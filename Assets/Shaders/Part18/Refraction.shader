Shader "Custom/Refraction"
{
    Properties
    {
        _MainTex("Main Texture", 2D) = "white"{}
    }
    SubShader
    {
        Tags { "RenderType" = "Transparent" "Queue"="Transparent" }
        zwrite off

        GrabPass {}

        CGPROGRAM
        #pragma surface surf _NoLight alpha:fade

        sampler2D _GrabTexture;
        sampler2D _MainTex;

        struct Input
        {
            float4 color:COLOR;
            float4 screenPos;
            float2 uv_MainTex;
        };
        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);

            //카메라의 거리 영향을 제거 
            float3 screenUV = IN.screenPos.rgb / IN.screenPos.a;
            fixed4 d = tex2D(_GrabTexture, screenUV.xy + (c.r * 0.05));
            //o.Emission = float3(screenUV.xy, 0);
            o.Emission = d.rgb;

            //o.Emission = IN.screenPos.rgb;
        }
        float4 Lighting_NoLight(SurfaceOutput s, float3 lightDir, float atten)
        {
            //return float4(1, 0, 0, 1);
            return float4(0, 0, 0, 1);
        }
        ENDCG
    }
    FallBack "Legacy Shaders/Transparent/VertexLit"
}
