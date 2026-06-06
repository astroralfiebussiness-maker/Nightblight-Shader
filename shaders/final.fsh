#version 120
#extension GL_ARB_texture_rectangle : enable

// NightBlight - Fabric Final Shader

varying vec2 texCoord;

uniform sampler2DRect colortex0;
uniform float saturation;

vec3 adjustSaturation(vec3 color, float sat) {
    float lum = dot(color, vec3(0.299, 0.587, 0.114));
    vec3 gray = vec3(lum);
    return mix(gray, color, sat);
}

void main() {
    vec3 color = texture2DRect(colortex0, gl_FragCoord.xy).rgb;
    
    color = clamp(color, vec3(0.0), vec3(1.0));
    color = adjustSaturation(color, saturation);
    color = pow(color, vec3(1.0 / 2.2));
    
    gl_FragColor = vec4(color, 1.0);
}
