# NightBlight Shader Architecture

## Overview

NightBlight is structured as a modular GLSL shader system for Iris/Oculus, designed with clean separation of concerns and maintainability.

## Rendering Pipeline

### 1. Geometry Buffer (GBuffer) Pass

Captures per-pixel data into multiple render targets:
- **GBuffer 0**: Albedo (RGB) + Material ID (A)
- **GBuffer 1**: Normal (RG) + Specular/Roughness (BA)
- **GBuffer 2**: Depth + Ambient Occlusion + Emissive
- **GBuffer 3**: Light data

### 2. Shadow Pass

Renders scene to shadow map from light's perspective:
- Handles both sun and moon shadows
- Cascaded shadow maps for improved quality
- Percentage-closer filtering (PCF) for soft shadows

### 3. Lighting Pass (Composite)

Combines all lighting information:
- Direct sunlight calculation
- Moonlight calculation
- Ambient lighting based on sky dome
- Emissive block contributions
- Shadow application

### 4. Post-Processing Pass

Applies final effects:
- Bloom and glow
- Tone mapping (ACES)
- Color grading
- Temporal anti-aliasing
- Fog and atmosphere

### 5. Final Pass

Final composition with:
- Motion blur (optional)
- Depth of field (optional)
- Lens flare
- Screen-space reflections

## Shader Organization

### Core Module (`shaders/core/`)

**common.glsl**
- Shared constants and uniforms
- Global configuration values
- Macro definitions

**functions.glsl**
- Utility functions used across shaders
- Math helpers (normalize, smoothstep variants)
- Sampling functions

**constants.glsl**
- Physical constants
- Color constants
- Performance thresholds

### Vertex Shaders (`shaders/vertex/`)

**gbuffers_basic.vsh**
- Non-textured geometry (hands, items)
- Simple position transformation
- Normal calculation

**gbuffers_terrain.vsh**
- Terrain, grass, foliage
- Waving animation for vegetation
- Wave parameters based on time and position

**gbuffers_water.vsh**
- Water surface
- Wave animation for realism
- Displacement mapping

**gbuffers_entities.vsh**
- Mobs, armor stands, etc.
- Bone animation preservation
- Normal mapping support

**gbuffers_skytextured.vsh**
- Sky dome rendering
- Star field generation
- Simple pass-through for texture coordinates

### Fragment Shaders (`shaders/fragment/`)

**gbuffers_terrain.fsh**
- Main terrain rendering
- Normal mapping
- Parallax mapping support
- Ambient occlusion application

**gbuffers_water.fsh**
- Water surface shading
- Caustics rendering
- Refraction distortion
- Fresnel reflection

**gbuffers_entities.fsh**
- Entity and mob rendering
- Support for entity normals
- Emissive entities (glowing)

**gbuffers_skytextured.fsh**
- Sky rendering
- Star generation and animation
- Sun/moon disk rendering
- Atmosphere scattering

**composite.fsh** (Main Lighting Pass)
- Deferred lighting calculation
- Shadow sampling
- Ambient calculation
- Emissive block handling
- Time-of-day adjustments

**composite1.fsh** (Effects Pass)
- Bloom extraction and blurring
- Volumetric fog
- Screen-space reflections

**final.fsh** (Post-Processing)
- Tone mapping
- Color grading
- Temporal anti-aliasing
- Final composition

**shadow.fsh**
- Shadow map rendering
- Alpha blending for transparent blocks

### Lighting Module (`shaders/lighting/`)

**sunlight.glsl**
- Solar disk rendering
- Shadow calculation
- Sunlight color based on sky angle
- God rays implementation

**moonlight.glsl**
- Moonlight calculation with blue tint
- Moon phase rendering
- Moonveil volumetric effect
- Starlight reflection calculation

**ambient.glsl**
- Ambient light determination from sky
- Night pulse effect
- Eye adaptation calculation

**emissive.glsl**
- Block emission handling
- Emissive particle support
- Glow contribution

### Post-Processing Module (`shaders/post/`)

**bloom.glsl**
- Bloom threshold extraction
- Gaussian blur implementation
- Bloom composition

**tonemap.glsl**
- ACES tone mapping
- Saturation control
- Contrast adjustment

**aces.glsl**
- Reference ACES color space functions
- Input/output transforms

## Key Techniques

### Night Lighting Algorithm

1. Sample shadow map at pixel location
2. Calculate base ambient from sky color
3. Apply moonlight with blue tint and falloff
4. Add starlight contribution to ambient
5. Enhance with night pulse in magical areas
6. Apply dynamic eye adaptation

### Volumetric Lighting (God Rays & Moonveil)

1. Raycast from camera toward light source
2. Sample shadow map along ray
3. Accumulate illumination
4. Apply depth-based falloff
5. Composite with final image

### Water Rendering Pipeline

1. Generate wave height and normal
2. Calculate Fresnel for reflection/refraction
3. Refract view direction for underwater distortion
4. Apply caustics pattern
5. Render reflections of sky and terrain
6. Composite with scene

### Eye Adaptation

1. Calculate average scene luminance
2. Store previous frame's luminance
3. Smoothly transition adaptation over time
4. Adjust final output based on adaptation value

## Performance Optimization Strategies

### Low Preset
- Single-tap shadow sampling
- 2x2 bloom
- No volumetric effects
- Temporal AA disabled
- Simple ambient calculation

### Medium Preset
- 4x4 PCF shadow sampling
- 4x4 bloom
- Basic volumetric fog
- Temporal AA 1x
- Improved ambient with interpolation

### High Preset
- 8x8 PCF shadow sampling
- 8x8 bloom with multiple passes
- Full volumetric effects
- Temporal AA 2x
- Advanced ambient occlusion

### Ultra Preset
- 16x16 PCF shadow sampling
- Full bloom and blur pipeline
- Full volumetric lighting with high quality
- Temporal AA 4x
- HBAO+ style ambient occlusion

## Uniforms & Configuration

All configurable parameters are exposed through:
- `shaders.properties` for static configuration
- Iris/Oculus options menu for runtime adjustment

See `CONFIGURATION.md` for complete list.

## Future Enhancements

- Path tracing for ultra preset
- Real-time global illumination
- Voxel cone tracing
- Screen-space ray tracing for reflections
- Advanced weather simulation
