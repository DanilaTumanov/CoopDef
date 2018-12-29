Shader "DanT/ViewZone"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_AttenBorder ("Attenuation border", Range(0, 10)) = 0.1
		_AttenMax ("Attenuation Max", Range(0, 1)) = 1
		_AttenMin ("Attenuation Min", Range(0, 1)) = 0.5
    }
    SubShader
    {
        Tags { 
			"RenderType" = "Opaque"
		}
        

		//UsePass "Standard/SHADOWCASTER"


        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf ViewZone fullforwardshadows 

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0


		#include "UnityPBSLighting.cginc"


		fixed _AttenBorder;
		fixed _AttenMax;
		fixed _AttenMin;
		


		half4 LightingViewZone (SurfaceOutputStandard s, half3 viewDir, UnityGI gi) {
			
			half4 stdColor = LightingStandard(s, viewDir, gi);
			
			half LdotN = saturate(dot(s.Normal, _WorldSpaceLightPos0)) * _WorldSpaceLightPos0.w;
			half4 c;
			fixed ViewZoneAtten = unity_4LightAtten0.x < _AttenBorder ? _AttenMax : _AttenMin;

			c.rgb = stdColor + ViewZoneAtten;// - half4(_AttenBorder, 0, 0, 1);//* _LightColor0.rgb * atten * LdotN * ViewZoneAtten;
			c.a = s.Alpha;

			return c;
		}

		// Пример взят тут https://docs.unity3d.com/Manual/SL-SurfaceShaderLightingExamples.html
		void LightingViewZone_GI(
                SurfaceOutputStandard s,
                UnityGIInput data,
                inout UnityGI gi)
        {
            LightingStandard_GI(s, data, gi);
        }



        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        fixed4 _Color;


        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
