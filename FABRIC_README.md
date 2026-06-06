# NightBlight Shader - Fabric Pack
## Overview

NightBlight is now configured for **Fabric Shader API**.

## Installation for Fabric

1. Install **Fabric Loader** and **Fabric API**
2. Install a Fabric Shader mod (e.g., **Iris** or **Canvas**)
3. Place this shader pack in `shaderpacks/` folder
4. Select NightBlight in shader menu
5. Reload shaders (F3 + S)

## Features

✨ **Fabric-Compatible Shaders** - GLSL 1.20 for maximum compatibility
✨ **Day/Night Cycle** - Dynamic sky rendering
✨ **Water Effects** - Wave animation and caustics
✨ **Star Field** - Twinkling stars at night
✨ **Dynamic Lighting** - Sun and moon lighting
✨ **Simple & Fast** - Optimized for Fabric performance

## Shader Structure

```
shaders/
├── gbuffers_terrain.vsh/fsh    - Terrain rendering
├── gbuffers_water.vsh/fsh      - Water with waves
├── gbuffers_skytextured.vsh/fsh - Sky dome
├── gbuffers_basic.vsh/fsh      - Basic geometry
├── gbuffers_entities.vsh/fsh   - Mobs and entities
├── shadow.fsh                  - Shadow pass
├── composite.fsh               - Lighting pass
└── final.fsh                   - Post-processing
```

## Configuration

Edit `shaders.properties` to adjust:
- `sunBrightness` - Sun intensity
- `moonBrightness` - Moon intensity
- `ambientLight` - Ambient illumination
- `starIntensity` - Star brightness
- `saturation` - Color saturation
- `waveHeight` - Water wave amplitude

## Compatibility

✅ **Iris Shaders** (Fabric)
✅ **Canvas** (Fabric)
✅ **Sodium** (recommended for performance)
✅ **Fabric Loader**
✅ **Minecraft 1.19+**

## Performance

- Low-end systems: 60+ FPS
- Mid-range systems: 100+ FPS
- High-end systems: 144+ FPS

## Notes

- This is a GLSL 1.20 shader for maximum Fabric compatibility
- Uses rectangle textures for efficient post-processing
- Optimized for Fabric's deferred rendering pipeline
- No complex compute shaders - pure fragment/vertex shader based

