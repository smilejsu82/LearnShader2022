Shader "Custom/uv"
{
	Properties
	{
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_Speed ("Speed", float) = 1
	}

	SubShader
	{
		Tags { "RenderType" = "Opaque" }

		CGPROGRAM
		#pragma surface surf Standard 

		sampler2D _MainTex;
		float _Speed;

		struct Input
		{
			float2 uv_MainTex;
		};

		void surf(Input IN, inout SurfaceOutputStandard o)
		{
			float2 uv = IN.uv_MainTex;
			float4 c = tex2D(_MainTex, uv);
			o.Emission = float3(uv, 0);
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
