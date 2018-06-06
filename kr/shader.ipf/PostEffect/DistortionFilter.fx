#ifndef __DISTORTIONFILTER_FX__
#define __DISTORTIONFILTER_FX__

float	distortionLevel = 0.01;

texture TargetTex;
sampler2D targetTex = sampler_state
{
    Texture = <TargetTex>;
	MinFilter = Linear; 
	MagFilter = Linear;
	AddressU = Clamp; 
	AddressV = Clamp;
    SRGBTEXTURE = TRUE;
};

texture DistSourceTex;
sampler2D sourceTex = sampler_state
{
    Texture = <DistSourceTex>;
	MinFilter = Linear; 
	MagFilter = Linear;
	AddressU = Clamp; 
	AddressV = Clamp;
    SRGBTEXTURE = TRUE;
};

float4 PS_Distortion( float2 uv : TEXCOORD0 ) : COLOR0
{
	
	float2 distortionNormal	= tex2D( sourceTex, uv  ).xy;
	//distortionNormal = (distortionNormal - 0.5f) * 2.0f;
	distortionNormal *= distortionLevel;	
	float4 ret = tex2D( targetTex, uv+distortionNormal );
	return ret;
}

technique DistortionTq
{
	pass P0 {
		PixelShader		= compile ps_2_0 PS_Distortion();	
	}
}

#endif	//__DISTORTIONFILTER_FX__