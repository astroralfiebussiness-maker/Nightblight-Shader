#version 150

uniform sampler2D tex;

in vec2 texCoord;
in vec3 normal;
in vec4 vertexColor;

out vec4 outColor;

void main() {
    vec4 texColor = texture(tex, texCoord);
    
    if (texColor.a < 0.1) discard;
    
    vec3 color = texColor.rgb * vertexColor.rgb;
    
    // Simple lighting
    vec3 lightDir = normalize(vec3(1.0, 1.0, 1.0));
    float light = max(0.3, dot(normalize(normal), lightDir));
    
    outColor = vec4(color * light, 1.0);
}
