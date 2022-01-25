Shader "NormalEmittMaterial/NormalEmittMaterial" {
	Properties {
		_BeamColor("Color", Color) 						= (1.0, 1.0, 1.0, 1.0)
		_MaxEmmisive("Max Emmisive", Range(0.0, 2.0)) 	= 1.0
		_Speed("Speed", Float)							= 1.0
	}
	SubShader {
		Tags {
			"RenderType"	= "Transparent"
			"Queue"			= "Transparent"
		}
		
		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows alpha:blend
		#pragma target 3.0

		struct Input {
			float2 uv_BumpMap;
			float3 worldNormal;
			float3 viewDir;
		};

		float4 _BeamColor;
		float  _MaxEmmisive;
		float  _Speed;

		void surf (Input IN, inout SurfaceOutputStandard o) {
			float      PI = 3.1415;
			fixed  limPow = 1.0 - abs( dot( IN.viewDir, IN.worldNormal ));
			
			float size = 0.01;
			float light_base = pow( limPow, 8.0);

			float scale = (1.0 - abs( sin( _Time.w * 4.0 * _Speed ))) + 1.0; 
			size = 0.05 * scale;
			float light = (limPow + pow( limPow, 2.0 )) * scale;

			o.Albedo 	= float3( 0.0, 0.0, 0.0 );
			o.Emission 	= max(0.0f, min( float3( _BeamColor.r, _BeamColor.g, _BeamColor.b )*light + float3( light_base, light_base, light_base), _MaxEmmisive));
			o.Alpha		= _BeamColor.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}