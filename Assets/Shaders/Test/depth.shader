Shader "Custom/depth"
{
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        CGPROGRAM
        #pragma surface surf Lambert noshadow noambient
        #pragma target 3.0

        struct Input
        {
            float4 screenPos;
        };
        
        sampler2D _CameraDepthTexture;

        void surf (Input IN, inout SurfaceOutput o)
        {
            float4 depth = tex2D(_CameraDepthTexture, IN.screenPos.xy);
            o.Emission = depth.r;
            o.Alpha = 1;
        }
        ENDCG
    }
    FallBack off
}
