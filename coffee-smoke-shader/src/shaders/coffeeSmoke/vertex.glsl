uniform float uTime;
uniform sampler2D uPerlinTexture;

varying vec2 vUv;

#include ../includes/rotate2D.glsl

void main()
{

  // creating a new variable so that we can modify the position since the latter is an attribute
  vec3 newPosition = position;

  // Twist
  // using the perlin texture to add randomness to the twist
  float twistPerlin = texture(
    uPerlinTexture, 
    vec2(0.5, uv.y * 0.2 - uTime * 0.005)
    ).r;
  float angle = twistPerlin * 10.0;
  // need to send in the base position and the angle respectively
  newPosition.xz = rotate2D(newPosition.xz, angle);


  // Wind offset - -0.5 at the end is so that it doesn't only blow in the positive direction but also in the negative
  // 0.25 and 0.75 are so that we pick 2 different random values from the texture, they can be replaced by any value
  vec2 windOffset = vec2(
    texture(uPerlinTexture, vec2(0.25, uTime * 0.01)).r - 0.7,
    texture(uPerlinTexture, vec2(0.75, uTime * 0.01)).r - 0.7
  );
  // we multiply it by uv.y so that the bottom of steam doesnt get blown away. 
  // we do power 2 so that we get the value curved, meaning the steam won't get blown away in a straight line
  windOffset *= pow(uv.y, 2.0) * 5.0;
  newPosition.xz += windOffset;

  // Final position  
  gl_Position = projectionMatrix * modelViewMatrix * vec4(newPosition, 1.0);

  // varying
  vUv = uv;

}