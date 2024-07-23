uniform sampler2D uPerlinTexture;
uniform float uTime;

varying vec2 vUv;

void main()
{

  // Scale smoke
  vec2 smokeUv = vUv;
  smokeUv.x *= 0.5;
  smokeUv.y *= 0.3;
  smokeUv.y -= uTime * 0.03;


  // Smoke - we only retrieve the r value (could do g or b) bc it's a gray scale color and all the values are the same
  float smoke = texture(uPerlinTexture, smokeUv).r;

  // rRemap - to make the transition smoother. it blends some of the values to 0 making them almost invisible
  // first value is where to start, second is where to end, 3rd is the value we want to remap
  smoke = smoothstep(0.4, 1.0, smoke);

  // Edges
  smoke *= smoothstep(0.0, 0.1, vUv.x);
  smoke *= smoothstep(1.0, 0.9, vUv.x);

  smoke *= smoothstep(0.0, 0.1, vUv.y);
  smoke *= smoothstep(1.0, 0.4, vUv.y);


  // Final color
  gl_FragColor = vec4(0.6, 0.3, 0.2, smoke);
    // gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);


  // the below code correspond to codes in the shaders code in three.js, meaning it will automatically get replaced with the appropriate code
  #include <tonemapping_fragment>
  #include <colorspace_fragment>
}