#ifndef __MODELSHADER_FX__
#define __MODELSHADER_FX__

// ShaderRenderer.h 에 있는 MAX_INSTANCE_COUNT 값과 동일하게 유지해야함
#define MAX_INSTANCE_COUNT 10

float4x4 g_ViewTM;
float4x4 g_InvViewTM;
float4x4 g_ViewProjTM;

float4 g_outLineColor = float4(1.f, 1.f, 0.f, 0.f);

#ifdef ENABLE_FREEZE
float4 g_materialShaderColor = float4(0.8f, 1.f, 1.6f, 1.f);
float4 g_materialShaderHeadColor = float4(0.96f, 1.5f, 2.5f, 1.f);
float g_fallOffMultiplyValue = 0.2f;
float g_materialShaderPowValue = 1.35f;
float g_colorMultiplyValue = 2.f;
#endif

float g_AlphaBlending;
float g_timeStamp = 0.f;

#ifdef ENABLE_INSTANCING
int g_InstanceCount;

// x : Matrix
// y : Bone
float2 g_InstanceID[MAX_INSTANCE_COUNT];

// 0 : g_pivotPoint
// 1 : g_BlendColor
// 2 : g_BlendColorAdd
// 3 : g_auraColor
// 4 : g_auraValues (x : factor, y : auraTime)
// 5 : g_SkinBlendColor
#ifdef ENABLE_FACE
// 6 : g_faceXYMulAdd
float4 g_InstanceVecArray[MAX_INSTANCE_COUNT * 7];
#else
float4 g_InstanceVecArray[MAX_INSTANCE_COUNT * 6];
#endif

texture VTF_MatrixInstance;
sampler vtf_MatrixInstance = sampler_state
{
	Texture = (VTF_MatrixInstance);
	AddressU = CLAMP;
	AddressV = CLAMP;
	SRGBTEXTURE = FALSE;
};

#define VTF_MATRIX_WORLD 0
#define VTF_MATRIX_BILLBOARD 1
#define VTF_MATRIX_CHAR_VIEW_PROJ 2
float4x4 GetMatrixInstance(int idx, int type)
{
	int index = idx + type;
	const float TEX_WIDTH = 512.f;
	const float TEX_HEIGTH = 512.f;
	const int OffsetWidth = TEX_WIDTH / 4;
	const int OffsetHeight = TEX_WIDTH / 4;

	float4 uvCol = float4(((float)((index % OffsetWidth) * 4) + 0.5f) / TEX_WIDTH, ((float)((index / OffsetHeight)) + 0.5f) / TEX_HEIGTH, 0.f, 0.f);
	float4x4 mat;
	mat._11_21_31_41 = tex2Dlod(vtf_MatrixInstance, uvCol);
	mat._12_22_32_42 = tex2Dlod(vtf_MatrixInstance, uvCol + float4(1.f / TEX_WIDTH, 0.f, 0.f, 0));
	mat._13_23_33_43 = tex2Dlod(vtf_MatrixInstance, uvCol + float4(2.f / TEX_WIDTH, 0.f, 0.f, 0));
	mat._14_24_34_44 = float4(0.f, 0.f, 0.f, 1.f);
	return mat;
}

#else
float4x4 g_WorldTM;
float4x4 g_WorldViewTM;
float4 g_BlendColor = float4(0.5f, 0.5f, 0.5f, 1.f);
float4 g_BlendColorAdd = float4(0.f, 0.f, 0.f, 0.f);
float4 g_auraColor = float4(0.f, 0.f, 0.f, 0.f);
// x : factor, y : auraTime
float4 g_auraValues = float4(0.f, 0.f, 0.f, 0.f);
float4 g_SkinBlendColor = float4(1.f, 1.f, 1.f, 1.f);

// 3d캐릭터 2d로 그리는거
float4x4 g_billboardTM;
float4x4 g_charViewProjTM;
float3 g_pivotPoint;

// 3d캐릭터 2d로 그리는거
#ifdef ENABLE_FACE
float4 g_faceXYMulAdd = 0.f;
#endif
#endif

#ifdef ENABLE_CHARACTER_RENDER
float4x4 g_TestMatrix;		// 타는 문제 때문에 추가된 매트릭스
float4x4 g_AngleMatrix;

float3 g_MidPos = float3(2000.f, 2000.f, 2000.f);
float g_depthDistanceValue = 8;
float4x4 g_depthDistTM;
float g_envValue = 1.f;

//x = Brightness;
//y = contrast
//z = hue
//w = saturation
float4 g_farValue = float4(-7.641f, 0.f, 0.f, -24.f);
float4 g_outLineValue = float4(-12.f, -30.f, 0.f, -40.f);

#endif

#ifdef ENABLE_SKINNING
int g_boneTexID : BONE_TEX_ID;

texture VTF_Tex : SKIN_VTF_TEX;
sampler vtf_skin = sampler_state
{
	Texture = (VTF_Tex);
	AddressU = CLAMP;
	AddressV = CLAMP;
	SRGBTEXTURE = FALSE;
};

float4x4 GetSkinMatrix(int idx)
{
	const float TEX_WIDTH = 512.f;
	const float TEX_HEIGTH = 512.f;
	const int OffsetWidth = TEX_WIDTH / 4;
	const int OffsetHeight = TEX_WIDTH / 4;

	float4 uvCol = float4(((float)((idx % OffsetWidth) * 4) + 0.5f) / TEX_WIDTH, ((float)((idx / OffsetHeight)) + 0.5f) / TEX_HEIGTH, 0.f, 0);
	float4x4 mat;
	mat._11_21_31_41 = tex2Dlod(vtf_skin, uvCol),
		mat._12_22_32_42 = tex2Dlod(vtf_skin, uvCol + float4(1.f / TEX_WIDTH, 0.f, 0.f, 0)),
		mat._13_23_33_43 = tex2Dlod(vtf_skin, uvCol + float4(2.f / TEX_WIDTH, 0.f, 0.f, 0)),
		mat._14_24_34_44 = float4(0.f, 0.f, 0.f, 1.f);
	return mat;
}
#endif

#ifdef ENABLE_DIFFUSETEX_ANIMATION
float4x4 g_DiffuseAnimationTM;
texture UVAnimMaskTex;
sampler uvAnimMaskTex = sampler_state
{
	Texture = (UVAnimMaskTex);

	AddressU = WRAP;
	AddressV = WRAP;

	MIPFILTER = NONE;
	MINFILTER = LINEAR;
	MAGFILTER = LINEAR;
};
#endif

#ifdef ENABLE_DIFFUSETEX
texture DiffuseTex;
sampler diffuseTex = sampler_state
{
	Texture = (DiffuseTex);

	AddressU = WRAP;
	AddressV = WRAP;

	MIPFILTER = NONE;
	MINFILTER = LINEAR;
	MAGFILTER = LINEAR;
};
#endif

#ifdef ENABLE_SKIN_MASK_TEX
texture DiffuseTex_SkinMask;
sampler diffuseTex_skinMask = sampler_state
{
	Texture = (DiffuseTex_SkinMask);

	AddressU = WRAP;
	AddressV = WRAP;

	MIPFILTER = NONE;
	MINFILTER = LINEAR;
	MAGFILTER = LINEAR;
};
#endif

#ifdef ENABLE_ENVTEX
texture EnvTex;
sampler envTex = sampler_state
{
	Texture = (EnvTex);
	AddressU = WRAP;
	AddressV = WRAP;
};
#endif 

#ifdef ENABLE_FREEZE
texture FreezeTex;
sampler freezeTex = sampler_state
{
	Texture = (FreezeTex);
	AddressU = WRAP;
	AddressV = BORDER;
};
#endif


#ifdef ENABLE_STATICSHADOWTEX
texture StaticShadowTex;
sampler staticShadowTex = sampler_state
{
	Texture = (StaticShadowTex);
	AddressU = WRAP;
	AddressV = WRAP;
};
#endif

texture ScreenTex;
sampler screenTex = sampler_state
{
	Texture = (ScreenTex);
	AddressU = WRAP;
	AddressV = WRAP;
};

#ifdef ENABLE_WATER


texture NormalTex;
sampler normalTex = sampler_state
{
	Texture = (NormalTex);
	AddressU = WRAP;
	AddressV = WRAP;
};
texture DepthTex;
sampler depthTex = sampler_state
{
	Texture = (DepthTex);
	AddressU = WRAP;
	AddressV = WRAP;
};
#endif

float mapSize;
float mapOffsetX;
float mapOffsetY;

float mapTop;
float mapBottom;

#ifdef ENABLE_WATER
float4 waterDiffDir;// = float2(0, -0.1);

float waterSwaySpeed;// = 1;	
float4 waterSwayRange;// = float2(0.01, 0);
float waterSwayPower;// = 0.005;

float refractionNormalSize;// = 0.01;
float4 refractionDir;// = float2(-0.05, 0.01);
float refractionPower;// = 0.05;

float waterSprayNormalSize;// = 0.01;
float4 waterSprayDir;// = float2(-0.1, -0.01);
float waterSprayPower;// = 0.01;
float waterSparyRange;// = 0.2;
float4 waterSprayColor;// = float3(0.1, 0.2, 0.3);
#endif

#ifdef ENABLE_GRASS
float4	g_grassAttack[10];
float	g_grassAttackTFactor[10];
float4	g_grassDefense[10];
float4	g_grassInHuman[10];

float g_windPower = 200.f;
float g_grassTime = 0;
float g_grassTimeoffset;
float g_windDir;

texture HeightTex;
sampler heightTex = sampler_state
{
	Texture = (HeightTex);
	AddressU = CLAMP;
	AddressV = CLAMP;
};
#endif

float4	g_FogColor;
float4	g_FogDist	: FOG_DIST;
float4	g_lightColor;

//g_FogDist
//x = fog Start
//y = fog End
//z = End - Start
//w = 사용하지 않음.
float Fog_CalcFogValue(in float viewRange)
{
	return (g_FogDist.y - viewRange) / (g_FogDist.z);
}

