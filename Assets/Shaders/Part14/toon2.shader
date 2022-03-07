Shader "Custom/toon2"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _BumpMap("NormalMap", 2D) = "bump"{}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        //1pass
        cull front 
        CGPROGRAM
        #pragma surface surf _NoLight vertex:vert
        void vert(inout appdata_full v) {
            v.vertex.xyz = v.vertex.xyz + (v.normal.xyz * 0.01);
        }

        struct Input
        {
            float4 color:COLOR;
        };
        void surf (Input IN, inout SurfaceOutput o)
        {
            
        }
        float4 Lighting_NoLight(SurfaceOutput s, float3 lightDir, float atten) {
            return float4(0, 0, 0, 1);
        }
        ENDCG


        //2pass
        cull back
        CGPROGRAM
        #pragma surface surf _Toon
        
        sampler2D _MainTex;
        sampler2D _BumpMap;

        struct Input
        {
            float4 color:COLOR;
            float2 uv_MainTex;
            float2 uv_BumpMap;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            fixed4 d = tex2D(_BumpMap, IN.uv_BumpMap);
            float3 normal = UnpackNormal(d);
            o.Normal = normal;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        float4 Lighting_Toon(SurfaceOutput s, float3 lightDir, float atten) {
            
            float4 final;

            float ndotl = dot(s.Normal, lightDir) * 0.5 + 0.5;
            ndotl = ndotl * 5;
            ndotl = ceil(ndotl) / 5;
            
            final.rgb = ndotl * s.Albedo;
            final.a = s.Alpha;

            return final;

        }
        ENDCG
    }
    FallBack "Diffuse"
}
