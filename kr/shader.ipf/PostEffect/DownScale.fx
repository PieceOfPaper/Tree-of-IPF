#ifndef __IMCDOWNSCALE_FX__
#define __IMCDOWNSCALE_FX__

static const int MAX_SAMPLES = 16;    // Maximum texture grabs
	
float2 g_texSampleOffSet[MAX_SAMPLES];

texture TargetTex;
sampler targetTex = sampler_state
{
    Texture = (TargetTex);
	ADDRESSU	= CLAMP;
	ADDRESSV 	= CLAMP;
	MINFILTER	= POINT;
	SRGBTEXTURE = TRUE;
};

float4 DownScale4x4( in float2 vScreenPosition : TEXCOORD0) : COLOR
{
	float4 sample = 0.0f;
	for( int i=0; i < 16; i++ )	{
		sample += tex2D( targetTex, vScreenPosition + g_texSampleOffSet[i] );
	}
	return sample / 16;
}

technique DownScale4x4Tq
{
    pass P0
    {
        PixelShader  = compile ps_3_0 DownScale4x4();
    }
}

float4 DownScale2x2(in float2 vScreenPosition : TEXCOORD0) : COLOR
{
	float4 sample = 0.0f;
	for ( int i = 0 ; i < 4 ; i++ ) {
		sample += tex2D( targetTex, vScreenPosition + g_texSampleOffSet[i] );
	}    
	return sample / 4;
}

technique DownScale2x2Tq
{
    pass P0
    {
        PixelShader  = compile ps_2_0 DownScale2x2();
    }
}

#endif