#version 150

in VS_OUT {
    vec2 texCoord;
    vec3 normal;
    vec4 vertexColor;
} fs_in;

uniform sampler2D tex;
uniform sampler2D lightmap;

out vec4 outColor;

void main() {
    vec4 texColor = texture(tex, fs_in.texCoord);
    
    if (texColor.a < 0.1) discard;
    
    vec3 baseColor = texColor.rgb * fs_in.vertexColor.rgb;
    
    // Normalize the normal
    vec3 normal = normalize(fs_in.normal);
    
    // Very simple lighting - sun from above
    vec3 sunDir = normalize(vec3(0.5, 1.0, 0.5));
    float diffuse = max(0.2, dot(normal, sunDir));
    
    vec3 finalColor = baseColor * diffuse;
    
    outColor = vec4(finalColor, 1.0);
}
