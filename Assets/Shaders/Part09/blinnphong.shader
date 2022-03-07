Shader "Custom/blinnphong"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _SpecColor ("SpecColor", Color) = (1,1,1,1)     //_SpecColor 예약어 
        _Gloss ("Gloss", Range(0, 1)) = 1   //specular 강도 
        _Specular ("Specular", Range(0, 1)) = 0.5  //specular  크기 
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf BlinnPhong 
        #pragma target 3.0

        sampler2D _MainTex;
        float _Gloss;
        float _Specular;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Specular = _Specular;
            o.Gloss = _Gloss;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
