varying vec2 v_coord;

uniform vec4 u_dir;//dx,dy,dz,fov ratio
uniform vec3 u_pos;
uniform vec3 u_vel;
uniform vec4 u_map;
uniform vec2 u_ran;
uniform sampler2D u_noise;

#define STEPS 100
#define EPS 5e-4
#define FAR 1e3

mat2 rotate2D(float a)
{
	//float c = cos(a);
	//float s = sin(a);
	return mat2(cos(a),-sin(a),sin(a),cos(a));	
}
float dist_box(vec3 p,vec3 b)
{
	vec3 a = b-abs(p);
	return length(min(a,0.)) - max(0.,min(a.x,min(a.y,a.z)));
}
float dist(vec3 p)
{
	vec3 v = p;
	vec2 s = 50.+200.*u_map.zw;
	v.xy = abs(mod(p.xy,s*4.)-s*2.)-s;
	float d = min(p.z,dist_box(v,vec3(s*.3,40)));
	
	mat2 m = rotate2D(u_map[1]);
	
	for(float i=1e2; i>0.1; i*=u_map[0])
	{
		v.xy *= m;
		//v.zx *= m;
		v.z += u_map[2]*i;
        //Subtract cube SDFs
		v = i*vec3(.9,u_map[3],.4) - abs(mod(v,i*2.)-i);
		float _d = max(0., min(v.x,min(v.y,v.z))) - length(min(v,0.));
		d = max(_d,d);
	}
	return d;
	//return min(length(cos(p*.4)-.9)/.4-1.,p.z+1.);
}

vec4 raymarch(vec3 p, vec3 d, vec4 n, const int num, float eps, float far)
{
	vec4 m = vec4(p+d*n.a*3., n.a*3.);
	for(int i = 0; i<num; i++)
	{
		float s = dist(m.xyz);
		m += vec4(d*s,s);
		
		if (s<eps*m.w) break;
		if (m.w>=far || (m.z>40. && d.z>0.)) return vec4(p+d*far, far);
	}
	return m;	
}
float shadow(vec3 p, vec3 d, vec4 n, float start, float end)
{
	float l = 1.0;
	vec4 m = vec4(p+d*start, start);
	for(int i = 0; i<STEPS; i++)
	{
		float s = dist(m.xyz);
		m += vec4(d*s,s);
		if (m.w>=end || (m.z>40. && d.z>0.)) break;
		
		l = min(l,s/m.w*9.);
		if (l<=0.0) return 0.0;
	}
	return l;
	
	
	/*
	float l = 1.0;
	float j = 0.0;
	for(float i = start*(.5+n.a); i<end; i*=1.5)
	{
		l *= clamp(dist(p+d*i)*9./i,0.000,1.);
		j++;
	}
	return pow(l,2./j);
	*/
}

vec3 normal(vec3 p, float E)
{
    vec2 e = vec2(2, -2)* E;
	    
    return normalize(dist(p+e.xxy)*e.xxy + dist(p+e.xyx)*e.xyx + dist(p+e.yxx)*e.yxx + dist(p+e.y)*e.y);
}
void main()
{
	vec4 noi = texture2D(u_noise, gl_FragCoord.xy/256.+u_ran);
	vec4 back = texture2D(gm_BaseTexture, v_coord);
	
	vec3 ray = vec3((v_coord - 0.5) * vec2(16./9.,1)*u_dir.w, 1.0);
	vec3 Z = u_dir.xyz;
	vec3 X = normalize(cross(Z, vec3(0,0,-1)));
	vec3 Y = normalize(cross(X, Z));
	
	float E = EPS/length(ray);
	ray = normalize(mat3(X,Y,Z) * ray);
	vec3 p = u_pos +u_vel*noi.a*5.0;
	vec4 m = raymarch(p, ray, noi, STEPS, E, FAR);
	
	float fog = smoothstep(20.0,-60.,m.z);
	//vec3 n = normal(m.xyz, E);
	
	vec3 scatter = mix(m.xyz,p,noi.r);
	vec3 dif = (noi.rgb-.5)*0. - (scatter-u_pos-u_dir.xyz*u_dir.w*3.0+u_vel*8.0);//mix(noi.rgb,vec3(1,2,7),noi.a*noi.a*noi.a);//vec3(0,0,-5) - m.xyz;
	float len = length(dif);
	vec3 r = dif/len;//sqrt(vec3(.1,.2,.7));//normalize(noi.rgb-.5);
	
	float l = shadow(scatter, r, noi, 0.01*m.w, len);//min(4.*m.w, 
	//l *= shadow(mix(m.xyz,p,(noi.r)*fog*.1), r, noi, 0.01*m.w,min(4.*m.w,len));
	
    gl_FragColor = vec4(l/(1.+len/5e0),pow(back.rg,vec2(.8)),1);//pow(vec3(fog),vec3(1,.5,.2))
}