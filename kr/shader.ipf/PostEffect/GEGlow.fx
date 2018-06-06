#ifndef __IMCGEGLOW_FX__
#define __IMCGEGLOW_FX__

texture TargetTex;
sampler targetTex = sampler_state
{
    Texture = (TargetTex);
	SRGBTEXTURE = TRUE;
};

#ifdef ENABLE_GE_GLOW

float	g_blurBlendFactor = 0.4f;
float	g_blurPowFactor = 1.0f;
float	g_blurMax = 0.0f;

texture BlurTex;
sampler blurTex = sampler_state
{
    Texture = (BlurTex);
	SRGBTEXTURE = TRUE;
};
#endif

#ifdef ENABLE_VIGNETTE 
float	g_vignetteMinValue = 0.6f;
float	g_vignetteMaxValue = 1.5f;
float	g_vignetteCorrectValue = 0.65f;
float3 	g_vignetteColor = float4(0.0f, 0.0f, 0.0f, 0.0f);
float2	g_vignetteCenterPos = float2(0.5f, 0.5f);

float3 vignette(in float3 c, const float2 win_bias)
{
	float2 wpos = 2*(win_bias - g_vignetteCenterPos);
	float r = length(wpos.xy);
	r = 1.0 - smoothstep(g_vignetteMinValue, g_vignetteMaxValue, r) * g_vignetteCorrectValue;
	return (r * c) + ((1.0f - r) * g_vignetteColor);
}
#endif

#ifdef ENABLE_SPOTLIGHT

float4	g_warFogColor;

texture ShadowTex;
sampler shadowTex = sampler_state
{
    Texture = (ShadowTex);
	SRGBTEXTURE = TRUE;
};
#endif

float4 PS_GEGlow(in float2 Tex : TEXCOORD0) : COLOR
{
    float3 srcColor = tex2D(targetTex, Tex.xy).rgb;

	/*
#ifdef ENABLE_SPOTLIGHT
	float3 shadowColor = tex2D(shadowTex, Tex.xy);	
	shadowColor = pow(shadowColor, 2.2f);
	
	float3 calcSum = srcColor - shadowColor;
	float3 maxColor = max(0.0f, calcSum); 
	float3 invSum = srcColor - maxColor;
	float3 alphaColor = smoothstep(calcSum, srcColor, invSum * g_warFogColor.a);		
	float alpha = min(alphaColor , g_warFogColor.a);	
	srcColor = ((1.0f - alpha) * srcColor) + (alpha * g_warFogColor);		
#endif
	*/

#ifdef ENABLE_GE_GLOW
	float3 addColor = pow(g_blurBlendFactor * tex2D(blurTex, Tex.xy).rgb, g_blurPowFactor);
	addColor = min( addColor, float3(g_blurMax, g_blurMax, g_blurMax));
	srcColor = srcColor + addColor;
#endif

#ifdef ENABLE_VIGNETTE
	srcColor = vignette(srcColor, Tex.xy); 
#endif

	return float4(srcColor, 1.0f);
}

float4 PS_Glow(in float2 Tex : TEXCOORD0) : COLOR
{
	//float3 srcColor = tex2D(targetTex, Tex.xy).rgb;
	float3 srcColor = tex2D(blurTex, Tex.xy) * 2.f;

#ifdef ENABLE_VIGNETTE
	//srcColor = vignette(srcColor, Tex.xy);
#endif

	return float4(srcColor, 1.f);
}

technique GEGlowTq
{
    pass P0
	{
		SRGBWRITEENABLE = TRUE;
        PixelShader = compile ps_3_0 PS_GEGlow();
    }
}

technique GlowTq
{
	pass P0
	{
		AlphaBlendEnable = true;
		SRGBWRITEENABLE = TRUE;
		PixelShader = compile ps_3_0 PS_Glow();
	}
}

#endif //__IMCGEGLOW_FX__