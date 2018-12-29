// Upgrade NOTE: replaced '_LightMatrix0' with 'unity_WorldToLight'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "DanT/ViewZone3"
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
        
 
        // shadow casting support
        UsePass "Standard/SHADOWCASTER"
    }
}