#version 460 core

#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform sampler2D iChannel0;

out vec4 fragColor;

const float pi = 3.1415926539;

float sat(float x)
{
    return clamp(0., 1., x);
}

vec3 sat(vec3 v)
{
    return vec3(sat(v.x), sat(v.y), sat(v.z));
}

vec3 pow3(vec3 v, float p)
{
    return vec3(pow(v.x, p), pow(v.y, p), pow(v.z, p));
}

void mainImage( out vec4 fragColor, in vec2 fragCoord, in vec2 fragSize)
{
    vec2 uv = fragCoord/fragSize.xy;

    vec2 r = vec2(fragSize.x/fragSize.y, 1.);

    float p = 100.;

    float po = 4.;
    float x =  cos(uv.x*pi*p*r.x-0.9);
    float y =  sin(uv.x*pi*p*r.x-1.5);
    float z = -cos(uv.x*pi*p*r.x+.9);
    vec3 grid = pow3(sat(pow3(vec3(x, y, z), po)-.3), .5);
    float g = pow(abs(cos(uv.y*pi*p*r.y)), .3);
    grid *= g;
    grid *= 1.5;

    uv = round(uv*p*r)/(p*r);

    vec3 c = texture(iChannel0, uv).rgb;

    vec3 col = grid*c;

    fragColor = vec4(col, 1.0);
}

void main() {
    mainImage(fragColor, FlutterFragCoord(), uSize);
}
