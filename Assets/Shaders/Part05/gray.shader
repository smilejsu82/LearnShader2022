Shader "Custom/gray"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _MainTex2 ("Albedo (RGB)", 2D) = "white" {}
        _LerpTest ("Lerp Test", Range(0, 1)) = 0
        _BrightDark ("Bright & Dark", Range(-1, 1)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Standard 

        sampler2D _MainTex;
        sampler2D _MainTex2;
        float _LerpTest;
        float _BrightDark;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_MainTex2;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float2 uv = IN.uv_MainTex;
            fixed4 c = tex2D (_MainTex, uv);

            /*float2 uv = float2(IN.uv_MainTex.x, IN.uv_MainTex.y);
            fixed4 c = tex2D(_MainTex, uv);

            float2 uv = float2(IN.uv_MainTex.r, IN.uv_MainTex.g);
            fixed4 c = tex2D(_MainTex, uv);*/



            fixed4 d = tex2D(_MainTex2, IN.uv_MainTex2);

            float3 gray = (c.r + c.g + c.b) / 3;
            //o.Albedo = lerp(gray + _BrightDark, d.rgb, 1-c.a); //0: d, 1: c
            o.Emission = lerp(c.rgb, d.rgb, 1 - c.a);
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
