#version 150
#extension GL_ARB_explicit_attrib_location : enable

// NightBlight - Sky Fragment Shader
// Sky dome with sun, moon, and stars

uniform float worldTime;
uniform float starIntensity;
uniform float moonBrightness;

in vec3 rayDir;
in vec2 texCoord;

layout(location = 0) out vec4 colortex0;

const float PI = 3.14159265359;
const float TWO_PI = 6.28318530718;

float hash(vec3 p) {
    return fract(sin(dot(p, vec3(12.9898, 78.233, 45.164))) * 43758.5453);
}

float getTimeOfDay() {
    return mod(worldTime / 24000.0, 1.0);
}

vec3 getSkyColor(vec3 rayDir, float time) {
    float sunAngle = (time - 0.25) * TWO_PI;
    vec3 sunDir = normalize(vec3(sin(sunAngle), cos(sunAngle), 0.0));
    
    float upness = rayDir.y;
    
    if (time < 0.5) {
        // Daytime
        float sunHeight = cos(sunAngle);
        if (sunHeight < 0.0) {
            return mix(vec3(0.01, 0.01, 0.02), vec3(1.0, 0.6, 0.3), sunHeight + 0.3);
        }
        vec3 zeniths = vec3(0.4, 0.65, 1.0);
        vec3 horizons = vec3(1.0, 0.7, 0.5);
        return mix(horizons, zeniths, upness * 0.5 + 0.5);
    } else {
        // Nighttime
        return vec3(0.01, 0.01, 0.02);
    }
}

float renderSun(vec3 rayDir, float time) {
    float sunAngle = (time - 0.25) * TWO_PI;
    vec3 sunDir = normalize(vec3(sin(sunAngle), cos(sunAngle), 0.0));
    
    if (sunDir.y <= 0.0) return 0.0;
    
    float angle = acos(clamp(dot(rayDir, sunDir), -1.0, 1.0));
    float sunRadius = 0.008;
    
    if (angle < sunRadius) {
        return smoothstep(sunRadius, sunRadius - 0.001, angle);
    }
    return 0.0;
}

float renderMoon(vec3 rayDir, float time) {
    float sunAngle = (time - 0.25) * TWO_PI;
    vec3 moonDir = -normalize(vec3(sin(sunAngle), cos(sunAngle), 0.0));
    
    if (moonDir.y <= 0.0) return 0.0;
    
    float angle = acos(clamp(dot(rayDir, moonDir), -1.0, 1.0));
    float moonRadius = 0.008;
    
    if (angle < moonRadius) {
        return smoothstep(moonRadius, moonRadius - 0.001, angle);
    }
    return 0.0;
}

float generateStarfield(vec3 rayDir) {
    float time = getTimeOfDay();
    
    if (time < 0.5) return 0.0; // Day
    if (rayDir.y < 0.0) return 0.0; // Below horizon
    
    float star = hash(rayDir * 1000.0);
    
    if (star > 0.98) {
        float brightness = smoothstep(0.98, 1.0, star);
        float twinkle = sin(worldTime * 0.002 + star * 10.0) * 0.5 + 0.5;
        twinkle = smoothstep(0.4, 0.6, twinkle);
        return brightness * mix(0.5, 1.0, twinkle) * starIntensity;
    }
    
    return 0.0;
}

void main() {
    float time = getTimeOfDay();
    vec3 skyColor = getSkyColor(rayDir, time);
    
    // Add sun
    skyColor += vec3(1.0, 0.95, 0.8) * renderSun(rayDir, time) * 2.0;
    
    // Add moon
    skyColor += vec3(1.0, 1.0, 0.8) * renderMoon(rayDir, time) * 0.5;
    
    // Add stars
    skyColor += vec3(1.0, 1.0, 1.0) * generateStarfield(rayDir);
    
    colortex0 = vec4(skyColor, 1.0);
}
