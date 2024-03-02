///@desc

gpu_set_tex_repeat(true);

var _cx,_cy;
_cx = window_get_width()/2;
_cy = window_get_height()/2;

window_mouse_set(_cx,_cy);
window_mouse_set_locked(true);
window_set_cursor(cr_cross);

dx = 0;
dy = 0;

px = 0;
py = 0;
pz = 20;

vx = 0;
vy = 0;
vz = 0;

u_dir = shader_get_uniform(shd_render,"u_dir");
u_pos = shader_get_uniform(shd_render,"u_pos");