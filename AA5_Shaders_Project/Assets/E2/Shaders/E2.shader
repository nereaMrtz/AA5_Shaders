Shader "Custom/E2"
{
    Properties
    {
        _Tiling("Tiling", Float) = 1
        _Blend("Blend Sharpness", Float) = 5
        _Color("Base Color Tint", Color) = (1,1,1,1)
        _Albedo("Albedo", 2D) = "white" {}

        [Toggle(_USEEMISSION)] _UseEmission("Use Emission", Float) = 0
        _Emission("Emission Texture", 2D) = "white" {}
        [HDR] _EmissionColor("Emission Color", Color) = (0,0,0,0)

        _SnowStart("Snow Start Height", Float) = 0.5
        _SnowSoftness("Snow Softness", Float) = 0.1
        _SnowColor("Snow Color", Color) = (1,1,1,1)
        _SnowMetallic("Snow Metallic", Range(0,1)) = 0
        _SnowSmoothness("Snow Smoothness", Range(0,1)) = 0.1
    }

        SubShader
        {
            Tags { "RenderType" = "Opaque" "Emission" = "True" }
            LOD 250

            CGPROGRAM
            #pragma surface surf Standard fullforwardshadows
            #pragma target 3.0
            #pragma multi_compile _ _USEEMISSION

            sampler2D _Albedo, _Emission;
            float _Tiling, _Blend;
            fixed4 _Color;

            float _SnowStart, _SnowSoftness;
            fixed4 _SnowColor;
            float _SnowMetallic, _SnowSmoothness;

            fixed4 _EmissionColor;

            struct Input
            {
                float3 worldPos;
                float3 worldNormal;
                INTERNAL_DATA
            };

            //Calcula blend de las 3 proyecciones segun la orientacion de la normal
            float4 SampleTriplanar(sampler2D tex, float3 pos, float3 normal)
            {
                float3 blend = pow(abs(normal), _Blend);
                blend /= dot(blend, 1.0);

                float2 xz = pos.zy * _Tiling;
                float2 yz = pos.xz * _Tiling;
                float2 xy = pos.xy * _Tiling;

                float4 tx = tex2D(tex, xz);
                float4 ty = tex2D(tex, yz);
                float4 tz = tex2D(tex, xy);

                return tx * blend.x + ty * blend.y + tz * blend.z;
            }

            void surf(Input IN, inout SurfaceOutputStandard o)
            {
                //Normalizar datos
                float3 worldNormal = normalize(IN.worldNormal);
                float3 worldPos = IN.worldPos;

                //Color base con triplanar
                float4 baseAlbedo = SampleTriplanar(_Albedo, worldPos, worldNormal);
                float3 baseColor = baseAlbedo.rgb * _Color.rgb;

                //Nieve con dot entre la normal y el up
                float upDot = saturate(dot(worldNormal, float3(0,1,0)));
                float snowMask = smoothstep(_SnowStart, _SnowStart + _SnowSoftness, upDot);
                float3 finalColor = lerp(baseColor, _SnowColor.rgb, snowMask);

                //albedo + nieve
                o.Albedo = finalColor;
                o.Metallic = lerp(0, _SnowMetallic, snowMask);
                o.Smoothness = lerp(0, _SnowSmoothness, snowMask);
                o.Alpha = 1;

                //Si activamos emision
                #ifdef _USEEMISSION
                float3 emissionTex = SampleTriplanar(_Emission, worldPos, worldNormal).rgb;
                o.Emission = emissionTex * _EmissionColor.rgb;
                #endif
            }
            ENDCG
        }

            FallBack "Self-Illumin/Diffuse"
}
