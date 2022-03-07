Shader "Custom/toon3"
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
        #pragma surface surf _Toon
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
            fixed4 d = tex2D(_BumpMap, IN.uv_BumpMap);
            float3 normal = UnpackNormal(d);
            o.Normal = normal;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }

        float4 Lighting_Toon(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten) {
            
            float4 final;

            //half-lambert term
            float ndotl = dot(s.Normal, lightDir) * 0.5 + 0.5;
            if (ndotl > 0.7) {
                ndotl = 1;
            }
            else {
                ndotl = 0.3;
            }

            //rim term (fresnel)
            float rim = abs(dot(s.Normal, viewDir));
            if (rim > 0.3) {
                rim = 1;
            }
            else {
                rim = -1;
            }

            //final term
            final.rgb = ndotl * s.Albedo * _LightColor0.rgb * rim;
            final.a = s.Alpha;

            return final;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
