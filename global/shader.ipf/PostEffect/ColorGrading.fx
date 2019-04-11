#ifndef __COLORGRADING_FX__
#define __COLORGRADING_FX__

texture TargetTex;
sampler2D targetTex = sampler_state
{
    Texture = <TargetTex>;
	AddressU = WRAP;
	AddressV = WRAP;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
	SRGBTEXTURE = FALSE;
};

texture RGBTex;
sampler2D rgbTex = sampler_state
{
    Texture = <RGBTex>;
	AddressU = WRAP;
	AddressV = WRAP;
	AddressW = WRAP;
	MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
	SRGBTEXTURE = FALSE;
};

float4 PS_ColorGrading(in float4 uv : TEXCOORD0) : COLOR
{
	float3 color = tex2D(targetTex, uv);

	float2 Offset = float2(0.5f / 256.0f, 0.5f / 16.0f);
	float Scale = 15.0f / 16.0f; 

	float IntB = floor(color.b * 14.9999f) / 16.0f;
	float FracB = color.b * 15.0f - IntB * 16.0f;
		
	float U = IntB + color.r * Scale / 16.0f;
	float V = color.g * Scale;

	half3 RG0 = tex2D(rgbTex, Offset + float2(U, V)).rgb;
	half3 RG1 = tex2D(rgbTex, Offset + float2(U + 1.0f / 16.0f, V)).rgb;
	return float4(lerp(RG0, RG1, FracB), 1.0f);
}

technique ColorGradingTq {
	pass p0 {
		PixelShader		= compile ps_2_0 PS_ColorGrading();
	}	
}

#endif //__COLORGRADING_FX__