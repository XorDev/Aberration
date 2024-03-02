varying vec2 v_coord;

uniform vec3 u_dir;
uniform vec3 u_pos;

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
	v.xy = abs(mod(p.xy,676.)-338.)-169.;
	float d = min(p.z,dist_box(v,vec3(80,50,40)));
	
	mat2 m = rotate2D(2.5);
	
	for(float i=1e2; i>0.1; i*=.4)
	{
		v.xy *= m;
		//v.zx *= m;
		v.z += .2*i;
        //Subtract cube SDFs
		v = i*vec3(.9,.8,.4) - abs(mod(v,i*2.)-i);
		float _d = max(0., min(v.x,min(v.y,v.z))) - length(min(v,0.));
		d = max(_d,d);
	}
	return d;
}

vec4 raymarch(vec3 p, vec3 d, const int num, float eps, float far)
{
	vec4 m = vec4(p+d*.01, .01);
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
	/*float l = 1.0;
	vec4 m = vec4(p+d*start, start);
	for(int i = 0; i<STEPS; i++)
	{
		float s = dist(m.xyz);
		m += vec4(d*s,s);
		l = min(l,s/m.w*9.);
		
		if (l<=0.0) return 0.0;
		if (m.w>=end || (m.z>40. && d.z>0.)) return l;
	}
	return l;	
	
	*/
	float l = 1.0;
	float j = 0.0;
	for(float i = start*(.5+n.a); i<end; i*=1.4)
	{
		l *= clamp(dist(p+d*i)*9./i,0.002,1.);
		j++;
	}
	return pow(l,2./j);
}

vec3 normal(vec3 p, float E)
{
    vec2 e = vec2(2, -2)* E;
	    
    return normalize(dist(p+e.xxy)*e.xxy + dist(p+e.xyx)*e.xyx + dist(p+e.yxx)*e.yxx + dist(p+e.y)*e.y);
}
void main()
{
	vec4 tex = texture2D(gm_BaseTexture, gl_FragCoord.xy/256.);
	
	vec3 ray = vec3((v_coord - 0.5) * vec2(16./9.,1)*2., 1.0);
	vec3 Z = u_dir;
	vec3 X = normalize(cross(Z, vec3(0,0,-1)));
	vec3 Y = normalize(cross(X, Z));
	
	float E = EPS/length(ray);
	ray = normalize(mat3(X,Y,Z) * ray);
	vec4 m = raymarch(u_pos, ray, STEPS, E, FAR);
	
	//vec3 n = normal(m.xyz, E);
	vec3 dif = tex.rgb;//vec3(1,2,7);//vec3(0,0,-5) - m.xyz;
	float len = length(dif);
	vec3 r = dif/len;//sqrt(vec3(.1,.2,.7));//normalize(tex.rgb-.5);
	//r *= sign(dot(r,n));
	
	float fog = max(m.w/FAR,0.);
	
	float l = shadow(mix(m.xyz,u_pos,0.), r, tex, .005*m.w, (m.w));
	
    gl_FragColor = vec4(l,l,l,1);//pow(vec3(fog),vec3(1,.5,.2))
}