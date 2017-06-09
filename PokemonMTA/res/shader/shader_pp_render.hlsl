texture screenSource;
float2 tiles = float2(16, 10);
float tileFactor = 1.0;
float saturation = 1.0;
float contrast = 1.0;
float brightness = 1.0;

sampler TextureSampler = sampler_state {
    Texture = <screenSource>;
    AddressU = Mirror;
    AddressV = Mirror;
};


float4 PixelShaderFunction(float2 texCoords : TEXCOORD0) : COLOR0 {	
	
	float4 rawColor;
	
	if (tileFactor > 1.0) {
		float2 brickSize = 1.0 / tiles;
		float2 offsetuv = texCoords;
		
		bool oddRow = floor(offsetuv.y / brickSize.y) % 2.0 >= 1.0;

		if (oddRow) {
			offsetuv.x += brickSize.x / 2.0;
		}
		
		float2 brickNum = floor(offsetuv / brickSize);
		float2 centerOfBrick = brickNum * brickSize + brickSize / 2;
		rawColor = tex2D(TextureSampler, centerOfBrick);
	} else {
		rawColor = tex2D(TextureSampler, texCoords);
	}
  
	float3 luminanceWeights = float3(0.299, 0.587, 0.114);
	float luminance = dot(rawColor, luminanceWeights);
	float4 finalColor = lerp(luminance, rawColor, saturation);
	
	finalColor.a = rawColor.a;
	finalColor.rgb = ((finalColor.rgb - 0.5f) * max(contrast, 0)) + 0.5f;
	finalColor.rgb *= brightness;
	
	return finalColor;
}
 

technique PP {
    pass P0 {
        AlphaRef = 1;
        AlphaBlendEnable = true;
        PixelShader  = compile ps_2_0 PixelShaderFunction();
    }
}

// Fallback
technique Fallback {
    pass P0 {
        // Just draw normally
    }
}