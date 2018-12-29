// Upgrade NOTE: replaced '_LightMatrix0' with 'unity_WorldToLight'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "DanT/ViewZone2"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Texture", 2D) = "white" {}
		_Radius ("Radius", Range(0, 50)) = 3
		_ViewLightPower ("View light power", Range(0, 1)) = 0.3
		_Sharpness ("Sharpness", Range(1, 20)) = 1

		_TestLAP ("Test LAP", Range(0, 50)) = 1
    }
    SubShader
    {
        Pass
        {
            Tags {"LightMode"="ForwardBase"}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
 
            // compile shader into multiple variants, with and without shadows
            #pragma multi_compile_fwdbase
            // shadow helper functions and macros
            #include "AutoLight.cginc"
 
            sampler2D _MainTex;
            float4 _MainTex_ST;
 
            fixed4 _Color;
 
            struct v2f
            {
                float2 uv : TEXCOORD0;
                SHADOW_COORDS(1) // put shadows data into TEXCOORD1
                float4 pos : SV_POSITION;
                float3 worldNormal : TEXCOORD2;
                float3 worldPos : TEXCOORD3;
            };
 
            v2f vert (appdata_base v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos (v.vertex);
                o.uv = TRANSFORM_TEX (v.texcoord, _MainTex);
                o.worldNormal = normalize (UnityObjectToWorldNormal (v.normal));
                o.worldPos = mul (unity_ObjectToWorld, v.vertex);
                // compute shadows data
                TRANSFER_SHADOW (o)
                return o;
            }
 
            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D (_MainTex, i.uv) * _Color;
                // compute shadow attenuation (1.0 = fully lit, 0.0 = fully shadowed)
                fixed shadow = SHADOW_ATTENUATION (i);
 
                half3 lightPos;
                if (_WorldSpaceLightPos0.w == 0) {
                    lightPos = normalize (_WorldSpaceLightPos0.xyz);
                } else {
                    lightPos = normalize (_WorldSpaceLightPos0.xyz - i.worldPos.xyz);
                }
 
                half nl = max (0, dot (i.worldNormal, lightPos));
                half diff = saturate (nl) * _LightColor0.rgb;
                half3 ambient = ShadeSH9 (half4 (i.worldNormal, 1));
                // darken light's illumination with shadow, keep ambient intact
                fixed3 lighting = diff * shadow + ambient;
                col.rgb *= lighting;
                return col;
            }
            ENDCG
        }
 
        Pass
        {
            Blend One One
 
            Tags {"LightMode"="ForwardAdd"}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
 
            // compile shader into multiple variants, with and without shadows
            #pragma multi_compile_fwdadd_fullshadows
            // shadow helper functions and macros
            #include "AutoLight.cginc"
 
            sampler2D _MainTex;
            float4 _MainTex_ST;
 
            fixed4 _Color;
			fixed _Radius;
			fixed _ViewLightPower;
			fixed _Sharpness;

			fixed _TestLAP;
 
            struct v2f
            {
                float2 uv : TEXCOORD0;
                SHADOW_COORDS(1) // put shadows data into TEXCOORD1
                float4 pos : SV_POSITION;
                float3 worldNormal : TEXCOORD2;
                float3 worldPos : TEXCOORD3;
            };
 
            v2f vert (appdata_base v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos (v.vertex);
                o.uv = TRANSFORM_TEX (v.texcoord, _MainTex);
                o.worldNormal = normalize (UnityObjectToWorldNormal (v.normal));
                o.worldPos = mul (unity_ObjectToWorld, v.vertex);
                // compute shadows data
                TRANSFER_SHADOW (o)
                return o;
            }
 
            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D (_MainTex, i.uv) * _Color;
                // compute shadow attenuation (1.0 = fully lit, 0.0 = fully shadowed)
                fixed shadow = SHADOW_ATTENUATION (i);
 
                half3 lightPos;
                if (_WorldSpaceLightPos0.w == 0) {
                    lightPos = normalize (_WorldSpaceLightPos0.xyz);
                } else {
                    lightPos = normalize (_WorldSpaceLightPos0.xyz - i.worldPos.xyz);
                }


				if ((_LightColor0.r + _LightColor0.g + _LightColor0.b) == 0) {
					half roundMod = saturate( (_Radius - length(_WorldSpaceLightPos0.xz - i.worldPos.xz)) *  _Sharpness );
					fixed3 lighting = _ViewLightPower * shadow;
					col.rgb *= roundMod * lighting;
				}
				else {
					half nl = saturate ( dot (i.worldNormal, lightPos));
					half diff = max(0, nl * _LightColor0.rgb - unity_4LightAtten0 * _TestLAP);
					// darken light's illumination with shadow, keep ambient intact
					fixed3 lighting = diff * shadow;
					col.rgb *= lighting;
				}

                return col;
            }
            ENDCG
        }
 
        // shadow casting support
        UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
    }
}