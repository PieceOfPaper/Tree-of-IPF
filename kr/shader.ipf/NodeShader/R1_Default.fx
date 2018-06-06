// G2 - Material Node Editor .FX file
//
//	Name : character_default
//	Date : 
//	Desc : 
//

#define _USE_LIGHT_SHADING
#define _USE_DIFFUSE_MAP

#include "NodeShader\Base\BaseFXBegin.fxh"

texture	tex0:DIFFUSE_TEX
<
	string UIName = "DIFFUSE_TEX";
	string ResourceName = "char_hi/monster_lavalarva_d.dds";
>;
sampler2D sampler0 = sampler_state
{
	Texture = <tex0>;
	SRGBTexture = FALSE;
	MipFilter = LINEAR;
	AddressU = WRAP;
	AddressV = WRAP;
};

float3 GetDiffuseColor( vs_out In )
{
	float4	local0 = tex2D( sampler0, In.uv0.xy );
	return	local0;
}

float3 GetNormalMap( vs_out In )
{
	return	float3(0,0,1);
}

float3 GetSpecularColor( vs_out In )
{
	return	0;
}

float GetSpecularPower( vs_out In )
{
	return	0.25;
}

float GetOpacity( vs_out In )
{
	return	1;
}

float3 GetEmissive( vs_out In )
{
	return	0;
}

float2 GetDistortionNormal( vs_out In )
{
	return	0;
}

float3 GetMask( vs_out In )
{
	return	0;
}

#include "NodeShader\Base\BaseFXEnd.fxh"

