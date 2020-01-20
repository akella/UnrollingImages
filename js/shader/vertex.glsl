uniform float time;
uniform float angle;
uniform float progress;
uniform vec4 resolution;
varying vec2 vUv;
varying float vFrontShadow;
// varying float vBackShadow;
// varying float vProgress;

uniform sampler2D texture1;
uniform sampler2D texture2;
uniform vec2 pixels;

const float pi = 3.1415925;

mat4 rotationMatrix(vec3 axis, float angle) {
    axis = normalize(axis);
    float s = sin(angle);
    float c = cos(angle);
    float oc = 1.0 - c;
    
    return mat4(oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,  0.0,
                oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,  0.0,
                oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c,           0.0,
                0.0,                                0.0,                                0.0,                                1.0);
}
vec3 rotate(vec3 v, vec3 axis, float angle) {
  mat4 m = rotationMatrix(axis, angle);
  return (m * vec4(v, 1.0)).xyz;
}




void main() {
  vUv = uv;
  float pi = 3.14159265359;


  float finalAngle = angle - 0.*0.3*sin(progress*6.);

  // @todo account for aspect ratio!!!
  vec3 newposition = position;

  // float angle = pi/10.;
  float rad = 0.1;
  float rolls = 8.;
  // rot
  newposition = rotate(newposition - vec3(-.5,.5,0.), vec3(0.,0.,1.),-finalAngle) + vec3(-.5,.5,0.);

  float offs = (newposition.x + 0.5)/(sin(finalAngle) + cos(finalAngle)) ; // -0.5..0.5 -> 0..1
  float tProgress = clamp( (progress - offs*0.99)/0.01 , 0.,1.);

  // shadows
  vFrontShadow = clamp((progress - offs*0.95)/0.05,0.7,1.);
  // vBackShadow = 1. - clamp(abs((progress - offs*0.9)/0.1),0.,1.);
  // vProgress = clamp((progress - offs*0.95)/0.05,0.,1.);

  

  newposition.z =  rad + rad*(1. - offs/2.)*sin(-offs*rolls*pi - 0.5*pi);
  newposition.x =  - 0.5 + rad*(1. - offs/2.)*cos(-offs*rolls*pi + 0.5*pi);
  // // rot back
  newposition = rotate(newposition - vec3(-.5,.5,0.), vec3(0.,0.,1.),finalAngle) + vec3(-.5,.5,0.);
  // unroll
  newposition = rotate(newposition - vec3(-.5,0.5,rad), vec3(sin(finalAngle),cos(finalAngle),0.), -pi*progress*rolls);
  newposition +=  vec3(
    -.5 + progress*cos(finalAngle)*(sin(finalAngle) + cos(finalAngle)), 
    0.5 - progress*sin(finalAngle)*(sin(finalAngle) + cos(finalAngle)),
    rad*(1.-progress/2.)
  );

  // animation
  vec3 finalposition = mix(newposition,position,tProgress);
  gl_Position = projectionMatrix * modelViewMatrix * vec4(finalposition, 1.0 );
}


