#ifndef __IMCDECAL_FX__
#define __IMCDECAL_FX__

float4x4 	g_ViewProjTM;
float 		g_SunLightIntensity;

texture DecalTex;
sampler2D decalTex = sampler_state
{
    Texture = <DecalTex>;
    AddressU = WRAP;
    AddressV = WRAP;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    SRGBTEXTURE = TRUE;
};

struct VS_OUT {
	float4 vPos : POSITION0;
	float4 color : COLOR;
	float4 Tex0 : TEXCOORD0;
};

VS_OUT DecalVS(
			in float4 worldPos : POSITION0,
			in float4 color : COLOR,
			in float2 Tex0 : TEXCOORD0
			)
{
	VS_OUT o = (VS_OUT)0;
	o.vPos = mul(worldPos, g_ViewProjTM);
	o.Tex0.xy = Tex0;
	o.color = color;
	return o;
}

float4 DecalPS(in VS_OUT In) : COLOR
{
	float4 texColor = tex2D(decalTex, In.Tex0.xy);
	texColor.rgb *= g_SunLightIntensity;
	texColor *= In.color;
	
	return texColor;
}

technique DecalTq
{
    pass p0
    {
		VertexShader 	= compile vs_3_0 DecalVS() ;
        PixelShader 	= compile ps_3_0 DecalPS();
    }
}

#endif //__IMCDECAL_FX__
