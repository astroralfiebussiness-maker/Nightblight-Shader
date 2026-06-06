#version 150

// NightBlight - Shadow Fragment Shader
// Renders scene to shadow map

uniform sampler2D tex;

in vec2 texCoord;

void main() {
    vec4 texColor = texture(tex, texCoord);
    
    // Alpha testing for transparent blocks
    if (texColor.a < 0.5) discard;
    
    // Depth is handled automatically by GPU
}
