#version 150

uniform sampler2D colortex0;

in vec2 texCoord;

out vec4 outColor;

void main() {
    vec3 color = texture(colortex0, texCoord).rgb;
    
    // Clamp color
    color = clamp(color, vec3(0.0), vec3(1.0));
    
    // Gamma correction
    color = pow(color, vec3(1.0 / 2.2));
    
    outColor = vec4(color, 1.0);
}
