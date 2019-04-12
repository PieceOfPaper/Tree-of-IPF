#ifndef __IMCEFFECTSHADER_FX__
#define __IMCEFFECTSHADER_FX__

// 
// Effect_Shake.fx
//


////////////////////////////////////////////////////////////////////////////////////////////////////////
// sampler
////////////////////////////////////////////////////////////////////////////////////////////////////////

texture	g_Texture;
sampler2D  g_sampler = sampler_state
{
	Texture = <g_Texture>;
};

texture	g_bgTexture;
sampler2D g_bgSampler = sampler_state 
{
    Texture = <g_bgTexture>;
};

texture	g_bgDepthTexture;
sampler2D g_bgDepthSampler = sampler_state 
{
    Texture = <g_bgDepthTexture>;
	MinFilter = POINT;
	MagFilter = POINT;
	MipFilter = NONE;
	AddressU = BORDER;
	AddressV = BORDER;
	BorderColor = 0xFFFFFFFF;
	SRGBTEXTURE = FALSE;
};

////////////////////////////////////////////////////////////////////////////////////////////////////////
// global shader variables
////////////////////////////////////////////////////////////////////////////////////////////////////////

float 		g_Power = 1.0f;
float		g_HDR_sunLightIntensity = 1.0f;

float		g_farDistance = 10000.0f;
float		g_softParticleRange = 3.0f;

// �ؽ�ó����Ʈ ������
float		g_effectTime = 0.0f;
float		g_waveSpeedX = 0.0f;
float		g_waveStretchX = 0.0f;
float		g_wavePowerX = 0.0f;
float		g_waveSpeedY = 0.0f;
float		g_waveStretchY = 0.0f;
float		g_wavePowerY = 0.0f;
//

float4x4	g_WorldViewProjTM;
float4x4	g_ViewTM;
float4x4	g_ProjTM;
float4x4	g_ViewProjTM;
float4x4	g_InvViewProjTM;
float4x4	g_WorldTM;
float4x4	g_InvWorldTM;
float4x4	g_InvViewTM;
float4x4	g_InvProjTM;

float3		g_CamPos;

float4		g_ModelDiffuse = 1.0f;

#ifdef USE_SKINNINGMODEL
float4x3	g_BoneTM[70];
#endif

#ifdef USE_DECAL
float4x4	g_matWorldArr[50];
float4x4	g_matInvWorldArr[50];
#endif

float4		g_lightDirection;

// 3dĳ���� 2d�� �׸��°�
float4x4 	g_billboardTM		: 	BILLBOARD_TM;
float4x4 	g_charProjTM		:	CHARPROJ_TM;
float4x4	g_charViewTM		:	CHARVIEW_TM;
float3		g_pivotPoint;

float g_softParticleFactor = 0.15f;

