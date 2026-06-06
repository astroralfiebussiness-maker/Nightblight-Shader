#version 150

// NightBlight - Terrain Vertex Shader
// Handles terrain rendering with waving foliage animation

flat out int blockID;
out vec2 texCoord;
out vec3 normal;
out vec4 color;
out vec3 fragPos;

uniform mat4 gbufferModelMatrix;
uniform mat4 gbufferViewMatrix;
uniform mat4 gbufferProjectionMatrix;
uniform float worldTime;
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
    
    // Waving foliage animation for grass and leaves
    float wave = sin(worldPos.x * 0.1 + worldPos.z * 0.1 + worldTime * 0.005) * 0.05;
    wave += sin(worldPos.x * 0.05 + worldPos.z * 0.05 + worldTime * 0.003) * 0.03;
    
    // Apply wave to Y position (vertical waving)
    worldPos.y += wave * vaColor.a; // Use alpha channel as wave mask
    
    gl_Position = gbufferProjectionMatrix * (gbufferViewMatrix * vec4(worldPos, 1.0));
}
