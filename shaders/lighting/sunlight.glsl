// NightBlight Sunlight Lighting Module
// Handles direct sunlight calculations and effects

#ifndef NIGHTBLIGHT_SUNLIGHT
#define NIGHTBLIGHT_SUNLIGHT

#include "../core/common.glsl"
#include "../core/functions.glsl"

// ============================================
// SUNLIGHT CALCULATION
// ============================================

// Calculate sunlight color based on sun angle
vec3 getSunColor(float sunAngle) {
    // At noon (0.5), full white
    // At sunrise/sunset, warmer orange/red
    // At night, nearly black
    
    float dayNight = cos(sunAngle * PI);
    dayNight = max(0.0, dayNight);
    
    vec3 noon = vec3(1.0, 0.95, 0.8);
    vec3 sunset = vec3(1.0, 0.6, 0.3);
    vec3 night = vec3(0.0, 0.0, 0.0);
    
    if (dayNight > 0.5) {
        return mix(sunset, noon, (dayNight - 0.5) * 2.0);
    } else {
        return mix(night, sunset, dayNight * 2.0);
    }
}

// Get sun intensity based on time of day
float getSunIntensity(vec3 sunDir) {
    // Sun is invisible below horizon
    if (sunDir.y <= 0.0) return 0.0;
    
    // Smooth falloff near horizon
    return smoothstep(0.0, 0.1, sunDir.y);
}

// Calculate direct sunlight contribution
vec3 calculateSunlight(vec3 normal, vec3 sunDir, float shadow, float sunIntensity) {
    float NdotL = max(0.0, dot(normal, sunDir));
    vec3 sunColor = getSunColor(0.5); // Simplified for now
    
    return sunColor * NdotL * shadow * sunIntensity * sunBrightness;
}

// ============================================
// SHADOW CALCULATION
// ============================================

// Sample shadow map with quality based on performance preset
float sampleSunShadow(vec3 shadowCoord, sampler2DShadow shadowMap) {
    vec2 pixelSize = 1.0 / vec2(2048.0); // Shadow map resolution
    
    if (performancePreset == 0) {
        // Low: 1 tap
        return texture(shadowMap, shadowCoord);
    } else if (performancePreset == 1) {
        // Medium: 4 taps
        return sampleShadow4(shadowMap, shadowCoord, pixelSize);
    } else if (performancePreset == 2) {
        // High: 9 taps
        return sampleShadow9(shadowMap, shadowCoord, pixelSize);
    } else {
        // Ultra: 16 taps (custom implementation)
        float shadow = 0.0;
        float range = 1.5;
        
        for (int x = -2; x <= 2; x++) {
            for (int y = -2; y <= 2; y++) {
                shadow += texture(shadowMap, shadowCoord + vec3(vec2(x, y) * pixelSize * range, 0.0));
            }
        }
        
        return shadow / 25.0;
    }
}

// ============================================
// VOLUMETRIC SUNLIGHT (GOD RAYS)
// ============================================

// Calculate volumetric light rays from sun
vec3 calculateGodRays(vec3 fragPos, vec3 sunDir, float sunIntensity, sampler2DShadow shadowMap) {
    if (performancePreset == 0) return vec3(0.0); // Disabled on Low
    
    vec3 rayDir = normalize(fragPos - cameraPosition);
    vec3 sunToCamera = normalize(-rayDir);
    
    // Check if sun is roughly in view
    if (dot(sunToCamera, sunDir) < 0.3) return vec3(0.0);
    
    vec3 result = vec3(0.0);
    int steps = performancePreset == 1 ? 8 : performancePreset == 2 ? 16 : 32;
    float stepSize = 0.1;
    
    vec3 currentPos = cameraPosition;
    vec3 step = rayDir * stepSize;
    
    for (int i = 0; i < steps; i++) {
        currentPos += step;
        
        // Transform to shadow space and sample
        vec4 shadowPos = shadowProjectionMatrix * (shadowViewMatrix * vec4(currentPos, 1.0));
        shadowPos.xyz /= shadowPos.w;
        shadowPos.xyz = shadowPos.xyz * 0.5 + 0.5;
        
        if (shadowPos.z > 0.0 && shadowPos.z < 1.0) {
            float shadow = sampleSunShadow(shadowPos.xyz, shadowMap);
            float dist = length(currentPos - cameraPosition);
            float falloff = exp(-dist * 0.02);
            
            result += shadow * falloff / float(steps);
        }
    }
    
    return result * getSunColor(0.5) * sunIntensity * 0.5;
}

// ============================================
// CONTACT SHADOWS
// ============================================

// Calculate contact shadows (small-scale shadows from nearby geometry)
float calculateContactShadows(vec3 fragPos, vec3 normal, vec3 sunDir, sampler2D depthTex) {
    if (performancePreset == 0) return 1.0; // Disabled on Low
    
    int steps = performancePreset == 1 ? 4 : 8;
    float stride = 0.1;
    float shadow = 1.0;
    
    for (int i = 1; i <= steps; i++) {
        vec3 rayPos = fragPos + normal * float(i) * stride;
        vec4 projPos = gbufferProjectionMatrix * (gbufferViewMatrix * vec4(rayPos, 1.0));
        vec2 screenUV = projPos.xy / projPos.w * 0.5 + 0.5;
        
        if (screenUV.x >= 0.0 && screenUV.x <= 1.0 && screenUV.y >= 0.0 && screenUV.y <= 1.0) {
            float sampledDepth = texture(depthTex, screenUV).r;
            float rayDepth = projPos.z / projPos.w;
            
            if (sampledDepth < rayDepth) {
                shadow *= 0.5;
            }
        }
    }
    
    return shadow;
}

#endif
