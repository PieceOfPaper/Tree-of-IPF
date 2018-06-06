//-----------------------------------------------------------------------------
// File: PixelMotionBlur.fx
//
// Desc: Effect file for image based motion blur. The HLSL shaders are used to
//       calculate the velocity of each pixel based on the last frame's matrix 
//       transforms.  This per-pixel velocity is then used in a blur filter to 
//       create the motion blur effect.
// 
// Copyright (c) Microsoft Corporation. All rights reserved.
//-----------------------------------------------------------------------------


//-----------------------------------------------------------------------------
// Global variables
//-----------------------------------------------------------------------------
texture RenderTargetTexture;
texture CurFrameVelocityTexture;
texture LastFrameVelocityTexture;
texture CustomMotionBlurTexture;

static const float NumberOfPostProcessSamples = 12.0f;
float g_fPixelBlurConst = 1.0f;

//-----------------------------------------------------------------------------
// Texture samplers
//-----------------------------------------------------------------------------
sampler RenderTargetSampler = 
sampler_state
{
    Texture = <RenderTargetTexture>;
    MinFilter = POINT;  
    MagFilter = POINT;

    AddressU = Clamp;
    AddressV = Clamp;
};

sampler CurFramePixelVelSampler = 
sampler_state
{
    Texture = <CurFrameVelocityTexture>;
    MinFilter = POINT;
    MagFilter = POINT;

    AddressU = Clamp;
    AddressV = Clamp;
};

sampler LastFramePixelVelSampler = 
sampler_state
{
    Texture = <LastFrameVelocityTexture>;
    MinFilter = POINT;
    MagFilter = POINT;

    AddressU = Clamp;
    AddressV = Clamp;
};

sampler MotionBlurTargetSampler =
sampler_state
{
	Texture = <CustomMotionBlurTexture>;
	MinFilter = POINT;
	MagFilter = POINT;

	AddressU = Clamp;
	AddressV = Clamp;
};

//-----------------------------------------------------------------------------
// Name: PostProcessMotionBlurPS 
// Type: Pixel shader                                      
// Desc: Uses the pixel's velocity to sum up and average pixel in that direction
//       to create a blur effect based on the velocity in a fullscreen
//       post process pass.
//-----------------------------------------------------------------------------
float4 PostProcessMotionBlurPS( float2 OriginalUV : TEXCOORD0 ) : COLOR
{
    float2 pixelVelocity;
    
    // Get this pixel's current velocity and this pixel's last frame velocity
    // The velocity is stored in .r & .g channels
    float4 curFramePixelVelocity = tex2D(CurFramePixelVelSampler, OriginalUV);
    float4 lastFramePixelVelocity = tex2D(LastFramePixelVelSampler, OriginalUV);

    // If this pixel's current velocity is zero, then use its last frame velocity
    // otherwise use its current velocity.  We don't want to add them because then 
    // you would get double the current velocity in the center.  
    // If you just use the current velocity, then it won't blur where the object 
    // was last frame because the current velocity at that point would be 0.  Instead 
    // you could do a filter to find if any neighbors are non-zero, but that requires a lot 
    // of texture lookups which are limited and also may not work if the object moved too 
    // far, but could be done multi-pass.
    float curVelocitySqMag = curFramePixelVelocity.r * curFramePixelVelocity.r +
                             curFramePixelVelocity.g * curFramePixelVelocity.g;
    float lastVelocitySqMag = lastFramePixelVelocity.r * lastFramePixelVelocity.r +
                              lastFramePixelVelocity.g * lastFramePixelVelocity.g;
                                   
    if( lastVelocitySqMag > curVelocitySqMag )
    {
		pixelVelocity.x = lastFramePixelVelocity.r * g_fPixelBlurConst;
		pixelVelocity.y = -lastFramePixelVelocity.g * g_fPixelBlurConst;
    }
    else
    {
		pixelVelocity.x = curFramePixelVelocity.r * g_fPixelBlurConst;
		pixelVelocity.y = -curFramePixelVelocity.g * g_fPixelBlurConst;
    }
    
    // For each sample, sum up each sample's color in "Blurred" and then divide
    // to average the color after all the samples are added.
    float3 Blurred = 0;    
    for(float i = 0; i < NumberOfPostProcessSamples; i++)
    {   
        // Sample texture in a new spot based on pixelVelocity vector 
        // and average it with the other samples        
        float2 lookup = pixelVelocity * i / NumberOfPostProcessSamples + OriginalUV;
        
        // Lookup the color at this new spot
        float4 Current = tex2D(RenderTargetSampler, lookup);
        
        // Add it with the other samples
        Blurred += Current.rgb;
    }
    
    // Return the average color of all the samples
    return float4(Blurred / NumberOfPostProcessSamples, 1.0f);
}

