#version 150
#extension GL_EXT_gpu_shader4 : enable

// NightBlight - Sky Vertex Shader
// Sky dome rendering

out vec3 rayDir;
out vec2 texCoord;

uniform mat4 gbufferModelMatrix;
uniform mat4 gbufferViewMatrix;
uniform mat4 gbufferProjectionMatrix;
uniform mat4 gbufferPreviousViewMatrix;

in vec3 vaPosition;
in vec2 vaUV0;
in vec3 vaNormal;

void main() {
    texCoord = vaUV0;
    
    vec3 worldPos = (gbufferModelMatrix * vec4(vaPosition, 1.0)).xyz;
    gl_Position = gbufferProjectionMatrix * (gbufferViewMatrix * vec4(worldPos, 1.0));
    
    // Ray direction from camera
    rayDir = normalize(worldPos);
}
