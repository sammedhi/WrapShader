#define PI 3.14159265359

/*
*   Compute the projection of the world space into the cylinder space of axis-y
*   @params worldPoint Position of the point in the world space
*   @params cylinderRadius Radius of the cylinder space we project to
*   @params gameWidth Width of the 2D game window we project from
*   @return The projected point in the cylinder space
*/
float4 WorldToCylinder(float4 worldPoint, float cylinderRadius, float gameWidth)
{
    float percent = worldPoint.x / (gameWidth / 2);
    float angle = percent * PI ;
    float2 circularCoord = float2(sin(angle), cos(angle)) * cylinderRadius;
    float4 cylinderVertex = float4(circularCoord.x,worldPoint.y, circularCoord.y, 1);
    return cylinderVertex;
}

/*
*   Compute the projection of the world space into the sphere space of radius sphereRadius
*   @params worldPoint Position of the point in the world space
*   @params cylinderRadius Radius of the cylinder space we project to
*   @params gameWidth Width of the 2D game window we project from
*   @return The projected point in the cylinder space
*/
float4 WorldToSphere(float4 worldPoint, float sphereRadius, float2 gameSize)
{
    float2 percent = worldPoint.xy / (gameSize.xy / 2);
    float2 angle = percent * PI ;
    float3 circularCoord = float3(sin(angle.x) * sphereRadius, 0, cos(angle.x) * sphereRadius);
    float3 up = float3(0, sphereRadius, 0);
    float3 sphereCoor = cos(angle.y) * circularCoord + sin(angle.y) * up;
    float4 sphereVertex = float4(sphereCoor.xyz, 1);
    return sphereVertex;
}