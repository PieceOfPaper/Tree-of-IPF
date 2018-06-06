#ifndef __MODELSHADER_FX__
#define __MODELSHADER_FX__

// ShaderRenderer.h 에 있는 MAX_INSTANCE_COUNT 값과 동일하게 유지해야함
#define MAX_INSTANCE_COUNT 10

float4x4 	g_ViewTM;
float4x4 	g_ProjTM;
float4x4	g_InvViewTM			:	INVVIEW_TM;
float4x4 	g_ViewProjTM		: 	VIEWPROJECTION_TM;

float4		g_outLineColor = float4(1.0f, 1.0f, 0.0f, 0.0f);

#ifdef ENABLE_FREEZE
float4		g_materialShaderColor = float4(0.8f, 1.0f, 1.6f, 1.0f);
float4		g_materialShaderHeadColor = float4(0.96f, 1.5f, 2.5f, 1.0f);
float		g_fallOffMultiplyValue = 0.2f;
float		g_materialShaderPowValue = 1.35f;
#endif

float		g_AlphaBlending;
float 		g_timeStamp = 0.0f;
float       g_Gamma = 0.0f;

#ifdef ENABLE_INSTANCING
int			g_InstanceCount;
// 0 : g_WorldTM
// 1 : g_billboardTM
// 2 : g_charProjTM * g_charViewTM
float4x4	g_InstanceTMArray[MAX_INSTANCE_COUNT * 3]				: INSTANCE_TMARRAY;
// 0 : g_pivotPoint
// 1 : g_BlendColor
// 2 : g_BlendColorAdd
// 3 : g_auraColor
// 4 : g_auraValues (x : factor, y : auraTime)
	#ifdef ENABLE_FACE
	// 5 : g_faceXYMulAdd
		float4		g_InstanceVecArray[MAX_INSTANCE_COUNT * 6];
	#else
		float4		g_InstanceVecArray[MAX_INSTANCE_COUNT * 5];
	#endif
#else
float4x4 	g_WorldTM      		: 	WORLD_TM;
float4x4 	g_WorldViewTM		: 	WORLDVIEW_TM;
float4x4 	g_WorldViewProjTM	: 	WORLDVIEWPROJECTION_TM;
float4x4 	g_PrevWorldTM 		: 	PREVWORLD_TM;
float4		g_BlendColor = float4(0.5f, 0.5f, 0.5f, 1.0f);
float4		g_BlendColorAdd = float4(0.0f, 0.0f, 0.0f, 0.0f);
float4		g_auraColor = float4(0.0f, 0.0f, 0.0f, 0.0f);
// x : factor, y : auraTime
float4		g_auraValues = float4(0.0f, 0.0f, 0.0f, 0.0f);

// 3d캐릭터 2d로 그리는거
float4x4 	g_billboardTM		: BILLBOARD_TM;
float4x4 	g_charViewProjTM	: CHARVIEWPROJ_TM;
float3		g_pivotPoint;

	// 표정 관련 정보
	#ifdef ENABLE_FACE
	float4 g_faceXYMulAdd = 0.0f;
	#endif
#endif

#ifdef ENABLE_CHARACTER_RENDER
float4x4	g_TestMatrix;		// 타는 문제 때문에 추가된 매트릭스
float4x4	g_AngleMatrix;

float3 		g_MidPos = float3(2000.0f, 2000.0f, 2000.0f);
float 		g_depthDistanceValue = 8;
float4x4 	g_depthDistTM;
float 		g_envValue = 1.0f;

//x = Brightness;
//y = contrast
//z = hue
//w = saturation
float4 		g_farValue = float4(-7.641f, 0.0f, 0.0f, -24.0f);
float4 		g_outLineValue = float4(-12.0f, -30.0f, 0.0f, -40.0f);

#endif

float2 encodeToRG(float v)
{
	float2 enc = float2(1.0f, 255.0f) * v;
	enc = frac(enc);
	enc.y -= (1.0f/255.0f);
	return enc;
}

#ifdef ENABLE_SKINNING
int g_boneTexID : BONE_TEX_ID;

texture VTF_Tex : SKIN_VTF_TEX;
sampler vtf_skin  = sampler_state {
	Texture = (VTF_Tex);
	AddressU = CLAMP;
	AddressV = CLAMP;
	SRGBTEXTURE = FALSE;
};

float4x4 GetSkinMatrix(int idx)
{
	const float TEX_WIDTH  = 512.0f;
	const float TEX_HEIGTH = 512.0f;
	float4 uvCol = float4(((float)((idx % 128) * 4) + 0.5f) / TEX_WIDTH, ((float)((idx / 128)) + 0.5f) / TEX_HEIGTH, 0.0f, 0);
	float4x4 mat;
	mat._11_21_31_41 = tex2Dlod(vtf_skin, uvCol),
	mat._12_22_32_42 = tex2Dlod(vtf_skin, uvCol + float4(1.0f / TEX_WIDTH, 0.0f, 0.0f, 0)),
	mat._13_23_33_43 = tex2Dlod(vtf_skin, uvCol + float4(2.0f / TEX_WIDTH, 0.0f, 0.0f, 0)),
	mat._14_24_34_44 = float4(0.0f, 0.0f, 0.0f, 1.0f);
	return mat;
}
#endif

#ifdef ENABLE_DIFFUSETEX_ANIMATION
float4x4	g_DiffuseAnimationTM	: DIFFUSEANITM;
#endif

float4	g_FogColor;
float4	g_FogDist	: FOG_DIST;
//g_FogDist
//x = fog Start
//y = fog End
//z = End - Start
//w = 사용하지 않음.
float Fog_CalcFogValue(in float viewRange)
{
	return (g_FogDist.y - viewRange) / (g_FogDist.z);
}

#ifdef ENABLE_DEPTH_MRT
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
	Out.b  = (worldPosY + 300) * 0.001;
	Out.a   = 1.0f;
	return Out;
}
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

float windPower = 200.0f;
float grassTime = 0;
float grassTimeoffset;
float windDir;

texture HeightTex;
sampler heightTex = sampler_state
{
	Texture = (HeightTex);
	AddressU = CLAMP;
	AddressV = CLAMP;
};
#endif

struct VS_OUT {
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
	float4 posWV : TEXCOORD10;
};

struct VS_OUT_AURA {
	float4 Pos : POSITION;
	float tmIndex : TEXCOORD0;
};

#ifdef ENABLE_INSTANCING
float4 CalcWVP(float4 Pos, float4x4 worldTM, float4x4 worldViewProjTM, int tmIndex, out float4 PosWV)
{
	Pos.w = 1.0f;

	// 캐릭터 2D 렌더링
	#ifdef ENABLE_2D
		float4 WorldPos = mul(Pos, worldTM);
		Pos = mul(WorldPos, g_InstanceTMArray[g_InstanceCount * 2 + tmIndex]);
		Pos /= Pos.w;
		Pos.z = 0.0f;	// 빌보드로 만듦
		Pos.y += 0.4f;  // 캐릭터 발 위치를 맞추기 위한 상수
		Pos = mul(Pos, g_InstanceTMArray[g_InstanceCount * 1 + tmIndex]);
		PosWV = mul(Pos, g_ViewTM);
		Pos = mul(Pos, g_ViewProjTM);
		// (Local Z - 카메라 거리 : Z값을 0 앞뒤로 맞추기 위함) * 적당히 납작하게 만들기 위한 상수 - 깊이 보정값

		float uprate = 1.1;
		float pivotOffset = 100;
		float4 pivotPoint = g_InstanceVecArray[tmIndex];
		float4 pivotMul = mul(float4(pivotPoint.x, (WorldPos.y - pivotPoint.y + pivotOffset) * uprate + pivotPoint.y - pivotOffset, pivotPoint.z, 1), g_ViewProjTM);
		float defz = pivotMul.z / pivotMul.w;
		Pos.z = defz * Pos.w;

		return Pos;
	#else
	PosWV = mul(Pos, worldTM);
	PosWV = mul(PosWV, g_ViewTM);
		return mul(Pos, worldViewProjTM);
	#endif
}
#else
float4 CalcWVP(float4 Pos, out float4 PosWV)
{
	Pos.w = 1.0f;

	// 캐릭터 2D 렌더링
	#ifdef ENABLE_2D
		// View TM, Proj TM 은 합쳐도 무방
		float4 WorldPos = mul(Pos, g_WorldTM);
		Pos = mul(WorldPos, g_charViewProjTM);
		Pos /= Pos.w;
		Pos.z = 0.0f;	// 빌보드로 만듦
		Pos.y += 0.4f;  // 캐릭터 발 위치ㄹ르 맞추기 위한 상수
		Pos = mul(Pos, g_billboardTM);
		PosWV = mul(Pos, g_ViewTM);
		Pos = mul(Pos, g_ViewProjTM);
		// (Local Z - 카메라 거리 : Z값을 0 앞뒤로 맞추기 위함) * 적당히 납작하게 만들기 위한 상수 - 깊이 보정값

		float uprate = 1.1;
		float pivotOffset = 100;
		float4 pivotMul = mul(float4(g_pivotPoint.x, (WorldPos.y - g_pivotPoint.y + pivotOffset) * uprate + g_pivotPoint.y - pivotOffset, g_pivotPoint.z, 1), g_ViewProjTM);
		float defz = pivotMul.z / pivotMul.w;
		Pos.z = defz * Pos.w;

		return Pos;
	#else
	PosWV = mul(Pos, g_WorldTM);
	PosWV = mul(PosWV, g_ViewTM);
		return mul(Pos, g_WorldViewProjTM);
	#endif
}
#endif

