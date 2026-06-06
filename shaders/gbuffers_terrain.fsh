#version 150

// NightBlight - Terrain Fragment Shader
// Main terrain rendering with lighting

uniform sampler2D tex;
uniform int performancePreset;
uniform float ambientStrength;
uniform float nightAmbientStrength;
uniform float sunBrightness;
uniform float moonBrightness;
uniform float worldTime;

in vec2 texCoord;
in vec3 normal;
in vec4 color;
in vec3 fragPos;
flat in int blockID;

out vec4 outColor;

// Simple day/night calculation
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

float getSunlight(vec3 sunDir) {
    float sunAngle = acos(sunDir.y) / 3.14159;
    if (sunAngle > 0.5) return 0.0; // Sun below horizon
    return smoothstep(0.5, 0.4, sunAngle);
}

void main() {
    vec4 texColor = texture(tex, texCoord);
    
    // Discard transparent pixels
    if (texColor.a < 0.5) discard;
    
    vec3 albedo = texColor.rgb * color.rgb;
    vec3 normalDir = normalize(normal);
    
    // Time calculations
    float time = getTimeOfDay();
    vec3 skyColor = getSkyColor(time);
    
    // Sun direction (simple approximation)
    float sunAngle = (time - 0.25) * 6.28318;
    vec3 sunDir = normalize(vec3(sin(sunAngle), cos(sunAngle), 0.0));
    vec3 moonDir = -sunDir;
    
    // Basic lighting
    float sunlight = max(0.0, dot(normalDir, sunDir)) * getSunlight(sunDir) * sunBrightness;
    float moonlight = max(0.0, dot(normalDir, moonDir)) * 0.3 * moonBrightness;
    
    // Ambient light
    float ambient = mix(ambientStrength, nightAmbientStrength, step(0.5, time));
    
    // Combine lighting
    vec3 litColor = albedo * (sunlight + moonlight + ambient);
    
    // Output to GBuffer
    // Color
    outColor = vec4(litColor, 1.0);
}
