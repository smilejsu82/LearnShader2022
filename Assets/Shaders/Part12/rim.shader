Shader "Custom/rim"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _RimColor ("Rim Color", Color) = (1,1,1,1)
        _RimPow ("Rim Power", Range(1, 10)) = 3
        _BumpMap("NormalMap", 2D) = "bump" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Lambert //noambient
        //#pragma target 3.0

        sampler2D _MainTex;
        sampler2D _BumpMap;
        float4 _RimColor;
        float _RimPow;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
            float3 viewDir;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            
            o.Albedo = c.rgb;

            //normal map 
            fixed4 d = tex2D(_BumpMap, IN.uv_BumpMap);
            float3 normal = UnpackNormal(d);
            o.Normal = normal;

            //rim 
            float rim = saturate(dot(o.Normal, IN.viewDir));
            o.Emission = pow(1 - rim, _RimPow) * _RimColor.rgb;

            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
