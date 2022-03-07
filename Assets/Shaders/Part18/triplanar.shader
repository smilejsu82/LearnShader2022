Shader "Custom/triplanar"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}

        [NoScaleOffset]_MainTex2("Albedo (RGB)", 2D) = "white" {}
        _MainTex2UV ("tileU,tileV,offsetU,offsetV", vector) = (1,1,0,0)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        
        #pragma surface surf Standard 

        sampler2D _MainTex;
        sampler2D _MainTex2;
        float4 _MainTex2UV;

        struct Input
        {
            float3 worldPos;
            float3 worldNormal;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float2 topUV = float2(IN.worldPos.x, IN.worldPos.z);
            float2 frontUV = float2(IN.worldPos.x, IN.worldPos.y);
            float2 sideUV = float2(IN.worldPos.z, IN.worldPos.y);

            float4 topTex = tex2D(_MainTex, topUV);
            float4 frontTex = tex2D(_MainTex2, frontUV * _MainTex2UV.xy + float2(_MainTex2UV.z, _MainTex2UV.w - _Time.y));
            float4 sideTex = tex2D(_MainTex2, sideUV * _MainTex2UV.xy + float2(_MainTex2UV.z, _MainTex2UV.w - _Time.y));

            //o.Emission = sideTex.rgb;
            o.Emission = lerp(topTex, frontTex, abs(IN.worldNormal.z));
            o.Emission = lerp(o.Emission, sideTex, abs(IN.worldNormal.x));
            //o.Emission = IN.worldNormal.y;
            o.Alpha = 1;

        }
        ENDCG
    }
    FallBack "Diffuse"
}
