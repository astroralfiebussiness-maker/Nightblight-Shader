# NightBlight Performance Optimization Guide

## Benchmark Results

### Test Conditions
- Resolution: 1920x1080
- Render Distance: 64 chunks
- Test Scene: Mixed terrain with water, foliage, entities
- Average FPS over 5 minutes

### Performance Targets

| GPU | Low | Medium | High | Ultra |
|-----|-----|--------|------|-------|
| GTX 1050 | 90+ | 60+ | - | - |
| GTX 1660 | 144+ | 90+ | 60+ | - |
| RTX 3060 | 240+ | 144+ | 90+ | 60+ |
| RTX 4070 | 240+ | 240+ | 144+ | 90+ |

## Performance Budget Breakdown

### Low Preset (Budget: 2-3ms)
- Shadow rendering: 0.5ms
- Lighting: 0.8ms
- Post-processing: 0.4ms
- Foliage animation: 0.2ms
- **Total: ~2.0ms**

### Medium Preset (Budget: 4-5ms)
- Shadow rendering: 1.0ms
- Lighting: 1.5ms
- Post-processing: 1.0ms
- Effects: 0.5ms
- **Total: ~4.0ms**

### High Preset (Budget: 8-10ms)
- Shadow rendering: 2.0ms
- Lighting: 3.0ms
- Post-processing: 2.5ms
- Effects: 1.5ms
- Volumetric effects: 1.0ms
- **Total: ~8.0ms**

### Ultra Preset (Budget: 15-20ms)
- Shadow rendering: 4.0ms
- Lighting: 5.0ms
- Post-processing: 4.0ms
- Volumetric effects: 3.0ms
- Advanced effects: 2.0ms
- **Total: ~15.0ms**

## Critical Performance Features

### Shadow Rendering

**Low:** Single PCF tap, 128x128 shadow map
```glsl
float shadow = texture(shadowMap, uv).r > fragDepth ? 1.0 : 0.0;
```
**Performance:** ~0.5ms

**Medium:** 4x4 PCF filter, 256x256 shadow map
```glsl
float shadow = 0.0;
for(int i = -1; i <= 1; i++)
for(int j = -1; j <= 1; j++)
    shadow += texture(shadowMap, uv + offset*vec2(i,j)).r > fragDepth ? 1.0 : 0.0;
shadow /= 9.0;
```
**Performance:** ~1.0ms

**High:** 8x8 PCF filter, 512x512 shadow map, cascaded
**Performance:** ~2.0ms

**Ultra:** 16x16 PCF filter, 1024x1024 shadow map, cascaded with compare
**Performance:** ~4.0ms

### Lighting Calculation

**Optimized for Night Performance:**

```glsl
// Fast moonlight calculation
vec3 moonlight = vec3(0.1, 0.2, 0.4) * moonBrightness * max(0.0, dot(normal, moonDir));

// Efficient ambient
vec3 ambient = mix(nightAmbient, dayAmbient, timeOfDayFactor);

// Combine
vec3 lit = albedo * (sunlight + moonlight + ambient);
```

### Foliage Animation

**Simple vertex-based waving:**

```glsl
// Vertex shader
float wave = sin(fragPos.x * 0.1 + fragPos.z * 0.1 + time * 0.3) * 0.1;
gl_Position += vec4(wave, 0.0, 0.0, 0.0);
```

**Cost:** ~0.2ms (vertex bound, not fragment bound)

### Volumetric Fog

**Low:** Disabled entirely

**Medium:** Simple distance-based fog
```glsl
float fogFactor = 1.0 - exp(-distance * 0.01);
color = mix(color, fogColor, fogFactor);
```
**Performance:** ~0.5ms

