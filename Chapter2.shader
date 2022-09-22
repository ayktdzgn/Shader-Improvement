Shader "Unlit/Chapter2"
{
    Properties
    {
        _Color ("Color",Color) = (0,0,0,1)
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
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _Color;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);

                //col *= _Color;

                //if(step(0.4, i.uv.x) && step(i.uv.y,0.4)) col *= fixed4(1,0,0,1);
                //if(step(0.6, i.uv.y) && step(i.uv.x, 0.6)) col *= fixed4(0,1,0,1);
                //if(step(0.6, i.uv.x) && step(0.4, i.uv.y)) col *= fixed4(0,0,1,1);

                if(step(i.uv.x,0.5) && step(0.5,i.uv.y)) col *= fixed4(0,1,0,1) * smoothstep(0,0.5,i.uv.x) * smoothstep(1,0.5,i.uv.y);
                if(step(i.uv.x,0.5) && step(i.uv.y,0.5)) col *= fixed4(0,0,1,1) * smoothstep(0,0.5,i.uv.x) * smoothstep(0,0.5,i.uv.y);

                if(step(0.5,i.uv.x) && step(0.5,i.uv.y)) col *= fixed4(1,0,0,1) * smoothstep(1,0.5,i.uv.x) * smoothstep(1,0.5,i.uv.y);
                if(step(0.5,i.uv.x) && step(i.uv.y, 0.5)) col *= _Color * smoothstep(1,0.5,i.uv.x) * smoothstep(0,0.5,i.uv.y);

                
                 //col *= fixed4(1,0,0,1) + smoothstep(0.5,1,i.uv.x);
                // 0.5 < x < 0.6

                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
