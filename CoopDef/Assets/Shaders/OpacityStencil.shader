Shader "DanT/OpacityStencil"
{

    SubShader
    {
        Tags { 
			"Queue"="Geometry-1" 
			"ForceNoShadowCasting"="True"
		}
        
		Pass {
			ZWrite Off

			Stencil {
				Ref 2
				Comp Always
				Pass Replace
			}
		}

    }
    FallBack "Diffuse"
}
