#define GENERATE_NORMALS
#include "mta-helper.hlsl"

struct VertexShaderInput
{
	float3 Position : POSITION0;
	float4 Diffuse : COLOR0;
};


struct VertexShaderOutput
{
	float4 Position : POSITION0;
	float4 Diffuse : COLOR0;
};


VertexShaderOutput VertexShaderFunction(VertexShaderInput input)
{
    VertexShaderOutput output;
	
    output.Position = MTACalcScreenPosition(input.Position);
    output.Diffuse = 0;
	
    return output;
}


float4 PixelShaderFunction(VertexShaderOutput input) : COLOR0
{	
	return 0;
}


technique Player
{
	
    pass Pass0
    {
	    AlphaBlendEnable = true;
		DepthBias = -0.0002;
        VertexShader = compile vs_3_0 VertexShaderFunction();
        PixelShader = compile ps_3_0 PixelShaderFunction();
    }
}


// Fallback
technique Fallback
{
    pass P0
    {
        // Just draw normally
    }
}