struct OUT_COLOR
{
	float4 albedo : COLOR0;
	float4 depth : COLOR1;
};

float4 CalcDepth(in float depth, in float worldPosY, in float4 posWV)
{
	float4 Out = 0;
	Out.r = depth * 0.0002;
	Out.g = length(posWV.xyz) * 0.0002f;
	Out.b = (worldPosY + 300) * 0.001;
	Out.a = 1.f;
	return Out;
}

#ifdef ENABLE_INSTANCING
float4 CalcWVP(in float4 PosW, int instanceID, int matrixID, out float4 PosWV)
{
	// 캐릭터 2D 렌더링
#ifdef ENABLE_2D
	float worldPosY = PosW.y;
	PosW = mul(PosW, GetMatrixInstance(matrixID, VTF_MATRIX_CHAR_VIEW_PROJ));
	PosW /= PosW.w;
	PosW.z = 0.f;	// 빌보드로 만듦
	PosW.y += 0.4f;  // 캐릭터 발 위치를 맞추기 위한 상수
	PosW = mul(PosW, GetMatrixInstance(matrixID, VTF_MATRIX_BILLBOARD));
	PosWV = mul(PosW, g_ViewTM);
	PosW = mul(PosW, g_ViewProjTM);
	// (Local Z - 카메라 거리 : Z값을 0 앞뒤로 맞추기 위함) * 적당히 납작하게 만들기 위한 상수 - 깊이 보정값

	float uprate = 1.1;
	float pivotOffset = 100;
	float4 pivotPoint = g_InstanceVecArray[instanceID];
	float4 pivotMul = mul(float4(pivotPoint.x, (worldPosY - pivotPoint.y + pivotOffset) * uprate + pivotPoint.y - pivotOffset, pivotPoint.z, 1), g_ViewProjTM);
	float defz = pivotMul.z / pivotMul.w;
	PosW.z = defz * PosW.w;

	return PosW;
#else
	PosWV = mul(PosW, g_ViewTM);
	return mul(PosW, g_ViewProjTM);
#endif
}
#else
float4 CalcWVP(in float4 PosW, out float4 PosWV)
{
	// 캐릭터 2D 렌더링
#ifdef ENABLE_2D
	float worldPosY = PosW.y;
	PosW = mul(PosW, g_charViewProjTM);
	PosW /= PosW.w;
	PosW.z = 0.f;	// 빌보드로 만듦
	PosW.y += 0.4f;  // 캐릭터 발 위치ㄹ르 맞추기 위한 상수
	PosW = mul(PosW, g_billboardTM);
	PosWV = mul(PosW, g_ViewTM);
	PosW = mul(PosW, g_ViewProjTM);

	float uprate = 1.1;
	float pivotOffset = 100;
	float4 pivotMul = mul(float4(g_pivotPoint.x, (worldPosY - g_pivotPoint.y + pivotOffset) * uprate + g_pivotPoint.y - pivotOffset, g_pivotPoint.z, 1), g_ViewProjTM);
	float defz = pivotMul.z / pivotMul.w;
	PosW.z = defz * PosW.w;

	return PosW;
#else
	PosWV = mul(PosW, g_ViewTM);
	return mul(PosW, g_ViewProjTM);
#endif
}
#endif

float fall_off(float3 normal, float3 eyevec)
{
	normal = normalize(normal);
	eyevec = normalize(eyevec);
	float falloff = max(0.f, dot(normal, eyevec));
	return falloff;
}

#ifdef ENABLE_FREEZE
float4 freezeHead(in float4 outcolor, in float falloff)
{
	outcolor.rgb = (outcolor.r + outcolor.g + outcolor.b) / 3;

	falloff = smoothstep(0.2f, 0.4f, falloff) * 0.8;
	falloff -= (1 - smoothstep(0.f, 0.3f, outcolor.r));

	outcolor.rgb += (1 - falloff) * g_fallOffMultiplyValue * 1.3;
	outcolor.rgb *= g_materialShaderHeadColor.rgb * g_colorMultiplyValue;

	outcolor.rgb = pow(abs(outcolor.rgb), g_materialShaderPowValue);

	return outcolor;
}

float4 freeze(in float4 outcolor, in float2 uv, in float falloff)
{
	outcolor.rgb = (outcolor.r + outcolor.g + outcolor.b) / 3;

	falloff = smoothstep(0.2f, 0.4f, falloff) * 0.8;
	falloff -= (1 - smoothstep(0.f, 0.3f, outcolor.r));

	outcolor.rgb += (1 - falloff) * g_fallOffMultiplyValue * 1.3;
	outcolor.rgb *= g_materialShaderColor.rgb * g_colorMultiplyValue;

	outcolor.rgb = pow(abs(outcolor.rgb), g_materialShaderPowValue);

#ifdef ENABLE_SKINNING
	float4 freeze = tex2D(freezeTex, uv);
	outcolor.rgb = outcolor.rgb * (1 - freeze.a) + freeze.rgb * (freeze.a);
#endif

	return outcolor;
}
#endif

void CalcDiffuseTexCoord(in float2 texCoord, out float4 outTexCoord)
{
#ifdef ENABLE_DIFFUSETEX_ANIMATION
	float4 TransTex = float4(texCoord.xy, 1.f, 1.f);
	float4x4 matAnim = g_DiffuseAnimationTM;
	matAnim._24 = 0.f;
	outTexCoord.xy = mul(TransTex, matAnim).xy;
	outTexCoord.zw = texCoord;
#else
	outTexCoord = float4(texCoord.xy, 0.f, 0.f);
#endif
}

struct VS_OUT
{
	float4 Pos : POSITION;
	float4 diffuseTexCoord : TEXCOORD0;

#if defined (ENABLE_STATICSHADOWTEX) 
	float4 shadowCoord : TEXCOORD1;
#endif
#if defined(ENABLE_ENVTEX)
	float4 envTexCoord : TEXCOORD2;
#endif
	float4 outDepth	: TEXCOORD3;
	float3 viewVec : TEXCOORD4;
	float4 worldNml : TEXCOORD5;
	float4 worldPos : TEXCOORD6;
	float4 worldz_tmIndex_fog : TEXCOORD7;
	float4 posWV : TEXCOORD8;
};

struct VS_OUT_AURA
{
	float4 Pos : POSITION;
	float tmIndex : TEXCOORD0;
};

VS_OUT_AURA VS_ModelAuraShader(in float4 InPos : POSITION, in float4 InNml : NORMAL, in float4 Tex : TEXCOORD0, in float4 Tex1 : TEXCOORD1
#ifdef ENABLE_SKINNING
	, in float4 weights : BLENDWEIGHT, in float4 indices : BLENDINDICES
#endif
#ifdef ENABLE_INSTANCING
	, in float tmID : TEXCOORD2
#endif
)
{
	VS_OUT_AURA o = (VS_OUT_AURA)0;

	//Position
	float4 localPos = 0.f;
	float3 localNml = 0.f;

#ifdef ENABLE_INSTANCING
	int instanceID = (int)(tmID + 1e-5f);
	int matrixID = g_InstanceID[instanceID].x;

	o.tmIndex = instanceID;

	float4x4 WorldTM = GetMatrixInstance(matrixID, VTF_MATRIX_WORLD);
#else
	float4x4 WorldTM = g_WorldTM;
#endif

#ifdef ENABLE_SKINNING
	int boneIDIndex = g_boneTexID;
#ifdef ENABLE_INSTANCING
	boneIDIndex = g_InstanceID[instanceID].y;
#endif

	float4 indices2 = D3DCOLORtoUBYTE4(indices);
	for (int i = 0; i < 4; ++i)
	{
		float4x4 boneTM = GetSkinMatrix(indices2[i] + boneIDIndex);
		localPos += mul(InPos, boneTM) * weights[i];
		localNml += mul(InNml.xyz, (float3x3)boneTM) * weights[i];
	}
	localPos.w = 1.f;
#else
	localPos = InPos;
	localNml = InNml.xyz;
	localPos.w = 1.f;
#endif

	float4 worldPos = mul(localPos, WorldTM);
	float3 worldNml = mul(localNml, (float3x3)WorldTM);

	float4 posWV = 0.f;
#ifdef ENABLE_INSTANCING
	o.Pos = CalcWVP(worldPos, instanceID, matrixID, posWV);
#else
	o.Pos = CalcWVP(worldPos, posWV);
#endif

#ifdef ENABLE_INSTANCING
	float fTime = g_InstanceVecArray[g_InstanceCount * 4 + instanceID].y;
	float fAuraFactor = g_InstanceVecArray[g_InstanceCount * 4 + instanceID].x;
#else
	float fAuraFactor = g_auraValues.x;
	float fTime = g_auraValues.y;
#endif

	float3 vpNml = mul(localNml.xyz, (float3x3)g_ViewProjTM).xyz;
	o.Pos.x += fTime * vpNml.x * fAuraFactor + sin(fTime * 3.14f) * 0.5f;
	float y = o.Pos.y;
	o.Pos.y += fTime * vpNml.y * fAuraFactor * 1.5f;
	o.Pos.y = max(o.Pos.y, y + sin(fTime));

	return o;
}

#define OPTION_TYPE_SILHOUETTE 1
#define OPTION_TYPE_OUTLINE 2
#define OPTION_TYPE_OUTLINE2 3
#define OPTION_TYPE_HEAD_OUTLINE 4

