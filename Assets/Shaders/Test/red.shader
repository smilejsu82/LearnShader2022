Shader "Custom/red"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Test("Test", Range(0, 1)) = 0.01
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent"}
        LOD 200
        ZWrite Off

        CGPROGRAM

        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard alpha:fade 

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        float _Test;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb * c.a; 
            o.Emission = _Test * (1 - c.a);
            o.Alpha = 1;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
