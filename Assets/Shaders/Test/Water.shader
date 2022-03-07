Shader "Custom/Water"
{
    Properties
    {
        _Bumpmap("NormalMap", 2D) = "bump"{}
        _Cube("Cube", Cube) = ""{}
    }
        SubShader
    {
        Tags { "RenderType" = "Transparent" "Queue"="Transparent"}
        GrabPass{ "_WaterBackground" }

        CGPROGRAM

        #pragma surface surf Lambert alpha:fade

        sampler2D _WaterBackground, _CameraDepthTexture, _Bumpmap;
        samplerCUBE _Cube;
        float4 _CameraDepthTexture_TexelSize;
        float _RefractionStrength;

        struct Input
        {
            float4 color:COLOR;
            float2 uv_Bumpmap;
            float4 screenPos;
            float3 worldRefl;
            INTERNAL_DATA
        };

        float2 AlignWithGrabTexel(float2 uv) {
#if UNITY_UV_STARTS_AT_TOP
            if (_CameraDepthTexture_TexelSize.y < 0) {
                uv.y = 1 - uv.y;
            }
#endif
            return
                (floor(uv * _CameraDepthTexture_TexelSize.zw) + 0.5) *
                abs(_CameraDepthTexture_TexelSize.xy);
        }

        void surf (Input IN, inout SurfaceOutput o)
        {
            float2 uv = AlignWithGrabTexel(IN.screenPos.xy / IN.screenPos.w);
            float backgroundDepth = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, uv));
            float surfaceDepth = UNITY_Z_0_FAR_FROM_CLIPSPACE(IN.screenPos.z);
            float depthDifference = backgroundDepth - surfaceDepth;

            o.Normal = UnpackNormal(tex2D(_Bumpmap, IN.uv_Bumpmap));
            float3 ref = texCUBE(_Cube, WorldReflectionVector(IN, o.Normal));
            float3 screenUV = IN.screenPos.rgb / IN.screenPos.a;
            float3 backgroundColor = tex2D(_WaterBackground, uv + o.Normal * 0.1).rgb;
            o.Emission = backgroundColor;

            /*float2 uv = IN.screenPos.xyz / IN.screenPos.w;
            float3 refraction = tex2D(_WaterBackground, (uv.xy + o.Normal * 0.2));
            o.Emission = refraction;*/

            o.Alpha = 0.5;
        }

        ENDCG
    }
    //FallBack "Diffuse"
    FallBack "Legacy Shaders/Transparent/Vertexlit"
}
