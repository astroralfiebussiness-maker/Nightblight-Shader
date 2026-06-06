# NightBlight Shader Passes - Detailed Reference

## Shadow Pass (`shadow.fsh`)

### Purpose
Renders the scene from the light's perspective to create shadow maps for both sun and moon.

### Key Variables
- `gl_Position`: Transformed to light space
- `varying float alpha`: For transparent block handling

### Technique
```glsl
// Simple shadow rendering - only depth information needed
void main() {
    // Handle alpha testing for leaves, grass
    if (texture(tex, texCoord).a < 0.1) discard;
    // GPU handles depth automatically
}
```

## GBuffer Passes

### `gbuffers_terrain.fsh` - Terrain

**Outputs:**
- `GBuffer 0`: Terrain color + material ID
- `GBuffer 1`: Normal map data + specularity
- `GBuffer 2`: Depth + AO + Emissive flag

**Key Techniques:**
- Normal mapping from texture
- Parallax mapping for depth
- Ambient occlusion blending
- Emissive block detection

### `gbuffers_water.fsh` - Water

**Outputs:**
- `GBuffer 0`: Water color (blue-tinted)
- `GBuffer 1`: Perturbed normals from wave animation
- `GBuffer 2`: Emissive for glowing water blocks

**Key Techniques:**
- Wave height calculation from time + position
- Normal perturbation
- Caustic pattern rendering
- Refraction sampling

### `gbuffers_entities.fsh` - Mobs & Items

**Outputs:**
- `GBuffer 0`: Entity color
- `GBuffer 1`: Per-vertex normals
- `GBuffer 2`: Glowing entity detection

**Key Techniques:**
- Entity-specific normal handling
- Glow detection for glowing entities
- Enchantment shimmer support

### `gbuffers_skytextured.fsh` - Sky

**Outputs:**
- `GBuffer 0`: Sky color gradient
- `GBuffer 1`: Sky normals (mostly vertical)
- `GBuffer 2`: Star field and moon data

**Key Techniques:**
- Sky color interpolation based on sun angle
- Star generation with pseudo-random function
- Star twinkling based on time
- Moon rendering with phase
- Atmosphere scattering approximation

## Lighting Pass (`composite.fsh`)

### Purpose
Combines geometry data with lighting calculations to produce final lit scene.

### Main Algorithm

```glsl
void main() {
    // 1. Decode GBuffers
    vec3 albedo = texture(colortex0, uv).rgb;
    vec3 normal = decode_normal(texture(colortex1, uv).rg);
    float specularity = texture(colortex1, uv).b;
    
    // 2. Calculate visibility
    float visibility = sample_shadow(fragPos);
    
    // 3. Calculate direct lighting
    vec3 sunlight = calculate_sunlight(normal, visibility);
    vec3 moonlight = calculate_moonlight(normal, visibility);
    
    // 4. Calculate ambient
    vec3 ambient = calculate_ambient(normal);
    
    // 5. Combine
    vec3 lit = albedo * (sunlight + moonlight + ambient);
    
    // 6. Add emissive
    vec3 emissive = get_emissive_contribution();
    
    gl_FragColor = vec4(lit + emissive, 1.0);
}
```

### Critical Functions

#### `calculate_sunlight()`
```
Inputs: surface normal, shadow visibility
Outputs: RGB sunlight contribution

Steps:
1. Calculate light direction (sun position)
2. Apply Lambert's cosine law
3. Apply shadow factor
4. Color sunlight based on atmospheric scattering
```

#### `calculate_moonlight()`
```
Inputs: surface normal, shadow visibility
Outputs: RGB moonlight contribution (blue-tinted)

Steps:
1. Calculate moon position and phase
2. Apply Lambert's cosine law (dim)
3. Apply shadow factor
4. Tint blue with intensity falloff
5. Add starlight ambient boost
```

#### `calculate_ambient()`
```
Inputs: surface normal
Outputs: RGB ambient light

Steps:
1. Sample sky color
2. Apply hemisphere lighting from sky
3. Modulate by time of day
4. Add night pulse effect if applicable
5. Apply eye adaptation
```

