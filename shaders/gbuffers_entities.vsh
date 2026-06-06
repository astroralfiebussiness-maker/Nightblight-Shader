#version 150

out VS_OUT {
    vec2 texCoord;
    vec3 normal;
    vec4 vertexColor;
} vs_out;

uniform mat4 gbufferModelMatrix;
uniform mat4 gbufferViewMatrix;
uniform mat4 gbufferProjectionMatrix;

in vec3 vaPosition;
in vec2 vaUV0;
in vec3 vaNormal;
in vec4 vaColor;

void main() {
    vs_out.texCoord = vaUV0;
    vs_out.vertexColor = vaColor;
    vs_out.normal = normalize(mat3(gbufferModelMatrix) * vaNormal);
    
    vec3 worldPos = (gbufferModelMatrix * vec4(vaPosition, 1.0)).xyz;
    vec4 viewPos = gbufferViewMatrix * vec4(worldPos, 1.0);
    gl_Position = gbufferProjectionMatrix * viewPos;
}
