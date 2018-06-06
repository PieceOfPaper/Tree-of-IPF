#ifndef __FXAA_FILTER_FX__
#define __FXAA_FILTER_FX__

#define FXAA_PC 1
#define FXAA_HLSL_3 1

#include "PostEffect\FxAA_NVidia.fx"

texture TargetTex;
sampler targetTex = sampler_state
{
    Texture = (TargetTex);
	MinFilter = LINEAR;
	MagFilter = LINEAR;
	MipFilter = POINT;
	AddressU = CLAMP;
	AddressV = CLAMP;
	SRGBTEXTURE = FALSE;
};

float2 g_texelSize;	

float4 PS_FxAAFilter(in float2 UV : TEXCOORD0) : COLOR
{
	float4 disableParm = float4(0.0f, 0.0f, 0.0f, 0.0f);
	return FxaaPixelShader(UV, disableParm, targetTex, g_texelSize, disableParm);
}

technique FxAAFilterTq
{
    pass P0 {
		SRGBWRITEENABLE = FALSE;
        PixelShader = compile ps_3_0 PS_FxAAFilter();
    }
}

#endif