#ifdef ENABLE_INSTANCING
float4 CalcWVPSilhouette(float3 Pos, int tmIndex)
{
	// 아래의 로직 때문에 컴페니언 탑승시 컴페니언의 실루엣이 위아래로 납작하게 눌려버리는 문제가 발생한다.
	// 없어도 실루엣을 그리는데 문제가 없지만, 미쳐 예상하지 못한 부분에서 문제가 발생할수도,
	float4 pivotPoint = g_InstanceVecArray[tmIndex];
	//float stepChk = step(Pos.y, pivotPoint.y);
	//float y = Pos.y;
	//Pos.y += (pivotPoint.y - Pos.y) * stepChk;

	float4 WorldPos = float4(Pos, 1);

	float4 Out = 0;

	#ifdef ENABLE_2D
		Out = mul(WorldPos, g_InstanceTMArray[g_InstanceCount * 2 + tmIndex]);
		Out /= Out.w;
		Out.z = 0.0f;	// 빌보드로 만듬
		Out.y += 0.4f;  // 캐릭터 발 위치 맞출때 사용하는 상수입니다	
		Out = mul(Out, g_InstanceTMArray[g_InstanceCount * 1 + tmIndex]);
		Out = mul(Out, g_ViewProjTM);
		// (localz-카메라거리:z값을0앞뒤로맞추려고) * 적당히 납작하게 하기 위한 상수 - 뎁스바이어스;

		float uprate = 1.1;
		float pivotOffset = 100;
		float4 pivotMul = mul(float4(pivotPoint.x, (WorldPos.y - pivotPoint.y + pivotOffset) * uprate + pivotPoint.y - pivotOffset, pivotPoint.z, 1), g_ViewProjTM);
		float defz = pivotMul.z / pivotMul.w;
		Out.z = defz * Out.w;
	#else
		Out = mul(WorldPos, g_ViewProjTM);
	#endif
	return Out;
}
#else
float4 CalcWVPSilhouette(float3 Pos)
{
	// 아래의 로직 때문에 컴페니언 탑승시 컴페니언의 실루엣이 위아래로 납작하게 눌려버리는 문제가 발생한다.
	// 없어도 실루엣을 그리는데 문제가 없지만, 미쳐 예상하지 못한 부분에서 문제가 발생할수도,
	//float stepChk = step(Pos.y, g_pivotPoint.y);
	//float y = Pos.y;
	//Pos.y += (g_pivotPoint.y - Pos.y) * stepChk;

	float4 WorldPos = float4(Pos, 1.f);

	float4 Out = 0;
	#ifdef ENABLE_2D
		Out = mul(WorldPos, g_charViewProjTM);
		Out /= Out.w;
		Out.z = 0.0f; // 빌보드로 만듬
		Out.y += 0.4f;  // 캐릭터 발 위치 맞출때 사용하는 상수입니다	
		Out = mul(Out, g_billboardTM);
		Out = mul(Out, g_ViewProjTM);
		// (localz-카메라거리:z값을0앞뒤로맞추려고) * 적당히 납작하게 하기 위한 상수 - 뎁스바이어스;

		float uprate = 1.1;
		float pivotOffset = 100;
		float4 pivotMul = mul(float4(g_pivotPoint.x, (WorldPos.y - g_pivotPoint.y + pivotOffset) * uprate + g_pivotPoint.y - pivotOffset, g_pivotPoint.z, 1), g_ViewProjTM);
		float defz = pivotMul.z / pivotMul.w;
		Out.z = defz * Out.w;
	#else
		Out = mul(WorldPos, g_ViewProjTM);
	#endif
	return Out;
}
#endif

float fall_off(float3 normal, float3 eyevec)
{
	normal = normalize(normal);
	eyevec = normalize(eyevec);
	float falloff = max(0.0f, dot(normal, eyevec));
	return falloff;
}

#ifdef ENABLE_FREEZE
float4 freezeHead(float4 outcolor, float3 worldpos, float falloff)
{
	outcolor.rgb = (outcolor.r + outcolor.g + outcolor.b) / 3;

	falloff = smoothstep(0.2f, 0.4f, outcolor.r);
	outcolor.rgb *= g_materialShaderHeadColor.rgb;
	outcolor.rgb += (1 - falloff) * g_fallOffMultiplyValue;
	outcolor.rgb = pow(abs(outcolor.rgb), g_materialShaderPowValue);
	return outcolor;
}

float4 freeze(float4 outcolor, float2 uv, float falloff)
{
	outcolor.rgb = (outcolor.r + outcolor.g + outcolor.b) / 3;

	falloff = smoothstep(0.2f, 0.4f, falloff) * 0.8;
	falloff -= (1 - smoothstep(0.0f, 0.3f, outcolor.r));

	outcolor.rgb *= g_materialShaderColor.rgb;
	outcolor.rgb += (1 - falloff) * g_fallOffMultiplyValue * 1.3;
	outcolor.rgb = pow(abs(outcolor.rgb), g_materialShaderPowValue);
	
	// freeze	
	worldpos.y /= 20;
	worldpos.y = 1 - worldpos.y;
	worldpos.x /= 20;
	worldpos.z /= 20;

#ifdef ENABLE_SKINNING
	float2 fuv = float2(worldpos.x + worldpos.z, worldpos.y);
	float4 freeze = tex2D(freezeTex, fuv);
	outcolor.rgb = outcolor.rgb * (1 - freeze.a) + freeze.rgb * (freeze.a);
#endif

	return outcolor;
}
#endif

void CalcDiffuseTexCoord(in float2 texCoord, out float2 outTexCoord)
{
#ifdef ENABLE_DIFFUSETEX_ANIMATION
	float4 TransTex = float4(texCoord.xy, 1.0f, 1.0f);
	outTexCoord = mul(TransTex, g_DiffuseAnimationTM).xy;
#else
	outTexCoord = texCoord;
#endif
}

VS_OUT VS_HeadOutlineModelShader_Common(in float4 InPos : POSITION, in float4 InNml : NORMAL, in float4 Tex : TEXCOORD0, in float4 Tex1 : TEXCOORD1
#ifdef ENABLE_SKINNING
	, in float4 weights : BLENDWEIGHT, in float4 indices : BLENDINDICES
#endif
#ifdef ENABLE_INSTANCING
	, in float tmID : TEXCOORD2
#endif
	, float xAdd, float yAdd
	)
{
	VS_OUT o = (VS_OUT)0;

	//Position
	float4 localPos = 0;
	float4 localNml = 0;

#ifdef ENABLE_INSTANCING
	int tmIndex = (int)(tmID + 1e-5f);
	o.worldz_tmIndex_fog.y = tmID;
	float4x4 WorldTM = g_InstanceTMArray[tmIndex];
	WorldTM._24 = 0.0f;
	float4x4 WorldViewTM = mul(WorldTM, g_ViewTM);
	float4x4 WorldViewProjTM = mul(WorldViewTM, g_ProjTM);
#else
	float4x4 WorldTM = g_WorldTM;
	float4x4 WorldViewTM = g_WorldViewTM;
	float4x4 WorldViewProjTM = g_WorldViewProjTM;
#endif

#ifdef ENABLE_SKINNING
	int boneIDIndex = g_boneTexID;
	#ifdef ENABLE_INSTANCING
		boneIDIndex = (int)g_InstanceTMArray[tmIndex]._24;
	#endif
	float4 indices2 = D3DCOLORtoUBYTE4(indices);
	for (int i = 0; i < 4; ++i) {
		float4x4 boneTM = GetSkinMatrix(indices2[i] + boneIDIndex);
		localPos.xyz += mul(InPos, boneTM) * weights[i];
		localNml.xyz += mul(InNml, (float3x3)boneTM) * weights[i];
	}
	localPos.w = 1.0f;
	localNml.w = 0.0f;
#else
	localPos = InPos;
	localNml = InNml;
	localPos.w = 1.0f;
	localNml.w = 0.0f;
#endif

	float3 worldPos = 0;
	float3 worldNml = 0;

	worldPos = mul(localPos, WorldTM);
	worldNml = mul(localNml, (float3x3)WorldTM);

	// 캐릭터 2D로 찍기
#ifdef ENABLE_INSTANCING
	o.Pos = CalcWVP(localPos, WorldTM, WorldViewProjTM, tmIndex, o.posWV);
#else	
	o.Pos = CalcWVP(localPos, o.posWV);
#endif

	o.Pos.z += 0.1f;
	o.Pos.x += xAdd;
	o.Pos.y += yAdd;
	float depth = o.Pos.z;

#ifdef ENABLE_CHARACTER_RENDER
	#ifdef ENABLE_INSTANCING
		float4x4 worldAngleTM = mul(WorldTM, g_AngleMatrix);
		o.worldz_tmIndex_fog.x = mul(localPos + float3(0, -25.5, 0), worldAngleTM).z * 0.1f;
	#else
		o.worldz_tmIndex_fog.x = mul(localPos + float3(0, -25.5, 0), g_TestMatrix).z * 0.1f;
	#endif
#endif

	o.worldPos.xyz = worldPos;

#ifdef ENABLE_FREEZE
	float4 zeroPos = float4(0, 0, 0, 1);
	zeroPos = mul(zeroPos, WorldTM);

	o.worldPos.xyz = worldPos - zeroPos;
#endif

#ifdef ENABLE_DIFFUSETEX
	CalcDiffuseTexCoord(Tex.xy, o.diffuseTexCoord.xy);
#endif
	o.worldPos.w = 0.0f;

#ifdef ENABLE_GRASS
	float3 viewPos = mul(localPos, WorldViewTM);

	float worldY = -(worldPos.y + mapBottom) / (mapTop - mapBottom);
	float2 texPos = worldPos.xz;
	texPos.x += mapOffsetX;
	texPos.y += mapOffsetY;
	texPos.xy /= mapSize;
	texPos.y *= -1;
	texPos.xy += 1.0;
	texPos.xy *= 0.5;
	float bgDepth = tex2Dlod(heightTex, float4(texPos, 0.0f, 1.0f)).y;

	float delta = (bgDepth - worldY) / 10;
	// 0.0005f 는 수치를 바꿔가면서 찾은 delta 최대치의 매직넘버
	// 0.001f 이상부터 모델이 흔들리는 정도가 심해지기 시작함
	if (delta > 0.0005f)
	{
		delta = 0.0005f;
	}
	o.worldPos.w = 0;


	float attack = 0;
	float tFactor = 0.0;
	for (int i = 0; i < 10; ++i)
	{
		float attackChk = step(length(g_grassAttack[i].xz - worldPos.xz), g_grassAttack[i].w);
		tFactor = g_grassAttackTFactor[i] * attackChk;
		attack = attackChk + attack;
	}

	float calcGrassTime = grassTime;
	float calcWindPower = windPower;

	float stepChk = step(0.5, attack);

	o.Pos.y += delta * 60000 * stepChk;
	calcGrassTime = 7 * stepChk + calcGrassTime * (1 - stepChk);
	calcWindPower = 600 * stepChk + calcWindPower * (1 - stepChk);
	o.worldPos.w = stepChk;

	delta = saturate(delta) * calcWindPower * 10;
	delta = sin((g_timeStamp + tFactor) * calcGrassTime + grassTimeoffset + worldPos.x * 0.1 - worldPos.z * 0.1) * delta + windDir * delta;

	o.Pos.x += delta;
	o.Pos.y -= delta * delta * 0.05;
#endif

	//Env
#ifdef ENABLE_ENVTEX
	float4 worldViewPos = mul(float4(localPos.xyz, 1.0f), WorldViewTM);
	float4 worldViewNml = mul(float4(localNml.xyz, 0.0f), WorldViewTM);
	worldViewPos = normalize(worldViewPos);
	worldViewNml = normalize(worldViewNml);
	o.envTexCoord.xy = reflect(worldViewPos, worldViewNml);
#endif

#ifdef ENABLE_STATICSHADOWTEX
	o.shadowCoord.xy = Tex1.xy;
#endif

	float fogValue = Fog_CalcFogValue(o.Pos.w);
	o.worldz_tmIndex_fog.z = saturate(fogValue);
#ifdef ENABLE_CHARACTER_RENDER
	float charPosInView = mul(float4(g_MidPos, 1.0f), g_depthDistTM).z;
	float vertexPosInView = mul(localPos, g_depthDistTM).z;
	o.outDepth.x = charPosInView;
	o.outDepth.y = vertexPosInView;
	o.outDepth.w = 1.0f;

	o.viewVec = g_InvViewTM[3].xyz - worldPos;
	o.worldNml.xyz = worldNml;

	#ifdef ENABLE_DIFFUSETEX
		// 얼굴 그리는 부분
		#ifdef ENABLE_FACE
			#ifdef ENABLE_INSTANCING
				float4 faceXYMulAdd = g_InstanceVecArray[g_InstanceCount * 5 + tmIndex];
			#else 
				float4 faceXYMulAdd = g_faceXYMulAdd;
			#endif
			o.diffuseTexCoord.x = faceXYMulAdd.x * o.diffuseTexCoord.x + faceXYMulAdd.z;
			o.diffuseTexCoord.y = faceXYMulAdd.y * o.diffuseTexCoord.y + faceXYMulAdd.w;
		#endif
	#endif
#endif

#if defined(ENABLE_DEPTH_RENDER) || defined(ENABLE_DEPTH_MRT)
	o.outDepth.w = depth;
#endif

#ifdef ENABLE_WATER
	o.outDepth = o.Pos;
	o.viewVec = g_InvViewTM[1].xyz;
	o.worldNml.xyz = worldNml;
#endif
	return o;
}