VS_OUT VS_ModelOption(in float4 InPos : POSITION, in float4 InNml : NORMAL, in float4 Tex : TEXCOORD0, in float4 Tex1 : TEXCOORD1
#ifdef ENABLE_SKINNING
	, in float4 weights : BLENDWEIGHT, in float4 indices : BLENDINDICES
#endif
#ifdef ENABLE_INSTANCING
	, in float tmID : TEXCOORD2
#endif
	, uniform const int optionType
)
{
	VS_OUT o = (VS_OUT)0;

	//Position
	float4 localPos = 0.f;
	float3 localNml = 0.f;

#ifdef ENABLE_INSTANCING
	int instanceID = (int)(tmID + 1e-5f);
	int matrixID = g_InstanceID[instanceID].x;

	o.worldz_tmIndex_fog.y = instanceID;
	float4x4 WorldTM = GetMatrixInstance(matrixID, VTF_MATRIX_WORLD);
#else
	float4x4 WorldTM = g_WorldTM;
#endif

#ifdef ENABLE_SKINNING
	int boneIDIndex = g_boneTexID;
#ifdef ENABLE_INSTANCING
	boneIDIndex = g_InstanceID[instanceID].y;
#endif

	float4 indices2 = D3DCOLORtoUBYTE4(indices);
	for (int i = 0; i < 4; ++i)
	{
		float4x4 boneTM = GetSkinMatrix(indices2[i] + boneIDIndex);
		localPos += mul(InPos, boneTM) * weights[i];
		localNml += mul(InNml.xyz, (float3x3)boneTM) * weights[i];
	}
	localPos.w = 1.f;
#else
	localPos = InPos;
	localPos.w = 1.f;

	localNml = InNml.xyz;
#endif

	if (optionType == OPTION_TYPE_OUTLINE)
	{
		localPos.xyz += normalize(localNml) * 0.3f;
	}
	else if (optionType == OPTION_TYPE_OUTLINE2)
	{
		localPos.xyz += normalize(localNml) * 1.f;
	}

	float4 worldPos = mul(localPos, WorldTM);
	float3 worldNml = mul(localNml.xyz, (float3x3)WorldTM).xyz;

	float4 posWV = 0.f;
#ifdef ENABLE_INSTANCING
	o.Pos = CalcWVP(worldPos, instanceID, matrixID, posWV);
#else
	o.Pos = CalcWVP(worldPos, posWV);
#endif

	if (optionType == OPTION_TYPE_HEAD_OUTLINE)
	{
#ifdef ENABLE_CHARACTER_RENDER
#ifdef ENABLE_INSTANCING
		float4x4 worldAngleTM = mul(WorldTM, g_AngleMatrix);
		o.worldz_tmIndex_fog.x = mul(localPos + float4(0.f, -25.5, 0.f, 0.f), worldAngleTM).z * 0.1f;
#else
		o.worldz_tmIndex_fog.x = mul(localPos + float4(0.f, -25.5, 0.f, 0.f), g_TestMatrix).z * 0.1f;
#endif
#endif

#ifdef ENABLE_FREEZE
		float4 zeroPos = float4(0, 0, 0, 1);
		zeroPos = mul(zeroPos, WorldTM);

		o.worldPos.xyz = worldPos.xyz - zeroPos.xyz;
#else
		o.worldPos.xyz = worldPos.xyz;
#endif
	}

#ifdef ENABLE_DIFFUSETEX
	CalcDiffuseTexCoord(Tex.xy, o.diffuseTexCoord);
#endif

#ifdef ENABLE_CHARACTER_RENDER
	float charPosInView = mul(float4(g_MidPos, 1.f), g_depthDistTM).z;
	float vertexPosInView = mul(localPos, g_depthDistTM).z;
	o.outDepth.x = charPosInView;
	o.outDepth.y = vertexPosInView;
	o.outDepth.w = 1.f;

	o.viewVec = g_InvViewTM[3].xyz - worldPos.xyz;
	o.worldNml.xyz = worldNml;

#ifdef ENABLE_DIFFUSETEX
	// 얼굴 그리는 부분
#ifdef ENABLE_FACE
#ifdef ENABLE_INSTANCING
	float4 faceXYMulAdd = g_InstanceVecArray[g_InstanceCount * 6 + instanceID];
#else
	float4 faceXYMulAdd = g_faceXYMulAdd;
#endif
	o.diffuseTexCoord.x = faceXYMulAdd.x * o.diffuseTexCoord.x + faceXYMulAdd.z;
	o.diffuseTexCoord.y = faceXYMulAdd.y * o.diffuseTexCoord.y + faceXYMulAdd.w;
#endif
#endif
#endif

	o.outDepth = o.Pos / o.Pos.w;

#ifdef ENABLE_WATER
	o.outDepth = o.Pos;
	o.viewVec = g_InvViewTM[1].xyz;
	o.worldNml.xyz = worldNml;
#endif

	return o;
}

VS_OUT VS_OutlineModelShader(in float4 InPos : POSITION, in float4 InNml : NORMAL, in float4 Tex : TEXCOORD0, in float4 Tex1 : TEXCOORD1
#ifdef ENABLE_SKINNING
	, in float4 weights : BLENDWEIGHT, in float4 indices : BLENDINDICES
#endif
#ifdef ENABLE_INSTANCING
	, in float tmID : TEXCOORD2
#endif
	, uniform const int type
	, uniform const int passNum
)
{
	VS_OUT o = (VS_OUT)0;

#ifdef ENABLE_SKINNING
#ifdef ENABLE_INSTANCING
	o = VS_ModelOption(InPos, InNml, Tex, Tex1, weights, indices, tmID, type);
#else
	o = VS_ModelOption(InPos, InNml, Tex, Tex1, weights, indices, type);
#endif
#else
#ifdef ENABLE_INSTANCING
	o = VS_ModelOption(InPos, InNml, Tex, Tex1, tmID, type);
#else
	o = VS_ModelOption(InPos, InNml, Tex, Tex1, type);
#endif
#endif

	if (passNum == 0)
	{
		o.Pos.x += -0.8f;
		o.Pos.y += 0.f;
	}
	else if (passNum == 1)
	{
		o.Pos.x += 0.8f;
		o.Pos.y += 0.f;
	}
	else if (passNum == 2)
	{
		o.Pos.x += 0.f;
		o.Pos.y += -0.8f;
	}
	else if (passNum == 3)
	{
		o.Pos.x += 0.f;
		o.Pos.y += 0.8f;
	}

	o.Pos.z += 0.1f;

	return o;
}

VS_OUT HeightShaderCommon(in float4 InPos
#ifdef ENABLE_SKINNING
	, in float4 weights, in float4 indices
#endif
#ifdef ENABLE_INSTANCING
	, in float tmID : TEXCOORD2
#endif
)
{
	VS_OUT o = (VS_OUT)0;
	//Position
	float4 localPos = 0.f;

#ifdef ENABLE_INSTANCING
	int instanceID = (int)(tmID + 1e-5f);
	int matrixID = g_InstanceID[instanceID].x;

	o.worldz_tmIndex_fog.y = instanceID;
	float4x4 WorldTM = GetMatrixInstance(matrixID, VTF_MATRIX_WORLD);
#else
	float4x4 WorldTM = g_WorldTM;
#endif

#ifdef ENABLE_SKINNING
	int boneIDIndex = g_boneTexID;
#ifdef ENABLE_INSTANCING
	boneIDIndex = g_InstanceID[instanceID].y;
#endif
	float4 indices2 = D3DCOLORtoUBYTE4(indices);
	for (int i = 0; i < 4; ++i)
	{
		float4x4 boneTM = GetSkinMatrix(indices2[i] + boneIDIndex);
		localPos += mul(InPos, boneTM) * weights[i];
	}
	localPos.w = 1.f;
#else
	localPos = InPos;
	localPos.w = 1.f;
#endif

	float3 worldPos = mul(localPos, WorldTM).xyz;
	float worldY = -(worldPos.y + mapBottom) / (mapTop - mapBottom);
	o.Pos = float4(worldPos, 1);
	o.Pos.y = o.Pos.z;
	o.Pos.z = worldY;
	o.Pos.x += mapOffsetX;
	o.Pos.y += mapOffsetY;
	o.Pos.xy /= mapSize;

	return o;
}

VS_OUT VS_HeightShader(in float4 InPos : POSITION, in float4 InNml : NORMAL, in float4 Tex : TEXCOORD0, in float4 Tex1 : TEXCOORD1
#ifdef ENABLE_SKINNING
	, in float4 weights : BLENDWEIGHT, in float4 indices : BLENDINDICES
#endif
#ifdef ENABLE_INSTANCING
	, in float tmID : TEXCOORD2
#endif
	, uniform int passNum
)
{
#ifdef ENABLE_SKINNING
#ifdef ENABLE_INSTANCING
	VS_OUT o = HeightShaderCommon(InPos, weights, indices, tmID);
#else
	VS_OUT o = HeightShaderCommon(InPos, weights, indices);
#endif
#else
#ifdef ENABLE_INSTANCING
	VS_OUT o = HeightShaderCommon(InPos, tmID);
#else
	VS_OUT o = HeightShaderCommon(InPos);
#endif
#endif

	switch (passNum)
	{
	case 0:
		o.Pos.x -= 0.02f;
		break;
	case 1:
		o.Pos.x += 0.02f;
		break;
	case 2:
		o.Pos.y -= 0.02f;
		break;
	case 3:
		o.Pos.y += 0.02f;
		break;
	}
	o.outDepth.w = o.Pos.z;
	return o;
}

