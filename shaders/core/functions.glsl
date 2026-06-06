// NightBlight Core Functions
// Utility functions for math, color, and sampling

#ifndef NIGHTBLIGHT_FUNCTIONS
#define NIGHTBLIGHT_FUNCTIONS

#include "common.glsl"

// ============================================
// MATH FUNCTIONS
// ============================================

// Smooth minimum (polynomial smooth step)
float smin(float a, float b, float k) {
    float h = max(k - abs(a - b), 0.0) / k;
    return min(a, b) - h * h * h * k / 6.0;
}

// Smooth maximum
float smax(float a, float b, float k) {
    float h = max(k - abs(a - b), 0.0) / k;
    return max(a, b) + h * h * h * k / 6.0;
}

// Remap range
float remap(float value, float oldMin, float oldMax, float newMin, float newMax) {
    float normalized = (value - oldMin) / (oldMax - oldMin);
    return mix(newMin, newMax, normalized);
}

// Fast inverse square root (Quake III)
float fastInvSqrt(float x) {
    return inversesqrt(x);
}

// ============================================
// COLOR FUNCTIONS
// ============================================

// Convert RGB to luminance
float getLuminance(vec3 color) {
    return dot(color, vec3(0.299, 0.587, 0.114));
}

// Convert to grayscale
vec3 toGrayscale(vec3 color) {
    float gray = getLuminance(color);
    return vec3(gray);
}

// Adjust saturation
vec3 adjustSaturation(vec3 color, float saturation) {
    vec3 gray = toGrayscale(color);
    return mix(gray, color, saturation);
}

// Linear to sRGB
vec3 linearToSRGB(vec3 color) {
    return mix(
        pow(color, vec3(1.0 / 2.4)) * 1.055 - 0.055,
        color * 12.92,
        lessThan(color, vec3(0.0031308))
    );
}

// sRGB to Linear
vec3 sRGBToLinear(vec3 color) {
    return mix(
        pow((color + 0.055) / 1.055, vec3(2.4)),
        color / 12.92,
        lessThan(color, vec3(0.04045))
    );
}

// Tone mapping - Reinhard
vec3 tonemapReinhard(vec3 color) {
    return color / (color + vec3(1.0));
}

// Tone mapping - Uncharted 2
vec3 tonemapUncharted2(vec3 color) {
    float A = 0.15;
    float B = 0.50;
    float C = 0.10;
    float D = 0.20;
    float E = 0.02;
    float F = 0.30;
    float W = 11.2;
    
    return ((color * (A * color + C * B) + D * E) / (color * (A * color + B) + D * F)) - E / F;
}

// ============================================
// NORMAL MAP FUNCTIONS
// ============================================

// Decode normal from RG channels (octahedron encoding)
vec3 decodeNormal(vec2 enc) {
    vec2 fenc = enc * 4.0 - 2.0;
    float f = dot(fenc, fenc);
    float g = sqrt(1.0 - f / 4.0);
    vec3 n;
    n.xy = fenc * g;
    n.z = 1.0 - f / 2.0;
    return normalize(n);
}

// Encode normal to RG channels
vec2 encodeNormal(vec3 n) {
    float p = sqrt(n.z * 8.0 + 8.0);
    return clamp(n.xy / p + 0.5, 0.0, 1.0);
}

// Decode normal from RGB (Signed RG8)
vec3 decodeNormalSigned(vec3 color) {
    vec3 n = color * 2.0 - 1.0;
    return normalize(n);
}

// ============================================
// SHADOW SAMPLING
// ============================================

// PCF shadow sampling (Low quality - 1 tap)
float sampleShadow1(sampler2DShadow shadowMap, vec3 shadowCoord) {
    return texture(shadowMap, shadowCoord);
}

// PCF shadow sampling (Medium quality - 4 taps)
float sampleShadow4(sampler2DShadow shadowMap, vec3 shadowCoord, vec2 pixelSize) {
    float shadow = 0.0;
    float range = 1.0;
    
    for (int x = -1; x <= 1; x += 2) {
        for (int y = -1; y <= 1; y += 2) {
            shadow += texture(shadowMap, shadowCoord + vec3(vec2(x, y) * pixelSize * range, 0.0));
        }
    }
    
    return shadow / 4.0;
}

