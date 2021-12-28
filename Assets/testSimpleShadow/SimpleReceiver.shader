Shader "Simple/SimpleReceiver"
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

			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 pos:TEXCOORD1;
				float4 vertex : SV_POSITION;
			};
			

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _depthTexture;
			//变换到灯光摄像机的 vp矩阵 从外部传入
			float4x4 _vpMatrix;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				//vp矩阵和m矩阵相乘 组合出光源空间下的mvp
				_vpMatrix = mul(_vpMatrix, unity_ObjectToWorld);
				o.pos = mul(_vpMatrix,v.vertex);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				//对深度图在屏幕空间下进行采样
				fixed4 dcol = tex2Dproj(_depthTexture,i.pos);
				//把取得的值进行解码，获取深度图时的EncodeFloatRGBA
				float d = DecodeFloatRGBA(dcol);
				float d1 = i.vertex.z / i.vertex.w;
				if (d1 > d)
				{
					col *= 0.5;
				}
				return col;
			}
			ENDCG
		}
	}
}
