Shader "Custom/PingTerrain"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _PingColor ("Ping Color", Color) = (1,1,0,1)
        _PingWidth ("Ping Width", Float) = 3.0
        _PingSpeed ("Ping Speed", Float) = 15.0
        _TimeSincePing ("Time Since Ping", Float) = 0.0
        _PingOriginWS ("Ping Origin WS", Vector) = (0,0,0)
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #include "UnityCG.cginc"

        sampler2D _MainTex;
        float4 _PingColor;
        float _PingWidth;
        float _PingSpeed;
        float _TimeSincePing;
        float3 _PingOriginWS;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldPos;
        };

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            float3 texColor = tex2D(_MainTex, IN.uv_MainTex).rgb;

            float dist = distance(IN.worldPos, _PingOriginWS);
            float radius = _TimeSincePing * _PingSpeed;

            float ring = smoothstep(radius - _PingWidth, radius, dist) *
                         (1 - smoothstep(radius, radius + _PingWidth, dist));

            o.Albedo = ring.xxx;
            o.Metallic = 0.0;
            o.Smoothness = 0.5;
        }
        ENDCG
    }

    FallBack "Diffuse"
}
