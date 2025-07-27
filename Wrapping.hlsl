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
    float radius = worldPoint.z;
    float2 circularCoord = float2(sin(angle), cos(angle)) * radius;
    float4 cylinderVertex = float4(circularCoord.x,worldPoint.y, circularCoord.y, 1);
    return cylinderVertex;
}