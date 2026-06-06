// NightBlight Emissive Lighting Module
// Handles block emission and glow from light sources

#ifndef NIGHTBLIGHT_EMISSIVE
#define NIGHTBLIGHT_EMISSIVE

#include "../core/common.glsl"
#include "../core/functions.glsl"

// ============================================
// EMISSIVE BLOCK DETECTION
// ============================================

// Detect if block is emissive based on texture color
bool isEmissiveBlock(vec3 albedo) {
    // High intensity color likely emissive
    float brightness = getLuminance(albedo);
    return brightness > EMISSIVE_THRESHOLD;
}

// Get emission strength from albedo
float getEmissionStrength(vec3 albedo) {
    float brightness = getLuminance(albedo);
    if (!isEmissiveBlock(albedo)) return 0.0;
    
    // Scale from threshold to 1.0
    return (brightness - EMISSIVE_THRESHOLD) / (1.0 - EMISSIVE_THRESHOLD);
}

// ============================================
// KNOWN EMISSIVE BLOCKS
// ============================================

// Check if block is a known emissive block
// These are blocks like glowstone, sea lanterns, etc.
struct EmissiveBlockData {
    vec3 color;
    float intensity;
};

// Get emission data for known blocks
EmissiveBlockData getKnownEmissiveBlockData(vec3 albedo) {
    EmissiveBlockData data;
    data.intensity = 0.0;
    data.color = albedo;
    
    // Glowstone - warm yellow
    if (distance(albedo, vec3(1.0, 0.8, 0.3)) < 0.1) {
        data.color = vec3(1.0, 0.8, 0.3);
        data.intensity = 1.0;
    }
    // Sea Lantern - cyan/blue
    else if (distance(albedo, vec3(0.0, 1.0, 1.0)) < 0.15) {
        data.color = vec3(0.0, 0.8, 1.0);
        data.intensity = 0.9;
    }
    // Lantern - orange
    else if (distance(albedo, vec3(1.0, 0.6, 0.0)) < 0.1) {
        data.color = vec3(1.0, 0.7, 0.2);
        data.intensity = 0.8;
    }
    // Torch - red-orange
    else if (distance(albedo, vec3(1.0, 0.4, 0.0)) < 0.15) {
        data.color = vec3(1.0, 0.5, 0.1);
        data.intensity = 0.7;
    }
    // Redstone Lamp - red
    else if (distance(albedo, vec3(1.0, 0.2, 0.0)) < 0.1) {
        data.color = vec3(1.0, 0.3, 0.1);
        data.intensity = 0.8;
    }
    // Amethyst - purple
    else if (distance(albedo, vec3(0.6, 0.3, 1.0)) < 0.15) {
        data.color = vec3(0.7, 0.4, 1.0);
        data.intensity = 0.6;
    }
    
    return data;
}

// ============================================
// EMISSIVE CONTRIBUTION
// ============================================

// Calculate contribution from emissive blocks
vec3 calculateEmissive(vec3 albedo, vec3 normal, vec3 fragPos) {
    if (!isEmissiveBlock(albedo)) return vec3(0.0);
    
    EmissiveBlockData data = getKnownEmissiveBlockData(albedo);
    
    if (data.intensity <= 0.0) {
        // Fallback for unknown emissive blocks
        data.color = albedo;
        data.intensity = getEmissionStrength(albedo);
    }
    
    // Emissive contribution is direct and not affected by lighting
    return data.color * data.intensity;
}

// ============================================
// GLOW/BLOOM EXTRACTION
// ============================================

// Determine if pixel should contribute to bloom
bool shouldContributeToBLoom(vec3 color, float bloomThreshold) {
    float luminance = getLuminance(color);
    return luminance > bloomThreshold;
}

// Get bloom contribution
vec3 getBloomContribution(vec3 color, float bloomThreshold, float bloomStrength) {
    float luminance = getLuminance(color);
    
    if (luminance <= bloomThreshold) return vec3(0.0);
    
    // Scale brightness above threshold
    float excessBrightness = luminance - bloomThreshold;
    float scaledBrightness = excessBrightness / (1.0 - bloomThreshold);
    
    return color * scaledBrightness * bloomStrength;
}

// ============================================
// LIGHT SOURCE GLOW
// ============================================

// Calculate falloff glow from light sources
vec3 calculateLightGlow(vec3 fragPos, vec3 emissiveColor, float emissiveIntensity) {
    // Glow decreases with distance
    float dist = length(fragPos - cameraPosition);
    
    // Maximum glow distance
    float maxGlowDist = 20.0;
    if (dist > maxGlowDist) return vec3(0.0);
    
    // Exponential falloff
    float falloff = exp(-dist / 4.0);
    
    // Quality scales with performance preset
    float glowIntensity = emissiveIntensity * falloff;
    
    if (performancePreset == 0) {
        glowIntensity *= 0.5; // Reduced on Low preset
    }
    
    return emissiveColor * glowIntensity * 0.3;
}

// ============================================
// DYNAMIC LIGHT INTEGRATION
// ============================================

// Add contribution from nearby emissive blocks to lighting
vec3 getDynamicLightContribution(vec3 fragPos, vec3 normal, sampler2D colortex0) {
    // Sample nearby pixels for emissive blocks
    // This is a simplified version - would need proper light probe data
    
    vec3 contribution = vec3(0.0);
    
    // Check nearby screen space
    vec2 pixelSize = 1.0 / vec2(viewWidth, viewHeight);
    vec3 fragPosView = (gbufferViewMatrix * vec4(fragPos, 1.0)).xyz;
    
    // Sample a few nearby pixels
    int samples = 4;
    for (int i = 0; i < samples; i++) {
        float angle = float(i) / float(samples) * TWO_PI;
        vec2 offset = vec2(cos(angle), sin(angle)) * pixelSize * 10.0;
        
        vec3 sampledColor = texture(colortex0, gl_FragCoord.xy * pixelSize + offset).rgb;
        
        if (isEmissiveBlock(sampledColor)) {
            contribution += sampledColor * 0.1;
        }
    }
    
    return contribution / float(samples);
}

#endif
