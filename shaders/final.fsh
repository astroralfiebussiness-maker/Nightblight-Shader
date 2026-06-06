#version 150

uniform sampler2D colortex0;

in vec2 texCoord;

out vec4 outColor;

void main() {
    vec3 color = texture(colortex0, texCoord).rgb;
    
    // Gamma correction
    color = pow(color, vec3(1.0 / 2.2));
    
    outColor = vec4(color, 1.0);
}
