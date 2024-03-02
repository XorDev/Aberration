///@desc

shader_set(shd_render);
shader_set_uniform_f(u_pos,px,py,pz);
shader_set_uniform_f(u_dir,dcos(dx)*dcos(dy),-dsin(dx)*dcos(dy),dsin(dy));

draw_sprite_stretched(spr_noise,-1,0,0,1920,1080);
shader_reset();