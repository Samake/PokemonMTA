/* 
    Authors: 50p, Sam@ke
*/ 
  
 
 
texture bgTexture; 
sampler BackgroundSampler = sampler_state 
{ 
    Texture = <bgTexture>; 
};

texture inTexture; 
sampler TextureSampler = sampler_state 
{ 
    Texture = <inTexture>; 
}; 
  
texture maskTexture; 
sampler MaskSampler = sampler_state 
{ 
    Texture = <maskTexture>; 
}; 
  
  
float4 MaskTextureMain(float2 texCoords : TEXCOORD0) : COLOR0 
{ 
	float4 backColor = tex2D(BackgroundSampler, texCoords);
    float4 mainColor = tex2D(TextureSampler, texCoords); 
    float4 maskColor = tex2D(MaskSampler, texCoords); 
	
    mainColor *= maskColor * backColor; 
    
	return mainColor; 
} 
  
technique MaskShader 
{ 
    pass Pass1 
    { 
        AlphaBlendEnable = true; 
        SrcBlend = SrcAlpha; 
        DestBlend = InvSrcAlpha; 
        PixelShader = compile ps_2_0 MaskTextureMain(); 
    } 
} 