varying vec2 v_coord;

void main()
{
    gl_FragColor = texture2D( gm_BaseTexture, v_coord);
}