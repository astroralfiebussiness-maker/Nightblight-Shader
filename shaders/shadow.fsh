#version 150

uniform sampler2D tex;

in vec2 texCoord;

void main() {
    vec4 color = texture(tex, texCoord);
    if (color.a < 0.1) discard;
}
