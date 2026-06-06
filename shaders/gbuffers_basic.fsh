#version 150

// NightBlight - Basic Fragment Shader

uniform sampler2D tex;
uniform float ambientStrength;

in vec2 texCoord;
in vec3 normal;
in vec4 color;

out vec4 outColor;

void main() {
    vec4 texColor = texture(tex, texCoord);
    
    if (texColor.a < 0.5) discard;
    
    vec3 albedo = texColor.rgb * color.rgb;
    vec3 lighting = normalize(normal) * 0.5 + 0.5; // Basic normal visualization
    
    outColor = vec4(albedo * (lighting + ambientStrength), 1.0);
}
