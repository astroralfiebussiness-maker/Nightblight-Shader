#version 150
#extension GL_EXT_gpu_shader4 : enable

// NightBlight - Terrain Vertex Shader
// Handles terrain rendering with waving foliage animation

out vec2 texCoord;
out vec3 normal;
out vec4 color;
out vec3 fragPos;
out vec3 viewNormal;

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
    
    vec3 worldPos = (gbufferModelMatrix * vec4(vaPosition, 1.0)).xyz;
    fragPos = worldPos;
    
    // Transform normal to world space
    normal = normalize((gbufferModelMatrix * vec4(vaNormal, 0.0)).xyz);
    viewNormal = normalize((gbufferViewMatrix * vec4(normal, 0.0)).xyz);
    
    // Waving foliage animation for grass and leaves
    float wave = sin(worldPos.x * 0.1 + worldPos.z * 0.1 + worldTime * 0.005) * 0.05;
    wave += sin(worldPos.x * 0.05 + worldPos.z * 0.05 + worldTime * 0.003) * 0.03;
    
    // Apply wave to Y position (vertical waving)
    worldPos.y += wave * vaColor.a;
    
    gl_Position = gbufferProjectionMatrix * (gbufferViewMatrix * vec4(worldPos, 1.0));
}
