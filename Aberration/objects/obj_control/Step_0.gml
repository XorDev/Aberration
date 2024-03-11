///@desc

tx = lerp(tx,window_mouse_get_delta_x()/10,0.05);
ty = lerp(ty,window_mouse_get_delta_y()/10,0.05);

dx = (dx-tx+360)%360;
dy = clamp(dy-ty,-89,89);

var _kb,_kf,_ks,_ku;
_kb = (.2+.8*keyboard_check(vk_shift))/(1+4*keyboard_check(vk_control));
_kf = (keyboard_check(ord("W")) - keyboard_check(ord("S")))*_kb;
_ks = (keyboard_check(ord("D")) - keyboard_check(ord("A")))*_kb;
_ku = (keyboard_check(ord("E")) - keyboard_check(ord("Q")))*_kb;

vx = lerp(vx, (+_kf*dcos(dx)+_ks*dsin(dx))*dcos(dy), 0.03);
vy = lerp(vy, (-_kf*dsin(dx)+_ks*dcos(dx))*dcos(dy), 0.03);
vz = lerp(vz, (+_kf*dsin(dy)+_ku), 0.03);

px += vx;
py += vy;
pz += vz;

if (keyboard_check(vk_escape)) game_end();

if keyboard_check_pressed(vk_space) map = [.4+random(.2),random(6),random(1),random(1)];


if keyboard_check_pressed(ord("2"))
{
	debug = !debug;
	show_debug_overlay(debug);
}

if keyboard_check_pressed(vk_enter)
{
	locked = !locked;
	window_mouse_set_locked(locked);
}