// PCF shadow sampling (High quality - 9 taps)
float sampleShadow9(sampler2DShadow shadowMap, vec3 shadowCoord, vec2 pixelSize) {
    float shadow = 0.0;
    float range = 1.0;
    
    for (int x = -1; x <= 1; x++) {
        for (int y = -1; y <= 1; y++) {
            shadow += texture(shadowMap, shadowCoord + vec3(vec2(x, y) * pixelSize * range, 0.0));
        }
    }
    
    return shadow / 9.0;
}

// ============================================
// NOISE FUNCTIONS
// ============================================

// Hash function for pseudo-random numbers
float hash(float n) {
    return fract(sin(n) * 43758.5453);
}

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

float hash(vec3 p) {
    return fract(sin(dot(p, vec3(12.9898, 78.233, 45.164))) * 43758.5453);
}

// Perlin-like noise
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f); // smoothstep
    
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    
    float ab = mix(a, b, f.x);
    float cd = mix(c, d, f.x);
    return mix(ab, cd, f.y);
}

// Fractional Brownian Motion
float fbm(vec2 p, int octaves) {
    float value = 0.0;
    float amplitude = 0.5;
    float frequency = 1.0;
    float maxValue = 0.0;
    
    for (int i = 0; i < octaves; i++) {
        value += amplitude * noise(p * frequency);
        maxValue += amplitude;
        amplitude *= 0.5;
        frequency *= 2.0;
    }
    
    return value / maxValue;
}

// ============================================
// FRESNEL
// ============================================

// Schlick's Fresnel approximation
float fresnel(float NdotV, float F0) {
    return F0 + (1.0 - F0) * pow(1.0 - NdotV, 5.0);
}

vec3 fresnelVec(float NdotV, vec3 F0) {
    return F0 + (1.0 - F0) * pow(1.0 - NdotV, 5.0);
}

// ============================================
// PARALLAX MAPPING
// ============================================

// Parallax mapping with heightmap
vec2 parallaxMapping(sampler2D heightMap, vec2 texCoords, vec3 viewDir, float heightScale) {
    float height = texture(heightMap, texCoords).r;
    vec2 p = viewDir.xy / viewDir.z * (height * heightScale);
    return texCoords - p;
}

// Steep parallax mapping (more samples, better quality)
vec2 steepParallaxMapping(sampler2D heightMap, vec2 texCoords, vec3 viewDir, float heightScale) {
    const float minLayers = 8.0;
    const float maxLayers = 32.0;
    float numLayers = mix(maxLayers, minLayers, abs(dot(vec3(0.0, 0.0, 1.0), viewDir)));
    
    float layerHeight = 1.0 / numLayers;
    float currentLayerHeight = 0.0;
    vec2 dtex = viewDir.xy / viewDir.z * heightScale / numLayers;
    vec2 currentTexCoords = texCoords;
    
    float heightFromTexture = texture(heightMap, currentTexCoords).r;
    
    for(int i = 0; i < 32; i++) {
        currentLayerHeight += layerHeight;
        if(currentLayerHeight > heightFromTexture) break;
        
        currentTexCoords -= dtex;
        heightFromTexture = texture(heightMap, currentTexCoords).r;
    }
    
    return currentTexCoords;
}

// ============================================
// UTILITY
// ============================================

// Get view space normal from depth (for screen-space effects)
vec3 getViewNormalFromDepth(sampler2D depthTex, vec2 uv, float fov) {
    vec2 offset = vec2(1.0) / vec2(viewWidth, viewHeight);
    
    float depth = texture(depthTex, uv).r;
    float depthN = texture(depthTex, uv + vec2(0.0, offset.y)).r;
    float depthE = texture(depthTex, uv + vec2(offset.x, 0.0)).r;
    
    vec3 pos = vec3(uv, depth);
    vec3 posN = vec3(uv + vec2(0.0, offset.y), depthN);
    vec3 posE = vec3(uv + vec2(offset.x, 0.0), depthE);
    
    vec3 tangent = normalize(posE - pos);
    vec3 bitangent = normalize(posN - pos);
    
    return cross(tangent, bitangent);
}

// Fast depth comparison
bool isInFront(float depth1, float depth2) {
    return depth1 < depth2;
}

#endif
