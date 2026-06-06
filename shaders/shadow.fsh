#version 150

// NightBlight - Shadow Fragment Shader

uniform sampler2D tex;

in vec2 texCoord;

void main() {
    vec4 texColor = texture(tex, texCoord);
    if (texColor.a < 0.5) discard;
}
