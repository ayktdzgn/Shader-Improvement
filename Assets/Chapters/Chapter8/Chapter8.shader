Shader "Unlit/Chapter8"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _SecondTex ("Second Texture", 2D) = "black" {}
        _BlendTex("Blend Tex",2D) = "gray" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue" = "Geometry"}
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
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            sampler2D _SecondTex;
            sampler2D _BlendTex;

            float4 _MainTex_ST;
            float4 _SecondTex_ST;
            float4 _BlendTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 main_uv = TRANSFORM_TEX(i.uv , _MainTex);
                float2 secondary_uv = TRANSFORM_TEX(i.uv , _SecondTex);
                float2 blend_uv = TRANSFORM_TEX(i.uv , _BlendTex);

                fixed4 main_col = tex2D(_MainTex , main_uv);
                fixed4 second_col = tex2D(_SecondTex , secondary_uv);
                fixed4 blend_col = tex2D(_BlendTex , blend_uv);

                float blend_value = blend_col.r;

                fixed4 col = lerp(main_col , second_col , blend_value);
                return col;
            }
            ENDCG
        }
    }
}