**High:** Volumetric fog with shadow sampling
```glsl
vec3 rayDir = normalize(fragPos - cameraPos);
vec3 result = vec3(0.0);
for(int i = 0; i < 16; i++) { // 16 steps
    vec3 rayPos = cameraPos + rayDir * float(i) * stepSize;
    float shadow = texture(shadowMap, project(rayPos)).r;
    float density = exp(-distance(rayPos, cameraPos) * 0.05);
    result += density * shadow * fogColor;
}
color = mix(color, result, fogFactor);
```
**Performance:** ~1.0ms

**Ultra:** Full volumetric with multi-directional sampling
**Performance:** ~3.0ms

### Screen-Space Reflections

**Disabled in Low/Medium presets**

**High/Ultra:** Binary search raycasting
```glsl
vec3 rayStart = fragPos;
vec3 rayDir = reflect(viewDir, normal);

for(int step = 0; step < 64; step++) {
    vec3 rayPos = rayStart + rayDir * float(step) * stepSize;
    vec4 projPos = projection * vec4(rayPos, 1.0);
    vec2 screenPos = projPos.xy / projPos.w * 0.5 + 0.5;
    
    if(texture(depthBuffer, screenPos).r < projPos.z) {
        // Hit detected, can retrieve color
        return texture(colorBuffer, screenPos).rgb;
    }
}
```
**Performance:** ~1.5ms for 64 steps

## Optimization Tips for Users

### If FPS is Low

1. **Disable specific features:**
   - Set Volumetric Fog to "Off"
   - Set Lens Flare to "Off"
   - Disable Motion Blur
   - Disable Screen-Space Reflections

2. **Reduce render distance:**
   - Lower shadow distance
   - Reduce volumetric fog distance

3. **Adjust quality settings:**
   - Lower Bloom Quality
   - Reduce TAA from 4x to 2x
   - Lower God Rays Quality

### If Night is Too Slow

1. Reduce Star Intensity
2. Disable Galaxy rendering
3. Reduce Moonveil effect intensity
4. Disable Night Pulse effect

### If Day is Too Slow

1. Reduce Cloud Quality
2. Disable God Rays
3. Reduce Bloom Strength
4. Lower Foliage Waving intensity

## Developer Optimization Strategies

### Conditional Compilation

```glsl
#ifdef LOW_QUALITY
    // Use simple calculations
#elif defined MEDIUM_QUALITY
    // Use moderate quality
#else
    // Use best quality
#endif
```

### Early Exit Patterns

```glsl
// Skip expensive calculations for occluded fragments
if(depth > 0.999) {
    gl_FragColor = vec4(sky, 1.0);
    return;
}
```

### Texture Atlasing

Combine multiple small textures into atlases to reduce texture lookups.

### Caching and Reuse

Cache expensive calculations like normal vectors for use in multiple passes.

## Future Optimization Opportunities

1. **Compute Shaders:** Pre-calculate lighting for tile-based deferred rendering
2. **Mesh Shaders:** Reduce draw calls for foliage
3. **Variable Rate Shading:** Lower quality in peripheral vision
4. **Bindless Texturing:** Reduce state changes
5. **GPU Instancing:** Batch similar geometry

## Profiling Recommendations

### Using Iris Debug Overlay
1. Press `Shift+F12` to open debug menu
2. Enable frame time breakdown
3. Identify bottleneck passes
4. Adjust relevant settings

### Manual Timing
1. Disable effects one by one
2. Measure FPS change
3. Identify highest-cost effects
4. Prioritize optimization efforts

## Memory Usage

### Texture Memory
- Shadow maps: 2-4 MB (depending on resolution)
- GBuffer textures: 8-16 MB (depending on presets)
- Effect textures (bloom, etc.): 4-8 MB
- **Total: 15-30 MB**

### Shader Program Size
- Approximately 2-5 MB compiled
- Varies by target GPU architecture

## Compatibility Notes

### Minimum Requirements
- GLSL 1.50+
- Floating-point textures (32-bit)
- At least 2x2 MRT (Multiple Render Targets)
- Support for derivative instructions (dFdx, dFdy)

### Recommended
- GLSL 3.30+
- 4x MSAA support
- Texture filtering with mipmaps
- Instancing support
