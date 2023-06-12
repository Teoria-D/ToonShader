Shader "Custom/HelloShaderv2"
{
    Properties
    {
        [NoScaleOffset] _Daycolor ("Day Color", 2D) = "white" {}
        [NoScaleOffset] _Nightcolor ("Night Color", 2D) = "black" {}
        [NoScaleOffset] _NightShadow ("Night Shadow",2D) = "grey" {}
    }
    SubShader
    {
        Tags{ "RenderType"="Opaque" }
        Pass
        {
            CGPROGRAM   

            #pragma vertex vert    
            #pragma fragment frag
            #include "UnityCG.cginc"
            fixed4 _Color;
            struct appdata
            {
                float4 vertex : POSITION;
                float3 N : NORMAL;
                float2 uv : TEXCOORD0;
            };
            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float2 uv2 :TEXCOORD1;
                float3 LV: TEXCOORD4;
                float4 L : TEXCOORD3;
                float4 T : TEXCOORD2;                
                float3 N : NORMAL;
            };
            sampler2D _Daycolor;
            float4 _Daycolor_ST;
            sampler2D _Nightcolor;
            float4 _Nightcolor_ST;
            sampler2D _NightShadow;
            float4 _NightShadow_ST;
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.N = UnityObjectToWorldNormal(v.N);
                o.uv = TRANSFORM_TEX(v.uv, _Daycolor);
                o.uv2 = TRANSFORM_TEX(v.uv, _Nightcolor);
                o.LV = WorldSpaceLightDir(v.vertex);
                o.L = dot(v.N,o.LV);
                o.T = step(0.0,o.L);
                return o;
            }
            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 DayC = tex2D(_Daycolor,i.uv);
                fixed4 NightC = tex2D(_Nightcolor,i.uv2);
                fixed4 NightS = tex2D(_NightShadow,i.uv2);
                float3 LV = normalize(i.LV);
                float4 Toon = clamp(i.T,0.0,1.0);             
                float4 col = lerp(NightC*NightS,DayC,Toon);
                return col;
            }

            ENDCG   
        }
    }
}