VS_OUT VS_HeadOutlineModelShader1(in float4 InPos : POSITION, in float4 InNml : NORMAL, in float4 Tex : TEXCOORD0, in float4 Tex1 : TEXCOORD1
#ifdef ENABLE_SKINNING
	, in float4 weights : BLENDWEIGHT, in float4 indices : BLENDINDICES
#endif
#ifdef ENABLE_INSTANCING
	, in float tmID : TEXCOORD2
#endif
	)
{
#ifdef ENABLE_SKINNING
	#ifdef ENABLE_INSTANCING
		return VS_HeadOutlineModelShader_Common(InPos, InNml, Tex, Tex1, weights, indices, tmID, -0.8f, 0.0f);
	#else
		return VS_HeadOutlineModelShader_Common(InPos, InNml, Tex, Tex1, weights, indices, -0.8f, 0.0f);
	#endif
#else
	#ifdef ENABLE_INSTANCING
		return VS_HeadOutlineModelShader_Common(InPos, InNml, Tex, Tex1, tmID, -0.8f, 0.0f);
	#else
		return VS_HeadOutlineModelShader_Common(InPos, InNml, Tex, Tex1, -0.8f, 0.0f);
	#endif
#endif
}


VS_OUT VS_HeadOutlineModelShader2(in float4 InPos : POSITION, in float4 InNml : NORMAL, in float4 Tex : TEXCOORD0, in float4 Tex1 : TEXCOORD1
#ifdef ENABLE_SKINNING
	, in float4 weights : BLENDWEIGHT, in float4 indices : BLENDINDICES
#endif
#ifdef ENABLE_INSTANCING
	, in float tmID : TEXCOORD2
#endif
	)
{
#ifdef ENABLE_SKINNING
	#ifdef ENABLE_INSTANCING
		return VS_HeadOutlineModelShader_Common(InPos, InNml, Tex, Tex1, weights, indices, tmID, 0.8f, 0.0f);
	#else
		return VS_HeadOutlineModelShader_Common(InPos, InNml, Tex, Tex1, weights, indices, 0.8f, 0.0f);
	#endif
#else
	#ifdef ENABLE_INSTANCING
		return VS_HeadOutlineModelShader_Common(InPos, InNml, Tex, Tex1, tmID, 0.8f, 0.0f);
	#else
		return VS_HeadOutlineModelShader_Common(InPos, InNml, Tex, Tex1, 0.8f, 0.0f);
	#endif
#endif
}


VS_OUT VS_HeadOutlineModelShader3(in float4 InPos : POSITION, in float4 InNml : NORMAL, in float4 Tex : TEXCOORD0, in float4 Tex1 : TEXCOORD1
#ifdef ENABLE_SKINNING
	, in float4 weights : BLENDWEIGHT, in float4 indices : BLENDINDICES
#endif
#ifdef ENABLE_INSTANCING
	, in float tmID : TEXCOORD2
#endif
	)
{
#ifdef ENABLE_SKINNING
	#ifdef ENABLE_INSTANCING
		return VS_HeadOutlineModelShader_Common(InPos, InNml, Tex, Tex1, weights, indices, tmID, 0.0f, -0.8f);
	#else
		return VS_HeadOutlineModelShader_Common(InPos, InNml, Tex, Tex1, weights, indices, 0.0f, -0.8f);
	#endif
#else
	#ifdef ENABLE_INSTANCING
		return VS_HeadOutlineModelShader_Common(InPos, InNml, Tex, Tex1, tmID, 0.0f, -0.8f);
	#else
		return VS_HeadOutlineModelShader_Common(InPos, InNml, Tex, Tex1, 0.0f, -0.8f);
	#endif	
#endif
}


VS_OUT VS_HeadOutlineModelShader4(in float4 InPos : POSITION, in float4 InNml : NORMAL, in float4 Tex : TEXCOORD0, in float4 Tex1 : TEXCOORD1
#ifdef ENABLE_SKINNING
	, in float4 weights : BLENDWEIGHT, in float4 indices : BLENDINDICES
#endif
#ifdef ENABLE_INSTANCING
	, in float tmID : TEXCOORD2
#endif
	)
{
#ifdef ENABLE_SKINNING
	#ifdef ENABLE_INSTANCING
		return VS_HeadOutlineModelShader_Common(InPos, InNml, Tex, Tex1, weights, indices, tmID, 0.0f, 0.8f);
	#else
		return VS_HeadOutlineModelShader_Common(InPos, InNml, Tex, Tex1, weights, indices, 0.0f, 0.8f);
	#endif
#else
	#ifdef ENABLE_INSTANCING
		return VS_HeadOutlineModelShader_Common(InPos, InNml, Tex, Tex1, tmID, 0.0f, 0.8f);
	#else
		return VS_HeadOutlineModelShader_Common(InPos, InNml, Tex, Tex1, 0.0f, 0.8f);
	#endif
#endif
}

#define TIME_STEP 2.f

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
	float4 localPos = 0;
	float4 localNml = 0;

	float4 localPrevPos = 0;

#ifdef ENABLE_INSTANCING
	int tmIndex = (int)(tmID + 1e-5f);
	o.tmIndex = tmID;
	float4x4 WorldTM = g_InstanceTMArray[tmIndex];
	WorldTM._24 = 0.f;
	float4x4 WorldViewTM = mul(WorldTM, g_ViewTM);
	float4x4 WorldViewProjTM = mul(WorldViewTM, g_ProjTM);
#else
	float4x4 WorldTM = g_WorldTM;
	float4x4 WorldViewTM = g_WorldViewTM;
	float4x4 WorldViewProjTM = g_WorldViewProjTM;
#endif

#ifdef ENABLE_SKINNING
	int boneIDIndex = g_boneTexID;
	#ifdef ENABLE_INSTANCING
		boneIDIndex = (int)g_InstanceTMArray[tmIndex]._24;
	#endif
	float4 indices2 = D3DCOLORtoUBYTE4(indices);
	for (int i = 0; i < 4; ++i) {
		float4x4 boneTM = GetSkinMatrix(indices2[i] + boneIDIndex);
			localPos.xyz += mul(InPos, boneTM) * weights[i];
		localNml.xyz += mul(InNml, (float3x3)boneTM) * weights[i];
	}
	localPos.w = 1.0f;
	localNml.w = 0.0f;
#else
	localPos = InPos;
	localNml = InNml;
	localPos.w = 1.0f;
	localNml.w = 0.0f;
#endif

	float3 worldPos = 0;
	float3 worldNml = 0;

	float3 prevWorldPos = 0.f;

	worldPos = mul(localPos, WorldTM);
	worldNml = mul(localNml, (float3x3)WorldTM);

	// 캐릭터 2D로 찍기
	float4 posWV;
#ifdef ENABLE_INSTANCING
	o.Pos = CalcWVP(localPos, WorldTM, WorldViewProjTM, tmIndex, posWV);
