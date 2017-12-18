precision highp float;
uniform vec2 u_c;
uniform vec2 u_scale;
uniform vec2 u_offset;
varying vec2 v_coord;

void main() {
    vec2 z = vec2((v_coord[0]-u_offset[0])*u_scale[0], -(1.0-v_coord[1]-u_offset[1])*u_scale[1]);
    int iterations = 100;

    for (int i = 0; i < 100; ++i) {
        float x = z[0];
        float y = z[1];

        z[0] = x*x - y*y + u_c[0];
        z[1] = 2.0*x*y + u_c[1];

        float m = sqrt(z[0]*z[0] + z[1]*z[1]);

        if (m > 2.0) {
            iterations = i;
            break;
        }
    }

    gl_FragColor = vec4(float(iterations)/32.0, 0.0, 0, 1.0);
}
