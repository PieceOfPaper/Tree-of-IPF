#ifndef __GLOBALVARIABLE_FX__
#define __GLOBALVARIABLE_FX__

float4x4	g_WorldTM      					: WORLD_TM;
float4x4	g_WorldViewTM					: WORLDVIEW_TM;
float4x4	g_WorldViewProjTM				: WORLDVIEWPROJECTION_TM;
float4x4	g_InvWorldTM					: INVWORLD_TM;
float4x4	g_InvWorldTTM					: INVWORLDT_TM;
float4x4	g_InvProjTM						: INVPROJ_TM;
float4x4	g_ViewTM						: VIEW_TM;
float4x4	g_InvViewTM						: INVVIEW_TM;
float4x4	g_ViewProjTM					: VIEWPROJECTION_TM;
float4x4	g_InvWorldViewProjTM			: INVWORLDVIEWPROJ_TM;
float4x4	g_WorldInvTTM					: WORLDINVTRANSPOSE_TM;
float4x3	g_BoneTM[50]					: BONE_TM;
float4x4	g_RealWorldTM					: REALWORLD_TM;
float4x4 	g_InvWorldViewTM				: INVWORLDVIEW_TM;
float3 		g_midPos						: MID_POS;

float4 		g_BlendColor					: BLENDCOLOR;

int 		g_boneTexID						: BONE_TEX_ID;
float 		g_SSAOScale						: SSAO_SCALE;
float 		g_AlphaValue					: ALPHA_VALUE;
float3		g_WorldLightDir					: WORLDLGT_DIR;
float3		g_WorldLightDiffuse				: WORLDLGT_DIFFUSE;
float3		g_WorldLightAmbient 			: WORLDLGT_AMBIENT;
float3 		g_WorldLightSpecular			: WORLDLGT_SPECULAR;

float4		g_EnvironmentLightCoefficients[7]	: ENVIRONMENT_LIGHT_COEFFICIENTS;
float		g_EnvironmentLightIntensity[2]		: ENVIRONMENT_LIGHT_INTENSITY;

float3		g_WorldEyePos					: WORLD_EYEPOS;
float3		g_ViewerDir						: VIEWER_DIR;
float 		g_FarPlaneDist					: FARPLANE_DIST = 50000.0f;

float3		g_FogDist						: FOG_DIST;
float3		g_FogColor						: FOG_COLOR;
float3		g_FogHeight						: FOG_HEIGHT;
float3		g_HeightFogColor				: FOG_HEIGHT_COLOR;
float		g_FogDistDensity				: FOG_DIST_DENSITY;
float		g_FogHeightDensity				: FOG_HEIGHT_DENSITY;

float4		g_ScreenSize					: SCREENSIZE;
float		g_ShadowInfluence[2]			: SHADOW_INFLUENCE = {1.0f, 1.0f};

float		g_RecipAreaSize					: RECIP_AREA_SIZE;

float4		g_AlphaBlending					: ALPHABLENDINGVALUE;
float3		g_ColorTone						: COLORTONE_COLOR;
float3		g_Brighten						: BRIGHTEN_COLOR;
float3		g_SimpleColor					: SIMPLE_COLOR;

#ifdef ENABLE_MATERIALDIFFUSE
float3		g_MaterialDiffuse				: MATERIAL_DIFFUSE = {1.0f, 1.0f, 1.0f};
#endif

#ifdef ENABLE_MATERIALOPACITY
float		g_MaterialOpacity				: MATERIAL_OPACITY = 1.0f;
#endif

#ifdef ENABLE_MATERIALSPECULARCOLOR
float3		g_MaterialSpecularColor			: MATERIAL_SPECULARCOLOR = {1.0f, 1.0f, 1.0f};
#endif

#ifdef ENABLE_MATERIALSPECULARPOWER
float		g_MaterialSpecularPower			: MATERIAL_SPECULARPOWER = 1.0f;
#endif

#ifdef ENABLE_DEPTH_BIAS_BLEND
float 		g_DepthBiasBlendScale			: DEPTHBIASBLEND_SCALE = 32;
#endif

#ifdef ENABLE_OUTLINE_MASKING
float3		g_MaskingColor					: MASKING_COLOR;
#endif

#ifdef ENABLE_DEFERRED_RENDER
float2		g_HalfPixelSize					: HALF_PIXEL_SIZE;
float3		g_FarCornerVectors[4]			: FAR_CORNER_VECTORS;
#endif

#endif //__GLOBALVARIABLE_FX__