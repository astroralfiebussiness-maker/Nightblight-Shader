#version 120
#extension GL_ARB_texture_rectangle : enable

// NightBlight - Fabric Terrain Vertex Shader

varying vec2 texCoord;
varying vec3 normal;
varying vec4 vertexColor;
varying vec3 fragPos;
varying float material;

uniform mat4 gbufferModelMatrix;
uniform mat4 gbufferViewMatrix;
uniform mat4 gbufferProjectionMatrix;
uniform mat4 shadowModelMatrix;
uniform mat4 shadowViewMatrix;
uniform mat4 shadowProjectionMatrix;

void main() {
    texCoord = gl_MultiTexCoord0.st;
    vertexColor = gl_Color;
    normal = normalize(gl_NormalMatrix * gl_Normal);
    fragPos = (gbufferModelMatrix * gl_Vertex).xyz;
    material = 0.0;
    
    gl_Position = gl_ProjectionMatrix * gl_ModelViewMatrix * gl_Vertex;
}
