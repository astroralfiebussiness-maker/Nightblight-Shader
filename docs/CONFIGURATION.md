# NightBlight Configuration Guide

## In-Game Options Menu

All settings can be accessed through the Iris/Oculus shader options menu while in-game.

### General Settings

#### Performance Preset
- **Low**: Best performance, suitable for integrated graphics
- **Medium**: Balanced quality and performance (GTX 1660 class)
- **High**: High quality with minimal performance impact (RTX 3060 class)
- **Ultra**: Maximum quality (RTX 4070+)

**Note:** Changing this preset resets related settings to their preset defaults.

### Lighting Settings

#### Sun Brightness
- Range: 0.5 - 2.0
- Default: 1.0
- Controls overall sunlight intensity

#### Moon Brightness
- Range: 0.0 - 1.0
- Default: 0.6
- Controls moonlight intensity at night

#### Ambient Light
- Range: 0.0 - 1.0
- Default: 0.3
- Controls global ambient illumination

#### Night Ambient
- Range: 0.0 - 0.5
- Default: 0.2
- Separate ambient multiplier specifically for night time

### Shadow Settings

#### Shadow Distance
- Range: 32 - 256 blocks
- Default: 128
- Distance from camera that shadows are rendered
- Higher = more distant shadows, higher performance cost

#### Shadow Quality
- Range: Low (1x), Medium (4x), High (8x), Ultra (16x)
- Default: Medium
- Number of shadow samples for soft shadows (PCF)

#### Shadow Blur
- Range: 0.5 - 2.0
- Default: 1.0
- Softness of shadow edges

### Water Settings

#### Water Reflections
- Options: Off, Screen-Space, Sky Only, Full
- Default: Screen-Space
- Quality of water reflections

#### Water Refraction
- Options: Off, Subtle, Medium, Strong
- Default: Medium
- Distortion of underwater view

#### Water Caustics
- Range: 0.0 - 1.0
- Default: 0.8
- Intensity of caustic patterns

#### Wave Height
- Range: 0.1 - 1.0
- Default: 0.5
- Animation amplitude of water waves

### Atmospheric Effects

#### Volumetric Fog Quality
- Options: Off, Low, Medium, High, Ultra
- Default: Medium
- Quality of volumetric fog rendering

#### Fog Density
- Range: 0.0 - 2.0
- Default: 1.0
- Overall thickness of fog

#### Fog Color
- Options: Auto (time-based), Custom
- Default: Auto
- If Custom, allows RGB color picker

#### God Rays Quality
- Options: Off, Low, Medium, High
- Default: Medium
- Quality of volumetric light rays

#### God Rays Intensity
- Range: 0.0 - 1.0
- Default: 0.8
- Brightness of light rays

### Night-Specific Settings

#### Moonlight Color
- Options: Pure Blue, Cool White, Natural, Custom
- Default: Cool White
- Color tone of moonlight illumination

#### Star Intensity
- Range: 0.0 - 2.0
- Default: 1.2
- Brightness of stars in night sky

#### Star Twinkle Speed
- Range: 0.5 - 3.0
- Default: 1.0
- Speed of star twinkling animation

#### Eye Adaptation Speed
- Range: 0.1 - 2.0
- Default: 1.0
- How quickly eyes adapt when moving between bright/dark areas

#### Show Galaxies
- Options: Off, Subtle, Visible
- Default: Subtle
- Display of galaxy texture in night sky

#### Moonveil Effect
- Range: 0.0 - 1.0
- Default: 0.8
- Intensity of volumetric moon rays through foliage

### Day-Specific Settings

#### Sun Color
- Options: Realistic, Warm, Custom
- Default: Realistic
- Color temperature of sunlight

#### Sky Brightness
- Range: 0.5 - 1.5
- Default: 1.0
- Overall sky luminance

#### Saturation
- Range: 0.5 - 1.5
- Default: 1.0
- Color saturation level
- Values < 1.0 desaturate
- Values > 1.0 oversaturate

#### Cloud Quality
- Options: Low, Medium, High, Ultra
- Default: High
- Resolution and complexity of cloud rendering

#### Cloud Speed
- Range: 0.0 - 2.0
- Default: 1.0
- Movement speed of clouds

### Foliage Settings

#### Foliage Waving
- Options: Off, Subtle, Normal, Intense
- Default: Normal
- Animation intensity of grass, leaves, and crops

#### Wave Speed
- Range: 0.5 - 2.0
- Default: 1.0
- Speed of foliage animation

#### Wind Strength
- Range: 0.0 - 1.0
- Default: 0.7
- Amplitude of wind-like movement

### Post-Processing Effects

#### Bloom Strength
- Range: 0.0 - 2.0
- Default: 1.0
- Intensity of bloom/glow effect

