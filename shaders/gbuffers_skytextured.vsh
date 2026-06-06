#version 150

out VS_OUT {
    vec3 rayDir;
    vec2 texCoord;
} vs_out;

uniform mat4 gbufferModelMatrix;
uniform mat4 gbufferViewMatrix;
uniform mat4 gbufferProjectionMatrix;

in vec3 vaPosition;
in vec2 vaUV0;
in vec3 vaNormal;

void main() {
    vs_out.texCoord = vaUV0;
    
    vec3 worldPos = (gbufferModelMatrix * vec4(vaPosition, 1.0)).xyz;
    vec4 viewPos = gbufferViewMatrix * vec4(worldPos, 1.0);
    gl_Position = gbufferProjectionMatrix * viewPos;
    
    // Ray direction for sky
    vs_out.rayDir = normalize(worldPos);
}
