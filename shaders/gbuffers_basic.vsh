#version 120
#extension GL_ARB_texture_rectangle : enable

// NightBlight - Fabric Basic Vertex Shader

varying vec2 texCoord;
varying vec3 normal;
varying vec4 vertexColor;

void main() {
    texCoord = gl_MultiTexCoord0.st;
    vertexColor = gl_Color;
    normal = normalize(gl_NormalMatrix * gl_Normal);
    
    gl_Position = gl_ProjectionMatrix * gl_ModelViewMatrix * gl_Vertex;
}
