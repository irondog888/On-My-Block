#pragma header

uniform float u_distort;
uniform vec2 u_scale;
uniform vec2 u_offset;

uniform float u_time;

uniform float u_mix;

void main() {
    gl_FragColor = vec4(vec3(0.0), 1.0);
    if (u_mix <= 0.0) {
        return;
    }
    
    vec2 uv = (openfl_TextureCoordv - 0.5) * openfl_TextureSize / openfl_TextureSize.y;
    uv *= (1.0 + u_distort * (uv.x * uv.x + uv.y * uv.y)) / u_scale;
    
    vec2 coord = uv * openfl_TextureSize;
    vec2 offset = u_offset / u_scale;
	vec2 uvd = uv + floor(u_time) + offset / 4.0;
    
    for (float i = 0.0; i <= 7.0; i++) {
        uvd *= 1.5;
        vec4 v = fract(floor(uvd + i * offset / 2.0).xyxy * vec4(0.1031, 0.1030, 0.0973, 0.1099));
        v += dot(v, v.wzxy + 33.33);
        v = fract(v.zywx * (v.xxyz + v.yzzw));
        
        uvd += v.z * v.xy * vec2(1.0, 2.0) * fract(uvd + i + floor((u_time + 1e2) / (v.z + 1.0)) * (v.z + 1.0) * v.y);
        
        if (i < 2.0 || v.w > 0.9) {
            gl_FragColor = step(0.5, v);
        }
    }
    
    vec3 n = vec3(vec2(coord.x / 2.0, coord.y) * 0.75 + (offset + 8192.0) * openfl_TextureSize.x / 16.0, float(int(u_time * 9.0))) * vec3(5332.0, 2524.0, 7552.0);
    for (int i = 0; i < 4; i++) {
        n = fract(n / 8.0 + fract(n * vec3(0.1031, 0.1030, 0.0973)));
        n += dot(n, n.yxz + 33.33);
        n = fract(n.zyx * (n + n.yzx));
    }
    
    gl_FragColor.rgb += n * (gl_FragColor.r - gl_FragColor.g - gl_FragColor.b) / exp2(33.0);
    gl_FragColor.rgb = min(u_mix * vec3(1.0 - (gl_FragColor.r + gl_FragColor.g + gl_FragColor.b) / 3.0) + (1.0 - u_mix) + length(uv * u_scale / 2.0) * u_mix * 4.0, 1.0);
}