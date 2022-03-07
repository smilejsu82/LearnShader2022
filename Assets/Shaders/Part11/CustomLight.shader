Shader "Custom/CustomLight"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _BumpMap("NormalMap", 2D) = "bump"{}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf _MyLambert noambient
        //#pragma target 3.0

        sampler2D _MainTex;
        sampler2D _BumpMap;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);

            //normal map
            fixed4 d = tex2D(_BumpMap, IN.uv_BumpMap);
            fixed3 normal = UnpackNormal(d);
            o.Normal = normal;

            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }

        float4 Lighting_MyLambert(SurfaceOutput s, float3 lightDir, float atten)
        {
            //lambert
            //float ndotl = dot(s.Normal, lightDir);
            //half-lambert
            float ndotl = dot(s.Normal, lightDir) * 0.5 + 0.5;
            float powNdotl = pow(ndotl, 3);

            float4 final;
            final.rgb = powNdotl * s.Albedo * _LightColor0.rgb * atten;
            final.a = s.Alpha;
            return final;
        }

        ENDCG
    }
    FallBack "Diffuse"
}