#### Bloom Threshold
- Range: 0.5 - 1.0
- Default: 0.8
- Brightness threshold for bloom activation

#### Bloom Quality
- Options: Low, Medium, High, Ultra
- Default: High
- Resolution of bloom blur

#### Temporal Anti-Aliasing
- Options: Off, 1x, 2x, 4x
- Default: 2x
- Strength of anti-aliasing

#### Motion Blur
- Range: 0.0 - 1.0
- Default: 0.0 (disabled)
- Intensity of motion blur effect

#### Lens Flare
- Options: Off, Subtle, Normal, Intense
- Default: Normal
- Intensity of lens flare artifacts

#### Color Grading
- Options: Off, Subtle, Moderate, Strong
- Default: Moderate
- Intensity of cinematic color curves

### Ambient Occlusion

#### AO Quality
- Options: Off, Low, Medium, High, Ultra
- Default: Medium
- Quality of ambient occlusion

#### AO Radius
- Range: 0.5 - 3.0
- Default: 2.0
- Spatial radius for AO calculation

#### AO Strength
- Range: 0.0 - 1.0
- Default: 0.7
- Darkness of AO shadows

### Weather Effects

#### Rain Ripples
- Options: Off, On
- Default: On
- Animated ripple patterns on surfaces during rain

#### Rain Refraction
- Options: Off, On
- Default: On
- View distortion during rain

#### Storm Fog
- Options: Off, Light, Medium, Heavy
- Default: Medium
- Extra fog density during storms

#### Lightning Flash
- Options: Off, Subtle, Normal, Intense
- Default: Normal
- Brightness of lightning illumination

### Signature Effects

#### Enable Moonveil
- Options: Off, On
- Default: On
- Enable volumetric moon rays through forest canopy

#### Enable Starlight Reflections
- Options: Off, On
- Default: On
- Water reflects stars and moonlight at night

#### Enable Night Pulse
- Options: Off, On
- Default: On
- Subtle animated glow in magical biomes

#### Enable Dawn Awakening
- Options: Off, On
- Default: On
- Enhanced sunrise transition effects

#### Enable Twilight Bloom
- Options: Off, On
- Default: On
- Enhanced sunset/sunrise bloom

### Debug Settings

*Note: These are primarily for development. Enable at own risk.*

#### Show Normals
- Options: Off, On
- Visualize surface normals

#### Show Depth
- Options: Off, On
- Visualize depth buffer

#### Show Lighting
- Options: Off, Sun, Moon, Ambient, All
- Isolate individual lighting components

#### Show Shadows
- Options: Off, On
- Visualize shadow map

## Configuration File

### shaders.properties

For advanced users, direct configuration via file:

```properties
# Performance
performance.preset=1
shadow.quality=2
bloom.strength=1.0

# Lighting
light.sunBrightness=1.0
light.moonBrightness=0.6
light.ambientStrength=0.3
light.nightAmbient=0.2

# Night Effects
night.moonColor=1  # 0=blue, 1=cool-white, 2=natural
night.starIntensity=1.2
night.twinkleSped=1.0
night.eyeAdaptSpeed=1.0
night.galaxyQuality=1  # 0=off, 1=subtle, 2=visible

# Water
water.reflectionQuality=2  # 0=off, 1=screen, 2=sky, 3=full
water.refractionStrength=1.0
water.causticIntensity=0.8

# Foliage
foliage.waveQuality=2  # 0=off, 1=subtle, 2=normal, 3=intense
foliage.waveSpeed=1.0
foliage.windStrength=0.7

# Post-Processing
postfx.bloomStrength=1.0
postfx.taaQuality=2  # 0=off, 1=1x, 2=2x, 3=4x
postfx.motionBlur=0.0

# Signature Effects
effects.moonveil=true
effects.starlightReflections=true
effects.nightPulse=true
effects.dawnAwakening=true
effects.twilightBloom=true
```

## Troubleshooting

### Low FPS
1. Lower Performance Preset
2. Reduce Shadow Quality
3. Disable Volumetric Fog
4. Disable Motion Blur and Depth of Field
5. Reduce Bloom Quality

### Visual Artifacts
1. Increase Eye Adaptation Speed
2. Enable Temporal Anti-Aliasing
3. Disable Screen-Space Reflections
4. Verify normal maps are correctly formatted

### Colors Look Wrong
1. Check "Color Grading" intensity
2. Verify "Saturation" setting
3. Reset to defaults and adjust individual sliders

### Night Too Dark
1. Increase "Moon Brightness"
2. Increase "Night Ambient"
3. Increase "Star Intensity"
4. Disable "Eye Adaptation Speed" or reduce value

### Water Looks Strange
1. Reduce "Water Refraction Strength"
2. Reduce "Wave Height"
3. Change "Water Reflection Quality"
4. Verify GPU supports normal mapping
