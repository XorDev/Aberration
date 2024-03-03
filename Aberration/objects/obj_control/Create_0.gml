///@desc

w = window_get_width()/2;
h = window_get_height()/2;
surface_resize(application_surface,w,h);
display_set_gui_size(w,h);

back_surf = -1;

debug = 0;
locked = true;

randomize();
gpu_set_tex_repeat(true);

window_mouse_set(w/2,h/2);
window_mouse_set_locked(locked);
window_set_cursor(cr_cross);

tx = 0;
ty = 0;
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
u_vel = shader_get_uniform(shd_render,"u_vel");
u_map = shader_get_uniform(shd_render,"u_map");
u_ran = shader_get_uniform(shd_render,"u_ran");
u_noise = shader_get_sampler_index(shd_render,"u_noise");

t_noise = -1;

map = [.4, 2.5, .2, .8];