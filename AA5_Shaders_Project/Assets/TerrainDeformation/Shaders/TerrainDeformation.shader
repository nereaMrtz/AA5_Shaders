Shader "Custom/TerrainDeformation"
{
    Properties
    {
        _GroundTex("Ground Texture", 2D) = "white" {}
        _CrackSnowTex("Cracked Snow", 2D) = "white" {}
        _TopSnowTex("Top Snow", 2D) = "white" {}

        _HeightMap("Render Height Texture", 2D) = "black" {}
        _HeightScale("Height Strength", Float) = 1.0

        _Zone1("Height Threshold 1", Float) = 3.0
        _Zone2("Height Threshold 2", Float) = 6.0
        _BlendWidth("Blending Margin", Float) = 1.0
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        Pass
        {
            CGPROGRAM
            #pragma target 4.5
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _GroundTex;
            sampler2D _CrackSnowTex;
            sampler2D _TopSnowTex;
            sampler2D _HeightMap;

            float _HeightScale;
            float _Zone1;
            float _Zone2;
            float _BlendWidth;

            float2 _BoundsMin;
            float2 _BoundsMax;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 world : TEXCOORD1;
            };

            v2f vert(appdata v)
            {
                v2f o;
                float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                float2 sampleUV = (worldPos.xz - _BoundsMin) / (_BoundsMax - _BoundsMin);
                float heightSample = tex2Dlod(_HeightMap, float4(sampleUV, 0, 0)).r;
                worldPos.y += heightSample * _HeightScale;

                o.pos = UnityObjectToClipPos(float4(worldPos, 1));
                o.world = worldPos;
                o.uv = v.uv;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float h = i.world.y;

                float3 texGround = tex2D(_GroundTex, i.uv).rgb;
                float3 texMid = tex2D(_CrackSnowTex, i.uv).rgb;
                float3 texTop = tex2D(_TopSnowTex, i.uv).rgb;

                float w1 = smoothstep(_Zone1 - _BlendWidth, _Zone1 + _BlendWidth, h);
                float w2 = smoothstep(_Zone2 - _BlendWidth, _Zone2 + _BlendWidth, h);

                float3 blend1 = lerp(texGround, texMid, w1);
                float3 finalCol = lerp(blend1, texTop, w2);

                return float4(finalCol, 1);
            }
            ENDCG
        }
    }

    FallBack "Diffuse"
}
