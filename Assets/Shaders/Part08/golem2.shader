Shader "Custom/golem2"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _MainTex2 ("Albedo (RGB)", 2D) = "white" {}
        _BumpMap("NormalMap", 2D) = "bump"{}
        _OcclusionMap("OcclusionMap", 2D) = "white"{}
        _Metallic ("Metallic", Range(0, 1)) = 0
        _Smoothness("Smoothness", Range(0, 1)) = 0.5
        _SmoothnessIntensity ("Smoothness Intensity", Range(0, 1)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Standard

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _MainTex2;
        sampler2D _BumpMap;
        sampler2D _OcclusionMap;
        float _Metallic;
        float _Smoothness;
        float _SmoothnessIntensity;

        struct Input
        {
            float4 color:COLOR;
            float2 uv_MainTex;
            float2 uv_MainTex2;
            float2 uv_BumpMap;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            fixed4 d = tex2D(_MainTex2, IN.uv_MainTex2);

            //normalmap 
            fixed4 e = tex2D(_BumpMap, IN.uv_BumpMap);
            fixed3 normal = UnpackNormal(e);
            o.Normal = normal;

            //occlusion map
            fixed4 f = tex2D(_OcclusionMap, IN.uv_MainTex);
            o.Occlusion = f.r;

            //metallic & smoothness
            o.Metallic = _Metallic;
            o.Smoothness = (IN.color.r * 0.5) * _Smoothness + _SmoothnessIntensity;

            o.Albedo = lerp(c.rgb, d.rgb, IN.color.r);

            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
