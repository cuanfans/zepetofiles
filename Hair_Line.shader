Shader "Out_Hair_Line" {
 Properties {

     _MainTex ("Masukin Texture Lo Kontol", 2D) = "white" {}
     _Color ("Warna Kontol", Color) = (1,1,1,1)
 }
 
 SubShader {
     
    Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
    LOD 100
     
    Cull Off
    ZWrite Off
    Blend One OneMinusSrcAlpha 
     
    Pass {  
        CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            
            #include "UnityCG.cginc"

            struct appdata_t {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f {
                float4 vertex : SV_POSITION;
                half2 texcoord : TEXCOORD0;

            };

            sampler2D _MainTex;
            fixed4 _Color;
            float4 _MainTex_ST;
            
            v2f vert (appdata_t v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);

                return o;
            }
            
            fixed4 frag (v2f i) : SV_Target
            {     
            fixed4 color = tex2D(_MainTex, i.texcoord);                
            color.rgb *= color.a;
            color *= _Color;
            
            return color;
            }
        ENDCG
    }
 }
 
 }