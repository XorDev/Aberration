///@desc

t_noise = sprite_get_texture(spr_noise,image_index);

if !surface_exists(back_surf) back_surf = surface_create(w,h);

gpu_set_blendenable(false);
surface_set_target(back_surf);
draw_surface(application_surface,0,0);
surface_reset_target();

surface_set_target(application_surface);
shader_set(shd_render);
shader_set_uniform_f(u_pos,px,py,pz);
shader_set_uniform_f(u_vel,vx,vy,vz);
shader_set_uniform_f(u_dir,dcos(dx)*dcos(dy),-dsin(dx)*dcos(dy),dsin(dy),2+point_distance_3d(0,0,0,vx,vy,vz));
shader_set_uniform_f_array(u_map,map);
shader_set_uniform_f(u_ran,random(1),random(1));
texture_set_stage(u_noise,t_noise);

draw_surface(back_surf,0,0);
shader_reset();
surface_reset_target();

draw_surface(application_surface,0,0);
gpu_set_blendenable(true);


draw_set_color(#FF0000);
if keyboard_check(ord("1")) draw_text(8,8,map);
if keyboard_check(ord("2")) draw_text(8,32,fps);