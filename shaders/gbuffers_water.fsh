#version 150

uniform sampler2D tex;
uniform float worldTime;

in vec2 texCoord;
in vec3 normal;
in vec4 vertexColor;

out vec4 outColor;

void main() {
    vec3 color = vec3(0.1, 0.4, 0.8); // Water blue
    
    // Caustic effect
    float caustic = sin(texCoord.x * 10.0 + worldTime * 0.001) * 
                   sin(texCoord.y * 10.0 + worldTime * 0.0015) * 0.15 + 0.85;
    
    color *= caustic;
    
    outColor = vec4(color, 0.7);
}
