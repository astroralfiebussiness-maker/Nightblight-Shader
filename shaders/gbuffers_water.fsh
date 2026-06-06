#version 120
#extension GL_ARB_texture_rectangle : enable

// NightBlight - Fabric Water Fragment Shader

varying vec2 texCoord;
varying vec3 normal;
varying vec4 vertexColor;
varying float waterWave;

uniform float worldTime;

void main() {
    vec3 waterColor = vec3(0.1, 0.4, 0.8);
    
    // Caustic effect
    float caustic = sin(texCoord.x * 10.0 + worldTime * 0.001) * 
                   sin(texCoord.y * 10.0 + worldTime * 0.0015) * 0.15 + 0.85;
    
    waterColor *= caustic;
    waterColor *= 0.7;
    
    gl_FragColor = vec4(waterColor, 0.8);
}
