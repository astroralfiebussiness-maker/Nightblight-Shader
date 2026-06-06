// NightBlight Moonlight Lighting Module
// Handles nighttime moonlight calculations and signature moon effects

#ifndef NIGHTBLIGHT_MOONLIGHT
#define NIGHTBLIGHT_MOONLIGHT

#include "../core/common.glsl"
#include "../core/functions.glsl"

// ============================================
// MOON CALCULATIONS
// ============================================

// Get moon phase (0-1, where 0 and 1 are full, 0.5 is new)
float getMoonPhase() {
    return mod(worldTime / 24000.0 * 0.5, 1.0);
}

// Calculate moonlight intensity
float getMoonIntensity(vec3 moonDir) {
    // Moon only visible above horizon
    if (moonDir.y <= 0.0) return 0.0;
    
    // Smooth falloff
    return smoothstep(0.0, 0.1, moonDir.y);
}

// Calculate moonlight color (blue-tinted)
vec3 getMoonColor() {
    // Cool blue/cyan color for moonlight
    return vec3(0.1, 0.2, 0.4) * 1.5; // Slightly boosted from constant
}

// Calculate direct moonlight contribution
vec3 calculateMoonlight(vec3 normal, vec3 moonDir, float shadow, float moonIntensity) {
    float NdotL = max(0.0, dot(normal, moonDir));
    vec3 moonColor = getMoonColor();
    
    // Moonlight is much dimmer than sunlight
    return moonColor * NdotL * shadow * moonIntensity * moonBrightness * 0.3;
}

// ============================================
// MOON RENDERING
// ============================================

// Render moon disk in sky
float renderMoonDisk(vec3 rayDir) {
    vec3 moonDir = getMoonDirection();
    
    if (moonDir.y <= 0.0) return 0.0;
    
    float angle = acos(dot(rayDir, moonDir));
    float moonRadius = 0.008; // Angular size
    
    if (angle < moonRadius) {
        // Hard edge for moon
        float phase = getMoonPhase();
        
        // Simple phase rendering (simplified)
        float edge = abs(angle - moonRadius);
        float softness = smoothstep(moonRadius, moonRadius - 0.001, angle);
        
        // Moon glow
        float glow = exp(-angle / moonRadius * 2.0) * 0.3;
        
        return softness + glow;
    }
    
    return 0.0;
}

// ============================================
// MOONVEIL EFFECT (Signature Feature)
// ============================================

// Moonveil: volumetric moon rays through forest canopy at night
vec3 calculateMoonveil(vec3 fragPos, vec3 moonDir, sampler2DShadow shadowMap) {
    if (!isNight() || moonveilStrength <= 0.0) return vec3(0.0);
    
    if (performancePreset == 0) return vec3(0.0); // Disabled on Low
    
    vec3 rayDir = normalize(fragPos - cameraPosition);
    float moonToRay = dot(rayDir, moonDir);
    
    // Only visible when looking roughly toward moon
    if (moonToRay < 0.1) return vec3(0.0);
    
    vec3 result = vec3(0.0);
    int steps = performancePreset == 1 ? 6 : performancePreset == 2 ? 12 : 20;
    float stepSize = 0.15;
    
    vec3 currentPos = cameraPosition;
    vec3 step = rayDir * stepSize;
    
    for (int i = 0; i < steps; i++) {
        currentPos += step;
        
        // Sample shadow for moon
        vec4 moonShadow = shadowProjectionMatrix * (shadowViewMatrix * vec4(currentPos, 1.0));
        moonShadow.xyz /= moonShadow.w;
        moonShadow.xyz = moonShadow.xyz * 0.5 + 0.5;
        
        if (moonShadow.z > 0.0 && moonShadow.z < 1.0) {
            // Sample shadow - looking for gaps in trees
            float shadow = texture(shadowMap, moonShadow.xyz);
            float dist = length(currentPos - cameraPosition);
            float falloff = exp(-dist * 0.01); // Longer range than sun rays
            
            // Only accumulate where there are shadows (tree canopy)
            result += (1.0 - shadow) * shadow * falloff / float(steps);
        }
    }
    
    vec3 moonColor = getMoonColor();
    return result * moonColor * moonveilStrength * 0.8;
}

// ============================================
// STARLIGHT REFLECTIONS (Signature Feature)
// ============================================

// Calculate starlight contribution to water reflections
vec3 calculateStarlightReflections(vec3 normal, vec3 starfield, float waterMask) {
    if (!isNight() || waterMask <= 0.0) return vec3(0.0);
    
    // Fresnel effect - stars reflect more on shallow angles
    float fresnel = pow(1.0 - abs(dot(normal, vec3(0.0, 1.0, 0.0))), 2.0);
    
    return starfield * fresnel * starIntensity * 0.5 * waterMask;
}

// ============================================
// NIGHT PULSE EFFECT (Signature Feature)
// ============================================

// Night Pulse: subtle animated glow in magical biomes
float calculateNightPulse(vec3 fragPos, bool isMagicalBiome) {
    if (!isNight() || !isMagicalBiome) return 0.0;
    
    // Gentle pulsing animation
    float pulse = sin(frameTimeCounter * 0.5) * 0.5 + 0.5;
    pulse = smoothstep(0.3, 0.7, pulse);
    
    // Falloff with distance
    float dist = length(fragPos - cameraPosition);
    float falloff = exp(-dist * 0.01);
    
    return pulse * falloff * 0.1;
}

// ============================================
// STARFIELD GENERATION
// ============================================

// Generate starfield for night sky
float generateStarfield(vec3 rayDir) {
    if (!isNight()) return 0.0;
    
    // Only in upper hemisphere
    if (rayDir.y < 0.0) return 0.0;
    
    // Hash-based star distribution
    float star = hash(rayDir * 1000.0);
    
    // Make stars sparse and bright
    if (star > 0.995) {
        // This is a star location
        float brightness = smoothstep(0.995, 1.0, star);
        
        // Add twinkling
        float twinkle = sin(frameTimeCounter * 2.0 + star * 10.0) * 0.5 + 0.5;
        twinkle = smoothstep(0.4, 0.6, twinkle);
        
        return brightness * mix(0.5, 1.0, twinkle) * starIntensity;
    }
    
    return 0.0;
}

// Generate galaxy nebulae (optional, Ultra preset)
vec3 generateGalaxy(vec3 rayDir) {
    if (!isNight() || performancePreset < 3) return vec3(0.0); // Ultra only
    
    // Milky way-like band
    float band = abs(rayDir.y);
    if (band > 0.3) return vec3(0.0);
    
    vec2 coord = vec2(atan(rayDir.z, rayDir.x), rayDir.y);
    float galaxy = fbm(coord * 5.0, 4) * 0.3;
    
    // Subtle purple/blue nebula colors
    vec3 nebula = mix(
        vec3(0.2, 0.1, 0.3),
        vec3(0.1, 0.2, 0.4),
        galaxy
    );
    
    return nebula * galaxy * starIntensity * 0.3;
}

#endif
