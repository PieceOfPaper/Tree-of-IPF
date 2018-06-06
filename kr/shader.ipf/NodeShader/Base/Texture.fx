#ifndef __TEXTURE_FX__
#define __TEXTURE_FX__

texture StaticLightTex : STATICLIGHT_TEX;
sampler staticLightTex = sampler_state
{
	Texture = (StaticLightTex);
	AddressU = CLAMP;
	AddressV = CLAMP;
	MinFilter = LINEAR;
	MagFilter = LINEAR;
	MipFilter = LINEAR;
	SRGBTEXTURE = TRUE;
};

texture TerrainShadowTex : TERRAIN_SHADOW_TEX;
sampler terrainShadowTex = sampler_state
{
	Texture = (TerrainShadowTex);
	AddressU = BORDER;
	AddressV = BORDER;
	BorderColor = 0xFFFFFFFF;
	MinFilter = LINEAR;
	MagFilter = LINEAR;
	MipFilter = NONE;
	SRGBTEXTURE = TRUE;
};

texture EnvironmentLightTex : ENVIRONMENTLIGHT_TEX;
sampler environmentLightTex = sampler_state
{
	Texture = (EnvironmentLightTex);
	MinFilter = LINEAR;
	MagFilter = LINEAR;
	MipFilter = LINEAR;
	SRGBTEXTURE = TRUE;
};

texture ScreenDiffuseTex : SCREEN_DIFFUSE_TEX;
sampler screenDiffuseTex = sampler_state
{
	Texture = (ScreenDiffuseTex);
	AddressU = CLAMP;
	AddressV = CLAMP;
	MinFilter = LINEAR;
	MagFilter = LINEAR;
	MipFilter = NONE;
	SRGBTEXTURE = TRUE;
};

texture ScreenNormalTex : SCREEN_NORMAL_TEX;
sampler screenNormalTex = sampler_state
{
	Texture = (ScreenNormalTex);
	AddressU = CLAMP;
	AddressV = CLAMP;
	MinFilter = LINEAR;
	MagFilter = LINEAR;
	MipFilter = NONE;
	SRGBTEXTURE = FALSE;
};

texture ScreenSpecularTex : SCREEN_SPECULAR_TEX;
sampler screenSpecularTex = sampler_state
{
	Texture = (ScreenSpecularTex);
	AddressU = CLAMP;
	AddressV = CLAMP;
	MinFilter = LINEAR;
	MagFilter = LINEAR;
	MipFilter = NONE;
	SRGBTEXTURE = TRUE;
};

texture ScreenDepthTex : SCREEN_DEPTH_TEX;
sampler screenDepthTex = sampler_state
{
	Texture = (ScreenDepthTex);
	AddressU = CLAMP;
	AddressV = CLAMP;
	MinFilter = LINEAR;
	MagFilter = LINEAR;
	MipFilter = NONE;
	SRGBTEXTURE = FALSE;
};

texture LightMaskTex : LIGHTMASK_TEX;
sampler lightMaskTex = sampler_state
{
	Texture = (LightMaskTex);
	AddressU = CLAMP;
	AddressV = CLAMP;
	MinFilter = LINEAR;
	MagFilter = LINEAR;
	MipFilter = NONE;
	SRGBTEXTURE = FALSE;
};

texture LppLightTex : LPPLIGHT_TEX;
sampler lppLightTex = sampler_state
{
	Texture = (LppLightTex);
	AddressU = CLAMP;
	AddressV = CLAMP;
	MinFilter = LINEAR;
	MagFilter = LINEAR;
	MipFilter = NONE;
	SRGBTEXTURE = TRUE;
};

#ifdef ENABLE_VTFSKINNING
texture VTF_Tex : SKIN_VTF_TEX;
sampler vtf_skin  = sampler_state {
	Texture = (VTF_Tex);
};
#endif

#ifdef ENABLE_STATICLIGHTTEX_TM
	float4x4 g_StaticLightMapTexTM : MATERIAL_STATICLIGHTMAP_TM;
#endif
float g_EnvironmentLightTexMipLevels	: ENVIRONMENTLIGHT_TEX_MIPLEVELS;

float4 Texture_GetStaticLightColor(float2 texCoord)
{
	return tex2D(staticLightTex, texCoord);
}

float4 Texture_GetTerrainShadowColor(float2 texCoord)
{
	return tex2D(terrainShadowTex, texCoord);
}

float4 Texture_GetEnvironmentLightColor(float3 texCoord)
{
	return texCUBE(environmentLightTex, texCoord);
}

float4 Texture_GetEnvironmentLightColorBias(float4 texCoord)
{
	return texCUBEbias(environmentLightTex, texCoord);
}

float4 Texture_GetEnvironmentLightColorLOD(float4 texCoord)
{
	return texCUBElod(environmentLightTex, texCoord);
}

float4 Texture_GetLightMaskColor(float2 texCoord)
{
	return tex2D(lightMaskTex, texCoord);
}

float4 Texture_GetLightPrePassColor(float2 texCoord)
{
	return tex2D(lppLightTex, texCoord);
}

float4 Texture_GetScreenDiffuseColor(float2 texCoord)
{
	return tex2D(screenDiffuseTex, texCoord);
}

float4 Texture_GetScreenNormalColor(float2 texCoord)
{
	return tex2D(screenNormalTex, texCoord);
}

float4 Texture_GetScreenSpecularColor(float2 texCoord)
{
	return tex2D(screenSpecularTex, texCoord);
}

float4 Texture_GetScreenDepthColor(float2 texCoord)
{
	return tex2D(screenDepthTex, texCoord);
}

#endif //__TEXTURE_FX__
