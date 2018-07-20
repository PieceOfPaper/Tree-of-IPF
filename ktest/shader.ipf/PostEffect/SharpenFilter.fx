#ifndef __SHARPENFILTER_FX__
#define __SHARPENFILTER_FX__

float2 g_TextureSize;
texture TargetTex;
sampler2D targetTex = sampler_state
{
    Texture = <TargetTex>;
    AddressU = Clamp;
    AddressV = Clamp;
    MinFilter = Point;
    MagFilter = Point;
    MipFilter = Point;
	SRGBTEXTURE = TRUE;
};


float g_Power = 0.3f;

float4 SharpenFilterPS( float2 Tex : TEXCOORD0 ) : COLOR0
{
	float2 sampling = 1.0f / g_TextureSize;
	float4 Color = (tex2D(targetTex, Tex) * ( 4 + 1/g_Power ) -
				    tex2D(targetTex, Tex + sampling * float2( 0.0f, -1.0f) ) -
				    tex2D(targetTex, Tex + sampling * float2( 0.0f,  1.0f) ) -
				    tex2D(targetTex, Tex + sampling * float2(-1.0f,  0.0f) ) -
				    tex2D(targetTex, Tex + sampling * float2( 0.0f,  0.0f) ) );
	Color *= g_Power;
	return Color;
}

technique SharpenFilterTq
{
    pass p0
    {
		SRGBWRITEENABLE = TRUE;
        PixelShader = compile ps_2_0 SharpenFilterPS();
    }
}

#endif //__SHARPENFILTER_FX__