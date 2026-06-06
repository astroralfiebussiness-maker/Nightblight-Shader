#version 150
#extension GL_ARB_explicit_attrib_location : enable

// NightBlight - Final Shader (Post-Processing)

uniform sampler2D colortex0;
uniform float bloomStrength;
uniform float saturation;

in vec2 texCoord;

layout(location = 0) out vec4 fragColor;

vec3 adjustSaturation(vec3 color, float sat) {
    float lum = dot(color, vec3(0.299, 0.587, 0.114));
    vec3 gray = vec3(lum);
    return mix(gray, color, sat);
}

vec3 tonemapReinhard(vec3 color) {
    return color / (color + vec3(1.0));
}

void main() {
    vec3 color = texture(colortex0, texCoord).rgb;
    
    // Tone mapping
    color = tonemapReinhard(color);
    
    // Saturation
    color = adjustSaturation(color, saturation);
    
    // Gamma
    color = pow(color, vec3(1.0 / 2.2));
    
    fragColor = vec4(color, 1.0);
}