## Effects Pass (`composite1.fsh`)

### Purpose
Applies screen-space effects that enhance visual quality.

### Operations

#### Bloom Extraction
```
For each pixel with luminance > threshold:
  Extract bloom contribution
  Store in temporary texture
```

#### Volumetric Fog
```
For each pixel:
  Calculate distance from camera
  Increase fog density with distance
  Increase fog density at night
  Increase fog density in rain
  Composite fog with scene color
```

#### Screen-Space Reflections
```
For each reflective pixel (water, wet terrain):
  Raycast into screen space
  Find intersecting geometry
  Blend intersection color with reflection
```

## Final Pass (`final.fsh`)

### Purpose
Applies tone mapping, color grading, and final composition.

### Operations

#### Tone Mapping (ACES)
```
1. Apply input transform
2. Apply ACES RRT (Reference Rendering Transform)
3. Apply output transform
4. Clamp values to [0, 1]
```

#### Color Grading
```
1. Apply saturation based on performance preset
2. Apply contrast curves
3. Apply time-of-day color shift
4. Apply weather effects coloration
```

#### Temporal Anti-Aliasing
```
1. Calculate subpixel offset
2. Sample current and previous frame
3. Calculate color difference
4. Blend frames based on difference and history
```

#### Lens Flare
```
For bright light sources:
  1. Calculate screen-space position
  2. Generate lens flare artifacts
  3. Composite over final image
```

## Vertex Shader Common Pattern

### `gbuffers_*.vsh` Structure

```glsl
#version 150

// Input from Minecraft
in vec3 vaPosition;      // Vertex position
in vec2 vaUV0;          // Texture coordinates
in vec3 vaNormal;       // Vertex normal
in vec4 vaColor;        // Vertex color / lighting

// Uniforms
uniform mat4 gbufferModelMatrix;      // Model-to-world
uniform mat4 gbufferViewMatrix;       // World-to-view
uniform mat4 gbufferProjectionMatrix; // View-to-screen
uniform mat4 gbufferPreviousModelMatrix;   // Previous frame model matrix
uniform mat4 gbufferPreviousViewMatrix;    // Previous frame view matrix
uniform mat4 gbufferPreviousProjectionMatrix; // Previous frame projection

// Time and weather
uniform float worldTime;   // Time of day (0-24000)
uniform float rainStrength; // Rain intensity
uniform float wetness;     // Surface wetness from rain

// Camera
uniform vec3 cameraPosition; // Camera position in world space

// Outputs
out vec3 fragPos;          // Fragment position in world space
out vec2 texCoord;         // Texture coordinate
out vec3 normal;           // Fragment normal (world space)
out flat int materialID;   // Material type identifier
out vec4 color;            // Vertex color
out vec3 prevFragPos;      // Previous frame fragment position

void main() {
    // Transform to world space
    fragPos = (gbufferModelMatrix * vec4(vaPosition, 1.0)).xyz;
    
    // Transform to clip space
    gl_Position = gbufferProjectionMatrix * (gbufferViewMatrix * vec4(fragPos, 1.0));
    
    // Transform normal
    normal = normalize((gbufferModelMatrix * vec4(vaNormal, 0.0)).xyz);
    
    // Pass through texture coordinates
    texCoord = vaUV0;
    
    // Determine material type
    materialID = determine_material_type();
    
    // Pass vertex color
    color = vaColor;
    
    // Calculate previous frame position for TAA
    prevFragPos = (gbufferPreviousModelMatrix * vec4(vaPosition, 1.0)).xyz;
}
```

## Configuration Impact on Passes

### Low Preset
- Shadow pass: 128x128 resolution
- Composite: Single light sample
- Final: No temporal AA

### Medium Preset
- Shadow pass: 256x256 resolution
- Composite: 4 shadow samples
- Final: 1x TAA

### High Preset
- Shadow pass: 512x512 resolution
- Composite: 8 shadow samples
- Final: 2x TAA

### Ultra Preset
- Shadow pass: 1024x1024 resolution
- Composite: 16 shadow samples
- Final: 4x TAA
