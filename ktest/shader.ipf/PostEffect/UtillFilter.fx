#ifndef __UTILL_FILTER_FX__
#define __UTILL_FILTER_FX__

float	bloomLevel = 1;
float	bloomStrenth = 0.25;
float	bloomMaxLevel = 5;

texture TargetTex;
sampler2D targetLinearTex = sampler_state
{ 
    Texture = <TargetTex>;
    MinFilter = Linear;
    MagFilter = Linear;
	AddressU = CLAMP;
	AddressV = CLAMP;
	SRGBTEXTURE = TRUE;
};

sampler2D targetLinearNOSRGBTex = sampler_state
{ 
    Texture = <TargetTex>;
    MinFilter = Linear;
    MagFilter = Linear;
	AddressU = CLAMP;
	AddressV = CLAMP;
	SRGBTEXTURE = FALSE;
};

texture DestTex;
sampler2D DestLinearTex = sampler_state
{ 
    Texture = <DestTex>;
    MinFilter = Linear;
    MagFilter = Linear;
	AddressU = CLAMP;
	AddressV = CLAMP;
	SRGBTEXTURE = TRUE;
};

texture DestTex1;
sampler2D DestLinearTex1 = sampler_state
{ 
    Texture = <DestTex1>;
    MinFilter = Linear;
    MagFilter = Linear;
	AddressU = CLAMP;
	AddressV = CLAMP;
	SRGBTEXTURE = TRUE;
};

texture DestTex2;
sampler2D DestLinearTex2 = sampler_state
{ 
    Texture = <DestTex2>;
    MinFilter = Linear;
    MagFilter = Linear;
	AddressU = CLAMP;
	AddressV = CLAMP;
	SRGBTEXTURE = TRUE;
};

float g_MultiplyValue = 1.0f;
float4 MultiplyFilter(in float2 uv0 : TEXCOORD0) : COLOR
{
	float3 sceneColor = tex2D(targetLinearTex, uv0);
	sceneColor *= g_MultiplyValue;
	return float4(sceneColor, 1.0f);
}

float g_fExtractionValue = 0.0f;
float4 ExtractionFilter(in float2 uv0 : TEXCOORD0) : COLOR
{
	float3 vSample = tex2D(targetLinearTex, uv0);
	float3 OutColor = 0.0f;
	if ( g_fExtractionValue < vSample.r ) 
		OutColor.r = vSample.r;
	if ( g_fExtractionValue < vSample.g ) 
		OutColor.g = vSample.g;
	if ( g_fExtractionValue < vSample.b ) 
		OutColor.b = vSample.b;		
	return float4(OutColor, 1.0f);
}

float4 GrayFilter(in float2 uv0 : TEXCOORD0) : COLOR
{
	float3 vColor = tex2D( targetLinearTex, uv0 );
	const float3 RGB2Y = float3(0.29900f, 0.58700f, 0.11400f);
	vColor = dot(vColor, RGB2Y);
	return float4( vColor, 1 );
}

float4 g_NearFarInterval;
float4 LerpWithDepthFilter(in float2 uv0 : TEXCOORD0) : COLOR
{
	float3 vColor 	 = tex2D(targetLinearTex, uv0);
	float3 BlurColor = tex2D(DestLinearTex, uv0);
	float depthValue = tex2D(DestLinearTex1, uv0).r;

	float fNear = g_NearFarInterval.x;
	float fInterval = g_NearFarInterval.z;
	float lerpValue = (depthValue - fNear) / fInterval;
	lerpValue = saturate(lerpValue);
	vColor = lerp(vColor, BlurColor, lerpValue);
	return float4(vColor, 1.0f);
}

float3 g_subColorValue = { 1.0f, 1.0f, 1.0f };
float4 SubColorFilter(in float2 uv0 : TEXCOORD0) : COLOR
{
	float3 vColor = tex2D( targetLinearTex, uv0 );
	vColor -= g_subColorValue;
	vColor = max(vColor, 0.0f);
	return float4( vColor, 1 );
}

float g_shoulderStrength 	= 0.15f;
float g_LinearAngle 		= 0.50f;
float g_LinearStrength 		= 0.10f;
float g_ToeStrength 		= 0.20f;
float g_ToeNumerator 		= 0.02f;
float g_ToeDenominator 		= 0.30f;
float g_filmicWhite			= 11.2f;

