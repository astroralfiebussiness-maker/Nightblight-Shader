#version 150

in VS_OUT {
    vec2 texCoord;
    vec3 normal;
    vec4 vertexColor;
} fs_in;

uniform float worldTime;

out vec4 outColor;

void main() {
    vec3 waterColor = vec3(0.1, 0.4, 0.8);
    
    // Caustic effect
    float caustic = sin(fs_in.texCoord.x * 10.0 + worldTime * 0.001) * 
                   sin(fs_in.texCoord.y * 10.0 + worldTime * 0.0015) * 0.15 + 0.85;
    
    waterColor *= caustic;
    waterColor *= 0.7; // Make it darker
    
    outColor = vec4(waterColor, 0.8);
}