#else
	o.Pos = CalcWVP(localPos, posWV);
#endif
	
#ifdef ENABLE_INSTANCING
	float fTime = g_InstanceVecArray[g_InstanceCount * 4 + tmIndex].y;
	float fAuraFactor = g_InstanceVecArray[g_InstanceCount * 4 + tmIndex].x;
#else
	float fTime = g_auraValues.y;
	float fAuraFactor = g_auraValues.x;
#endif

	float3 vpNml = mul(localNml, (float3x3)g_ViewProjTM);
	o.Pos.x += fTime * vpNml.x * fAuraFactor + sin(fTime * 3.14f) * 0.5f;
	float y = o.Pos.y;
	o.Pos.y += fTime * vpNml.y * fAuraFactor * 1.5f;
	o.Pos.y = max(o.Pos.y, y + sin(fTime));
			
	return o;
}

VS_OUT VS_ModelShader(in float4 InPos : POSITION, in float4 InNml : NORMAL, in float4 Tex : TEXCOORD0, in float4 Tex1 : TEXCOORD1
#ifdef ENABLE_SKINNING
	, in float4 weights : BLENDWEIGHT, in float4 indices : BLENDINDICES
#endif
#ifdef ENABLE_INSTANCING
	, in float tmID : TEXCOORD2
#endif
	)
{
	VS_OUT o = (VS_OUT)0;

	//Position
	float4 localPos = 0;
	float4 localNml = 0;

#ifdef ENABLE_INSTANCING
	int tmIndex = (int)(tmID + 1e-5f);
	o.worldz_tmIndex_fog.y = tmID;
	float4x4 WorldTM = g_InstanceTMArray[tmIndex];
	WorldTM._24 = 0.0f;
	float4x4 WorldViewTM = mul(WorldTM, g_ViewTM);
	float4x4 WorldViewProjTM = mul(WorldViewTM, g_ProjTM);
#else
	float4x4 WorldTM = g_WorldTM;
	float4x4 WorldViewTM = g_WorldViewTM;
	float4x4 WorldViewProjTM = g_WorldViewProjTM;
#endif

#ifdef ENABLE_SKINNING
	int boneIDIndex = g_boneTexID;
	#ifdef ENABLE_INSTANCING
		boneIDIndex = (int)g_InstanceTMArray[tmIndex]._24;
	#endif
	float4 indices2 = D3DCOLORtoUBYTE4(indices);
	for (int i = 0; i < 4; ++i) {
		float4x4 boneTM = GetSkinMatrix(indices2[i] + boneIDIndex);
		localPos.xyz += mul(InPos, boneTM) * weights[i];
		localNml.xyz += mul(InNml, (float3x3)boneTM) * weights[i];
	}
	localPos.w = 1.0f;
	localNml.w = 0.0f;
#else
	localPos = InPos;
	localNml = InNml;
	localPos.w = 1.0f;
	localNml.w = 0.0f;
#endif
	
	float3 worldPos = 0;
	float3 worldNml = 0;

	worldPos = mul(localPos, WorldTM);
	worldNml = mul(localNml, (float3x3)WorldTM);

	// 캐릭터 2D로 찍기
#ifdef ENABLE_INSTANCING
	o.Pos = CalcWVP(localPos, WorldTM, WorldViewProjTM, tmIndex, o.posWV);
#else	
	o.Pos = CalcWVP(localPos, o.posWV);
#endif

	float depth = o.Pos.z;

#ifdef ENABLE_CHARACTER_RENDER
	#ifdef ENABLE_INSTANCING
		float4x4 worldAngleTM = mul(WorldTM, g_AngleMatrix);
		o.worldz_tmIndex_fog.x = mul(localPos + float3(0, -25.5, 0), worldAngleTM).z * 0.1f;
	#else
		o.worldz_tmIndex_fog.x = mul(localPos + float3(0, -25.5, 0), g_TestMatrix).z * 0.1f;
	#endif
#endif

	o.worldPos.xyz = worldPos;
	
#ifdef ENABLE_FREEZE
	float4 zeroPos = float4(0, 0, 0, 1);
	zeroPos = mul(zeroPos, WorldTM);

	o.worldPos.xyz = worldPos - zeroPos;
#endif 
	//Diffuse
#ifdef ENABLE_DIFFUSETEX
	CalcDiffuseTexCoord(Tex.xy, o.diffuseTexCoord.xy);
#endif
	o.worldPos.w = 0.0f;
#ifdef ENABLE_GRASS
	float3 viewPos = mul(localPos, WorldViewTM);

	float worldY = -(worldPos.y + mapBottom) / (mapTop - mapBottom);
	float2 texPos = worldPos.xz;
	texPos.x += mapOffsetX;
	texPos.y += mapOffsetY;
	texPos.xy /= mapSize;
	texPos.y *= -1;
	texPos.xy += 1.0;
	texPos.xy *= 0.5;
	float bgDepth = tex2Dlod(heightTex, float4(texPos, 0.0f, 1.0f)).y;

	float delta = (bgDepth - worldY) / 10;
	// 0.0005f 는 수치를 바꿔가면서 찾은 delta 최대치의 매직넘버
	// 0.001f 이상부터 모델이 흔들리는 정도가 심해지기 시작함
	if (delta > 0.0005f)
	{
		delta = 0.0005f;
	}
	o.worldPos.w = 0;

	float attack = 0;
	float tFactor = 0.0;
	for (int i = 0; i < 10; ++i)
	{
		float attackChk = step(length(g_grassAttack[i].xz - worldPos.xz), g_grassAttack[i].w);
		tFactor = g_grassAttackTFactor[i] * attackChk;
		attack = attackChk + attack;
	}

	float calcGrassTime = grassTime;
	float calcWindPower = windPower;

	float stepChk = step(0.5, attack);

	o.Pos.y += delta * 60000 * stepChk;
	calcGrassTime = 7 * stepChk + calcGrassTime * (1 - stepChk);
	calcWindPower = 600 * stepChk + calcWindPower * (1 - stepChk);
	o.worldPos.w = stepChk;
	
	delta = saturate(delta) * calcWindPower * 10;
	delta = sin((g_timeStamp + tFactor) * calcGrassTime + grassTimeoffset + worldPos.x * 0.1 - worldPos.z * 0.1) * delta + windDir * delta;

	o.Pos.x += delta;
	o.Pos.y -= delta * delta * 0.05;
#endif

	//Env
#ifdef ENABLE_ENVTEX
	float4 worldViewPos = mul(float4(localPos.xyz, 1.0f), WorldViewTM);
	float4 worldViewNml = mul(float4(localNml.xyz, 0.0f), WorldViewTM);
	worldViewPos = normalize(worldViewPos);
	worldViewNml = normalize(worldViewNml);
	o.envTexCoord.xy = reflect(worldViewPos, worldViewNml);
#endif

#ifdef ENABLE_STATICSHADOWTEX
	o.shadowCoord.xy = Tex1.xy;
#endif

	float fogValue = Fog_CalcFogValue(o.Pos.w);
	o.worldz_tmIndex_fog.z = saturate(fogValue);
#ifdef ENABLE_CHARACTER_RENDER
	float charPosInView = mul(float4(g_MidPos, 1.0f), g_depthDistTM).z;
	float vertexPosInView = mul(localPos, g_depthDistTM).z;
	o.outDepth.x = charPosInView;
	o.outDepth.y = vertexPosInView;
	o.outDepth.w = 1.0f;

	o.viewVec = g_InvViewTM[3].xyz - worldPos;
	o.worldNml.xyz = worldNml;
	#ifdef ENABLE_DIFFUSETEX
		// 얼굴 그리는 부분
		#ifdef ENABLE_FACE
			#ifdef ENABLE_INSTANCING
				float4 faceXYMulAdd = g_InstanceVecArray[g_InstanceCount * 5 + tmIndex];
			#else
				float4 faceXYMulAdd = g_faceXYMulAdd;
			#endif
			o.diffuseTexCoord.x = faceXYMulAdd.x * o.diffuseTexCoord.x + faceXYMulAdd.z;
			o.diffuseTexCoord.y = faceXYMulAdd.y * o.diffuseTexCoord.y + faceXYMulAdd.w;
		#endif
	#endif
#endif

#if defined(ENABLE_DEPTH_RENDER) || defined(ENABLE_DEPTH_MRT)
	o.outDepth.w = depth;
#endif

#ifdef ENABLE_WATER
	o.outDepth = o.Pos;
	o.viewVec = g_InvViewTM[1].xyz;
	o.worldNml.xyz = worldNml;
#endif
	return o;
}

