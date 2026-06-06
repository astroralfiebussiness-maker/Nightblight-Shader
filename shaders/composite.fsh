#version 150

uniform sampler2D colortex0;
uniform float worldTime;

in vec2 texCoord;

out vec4 outColor;

const float PI = 3.14159265359;
const float TWO_PI = 6.28318530718;

void main() {
    vec3 color = texture(colortex0, texCoord).rgb;
    
    // Simple pass-through for now
    outColor = vec4(color, 1.0);
}
