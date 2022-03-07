Shader "Custom/warp"
{
    Properties
    {
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _RampTex("Ramp Texture", 2D) = "white" {}
        _BumpMap("NormalMap", 2D) = "bump"{}
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" }

        //1pass 
        cull front
        CGPROGRAM
        #pragma surface surf _NoLight vertex:vert

        void vert(inout appdata_full v) {
            v.vertex.xyz = v.vertex.xyz + v.normal.xyz * 0.01;
        }
        struct Input
        {
            float4 color:COLOR;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
        }

        float4 Lighting_NoLight(SurfaceOutput s, float3 lightDir, float atten) {
            return float4(0, 0, 0, 1);
        }
        ENDCG

        //2pass
        cull back
        CGPROGRAM
        #pragma surface surf _Warp

        sampler2D _MainTex;
        sampler2D _RampTex;
        sampler2D _BumpMap;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            fixed4 d = tex2D(_BumpMap, IN.uv_BumpMap);

            o.Normal = UnpackNormal(d);

            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }

        float4 Lighting_Warp(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten) {

            float3 H = normalize(lightDir + viewDir);
            float spec = saturate(dot(s.Normal, H));
            spec = pow(spec, 100);

            float ndotl = dot(s.Normal, lightDir);
            float4 ramp = tex2D(_RampTex, float2(ndotl, 0.5));
            float4 final;
            final.rgb = ramp.rgb * s.Albedo.rgb + spec;
            final.a = s.Alpha;
            return final;
        }
        ENDCG
    }
        FallBack "Diffuse"
}
