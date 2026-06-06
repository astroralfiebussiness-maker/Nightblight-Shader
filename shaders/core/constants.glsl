// NightBlight Core Constants
// Physical and visual constants used throughout shaders

#ifndef NIGHTBLIGHT_CONSTANTS
#define NIGHTBLIGHT_CONSTANTS

// Pi and math constants
const float PI = 3.14159265359;
const float TWO_PI = 6.28318530718;
const float HALF_PI = 1.5707963268;
const float INV_PI = 0.31830988618;
const float INV_TWO_PI = 0.15915494309;

// Lighting constants
const vec3 SUNLIGHT_COLOR = vec3(1.0, 0.95, 0.8);
const vec3 MOONLIGHT_COLOR = vec3(0.1, 0.2, 0.4);
const vec3 NIGHT_SKY_COLOR = vec3(0.01, 0.01, 0.02);
const vec3 DAY_SKY_COLOR = vec3(0.4, 0.65, 1.0);
const vec3 HORIZON_COLOR = vec3(0.8, 0.7, 0.5);

// Physical constants
const float ATMOSPHERE_DENSITY = 0.08;
const float RAYLEIGH_COEFFICIENT = 0.00076;
const float MIE_COEFFICIENT = 0.0015;

// Shadow constants
const float SHADOW_BIAS = 0.002;
const float SHADOW_DISTANCE_FADE = 0.2;

// Performance thresholds
const float NORMAL_THRESHOLD = 0.01;
const float DEPTH_THRESHOLD = 0.999;
const float EMISSIVE_THRESHOLD = 0.9;

// Gamma correction
const float GAMMA = 2.2;
const float INV_GAMMA = 1.0 / 2.2;

#endif