VS_OUT VS_OutlineShader(in float4 InPos : POSITION, in float4 InNml : NORMAL, in float4 Tex : TEXCOORD0, in float4 Tex1 : TEXCOORD1
#ifdef ENABLE_SKINNING
	, in float4 weights : BLENDWEIGHT, in float4 indices : BLENDINDICES
#endif
#ifdef ENABLE_INSTANCING
	, in float tmID : TEXCOORD2
#endif
	)
{
	VS_OUT o = (VS_OUT)0;

	//Position
	float4 localPos = 0;
	float4 localNml = 0;

#ifdef ENABLE_INSTANCING
	int tmIndex = (int)(tmID + 1e-5f);
	o.worldz_tmIndex_fog.y = tmID;
	float4x4 WorldTM = g_InstanceTMArray[tmIndex];
	WorldTM._24 = 0.0f;
	float4x4 WorldViewTM = mul(WorldTM, g_ViewTM);
	float4x4 WorldViewProjTM = mul(WorldViewTM, g_ProjTM);
#else
	float4x4 WorldTM = g_WorldTM;
	float4x4 WorldViewTM = g_WorldViewTM;
	float4x4 WorldViewProjTM = g_WorldViewProjTM;
#endif

#ifdef ENABLE_SKINNING
	int boneIDIndex = g_boneTexID;
	#ifdef ENABLE_INSTANCING
		boneIDIndex = (int)g_InstanceTMArray[tmIndex]._24;
	#endif
	float4 indices2 = D3DCOLORtoUBYTE4(indices);
	for (int i = 0; i < 4; ++i) {
		float4x4 boneTM = GetSkinMatrix(indices2[i] + boneIDIndex);
		localPos.xyz += mul(InPos, boneTM) * weights[i];
		localNml.xyz += mul(InNml, (float3x3)boneTM) * weights[i];
	}
	localPos.w = 1.0f;
	localNml.w = 0.0f;
#else
	localPos = InPos;
	localNml = InNml;
	localPos.w = 1.0f;
	localNml.w = 0.0f;
#endif

	localPos += normalize(localNml) * 0.3;

	float3 worldPos = 0;
	float3 worldNml = 0;
	worldPos = mul(localPos, WorldTM);
	worldNml = mul(localNml, (float3x3)WorldTM);

	// 캐릭터 2D로 찍기
#ifdef ENABLE_INSTANCING
	o.Pos = CalcWVP(localPos, WorldTM, WorldViewProjTM, tmIndex, o.posWV);
#else	
	o.Pos = CalcWVP(localPos, o.posWV);
#endif

	float depth = o.Pos.z;

#ifdef ENABLE_DIFFUSETEX
	CalcDiffuseTexCoord(Tex.xy, o.diffuseTexCoord.xy);
#endif

#ifdef ENABLE_CHARACTER_RENDER
	float charPosInView = mul(float4(g_MidPos, 1.0f), g_depthDistTM).z;
	float vertexPosInView = mul(localPos, g_depthDistTM).z;
	o.outDepth.x = charPosInView;
	o.outDepth.y = vertexPosInView;
	o.outDepth.w = 1.0f;

	o.viewVec = g_InvViewTM[3].xyz - worldPos;
	o.worldNml.xyz = worldNml;
#endif

	return o;
}

VS_OUT VS_ColorOutlineShader(in float4 InPos : POSITION, in float4 InNml : NORMAL, in float4 Tex : TEXCOORD0, in float4 Tex1 : TEXCOORD1
#ifdef ENABLE_SKINNING
	, in float4 weights : BLENDWEIGHT, in float4 indices : BLENDINDICES
#endif
#ifdef ENABLE_INSTANCING
	, in float tmID : TEXCOORD2
#endif
	)
{
	VS_OUT o = (VS_OUT)0;

	//Position
	float4 localPos = 0;
	float4 localNml = 0;

#ifdef ENABLE_INSTANCING
	int tmIndex = (int)(tmID + 1e-5f);
	o.worldz_tmIndex_fog.y = tmID;
	float4x4 WorldTM = g_InstanceTMArray[tmIndex];
	WorldTM._24 = 0.0f;
	float4x4 WorldViewTM = mul(WorldTM, g_ViewTM);
	float4x4 WorldViewProjTM = mul(WorldViewTM, g_ProjTM);
#else
	float4x4 WorldTM = g_WorldTM;
	float4x4 WorldViewTM = g_WorldViewTM;
	float4x4 WorldViewProjTM = g_WorldViewProjTM;
#endif

#ifdef ENABLE_SKINNING
	int boneIDIndex = g_boneTexID;
	#ifdef ENABLE_INSTANCING
		boneIDIndex = (int)g_InstanceTMArray[tmIndex]._24;
	#endif
	float4 indices2 = D3DCOLORtoUBYTE4(indices);
	for (int i = 0; i < 4; ++i) {
		float4x4 boneTM = GetSkinMatrix(indices2[i] + boneIDIndex);
		localPos.xyz += mul(InPos, boneTM) * weights[i];
		localNml.xyz += mul(InNml, (float3x3)boneTM) * weights[i];
	}
	localPos.w = 1.0f;
	localNml.w = 0.0f;
#else
	localPos = InPos;
	localNml = InNml;
	localPos.w = 1.0f;
	localNml.w = 0.0f;
#endif

	localPos += normalize(localNml) * 1.0f;

	float3 worldPos = 0;
	float3 worldNml = 0;
	worldPos = mul(localPos, WorldTM);
	worldNml = mul(localNml, (float3x3)WorldTM);

	// 캐릭터 2D로 찍기
#ifdef ENABLE_INSTANCING
	o.Pos = CalcWVP(localPos, WorldTM, WorldViewProjTM, tmIndex, o.posWV);
#else	
	o.Pos = CalcWVP(localPos, o.posWV);
#endif

	float depth = o.Pos.z;

#ifdef ENABLE_DIFFUSETEX
	CalcDiffuseTexCoord(Tex.xy, o.diffuseTexCoord.xy);
#endif

#ifdef ENABLE_CHARACTER_RENDER
	float charPosInView = mul(float4(g_MidPos, 1.0f), g_depthDistTM).z;
	float vertexPosInView = mul(localPos, g_depthDistTM).z;
	o.outDepth.x = charPosInView;
	o.outDepth.y = vertexPosInView;
	o.outDepth.w = 1.0f;

	o.viewVec = g_InvViewTM[3].xyz - worldPos;
	o.worldNml.xyz = worldNml;
#endif

	return o;
}


VS_OUT VS_Silhouette(in float4 InPos : POSITION, in float4 InNml : NORMAL, in float4 Tex : TEXCOORD0, in float4 Tex1 : TEXCOORD1
#ifdef ENABLE_SKINNING
	, in float4 weights : BLENDWEIGHT, in float4 indices : BLENDINDICES
#endif
#ifdef ENABLE_INSTANCING
	, in float tmID : TEXCOORD2
#endif
	)
{
	VS_OUT o = (VS_OUT)0;

	//Position
	float4 localPos = 0;
	float4 localNml = 0;

#ifdef ENABLE_INSTANCING
	int tmIndex = (int)(tmID + 1e-5f);
	o.worldz_tmIndex_fog.y = tmID;
	float4x4 WorldTM = g_InstanceTMArray[tmIndex];
	WorldTM._24 = 0.0f;
	float4x4 WorldViewTM = mul(WorldTM, g_ViewTM);
	float4x4 WorldViewProjTM = mul(WorldViewTM, g_ProjTM);
#else
	float4x4 WorldTM = g_WorldTM;
	float4x4 WorldViewTM = g_WorldViewTM;
	float4x4 WorldViewProjTM = g_WorldViewProjTM;
#endif

#ifdef ENABLE_SKINNING
	int boneIDIndex = g_boneTexID;
	#ifdef ENABLE_INSTANCING
		boneIDIndex = (int)g_InstanceTMArray[tmIndex]._24;
	#endif
	float4 indices2 = D3DCOLORtoUBYTE4(indices);
	for (int i = 0; i < 4; ++i) {
		float4x4 boneTM = GetSkinMatrix(indices2[i] + boneIDIndex);
		localPos.xyz += mul(InPos, boneTM) * weights[i];
		localNml.xyz += mul(InNml, (float3x3)boneTM) * weights[i];
	}
	localPos.w = 1.0f;
	localNml.w = 0.0f;
#else
	localPos = InPos;
	localNml = InNml;
	localPos.w = 1.0f;
	localNml.w = 0.0f;
#endif

	float3 worldPos = mul(localPos, WorldTM);
	float3 worldNml = mul(localNml, (float3x3)WorldTM);

	// 캐릭터 2D로 찍기
#ifdef ENABLE_INSTANCING
	o.Pos = CalcWVPSilhouette(worldPos, tmIndex);
#else
	o.Pos = CalcWVPSilhouette(worldPos);
#endif

	float depth = o.Pos.z;

#ifdef ENABLE_DIFFUSETEX
	CalcDiffuseTexCoord(Tex.xy, o.diffuseTexCoord.xy);
#endif

#ifdef ENABLE_CHARACTER_RENDER
	float charPosInView = mul(float4(g_MidPos, 1.0f), g_depthDistTM).z;
	float vertexPosInView = mul(localPos, g_depthDistTM).z;
	o.outDepth.x = charPosInView;
	o.outDepth.y = vertexPosInView;
	o.outDepth.w = 1.0f;

	o.viewVec = g_InvViewTM[3].xyz - worldPos;
	o.worldNml.xyz = worldNml;

	// 얼굴 그리는 부분
	#ifdef ENABLE_FACE
		#ifdef ENABLE_INSTANCING
			float4 faceXYMulAdd = g_InstanceVecArray[g_InstanceCount * 5 + tmIndex];
		#else
			float4 faceXYMulAdd = g_faceXYMulAdd;
		#endif
		o.diffuseTexCoord.x = faceXYMulAdd.x * o.diffuseTexCoord.x + faceXYMulAdd.z;
		o.diffuseTexCoord.y = faceXYMulAdd.y * o.diffuseTexCoord.y + faceXYMulAdd.w;
	#endif
#endif
	o.outDepth = o.Pos/o.Pos.w;
	return o;
}

