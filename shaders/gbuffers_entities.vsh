#version 150

// NightBlight - Entities Vertex Shader
// Handles mobs, entities, armor stands

out vec2 texCoord;
out vec3 normal;
out vec4 color;
out vec3 fragPos;

uniform mat4 gbufferModelMatrix;
uniform mat4 gbufferViewMatrix;
uniform mat4 gbufferProjectionMatrix;
uniform vec3 cameraPosition;

in vec3 vaPosition;
in vec2 vaUV0;
in vec3 vaNormal;
in vec4 vaColor;

void main() {
    texCoord = vaUV0;
    color = vaColor;
    normal = normalize((gbufferModelMatrix * vec4(vaNormal, 0.0)).xyz);
    
    vec3 worldPos = (gbufferModelMatrix * vec4(vaPosition, 1.0)).xyz;
    fragPos = worldPos;
    
    gl_Position = gbufferProjectionMatrix * (gbufferViewMatrix * vec4(worldPos, 1.0));
}