/*
float A = 0.15f;
float B = 0.50f;
float C = 0.10f;
float D = 0.20f;
float E = 0.02f;
float F = 0.30f;
float W = 11.2f;

float3 UnchartedToneMapping(float3 x)
{
	return ((x*(A*x + C*B) + D*E )/(x*(A*x+B)+D*F))-E/F;
}
*/

float3 FilmicToneMapping(float3 x)
{
	return ((x*(g_shoulderStrength*x + g_LinearStrength*g_LinearAngle) + g_ToeStrength*g_ToeNumerator )/(x*(g_shoulderStrength*x+g_LinearAngle)+g_ToeStrength*g_ToeDenominator))-g_ToeNumerator/g_ToeDenominator;
}

float4 ReinHardToneMapping(in float2 uv0 : TEXCOORD0) : COLOR 
{
	float3 sceneColor 	= tex2D( targetLinearTex, uv0 );
	sceneColor = sceneColor / (1.0f + sceneColor);
	return float4(sceneColor, 1.0f);
}

float4 FilmictoneMappingFilter(in float2 uv0 : TEXCOORD0) : COLOR
{
	float3 sceneColor 	= tex2D( targetLinearTex, uv0 );
	const float3 whiteScale = 1.0f / FilmicToneMapping(g_filmicWhite);
	float3 curve = FilmicToneMapping(sceneColor);
	sceneColor = curve * whiteScale;
	return float4(sceneColor, 1.0f);
}

float3 RGBToXYZ(float3 rgb)
{
	float3 XYZ;
	XYZ.x = rgb.r * 0.4124 + rgb.g * 0.3576 + rgb.b * 0.1805;
	XYZ.y = rgb.r * 0.2126 + rgb.g * 0.7152 + rgb.b * 0.0722;
	XYZ.z = rgb.r * 0.0193 + rgb.g * 0.1192 + rgb.b * 0.9505;
	return XYZ;
}

float3 XYZToRGB(float3 XYZ)
{
	float3 RGB = 0;
	RGB.r = XYZ.x *  3.2406 + XYZ.y * -1.5372 + XYZ.z * -0.4986;
	RGB.g = XYZ.x * -0.9689 + XYZ.y *  1.8758 + XYZ.z *  0.0415;
	RGB.b = XYZ.x *  0.0557 + XYZ.y * -0.2040 + XYZ.z *  1.0570;
	return RGB;		
}

void XYZToYxy(float iX, float iY, float iZ, out float oY, out float ox, out float oy)
{
	oY = iY;
	ox = iX / ( iX + iY + iZ );
	oy = iY / ( iX + iY + iZ );
}

void YxyToXYZ(float iY, float ix, float iy, out float oX, out float oY, out float oZ)
{
	oX = ix * ( iY / iy );
	oY = iY;
	oZ = ( 1.0f - ix - iy ) * ( iY / iy );
}

float4 CopyFilter(in float2 uv0 : TEXCOORD0) : COLOR
{
	return tex2D(targetLinearTex, uv0);
}

float4 BloomCrop(in float2 uv0 : TEXCOORD0) : COLOR
{
	float3 renderRT = tex2D( targetLinearTex, uv0 );
	float3 ret = min(bloomMaxLevel, pow( renderRT*bloomStrenth, 2 ))*bloomLevel;
	return float4(ret, 1.0f);
}

float4 AddFilter(in float2 uv0 : TEXCOORD0) : COLOR
{
	float3 ret = tex2D( targetLinearTex, uv0 ) + tex2D( DestLinearTex,uv0 );
	return float4( ret, 1 );
}

float g_LerpSpeed;
float g_fElapsedTime;
float4 LumInterpolation(in float2 uv0 : TEXCOORD0) : COLOR
{
	float cur 	= tex2D(targetLinearTex, float2(0.5f, 0.5f)).r;	
	float past 	= tex2D(DestLinearTex,	float2(0.5f, 0.5f)).r;
    float fNewAdaptation = past + (cur- past) * ( 1 - pow( 0.98f, 30.0f * g_LerpSpeed * g_fElapsedTime ) );
	return float4( fNewAdaptation, fNewAdaptation, fNewAdaptation, 1 );
}

