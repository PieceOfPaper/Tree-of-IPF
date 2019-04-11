#ifndef ___IMC__ZDEPTH__FX__
#define ___IMC__ZDEPTH__FX__

extern texture g_sprTexture0;
extern float g_renderAlpha;

sampler g_sampler0 = sampler_state
{
    Texture = (g_sprTexture0);
	SRGBTEXTURE = TRUE;
};

struct VS_INPUT
{
	vector diffuse  : COLOR;
    float2 tex		: TEXCOORD0;
};

struct VS_OUTPUT
{
    vector diffuse  : COLOR;
    float depth		: DEPTH;
};

//float4 g_emptyDefine = float4(1.0f, 0.0f, 0.0f, 1.0f);
float4 g_noColor = float4(0.0f, 0.0f, 0.0f, 0.0f);

const float fWidth = 100.0f;

const float2 samples2[4] = {
 0.0,-1.0,
-1.0, 0.0,
 1.0, 0.0,
 0.0, 1.0,
};

VS_OUTPUT PS_ZDepth(VS_INPUT input)
{
	VS_OUTPUT output = (VS_OUTPUT) 0;

	for (int i = 0 ; i < 4 ; i ++)
	{
		float4 nearByPixel = tex2D(g_sampler0, input.tex + samples2[i]/float2(fWidth,fWidth));
		if (nearByPixel.r == 0.0f
			&& nearByPixel.g == 0.0f
			&& nearByPixel.b == 0.0f
			&& nearByPixel.a == 0.0f
		)
		{
			output.diffuse = g_noColor;
			output.depth = 1.0f;
		}
	}	
	
	if (output.depth != 1.0f)
	{
		float4 col0 = tex2D(g_sampler0, input.tex);
		if ((col0.r == g_noColor.r 
			&& col0.g == g_noColor.g 
			&& col0.b == g_noColor.b)
			&& col0.a == g_noColor.a
			)
		{
			output.diffuse = g_noColor;
			output.depth = 1.0f;
		}  else {
			output.diffuse = float4(col0.r, col0.g, col0.b, g_renderAlpha);
			output.depth = 0.5f + 0.1f * (0.5f - col0.a);
		}
	}
	
	return output;
}

technique ZDepthTq
{
    pass P0
	{
		SRGBWRITEENABLE = TRUE;
		PixelShader = compile ps_2_0 PS_ZDepth();
    }
}

#endif // ___IMC__ZDEPTH__FX__