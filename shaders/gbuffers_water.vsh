#version 150

out vec2 texCoord;
out vec3 normal;
out vec4 vertexColor;

uniform mat4 gbufferModelMatrix;
uniform mat4 gbufferViewMatrix;
uniform mat4 gbufferProjectionMatrix;
uniform float worldTime;

in vec3 vaPosition;
in vec2 vaUV0;
in vec3 vaNormal;
in vec4 vaColor;

void main() {
    texCoord = vaUV0;
    vertexColor = vaColor;
    normal = normalize(mat3(gbufferModelMatrix) * vaNormal);
    
    vec3 worldPos = (gbufferModelMatrix * vec4(vaPosition, 1.0)).xyz;
    
    // Water wave animation
    float wave = sin(worldPos.x * 0.1 + worldTime * 0.001) * 0.02;
    wave += sin(worldPos.z * 0.1 + worldTime * 0.0015) * 0.02;
    worldPos.y += wave;
    
    gl_Position = gbufferProjectionMatrix * (gbufferViewMatrix * vec4(worldPos, 1.0));
}
