Shader "Custom/Dissolve"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _NoiseTex("Noise Texture", 2D) = "white" {}
        _AlphaCut("Alpha Cut", Range(0, 1)) = 0
        [HDR] _OutlineColor ("Outline Color", Color) = (1,1,1,1)
        _OutlineThickness("Outline Thickness", Range(1, 1.5)) = 1.15
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }

        //1pass
        zwrite on 
        ColorMask 0
        CGPROGRAM
        #pragma surface surf _NoLight noambient noshadow
        struct Input{float2 uv_MainTex;};
        void surf(Input IN, inout SurfaceOutput o) {}
        float4 Lighting_NoLight(SurfaceOutput s, float3 lightDir, float atten) { return 0; }
        ENDCG

        //2pass 
        zwrite off
        CGPROGRAM
        #pragma surface surf Lambert alpha:fade

        sampler2D _MainTex;
        sampler2D _NoiseTex;
        float4 _OutlineColor;
        float _OutlineThickness;
        float _AlphaCut;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_NoiseTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            fixed4 noise = tex2D(_NoiseTex, IN.uv_NoiseTex);

            o.Albedo = c.rgb;

            float alpha;
            if (noise.r >= _AlphaCut) 
                alpha = 1;
            else 
                alpha = 0;

            float outline;
            if (noise.r >= _AlphaCut * _OutlineThickness)
                outline = 0;
            else
                outline = 1;

            o.Emission = outline * _OutlineColor.rgb;
            
            o.Alpha = alpha;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