VS_OUT VS_ModelShader(in float4 InPos : POSITION, in float4 InNml : NORMAL, in float4 Tex : TEXCOORD0, in float4 Tex1 : TEXCOORD1
#ifdef ENABLE_SKINNING
	, in float4 weights : BLENDWEIGHT, in float4 indices : BLENDINDICES
#endif
#ifdef ENABLE_INSTANCING
	, in float tmID : TEXCOORD2
#endif
	, uniform const bool isSnapShot
)
{
	VS_OUT o = (VS_OUT)0.f;

	//Position
	float4 localPos = 0.f;
	float3 localNml = 0.f;

#ifdef ENABLE_INSTANCING
	int instanceID = (int)(tmID + 1e-5f);
	int matrixID = g_InstanceID[instanceID].x;

	o.worldz_tmIndex_fog.y = instanceID;
	float4x4 WorldTM = GetMatrixInstance(matrixID, VTF_MATRIX_WORLD);
	float4x4 WorldViewTM = mul(WorldTM, g_ViewTM);
#else
	float4x4 WorldTM = g_WorldTM;
	float4x4 WorldViewTM = g_WorldViewTM;
#endif

#ifdef ENABLE_SKINNING
	int boneIDIndex = g_boneTexID;
#ifdef ENABLE_INSTANCING
	boneIDIndex = g_InstanceID[instanceID].y;
#endif

	float4 indices2 = D3DCOLORtoUBYTE4(indices);
	for (int i = 0; i < 4; ++i)
	{
		float4x4 boneTM = GetSkinMatrix(indices2[i] + boneIDIndex);
		localPos += mul(InPos, boneTM) * weights[i];
		localNml += mul(InNml.xyz, (float3x3)boneTM) * weights[i];
	}
	localPos.w = 1.f;
#else
	localPos = InPos;
	localNml = InNml.xyz;
	localPos.w = 1.f;
#endif

	float4 worldPos = mul(localPos, WorldTM);
	float3 worldNml = mul(localNml, (float3x3)WorldTM);

	// 캐릭터 2D로 찍기
#ifdef ENABLE_INSTANCING
	o.Pos = CalcWVP(worldPos, instanceID, matrixID, o.posWV);
#else
	o.Pos = CalcWVP(worldPos, o.posWV);
#endif

#ifdef ENABLE_CHARACTER_RENDER
#ifdef ENABLE_INSTANCING
	float4x4 worldAngleTM = mul(WorldTM, g_AngleMatrix);
	o.worldz_tmIndex_fog.x = mul(localPos + float4(0.f, -25.5f, 0.f, 0.f), worldAngleTM).z * 0.1f;
#else
	o.worldz_tmIndex_fog.x = mul(localPos + float4(0.f, -25.5f, 0.f, 0.f), g_TestMatrix).z * 0.1f;
#endif

#ifdef ENABLE_FACE
	if (isSnapShot == true)
	{
		o.Pos.z += 0.0001f;
	}
#endif
#endif

#ifdef ENABLE_FREEZE
	float4 zeroPos = float4(0.f, 0.f, 0.f, 1.f);
	zeroPos = mul(zeroPos, WorldTM);

	o.worldPos.xyz = worldPos.xyz - zeroPos.xyz;
#else
	o.worldPos.xyz = worldPos.xyz;
#endif 

	//Diffuse
#ifdef ENABLE_DIFFUSETEX
	CalcDiffuseTexCoord(Tex.xy, o.diffuseTexCoord);
#endif

	o.worldPos.w = 0.f;

#ifdef ENABLE_GRASS
	float worldY = -(worldPos.y + mapBottom) / (mapTop - mapBottom);
	float2 texPos = worldPos.xz;
	texPos.x += mapOffsetX;
	texPos.y += mapOffsetY;
	texPos.xy /= mapSize;
	texPos.y *= -1.f;
	texPos.xy += 1.f;
	texPos.xy *= 0.5f;
	float bgDepth = tex2Dlod(heightTex, float4(texPos, 0.f, 1.f)).y;

	float delta = (bgDepth - worldY) / 10.f;
	// 0.0001f 는 수치를 바꿔가면서 찾은 delta 최대치의 매직넘버
	// 0.0005f 이상부터 모델이 흔들리는 정도가 심해지기 시작함
	if (delta > 0.0001f)
	{
		delta = 0.0001f;
	}

	float attack = 0.f;
	float tFactor = 0.0;
	[unroll]
	for (int i = 0; i < 10; ++i)
	{
		float attackChk = step(length(g_grassAttack[i].xz - worldPos.xz), g_grassAttack[i].w);
		tFactor = g_grassAttackTFactor[i] * attackChk;
		attack = attackChk + attack;
	}

	float calcGrassTime = g_grassTime;
	float calcWindPower = g_windPower;

	float stepChk = step(0.5f, attack);

	o.Pos.y += delta * 60000.f * stepChk;
	calcGrassTime = 7.f * stepChk + calcGrassTime * (1.f - stepChk);
	calcWindPower = 600.f * stepChk + calcWindPower * (1.f - stepChk);
	o.worldPos.w = stepChk;

	delta = saturate(delta) * calcWindPower * 10.f;
	delta = sin((g_timeStamp + tFactor) * calcGrassTime + g_grassTimeoffset + worldPos.x * 0.1 - worldPos.z * 0.1) * delta + g_windDir * delta;

	o.Pos.x += delta;
	o.Pos.y -= delta * delta * 0.05f;
#endif

	//Env
#ifdef ENABLE_ENVTEX
	float4 worldViewPos = normalize(mul(float4(localPos.xyz, 1.f), WorldViewTM));

	float3 worldViewNml = normalize(mul(localNml, (float3x3)WorldViewTM));
	o.envTexCoord.xy = reflect(worldViewPos.xyz, worldViewNml);
#endif

#ifdef ENABLE_STATICSHADOWTEX
	o.shadowCoord.xy = Tex1.xy;
#endif

	float fogValue = Fog_CalcFogValue(o.Pos.w);
	o.worldz_tmIndex_fog.z = saturate(fogValue);
#ifdef ENABLE_CHARACTER_RENDER
	float charPosInView = mul(float4(g_MidPos, 1.f), g_depthDistTM).z;
	float vertexPosInView = mul(localPos, g_depthDistTM).z;
	o.outDepth.x = charPosInView;
	o.outDepth.y = vertexPosInView;
	o.outDepth.w = 1.f;

	o.viewVec = g_InvViewTM[3].xyz - worldPos.xyz;
	o.worldNml.xyz = worldNml;
#ifdef ENABLE_DIFFUSETEX
	// 얼굴 그리는 부분
#ifdef ENABLE_FACE
#ifdef ENABLE_INSTANCING
	float4 faceXYMulAdd = g_InstanceVecArray[g_InstanceCount * 6 + instanceID];
#else
	float4 faceXYMulAdd = g_faceXYMulAdd;
#endif
	o.diffuseTexCoord.x = faceXYMulAdd.x * o.diffuseTexCoord.x + faceXYMulAdd.z;
	o.diffuseTexCoord.y = faceXYMulAdd.y * o.diffuseTexCoord.y + faceXYMulAdd.w;
#endif
#endif
#endif

	o.outDepth.w = o.Pos.z;

#ifdef ENABLE_WATER
	o.outDepth = o.Pos;
	o.viewVec = g_InvViewTM[1].xyz;
	o.worldNml.xyz = worldNml;
#endif
	return o;
}

#ifdef ENABLE_DEPTH_RENDER
float4 PS_DepthRender(VS_OUT In) : COLOR
{
	float4 Out = 0.f;

	Out.rgb = In.outDepth.w;
	float alpha = 0.f;
#ifdef ENABLE_DIFFUSETEX
	float4 diffTexColor = tex2D(diffuseTex, In.diffuseTexCoord.xy);
	alpha = diffTexColor.a;
#endif

	Out.a = alpha;
	Out.r = (In.outDepth.w) * 0.0002;
	Out.g = length(In.posWV.xyz) * 0.0002;
	Out.b = (In.worldPos.y + 300) * 0.001;
	return Out;
}
#else

float4 PS_WaterRender(VS_OUT In) : COLOR
{
	float4 Out = 0.f;

	In.outDepth.x /= In.outDepth.w;
	In.outDepth.y /= In.outDepth.w;

	float2 scrTexOut;
	scrTexOut.x = (In.outDepth.x + 1.f) * 0.5f;
	scrTexOut.y = (2.f - (In.outDepth.y + 1.f)) * 0.5f;

	// 스크린 오프셋 (매직넘버)
	scrTexOut.x += 0.0005f;
	scrTexOut.y += 0.0006f;

	Out.rgba = 0.f;
#ifdef ENABLE_WATER
#ifdef ENABLE_DIFFUSETEX	
	// sway
	float dt = sin(g_timeStamp* waterSwaySpeed + In.worldPos.xz * waterSwayRange.xy)* waterSwayPower;
	In.diffuseTexCoord.xy += normalize(waterSwayRange) * dt;

	// speed
	In.diffuseTexCoord.xy += g_timeStamp * waterDiffDir;
	float4 oriTexColor = tex2D(diffuseTex, In.diffuseTexCoord.xy);
	Out.rgba = oriTexColor.rgba;
#endif

#ifdef ENABLE_STATICSHADOWTEX
	float4 shadowColor = tex2D(staticShadowTex, In.shadowCoord.xy);
	Out.rgb *= shadowColor.rgb * 2.f * g_lightColor.rgb * pow(max(g_lightColor.w, 0.01f), 1.5f);
#endif

#ifdef ENABLE_ENVTEX
	float4 envColor = tex2D(envTex, In.envTexCoord.xy);
#endif
	// refraction
	float2 uv = In.worldPos.xz * refractionNormalSize;
	uv += g_timeStamp * refractionDir;
	float4 normal = tex2D(normalTex, uv) - 0.5f;

	Out.rgb = tex2D(screenTex, scrTexOut.xy + normal.xy * refractionPower) * (1.f - Out.a) + Out.rgb * Out.a;
	Out.a = 1.f;

	// spary
	uv = In.worldPos.xz * waterSprayNormalSize;
	uv += g_timeStamp * waterSprayDir;
	normal = tex2D(normalTex, uv) - 0.5f;

	scrTexOut.xy += normal.xy * waterSprayPower;

	float edge1 = In.worldPos.y - tex2D(depthTex, scrTexOut.xy).b * 1000.f + 300.f;
	edge1 *= waterSparyRange;

	edge1 = step(edge1, 1.f) * edge1;
	edge1 = step(0.f, edge1) * edge1;
	edge1 = 1 - edge1 - step(1.f, 1.f - edge1);
	Out.rgb += edge1 * edge1 * waterSprayColor;

	if (g_FogColor.w > 0)
	{
		Out.rgb = lerp(g_FogColor.rgb, Out.rgb, 1.f - ((1.f - In.worldz_tmIndex_fog.z) * 0.3f));
	}

	Out.rgb *= g_lightColor.rgb * g_lightColor.w;

	saturate(Out.rgb);
#endif
	return Out;
}

