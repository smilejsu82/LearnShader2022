Shader "Custom/warp"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _RampTex("Ramp Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf _Warp
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _RampTex;


        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }

        float4 Lighting_Warp(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten) {

            float4 final;

            //half-lambert
            float ndotl = dot(s.Normal, lightDir) * 0.5 +0.5;

            //rim
            float rim = abs(dot(s.Normal, viewDir));
            if (rim > 0.2) rim = 1;
            else rim = 0;

            //spec 
            float3 H = normalize(lightDir + viewDir);
            float spec = saturate(dot(s.Normal, H));
            //spec = pow(spec, 150);

            //ramp
            fixed4 ramp = tex2D(_RampTex, float2(ndotl, spec));

            //final
            final.rgb = (s.Albedo.rgb * (ramp.rgb + 0.8)) + (ramp.rgb * 0.1);
            final.rgb *= rim;
            final.a = s.Alpha;

            return final;
        }

        ENDCG
    }
    FallBack "Diffuse"
}
