Shader "Custom/fire2"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _MainTex2("Albedo (RGB)", 2D) = "white" {}
        _Noise ("Noise", Range(0, 10)) = 0
        _Speed ("Speed", Range(1, 2)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }

        CGPROGRAM

        #pragma surface surf Standard alpha:fade
        
        sampler2D _MainTex;
        sampler2D _MainTex2;
        float _Noise;
        float _Speed;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_MainTex2;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            //데이터
            float2 uv = IN.uv_MainTex2;
            fixed4 d = tex2D(_MainTex2, float2(uv.x, uv.y));// - _Time.y * _Speed

            //데이터를 적용할 텍스쳐 
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex + d.r * _Noise);

            o.Emission = d.r + _Noise; // c.rgb;
            o.Alpha = 1;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
