#ifndef __AEROBLUR_FILTER_FX__
#define __AEROBLUR_FILTER_FX__

texture uiTexture;
sampler2D UITex = sampler_state
{
    Texture = <uiTexture>;
	AddressU = Clamp;
	AddressV = Clamp;
	AddressW = Clamp;
	MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
	SRGBTEXTURE = FALSE;
};

texture screenTexture;
sampler2D ScreenTex = sampler_state
{
    Texture = <screenTexture>;
    AddressU = Clamp;
    AddressV = Clamp;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
	SRGBTEXTURE = FALSE;
};

texture maskTexture;
sampler2D MaskTex = sampler_state
{
    Texture = <maskTexture>;
    AddressU = Clamp;
    AddressV = Clamp;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
	SRGBTEXTURE = FALSE;
};


static const int KERNEL_SIZE = 13;
static const int CHECAP_KERNEL_SIZE = 7;

float2 PixelKernelH[KERNEL_SIZE];
float2 PixelKernelV[KERNEL_SIZE];

float BlurWeight[KERNEL_SIZE] = 
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

float4 DrawUI(float4 diffuse : COLOR0, float2 uvUI : TEXCOORD0, float2 uvScreen : TEXCOORD1) : COLOR0
{
	//float4 ret = tex2D(UITex, uvUI.xy);
	//return float4(pow(ret, 1.0 / 2.2).rgb, ret.a);

	float4 color = tex2D(UITex, uvUI.xy);
	return color * diffuse;
}

float4 DrawUIWithMask(float4 diffuse : COLOR0, float2 uvUI : TEXCOORD0, float2 uvScreen : TEXCOORD1, float2 uvMask : TEXCOORD2) : COLOR0
{
	//float4 ret = tex2D(UITex, uvUI.xy);
	//return float4(pow(ret, 1.0 / 2.2).rgb, ret.a);

	float4 color = tex2D(UITex, uvUI.xy);
	float4 mask = tex2D(MaskTex, uvMask.xy);
	color.a = color.a * mask.a;
	return color * diffuse;
}




float4 GaussianBlurPS_V(float2 uvUI : TEXCOORD0, float2 uvScreen : TEXCOORD1) : COLOR0
{
	float alpha = tex2D(UITex, uvUI.xy).a;
	if (alpha < 0.2f) {
		return tex2D(ScreenTex, uvScreen.xy);
	}
	float3 Color = 0;
    for (int i = 0; i < CHECAP_KERNEL_SIZE; i++) {    
        Color += tex2D( ScreenTex, uvScreen + PixelKernelV[i].xy ).rgb * BlurWeight[i];
    }
	return float4(Color, 1.0f);
}

float4 GaussianBlurPS_H(float2 uvUI : TEXCOORD0, float2 uvScreen : TEXCOORD1) : COLOR0
{
	float alpha = tex2D(UITex, uvUI.xy).a;
	if (alpha < 0.2f) {
		return tex2D(ScreenTex, uvScreen.xy);
	}
	float3 Color = 0;
    for (int i = 0; i < CHECAP_KERNEL_SIZE; i++) {    
        Color += tex2D( ScreenTex, uvScreen + PixelKernelH[i].xy ).rgb * BlurWeight[i];
    }
	return float4(Color, 1.0f);
}


technique AeroUI
{
    pass p0
    {
				SRGBWRITEENABLE = FALSE;
        PixelShader = compile ps_2_0 GaussianBlurPS_H();
    }

		pass p1
		{
			SRGBWRITEENABLE = FALSE;
        PixelShader = compile ps_2_0 GaussianBlurPS_V();
		}

		
		pass p2
		{
			ZENABLE = FALSE;
			ZWRITEENABLE = FALSE;
			ALPHABLENDENABLE = TRUE;
			SRGBWRITEENABLE = FALSE;
			

      PixelShader = compile ps_2_0 DrawUI();
		}
}

technique AeroUIWithMask
{
    pass p0
    {
		SRGBWRITEENABLE = FALSE;
        PixelShader = compile ps_2_0 GaussianBlurPS_H();
    }

		pass p1
		{
			SRGBWRITEENABLE = FALSE;
        PixelShader = compile ps_2_0 GaussianBlurPS_V();
		}

		
		pass p2
		{
			ZENABLE = FALSE;
			ZWRITEENABLE = FALSE;
			ALPHABLENDENABLE = TRUE;
			SRGBWRITEENABLE = FALSE;
			

      PixelShader = compile ps_2_0 DrawUIWithMask();
		}
}

technique NoneAeroUI
{
		pass p0
		{
			ZENABLE = FALSE;
			ZWRITEENABLE = FALSE;
			ALPHABLENDENABLE = TRUE;
			SRGBWRITEENABLE = FALSE;
			

      PixelShader = compile ps_2_0 DrawUI();
		}
}

technique NoneAeroUIWithMask
{
		pass p0
		{
			ZENABLE = FALSE;
			ZWRITEENABLE = FALSE;
			ALPHABLENDENABLE = TRUE;
			SRGBWRITEENABLE = FALSE;
			

      PixelShader = compile ps_2_0 DrawUIWithMask();
		}
}

#endif	//__AEROBLUR_FILTER_FX__