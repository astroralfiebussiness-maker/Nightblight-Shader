#version 150
#extension GL_ARB_explicit_attrib_location : enable

// NightBlight - Composite Shader (Main Lighting Pass)

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;
uniform sampler2D depthtex0;
uniform int performancePreset;
uniform float worldTime;
uniform float ambientStrength;
uniform float nightAmbientStrength;
uniform float sunBrightness;
uniform float moonBrightness;

in vec2 texCoord;

layout(location = 0) out vec4 colortex0_out;
layout(location = 1) out vec4 colortex1_out;
layout(location = 2) out vec4 colortex2_out;

const float PI = 3.14159265359;
const float TWO_PI = 6.28318530718;

float getTimeOfDay() {
    return mod(worldTime / 24000.0, 1.0);
}

vec3 getSkyColor(float time) {
    float sunAngle = (time - 0.25) * TWO_PI;
    float sunHeight = cos(sunAngle);
    
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
    
    // Sky
    if (depth >= 0.999) {
        float time = getTimeOfDay();
        colortex0_out = vec4(getSkyColor(time), 1.0);
        colortex1_out = vec4(0.5, 0.5, 1.0, 1.0);
        colortex2_out = vec4(0.0, 0.0, 0.0, 1.0);
        return;
    }
    
    float time = getTimeOfDay();
    float sunAngle = (time - 0.25) * TWO_PI;
    vec3 sunDir = normalize(vec3(sin(sunAngle), cos(sunAngle), 0.0));
    vec3 moonDir = -sunDir;
    
    // Lighting
    float sunlight = max(0.0, sunDir.y) * sunBrightness;
    float moonlight = max(0.0, moonDir.y) * moonBrightness;
    
    if (time > 0.5) {
        sunlight = 0.0;
    } else {
        moonlight = 0.0;
    }
    
    float ambient = mix(ambientStrength, nightAmbientStrength, step(0.5, time));
    
    vec3 lit = albedo * (sunlight + moonlight + ambient);
    
    colortex0_out = vec4(lit, 1.0);
    colortex1_out = texture(colortex1, texCoord);
    colortex2_out = texture(colortex2, texCoord);
}
