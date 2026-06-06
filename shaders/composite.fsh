#version 120
#extension GL_ARB_texture_rectangle : enable

// NightBlight - Fabric Composite Shader

varying vec2 texCoord;

uniform sampler2DRect colortex0;

void main() {
    vec3 color = texture2DRect(colortex0, gl_FragCoord.xy).rgb;
    color = clamp(color, vec3(0.0), vec3(1.0));
    gl_FragColor = vec4(color, 1.0);
}
