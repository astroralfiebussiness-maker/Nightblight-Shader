#version 150

// NightBlight - Water Fragment Shader
// Water rendering with reflections and refraction

uniform sampler2D tex;
uniform sampler2D depthtex0;
uniform int performancePreset;
uniform float worldTime;

in vec2 texCoord;
in vec3 normal;
in vec4 color;
in vec3 fragPos;
in float waveHeight;

out vec4 outColor;

void main() {
    vec4 texColor = texture(tex, texCoord);
    vec3 waterColor = texColor.rgb;
    
    // Apply blue tint to water
    waterColor = mix(waterColor, vec3(0.0, 0.4, 0.8), 0.6);
    
    // Caustics pattern for underwater effect
    float caustic = sin(texCoord.x * 10.0 + worldTime * 0.001) * 
                   sin(texCoord.y * 10.0 + worldTime * 0.0015) * 0.3 + 0.7;
    
    waterColor *= caustic;
    
    // Fresnel effect for water
    vec3 viewDir = normalize(vec3(0.0, 1.0, 0.0));
    float fresnel = pow(1.0 - abs(dot(viewDir, normal)), 2.0);
    
    // Glow from water at night
    float time = mod(worldTime / 24000.0, 1.0);
    float nightGlow = 0.0;
    if (time > 0.5) {
        nightGlow = (time - 0.5) * 0.3;
    }
    
    waterColor += vec3(0.1, 0.2, 0.4) * nightGlow;
    
    outColor = vec4(waterColor, 0.8);
}
