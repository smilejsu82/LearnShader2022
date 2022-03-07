Shader "Custom/surface"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Metallic ("Metallic", Range(0, 1)) = 0
        _Smoothness ("Smoothness", Range(0, 1)) = 0.5
        _BumpMap("Normalmap", 2D) = "bump" {}
        _Intensity("Intensity", Float) = 1
        _Occlusion("Occlusion", 2D) = "white"{}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM

        #pragma surface surf Standard 
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _BumpMap;
        sampler2D _Occlusion;

        //변수 정의 
        float _Metallic;
        float _Smoothness;
        float _Intensity;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
          
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);

            fixed4 n = tex2D(_BumpMap, IN.uv_BumpMap);  //노멀맵의 픽셀을 가져온다 
            fixed3 normal = UnpackNormal(n);            //가져온 픽셀값을 추출 한다 
            o.Normal = float3(normal.xy * _Intensity, normal.z);

            //occlusion
            fixed4 occlusion = tex2D(_Occlusion, IN.uv_MainTex);
            o.Occlusion = occlusion;

            o.Albedo = c.rgb;
            //구조체 변수에 할당 
            o.Metallic = _Metallic;
            o.Smoothness = _Smoothness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
