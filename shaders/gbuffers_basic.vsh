#version 150

// NightBlight - Basic Vertex Shader
// Handles simple geometry (items, armor stands)

out vec2 texCoord;
out vec3 normal;
out vec4 color;

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
    
    vec3 worldPos = (gbufferModelMatrix * vec4(vaPosition, 1.0)).xyz;
    gl_Position = gbufferProjectionMatrix * (gbufferViewMatrix * vec4(worldPos, 1.0));
}
