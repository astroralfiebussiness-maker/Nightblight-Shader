#version 150
#extension GL_ARB_explicit_attrib_location : enable

// NightBlight - Water Fragment Shader
// Water rendering with reflections and refraction

uniform sampler2D tex;
uniform int performancePreset;
uniform float worldTime;

in vec2 texCoord;
in vec3 normal;
in vec4 color;
in vec3 fragPos;
in float waveHeight;
in vec3 viewNormal;

layout(location = 0) out vec4 colortex0;
layout(location = 1) out vec4 colortex1;
layout(location = 2) out vec4 colortex2;

vec2 encodeNormal(vec3 n) {
    n = normalize(n) * 0.5 + 0.5;
    return n.xy;
}

void main() {
    vec4 texColor = texture(tex, texCoord);
    vec3 waterColor = texColor.rgb;
    
    // Apply blue tint to water
    waterColor = mix(waterColor, vec3(0.0, 0.4, 0.8), 0.6);
    
    // Caustics
    float caustic = sin(texCoord.x * 10.0 + worldTime * 0.001) * 
                   sin(texCoord.y * 10.0 + worldTime * 0.0015) * 0.3 + 0.7;
    waterColor *= caustic;
    
    // GBuffer output
    colortex0 = vec4(waterColor, 1.0);
    colortex1 = vec4(encodeNormal(normal), 0.5, 0.5); // Lower specularity
    colortex2 = vec4(vec3(0.0), 0.8);
}
