// NightBlight Ambient Lighting Module
// Handles ambient light calculation and eye adaptation

#ifndef NIGHTBLIGHT_AMBIENT
#define NIGHTBLIGHT_AMBIENT

#include "../core/common.glsl"
#include "../core/functions.glsl"

// ============================================
// AMBIENT LIGHT CALCULATION
// ============================================

// Get ambient light based on sky color and time of day
vec3 calculateAmbient(vec3 normal, vec3 skyColor) {
    // Hemispherical lighting from sky
    float NdotUp = dot(normal, vec3(0.0, 1.0, 0.0)) * 0.5 + 0.5;
    
    // Sky color from above, ground color from below
    vec3 groundColor = vec3(0.2, 0.2, 0.2); // Dark gray ground
    vec3 ambient = mix(groundColor, skyColor, NdotUp);
    
    return ambient * ambientStrength;
}

// Get sky color based on time of day
vec3 getSkyColor() {
    float time = getTimeOfDay();
    float sunHeight = sin(time * PI);
    
    vec3 dayColor = vec3(0.4, 0.65, 1.0);
    vec3 sunsetColor = vec3(1.0, 0.6, 0.3);
    vec3 nightColor = vec3(0.01, 0.01, 0.02);
    
    if (time < 0.25) {
        // Night to sunrise
        return mix(nightColor, sunsetColor, (time - 0.0) / 0.25);
    } else if (time < 0.5) {
        // Sunrise to day
        return mix(sunsetColor, dayColor, (time - 0.25) / 0.25);
    } else if (time < 0.75) {
        // Day to sunset
        return mix(dayColor, sunsetColor, (time - 0.5) / 0.25);
    } else {
        // Sunset to night
        return mix(sunsetColor, nightColor, (time - 0.75) / 0.25);
    }
}

// Get night-specific ambient light
vec3 calculateNightAmbient(vec3 normal) {
    // Moonlight provides soft ambient at night
    vec3 moonDir = getMoonDirection();
    float moonUp = max(0.0, dot(normal, moonDir));
    
    // Very dim ambient in pure darkness
    vec3 ambient = vec3(0.01, 0.01, 0.02) * nightAmbientStrength;
    
    // Add subtle moonlight contribution to ambient
    ambient += vec3(0.1, 0.2, 0.4) * moonUp * 0.2;
    
    return ambient;
}

// ============================================
// EYE ADAPTATION (Dynamic Exposure)
// ============================================

// Storage for adaptation (would use persistent texture in real implementation)
layout(location = 0) uniform float previousAdaptation;

// Calculate luminance for exposure adjustment
float calculateSceneLuminance(vec3 color) {
    return getLuminance(color);
}

// Apply eye adaptation to adjust for bright/dark transitions
float getEyeAdaptation(float currentLuminance) {
    // Smooth transition between old and new adaptation
    float targetAdaptation = 1.0 / (currentLuminance + 0.001);
    
    // Clamp to reasonable range
    targetAdaptation = clamp(targetAdaptation, 0.1, 5.0);
    
    // Smooth lerp based on speed setting
    float factor = eyeAdaptSpeed * frameTime;
    float adaptation = mix(previousAdaptation, targetAdaptation, factor);
    
    return adaptation;
}

// Apply exposure compensation
vec3 applyExposure(vec3 color, float exposure) {
    return color * exposure;
}

// ============================================
// AMBIENT OCCLUSION
// ============================================

// Screen-space ambient occlusion (SSAO) - simplified
float calculateSSAO(vec2 uv, sampler2D normalTex, sampler2D depthTex, vec3 viewPos, vec3 normal) {
    if (performancePreset == 0) return 1.0; // Disabled on Low
    
    float ao = 0.0;
    int samples = performancePreset == 1 ? 4 : performancePreset == 2 ? 8 : 16;
    float radius = 0.02;
    
    for (int i = 0; i < samples; i++) {
        float angle = float(i) / float(samples) * TWO_PI;
        vec2 offset = vec2(cos(angle), sin(angle)) * radius;
        
        vec2 sampleUV = uv + offset;
        if (sampleUV.x < 0.0 || sampleUV.x > 1.0 || sampleUV.y < 0.0 || sampleUV.y > 1.0) continue;
        
        float sampleDepth = texture(depthTex, sampleUV).r;
        float centerDepth = texture(depthTex, uv).r;
        
        // If sample is in front, it contributes to occlusion
        if (sampleDepth < centerDepth) {
            ao += 1.0;
        }
    }
    
    ao /= float(samples);
    return 1.0 - ao * 0.5; // Reduce effect strength
}

// ============================================
// DAWN AWAKENING EFFECT (Signature Feature)
// ============================================

// Enhanced sunrise transition with gradual changes
vec3 calculateDawnAwakening(vec3 color) {
    float time = getTimeOfDay();
    float sunrise = 0.23;  // ~5:30 AM
    float sunrise_end = 0.27; // ~6:30 AM
    
    // Only during sunrise period
    if (time < sunrise || time > sunrise_end) return color;
    
    // Smooth transition factor during sunrise
    float awakeFactor = (time - sunrise) / (sunrise_end - sunrise);
    awakeFactor = smoothstep(0.0, 1.0, awakeFactor);
    
    // Gradually increase saturation and warmth
    vec3 warmed = adjustSaturation(color, mix(0.8, 1.2, awakeFactor));
    
    // Add warm color cast
    vec3 warmCast = vec3(1.0, 0.8, 0.5) * awakeFactor * 0.1;
    warmed += warmCast;
    
    return warmed;
}

// ============================================
// TWILIGHT BLOOM (Signature Feature)
// ============================================

// Enhanced bloom during sunset/sunrise
float getTwilightBloom() {
    float time = getTimeOfDay();
    
    // Twilight periods
    float sunrise = 0.23;
    float sunset = 0.77;
    float duration = 0.05;
    
    float bloomFactor = 0.0;
    
    // Sunrise bloom
    if (time > sunrise - duration && time < sunrise + duration) {
        bloomFactor = 1.0 - abs((time - sunrise) / duration);
    }
    
    // Sunset bloom
    if (time > sunset - duration && time < sunset + duration) {
        bloomFactor = 1.0 - abs((time - sunset) / duration);
    }
    
    return smoothstep(0.0, 1.0, bloomFactor) * 0.3; // Boost bloom strength
}

#endif
