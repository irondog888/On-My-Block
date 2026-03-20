#pragma header

uniform float intensity;       // 0.0 - 1.0
uniform float contrast;        // 1.0 = normal, >1 = high contrast
uniform float bloomIntensity;  // 0.0 - 1.0
uniform float blurAmount;      // 0.0 - 1.0

uniform float shadowR;
uniform float shadowG;
uniform float shadowB;

uniform float highlightR;
uniform float highlightG;
uniform float highlightB;

vec3 applyContrast(vec3 c, float k) {
    return (c - 0.5) * k + 0.5;
}

vec3 getBlur(vec2 uv, float amount) {
    vec3 blur = vec3(0.0);
    float offset = amount * 0.002;
    
    for(int x=-1;x<=1;x++){
        for(int y=-1;y<=1;y++){
            blur += flixel_texture2D(bitmap, uv + vec2(float(x)*offset, float(y)*offset)).rgb;
        }
    }
    
    return blur / 9.0;
}

vec3 getBloom(vec2 uv) {
    vec3 bloom = vec3(0.0);
    float offset = 0.004;
    
    for(int i=-2;i<=2;i++){
        for(int j=-2;j<=2;j++){
            vec2 sampleUV = uv + vec2(float(i), float(j)) * offset;
            vec3 sample = flixel_texture2D(bitmap, sampleUV).rgb;
            float brightness = dot(sample, vec3(0.299, 0.587, 0.114));
            if(brightness > 0.6) bloom += sample * (brightness - 0.6);
        }
    }
    
    return bloom / 25.0;
}

vec3 getGlare(vec2 uv, vec3 color) {
    float l = dot(color, vec3(0.299, 0.587, 0.114));
    if(l > 0.7){
        vec2 center = uv - 0.5;
        float angle = atan(center.y, center.x);
        float star = abs(sin(angle * 2.0)) * 0.3;
        star += abs(cos(angle * 2.0)) * 0.3;
        return color * (1.0 + star * (l - 0.7) * 2.0);
    }
    return color;
}

void main() {
    vec4 col = flixel_texture2D(bitmap, openfl_TextureCoordv);

    vec3 blurred = mix(col.rgb, getBlur(openfl_TextureCoordv, blurAmount), blurAmount * 0.3);
    vec3 bloom = getBloom(openfl_TextureCoordv);
    float l = dot(blurred, vec3(0.299, 0.587, 0.114));

    vec3 shadow = vec3(shadowR, shadowG, shadowB);
    vec3 highlight = vec3(highlightR, highlightG, highlightB);
    vec3 dynamicColor = mix(shadow, highlight, clamp(l, 0.0, 1.0));

    dynamicColor = applyContrast(dynamicColor, contrast);
    dynamicColor += bloom * bloomIntensity * highlight;
    dynamicColor = getGlare(openfl_TextureCoordv, dynamicColor);

    vec3 finalCol = mix(blurred, dynamicColor, intensity);

    gl_FragColor = vec4(clamp(finalCol, 0.0, 1.0), col.a);
}