float3 RGBToHSL(float3 RGB)
{
	float3 HSL = 0.f;
	float U = -min(RGB.r, min(RGB.g, RGB.b));
	float V = max(RGB.r, max(RGB.g, RGB.b));
	HSL.z = (V - U) * 0.5;
	float C = V + U;
	if (C != 0)
	{
		float3 Delta = (V - RGB) / C;
		Delta.rgb -= Delta.brg;
		Delta.rgb += float3(2, 4, 6);
		Delta.brg = step(V, RGB) * Delta.brg;
		HSL.x = max(Delta.r, max(Delta.g, Delta.b));
		HSL.x = frac(HSL.x / 6);
		HSL.y = C / (1 - abs(2 * HSL.z - 1));
	}
	return HSL;
}

float3 Hue(float H)
{
	float R = abs(H * 6 - 3) - 1;
	float G = 2 - abs(H * 6 - 2);
	float B = 2 - abs(H * 6 - 4);
	return saturate(float3(R, G, B));
}

float3 HSLToRGB(float3 HSL)
{
	float3 RGB = Hue(HSL.x);
	float C = (1 - abs(2 * HSL.z - 1)) * HSL.y;
	return (RGB - 0.5) * C + HSL.z;
}

float3 hueadj(float3 color, float hue)
{
	hue /= 100;

	float3 rethsl = RGBToHSL(color); //convert to HSL
	float3 hueColor = hue*(1 - color);
	rethsl.x -= hueColor.x; //Shift Hue
	rethsl.y += hueColor.y; //increase saturation
	rethsl.z -= hueColor.z; //decrease lightness, not too sure if this is all correct, with the multiplication following this...

	float3 result = HSLToRGB(rethsl);
	return result;
}

float3 saturationAdj(float3 diffuse, float saturation)
{
	float3 Out = 0.f;
	saturation /= 100;
	saturation += 1;
	float R = 0.3;
	float G = 0.59;
	float B = 0.11;
	float UIConst_7513 = 1.0;
	float DivideByOne = (((diffuse.x * R) + (diffuse.y * G)) + (diffuse.z * B)) / UIConst_7513;
	float3 OutGrey = float3(DivideByOne, DivideByOne, DivideByOne);
	Out = float3(lerp(OutGrey, diffuse.xyz, saturation));
	return Out;
}

float3 brightcontrast(float3 diffuse, float bright, float contrast)
{
	bright /= 100;
	contrast /= 100;
	contrast += 1;
	if (contrast != 1 || bright != 0)
	{
		float3 result = (diffuse - 0.5) * contrast + 0.5 + bright;
		return result;
	}
	return diffuse;
}

float3 adjust(float3 diffuse, float4 colorValue)
{
	float3 result = diffuse;
	result = hueadj(result, colorValue.z);
	result = saturationAdj(result, colorValue.w);
	result = brightcontrast(result, colorValue.x, colorValue.y);
	return result;
}

float GetLuminance(float3 sourceColor)
{
	float luminance = saturate(dot(sourceColor, float3(0.2125f, 0.7154f, 0.0721f)));
	return luminance;
}

OUT_COLOR PS_TEST(VS_OUT In)
{
	float4 Out = 0.f;
	float4 diffTexColor = 0.f;
#ifdef ENABLE_DIFFUSETEX
	diffTexColor = tex2D(diffuseTex, In.diffuseTexCoord.xy);
#endif
	Out = diffTexColor;

#ifdef ENABLE_STATICSHADOWTEX
	float4 shadowColor = tex2D(staticShadowTex, In.shadowCoord.xy);
	Out.rgb *= shadowColor.rgb * 2.f * g_lightColor.rgb * pow(max(g_lightColor.w, 0.01f), 1.5f);
#else
	Out.rgb *= g_lightColor.rgb * g_lightColor.w;
#endif

#ifdef ENABLE_INSTANCING
	int instanceID = In.worldz_tmIndex_fog.y;

	float4 blendColor = g_InstanceVecArray[g_InstanceCount + instanceID];
#else
	float4 blendColor = g_BlendColor;
#endif

	Out.rgb *= blendColor.rgb * 2.f;
	Out.a *= blendColor.a;

	if (g_FogColor.w > 0)
	{
		Out.rgb = lerp(g_FogColor.rgb, Out.rgb, In.worldz_tmIndex_fog.z);
	}

	Out.a *= g_AlphaBlending;

	OUT_COLOR color = (OUT_COLOR)0;
	color.albedo = Out;
	color.depth = CalcDepth(In.outDepth.w, In.worldPos.y, In.posWV);
	return color;
}

OUT_COLOR PS_CharacterShader(VS_OUT In, uniform const bool isLowQuality)
{
#ifdef ENABLE_INSTANCING
	int instanceID = (int)(In.worldz_tmIndex_fog.y + 1e-5f);
#endif

	float4 diffTexColor = 1.f;
	float alpha = 0.f;

#ifdef ENABLE_DIFFUSETEX
	diffTexColor = tex2D(diffuseTex, In.diffuseTexCoord.xy);
	if (isLowQuality == true && diffTexColor.a > (48.f / 255.f))
	{
		alpha = max(254.f / 255.f, diffTexColor.a);
	}
	else
	{
		alpha = diffTexColor.a;
	}

#endif

#ifdef ENABLE_SKIN_MASK_TEX
	float skinMask = tex2D(diffuseTex_skinMask, In.diffuseTexCoord.xy).r;
	if (skinMask > 0.f)
	{
#ifdef ENABLE_INSTANCING
		float4 skinBlendColor = g_InstanceVecArray[g_InstanceCount * 5 + instanceID];
#else
		float4 skinBlendColor = g_SkinBlendColor;
#endif

		const float4 pivotColor = float4(0.5f, 0.5f, 0.5f, 0.f);
		skinBlendColor = ((skinBlendColor - pivotColor) * skinMask) + 0.5f;

		diffTexColor = diffTexColor * skinBlendColor * 2.f;
	}
#endif

	float4 OutColor = 1.f;
	float falloff = 0.f;

#ifdef ENABLE_CHARACTER_RENDER
	float3 normalizeNormal = normalize(In.worldNml.xyz);

	float distValue = In.outDepth.r - In.outDepth.g;
	falloff = fall_off(normalizeNormal, In.viewVec);
	float outlinevalue = smoothstep(0.f, 0.38f, falloff);
	float3 farColor = adjust(diffTexColor.rgb, g_farValue);
	float3 nearColor = diffTexColor.xyz;

	OutColor.rgb = lerp(farColor, nearColor, saturate(In.worldz_tmIndex_fog.x * g_depthDistanceValue));
	float3 outlineColor = adjust(OutColor.rgb, g_outLineValue);
	OutColor.rgb = lerp(outlineColor, OutColor.rgb, outlinevalue);
	OutColor.rgb = saturate(OutColor.rgb);

	OutColor.a = alpha;
#endif

	float4 Out = 0.f;
	Out.rgb = OutColor.rgb;
	Out.a = alpha;

#ifdef ENABLE_INSTANCING
	float4 blendColor = g_InstanceVecArray[g_InstanceCount + instanceID];
	float4 blendColorAdd = g_InstanceVecArray[g_InstanceCount * 2 + instanceID];
#else
	float4 blendColor = g_BlendColor;
	float4 blendColorAdd = g_BlendColorAdd;
#endif

	Out.rgb *= blendColor.rgb * 2.f;
	Out.rgb += blendColorAdd.rgb;

#ifdef ENABLE_CHARACTER_RENDER
	if (isLowQuality == false)
	{
		Out.a *= blendColor.a;
	}
#endif

	Out = saturate(Out);

#ifdef ENABLE_FREEZE
	Out = freeze(Out, In.diffuseTexCoord.xy, falloff);
#endif
	if (g_FogColor.w > 0)
	{
		Out.rgb = lerp(g_FogColor.rgb, Out.rgb, 1 - ((1 - In.worldz_tmIndex_fog.z) * 0.3f));
	}

	Out.rgb *= g_lightColor.rgb * g_lightColor.w;

#ifdef ENABLE_DIFFUSETEX_ANIMATION
	if (g_DiffuseAnimationTM._24 > 0.f)
	{
		float4 mask = tex2D(uvAnimMaskTex, In.diffuseTexCoord.zw);
		Out.a *= mask.r;
	}
#endif

	OUT_COLOR color = (OUT_COLOR)0;
	color.albedo = Out;
	color.depth = CalcDepth(In.outDepth.w, In.worldPos.y, In.posWV);
	color.depth.a = alpha;
	return color;
}