float4 PostProcessMotionBlurPS_Custom(float2 OriginalUV : TEXCOORD0) : COLOR
{
	float2 pixelVelocity;

	// Get this pixel's current velocity and this pixel's last frame velocity
	// The velocity is stored in .r & .g channels
	float4 curFramePixelVelocity = tex2D(CurFramePixelVelSampler, OriginalUV);
		float4 lastFramePixelVelocity = tex2D(LastFramePixelVelSampler, OriginalUV);

		// If this pixel's current velocity is zero, then use its last frame velocity
		// otherwise use its current velocity.  We don't want to add them because then 
		// you would get double the current velocity in the center.  
		// If you just use the current velocity, then it won't blur where the object 
		// was last frame because the current velocity at that point would be 0.  Instead 
		// you could do a filter to find if any neighbors are non-zero, but that requires a lot 
		// of texture lookups which are limited and also may not work if the object moved too 
		// far, but could be done multi-pass.
		float curVelocitySqMag = curFramePixelVelocity.r * curFramePixelVelocity.r +
		curFramePixelVelocity.g * curFramePixelVelocity.g;
	float lastVelocitySqMag = lastFramePixelVelocity.r * lastFramePixelVelocity.r +
		lastFramePixelVelocity.g * lastFramePixelVelocity.g;

	if (lastVelocitySqMag > curVelocitySqMag)
	{
		pixelVelocity.x = lastFramePixelVelocity.r * g_fPixelBlurConst;
		pixelVelocity.y = -lastFramePixelVelocity.g * g_fPixelBlurConst;
	}
	else
	{
		pixelVelocity.x = curFramePixelVelocity.r * g_fPixelBlurConst;
		pixelVelocity.y = -curFramePixelVelocity.g * g_fPixelBlurConst;
	}

	pixelVelocity *= 10.f;

	float4 color = tex2D(RenderTargetSampler, OriginalUV);

	// For each sample, sum up each sample's color in "Blurred" and then divide
	// to average the color after all the samples are added.
	float3 Blurred = 0;
	for (float i = 0; i < NumberOfPostProcessSamples; i++)
	{
		// Sample texture in a new spot based on pixelVelocity vector 
		// and average it with the other samples        
		float2 lookup = pixelVelocity * i / NumberOfPostProcessSamples + OriginalUV;

			// Lookup the color at this new spot
			float4 Current = tex2D(MotionBlurTargetSampler, lookup);

			// Add it with the other samples
			Blurred += Current.rgb;
	}

	// Return the average color of all the samples
	color = float4(Blurred / NumberOfPostProcessSamples, 1.0f);

	return color;
}

//-----------------------------------------------------------------------------
// Name: PostProcessMotionBlur
// Type: Technique                                     
// Desc: Renders a full screen quad and uses velocity information stored in 
//       the textures to blur image.
//-----------------------------------------------------------------------------
technique PostProcessMotionBlur
{
    pass P0
    {
        PixelShader = compile ps_3_0 PostProcessMotionBlurPS();
    }
}

technique PostProcessMotionBlur_Custom
{
	pass P0
	{
		PixelShader = compile ps_3_0 PostProcessMotionBlurPS_Custom();
	}
}