float4 float4lineShader(VS_OUT In) : COLOR
{
	float4 diffTexColor = 1;
	float  alpha = 0;
	float3 farColor = 1;
	float3 nearColor = 1;
	float3 nearTopColor = 1;
	float3 nearBottomColor = 1;
	float3 outlineColor = 1;
	float3 specularcolor = 1;
	float3 envtex = float3(1, 0, 0);
	float specularpower = 0;
	float specularmask = 0;
	float glossiness = 0;
#ifdef ENABLE_DIFFUSETEX
	diffTexColor = tex2D(diffuseTex, In.diffuseTexCoord);
	alpha = diffTexColor.a;
#endif

#ifdef ENABLE_ENVTEX 
	envtex = tex2D(envTex, In.diffuseTexCoord).rgb;
#endif

	float4 OutColor = 1;
	float falloff = 0.0f;
	float distValue = 0.0f;
#ifdef ENABLE_CHARACTER_RENDER
	float3 normalizeNormal = normalize(In.worldNml.xyz);

	distValue = In.outDepth.r - In.outDepth.g;

	specularmask = envtex.r;
	specularpower = 1 + (envtex.g * g_envValue);
	glossiness = saturate(0.78 + (envtex.b*0.2)) - 0.03;
	falloff = fall_off(normalizeNormal, In.viewVec);
	float falloffValue = smoothstep(glossiness, 0.98, falloff);
	float outlinevalue = smoothstep(0.0f, 0.38f, falloff);
	falloffValue *= specularmask;

	farColor = diffTexColor.xyz;;
	nearColor = diffTexColor.xyz;
	OutColor.rgb = lerp(outlineColor, OutColor.rgb, outlinevalue);
	OutColor = diffTexColor;
	OutColor.rgb = saturate(OutColor.rgb);
	OutColor.a = alpha;
#endif

#ifdef ENABLE_INSTANCING
	int tmIndex = (int)(In.worldz_tmIndex_fog.y + 1e-5f);
	float4 blendColor = g_InstanceVecArray[g_InstanceCount + tmIndex];
#else
	float4 blendColor = g_BlendColor;
#endif
	OutColor.rgb *= blendColor.rgb * 2.0f;
	OutColor = saturate(OutColor);
	OutColor *= 0.5f;
	OutColor.a = alpha;
#ifdef ENABLE_CHARACTER_RENDER
	OutColor.a *= blendColor.a;
#endif

#ifdef ENABLE_FREEZE
	OutColor = freeze(OutColor, In.worldPos.xyz, falloff);
	OutColor.r *= 0.5f;
	OutColor.g *= 0.5f;
	OutColor.b *= 0.8f;
#endif

	return OutColor;
}

float4 PS_OutLineColorHeadShader(VS_OUT In) : COLOR
{
	float4 diffTexColor = 1;
	float  alpha = 0;
	float3 farColor = 1;
	float3 nearColor = 1;
	float3 nearTopColor = 1;
	float3 nearBottomColor = 1;
	float3 outlineColor = 1;
	float3 specularcolor = 1;
	float3 envtex = float3(1, 0, 0);
	float specularpower = 0;
	float specularmask = 0;
	float glossiness = 0;
#ifdef ENABLE_DIFFUSETEX
	diffTexColor = tex2D(diffuseTex, In.diffuseTexCoord);
	alpha = diffTexColor.a;
#endif

#ifdef ENABLE_ENVTEX 
	envtex = tex2D(envTex, In.diffuseTexCoord).rgb;
#endif

	float4 OutColor = 1;
	float falloff = 0.0f;
	float distValue = 0.0f;
#ifdef ENABLE_CHARACTER_RENDER
	float3 normalizeNormal = normalize(In.worldNml.xyz);

	distValue = In.outDepth.r - In.outDepth.g;

	specularmask = envtex.r;
	specularpower = 1 + (envtex.g*g_envValue);
	glossiness = saturate(0.78 + (envtex.b*0.2)) - 0.03;
	falloff = fall_off(normalizeNormal, In.viewVec);
	float falloffValue = smoothstep(glossiness, 0.98, falloff);
	float outlinevalue = smoothstep(0.0f, 0.38f, falloff);
	falloffValue *= specularmask;

	farColor = diffTexColor.xyz;;

	nearColor = diffTexColor.xyz;
	OutColor.rgb = lerp(outlineColor, OutColor.rgb, outlinevalue);
	OutColor = diffTexColor;
	OutColor.rgb = saturate(OutColor.rgb);
	OutColor.a = alpha;
#endif

#ifdef ENABLE_INSTANCING
	int tmIndex = (int)(In.worldz_tmIndex_fog.y + 1e-5f);
	float4 blendColor = g_InstanceVecArray[g_InstanceCount + tmIndex];
#else
	float4 blendColor = g_BlendColor;
#endif
	OutColor.rgb *= blendColor.rgb * 2.0f;
	OutColor = saturate(OutColor);
	OutColor *= 0.5f;
	OutColor.a = alpha;
#ifdef ENABLE_CHARACTER_RENDER		
	OutColor.a *= blendColor.a;
#endif

#ifdef ENABLE_FREEZE
	OutColor = freeze(OutColor, In.worldPos.xyz, falloff);
	OutColor.r *= 0.5f;
	OutColor.g *= 0.5f;
	OutColor.b *= 0.8f;
#endif
	OutColor.rgb = g_outLineColor.rgb;
	
	return OutColor;
}

float4 PS_OutLineColorShader(VS_OUT In) : COLOR
{
	float4 OutColor;
	OutColor.a = 1.0f;
	OutColor.rgb = g_outLineColor.rgb;
	return OutColor;
}


float4 PS_DepthRender(VS_OUT In) : COLOR
{
	float4 Out;// = (float4)0;

	Out.rgb = In.outDepth.w;
	float alpha = 0.0f;
#ifdef ENABLE_DIFFUSETEX
	float4 diffTexColor = tex2D(diffuseTex, In.diffuseTexCoord);
	alpha = diffTexColor.a;
#endif

	Out.a = alpha;
	Out.r = (In.outDepth.w) * 0.0002;
	Out.g = length(In.posWV.xyz) * 0.0002;
	Out.b  = (In.worldPos.y + 300) * 0.001;
	return Out;
}

float4 PS_WaterRender(VS_OUT In) : COLOR
{
	float4 Out;// = (float4)0;

	In.outDepth.x /= In.outDepth.w;
	In.outDepth.y /= In.outDepth.w;

	double2 scrTexOut;
	scrTexOut.x = (In.outDepth.x + 1.0f) * 0.5f;
	scrTexOut.y = (2.0f - (In.outDepth.y + 1.0f)) * 0.5f;

	// 스크린 오프셋 (매직넘버)
	scrTexOut.x += 0.0005f;
	scrTexOut.y += 0.0006f;

	Out.rgba = 0.0f;
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
		float4 shadowColor = tex2D(staticShadowTex, In.shadowCoord);
		Out.rgb *= shadowColor.rgba * 2;
	#endif

	#ifdef ENABLE_ENVTEX
		float4 envColor = tex2D(envTex, In.envTexCoord);
	#endif
	// refraction
	float2 uv = In.worldPos.xz*refractionNormalSize;
	uv += g_timeStamp*refractionDir;
	float4 normal = tex2D(normalTex, uv) - 0.5;

	Out.rgb = tex2D(screenTex, scrTexOut.xy + normal.xy * refractionPower) * (1 - Out.a) + Out.rgb * Out.a;
	Out.a = 1.0f;

	// spary
	uv = In.worldPos.xz*waterSprayNormalSize;
	uv += g_timeStamp*waterSprayDir;
	normal = tex2D(normalTex, uv) - 0.5;

	scrTexOut.xy += normal.xy * waterSprayPower;

	float edge1 = In.worldPos.y - tex2D(depthTex, scrTexOut.xy).b * 1000 + 300;
	edge1 *= waterSparyRange;
	//edge1 = cnt - edge1;
	//edge1 = saturate(edge1/cnt);
	edge1 = step(edge1, 1) * edge1;
	edge1 = step(0, edge1) * edge1;
	edge1 = 1 - edge1 - step(1, 1 - edge1);
	Out.rgb += edge1 * edge1 * waterSprayColor;
	Out.rgb = lerp(g_FogColor.rgb, Out.rgb, 1 - ((1 - In.worldz_tmIndex_fog.z) *0.3f));

	saturate(Out.rgb);
#endif
	return Out;
}

float3 RGBToHSL(float3 RGB)
{
	float3 HSL = 0;
	float U, V;
	U = -min(RGB.r, min(RGB.g, RGB.b));
	V = max(RGB.r, max(RGB.g, RGB.b));
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
	rethsl.x -= hue*(1 - color); //Shift Hue
	rethsl.y += hue*(1 - color); //increase saturation
	rethsl.z -= hue*(1 - color); //decrease lightness, not too sure if this is all correct, with the multiplication following this...
	float3 result = HSLToRGB(rethsl);
	return result;
}

