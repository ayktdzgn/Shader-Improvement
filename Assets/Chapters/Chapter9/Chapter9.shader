Shader "Unlit/Chapter9"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float3 worldPos : TEXCOORD0;
                float4 position : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.position = UnityObjectToClipPos(v.vertex);
                float4 worldPos= mul(unity_ObjectToWorld, v.vertex);
                o.worldPos = worldPos.xyz;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 uv_front = TRANSFORM_TEX(i.worldPos.xy,_MaintTex);
                float2 uv_side = TRANSFORM_TEX(i.worldPos.zy,_MaintTex);
                float2 uv_top = TRANSFORM_TEX(i.worldPos.xz,_MaintTex);

                

                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
