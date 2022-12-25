#version 460 core

#include <flutter/runtime_effect.glsl>

uniform vec2 uResolution;
uniform float uTilings;
uniform sampler2D uImage;

out vec4 fragColor;

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // 1 to 1 aspect ratio pixel coordinates.
    vec2 uv = fragCoord/uResolution.y;

    // Scale, smoothing factor and scaling.
    float sf = uTilings/uResolution.y;
    vec2 p = uv*uTilings;

    // Cell dimensions.
    const vec2 s = vec2(1.7320508, 1);

    // The hexagon centers.
    vec4 hC = floor(vec4(p, p - vec2(1, .5))/s.xyxy) + .5;

    // Centering the coordinates with the hexagon centers above.
    vec4 h = vec4(p - hC.xy*s, p - (hC.zw + .5)*s);

    // Local coordinates and ID or nearest hexagon center.
    h = dot(h.xy, h.xy)<dot(h.zw, h.zw) ? vec4(h.xy, hC.xy) : vec4(h.zw, hC.zw + .5);

    // The iChannel display pictures are deceiving, as they have been stretched
    // to fit. The UV hexagon coordinates are in 1 to 1 form, so we're restretching
    // the texture to fit... Confused? So am I.
    vec2 stretch = vec2(uResolution.y/uResolution.x, 1);

    // Hexagon cell color.
    // ID, scaled by the hexagon dimension, the overall scale and
    // the stretch vector.
    vec4 col = texture(uImage, h.zw*s/uTilings*stretch);
    col *= col; // Rough sRGB to linear.

    // Borders, if you wanted them.
    h.xy = abs(h.xy);
    float hex = max(dot(h.xy, s*.5), h.y) - .45;
    col = mix(col, vec4(0), smoothstep(0., sf, hex));

    // Rough gamma correction.
    fragColor = sqrt(max(col, 0.));
}

void main() {
    mainImage(fragColor, FlutterFragCoord());
}