float4 PS_CharacterShaderOption(VS_OUT In, uniform const int optionType) : COLOR
{
	float4 diffTexColor = 1.f;
	float alpha = 0.f;
	float3 envtex = float3(1.f, 0.f, 0.f);
#ifdef ENABLE_DIFFUSETEX
	diffTexColor = tex2D(diffuseTex, In.diffuseTexCoord.xy);
	alpha = diffTexColor.a;
#endif

#ifdef ENABLE_INSTANCING
	int instanceID = (int)(In.worldz_tmIndex_fog.y + 1e-5f);
#endif

#ifdef ENABLE_SKIN_MASK_TEX
	float skinMask = tex2D(diffuseTex_skinMask, In.diffuseTexCoord.xy).r;
	if (skinMask > 0.f)
	{
#ifdef ENABLE_INSTANCING
		float4 skinBlendColor = g_InstanceVecArray[g_InstanceCount * 5 + instanceID];
#else
		float4 skinBlendColor = g_SkinBlendColor;
#endif

		const float4 pivotColor = float4(0.5f, 0.5f, 0.5f, 0.f);
		skinBlendColor = ((skinBlendColor - pivotColor) * skinMask) + 0.5f;

		diffTexColor = diffTexColor * skinBlendColor * 2.f;
	}
#endif

#ifdef ENABLE_ENVTEX 
	envtex = tex2D(envTex, In.diffuseTexCoord.xy).rgb;
#endif

	float4 OutColor = 1.f;
	float falloff = 0.f;
	float distValue = 0.f;
#ifdef ENABLE_CHARACTER_RENDER
	float3 normalizeNormal = normalize(In.worldNml.xyz);

	distValue = In.outDepth.r - In.outDepth.g;

	float specularmask = envtex.r;
	float glossiness = saturate(0.78f + (envtex.b * 0.2f)) - 0.03f;
	falloff = fall_off(normalizeNormal, In.viewVec);
	float falloffValue = smoothstep(glossiness, 0.98f, falloff);
	float outlinevalue = smoothstep(0.f, 0.38f, falloff);
	falloffValue *= specularmask;

	OutColor.rgb = lerp(float3(1.f, 1.f, 1.f), OutColor.rgb, outlinevalue);
	OutColor = diffTexColor;
	OutColor.rgb = saturate(OutColor.rgb);
	OutColor.a = alpha;
#endif

#ifdef ENABLE_INSTANCING
	float4 blendColor = g_InstanceVecArray[g_InstanceCount + instanceID];
#else
	float4 blendColor = g_BlendColor;
#endif

	OutColor.rgb *= blendColor.rgb * 2.f;
	OutColor = saturate(OutColor);
	OutColor *= 0.5f;
	OutColor.a = alpha;

#ifdef ENABLE_CHARACTER_RENDER
	OutColor.a *= blendColor.a;
#endif

#ifdef ENABLE_FREEZE
	OutColor = freeze(OutColor, In.diffuseTexCoord.xy, falloff);
	OutColor.r *= 0.5f;
	OutColor.g *= 0.5f;
	OutColor.b *= 0.8f;
#endif

	if (optionType == OPTION_TYPE_OUTLINE || optionType == OPTION_TYPE_HEAD_OUTLINE)
	{
		OutColor.rgb = g_outLineColor.rgb;
	}

#ifdef ENABLE_DIFFUSETEX_ANIMATION
	if (optionType == 0 && g_DiffuseAnimationTM._24 > 0.f)
	{
		float4 mask = tex2D(uvAnimMaskTex, In.diffuseTexCoord.zw);
		OutColor.a *= mask.r;
	}
#endif

	OutColor.rgb *= g_lightColor.rgb * g_lightColor.w;

	return OutColor;
}

OUT_COLOR PS_BillBoardHead(VS_OUT In, uniform const bool isLowQuality)
{
#ifdef ENABLE_INSTANCING
	int instanceID = (int)(In.worldz_tmIndex_fog.y + 1e-5f);
#endif

	float4 diffTexColor = 0.f;
	float alpha = 0.f;
#ifdef ENABLE_DIFFUSETEX
	diffTexColor = tex2D(diffuseTex, In.diffuseTexCoord.xy);

#ifdef ENABLE_SKIN_MASK_TEX
	float skinMask = tex2D(diffuseTex_skinMask, In.diffuseTexCoord.xy).r;
	if (skinMask > 0.f)
	{
#ifdef ENABLE_INSTANCING
		float4 skinBlendColor = g_InstanceVecArray[g_InstanceCount * 5 + instanceID];
#else
		float4 skinBlendColor = g_SkinBlendColor;
#endif

		const float4 pivotColor = float4(0.5f, 0.5f, 0.5f, 0.f);
		skinBlendColor = ((skinBlendColor - pivotColor) * skinMask) + 0.5f;

		diffTexColor = diffTexColor * skinBlendColor * 2.f;
	}

#endif

	if (isLowQuality == true)
	{
		alpha = max(48.f / 255.f, diffTexColor.a);
	}
	else
	{
		alpha = diffTexColor.a;
	}
#endif

	float4 Out = diffTexColor;

#ifdef ENABLE_CHARACTER_RENDER
	float3 normalizeNormal = normalize(In.worldNml.xyz);

	float distValue = In.outDepth.r - In.outDepth.g;
	float falloff = fall_off(normalizeNormal, In.viewVec);
	float outlinevalue = smoothstep(0.f, 0.38f, falloff);
	float3 farColor = adjust(diffTexColor.rgb, g_farValue);
	float3 nearColor = diffTexColor.xyz;

	Out.rgb = lerp(farColor, nearColor, saturate(In.worldz_tmIndex_fog.x * g_depthDistanceValue));
	float3 outlineColor = adjust(Out.rgb, g_outLineValue);
	Out.rgb = lerp(outlineColor, Out.rgb, outlinevalue);
	Out.rgb = saturate(Out.rgb);

	Out.a = alpha;
#endif

#ifdef ENABLE_CHARACTER_RENDER
#ifdef ENABLE_INSTANCING
	int tmIndex = (int)(In.worldz_tmIndex_fog.y + 1e-5f);
	float4 blendColor = g_InstanceVecArray[g_InstanceCount + tmIndex];
	float4 blendColorAdd = g_InstanceVecArray[g_InstanceCount * 2 + tmIndex];
#else
	float4 blendColor = g_BlendColor;
	float4 blendColorAdd = g_BlendColorAdd;
#endif

	if (isLowQuality == false)
	{
		Out.a *= blendColor.a;
	}

	Out.rgb *= blendColor.rgb * 2.f;
	Out.rgb += blendColorAdd.rgb;
	Out = saturate(Out);
#endif

#ifdef ENABLE_FREEZE
	Out = freezeHead(Out, 1.f);
#endif

	if (g_FogColor.w > 0)
	{
		Out.rgb = lerp(g_FogColor.rgb, Out.rgb, 1 - ((1 - In.worldz_tmIndex_fog.z) * 0.3f));
	}

	Out.rgb *= g_lightColor.rgb * g_lightColor.w;

	OUT_COLOR color = (OUT_COLOR)0;

	color.albedo = Out;
	color.depth = CalcDepth(In.outDepth.w, In.worldPos.y, In.posWV);
	color.depth.a = alpha;
	return color;
}

float4 PS_Silhouette(VS_OUT In) : COLOR
{
	float2 scrTexOut = 0.f;
	scrTexOut.x = (In.outDepth.x + 1.f) * 0.5f;
	scrTexOut.y = (2.f - (In.outDepth.y + 1.f)) * 0.5f;
	// 스크린 오프셋 (매직넘버)
	scrTexOut.x += 0.0005f;
	scrTexOut.y += 0.0006f;
	float3 screenTexColor = tex2D(screenTex, scrTexOut.xy).rgb;

	float4 color = float4(0.f, 0.f, 0.f, 1.f);
	color.rgb = 1.f - GetLuminance(screenTexColor);
	return color;
}

float4 PS_SilhouetteHead(VS_OUT In) : COLOR
{
	float alpha = 1.f;
	#ifdef ENABLE_DIFFUSETEX
	alpha = tex2D(diffuseTex, In.diffuseTexCoord.xy).a;
	#endif

	float2 scrTexOut;
	scrTexOut.x = (In.outDepth.x + 1.f) * 0.5f;
	scrTexOut.y = (2.f - (In.outDepth.y + 1.f)) * 0.5f;
	// 스크린 오프셋 (매직넘버)
	scrTexOut.x += 0.0005f;
	scrTexOut.y += 0.0006f;
	float3 screenTexColor = tex2D(screenTex, scrTexOut.xy).rgb;

	float4 color = float4(0.f, 0.f, 0.f, 1.f);
	color.rgb = 1.f - GetLuminance(screenTexColor);
	color.a = alpha;
	return color;
}

float4 PS_CharacterAuraShader(VS_OUT_AURA In) : COLOR
{
#ifdef ENABLE_INSTANCING
	int tmIndex = (int)(In.tmIndex + 1e-5f);
float4 color = g_InstanceVecArray[g_InstanceCount * 3 + tmIndex];
#else
	float4 color = g_auraColor;
#endif

	color.a *= 0.02f;

	return color;
}

float4 PS_HeightRender(VS_OUT In) : COLOR
{
	float4 Out = 0.f;

	Out.rgb = In.outDepth.w;
	float alpha = 1.f;
#ifdef ENABLE_DIFFUSETEX
	float4 diffTexColor = tex2D(diffuseTex, In.diffuseTexCoord.xy);
	alpha = diffTexColor.a;
#endif
	Out.a = alpha;
	return Out;
}

float4 PS_OutLineColorShader(VS_OUT In) : COLOR
{
	return float4(g_outLineColor.rgb, 1.f);
}

#endif

#ifdef ENABLE_DEPTH_RENDER
technique DepthRenderTq
{
	pass P0
	{
		CullMode = none;
		AlphaTestEnable = true;
		AlphaRef = 0x10;
		AlphaBlendEnable = false;
		VertexShader = compile vs_3_0 VS_ModelShader(false);
		PixelShader = compile ps_3_0 PS_DepthRender();
	}
}
#else
technique DefaultVertexTq
{
	pass P0
	{
		CullMode = ccw;

		VertexShader = compile vs_3_0 VS_ModelShader(false);
		PixelShader = compile ps_3_0 PS_TEST();
	}
}

technique DefaultVertexAlphaTq
{
	pass P0
	{
		AlphaTestEnable = true;
		AlphaRef = 0xfd;
		AlphaFunc = Greater;
		CullMode = none;
		AlphaBlendEnable = false;
		ZEnable = true;
		ZFunc = LessEqual;
		ZWriteEnable = true;
		VertexShader = compile vs_3_0 VS_ModelShader(false);
		PixelShader = compile ps_3_0 PS_TEST();
	}

	pass P1
	{
		AlphaTestEnable = true;
		AlphaRef = 0x01;
		AlphaFunc = Greater;
		CullMode = none;
		AlphaBlendEnable = true;
		ZEnable = true;
		ZFunc = LessEqual;
		ZWriteEnable = true;
		VertexShader = compile vs_3_0 VS_ModelShader(false);
		PixelShader = compile ps_3_0 PS_TEST();
	}
}

