Shader "Custom/toon"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Thickness ("thickness", Range(0, 1)) = 0.01
        _OutlineColor("outline color", Color) = (1,1,1,1)
        _OutlineTex("outlint texture", 2D) = "white"{}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Cull Front

        //1pass 
        CGPROGRAM
        #pragma surface surf _NoLight vertex:vert noshadow noambient
        sampler2D _MainTex;
        sampler2D _OutlineTex;
        float _Thickness;
        float4 _OutlineColor;
        void vert(inout appdata_full v) {   
            v.vertex.xyz = v.vertex.xyz + (v.normal.xyz * _Thickness);
        }
        struct Input
        {
            float4 color : COLOR;
            float2 uv_OutlineTex;
        };
        void surf (Input IN, inout SurfaceOutput o)
        {   
            fixed4 c = tex2D(_OutlineTex, IN.uv_OutlineTex);
            o.Emission = c.rgb + abs(sin(_Time.y));
            o.Alpha = c.a;
        }
        float4 Lighting_NoLight(SurfaceOutput s, float3 lightDir, float atten) {
            float4 final;
            final.rgb = s.Emission * _OutlineColor;
            final.a = s.Alpha;
            return final;
        }
        ENDCG

        Cull Back

        //2pass
        CGPROGRAM
        #pragma surface surf Lambert
        sampler2D _MainTex;
        struct Input
        {
            float2 uv_MainTex;
        };
        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
