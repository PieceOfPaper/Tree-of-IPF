#ifndef __BEFORELOADSHADER_FX__
#define __BEFORELOADSHADER_FX__

#include "NodeShader\Base\GlobalVariable.fx"
#include "NodeShader\Base\Texture.fx"

texture DiffuseTex : DIFFUSE_TEX;
sampler diffuseTex = sampler_state
{
	Texture = (DiffuseTex);
	AddressU = WRAP;
	AddressV = WRAP;
	SRGBTEXTURE = TRUE;
};

#ifdef ENABLE_VTFSKINNING
	float4x4 GetSkinMatrix(int idx)
	{
		const float TEX_WIDTH  = 512.0f;
		const float TEX_HEIGTH = 512.0f;
		float4 uvCol = float4(((float)((idx % 128) * 4) + 0.5f) / TEX_WIDTH, ((float)((idx/128)) + 0.5f) / TEX_HEIGTH, 0.0f, 0);
		
		//tranpose가 있으므로 이렇게 값을 집어 넣는다.
		float4x4 mat;	
		mat._11_21_31_41 = tex2Dlod(vtf_skin, uvCol),
		mat._12_22_32_42 = tex2Dlod(vtf_skin, uvCol + float4(1.0f/TEX_WIDTH, 0.0f, 0.0f, 0)),
		mat._13_23_33_43 = tex2Dlod(vtf_skin, uvCol + float4(2.0f/TEX_WIDTH, 0.0f, 0.0f, 0)),
		mat._14_24_34_44 = float4(0.0f, 0.0f, 0.0f, 1.0f);
		return mat;
	}
#endif

#ifdef ENABLE_INSTANCING_SHADERARRAY
float4x4 g_instanceTMArray[50] : INSTANCE_TMARRAY;
#endif

struct VS_OUT
{
	float4 Pos				: POSITION;
	float4 diffuseTexCoord	: TEXCOORD0;
	float4 worldNml			: TEXCOORD1;
};

VS_OUT VS_ModelShader(in float4 InPos : POSITION, in float4 InNml : NORMAL, in float4 Tex : TEXCOORD0
#ifdef ENABLE_INSTANCING_SHADERARRAY
					 , in float tmIndex : TEXCOORD2
#endif
#ifdef ENABLE_SKINNING
					 , in float4 weights : BLENDWEIGHT, in float4 indices : BLENDINDICES
#endif
                     )
{
	VS_OUT o = (VS_OUT)0;

	int boneIDIndex = 0;
#if defined(ENABLE_INSTANCING_SHADERARRAY)
	int tmIndex2 = (int)tmIndex;
	float4x4 WorldTM = g_instanceTMArray[(int) tmIndex2];
	#if defined(ENABLE_SKINNING) && defined(ENABLE_VTFSKINNING)
		boneIDIndex = (int)WorldTM._24;
	#endif
	WorldTM._24 = 0.0f;
	float4x4 WorldViewTM 		= mul(WorldTM, g_ViewTM);
	float4x4 WorldViewProjTM 	= mul(WorldTM, g_ViewProjTM);
#else
	#if defined(ENABLE_SKINNING) && defined(ENABLE_VTFSKINNING)
		boneIDIndex = g_boneTexID;
	#endif	
	float4x4 WorldTM 			= g_WorldTM;
	float4x4 WorldViewTM 		= g_WorldViewTM;
	float4x4 WorldViewProjTM 	= g_WorldViewProjTM;
	float4x4 ViewProjTM 		= g_ViewProjTM;
#endif		

	// Position
	float4 localPos = 0;
	float4 localNml = 0;
#ifdef ENABLE_SKINNING
	float4 indices2 = D3DCOLORtoUBYTE4(indices);
	#ifdef ENABLE_VTFSKINNING
		for ( int i = 0 ; i < 4 ; ++i ) {
			float4x4 boneTM = GetSkinMatrix(indices2[i]+boneIDIndex);
			localPos.xyz += mul( float4( InPos.xyz, 1.0f ), boneTM) * weights[i];
			localNml.xyz += mul( InNml.xyz, boneTM ) * weights[i];
		}			
	#else
		for ( int i = 0 ; i < 4 ; ++i ) {
			localPos.xyz += mul( float4( InPos.xyz, 1.0f ), g_BoneTM[ indices2[i] ] ) * weights[i];
			localNml.xyz += mul( InNml.xyz, g_BoneTM[ indices2[i] ]) * weights[i];
		}
	#endif
	localNml = normalize( localNml );
#else
	localPos = InPos;
	localNml = InNml;
#endif

	o.Pos = mul(float4(localPos.xyz, 1.0f), WorldViewProjTM);
	o.diffuseTexCoord.xy = Tex.xy;
	o.worldNml = mul(float4(localNml.xyz, 0.0f), WorldTM);

	return o;	
}

float4 PS_ModelShader(VS_OUT In) : COLOR
{
	return float4(0.5f, 0.5f, 0.5f, 1.0f);
#ifdef ENABLE_DIFFUSETEX
	return tex2D(diffuseTex, In.diffuseTexCoord);
#else 
	float3 lightDir = -g_WorldLightDir;
	float lightFactor = max(0.0f, dot(In.worldNml, lightDir));
	return float4(lightFactor, lightFactor, lightFactor, 1.0f);
#endif
}

technique DefaultMainTq 
{
	pass P0 {
		VertexShader = compile vs_3_0 VS_ModelShader();	
		PixelShader  = compile ps_3_0 PS_ModelShader();	
	}
}

#endif	//__BEFORELOADSHADER_FX__