#ifdef ENABLE_CHARACTER_RENDER

float4 PS_White(VS_OUT In) : COLOR
{
	float4 diffTexColor = 1.f;
#ifdef ENABLE_DIFFUSETEX
	diffTexColor = tex2D(diffuseTex, In.diffuseTexCoord.xy);
#endif

	diffTexColor.rgb = 1.0f;

	float2 scrTexOut;
	scrTexOut.x = (In.outDepth.x + 1.0f) / 2;
	scrTexOut.y = (2.0f - (In.outDepth.y + 1.0f)) / 2;

	scrTexOut.x += 0.0005f;
	scrTexOut.y += 0.0006f;
	diffTexColor.a = 0.3;
	diffTexColor.rgb = tex2D(screenTex, scrTexOut.xy).rgb * (1 - diffTexColor.a) + diffTexColor.rgb * diffTexColor.a;
	diffTexColor.a = 1.0;

	return diffTexColor;
}

float4 PS_Black(VS_OUT In) : COLOR
{
	float4 diffTexColor = 0;

#ifdef ENABLE_DIFFUSETEX
	diffTexColor = tex2D(diffuseTex, In.diffuseTexCoord);
#endif

	diffTexColor.rgb = 0.0f;

	float2 scrTexOut;
	scrTexOut.x = (In.outDepth.x + 1.0f) / 2;
	scrTexOut.y = (2.0f - (In.outDepth.y + 1.0f)) / 2;

	scrTexOut.x += 0.0005f;
	scrTexOut.y += 0.0006f;
	diffTexColor.a = 0.5;
	diffTexColor.rgb = tex2D(screenTex, scrTexOut.xy)*(1 - diffTexColor.a) + diffTexColor.rgb * diffTexColor.a;
	diffTexColor.a = 1.0;

	return diffTexColor;
}

float4 PS_WhiteHead(VS_OUT In) : COLOR
{
	float4 diffTexColor = 1.f;
#ifdef ENABLE_DIFFUSETEX
	diffTexColor = tex2D(diffuseTex, In.diffuseTexCoord.xy);
#endif

	diffTexColor.rgb = 1.0f;

	float2 scrTexOut;
	scrTexOut.x = (In.outDepth.x + 1.0f) / 2;
	scrTexOut.y = (2.0f - (In.outDepth.y + 1.0f)) / 2;

	scrTexOut.x += 0.0005f;
	scrTexOut.y += 0.0006f;
	float alpha = diffTexColor.a;
	diffTexColor.a = 0.3;
	diffTexColor.rgb = tex2D(screenTex, scrTexOut.xy).rgb * (1 - diffTexColor.a) + diffTexColor.rgb * diffTexColor.a;
	diffTexColor.a = step(0.2, alpha);

	return diffTexColor;
}

float4 PS_BlackHead(VS_OUT In) : COLOR
{
	float4 diffTexColor = 0.f;

#ifdef ENABLE_DIFFUSETEX
	diffTexColor = tex2D(diffuseTex, In.diffuseTexCoord);
#endif

	diffTexColor.rgb = 0.0f;

	float2 scrTexOut;
	scrTexOut.x = (In.outDepth.x + 1.0f) / 2;
	scrTexOut.y = (2.0f - (In.outDepth.y + 1.0f)) / 2;

	scrTexOut.x += 0.0005f;
	scrTexOut.y += 0.0006f;
	float alpha = diffTexColor.a;
	diffTexColor.a = 0.5;
	diffTexColor.rgb = tex2D(screenTex, scrTexOut.xy).rgb * (1 - diffTexColor.a) + diffTexColor.rgb * diffTexColor.a;// *(1 - diffTexColor.a) + diffTexColor.rgb * diffTexColor.a;
	diffTexColor.a = step(0.2, alpha);

	return diffTexColor;
}

technique BehindCharacterShadingTq
{
	pass P0
	{
		AlphaTestEnable = true;
		AlphaRef = 0x30;
		AlphaFunc = Greater;
		CullMode = none;
		ZEnable = true;
		ZFunc = Greater;
		ZWriteEnable = false;
		AlphaBlendEnable = false;
		VertexShader = compile vs_3_0 VS_ModelOption(OPTION_TYPE_SILHOUETTE);
		PixelShader = compile ps_3_0 PS_Black();
	}
}

technique BehindCharacterShadingOutTq
{
	pass P0
	{
		AlphaTestEnable = true;
		AlphaRef = 0x30;
		AlphaFunc = Greater;
		CullMode = none;
		ZEnable = true;
		ZFunc = Greater;
		ZWriteEnable = false;
		AlphaBlendEnable = false;
		VertexShader = compile vs_3_0 VS_OutlineModelShader(OPTION_TYPE_SILHOUETTE, 0);
		PixelShader = compile ps_3_0 PS_White();
	}
	pass P1
	{
		AlphaTestEnable = true;
		AlphaRef = 0x30;
		AlphaFunc = Greater;
		CullMode = none;
		ZEnable = true;
		ZFunc = Greater;
		ZWriteEnable = false;
		VertexShader = compile vs_3_0 VS_OutlineModelShader(OPTION_TYPE_SILHOUETTE, 1);
		PixelShader = compile ps_3_0 PS_White();
	}
	pass P2
	{
		AlphaTestEnable = true;
		AlphaRef = 0x30;
		AlphaFunc = Greater;
		CullMode = none;
		ZEnable = true;
		ZFunc = Greater;
		ZWriteEnable = false;
		VertexShader = compile vs_3_0 VS_OutlineModelShader(OPTION_TYPE_SILHOUETTE, 2);
		PixelShader = compile ps_3_0 PS_White();
	}
	pass P3
	{
		AlphaTestEnable = true;
		AlphaRef = 0x30;
		AlphaFunc = Greater;
		CullMode = none;
		ZEnable = true;
		ZFunc = Greater;
		ZWriteEnable = false;
		VertexShader = compile vs_3_0 VS_OutlineModelShader(OPTION_TYPE_SILHOUETTE, 3);
		PixelShader = compile ps_3_0 PS_White();
	}
}

technique BehindBillboardHeadShadingTq
{
	pass P0
	{
		SRGBWRITEENABLE = FALSE;
		CullMode = none;
		AlphaTestEnable = true;
		AlphaRef = 0x30;
		AlphaFunc = Greater;
		ZFunc = Greater;
		ZWriteEnable = false;
		AlphaBlendEnable = false;
		VertexShader = compile vs_3_0 VS_ModelOption(OPTION_TYPE_SILHOUETTE);
		PixelShader = compile ps_3_0 PS_BlackHead();
	}
}

technique BehindBillboardHeadShadingOutTq
{
	pass P0
	{
		AlphaTestEnable = true;
		AlphaRef = 0x30;
		AlphaFunc = Greater;
		CullMode = none;
		ZEnable = true;
		ZFunc = Greater;
		ZWriteEnable = false;
		AlphaBlendEnable = false;
		VertexShader = compile vs_3_0 VS_OutlineModelShader(OPTION_TYPE_HEAD_OUTLINE, 0);
		PixelShader = compile ps_3_0 PS_WhiteHead();
	}
	pass P1
	{
		AlphaTestEnable = true;
		AlphaRef = 0x30;
		AlphaFunc = Greater;
		CullMode = none;
		ZEnable = true;
		ZFunc = Greater;
		ZWriteEnable = false;
		VertexShader = compile vs_3_0 VS_OutlineModelShader(OPTION_TYPE_HEAD_OUTLINE, 1);
		PixelShader = compile ps_3_0 PS_WhiteHead();
	}
	pass P2
	{
		AlphaTestEnable = true;
		AlphaRef = 0x30;
		AlphaFunc = Greater;
		CullMode = none;
		ZEnable = true;
		ZFunc = Greater;
		ZWriteEnable = false;
		VertexShader = compile vs_3_0 VS_OutlineModelShader(OPTION_TYPE_HEAD_OUTLINE, 2);
		PixelShader = compile ps_3_0 PS_WhiteHead();
	}
	pass P3
	{
		AlphaTestEnable = true;
		AlphaRef = 0x30;
		AlphaFunc = Greater;
		CullMode = none;
		ZEnable = true;
		ZFunc = Greater;
		ZWriteEnable = false;
		VertexShader = compile vs_3_0 VS_OutlineModelShader(OPTION_TYPE_HEAD_OUTLINE, 3);
		PixelShader = compile ps_3_0 PS_WhiteHead();
	}
}

technique CharacterShadingTq
{
	pass P0
	{
		AlphaTestEnable = true;
		AlphaRef = 0xfd;
		AlphaFunc = Greater;
		CullMode = ccw;
		AlphaBlendEnable = false;
		ZFunc = LessEqual;
		ZWriteEnable = true;
		VertexShader = compile vs_3_0 VS_ModelShader(false);
		PixelShader = compile ps_3_0 PS_CharacterShader(false);
	}

	pass P1
	{
		AlphaTestEnable = true;
		AlphaRef = 0x30;
		AlphaFunc = Greater;
		CullMode = ccw;
		AlphaBlendEnable = true;
		ZFunc = LessEqual;
		VertexShader = compile vs_3_0 VS_ModelShader(false);
		PixelShader = compile ps_3_0 PS_CharacterShader(false);
	}

	pass P2
	{
		AlphaTestEnable = true;
		AlphaRef = 0x30;
		AlphaFunc = Greater;
		CullMode = cw;
		AlphaBlendEnable = true;
		ZFunc = LessEqual;
		ZWriteEnable = false;
		VertexShader = compile vs_3_0 VS_ModelOption(OPTION_TYPE_OUTLINE);
		PixelShader = compile ps_3_0 PS_CharacterShaderOption(0);
	}
}

technique CharacterAuraShadingTq
{
	pass P0
	{
		CullMode = cw;
		AlphaBlendEnable = true;
		ZWriteEnable = false;
		VertexShader = compile vs_3_0 VS_ModelAuraShader();
		PixelShader = compile ps_3_0 PS_CharacterAuraShader();
	}
}

