/*
Shader "Hidden/Custom/PingPostEffect"
{
    Properties
    {
        _MainTex ("MainTex", 2D) = "white" {}
        _PingOrigin ("Ping Origin", Vector) = (0,0,0,0)
        _Strength ("Strength", Float) = 1
        _Color ("Ping Color", Color) = (1, 0.5, 0, 1)
        _Width ("Width", Float) = 0.1
        _Speed ("Speed", Float) = 1
        _MaxDistance ("Max Distance", Float) = 30
        _Frequency ("Frequency", Float) = 0.25
        _TimeSincePing ("Time", Float) = 0
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_TexelSize;

            float4 _PingOrigin;
            float _Strength;
            float4 _Color;
            float _Width;
            float _Speed;
            float _MaxDistance;
            float _Frequency;
            float _TimeSincePing;

            float remap(float value, float min1, float max1, float min2, float max2)
            {
                return min2 + (value - min1) * (max2 - min2) / (max1 - min1);
            }

            fixed4 frag(v2f_img i) : SV_Target
            {
                float2 uv = i.uv;
                float2 centerUV = _PingOrigin.xy / _PingOrigin.zw;
                float2 diff = uv - centerUV;
                float dist = length(diff);

                float radius = _TimeSincePing * _Speed;

                float ring = smoothstep(radius - _Width, radius, dist) *
                             (1.0 - smoothstep(radius, radius + _Width, dist));

                float3 baseCol = tex2D(_MainTex, uv).rgb;
                float3 pingCol = baseCol + ring * _Color.rgb * _Strength;

                return float4(pingCol, 1.0);
            }
            ENDCG
        }
    }
}
*/

Shader "Hidden/Custom/PingPostEffect"
{
    SubShader
    {
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_TexelSize;

            fixed4 frag(v2f_img i) : SV_Target
            {
                return tex2D(_MainTex, i.uv); // copia exacta de la pantalla
            }
            ENDCG
        }
    }
}