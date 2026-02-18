Shader "Out_Version1"
{
	Properties 
	{
		_MainTex ("Hair Map", 2D) = "white" {}
		_SubTex ("Alpha Map", 2D) = "white" {}
		_Color ("Main Color", Color) = (1,1,1,1)
		_Cutoff ("Alpha Cut-Off", range(0, 1)) = 0.95
		_NormalTex ("Normal Map", 2D) = "bump" {}
		_NormalPower ("NormalPower", range(0, 5)) = 0.75
		_SpecularTex ("Specular (R) Spec Shift (G) Spec Mask (B)", 2D) = "gray" {}
		_SpecularMultiplier ("Specular Multiplier", float) = 10.0
		
		_SpecularColor ("Specular Color", Color) = (1,1,1,1)
		_SpecularMultiplier2 ("Secondary Specular Multiplier", float) = 10.0
		_SpecularColor2 ("Secondary Specular Color", Color) = (1,1,1,1)
		_PrimaryShift ( "Specular Primary Shift", float) = -0.01
		_SecondaryShift ( "Specular Secondary Shift", float) = -0.28

		_RimColor ("Rim Color", Color) = (0,0,0,0)
		_RimPower ("Rim Power", Range(1,3)) = 1.292


		_TintColor ("Tint Color", Color) = (0,0,0)
		_TintPower ("Tint Power", Range(0,1)) = 0.292
		[Enum(UnityEngine.Rendering.CullMode)] _Cull ("Cull", Float) = 0
		[HideInInspector]_LogLut ("_LogLut", 2D)  = "white" {}		


	}

SubShader {
    Tags { "Queue"="Transparent" "IgnoreProjector"="false" "RenderType"="Transparent" }
    Cull [_Cull]
    ZWrite Off
    Blend One OneMinusSrcColor

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
        sampler2D _SubTex;
        fixed4 _Color;
        float4 _MainTex_ST;
        float4 _SubTex_ST;

        v2f vert (appdata_t v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.texcoord = TRANSFORM_TEX(v.texcoord, _SubTex);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target {     
            fixed4 color = tex2D(_SubTex, i.texcoord);
            color.rgb *= color.a;
            color *= _Color;
            
            return color;
            }
        ENDCG
    }
		
		Tags { "RenderType" = "Opaque"  "Queue" = "Geometry+1"  "RequireOption" = "SoftVegetation" }
		cull off
		Blend Off
		ZWrite on

		CGPROGRAM
		#pragma surface surf Hair vertex:vert finalcolor:tonemapping
		#pragma target 3.0
		
		#include "./TAERI_Hair.cginc"

		void surf (Input IN, inout SurfaceOutputHair o)
		{
			surf_base(IN, o);
			if(o.Alpha < _Cutoff) {   
				clip(-1.0); 
			}
		}

		ENDCG
		
		/////////////////////////
		
		Tags { "RenderType" = "Opaque+1"  "Queue" = "Geometry+2"  "RequireOption" = "felse" }
		cull off
		Blend SrcAlpha OneMinusSrcAlpha
		ZWrite off
		

		CGPROGRAM
		#pragma surface surf Hair vertex:vert finalcolor:tonemapping alpha:fade
		#pragma target 3.0
		
		#include "./TAERI_Hair.cginc"

		void surf (Input IN, inout SurfaceOutputHair o)
		{
			surf_base(IN, o);
			if(o.Alpha < _Cutoff) {   
				//clip(-1.0); 
			}
		}

		ENDCG

		Tags { "RenderType" = "Opaque+1"  "Queue" = "Geometry+2"  "RequireOption" = "felse" }
		cull back
		Blend SrcAlpha OneMinusSrcAlpha
		ZWrite off
		

		CGPROGRAM
		#pragma surface surf Hair vertex:vert finalcolor:tonemapping alpha:fade
		#pragma target 3.0
		
		#include "./TAERI_Hair.cginc"

		void surf (Input IN, inout SurfaceOutputHair o)
		{
			surf_base(IN, o);
			if(o.Alpha < _Cutoff) {   
				//clip(-1.0); 
			}
		}

		ENDCG
		

	}
	FallBack "Mobile/VertexLit"
}