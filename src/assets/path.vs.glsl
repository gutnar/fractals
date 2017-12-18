precision highp float;
uniform vec2 u_scale;
uniform vec2 u_offset;
attribute vec3 a_vertex;
varying float v_color;

void main() {
    //vec2 z = vec2((v_coord[0]-u_offset[0])*u_scale[0], (-1.0+v_coord[1]+u_offset[1])*u_scale[1]);
    gl_Position = vec4(a_vertex[0]/u_scale[0]*2.0, a_vertex[1]/u_scale[1]*2.0, 1.0, 1.0);
    v_color = a_vertex[2]/100.0;
    //gl_Position = vec4(a_vertex[0], a_vertex[1], 1.0, 1.0);
}
