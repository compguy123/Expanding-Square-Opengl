#version 400

flat in vec4 color;
uniform bool Outline;
out vec4 fColor;
uniform vec4 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform float Shininess;
uniform int text;
uniform sampler2D texture;
in vec3 N, L, E;
in vec2 TexCoord;
void main() 
{ 
    if(text %2==0){
    //for texture 
     vec4 texColor = texture2D(texture, TexCoord);
    fColor =texColor;
    
    }else{
        if ( Outline ){
        //to draw lines 
             fColor = vec4(0,0,0,1);
        }else{
        //for blinn phong 
            vec3 H = normalize( L + E );
            vec4 ambient = AmbientProduct;

            float Kd = max( dot(L, N), 0.0 );
            vec4  diffuse = Kd * DiffuseProduct;

            float Ks = pow( max(dot(N, H), 0.0), Shininess );
            vec4  specular = Ks * SpecularProduct;
   
            if ( dot(L, N) < 0.0 ) {
            specular = vec4(0.0, 0.0, 0.0, 1.0);
            }

            fColor = ambient + diffuse + specular;
            fColor.a = 1.0;
     
          
       }
     }
}
