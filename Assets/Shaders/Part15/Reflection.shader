Shader "Custom/Reflection"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _MaskMap("MaskMap", 2D) = "white" {}
        _BumpMap("NormalMap", 2D) = "bump" {}
        _Cube("Cubemap", Cube) = ""{}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Lambert
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _MaskMap;
        sampler2D _BumpMap;
        samplerCUBE _Cube;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_MaskMap;
            float2 uv_BumpMap;
            float3 worldRefl; 
            INTERNAL_DATA
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            fixed4 m = tex2D(_MaskMap, IN.uv_MaskMap);
            //normal
            fixed4 d = tex2D(_BumpMap, IN.uv_BumpMap);
            float3 normal = UnpackNormal(d);
            o.Normal = normal;

            //cubemap relfection
            float3 worldRefl = WorldReflectionVector(IN, o.Normal);
            float4 refl = texCUBE(_Cube, worldRefl);

            //final
            o.Albedo = c.rgb * (1-m.r);
            o.Emission = refl.rgb * m.r;
            o.Alpha =  c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