float4 ShiftColor(float4 c)
{
	float r = c.r;
	c.r = c.g;
	c.g = c.b;
	c.b = r;

	return c;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Struct
////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Vertex Shader
////////////////////////////////////////////////////////////////////////////////////////////////////////
float4 CalcWVP( float4 Pos )
{
	Pos.w = 1.0f;	
	// ĳ���� 2D�� ���
	#ifdef USE_2D
		//return mul(Pos, g_ViewProjTM);
		// ��� �ؿ� �ΰ��� ���ĵ� �����ϴ�. ������ ������ ������ ����
		float4 WorldPos = mul(Pos, g_WorldTM);
		Pos = mul(WorldPos, g_charViewTM);
		Pos = mul(Pos, g_charProjTM);
		Pos /= Pos.w;
		Pos.z = 0.0f; // ������ ����
		Pos.y += 0.4f;  // ĳ���� �� ��ġ ���⶧ ����ϴ� ����Դϴ�
		Pos.xy *= (Pos.y*float2(0.5,0.2)+1);
		Pos = mul(Pos, g_billboardTM);
		Pos = mul(Pos, g_ViewProjTM);
		// (localz-ī�޶�Ÿ�:z����0�յڷθ��߷���) * ������ �����ϰ� �ϱ� ���� ��� - �������̾;
		
		float uprate = 1.1;
		float pivotOffset = 100;
		float defz = mul(float4(g_pivotPoint.x, (WorldPos.y - g_pivotPoint.y + pivotOffset) * uprate + g_pivotPoint.y - pivotOffset, g_pivotPoint.z, 1), g_ViewProjTM).z / mul(float4(g_pivotPoint.x, (WorldPos.y - g_pivotPoint.y + pivotOffset) * uprate + g_pivotPoint.y - pivotOffset, g_pivotPoint.z, 1), g_ViewProjTM).w;
		Pos.z = defz * Pos.w;				
		return Pos;
	#else
		return mul(Pos, g_WorldViewProjTM);
	#endif	
}

float4 CalcWVPInstancing(float4 Pos)
{
#ifdef USE_2D
	return Pos;
#else
	return mul(Pos, g_WorldViewProjTM);
#endif	
}

float4 CalcWorldNormal( float3 normal ) 
{
	float4 worldNormal = float4(normal, 0.0f);		
	return mul(worldNormal, g_WorldTM);
}

void CalcSkinGeom(in float4 Pos, in float3 Nml, in float4 weights, in int4 indices, 
				  out float4 PosCS, out float3 NmlMS, out float3 localPos, in int numBones)
{
#ifdef USE_SKINNINGMODEL
	localPos = 0;
	NmlMS = 0;
	for(int i = 0; i < numBones; ++i) {
		localPos += mul(Pos, (float4x3)g_BoneTM[ indices[i] ]) * weights[i];
		NmlMS  	 += mul(Nml, (float3x3)g_BoneTM[ indices[i] ]) * weights[i];
	}
    PosCS = CalcWVP( float4(localPos, 1.0f) );
#else
	PosCS = 0.f;
	NmlMS = 0.f;
	localPos = 0.f;
#endif
}

void VS_EffectInstancing_Frk(in float4 PosIn : POSITION,
	in float4 ColorIn : COLOR,
	in float2 TexIn : TEXCOORD0,
	in float2 SoftParticleIn : TEXCOORD1,
	out float4 PosOut : POSITION,
	out float4 ColorOut : COLOR,
	out float2 TexOut : TEXCOORD0,
	out float4 ScrPos : TEXCOORD1,
	out float2 SoftParticleOut : TEXCOORD2,
	out float4 WaveSpeedStretchOut : TEXCOORD3,
	out float4 WavePowerTimeOut : TEXCOORD4
	)
{
	PosOut = CalcWVPInstancing(PosIn);
	ScrPos = PosOut;

	ColorOut = ColorIn;
	TexOut = TexIn;
	SoftParticleOut = SoftParticleIn;
	WaveSpeedStretchOut = 0.f;
	WavePowerTimeOut = 0.f;
}

void VS_EffectInstancing( in float4 PosIn : POSITION,
				in float4 ColorIn : COLOR,
				in float2 TexIn : TEXCOORD0,
				in float2 SoftParticleIn : TEXCOORD1,
				in float4 WaveSpeedStretchIn : TEXCOORD2,
				in float4 WavePowerTimeIn : TEXCOORD3,
					out float4 PosOut : POSITION,
					out float4 ColorOut : COLOR,
					out float2 TexOut : TEXCOORD0,
					out float4 ScrPos : TEXCOORD1,
					out float2 SoftParticleOut : TEXCOORD2,
					out float4 WaveSpeedStretchOut : TEXCOORD3,
					out float4 WavePowerTimeOut : TEXCOORD4
					)
{
	PosOut			= CalcWVPInstancing(PosIn);
	ScrPos			= PosOut;
	
	ColorOut		= ColorIn;
	TexOut			= TexIn;
	SoftParticleOut = SoftParticleIn;

	WaveSpeedStretchOut = WaveSpeedStretchIn;
	WavePowerTimeOut = WavePowerTimeIn;
}

void VS_Effect(in float4 PosIn : POSITION,
	in float4 ColorIn : COLOR,
	in float2 TexIn : TEXCOORD0,
	out float4 PosOut : POSITION,
	out float4 ColorOut : COLOR,
	out float2 TexOut : TEXCOORD0,
	out float4 ScrPos : TEXCOORD1
	)
{
	PosOut = CalcWVP(PosIn);
	ScrPos = PosOut;

	ColorOut = ColorIn;
	TexOut = TexIn;
}

void VS_Effect_Model( in float4 PosIn : POSITION,
					in float3 NormalIn : NORMAL,
					in float2 TexIn : TEXCOORD0,
					out float4 PosOut : POSITION,
					out float4 ColorOut : COLOR,
					out float2 TexOut : TEXCOORD0,
					out float4 ScrPos : TEXCOORD1,
					out float4 worldNormal : TEXCOORD2
					)
{
	PosOut			= CalcWVP(PosIn);
	ScrPos			= PosOut;	
	
	ColorOut		= g_ModelDiffuse;
	TexOut			= TexIn;	

	worldNormal 	= CalcWorldNormal(NormalIn);		
}

void VS_Effect_AniModel(in float4 PosIn : POSITION, 
					in float3 NormalIn : NORMAL, 
					in float4 weights : BLENDWEIGHT, 
					in float4 indices : BLENDINDICES,
					in float4 TexIn : TEXCOORD0,
					out float4 PosOut : POSITION,
					out float4 ColorOut : COLOR,
					out float2 TexOut : TEXCOORD0,
					out float4 ScrPos : TEXCOORD1,
					out float4 worldNormal : TEXCOORD2
					)
{	
	float3 localNml;
	float3 localPos;		
	
	CalcSkinGeom(PosIn, NormalIn, weights, D3DCOLORtoUBYTE4(indices), PosOut, localNml, localPos, 4);
	
	ScrPos		= PosOut;	
	ColorOut	= g_ModelDiffuse;
	TexOut		= TexIn;		
	
	worldNormal 	= CalcWorldNormal(NormalIn);	
}
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Pixel Shader
////////////////////////////////////////////////////////////////////////////////////////////////////////
void vignette(inout float4 c, const float2 win_bias)
{
	float2 wpos = 2 * (win_bias - (float2)(0.5, 0.5));

	float r = length(wpos.xy);
	r = 1.0 - smoothstep(0.6, 1.5, r) * 0.65;
	c = c * r;
}

double2 GetScreenTex(float4 pos)
{    
  	pos.x			/= pos.w;
	pos.y			/= pos.w;	

	double2 scrTexOut;
	scrTexOut.x		= (pos.x + 1.0f) / 2;
	scrTexOut.y		= (2.0f - (pos.y + 1.0f)) / 2;
	
	// ��ũ�� ������ (�����ѹ�)
	scrTexOut.x		+= 0.0005f;
	scrTexOut.y		+= 0.0006f;
	
	return scrTexOut;
}
float decodeFromRG(float2 rg)
{	
	return dot(rg, float2(1.0f, 1.0f/255.0f));
}

float CalcAlphaWithDepth(float4 srcPos)
{
#ifdef USE_SOFT_PARTICLE
	float2 scrTexOut = GetScreenTex(srcPos);
	float pixelDepth = srcPos.z;
	float bgDepth = tex2D(g_bgDepthSampler, scrTexOut.xy).x * 5000.0f;
	float delta = (bgDepth - pixelDepth) * g_softParticleFactor + 1.0f;
	float alpha = saturate(delta);
	return alpha;
#else
	return 1.0f;	//2d����Ʈ(ex:UI)
#endif
}

float CalcAlphaWithDepthInstancing(float4 srcPos, float softParticleFactor)
{
#ifdef USE_SOFT_PARTICLE
	float2 scrTexOut = GetScreenTex(srcPos);
	float pixelDepth = srcPos.z;
	float bgDepth = tex2D(g_bgDepthSampler, scrTexOut.xy).x * 5000.0f;
	float delta = (bgDepth - pixelDepth) * softParticleFactor + 1.0f;
	float alpha = saturate(delta);
	return alpha;
#else
	return 1.0f;	//2d����Ʈ(ex:UI)
#endif
}

float4 PS_MultiplyProcessInstancing(in float4 diffuse : COLOR,
	in float2 tex : TEXCOORD0,
	in float4 ScrPos : TEXCOORD1,
	in float2 SoftParticle : TEXCOORD2,
	in float4 WaveSpeedStretch : TEXCOORD3,
	in float4 WavePowerTime : TEXCOORD4
	) : COLOR
{
	clip(diffuse.a - 0.001f);

	tex.x = tex.x + (sin(tex.y * WaveSpeedStretch.z + WavePowerTime.z * WaveSpeedStretch.x) * WavePowerTime.x);
	tex.y = tex.y + (sin(tex.x * WaveSpeedStretch.w + WavePowerTime.z * WaveSpeedStretch.y) * WavePowerTime.y);

	float4 texColor = tex2D(g_sampler, tex.xy).rgba;
	float4 finalColor = texColor * diffuse;
	finalColor.rgb = finalColor * g_HDR_sunLightIntensity;

#ifdef IS_REVERSE
	finalColor = ShiftColor(finalColor);
#endif

#ifdef RGB_SOFT_PARTICLE
	finalColor.rgb *= CalcAlphaWithDepthInstancing(ScrPos, SoftParticle.x);
	finalColor.a = 0.0f;
#else
	finalColor.a *= CalcAlphaWithDepthInstancing(ScrPos, SoftParticle.x);
#endif

	return finalColor;
}


float4 PS_AdditiveProcessInstancing(in float4 diffuse : COLOR,
	in float2 tex : TEXCOORD0,
	in float4 ScrPos : TEXCOORD1,
	in float2 SoftParticle : TEXCOORD2
	) : COLOR
{
	float4 texColor = tex2D(g_sampler, tex.xy).rgba;
	float4 finalColor = texColor;

	finalColor.a = texColor.a * diffuse.a;
	finalColor.rgb = (texColor.rgb * diffuse.rgb) * g_HDR_sunLightIntensity;

#ifdef RGB_SOFT_PARTICLE
	finalColor.rgb *= CalcAlphaWithDepthInstancing(ScrPos, SoftParticle.x);
	finalColor.a = 1.0f;
#else
	finalColor.a *= CalcAlphaWithDepthInstancing(ScrPos, SoftParticle.x);
#endif

#ifdef IS_REVERSE
	finalColor = ShiftColor(finalColor);
#endif 

	return finalColor;
}

float4 PS_ExchangeProcessInstancing(in float4 diffuse : COLOR,
	in float2 tex : TEXCOORD0,
	in float4 ScrPos : TEXCOORD1,
	in float2 SoftParticle : TEXCOORD2
	) : COLOR
{
	float4 texColor = tex2D(g_sampler, tex.xy).rgba;
	float4 finalColor = diffuse;
	finalColor.a = texColor.a * diffuse.a;
	finalColor.rgb = finalColor * g_HDR_sunLightIntensity;

#ifdef RGB_SOFT_PARTICLE
	finalColor.rgb *= CalcAlphaWithDepthInstancing(ScrPos, SoftParticle.x);
	finalColor.a = 1.0f;
#else
	finalColor.a *= CalcAlphaWithDepthInstancing(ScrPos, SoftParticle.x);
#endif	

#ifdef IS_REVERSE
	finalColor = ShiftColor(finalColor);
#endif 
	return finalColor;
}

float4 PS_ScreenProcess( in float4 diffuse : COLOR,
						in float2 tex: TEXCOORD0,
						in float4 ScrPos: TEXCOORD1
						) : COLOR
{	
    float4 texColor = tex2D(g_sampler, tex.xy).rgba;
	float4 finalColor = texColor;
	return finalColor;
}

// ========= Color Process
float4 PS_MultiplyProcess( in float4 diffuse : COLOR,
						in float2 tex: TEXCOORD0,
						in float4 ScrPos: TEXCOORD1
						) : COLOR
{
	tex.x = tex.x + (sin(tex.y * g_waveStretchX + g_effectTime * g_waveSpeedX) * g_wavePowerX);
	tex.y = tex.y + (sin(tex.x * g_waveStretchY + g_effectTime * g_waveSpeedY) * g_wavePowerY);

    float4 texColor = tex2D(g_sampler, tex.xy).rgba;
	float4 finalColor = texColor * diffuse;
	finalColor.rgb = finalColor * g_HDR_sunLightIntensity;
	
#ifdef IS_REVERSE
	finalColor = ShiftColor(finalColor);
#endif 

#ifdef RGB_SOFT_PARTICLE
	finalColor.rgb *= CalcAlphaWithDepth(ScrPos);
	finalColor.a = 0.0f;	
#else
	finalColor.a *= CalcAlphaWithDepth(ScrPos);
#endif		

	return finalColor;
}

float4 PS_AdditiveProcess( in float4 diffuse : COLOR,
						in float2 tex: TEXCOORD0,
						in float4 ScrPos: TEXCOORD1
						) : COLOR
{	
    float4 texColor = tex2D(g_sampler, tex.xy).rgba;
	float4 finalColor = texColor;
	
	finalColor.a 	= texColor.a * diffuse.a;
	finalColor.rgb 	= (texColor.rgb * diffuse.rgb) * g_HDR_sunLightIntensity;	
	
#ifdef RGB_SOFT_PARTICLE
	finalColor.rgb *= CalcAlphaWithDepth(ScrPos);
	finalColor.a = 1.0f;	
#else
	finalColor.a *= CalcAlphaWithDepth(ScrPos);
#endif

#ifdef IS_REVERSE
		finalColor = ShiftColor(finalColor);
#endif 
		
	return finalColor;
}

float4 PS_ExchangeProcess( in float4 diffuse : COLOR,
						in float2 tex: TEXCOORD0,
						in float4 ScrPos: TEXCOORD1
						) : COLOR
{
    float4 texColor = tex2D(g_sampler, tex.xy).rgba;
	float4 finalColor = diffuse;
	finalColor.a 	= texColor.a * diffuse.a;
	finalColor.rgb 	= finalColor * g_HDR_sunLightIntensity;
	
#ifdef RGB_SOFT_PARTICLE
	finalColor.rgb *= CalcAlphaWithDepth(ScrPos);	
	finalColor.a = 1.0f;	
#else
	finalColor.a *= CalcAlphaWithDepth(ScrPos);	
#endif	

#ifdef IS_REVERSE
	finalColor = ShiftColor(finalColor);
#endif 
	return finalColor;
}

float4 PS_LightingProcess( in float4 diffuse : COLOR,
						in float2 tex: TEXCOORD0,
						in float4 ScrPos: TEXCOORD1,
						in float4 worldNormal: TEXCOORD2
						) : COLOR

{
	worldNormal = normalize(worldNormal);

	float lightPower = saturate(dot(worldNormal.xyz, -g_lightDirection));	
	//float lightPower = dot(worldNormal.xyz, -g_lightDirection) * 0.8f + 0.2f);
	
    float4 texColor = tex2D(g_sampler, tex.xy).rgba;
	float4 finalColor = texColor;
	
	finalColor.a 	= texColor.a * diffuse.a;
	
	finalColor.rgb 	= (texColor.rgb + diffuse.rgb)* lightPower * g_HDR_sunLightIntensity;	
	return finalColor;
}

// ======== Effect Process with BG Image
float4 PS_ShakeProcess( in float4 diffuse : COLOR,
						in float2 tex: TEXCOORD0,
						in float4 ScrPos: TEXCOORD1
						) : COLOR
{	
    float4 finalColor = tex2D(g_sampler, tex.xy) * diffuse;		
	float alpha = finalColor.a;

	if (alpha > 0.0f)
	{
		float2 scrTexOut = GetScreenTex(ScrPos);
		float offsetY = 0.01f * g_Power * alpha;
		scrTexOut.y -= offsetY;

		if (scrTexOut.y < 0.01f)
			scrTexOut.y = 0.01f;

		finalColor.rgb = tex2D(g_bgSampler, scrTexOut.xy).rgb;
		finalColor.a = 0.9f;
	}	
	return finalColor;
}

float4 PS_GetPixelAverage(float2 uv, float range)
{
	float2 uvHorzLeft	= uv;
	float2 uvHorzRight	= uv;
	float2 uvVertUp		= uv;
	float2 uvVertDown	= uv;
	
	uvHorzLeft.x	-= range;
	uvHorzRight.x	+= range;
	uvVertUp.y		-= range;
	uvVertDown.y	+= range;	
	
	float4 totalColor = 0;
	totalColor += tex2D(g_bgSampler, uvHorzLeft);			
	totalColor += tex2D(g_bgSampler, uvHorzRight);			
	totalColor += tex2D(g_bgSampler, uvVertUp);			
	totalColor += tex2D(g_bgSampler, uvVertDown);
	
	return totalColor;
}

float4 PS_BlurProcess(	in float4 diffuse: COLOR0,						
						in float2 tex: TEXCOORD0,
						in float4 ScrPos : TEXCOORD1
						) : COLOR
{		   
	float4 finalColor = tex2D(g_sampler, tex.xy) * diffuse;
	float alpha = finalColor.a;

	if (alpha > 0.0f)
	{
		float2 scrTexOut = GetScreenTex(ScrPos);

	    float rangeStep = 0.01f * g_Power * alpha;
		float4 totalColor = tex2D(g_bgSampler, scrTexOut);

		for ( int i = 0; i < 4; i++ )
		{
			totalColor += PS_GetPixelAverage(scrTexOut, rangeStep * i);
		}	
		
		totalColor /= 17;
		
		finalColor.rgb = totalColor.rgb;
		finalColor.a = 0.9f;
	}		
	return finalColor;
}

float4 PS_NoiseProcess(	in float4 diffuse: COLOR0,						
						in float2 tex: TEXCOORD0,
						in float4 ScrPos : TEXCOORD1
						) : COLOR
{		   
	float4 finalColor = tex2D(g_sampler, tex.xy) * diffuse;
	float alpha = finalColor.a;
				  					
	if (alpha > 0.0f)	
	{
		float2 scrTexOut = GetScreenTex(ScrPos);
		
		float2 offsetTex = scrTexOut;
		offsetTex *= 600;
		
		scrTexOut.x += (alpha * sin(offsetTex.y) * g_Power * 0.01f);
		scrTexOut.y += (alpha * sin(offsetTex.x) * g_Power * 0.01f);
		
		if (scrTexOut.x  < 0.00f)
			scrTexOut.x = 0.00f;
			
		if (scrTexOut.x  > 0.99f)
			scrTexOut.x = 0.99f;

        if (scrTexOut.y  < 0.01f)
			scrTexOut.y = 0.01f;
			
		if (scrTexOut.y  > 0.99f)
			scrTexOut.y = 0.99f;
				
		finalColor.rgb = tex2D(g_bgSampler, scrTexOut).rgb;	
		finalColor.a = 0.9f;
	}		
	return finalColor;
}

float4 PS_DistortionProcess(in float4 diffuse: COLOR0,
						in float2 tex: TEXCOORD0,
						in float4 ScrPos : TEXCOORD1
						) : COLOR
{		   
	float4 finalColor = tex2D(g_sampler, tex.xy) * diffuse;	
	float alpha = finalColor.a;	
				  					
	if (alpha > 0.0f)	
	{
		float2 scrTexOut = GetScreenTex(ScrPos);				
		float2 offsetTex = scrTexOut;		
		
		offsetTex.x = scrTexOut.x + (finalColor.r - 0.5f) * alpha * g_Power * 0.1f;
		offsetTex.y = scrTexOut.y + (finalColor.g - 0.5f) * alpha * g_Power * 0.1f;		
		scrTexOut = offsetTex;
		
        if (scrTexOut.x  < 0.01f)
			scrTexOut.x = 0.01f;
			
		if (scrTexOut.x  > 0.99f)
			scrTexOut.x = 0.99f;
				
		finalColor.rgb = tex2D(g_bgSampler, scrTexOut).rgb;		
		finalColor.a = 0.9f;
	}
	
	return finalColor;
}

void VS_Decal(in float4 PosIn : POSITION, in float instID : TEXCOORD0,
	out float4 PosOut : POSITION, out float4 ScrPos : TEXCOORD0, out float3 ViewRay : TEXCOORD1, out float out_instID : TEXCOORD2)
{
	int nInstID = (int)(instID + 1e-5f);
	PosIn.w = 1.f;
#ifdef USE_DECAL
	PosOut = mul(PosIn, g_matWorldArr[nInstID]);
#else
	PosOut = mul(PosIn, g_WorldTM);
#endif

	ViewRay = PosOut - g_CamPos;

	PosOut = mul(PosOut, g_ViewProjTM);
	ScrPos = PosOut;
	out_instID = nInstID;
}

float4 PS_Decal(in float4 ScrPos : TEXCOORD0,
	in float3 ViewRay : TEXCOORD1,
	in float instID : TEXCOORD2) : COLOR
{
	int nInstID = (int)(instID + 1e-5f);

	float2 screeenPos;
	screeenPos.x = ScrPos.x / ScrPos.w * 0.5f + 0.5f;
	screeenPos.y = -ScrPos.y / ScrPos.w * 0.5f + 0.5f;
	
	float fDepth = tex2D(g_bgDepthSampler, screeenPos).g * 5000.f;

	ViewRay = normalize(ViewRay);
	float4 pos = float4(g_CamPos + ViewRay * fDepth, 1.f);

#ifdef USE_DECAL
	float3 f3DecalLocalPos = mul(pos, g_matInvWorldArr[nInstID]).xyz;
#else
	float3 f3DecalLocalPos = mul(pos, g_InvWorldTM).xyz;
#endif
	clip(0.5f - abs(f3DecalLocalPos));

	float2 f2DecalUV = f3DecalLocalPos.xz + 0.5f;

	float fDist = abs(f3DecalLocalPos.y);
	float4 color = tex2D(g_sampler, f2DecalUV).rgba;
	color.a *= (1.f - max((fDist - 0.25f) / 0.25f, 0.f));

	return color;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Techniques
////////////////////////////////////////////////////////////////////////////////////////////////////////
technique TQ_Effect_Particle
{
    pass P0 {
		VertexShader = compile vs_3_0 VS_Effect();
		PixelShader = compile ps_3_0 PS_MultiplyProcess();
    }
	
	pass P1 {
		VertexShader = compile vs_3_0 VS_Effect();
		PixelShader = compile ps_3_0 PS_AdditiveProcess();
    }
	
	pass P2 {
		VertexShader = compile vs_3_0 VS_Effect();
        PixelShader  = compile ps_3_0 PS_ExchangeProcess();
    }				
	
    pass P3 {
		VertexShader = compile vs_3_0 VS_Effect();
        PixelShader  = compile ps_3_0 PS_ShakeProcess();
    }
	
    pass P4 {
		VertexShader = compile vs_3_0 VS_Effect();
        PixelShader  = compile ps_3_0 PS_BlurProcess();
    }
	
	pass P5 {
		VertexShader = compile vs_3_0 VS_Effect();
        PixelShader  = compile ps_3_0 PS_NoiseProcess();
    }
	
	pass P6 {
		VertexShader = compile vs_3_0 VS_Effect();
        PixelShader  = compile ps_3_0 PS_DistortionProcess();
    }
	
	pass P7 {
        PixelShader  = compile ps_3_0 PS_ScreenProcess();
	}
}

technique TQ_Effect_ParticleInstancing
{
	pass P0 {
		VertexShader = compile vs_3_0 VS_EffectInstancing();
		PixelShader = compile ps_3_0 PS_MultiplyProcessInstancing();
	}

	pass P1 {
		VertexShader = compile vs_3_0 VS_EffectInstancing();
		PixelShader = compile ps_3_0 PS_AdditiveProcessInstancing();
	}

	pass P2 {
		VertexShader = compile vs_3_0 VS_EffectInstancing();
		PixelShader = compile ps_3_0 PS_ExchangeProcessInstancing();
	}

	pass P3 {
		VertexShader = compile vs_3_0 VS_Effect();
		PixelShader = compile ps_3_0 PS_ShakeProcess();
	}

	pass P4 {
		VertexShader = compile vs_3_0 VS_Effect();
		PixelShader = compile ps_3_0 PS_BlurProcess();
	}

	pass P5 {
		VertexShader = compile vs_3_0 VS_Effect();
		PixelShader = compile ps_3_0 PS_NoiseProcess();
	}

	pass P6 {
		VertexShader = compile vs_3_0 VS_Effect();
		PixelShader = compile ps_3_0 PS_DistortionProcess();
	}

	pass P7 {
		PixelShader = compile ps_3_0 PS_ScreenProcess();
	}
}

technique TQ_Effect_ParticleInstancing_Frk
{
	pass P0 {
		VertexShader = compile vs_3_0 VS_EffectInstancing_Frk();
		PixelShader = compile ps_3_0 PS_MultiplyProcessInstancing();
	}
}

technique TQ_Effect_Model
{	
	 pass P0 {
		VertexShader = compile vs_3_0 VS_Effect_Model();
        PixelShader  = compile ps_3_0 PS_MultiplyProcess();
    }
	
	pass P1 {
		VertexShader = compile vs_3_0 VS_Effect_Model();
        PixelShader  = compile ps_3_0 PS_AdditiveProcess();
    }
	
	pass P2 {
		VertexShader = compile vs_3_0 VS_Effect_Model();
        PixelShader  = compile ps_3_0 PS_ExchangeProcess();
    }
	
	pass P3 {
		VertexShader = compile vs_3_0 VS_Effect_Model();
        PixelShader  = compile ps_3_0 PS_LightingProcess();
    }
	
	pass P4 {
		VertexShader = compile vs_3_0 VS_Effect_Model();
        PixelShader  = compile ps_3_0 PS_ShakeProcess();
    }
	
    pass P5 {
		VertexShader = compile vs_3_0 VS_Effect_Model();
        PixelShader  = compile ps_3_0 PS_BlurProcess();
    }
	
	pass P6 {
		VertexShader = compile vs_3_0 VS_Effect_Model();
        PixelShader  = compile ps_3_0 PS_NoiseProcess();
    }
	
	pass P7 {
		VertexShader = compile vs_3_0 VS_Effect_Model();
        PixelShader  = compile ps_3_0 PS_DistortionProcess();
    }
}

technique TQ_Effect_AniModel
{
	pass P0 {
		VertexShader = compile vs_3_0 VS_Effect_AniModel(); 
        PixelShader  = compile ps_3_0 PS_MultiplyProcess();       
    }
	
	pass P1 {
		VertexShader = compile vs_3_0 VS_Effect_AniModel();
        PixelShader  = compile ps_3_0 PS_AdditiveProcess();
    }
	
	pass P2 {
		VertexShader = compile vs_3_0 VS_Effect_AniModel();
        PixelShader  = compile ps_3_0 PS_ExchangeProcess();
    }
	
	pass P3 {
		VertexShader = compile vs_3_0 VS_Effect_AniModel();
        PixelShader  = compile ps_3_0 PS_LightingProcess();
    }
	
	pass P4 {
		VertexShader = compile vs_3_0 VS_Effect_AniModel();
        PixelShader  = compile ps_3_0 PS_ShakeProcess();
    }
	
    pass P5 {
		VertexShader = compile vs_3_0 VS_Effect_AniModel();
        PixelShader  = compile ps_3_0 PS_BlurProcess();
    }
	
	pass P6 {
		VertexShader = compile vs_3_0 VS_Effect_AniModel();
        PixelShader  = compile ps_3_0 PS_NoiseProcess();
    }
	
	pass P7 {
		VertexShader = compile vs_3_0 VS_Effect_AniModel();
        PixelShader  = compile ps_3_0 PS_DistortionProcess();
    }
}

technique Decal
{
	pass P0 {
		VertexShader = compile vs_3_0 VS_Decal();
		PixelShader = compile ps_3_0 PS_Decal();
	}
}

#endif //__IMCEFFECTSHADER_FX__
