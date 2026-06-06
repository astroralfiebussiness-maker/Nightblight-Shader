#version 120
#extension GL_ARB_texture_rectangle : enable

// NightBlight - Fabric Terrain Fragment Shader

varying vec2 texCoord;
varying vec3 normal;
varying vec4 vertexColor;
varying vec3 fragPos;
varying float material;

uniform sampler2D tex;
uniform sampler2D lightmap;
uniform float sunBrightness;
uniform float moonBrightness;
uniform float ambientLight;

void main() {
    vec4 texColor = texture2D(tex, texCoord);
    
    if (texColor.a < 0.1) discard;
    
    vec3 baseColor = texColor.rgb * vertexColor.rgb;
    vec3 norm = normalize(normal);
    
    // Simple sun direction
    vec3 sunDir = normalize(vec3(0.5, 1.0, 0.5));
    float diffuse = max(0.0, dot(norm, sunDir)) * sunBrightness;
    
    // Moon direction (opposite)
    vec3 moonDir = -sunDir;
    float moonLight = max(0.0, dot(norm, moonDir)) * moonBrightness * 0.3;
    
    // Combine lighting
    float lighting = diffuse + moonLight + ambientLight;
    vec3 finalColor = baseColor * lighting;
    
    gl_FragColor = vec4(finalColor, 1.0);
}