float4 CalcLumSaveToAlphaChannelFilter(in float2 uv0 : TEXCOORD0) : COLOR
{
	float4 texColor = tex2D(targetLinearNOSRGBTex, uv0);
	texColor.a = pow(dot(texColor.rgb, float3(0.299, 0.587, 0.114)), 2.2f);
	return texColor;
}

float g_Scale = 1.0f;
float4 AddScalePS(in float2 uv0 : TEXCOORD0) : COLOR
{
	float3 ret = tex2D( targetLinearTex, uv0 ) + ( tex2D( DestLinearTex,uv0 ) * g_Scale ) ;
	return float4( ret, 1 );
}

static const float3 LUMINANCE_VECTOR  = float3(0.2125f, 0.7154f, 0.0721f);
static const float3 BLUE_SHIFT_VECTOR = float3(1.05f, 0.97f, 1.27f); 

float4 BlueShift(in float2 uv0 : TEXCOORD0) : COLOR 
{
	float3 sceneColor = tex2D( targetLinearTex, uv0 );
	float fAdaptedLum = tex2D( DestLinearTex, float2(0.5f, 0.5f) );
	
	float fBlueShiftCoefficient = 1.0f - (fAdaptedLum + 1.5)/4.1;
	fBlueShiftCoefficient = saturate(fBlueShiftCoefficient);

	float3 vRodColor = dot( sceneColor, LUMINANCE_VECTOR ) * BLUE_SHIFT_VECTOR;
	sceneColor.rgb = lerp( sceneColor, vRodColor, fBlueShiftCoefficient );
	return float4(sceneColor, 1.0f);
}

float g_addScale[3];
float4 BloomAdd3FilterPS(in float2 uv0 : TEXCOORD0) : COLOR
{
	float3 ret = tex2D( targetLinearTex, uv0 ) 
			+ ( tex2D( DestLinearTex,uv0 ) * g_addScale[0] )
			+ ( tex2D( DestLinearTex1,uv0 ) * g_addScale[1] ) 
			+ ( tex2D( DestLinearTex2,uv0 ) * g_addScale[2] );
	return float4( ret, 1.0f );
}

float4 BloomAdd2FilterPS(in float2 uv0 : TEXCOORD0) : COLOR
{
	float3 ret = tex2D( targetLinearTex, uv0 ) 
			+ ( tex2D( DestLinearTex,uv0 ) * g_addScale[0] )
			+ ( tex2D( DestLinearTex1,uv0 ) * g_addScale[1] );
	return float4(ret, 1.0f);
}

float4 SceneLumScaleFilter(in float2 uv0 : TEXCOORD0) : COLOR
{
	float3 sceneColor  	= tex2D(targetLinearTex, uv0);
	float fAdaptedLum 	= tex2D(DestLinearTex,	float2(0.5f, 0.5f)).r;
	
	sceneColor = sceneColor * (0.18/(fAdaptedLum + 0.001f));
	return float4(sceneColor, 1.0f);
}

float2 g_texelSize = float2(1.0f/1024.0f, 1.0f/768.0f);

const float g_kernel[5] = {0.25f,0.25f,-1.0f,0.25f,0.25f};
	
const float2 g_offset[9] = {
	float2(1.0f/768.0f, 0.0f),
	float2(0.0f, 1.0f/768.0f),
	float2(0.0f, 0.0f),
	float2(0.0f, -(1.0f/768.0f)),
	float2(-(1.0f/768.0f), 0.0f),
	float2(1.0f/768.0f, 1.0f/768.0f),
	float2(1.0f/768.0f, -(1.0f/768.0f)),
	float2(-(1.0f/768.0f), 1.0f/768.0f),
	float2(-(1.0f/768.0f), -(1.0f/768.0f))
};