float3 saturationAdj(float3 diffuse, float saturation)
{
	float3 Out;
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

float4 PS_Silhouette(VS_OUT In) : COLOR
{
	float2 scrTexOut;
	scrTexOut.x = (In.outDepth.x + 1.0f) * 0.5f;
	scrTexOut.y = (2.0f - (In.outDepth.y + 1.0f)) * 0.5f;
	// 스크린 오프셋 (매직넘버)
	scrTexOut.x += 0.0005f;
	scrTexOut.y += 0.0006f;
	float3 screenTexColor = tex2D(screenTex, scrTexOut.xy).rgb;

	float4 color = float4(0.0f, 0.0f, 0.0f, 1.0f);
	color.rgb = 1.0f - GetLuminance(screenTexColor);
	return color;
}

float4 PS_SilhouetteHead(VS_OUT In) : COLOR
{
	float alpha = 1.0f;
#ifdef ENABLE_DIFFUSETEX
	alpha = tex2D(diffuseTex, In.diffuseTexCoord).a;
#endif

	float2 scrTexOut;
	scrTexOut.x = (In.outDepth.x + 1.0f) * 0.5f;
	scrTexOut.y = (2.0f - (In.outDepth.y + 1.0f)) * 0.5f;
	// 스크린 오프셋 (매직넘버)
	scrTexOut.x += 0.0005f;
	scrTexOut.y += 0.0006f;
	float3 screenTexColor = tex2D(screenTex, scrTexOut.xy).rgb;

	float4 color = float4(0.0f, 0.0f, 0.0f, 1.0f);
	color.rgb = 1.0f - GetLuminance(screenTexColor);
	color.a = alpha;
	return color;
}

float3 ShiftColor(float3 c)
{
	float r = c.r;
	c.r = c.g;
	c.g = c.b;
	c.b = r;

	return c;
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

#ifdef ENABLE_DEPTH_MRT
OUT_COLOR PS_CharacterShader(VS_OUT In)
#else
float4 PS_CharacterShader(VS_OUT In) : COLOR
#endif
{
	float4 diffTexColor = 1;
	float  alpha = 0;
	float3 farColor = 1;
	float3 nearColor = 1;
	float3 outlineColor = 1;
	float3 envtex = float3(1, 0, 0);
#ifdef ENABLE_DIFFUSETEX
	diffTexColor = tex2D(diffuseTex, In.diffuseTexCoord);
	alpha = diffTexColor.a;
#endif

#ifdef ENABLE_ENVTEX 
	envtex = tex2D(envTex, In.diffuseTexCoord).rgb;
#endif

	float4 OutColor = 1;
	float falloff = 0.0f;
	float distValue = 0.0f;

#ifdef ENABLE_INSTANCING
	int tmIndex = (int)(In.worldz_tmIndex_fog.y + 1e-5f);
	float4 blendColor = g_InstanceVecArray[g_InstanceCount + tmIndex];
	float4 blendColorAdd = g_InstanceVecArray[g_InstanceCount * 2 + tmIndex];
#else
	float4 blendColor = g_BlendColor;
	float4 blendColorAdd = g_BlendColorAdd;
#endif

#ifdef ENABLE_CHARACTER_RENDER
	float3 normalizeNormal = normalize(In.worldNml.xyz);

	distValue = In.outDepth.r - In.outDepth.g;
	falloff = fall_off(normalizeNormal, In.viewVec);
	float outlinevalue = smoothstep(0.0f, 0.38f, falloff);
	farColor = adjust(diffTexColor.rgb, g_farValue);
	nearColor = diffTexColor.xyz;

	OutColor.rgb = lerp(farColor, nearColor, saturate(In.worldz_tmIndex_fog.x * g_depthDistanceValue));
	outlineColor = adjust(OutColor.rgb, g_outLineValue);
	OutColor.rgb = lerp(outlineColor, OutColor.rgb, outlinevalue);
	OutColor.rgb = saturate(OutColor.rgb);
	
	OutColor.a = alpha;
#endif
	float4 Out = (float4)0;

	Out.rgb = OutColor.xyz;
	Out.a = alpha;

	Out.rgb *= blendColor.rgb * 2.0f;
	Out.rgb += blendColorAdd.rgb;
	Out = saturate(Out);

#ifdef ENABLE_CHARACTER_RENDER
	Out.a *= blendColor.a;
#endif

#ifdef ENABLE_FREEZE
	Out = freeze(Out, In.worldPos.xyz, falloff);
#endif
	Out.rgb = lerp(g_FogColor.rgb, Out.rgb, 1 - ((1 - In.worldz_tmIndex_fog.z) * 0.3f));
	
#ifdef ENABLE_DEPTH_MRT
	OUT_COLOR color = (OUT_COLOR)0;
	color.albedo = Out;
	color.depth  = CalcDepth(In.outDepth.w, In.worldPos.y, In.posWV);
	color.depth.a = alpha;
	return color;
#else
	return Out;
#endif	
}

float4 PS_BillBoardHead(VS_OUT In) : COLOR
{
	float4 diffTexColor = 0;
	float alpha = 0.0f;
#ifdef ENABLE_DIFFUSETEX
	diffTexColor = tex2D(diffuseTex, In.diffuseTexCoord);
	alpha = diffTexColor.a;
#endif
	diffTexColor.a = alpha;

	float4 Out = diffTexColor;
#ifdef ENABLE_CHARACTER_RENDER
	#ifdef ENABLE_INSTANCING
		int tmIndex = (int)(In.worldz_tmIndex_fog.y + 1e-5f);
		float4 blendColor = g_InstanceVecArray[g_InstanceCount + tmIndex];
		float4 blendColorAdd = g_InstanceVecArray[g_InstanceCount * 2 + tmIndex];
	#else
		float4 blendColor = g_BlendColor;
		float4 blendColorAdd = g_BlendColorAdd;
	#endif
	Out.a *= blendColor.a;
	Out.rgb *= blendColor.rgb * 2.0f;
	Out.rgb += blendColorAdd.rgb;
	Out = saturate(Out);
#endif

#ifdef ENABLE_FREEZE
	Out = freezeHead(Out, In.worldPos.xyz, 1);
#endif

	Out.rgb = lerp(g_FogColor.rgb, Out.rgb, 1 - ((1 - In.worldz_tmIndex_fog.z) *0.3f));

	return Out;
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
	float4 localPos = 0;
	float4 localNml = 0;
#ifdef ENABLE_SKINNING
	int boneIDIndex = g_boneTexID;
	float4 indices2 = D3DCOLORtoUBYTE4(indices);

	for (int i = 0; i < 4; ++i) {
		float4x4 boneTM = GetSkinMatrix(indices2[i] + boneIDIndex);
		localPos.xyz += mul(InPos, boneTM) * weights[i];
	}
	localPos.w = 1.0f;

#else
		localPos = InPos;

	localPos.w = 1.0f;

#endif

#ifdef ENABLE_INSTANCING
	int tmIndex = (int)(tmID + 1e-5f);
	o.worldz_tmIndex_fog.y = tmID;
	float4x4 WorldTM = g_InstanceTMArray[tmIndex];
		WorldTM._24 = 0.0f;
#else
	float4x4 WorldTM = g_WorldTM;
#endif

	float3 worldPos = 0;
	worldPos = mul(localPos, WorldTM);

	float worldY = -(worldPos.y + mapBottom) / (mapTop - mapBottom);
	o.Pos = float4(worldPos, 1);
	o.Pos.y = o.Pos.z;
	o.Pos.z = worldY;
	o.Pos.x += mapOffsetX;
	o.Pos.y += mapOffsetY;
	o.Pos.xy /= mapSize;


	return o;
}


VS_OUT VS_HeightShader0(in float4 InPos : POSITION, in float4 InNml : NORMAL, in float4 Tex : TEXCOORD0, in float4 Tex1 : TEXCOORD1
#ifdef ENABLE_SKINNING
	, in float4 weights : BLENDWEIGHT, in float4 indices : BLENDINDICES
#endif
#ifdef ENABLE_INSTANCING
	, in float tmID : TEXCOORD2
#endif
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

	o.Pos.x -= 0.02f;
	o.outDepth.w = o.Pos.z;
	return o;
}
VS_OUT VS_HeightShader1(in float4 InPos : POSITION, in float4 InNml : NORMAL, in float4 Tex : TEXCOORD0, in float4 Tex1 : TEXCOORD1
#ifdef ENABLE_SKINNING
	, in float4 weights : BLENDWEIGHT, in float4 indices : BLENDINDICES
#endif
#ifdef ENABLE_INSTANCING
	, in float tmID : TEXCOORD2
#endif
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

	o.Pos.x += 0.02f;
	o.outDepth.w = o.Pos.z;
	return o;
}
VS_OUT VS_HeightShader2(in float4 InPos : POSITION, in float4 InNml : NORMAL, in float4 Tex : TEXCOORD0, in float4 Tex1 : TEXCOORD1
#ifdef ENABLE_SKINNING
	, in float4 weights : BLENDWEIGHT, in float4 indices : BLENDINDICES
#endif
#ifdef ENABLE_INSTANCING
	, in float tmID : TEXCOORD2
#endif
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

	o.Pos.y -= 0.02f;
	o.outDepth.w = o.Pos.z;
	return o;
}
VS_OUT VS_HeightShader3(in float4 InPos : POSITION, in float4 InNml : NORMAL, in float4 Tex : TEXCOORD0, in float4 Tex1 : TEXCOORD1
#ifdef ENABLE_SKINNING
	, in float4 weights : BLENDWEIGHT, in float4 indices : BLENDINDICES
#endif
#ifdef ENABLE_INSTANCING
	, in float tmID : TEXCOORD2
#endif
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

	o.Pos.y += 0.02f;
	o.outDepth.w = o.Pos.z;
	return o;
}

float4 PS_HeightRender(VS_OUT In) : COLOR
{
	float4 Out;// = (float4)0;

	Out.rgb = In.outDepth.w;
	float alpha = 1.0f;
#ifdef ENABLE_DIFFUSETEX
	float4 diffTexColor = tex2D(diffuseTex, In.diffuseTexCoord);
		alpha = diffTexColor.a;
#endif
	Out.a = alpha;
	return Out;
}

#ifdef ENABLE_DEPTH_MRT
OUT_COLOR PS_TEST(VS_OUT In)
#else
float4 PS_TEST(VS_OUT In) : COLOR
#endif
{
	float4 Out;
	Out.rgba = 0.0f;
	float4 diffTexColor = 0;
#ifdef ENABLE_DIFFUSETEX
	diffTexColor = tex2D(diffuseTex, In.diffuseTexCoord);
#endif
	Out = diffTexColor;

#ifdef ENABLE_STATICSHADOWTEX
	float4 shadowColor = tex2D(staticShadowTex, In.shadowCoord);
	Out.rgb *= shadowColor.rgba * 2;
#endif

#ifdef ENABLE_ENVTEX
	float4 envColor = tex2D(envTex, In.envTexCoord);
#endif

	Out.rgb = lerp(g_FogColor.rgb, Out.rgb, In.worldz_tmIndex_fog.z);

	float chk = step(1.0f, In.worldPos.w);	
	Out.r += (sin(g_timeStamp * 10) / 5 + 0.1f) * chk;
	Out.g += (sin(g_timeStamp * 10 + 1.04) / 5 + 0.1f) * chk;
	Out.b += (sin(g_timeStamp * 10 + 2.08) / 5 + 0.1f) * chk;	

	Out.a *= g_AlphaBlending;
	
#ifdef ENABLE_DEPTH_MRT
	OUT_COLOR color = (OUT_COLOR)0;
	color.albedo = Out;
	color.depth  = CalcDepth(In.outDepth.w, In.worldPos.y, In.posWV);
	return color;
#else
	return Out;
#endif	
	
}

#ifdef ENABLE_DEPTH_RENDER
	technique DepthRenderTq
	{
		pass P0 {
			CullMode = none;
			AlphaTestEnable = true;
			AlphaRef = 0x10;
			AlphaBlendEnable = false;
			VertexShader = compile vs_3_0 VS_ModelShader();
			PixelShader = compile ps_3_0 PS_DepthRender();
		}
	}
#else
	technique DefaultVertexTq
	{
		pass P0 {
			CullMode = ccw;

			VertexShader = compile vs_3_0 VS_ModelShader();
			PixelShader = compile ps_3_0 PS_TEST();
		}
	}

	#ifdef ENABLE_CHARACTER_RENDER
		technique BehindCharacterShadingTq
		{	
			pass P0 {
				AlphaTestEnable = true;
				AlphaRef = 0x30;
				AlphaFunc = Greater;
				CullMode = none;
				ZEnable = true;
				ZFunc = Greater;
				ZWriteEnable = false;
				AlphaBlendEnable = false;
				VertexShader = compile vs_3_0 VS_Silhouette();
				PixelShader = compile ps_3_0 PS_Silhouette();
			}
		}

		technique BehindBillboardHeadShadingTq
		{	
			pass P0 {
				SRGBWRITEENABLE = FALSE;
				CullMode = none;
				AlphaTestEnable = true;
				AlphaRef = 0x30;
				AlphaFunc = Greater;
				ZFunc = Greater;
				ZWriteEnable = false;
				AlphaBlendEnable = false;
				VertexShader = compile vs_3_0 VS_Silhouette();
				PixelShader = compile ps_3_0 PS_SilhouetteHead();
			}
		}

		technique CharacterShadingTq
		{
			pass P0 {
				AlphaTestEnable = true;
				AlphaRef = 0xfd;
				AlphaFunc = Greater;
				CullMode = ccw;
				AlphaBlendEnable = false;
				ZFunc = LessEqual;
				ZWriteEnable = true;
				VertexShader = compile vs_3_0 VS_ModelShader();
				PixelShader = compile ps_3_0 PS_CharacterShader();
			}
			pass P1 {
				AlphaTestEnable = true;
				AlphaRef = 0x30;
				AlphaFunc = Greater;
				CullMode = ccw;
				AlphaBlendEnable = true;
				ZFunc = LessEqual;
				VertexShader = compile vs_3_0 VS_ModelShader();
				PixelShader = compile ps_3_0 PS_CharacterShader();
			}
			pass P2 {
				AlphaTestEnable = true;
				AlphaRef = 0x30;
				AlphaFunc = Greater;
				CullMode = cw;
				AlphaBlendEnable = true;
				ZFunc = LessEqual;
				ZWriteEnable = false;
				VertexShader = compile vs_3_0 VS_OutlineShader();
				PixelShader = compile ps_3_0 float4lineShader();
			}
		}

		technique CharacterAuraShadingTq
		{
			pass P0 {
				CullMode = cw;
				AlphaBlendEnable = true;
				ZWriteEnable = false;
				VertexShader = compile vs_3_0 VS_ModelAuraShader();
				PixelShader = compile ps_3_0 PS_CharacterAuraShader();
			}
		}

		technique CharacterOutlineShadingTq
		{
			pass P0 {
				AlphaTestEnable = true;
				AlphaRef = 0xfd;
				AlphaFunc = Greater;
				CullMode = ccw;
				AlphaBlendEnable = false;
				ZFunc = LessEqual;
				ZWriteEnable = true;
				VertexShader = compile vs_3_0 VS_ModelShader();
				PixelShader = compile ps_3_0 PS_CharacterShader();
			}
			pass P1 {
				AlphaTestEnable = true;
				AlphaRef = 0x30;
				AlphaFunc = Greater;
				CullMode = ccw;
				AlphaBlendEnable = true;
				ZFunc = LessEqual;
				VertexShader = compile vs_3_0 VS_ModelShader();
				PixelShader = compile ps_3_0 PS_CharacterShader();
			}
			pass P2 {
				AlphaTestEnable = true;
				AlphaRef = 0x30;
				AlphaFunc = Greater;
				CullMode = cw;
				AlphaBlendEnable = true;
				ZFunc = LessEqual;
				ZWriteEnable = false;
				VertexShader = compile vs_3_0 VS_ColorOutlineShader();
				PixelShader = compile ps_3_0 PS_OutLineColorShader();
			}
		}

		technique CharacterShadingTq_LowQuality
		{
			pass P0 {
				AlphaTestEnable = true;
				AlphaRef = 0xfd;
				AlphaFunc = Greater;
				CullMode = ccw;
				AlphaBlendEnable = false;
				ZFunc = LessEqual;
				ZWriteEnable = true;
				VertexShader = compile vs_3_0 VS_ModelShader();
				PixelShader = compile ps_3_0 PS_CharacterShader();
			}
		}

		technique CharacterOutlineShadingTq_LowQuality
		{
			pass P0 {
				AlphaTestEnable = true;
				AlphaRef = 0xfd;
				AlphaFunc = Greater;
				CullMode = ccw;
				AlphaBlendEnable = false;
				ZFunc = LessEqual;
				ZWriteEnable = true;
				VertexShader = compile vs_3_0 VS_ModelShader();
				PixelShader = compile ps_3_0 PS_CharacterShader();
			}
			pass P2 {
				AlphaTestEnable = true;
				AlphaRef = 0x30;
				AlphaFunc = Greater;
				CullMode = cw;
				AlphaBlendEnable = true;
				ZFunc = LessEqual;
				ZWriteEnable = false;
				VertexShader = compile vs_3_0 VS_ColorOutlineShader();
				PixelShader = compile ps_3_0 PS_OutLineColorShader();
			}
		}

		technique BillboardHeadTq
		{
			pass P0 {
				SRGBWRITEENABLE = FALSE;
				CullMode = none;
				AlphaTestEnable = true;
				AlphaRef = 0x30;
				AlphaFunc = Greater;
				ZEnable = true;
				ZFunc = LessEqual;
				ZWriteEnable = true;
				VertexShader = compile vs_3_0 VS_ModelShader();
				PixelShader = compile ps_3_0 PS_BillBoardHead();
			}
		}

		technique BillboardHeadSnapShotTq
		{
			pass P0 {
				SRGBWRITEENABLE = FALSE;
				CullMode = none;
				AlphaTestEnable = true;
				AlphaRef = 0xb4;
				AlphaFunc = Greater;
				ZEnable = true;
				ZFunc = LessEqual;
				ZWriteEnable = true;
				VertexShader = compile vs_3_0 VS_ModelShader();
				PixelShader = compile ps_3_0 PS_BillBoardHead();
			}
		}

		technique BillboardHeadOutlineTq
		{
			pass P0 {
				SRGBWRITEENABLE = FALSE;
				CullMode = none;
				AlphaTestEnable = true;
				AlphaRef = 0x30;
				AlphaFunc = Greater;
				ZEnable = true;
				ZFunc = LessEqual;
				ZWriteEnable = true;
				VertexShader = compile vs_3_0 VS_HeadOutlineModelShader1();
				PixelShader = compile ps_3_0 PS_OutLineColorHeadShader();
			}
			pass P1 {
				SRGBWRITEENABLE = FALSE;
				CullMode = none;
				AlphaTestEnable = true;
				AlphaRef = 0x30;
				AlphaFunc = Greater;
				ZEnable = true;
				ZFunc = LessEqual;
				ZWriteEnable = true;
				VertexShader = compile vs_3_0 VS_HeadOutlineModelShader2();
				PixelShader = compile ps_3_0 PS_OutLineColorHeadShader();
			}
			pass P2 {
				SRGBWRITEENABLE = FALSE;
				CullMode = none;
				AlphaTestEnable = true;
				AlphaRef = 0x30;
				AlphaFunc = Greater;
				ZEnable = true;
				ZFunc = LessEqual;
				ZWriteEnable = true;
				VertexShader = compile vs_3_0 VS_HeadOutlineModelShader3();
				PixelShader = compile ps_3_0 PS_OutLineColorHeadShader();
			}
			pass P3 {
				SRGBWRITEENABLE = FALSE;
				CullMode = none;
				AlphaTestEnable = true;
				AlphaRef = 0x30;
				AlphaFunc = Greater;
				ZEnable = true;
				ZFunc = LessEqual;
				ZWriteEnable = true;
				VertexShader = compile vs_3_0 VS_HeadOutlineModelShader4();
				PixelShader = compile ps_3_0 PS_OutLineColorHeadShader();
			}
		}

		technique BillboardHeadAddTq
		{
			pass P0 {
				SRGBWRITEENABLE = FALSE;
				CullMode = none;
				AlphaTestEnable = true;
				AlphaRef = 0x30;
				AlphaFunc = Greater;
				ZEnable = true;
				ZFunc = LessEqual;
				ZWriteEnable = true;
				VertexShader = compile vs_3_0 VS_ModelShader();
				PixelShader = compile ps_3_0 PS_BillBoardHead();
			}
		}
	#else
		technique WaterRenderTq
		{
			pass P0 {
				Zenable = TRUE;
				VertexShader = compile vs_3_0 VS_ModelShader();
				PixelShader = compile ps_3_0 PS_WaterRender();
			}
		}

		technique HeightRenderTq
		{
			pass P0 {
				CullMode = none;
				AlphaTestEnable = true;
				AlphaRef = 0x10;
				AlphaBlendEnable = false;
				VertexShader = compile vs_3_0 VS_HeightShader0();
				PixelShader = compile ps_3_0 PS_HeightRender();
			}
			pass P1 {
				CullMode = none;
				AlphaTestEnable = true;
				AlphaRef = 0x10;
				AlphaBlendEnable = false;
				VertexShader = compile vs_3_0 VS_HeightShader1();
				PixelShader = compile ps_3_0 PS_HeightRender();
			}
			pass P2 {
				CullMode = none;
				AlphaTestEnable = true;
				AlphaRef = 0x10;
				AlphaBlendEnable = false;
				VertexShader = compile vs_3_0 VS_HeightShader2();
				PixelShader = compile ps_3_0 PS_HeightRender();
			}
			pass P3 {
				CullMode = none;
				AlphaTestEnable = true;
				AlphaRef = 0x10;
				AlphaBlendEnable = false;
				VertexShader = compile vs_3_0 VS_HeightShader3();
				PixelShader = compile ps_3_0 PS_HeightRender();
			}
		}
	#endif
#endif

#endif //__MODELSHADER_FX__
