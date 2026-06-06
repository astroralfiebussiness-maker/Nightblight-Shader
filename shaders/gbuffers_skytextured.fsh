#version 120
#extension GL_ARB_texture_rectangle : enable

// NightBlight - Fabric Sky Fragment Shader

varying vec3 rayDir;
varying vec2 texCoord;

uniform float worldTime;
uniform float starIntensity;

const float PI = 3.14159265359;

float hash(vec3 p) {
    return fract(sin(dot(p, vec3(12.9898, 78.233, 45.164))) * 43758.5453);
}

void main() {
    float time = mod(worldTime / 24000.0, 1.0);
    vec3 color;
    
    bool isDay = time < 0.5;
    
    if (rayDir.y > 0.0) {
        if (isDay) {
            vec3 skyBlue = vec3(0.5, 0.7, 1.0);
            vec3 horizon = vec3(1.0, 0.7, 0.5);
            float upness = clamp(rayDir.y, 0.0, 1.0);
            color = mix(horizon, skyBlue, upness);
        } else {
            color = vec3(0.01, 0.01, 0.03);
            
            float star = hash(rayDir * 1000.0);
            if (star > 0.98) {
                float brightness = (star - 0.98) * 50.0;
                color += vec3(brightness) * starIntensity;
            }
        }
    } else {
        color = vec3(0.0);
    }
    
    gl_FragColor = vec4(color, 1.0);
}
