#version 150
#extension GL_ARB_explicit_attrib_location : enable

// NightBlight - Terrain Fragment Shader
// Main terrain rendering with lighting

uniform sampler2D tex;
uniform sampler2D lightmap;

in vec2 texCoord;
in vec3 normal;
in vec4 color;
in vec3 fragPos;
in vec3 viewNormal;

layout(location = 0) out vec4 colortex0;
layout(location = 1) out vec4 colortex1;
layout(location = 2) out vec4 colortex2;

// Encode normal
vec2 encodeNormal(vec3 n) {
    n = normalize(n) * 0.5 + 0.5;
    return n.xy;
}

void main() {
    vec4 texColor = texture(tex, texCoord);
    
    // Discard transparent pixels
    if (texColor.a < 0.5) discard;
    
    vec3 albedo = texColor.rgb * color.rgb;
    
    // GBuffer output
    // colortex0: Albedo + block light
    colortex0 = vec4(albedo, 1.0);
    
    // colortex1: Normal data + specularity
    colortex1 = vec4(encodeNormal(normal), 0.5, 1.0);
    
    // colortex2: Emissive flag
    colortex2 = vec4(vec3(0.0), 1.0);
}
