uniform float time;
uniform float progress;
uniform sampler2D texture1;
uniform sampler2D texture2;
uniform vec4 resolution;

varying vec2 vUv;
varying float vFrontShadow;
varying float vBackShadow;




void main()	{
	vec2 newUV = (vUv - vec2(0.5))*resolution.zw + vec2(0.5);

	gl_FragColor = texture2D(texture1,newUV);
    gl_FragColor.rgb *=vFrontShadow;
	if (!gl_FrontFacing){
		gl_FragColor =gl_FragColor/2. + vec4(0.,0.,0.,0.5);
        gl_FragColor +=vec4(vBackShadow/2.);
	}
    gl_FragColor.a = clamp(progress*5.,0.,1.);
}