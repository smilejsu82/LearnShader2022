Shader "Custom/Water"
{
	Properties
	{
		_BumpMap("Normal Map", 2D) = "bump" {}
		_Cube("Cube", Cube) = ""{}
		_RimPower("Rim Power", Range(1, 5)) = 2
		_WaterAlphaFactor("Water Alpha Factor", Range(0, 1)) = 0.5
		_WaterReflFactor("Water Reflection Factor", Range(1, 3)) = 1
	}
	SubShader
	{
		Tags { "RenderType" = "Transparent" "Queue" = "Transparent"}
		//Tags { "RenderType" = "Opaque" }

		GrabPass {}

		CGPROGRAM

		#pragma surface surf Lambert vertex:vert alpha:fade 

		sampler2D _GrabTexture;
		sampler2D _BumpMap;
		samplerCUBE _Cube;
		float _RimPower;
		float _WaterAlphaFactor;
		float _WaterReflFactor;

		void vert(inout appdata_full v) {

			//*2 -1연산  0 ~ 1값을 -1 ~ 1사이로 만들어 주고 절대값으로 1 ~ 0 ~ 1로 값을 만들어 준다 
			//float wavelength_range = 12;//파장의 넓이 
			//float wavelength_intensity = 0.1;//파장의 강도 
			//float waveX = abs((v.texcoord.x * 2 - 1) * wavelength_range);
			//float waveY = abs((v.texcoord.y * 2 - 1) * wavelength_range);
			//float wave_time = 2;
			//float movement;
			//movement = sin(waveX + _Time.y * wave_time) * wavelength_intensity;
			//movement += sin(waveY + _Time.y * wave_time) * wavelength_intensity;

			//v.vertex.y += movement / 2;

		}

		struct Input
		{
			float3 viewDir;
			float2 uv_BumpMap;
			float3 worldRefl;
			float4 screenPos;
			INTERNAL_DATA
		};

		void surf(Input IN, inout SurfaceOutput o)
		{
			//float3 normal1 = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));	// + _Time.x * 0.1
			//float3 normal2 = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));	// - _Time.x * 0.1
			o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
			//o.Normal = (normal1 + normal2) / 2;

			//reflection
			//float3 refColor = texCUBE(_Cube, WorldReflectionVector(IN, o.Normal));
			
			//refraction
			float3 screenUV = IN.screenPos.rgb / IN.screenPos.a;
			float3 refraction = tex2D(_GrabTexture, screenUV.xy + o.Normal.xy * 0.1);

			//rim 
			//float rim = saturate(dot(o.Normal, IN.viewDir));
			//rim = pow(1 - rim, _RimPower);

			o.Emission = refraction;// refColor* rim* refraction* _WaterReflFactor;
			o.Alpha = 0.5;// saturate(rim + _WaterAlphaFactor);
		}

		/*float4 Lighting_WaterSpecular(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten) {

			float3 H = normalize(lightDir + viewDir);
			float spec = saturate(dot(s.Normal, H));
			spec = pow(spec, 150);

			float4 final;
			final.rgb = spec * 3;
			final.a = s.Alpha + spec;

			return final;

		}*/
		ENDCG
	}
	FallBack "Legacy Shaders/Transparent/VertexLit"
}
