Shader "Custom/test"
{
    Properties
    {
        _MainTex("Main Texure", 2D) = "white"{}
    }
        SubShader
    {
        Tags { "RenderType" = "Opaque" }

        CGPROGRAM
        #pragma surface surf Lambert 
        //#pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        
        void surf (Input i, inout SurfaceOutput o)
        {
            o.Albedo = 1;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
