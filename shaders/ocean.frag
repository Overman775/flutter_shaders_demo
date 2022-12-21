#include <flutter/runtime_effect.glsl>

uniform vec2 iResolution;
uniform float iTime;

out vec4 fragColor;

const int MAX_MARCH = 15;
const int OCTAVE = 5;
const mat2 OCTAVE_M = mat2(1.6,1.2,-1.2,1.6);
const float EPSILON = 0.001;  // big epsilon is important to suppress noise
const vec3 SUN = normalize(vec3(0.0, 1.0, -1.0));
const vec3 WATER_LIGHTEST = vec3(0.6,0.7,0.5);
const vec3 WATER_DARKEST = vec3(0.1,0.2,0.25);
const float SEA_CHOPPY = 4.0;
const float SEA_HEIGHT = 0.6;


float random(vec2 p) {
    return fract(sin(dot(p, vec2(123.45, 678.9))) * 987654.321);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = random(i), c = random(i + vec2(0., 1.)),
        b = random(i + vec2(1., 0.)), d = random(i + 1.);
    vec2 u = smoothstep(0., 1., f);
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

float single_octave(vec2 uv) {
    uv = sin(uv + 2.0 * noise(uv) - 1.0);
    return pow(1.0 - pow(uv.x * uv.y, 1.5), SEA_CHOPPY);
}

float socean(vec3 pos) {
    vec2 p = pos.xz;
    p.x *= 0.5;
    float h = 0.0;
    float amp = SEA_HEIGHT;
    float freq = 0.2;

    float t = 100.0;
    t = iTime * 0.5;

    for (int i = 0; i < OCTAVE; ++i) {
        h += (single_octave((p - t) * freq) + single_octave((p + t) * freq)) * amp;
        p *= OCTAVE_M;
        amp *= 0.2;
        freq *= 2.0;
    }
    return pos.y - h;
}

float sdscene(vec3 pos) {
    return socean(pos);
}

vec3 normal(vec3 pos) {
    vec2 e0 = vec2(EPSILON, 0.);
    float d = sdscene(pos);
    return normalize(vec3(sdscene(pos + e0.xyy), sdscene(pos + e0.yxy), sdscene(pos + e0.yyx)) - d);
}

// bteitler: Generate a smooth sky gradient color based on ray direction's Y value
// sky
vec3 csky(vec3 e) {
    e.y = max(e.y, 0.0);

    vec3 ret;
    ret.g = 1.0 - e.y;
    ret.r = pow(ret.g, 3.0);
    ret.b = 0.6 + ret.g * 0.4;
    return ret;
}

float raymarch(vec3 pos, vec3 dir) {
    float res = .0;
    for (int i = 0; i < MAX_MARCH; ++i) {
        float r = sdscene(pos);
        res += r;
        if (r <= EPSILON) {
            break;
        }
        pos += dir * r;
    }
    return res;
}

vec3 shade(vec3 pos, vec3 eye, float d) {
    vec3 n = normal(pos);
    vec3 l = SUN;
    // direct light from the sun
    vec3 reflected = csky(reflect(eye, n)) * 0.5 + 10.0 * pow(max(dot(eye, reflect(l, n)), 0.0), 100.0);
    // indirect light from the sun through water
    vec3 refracted = WATER_DARKEST +  WATER_LIGHTEST * pow(0.4 * dot(n, l) + 0.6, 100.0) * 0.1;
    refracted += WATER_LIGHTEST * 0.2 * (pos.y - 2.0 * SEA_HEIGHT);

    float fresnel = 1.0 - max(dot(n,-eye),0.0);
    float f0 = 0.1;
    fresnel = f0 + (1.0 - f0) * pow(fresnel,5.0) * 0.65;
    return mix(refracted, reflected, fresnel);
}

vec3 cocean(vec3 cp, vec3 cd) {
    float d = raymarch(cp, cd);
    return shade(cp + d * cd, cd, d);
}

void camera(out vec3 ro, out vec3 rd, vec2 fragCoord) {
    vec2 uv = (2.0 * fragCoord - iResolution.xy) / min(iResolution.x, iResolution.y);

    float t = iTime * 0.1;

    vec3 cd = normalize(vec3(
        2.0 * noise(vec2(t * 2.0, t * -0.5)) - 1.0,
        2.0 * noise(vec2(t * 0.5, -t * 2.0)) - 2.0,
        -2.0
    ));

    vec3 cr = normalize(cross(cd, vec3(0.25 * (2.0 * noise(vec2(t, -t)) - 1.0), 1.0, 0.0)));
    vec3 cu = cross(cr, cd);
    ro = vec3(2.0 * noise(vec2(t * 1.2, -t * 3.4) - 1.0), SEA_HEIGHT * 5.0, -t * 8.0);
    rd = normalize(cr * uv.x + cu * uv.y + cd);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
    vec2 uv = (2.0 * fragCoord - iResolution.xy) / min(iResolution.x, iResolution.y);

    vec3 ro, rd;
    camera(ro, rd, fragCoord);

    vec3 color = mix(
        csky(rd),
        cocean(ro, rd),
        pow(smoothstep(0.0,-0.05,rd.y), 0.3) // bteitler: Can be thought of as "fog" that gets thicker in the distance
    );

    // Output to screen
    fragColor = vec4(pow(color, vec3(1.0/2.2)), 1.0);
}

void main() {
    mainImage(fragColor, FlutterFragCoord());
}
