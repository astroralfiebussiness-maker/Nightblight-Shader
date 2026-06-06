#version 150

// NightBlight - Final Shader
// Post-processing and tone mapping

uniform sampler2D colortex0;
uniform float bloomStrength;
uniform float saturation;

in vec2 texCoord;
out vec4 outColor;

vec3 adjustSaturation(vec3 color, float sat) {
    vec3 gray = vec3(dot(color, vec3(0.299, 0.587, 0.114)));
    return mix(gray, color, sat);
}

vec3 tonemapReinhard(vec3 color) {
    return color / (color + vec3(1.0));
}

void main() {
    vec3 color = texture(colortex0, texCoord).rgb;
    
    // Tone mapping
    color = tonemapReinhard(color);
    
    // Saturation adjustment
    color = adjustSaturation(color, saturation);
    
    // Gamma correction
    color = pow(color, vec3(1.0 / 2.2));
    
    outColor = vec4(color, 1.0);
}
