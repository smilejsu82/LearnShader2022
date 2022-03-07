Shader "Custom/BlinnPhong"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _SpecCol ("Specular Color", Color) = (1,1,1,1)
        _GlossTex("Gloss Tex", 2D) = "white"{}
        _BumpMap("Normal Map", 2D) = "bump"{}
        _FakeSpecColor ("Fake Spec Color", Color) = (1,1,1,1)
        _RimColor("Rim Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf _Lambert //noambient

        sampler2D _MainTex;
        sampler2D _GlossTex;
        sampler2D _BumpMap;
        float4 _SpecCol;
        float4 _FakeSpecColor;
        float4 _RimColor;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_GlossTex;
            float2 uv_BumpMap;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            fixed4 d = tex2D(_GlossTex, IN.uv_GlossTex);
            fixed4 e = tex2D(_BumpMap, IN.uv_BumpMap);
            float3 normal = UnpackNormal(e);
            o.Normal = normal;
            o.Albedo = c.rgb;
            o.Gloss = d.a;
            o.Alpha = c.a;
        }

        float4 Lighting_Lambert(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten) {

            //diffuse 
            float3 diffuseColor;
            float ndotl = saturate(dot(s.Normal, lightDir));
            diffuseColor = ndotl * s.Albedo * _LightColor0.rgb * atten;
            //spec 
            float3 H = normalize(lightDir + viewDir);
            float spec = saturate(dot(H, s.Normal));
            spec = pow(spec, 100);
            float3 specColor = spec * _SpecCol.rgb * s.Gloss;
            //rim
            float3 rimColor;
            float rim = abs(dot(viewDir, s.Normal));
            float invertRim = 1 - rim;
            rimColor = pow(invertRim, 6) * _RimColor;
            //fake spec
            float3 fakeSpecColor;
            fakeSpecColor = pow(rim, 50) * s.Gloss * _FakeSpecColor.rgb;
            //final
            float4 final;
            final.rgb = diffuseColor.rgb + specColor + rimColor + fakeSpecColor;
            final.a = s.Alpha;
            return final;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
