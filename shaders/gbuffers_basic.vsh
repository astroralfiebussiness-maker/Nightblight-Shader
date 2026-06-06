#version 150
#extension GL_EXT_gpu_shader4 : enable

// NightBlight - Basic Vertex Shader

out vec2 texCoord;
out vec3 normal;
out vec4 color;
out vec3 viewNormal;

uniform mat4 gbufferModelMatrix;
uniform mat4 gbufferViewMatrix;
uniform mat4 gbufferProjectionMatrix;

in vec3 vaPosition;
in vec2 vaUV0;
in vec3 vaNormal;
in vec4 vaColor;

void main() {
    texCoord = vaUV0;
    color = vaColor;
    normal = normalize((gbufferModelMatrix * vec4(vaNormal, 0.0)).xyz);
    viewNormal = normalize((gbufferViewMatrix * vec4(normal, 0.0)).xyz);
    
    vec3 worldPos = (gbufferModelMatrix * vec4(vaPosition, 1.0)).xyz;
    gl_Position = gbufferProjectionMatrix * (gbufferViewMatrix * vec4(worldPos, 1.0));
}
