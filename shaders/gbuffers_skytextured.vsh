#version 120
#extension GL_ARB_texture_rectangle : enable

// NightBlight - Fabric Sky Vertex Shader

varying vec3 rayDir;
varying vec2 texCoord;

void main() {
    texCoord = gl_MultiTexCoord0.st;
    rayDir = normalize((gl_ModelViewMatrix * gl_Vertex).xyz);
    gl_Position = gl_ProjectionMatrix * gl_ModelViewMatrix * gl_Vertex;
}
