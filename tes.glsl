#version 400

// tessellation evaluation shader

// this is invoked from the TCS, once for each generated vertex
// like a vertex shader, it needs to output vertex position in gl_Position
// as input, it receives:
//  - gl_in[GL_PATCH_VERTICES] as the TCS
//  - vec3 gl_TessCoord, which is the barycentric coordinate of the vertex
//  - any arrays ouput from the TCS (must be declared)
// it can also output per-fragment values to the fragment shader

// this line is required: layout (...) in;
// the first value "triangles" is required (other options: quads, isolines)
//   and is used to choose how the patch will be tessellated
// the other two are the default (spacing between vertices, winding)
layout (quads, equal_spacing, ccw) in;

uniform mat4 ModelView;
uniform mat4 Projection;
uniform float radius;
uniform mat4 Transformation;
uniform vec4 LightPosition;
uniform int subdivision;
in vec4 colorTES[];
flat out vec4 color;

out vec3 N, L, E;
out vec2 TexCoord;



void main() {

float ratio = 1.0f/subdivision;
float t = gl_TessCoord.s;
vec4 p1 = gl_in[0].gl_Position*(1-t) + gl_in[3].gl_Position*t;
vec4 p2 = gl_in[1].gl_Position*(1-t) + gl_in[2].gl_Position*t;
t = gl_TessCoord.t;
vec4 pos = p1*(1-t) + p2*t;

//calculate pos of each vertex 
pos.xyz += (normalize(pos.xyz)-pos.xyz)* radius;
pos.w=1;

//for normals 
vec3 vPos = (Transformation*pos).xyz;
L = normalize( LightPosition.xyz -vPos );
E = normalize( -vPos );

//get adjacent vertex
vec4 a= mix(p1,p2,t-ratio);
a.xyz += (normalize(a.xyz)-a.xyz)* radius;
a.w=1;


t = gl_TessCoord.s-ratio;
p1 = gl_in[0].gl_Position*(1-t) + gl_in[3].gl_Position*t;
p2 = gl_in[1].gl_Position*(1-t) + gl_in[2].gl_Position*t;
t = gl_TessCoord.t;

vec4 b = mix(p1,p2,t);
b.xyz += (normalize(b.xyz)-b.xyz)* radius;
b.w=1;

a.xyz= a.xyz-pos.xyz;
b.xyz= b.xyz-pos.xyz;

//get cross product 
vec3 nor =cross(a.xyz,b.xyz);
nor.xyz = normalize(nor.xyz);
N = (Transformation * vec4(nor, 0)).xyz;

//for texture 
TexCoord = gl_TessCoord.xy;
gl_Position = Projection*Transformation*pos;
  
}

