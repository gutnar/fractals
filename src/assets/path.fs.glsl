precision highp float;
varying float v_color;

void main() {
    gl_FragColor = vec4(0.0, v_color, 1.0, 1.0);
}
