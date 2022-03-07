Shader "Custom/axe"
{
    Properties
    {
        _MainTex("Main Texture", 2D) = "white"{}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        cull front
        CGPROGRAM
        #pragma surface surf _NoLight noshadow vertex:vert noambient
        void vert(inout appdata_full v) {
            
            //v.vertex.xyz = v.vertex.xyz + v.normal.xyz * 0.01;
            v.vertex.xyz = v.vertex.xyz + v.color.r * 0.03;
        }
        struct Input
        {
            float4 color:COLOR;
        };
        void surf (Input IN, inout SurfaceOutput o)
        {
            
        }
        float4 Lighting_NoLight(SurfaceOutput s, float3 lightDir, float atten) {
            return float4(0, 0, 0, 1);
        }
        ENDCG

        //2pass
        cull back
        CGPROGRAM
        #pragma surface surf Lambert
        
        sampler2D _MainTex;

        struct Input
        {
            float4 color:COLOR;
            float2 uv_MainTex;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            o.Emission = c.rgb;
            o.Alpha = c.a;
            //o.Emission = IN.color.rgb;
            //o.Alpha = 1;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
