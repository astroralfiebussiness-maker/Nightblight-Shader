#version 120
#extension GL_ARB_texture_rectangle : enable

// NightBlight - Fabric Entities Fragment Shader

varying vec2 texCoord;
varying vec3 normal;
varying vec4 vertexColor;

uniform sampler2D tex;
uniform float sunBrightness;
uniform float ambientLight;

void main() {
    vec4 texColor = texture2D(tex, texCoord);
    
    if (texColor.a < 0.1) discard;
    
    vec3 baseColor = texColor.rgb * vertexColor.rgb;
    vec3 norm = normalize(normal);
    
    vec3 sunDir = normalize(vec3(0.5, 1.0, 0.5));
    float diffuse = max(0.0, dot(norm, sunDir)) * sunBrightness;
    float lighting = diffuse + ambientLight;
    
    vec3 finalColor = baseColor * lighting;
    gl_FragColor = vec4(finalColor, 1.0);
}
