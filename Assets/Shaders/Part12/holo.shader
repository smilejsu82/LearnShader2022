Shader "Custom/holo"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }

        CGPROGRAM
        #pragma surface surf _NoLight alpha:fade noambient

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
            float3 viewDir;
            float3 worldPos;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);

            //color 
            o.Emission = float3(0, 1, 0);

            //holo effect 
            float holo = pow(frac(IN.worldPos.g * 3 - _Time.y), 30);

            //rim 
            float ndotv = saturate(dot(o.Normal, IN.viewDir));
            float rim = pow(1 - ndotv, 3);

            float alpha = rim + holo;
            o.Alpha = alpha;
        }

        float4 Lighting_NoLight(SurfaceOutput s, float3 lightDir, float atten) {
            return float4(0, 0, 0, s.Alpha);
        }

        ENDCG
    }
    FallBack "Transparent/Diffuse"
}
