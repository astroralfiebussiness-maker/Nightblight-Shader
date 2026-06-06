#version 150

// NightBlight - Sky Vertex Shader
// Sky dome rendering

out vec2 texCoord;
out vec3 rayDir;

uniform mat4 gbufferModelMatrix;
uniform mat4 gbufferViewMatrix;
uniform mat4 gbufferProjectionMatrix;

in vec3 vaPosition;
in vec2 vaUV0;
in vec3 vaNormal;

void main() {
    texCoord = vaUV0;
    
    vec3 worldPos = (gbufferModelMatrix * vec4(vaPosition, 1.0)).xyz;
    gl_Position = gbufferProjectionMatrix * (gbufferViewMatrix * vec4(worldPos, 1.0));
    
    // Calculate ray direction for sky
    rayDir = normalize(worldPos);
}
