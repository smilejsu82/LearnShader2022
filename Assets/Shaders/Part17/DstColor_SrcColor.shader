Shader "Custom/DstColor_SrcColor"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        zwrite off
        blend DstColor SrcColor

        CGPROGRAM
        #pragma surface surf Lambert keepalpha

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            //o.Albedo = c.rgb;
            c = lerp(float4(0.5, 0.5, 0.5, 0.5), c, c.a);
            o.Emission = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Legacy Shaders/Transparent/VertexLit"
}
