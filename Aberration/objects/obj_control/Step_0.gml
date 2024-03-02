///@desc

dx = (dx-window_mouse_get_delta_x()/10+360)%360;
dy = clamp(dy-window_mouse_get_delta_y()/10,-89,89);

var _kb,_kf,_ks,_ku;
_kb = 0.2+0.8*keyboard_check(vk_shift);
_kf = (keyboard_check(ord("W")) - keyboard_check(ord("S")))*_kb;
_ks = (keyboard_check(ord("D")) - keyboard_check(ord("A")))*_kb;
_ku = (keyboard_check(ord("E")) - keyboard_check(ord("Q")))*_kb;

vx = lerp(vx, (+_kf*dcos(dx)+_ks*dsin(dx))*dcos(dy), 0.2);
vy = lerp(vy, (-_kf*dsin(dx)+_ks*dcos(dx))*dcos(dy), 0.2);
vz = lerp(vz, (+_kf*dsin(dy)+_ku), 0.2);

px += vx;
py += vy;
pz += vz;

if (keyboard_check(vk_escape)) game_end();