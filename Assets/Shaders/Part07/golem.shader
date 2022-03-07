Shader "Custom/golem"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _MainTex2 ("Albedo (RGB)", 2D) = "white" {}
        _MainTex3 ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Standard 

        sampler2D _MainTex;
        sampler2D _MainTex2;
        sampler2D _MainTex3;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_MainTex2;
            float2 uv_MainTex3;
            float4 color : COLOR;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            fixed4 d = tex2D(_MainTex2, IN.uv_MainTex2);
            fixed4 e = tex2D(_MainTex3, IN.uv_MainTex3);

            o.Emission = lerp(c.rgb, d.rgb, IN.color.r);
            o.Emission = lerp(o.Emission, e.rgb, IN.color.g);

            //o.Emission = IN.color.rgb;

            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
