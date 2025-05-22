
Shader "Custom/WaterFlowShader"
{
    Properties
    {
        _Normals ("Normal Map", 2D) = "bump" {}
        _NormalStrength ("Normal Strength", Float) = 1.0

        _Flowmap ("Flow Map", 2D) = "white" {}
        _FlowmapStrength ("Flowmap Strength", Float) = 0.5
        _Speed ("Flow Speed", Float) = 0.5

        _DepthColor ("Depth Color", Color) = (0, 1, 1, 1)
        _DepthRange ("Depth Range", Float) = 10
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #include "UnityCG.cginc"

        sampler2D _Normals;
        float _NormalStrength;

        sampler2D _Flowmap;
        float _FlowmapStrength;
        float _Speed;

        fixed4 _DepthColor;
        float _DepthRange;

        UNITY_DECLARE_DEPTH_TEXTURE(_CameraDepthTexture);

        struct Input
        {
            float2 uv_Normals;
            float2 uv_Flowmap;
            float4 screenPos;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float time = _Time.y;

            float4 flow = tex2D(_Flowmap, IN.uv_Flowmap);
            float2 dir = (flow.rg * 2.0 - 1.0) * _FlowmapStrength;

            float2 animatedUV = IN.uv_Normals + dir * time * _Speed;
            float3 normal = UnpackNormal(tex2D(_Normals, animatedUV)) * _NormalStrength;
            o.Normal = normalize(normal);

            float depthSample = SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(IN.screenPos));
            float depth = LinearEyeDepth(depthSample);
            float depthFactor = saturate(depth / _DepthRange);

            o.Albedo = _DepthColor.rgb * depthFactor;
            o.Metallic = 0;
            o.Smoothness = 0.8;
        }
        ENDCG
    }

    FallBack "Diffuse"
}
