#version 120
#extension GL_ARB_texture_rectangle : enable

// NightBlight - Fabric Water Vertex Shader

varying vec2 texCoord;
varying vec3 normal;
varying vec4 vertexColor;
varying float waterWave;

uniform float worldTime;

void main() {
    texCoord = gl_MultiTexCoord0.st;
    vertexColor = gl_Color;
    normal = normalize(gl_NormalMatrix * gl_Normal);
    
    vec3 worldPos = (gl_ModelViewMatrix * gl_Vertex).xyz;
    
    // Water wave animation
    float wave = sin(worldPos.x * 0.1 + worldTime * 0.001) * 0.02;
    wave += sin(worldPos.z * 0.1 + worldTime * 0.0015) * 0.02;
    waterWave = wave;
    
    gl_Position = gl_ProjectionMatrix * (gl_ModelViewMatrix * gl_Vertex + vec4(0.0, wave, 0.0, 0.0));
}