float4 CharacterOutLineFilter(in float2 uv0 : TEXCOORD0) : COLOR
{
	float4 albedo = tex2D(targetLinearTex, uv0);	
	float falloff = 0;
		
	
	
	//아웃라인 연산을 해 주면된다.
	//
	
	int i = 0;
	for ( i = 0; i < 5 ; i++)
	{
		float tmp = tex2D(DestLinearTex, uv0+g_offset[i]).x;
		falloff += tmp*g_kernel[i];			
	}


	/// 아웃라인엣지에는 알파를 넣자
	float tmpAlpha = 1.0f;
	for ( i = 0; i < 9 ; i++)
	{
		float tmp2 = tex2D(targetLinearTex, uv0+g_offset[i]).a;
		if(tmp2 < 0.01)
		{
			tmpAlpha = albedo.a;
		}
	}	

	falloff = saturate(falloff);
//	return float4(falloff.xxx,albedo.a);
	

	float3 outline = saturate(albedo.xyz+0.05)*0.7;

	albedo.xyz = lerp(albedo.xyz,outline,falloff);
	albedo.a = tmpAlpha;
		
	return albedo;
}



technique CopyFilterTq
{
    pass P0 {
		SRGBWRITEENABLE = TRUE;
        PixelShader  = compile ps_2_0 CopyFilter();
    }
}

technique CharacterOutLineFilterTq
{
    pass P0 {
		SRGBWRITEENABLE = TRUE;

        PixelShader  = compile ps_3_0 CharacterOutLineFilter();
    }
}

technique BloomCropTq
{
    pass P0 {
		SRGBWRITEENABLE = TRUE;
        PixelShader  = compile ps_2_0 BloomCrop();
    }
}

technique AddFilterTq
{
    pass P0 {
		SRGBWRITEENABLE = TRUE;
        PixelShader  = compile ps_2_0 AddFilter();
    }
}

technique AddScaleFilterTq
{
    pass P0 {
		SRGBWRITEENABLE = TRUE;
        PixelShader  = compile ps_2_0 AddScalePS();
    }
}

technique BloomAdd3FilterTq
{
    pass P0 {
		SRGBWRITEENABLE = TRUE;
        PixelShader  = compile ps_2_0 BloomAdd3FilterPS();
    }
}

technique BloomAdd2FilterTq
{
    pass P0 {
		SRGBWRITEENABLE = TRUE;
        PixelShader  = compile ps_2_0 BloomAdd2FilterPS();
    }
}

technique ExtractionFilterTq
{
    pass P0 {
		SRGBWRITEENABLE = TRUE;
        PixelShader  = compile ps_2_0 ExtractionFilter();
    }
}

technique MultiplyFilterTq
{
    pass P0 {
		SRGBWRITEENABLE = TRUE;
        PixelShader  = compile ps_2_0 MultiplyFilter();
    }
}

technique FilmictoneMappingFilterTq
{
    pass P0 {
		SRGBWRITEENABLE = TRUE;
        PixelShader  = compile ps_2_0 FilmictoneMappingFilter();
    }
}

technique ReinHardToneMappingTq
{
    pass P0 {
		SRGBWRITEENABLE = TRUE;
        PixelShader  = compile ps_2_0 ReinHardToneMapping();
    }
}

technique SubColorFilterTq
{
    pass P0 {
		SRGBWRITEENABLE = TRUE;
        PixelShader  = compile ps_2_0 SubColorFilter();
    }
}

technique GrayFilterTq
{
    pass P0 {
		SRGBWRITEENABLE = TRUE;
        PixelShader  = compile ps_2_0 GrayFilter();
    }
}

technique LerpWithDepthFilterTq
{
    pass P0 {
		SRGBWRITEENABLE = TRUE;
        PixelShader  = compile ps_2_0 LerpWithDepthFilter();
    }
}

technique LumInterpolationTq
{
    pass P0 {
		SRGBWRITEENABLE = TRUE;
        PixelShader  = compile ps_2_0 LumInterpolation();
    }
}

technique SceneLumScaleFilterTq
{
    pass P0 {
		SRGBWRITEENABLE = TRUE;
        PixelShader  = compile ps_2_0 SceneLumScaleFilter();
    }
}

technique BlueShiftTq
{
    pass P0 {
		SRGBWRITEENABLE = TRUE;
        PixelShader  = compile ps_2_0 BlueShift();
    }
}

technique CalcLumSaveToAlphaChannelFilterTq
{
    pass P0 {
		SRGBWRITEENABLE = FALSE;
        PixelShader  = compile ps_2_0 CalcLumSaveToAlphaChannelFilter();
    }
}
#endif //__UTILL_FILTER_FX__