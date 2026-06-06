# NightBlight Shader Pack

A cinematic Minecraft shader pack for modern versions using the Iris/Oculus shader pipeline (GLSL-based).

## Vision

NightBlight dramatically improves both daytime and nighttime visuals while maintaining good performance and a cinematic atmosphere. The shader combines:
- The atmosphere of BSL shaders
- The realism of Complementary Reimagined
- The cinematic mood of SEUS PTGI
- A unique emphasis on breathtaking nights and beautiful dawns

## Features

### Daytime
- Dynamic sunlight with realistic color temperature
- Volumetric light rays (god rays)
- Realistic atmospheric scattering
- Enhanced cloud rendering
- Dynamic shadows with configurable quality
- Contact shadows and ambient occlusion
- Enhanced water reflections/refractions
- Waving foliage and crops
- Heat haze in hot biomes

### Nighttime (Primary Focus)
- Deep, atmospheric nights with readable terrain
- Soft blue-tinted moonlight illumination
- Enhanced moon rendering with glow
- Bright, detailed, twinkling stars
- Optional visible galaxies and nebulae
- Advanced ambient moonlight
- Dynamic eye adaptation
- Enhanced cave darkness transitions

### Weather Effects
- Improved rain rendering
- Wet surface reflections
- Volumetric fog during storms
- Dynamic storm lighting
- Realistic lightning flashes

### Visual Effects
- High-quality bloom
- Screen-space reflections
- Temporal anti-aliasing
- Volumetric fog
- Cinematic color grading
- Lens flare system
- Improved emissive lighting

### Signature Effects
- **Moonveil**: Volumetric beams through forests at night
- **Starlight Reflections**: Water reflects stars and moonlight
- **Night Pulse**: Subtle animated glow in magical biomes
- **Dawn Awakening**: Smooth sunrise transition
- **Twilight Bloom**: Enhanced sunset/sunrise atmosphere

## Performance Presets

- **Low**: GTX 1050 / Integrated Graphics
- **Medium**: GTX 1660 class
- **High**: RTX 3060 class
- **Ultra**: RTX 4070+ class

## Installation

1. Install [Iris Shaders](https://www.irisshaders.net/) or Oculus
2. Download the latest release
3. Place the shader folder in your `shaderpacks` directory
4. Select NightBlight in your shaders menu

## Project Structure

```
Nightblight-Shader/
├── shaders/
│   ├── core/
│   │   ├── common.glsl
│   │   ├── functions.glsl
│   │   └── constants.glsl
│   ├── vertex/
│   │   ├── gbuffers_basic.vsh
│   │   ├── gbuffers_terrain.vsh
│   │   ├── gbuffers_water.vsh
│   │   ├── gbuffers_entities.vsh
│   │   └── gbuffers_skytextured.vsh
│   ├── fragment/
│   │   ├── gbuffers_basic.fsh
│   │   ├── gbuffers_terrain.fsh
│   │   ├── gbuffers_water.fsh
│   │   ├── gbuffers_entities.fsh
│   │   ├── gbuffers_skytextured.fsh
│   │   ├── composite.fsh
│   │   ├── composite1.fsh
│   │   ├── final.fsh
│   │   └── shadow.fsh
│   ├── post/
│   │   ├── bloom.glsl
│   │   ├── tonemap.glsl
│   │   └── aces.glsl
│   └── lighting/
│       ├── sunlight.glsl
│       ├── moonlight.glsl
│       ├── ambient.glsl
│       └── emissive.glsl
├── textures/
│   ├── stars/
│   ├── moon/
│   └── clouds/
├── docs/
│   ├── ARCHITECTURE.md
│   ├── SHADER_PASSES.md
│   ├── PERFORMANCE.md
│   └── CONFIGURATION.md
└── shaders.properties
```

## Configuration

All shader settings can be configured via the in-game options menu. See `docs/CONFIGURATION.md` for detailed descriptions.

## Development

See `docs/ARCHITECTURE.md` for technical details about shader structure and rendering pipeline.

## License

Created by astroralfiebussiness-maker

## Credits

Inspired by BSL, Complementary Reimagined, and SEUS PTGI shaders.
