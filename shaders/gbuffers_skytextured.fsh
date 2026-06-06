#version 150

in VS_OUT {
    vec3 rayDir;
    vec2 texCoord;
} fs_in;

uniform float worldTime;

out vec4 outColor;

const float PI = 3.14159265359;

float hash(vec3 p) {
    return fract(sin(dot(p, vec3(12.9898, 78.233, 45.164))) * 43758.5453);
}

void main() {
    float time = mod(worldTime / 24000.0, 1.0);
    vec3 color;
    
    // Determine if day or night
    bool isDay = time < 0.5;
    
    if (fs_in.rayDir.y > 0.0) {
        // Above horizon
        if (isDay) {
            // Daytime sky - blue
            vec3 skyBlue = vec3(0.5, 0.7, 1.0);
            vec3 horizon = vec3(1.0, 0.7, 0.5);
            float upness = clamp(fs_in.rayDir.y, 0.0, 1.0);
            color = mix(horizon, skyBlue, upness);
        } else {
            // Nighttime sky - dark with stars
            color = vec3(0.01, 0.01, 0.03);
            
            // Add stars
            float star = hash(fs_in.rayDir * 1000.0);
            if (star > 0.98) {
                float brightness = (star - 0.98) * 50.0;
                color += vec3(brightness);
            }
        }
    } else {
        // Below horizon - black
        color = vec3(0.0);
    }
    
    outColor = vec4(color, 1.0);
}
