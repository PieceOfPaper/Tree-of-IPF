#ifndef __GAUSSIANBLUR_FILTER_FX__
#define __GAUSSIANBLUR_FILTER_FX__

texture TargetTex;
sampler2D g_targetColor = sampler_state
{
    Texture = <TargetTex>;
    AddressU = Clamp;
    AddressV = Clamp;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
	SRGBTEXTURE = TRUE;
};

static const int KERNEL_SIZE = 13;
static const int CHECAP_KERNEL_SIZE = 7;

float2 PixelKernelH[KERNEL_SIZE];
float2 PixelKernelV[KERNEL_SIZE];

float g_BlurWeight[KERNEL_SIZE] = 
{
    0.002216,
    0.008764,
    0.026995,
    0.064759,
    0.120985,
    0.176033,
    0.199471,
    0.176033,
    0.120985,
    0.064759,
    0.026995,
    0.008764,
    0.002216,
};

float4 GaussianBlurPSHorizon( float2 screenQuard : TEXCOORD0 ) : COLOR0
{
    float3 Color = 0;
	for (int i = 0; i < CHECAP_KERNEL_SIZE; i++) {    
        Color += tex2D( g_targetColor, screenQuard + PixelKernelH[i].xy ).rgb * g_BlurWeight[i];
    }
	#ifdef ENABLE_ALPHA_PRESERVE
		return float4(Color, tex2D(g_targetColor, screenQuard).a);
	#else
		return float4(Color, 1.0f);
	#endif
}

float4 GaussianBlurPSVertical( float2 screenQuard : TEXCOORD0 ) : COLOR0
{
    float3 Color = 0;
    for (int i = 0; i < CHECAP_KERNEL_SIZE; i++) {    
        Color += tex2D( g_targetColor, screenQuard + PixelKernelV[i].xy ).rgb * g_BlurWeight[i];
    }
	#ifdef ENABLE_ALPHA_PRESERVE
		return float4(Color, tex2D(g_targetColor, screenQuard).a);
	#else
		return float4(Color, 1.0f);
	#endif
}

technique GaussianBlurPSVerticalTq
{
    pass p0
    {
		SRGBWRITEENABLE = TRUE;
        PixelShader = compile ps_2_0 GaussianBlurPSVertical();
    }
}

technique GaussianBlurPSHorizonTq
{
    pass p0
    {
		SRGBWRITEENABLE = TRUE;
        PixelShader = compile ps_2_0 GaussianBlurPSHorizon();
    }
}

#endif	//__GAUSSIANBLUR_FILTER_FX__