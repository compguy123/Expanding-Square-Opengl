#version 400

in vec4 vPosition;
in vec4 vNormal;
out vec4 color;

uniform vec4 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform mat4 ModelView;


void main()
{
  // move each side of quad form 0 z to its respective pos , need to do it here for radius calc
    gl_Position =ModelView*vPosition;  
   
}
