// NightBlight Common Definitions
// Shared structures, uniforms, and macros

#ifndef NIGHTBLIGHT_COMMON
#define NIGHTBLIGHT_COMMON

#include "constants.glsl"

// ============================================
// UNIFORMS - Time and Weather
// ============================================
uniform float worldTime;        // 0-24000 ticks
uniform float rainStrength;     // 0-1 rain intensity
uniform float wetness;          // 0-1 surface wetness
uniform float thunderStrength;  // 0-1 lightning intensity

// ============================================
// UNIFORMS - Camera
// ============================================
uniform vec3 cameraPosition;        // Camera position in world space
uniform mat4 gbufferModelMatrix;    // Model to world
uniform mat4 gbufferViewMatrix;     // World to view
uniform mat4 gbufferProjectionMatrix; // View to screen
uniform mat4 gbufferPreviousModelMatrix;
uniform mat4 gbufferPreviousViewMatrix;
uniform mat4 gbufferPreviousProjectionMatrix;
uniform mat4 shadowModelMatrix;     // Shadow model matrix
uniform mat4 shadowViewMatrix;      // Shadow view matrix
uniform mat4 shadowProjectionMatrix; // Shadow projection

// ============================================
// UNIFORMS - Screen
// ============================================
uniform float viewWidth;
uniform float viewHeight;
uniform sampler2D depthtex0;        // Opaque depth
uniform sampler2D depthtex1;        // Transparent depth
uniform sampler2D colortex0;        // Albedo
uniform sampler2D colortex1;        // Normal/Specular
uniform sampler2D colortex2;        // Depth/AO/Emissive
uniform sampler2D colortex3;        // Light data
samplerShadow shadowtex0;           // Directional shadow map
samplerShadow shadowtex1;           // Secondary shadow map
uniform sampler2D shadowcolor0;     // Shadow color
uniform sampler2D shadowcolor1;     // Secondary shadow color

// ============================================
// UNIFORMS - Configuration
// ============================================
uniform int frameCounter;           // Frame number
uniform float frameTime;            // Time since last frame
uniform float frameTimeCounter;     // Total time

// Performance preset (0=Low, 1=Medium, 2=High, 3=Ultra)
uniform int performancePreset;

// Lighting settings
uniform float sunBrightness;
uniform float moonBrightness;
uniform float ambientStrength;
uniform float nightAmbientStrength;

// Effect settings
uniform float bloomStrength;
uniform float bloomThreshold;
uniform float saturation;

// Water settings
uniform float waveHeight;
uniform float causticIntensity;

// Night settings
uniform float starIntensity;
uniform float eyeAdaptSpeed;
uniform float moonveilStrength;

// ============================================
// STRUCTURES
// ============================================

struct Material {
    vec3 albedo;
    vec3 normal;
    float roughness;
    float metallic;
    float emissive;
};

struct Light {
    vec3 direction;
    vec3 color;
    float intensity;
};

struct Surface {
    vec3 position;
    vec3 normal;
    vec3 viewDir;
    float depth;
};

// ============================================
// MACROS
// ============================================

#define saturate(x) clamp(x, 0.0, 1.0)
#define linearstep(a, b, x) saturate((x - a) / (b - a))
#define when_gt(x, y) step(y, x)
#define when_eq(x, y) 1.0 - abs(sign(x - y))
#define when_lt(x, y) step(x, y)

// ============================================
// HELPERS
// ============================================

// Get time of day (0-1, where 0.5 = noon)
float getTimeOfDay() {
    return mod(worldTime / 24000.0, 1.0);
}

// Get sun position based on time
vec3 getSunDirection() {
    float time = getTimeOfDay();
    float angle = (time - 0.25) * TWO_PI;
    return vec3(sin(angle), cos(angle), 0.0);
}

// Get moon position (opposite sun)
vec3 getMoonDirection() {
    return -getSunDirection();
}

// Is it night time? (between 12500 and 23500 ticks)
bool isNight() {
    float time = getTimeOfDay();
    return time > 0.52 && time < 0.98;
}

// Is it day time?
bool isDay() {
    return !isNight();
}

// Get day/night transition factor (0 at day, 1 at night)
float getNightFactor() {
    float time = getTimeOfDay();
    float sunrise = 0.23;  // ~5:30 AM
    float sunset = 0.77;   // ~6:30 PM
    float night_start = 0.98;
    float night_end = 0.02;
    
    if (time < sunrise) {
        return linearstep(night_end, sunrise, time);
    } else if (time < sunset) {
        return 0.0;
    } else if (time < night_start) {
        return linearstep(sunset, night_start, time);
    } else {
        return 1.0;
    }
}

// Get twilight factor (0 at full day/night, 1 at transitions)
float getTwilightFactor() {
    return 1.0 - abs(getNightFactor() * 2.0 - 1.0);
}

#endif
