#version 150

// NightBlight - Water Vertex Shader
// Water surface animation

out vec2 texCoord;
out vec3 normal;
out vec4 color;
out vec3 fragPos;
out float waveHeight;

uniform mat4 gbufferModelMatrix;
uniform mat4 gbufferViewMatrix;
uniform mat4 gbufferProjectionMatrix;
uniform float worldTime;
uniform vec3 cameraPosition;
uniform float waveHeight_u;

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
    
    // Wave animation for water
    float wave1 = sin(worldPos.x * 0.3 + worldTime * 0.002) * waveHeight_u * 0.05;
    float wave2 = sin(worldPos.z * 0.2 + worldTime * 0.0015) * waveHeight_u * 0.03;
    float wave3 = cos((worldPos.x + worldPos.z) * 0.25 + worldTime * 0.0025) * waveHeight_u * 0.04;
    
    worldPos.y += wave1 + wave2 + wave3;
    waveHeight = wave1 + wave2 + wave3;
    
    // Update normals based on waves (simplified)
    normal = normalize(normal + vec3(wave1, 0.0, wave2) * 0.1);
    
    gl_Position = gbufferProjectionMatrix * (gbufferViewMatrix * vec4(worldPos, 1.0));
}
