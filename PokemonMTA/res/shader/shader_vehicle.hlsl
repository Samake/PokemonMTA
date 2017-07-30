#define GENERATE_NORMALS
#include "mta-helper.hlsl"

float3 lightDirection = float3(0.0, 0.0, 0);
float reflectionsStrength = 2;
float shininess = 32;

sampler MainSampler = sampler_state
{
    Texture = (gTexture0);
};

struct VertexShaderInput
{
	float3 Position : POSITION0;
	float4 Diffuse : COLOR0;
	float3 Normal : NORMAL0;
	float2 TexCoord : TEXCOORD0;
};


struct VertexShaderOutput
{
	float4 Position : POSITION0;
	float4 Diffuse : COLOR0;
	float3 Normal : NORMAL0;
	float2 TexCoord : TEXCOORD0;
	float3 WorldNormal : TEXCOORD2;
};


float4 CalcSpecular(float3 normal, float3 direction, float4 color, float shininess, float strength)
{
	float3 normals = normalize(normal);
	
	float3 light = normalize(direction);
	float3 rs = normalize(2 * dot(light, normals) * normals - light);
	float3 vs = normalize(mul(normalize(gCameraDirection), gWorld));
	float dotProductSun = dot(rs, vs);
	return saturate(color * max(pow(dotProductSun, shininess), 0) * length(color)) * strength;
} 


VertexShaderOutput VertexShaderFunction(VertexShaderInput input)
{
    VertexShaderOutput output;
	
    MTAFixUpNormal(input.Normal);

    output.Position = MTACalcScreenPosition(input.Position);
	output.Normal = mul(input.Normal, gWorldInverseTranspose);
	output.TexCoord = input.TexCoord;
	output.WorldNormal = MTACalcWorldNormal(input.Normal);
	
	float lightIntensity = dot(output.WorldNormal, -lightDirection);
    output.Diffuse = saturate(MTACalcGTAVehicleDiffuse(output.WorldNormal, input.Diffuse) * lightIntensity) + 0.2;
	
    return output;
}


float4 PixelShaderFunction(VertexShaderOutput input) : COLOR0
{	
	float4 finalColor = tex2D(MainSampler, input.TexCoord);
	float4 specular = CalcSpecular(input.Normal, lightDirection, input.Diffuse, shininess, reflectionsStrength);
	
	return finalColor * saturate(float4(input.Diffuse.rgb, 1.0) + specular);
}


technique Vehicle
{
    pass Pass0
    {
	    FogEnable = false;
        ZEnable = true;
        AlphaBlendEnable = true;
		AlphaTestEnable = true;
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