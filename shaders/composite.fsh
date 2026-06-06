#version 150

// NightBlight - Composite Shader (Main Lighting Pass)
// Deferred lighting calculation

uniform sampler2D colortex0;   // Albedo
uniform sampler2D depthtex0;   // Depth
uniform int performancePreset;
uniform float worldTime;
uniform float ambientStrength;
uniform float nightAmbientStrength;
uniform float sunBrightness;
uniform float moonBrightness;

in vec2 texCoord;
out vec4 outColor;

const float PI = 3.14159265359;

float getTimeOfDay() {
    return mod(worldTime / 24000.0, 1.0);
}

vec3 getSkyColor(float time) {
    if (time < 0.25) {
        return mix(vec3(0.01, 0.01, 0.02), vec3(1.0, 0.6, 0.3), time / 0.25);
    } else if (time < 0.5) {
        return mix(vec3(1.0, 0.6, 0.3), vec3(0.4, 0.65, 1.0), (time - 0.25) / 0.25);
    } else if (time < 0.75) {
        return mix(vec3(0.4, 0.65, 1.0), vec3(1.0, 0.6, 0.3), (time - 0.5) / 0.25);
    } else {
        return mix(vec3(1.0, 0.6, 0.3), vec3(0.01, 0.01, 0.02), (time - 0.75) / 0.25);
    }
}

void main() {
    vec3 albedo = texture(colortex0, texCoord).rgb;
    float depth = texture(depthtex0, texCoord).r;
    
    if (depth >= 1.0) {
        // Sky
        float time = getTimeOfDay();
        outColor = vec4(getSkyColor(time), 1.0);
        return;
    }
    
    // Get time info
    float time = getTimeOfDay();
    vec3 skyColor = getSkyColor(time);
    
    // Sun and moon direction
    float sunAngle = (time - 0.25) * 2.0 * PI;
    vec3 sunDir = normalize(vec3(sin(sunAngle), cos(sunAngle), 0.0));
    vec3 moonDir = -sunDir;
    
    // Basic lighting
    float sunlight = max(0.0, sunDir.y) * sunBrightness * (1.0 - step(0.5, time));
    float moonlight = max(0.0, moonDir.y) * moonBrightness * step(0.5, time);
    
    // Ambient
    float ambient = mix(ambientStrength, nightAmbientStrength, step(0.5, time));
    
    // Combine
    vec3 litColor = albedo * (sunlight + moonlight + ambient);
    
    outColor = vec4(litColor, 1.0);
}
