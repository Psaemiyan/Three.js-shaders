uniform float uSize;
uniform float uTime;

attribute float aScale;
attribute vec3 aRandomness;
varying vec3 vColor;

void main()
{
  /**
    * Position
    */
  vec4 modelPosition = modelMatrix * vec4(position, 1.0);

  // spin
  float angle = atan(modelPosition.x, modelPosition.z);
  float distanceToCenter = length(modelPosition.xz);
  float angleOffset = (1.0 / distanceToCenter) * uTime * 0.2;
  angle += angleOffset;
  modelPosition.x = cos(angle) * distanceToCenter;
  modelPosition.z = sin(angle) * distanceToCenter;

  // Randomness
  modelPosition.xyz += aRandomness;



  vec4 viewPosition = viewMatrix * modelPosition;
  vec4 projectedPosition = projectionMatrix * viewPosition;
  gl_Position = projectedPosition;



  /**
    * Size
    */
  gl_PointSize = uSize * aScale;
  // formula for size attenuation - taken from three js docs in the points.glsl.js file
  gl_PointSize *= ( 1.0 / - viewPosition.z );


  /**
    * color
  */
  vColor = color;


}