technique CharacterOutlineShadingTq
{
	pass P0
	{
		AlphaTestEnable = true;
		AlphaRef = 0xfd;
		AlphaFunc = Greater;
		CullMode = ccw;
		AlphaBlendEnable = false;
		ZFunc = LessEqual;
		ZWriteEnable = true;
		VertexShader = compile vs_3_0 VS_ModelShader(false);
		PixelShader = compile ps_3_0 PS_CharacterShader(false);
	}

	pass P1
	{
		AlphaTestEnable = true;
		AlphaRef = 0x30;
		AlphaFunc = Greater;
		CullMode = ccw;
		AlphaBlendEnable = true;
		ZFunc = LessEqual;
		VertexShader = compile vs_3_0 VS_ModelShader(false);
		PixelShader = compile ps_3_0 PS_CharacterShader(false);
	}

	pass P2
	{
		AlphaTestEnable = true;
		AlphaRef = 0x30;
		AlphaFunc = Greater;
		CullMode = cw;
		AlphaBlendEnable = true;
		ZFunc = LessEqual;
		ZWriteEnable = false;
		VertexShader = compile vs_3_0 VS_ModelOption(OPTION_TYPE_OUTLINE2);
		PixelShader = compile ps_3_0 PS_OutLineColorShader();
	}
}

technique CharacterShadingTq_LowQuality
{
	pass P0
	{
		AlphaTestEnable = true;
		AlphaRef = 0xfd;
		AlphaFunc = Greater;
		CullMode = ccw;
		AlphaBlendEnable = false;
		ZFunc = LessEqual;
		ZWriteEnable = true;
		VertexShader = compile vs_3_0 VS_ModelShader(false);
		PixelShader = compile ps_3_0 PS_CharacterShader(true);
	}
}

technique CharacterOutlineShadingTq_LowQuality
{
	pass P0
	{
		AlphaTestEnable = true;
		AlphaRef = 0xfd;
		AlphaFunc = Greater;
		CullMode = ccw;
		AlphaBlendEnable = false;
		ZFunc = LessEqual;
		ZWriteEnable = true;
		VertexShader = compile vs_3_0 VS_ModelShader(false);
		PixelShader = compile ps_3_0 PS_CharacterShader(true);
	}

	pass P2
	{
		AlphaTestEnable = true;
		AlphaRef = 0x30;
		AlphaFunc = Greater;
		CullMode = cw;
		AlphaBlendEnable = true;
		ZFunc = LessEqual;
		ZWriteEnable = false;
		VertexShader = compile vs_3_0 VS_ModelOption(OPTION_TYPE_OUTLINE2);
		PixelShader = compile ps_3_0 PS_CharacterShaderOption(OPTION_TYPE_OUTLINE);
	}
}

technique BillboardHeadTq
{
#ifdef ENABLE_FACE
	pass P0
	{
		SRGBWRITEENABLE = FALSE;
		CullMode = none;
		AlphaTestEnable = true;
		AlphaRef = 0x90;
		AlphaFunc = Greater;
		ZEnable = true;
		ZFunc = LessEqual;
		ZWriteEnable = true;
		VertexShader = compile vs_3_0 VS_ModelShader(false);
		PixelShader = compile ps_3_0 PS_BillBoardHead(false);
	}
#else
	pass P0
	{
		SRGBWRITEENABLE = FALSE;
		CullMode = none;
		AlphaTestEnable = true;
		AlphaRef = 0x90;
		AlphaFunc = Greater;
		ZEnable = true;
		ZFunc = LessEqual;
		ZWriteEnable = true;
		VertexShader = compile vs_3_0 VS_ModelShader(false);
		PixelShader = compile ps_3_0 PS_BillBoardHead(false);
	}

	pass P1
	{
		SRGBWRITEENABLE = FALSE;
		CullMode = none;
		AlphaTestEnable = true;
		AlphaRef = 0x30;
		AlphaFunc = Greater;
		ZEnable = true;
		ZFunc = LessEqual;
		ZWriteEnable = false;
		VertexShader = compile vs_3_0 VS_ModelShader(false);
		PixelShader = compile ps_3_0 PS_BillBoardHead(false);
	}
#endif
}

technique BillboardHeadTq_Low
{
	pass P0
	{
		SRGBWRITEENABLE = FALSE;
		CullMode = none;
		AlphaTestEnable = true;
		AlphaRef = 0x30;
		AlphaFunc = Greater;
		AlphaBlendEnable = false;
		ZEnable = true;
		ZFunc = LessEqual;
		ZWriteEnable = true;
		VertexShader = compile vs_3_0 VS_ModelShader(false);
		PixelShader = compile ps_3_0 PS_BillBoardHead(true);
	}
}

technique BillboardHeadSnapShotTq
{
	pass P0
	{
		SRGBWRITEENABLE = FALSE;
		CullMode = none;
		AlphaTestEnable = true;
		AlphaRef = 0x30;
		AlphaFunc = Greater;
		ZEnable = true;
		ZFunc = LessEqual;
		ZWriteEnable = true;
		VertexShader = compile vs_3_0 VS_ModelShader(true);
		PixelShader = compile ps_3_0 PS_BillBoardHead(false);
	}
}

technique BillboardHeadOutlineTq
{
	pass P0
	{
		SRGBWRITEENABLE = FALSE;
		CullMode = none;
		AlphaTestEnable = true;
		AlphaRef = 0x30;
		AlphaFunc = Greater;
		ZEnable = true;
		ZFunc = LessEqual;
		ZWriteEnable = true;
		VertexShader = compile vs_3_0 VS_OutlineModelShader(OPTION_TYPE_HEAD_OUTLINE, 0);
		PixelShader = compile ps_3_0 PS_CharacterShaderOption(OPTION_TYPE_HEAD_OUTLINE);
	}

	pass P1
	{
		SRGBWRITEENABLE = FALSE;
		CullMode = none;
		AlphaTestEnable = true;
		AlphaRef = 0x30;
		AlphaFunc = Greater;
		ZEnable = true;
		ZFunc = LessEqual;
		ZWriteEnable = true;
		VertexShader = compile vs_3_0 VS_OutlineModelShader(OPTION_TYPE_HEAD_OUTLINE, 1);
		PixelShader = compile ps_3_0 PS_CharacterShaderOption(OPTION_TYPE_HEAD_OUTLINE);
	}

	pass P2
	{
		SRGBWRITEENABLE = FALSE;
		CullMode = none;
		AlphaTestEnable = true;
		AlphaRef = 0x30;
		AlphaFunc = Greater;
		ZEnable = true;
		ZFunc = LessEqual;
		ZWriteEnable = true;
		VertexShader = compile vs_3_0 VS_OutlineModelShader(OPTION_TYPE_HEAD_OUTLINE, 2);
		PixelShader = compile ps_3_0 PS_CharacterShaderOption(OPTION_TYPE_HEAD_OUTLINE);
	}

	pass P3
	{
		SRGBWRITEENABLE = FALSE;
		CullMode = none;
		AlphaTestEnable = true;
		AlphaRef = 0x30;
		AlphaFunc = Greater;
		ZEnable = true;
		ZFunc = LessEqual;
		ZWriteEnable = true;
		VertexShader = compile vs_3_0 VS_OutlineModelShader(OPTION_TYPE_HEAD_OUTLINE, 3);
		PixelShader = compile ps_3_0 PS_CharacterShaderOption(OPTION_TYPE_HEAD_OUTLINE);
	}
}

technique BillboardHeadAddTq
{
	pass P0
	{
		SRGBWRITEENABLE = FALSE;
		CullMode = none;
		AlphaTestEnable = true;
		AlphaRef = 0x30;
		AlphaFunc = Greater;
		ZEnable = true;
		ZFunc = LessEqual;
		ZWriteEnable = true;
		VertexShader = compile vs_3_0 VS_ModelShader(false);
		PixelShader = compile ps_3_0 PS_BillBoardHead(false);
	}
}

technique BillboardHeadAddTq_Low
{
	pass P0
	{
		SRGBWRITEENABLE = FALSE;
		CullMode = none;
		AlphaTestEnable = true;
		AlphaRef = 0x30;
		AlphaFunc = Greater;
		AlphaBlendEnable = false;
		ZEnable = true;
		ZFunc = LessEqual;
		ZWriteEnable = true;
		VertexShader = compile vs_3_0 VS_ModelShader(false);
		PixelShader = compile ps_3_0 PS_BillBoardHead(false);
	}
}

#else
technique WaterRenderTq
{
	pass P0
	{
		Zenable = TRUE;
		VertexShader = compile vs_3_0 VS_ModelShader(false);
		PixelShader = compile ps_3_0 PS_WaterRender();
	}
}

technique HeightRenderTq
{
	pass P0
	{
		CullMode = none;
		AlphaTestEnable = true;
		AlphaRef = 0x10;
		AlphaBlendEnable = false;
		VertexShader = compile vs_3_0 VS_HeightShader(0);
		PixelShader = compile ps_3_0 PS_HeightRender();
	}

	pass P1
	{
		CullMode = none;
		AlphaTestEnable = true;
		AlphaRef = 0x10;
		AlphaBlendEnable = false;
		VertexShader = compile vs_3_0 VS_HeightShader(1);
		PixelShader = compile ps_3_0 PS_HeightRender();
	}

	pass P2
	{
		CullMode = none;
		AlphaTestEnable = true;
		AlphaRef = 0x10;
		AlphaBlendEnable = false;
		VertexShader = compile vs_3_0 VS_HeightShader(2);
		PixelShader = compile ps_3_0 PS_HeightRender();
	}

	pass P3
	{
		CullMode = none;
		AlphaTestEnable = true;
		AlphaRef = 0x10;
		AlphaBlendEnable = false;
		VertexShader = compile vs_3_0 VS_HeightShader(3);
		PixelShader = compile ps_3_0 PS_HeightRender();
	}
}
#endif
#endif

#endif