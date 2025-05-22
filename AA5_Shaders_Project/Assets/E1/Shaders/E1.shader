Shader "Custom/E1_Final_Shield"
{
    Properties
    {
        _Color("Base Color", Color) = (0,1,1,1)
        _GlowColor("Glow Color", Color) = (0,1,1,1)
        _MainTex("Main Texture (hex pattern)", 2D) = "white" {}
        _Glossiness("Smoothness", Range(0,1)) = 0.0
        _Metallic("Metallic", Range(0,1)) = 0.0
        _FresnelPower("Fresnel Power", Range(0.1, 10)) = 1.04
        _Speed("Hex Scroll Speed", Float) = 0.2
        _ScanlineDensity("Scanline Density", Float) = 70
        _ScanlineSpeed("Scanline Speed", Float) = 1
        _ScanlineStrength("Scanline Strength", Range(0, 1)) = 1
        _GlowStrength("Glow Intensity", Range(0, 10)) = 4.18
    }

        SubShader
        {
            Tags { "RenderType" = "Transparent" }
            LOD 200
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
            Cull Back

            CGPROGRAM
            #pragma surface surf Standard alpha:fade fullforwardshadows
            #pragma target 3.0

            sampler2D _MainTex;
            fixed4 _Color;
            fixed4 _GlowColor;
            float _Glossiness;
            float _Metallic;
            float _FresnelPower;
            float _Speed;
            float _ScanlineDensity;
            float _ScanlineSpeed;
            float _ScanlineStrength;
            float _GlowStrength;

            struct Input
            {
                float2 uv_MainTex;
                float3 viewDir;
            };

            void surf(Input IN, inout SurfaceOutputStandard o)
            {
                // Animar patrón
                float2 hexUV = IN.uv_MainTex + float2(0, _Time.y * _Speed);
                float hex = tex2D(_MainTex, hexUV).r;

                // Fresnel
                float3 normalDir = normalize(o.Normal);
                float3 viewDirection = normalize(IN.viewDir);
                float fresnel = pow(1.0 - saturate(dot(viewDirection, normalDir)), _FresnelPower);

                // Scanlines invertidas
                float scanUV = frac(IN.uv_MainTex.y * _ScanlineDensity + _Time.y * _ScanlineSpeed);
                float scanline = 1.0 - smoothstep(0.0, 0.5, scanUV); // invertido

                // aplicar scanline al patrón como "apagado"
                float maskedPattern = (1.0 - hex) * scanline;

                // Aplicar fresnel como máscara global
                float final = maskedPattern * fresnel;

                // Color + glow
                float3 glowColor = _GlowColor.rgb * (fresnel * _GlowStrength);
                float3 finalColor = _Color.rgb * final + glowColor;

                o.Albedo = finalColor;
                o.Metallic = _Metallic;
                o.Smoothness = _Glossiness;
                o.Alpha = saturate(final + (fresnel * 0.1)); // bordes = glow + transparencia
                o.Emission = glowColor;
            }
            ENDCG
        }

            FallBack "Transparent/Diffuse"
}
