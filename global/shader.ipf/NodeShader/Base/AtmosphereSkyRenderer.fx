#ifndef __ATMOSPHERE_SKY_RENDERER_FX__
#define __ATMOSPHERE_SKY_RENDERER_FX__

#include "NodeShader\Base\Scattering.fx"

float4x4 	g_WorldViewProjTM;
float		g_fLightIntensity = 1.0f;

struct VS_IN {
	float4 localPos : POSITION;
};

struct VS_OUT {
	float4 pos 		: POSITION;
	float3 worldPos	: TEXCOORD0;
};

VS_OUT VS_Sky(float4 localPos : POSITION)
{
	// Get the ray from the camera to the vertex, and its length (which is the far point of the ray passing through the atmosphere)
	VS_OUT OUT = (VS_OUT)0;
	OUT.pos = mul(float4(localPos.xyz, 1.0f), g_WorldViewProjTM);

	float3 worldPos = localPos.xyz;
	worldPos /= g_fSkyDomeRadius;
	worldPos *= g_fThickness;
	worldPos.y += g_fInnerRadius;

	OUT.worldPos = worldPos;

	return OUT;
}

struct PS_OUT {
	float4 Sky : COLOR0;
	float4 Sun : COLOR1;
};

PS_OUT PS_Sky(VS_OUT In) : COLOR
{
	float3 worldPos = In.worldPos;
	float3 v3Ray = worldPos - g_v3CameraPos;
	float fFar = length(v3Ray);
	v3Ray /= fFar;

	float3 v3Start = g_v3CameraPos;
	float fStartHeight = length(v3Start);
	float fStartDepth = exp(0.0f);
	float fStartAngle = dot(v3Ray, v3Start) / fStartHeight;
	float fStartOffset = fStartDepth * Scale(fStartAngle);

	float fSampleLength = fFar / 2.0f;
	float fScaledLength = fSampleLength * g_fScale;
	float3 v3SampleRay = v3Ray * fSampleLength;
	float3 v3SamplePoint = v3Start + v3SampleRay;

	float3 v3FrontColor = 0.0f;
	for(int i = 0; i < 2; i++)		//반복횟수를 수정하면  float fSampleLength = fFar / 2.0f; 의 2.0f도 수정할 것.
	{
		float fHeight = length(v3SamplePoint);
		float fDepth = exp(g_fScaleOverScaleDepth * (g_fInnerRadius - fHeight));
		float fLightAngle = dot(g_v3LightDir, v3SamplePoint) / fHeight;
		float fCameraAngle = dot(v3Ray, v3SamplePoint) / fHeight;
		float fScatter = fStartOffset + fDepth * (Scale(fLightAngle) - Scale(fCameraAngle));
		float3 v3Attenuate = exp(-fScatter * (g_v3InvWavelength * g_fKr4PI + g_fKm4PI));
		v3FrontColor += v3Attenuate * (fDepth * fScaledLength);
		v3SamplePoint += v3SampleRay;
	}
	float3 rayleighColor = v3FrontColor * (g_v3InvWavelength * g_fKrESun);
	float3 mieColor = v3FrontColor * g_fKmESun;

	float3 viewVec = g_v3CameraPos - worldPos;
	float fCos = dot(g_v3LightDir, viewVec) / length(viewVec);
	float fCos2 = fCos*fCos;
	float fMiePhase = GetMiePhase(fCos, fCos2, g, g2);
	float fRayleigh = GetRayleighPhase(fCos2);
	float3 Sun = fMiePhase * mieColor;
	float3 Color = fRayleigh * rayleighColor + Sun;

	PS_OUT o = (PS_OUT)0;
	o.Sky = float4(Color, 1.0f);
	o.Sun = float4(Sun, 1.0f);
	return o;
}

technique SkyTq
{
	pass P0 {
		SRGBWRITEENABLE = TRUE;
		ZENABLE = FALSE;
		ZWRITEENABLE = FALSE;
		VertexShader = compile vs_3_0 VS_Sky();
		PixelShader  = compile ps_3_0 PS_Sky();
	}
}
#endif //__ATMOSPHERE_SKY_RENDERER_FX__