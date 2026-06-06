#version 150

uniform float worldTime;

in vec3 rayDir;
in vec2 texCoord;

out vec4 outColor;

const float PI = 3.14159265359;
const float TWO_PI = 6.28318530718;

float hash(vec3 p) {
    return fract(sin(dot(p, vec3(12.9898, 78.233, 45.164))) * 43758.5453);
}

void main() {
    float time = mod(worldTime / 24000.0, 1.0);
    vec3 color;
    
    if (rayDir.y > 0.0) {
        // Above horizon
        if (time < 0.5) {
            // Day
            vec3 skyBlue = vec3(0.5, 0.7, 1.0);
            vec3 horizon = vec3(1.0, 0.7, 0.5);
            color = mix(horizon, skyBlue, rayDir.y);
        } else {
            // Night
            color = vec3(0.01, 0.01, 0.03);
            
            // Stars
            float star = hash(rayDir * 1000.0);
            if (star > 0.99) {
                float brightness = (star - 0.99) * 100.0;
                color += vec3(brightness);
            }
        }
    } else {
        // Below horizon
        color = vec3(0.0);
    }
    
    outColor = vec4(color, 1.0);
}
