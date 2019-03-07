texture DiffuseTex : DIFFUSE_TEX;
sampler diffuseTex = sampler_state
{
	Texture = (DiffuseTex);

	AddressU = WRAP;
	AddressV = WRAP;
};

float4 g_tex_view_size;
#define g_textureSize g_tex_view_size.xy
#define g_viewportSize g_tex_view_size.zw

float4 g_sourceRect;

float4 g_textureColor[32];
float4x4 g_transform[32];

struct VS_OUT
{
	float4 position : POSITION;
	float2 texcoord : TEXCOORD0;
	float4 color : COLOR;
};

VS_OUT VS(in float4 inPosition : POSITION, in float2 inTexCoord : TEXCOORD0, in float inInstancingID : TEXCOORD1)
{
	const int instancingID = (int)(inInstancingID + 1e-5f);

	float4 positionSS = float4(inPosition.xy * g_sourceRect.zw, 0.f, 1.f);
	positionSS = mul(positionSS, g_transform[instancingID]);

	float4 positionDS = positionSS;
	positionDS = positionDS * 2.f - 1.f;

	float2 outTexCoord = inTexCoord;
	outTexCoord.xy *= g_sourceRect.zw / g_textureSize;
	outTexCoord.xy += g_sourceRect.xy / g_textureSize;

	VS_OUT output;
	output.position = positionDS;
	output.texcoord = outTexCoord;
	output.color = g_textureColor[instancingID];
	return output;
}

float4 PS(in VS_OUT input) : COLOR
{
	float4 texColor = tex2D(diffuseTex, input.texcoord);
	texColor *= input.color;
	return texColor;
}

float4 PS_Brighten(in VS_OUT input) : COLOR
{
	float4 texColor = tex2D(diffuseTex, input.texcoord);
	texColor.rgb += input.color.rgb;
	return texColor;
}

technique Sprite
{
	pass P0
	{
		VertexShader = compile vs_3_0 VS();
		PixelShader = compile ps_3_0 PS();
	}
}

technique Sprite_Brighten
{
	pass P0
	{
		VertexShader = compile vs_3_0 VS();
		PixelShader = compile ps_3_0 PS_Brighten();
	}
}