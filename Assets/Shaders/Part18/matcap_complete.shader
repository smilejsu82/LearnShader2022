Shader "Custom/matcap_complete"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _MatcapTex("Matcap Texture", 2D) = "white" {}
        _BumpMap("NormalMap", 2D) = "bump" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf _NoLight noambient
        sampler2D _MainTex;
        sampler2D _MatcapTex;
        sampler2D _BumpMap;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
            float3 worldNormal;
            INTERNAL_DATA
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
         
            //normal
            fixed4 d = tex2D(_BumpMap, IN.uv_BumpMap);
            o.Normal = UnpackNormal(d);
            float3 worldNormal = WorldNormalVector(IN, o.Normal);

            //matcap 
            float3 viewNormal = mul((float3x3)UNITY_MATRIX_V, worldNormal); 
            float2 matcapUV = viewNormal.xy * 0.5 + 0.5;
            fixed4 e = tex2D(_MatcapTex, matcapUV);

            //final
            o.Emission = c.rgb * e.rgb;
            o.Alpha = c.a;
        }
        float4 Lighting_NoLight(SurfaceOutput s, float3 lightDir, float atten) {
            return float4(0, 0, 0, s.Alpha);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
