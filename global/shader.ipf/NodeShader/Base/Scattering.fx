#ifndef __SCATTERING_FX__
#define __SCATTERING_FX__

float3 		g_v3LightDir		: LIGHT_DIR;				// The direction vector to the light source
float3 		g_v3CameraPos		: SCATTER_CAMPOS;			// The camera's current position

float3 		g_v3InvWavelength	: SCATTER_INV_WAVELENGTH;	// 1 / pow(wavelength, 4) for the red, green, and blue channels
float 		g_fInnerRadius		: SCATTER_INNER_RADIUS;		// The inner (planetary) radius
float 		g_fThickness		: SCATTER_THICKNESS;
float 		g_fKrESun			: SCATTER_KR_E_SUN;			// Kr * ESun
float 		g_fKmESun			: SCATTER_KM_E_SUN;			// Km * ESun
float 		g_fKr4PI			: SCATTER_KR_4_PI;			// Kr * 4 * PI
float 		g_fKm4PI			: SCATTER_KM_4_PI;			// Km * 4 * PI
float 		g_fScale			: SCATTER_SCALE;			// 1 / (g_fOuterRadius - g_fInnerRadius)
float 		g_fScaleOverScaleDepth : SCATTER_OVER_SCALE_DEPTH;	// g_fScale / g_fScaleDepth
float 		g_fSkyDomeRadius	: SCATTER_DOME_RADIUS;		// skyDome¿« Rad

float 		g					: SCATTER_G;
float 		g2					: SCATTER_G2;

const float	g_fScaleDepth 		: SCATTER_SCALE_DEPTH;
const float	g_fInvScaleDepth 	: SCATTER_INVSCALE_DEPTH;		// 1.0f / SCATTER_SCALE_DEPTH;

float Scale(float fCos)
{
	float x = 1.0f - fCos;
	return g_fScaleDepth * exp(-0.00287f + x * (0.459f + x * (3.83f + x * (-6.80f + x * 5.25f))));
}

float GetRayleighPhase(float fCos2)
{
	return 0.75f * (2.0f + 0.5f * fCos2);
}

float GetMiePhase(float fCos, float fCos2, float g, float g2)
{
	return 1.5f * ((1.0f - g2) / (2.0f + g2)) * (1.0f + fCos2) / pow(1.0f + g2 - 2.0f * g * fCos, 1.5f);
}

void GetRayleighMie(in float3 scatterPos, out float3 rayleigh, out float3 mie)
{
	scatterPos /= g_fSkyDomeRadius;
	scatterPos *= g_fThickness;
	scatterPos.y += g_fInnerRadius;

	float3 v3CameraPos = float3(g_v3CameraPos.x, scatterPos.y, g_v3CameraPos.z);
	float fCameraHeight = length(v3CameraPos);

	float3 v3Ray = scatterPos - v3CameraPos;
	float fFar = length(v3Ray);
	v3Ray /= fFar;

	float3 v3Start = v3CameraPos;
	float fStartDepth = exp((g_fInnerRadius - fCameraHeight) * g_fInvScaleDepth);
	float fStartHeight = length(scatterPos);
	float fCameraAngle = dot(-v3Ray, scatterPos) / fStartHeight;
	float fLightAngle = dot(g_v3LightDir, scatterPos) / fStartHeight;
	float fCameraScale = Scale(fCameraAngle);
	float fLightScale = Scale(fLightAngle);
	float fCameraOffset = fStartDepth * fCameraScale;
	float fTemp = fLightScale + fCameraScale;

	float fSampleLength = fFar / 2.0f;
	float fScaledLength = fSampleLength * g_fScale;
	float3 v3SampleRay = v3Ray * fSampleLength;
	float3 v3SamplePoint = v3Start + v3SampleRay * 0.5f;

	float3 v3FrontColor = 0.0f;
	float3 v3Attenuate = 0.0f;
	for(int i = 0; i < 2; i++)
	{
		float fHeight = length(v3SamplePoint);
		float fDepth = exp(g_fScaleOverScaleDepth * (g_fInnerRadius - fHeight));
		float fScatter = fDepth * fTemp - fCameraOffset;
		v3Attenuate = exp(-fScatter * (g_v3InvWavelength * g_fKr4PI + g_fKm4PI));
		v3FrontColor += v3Attenuate * (fDepth * fScaledLength);
		v3SamplePoint += v3SampleRay;
	}
	rayleigh = v3FrontColor * (g_v3InvWavelength * g_fKrESun + g_fKmESun);
	mie = v3Attenuate;
}


#endif