Shader "Unlit/CubeShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _WorldWidth ("World Width", float) = 1
        _Whr ("Widht Height ratio", Range(0, 1)) = 0.5
        _MapDepth ("Map Depth", float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float4 color : TEXCOORD1;
            };

            struct CubeConversionInfo
            {
                float width;
                float height;
                float4 points;
            };
            
            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _WorldWidth;
            float _Whr;
            float _MapDepth;

            void computeCubeInfo(inout CubeConversionInfo cubeInfo)
            {
                cubeInfo.width = _WorldWidth / (2 + _Whr);
                cubeInfo.height = cubeInfo.width * _Whr;

                float p0 = 0;
                float p1 = cubeInfo.width;
                float p2 = p1 + cubeInfo.height;
                float p3 = p2 + cubeInfo.width;
                
                cubeInfo.points = float4(p0, p1, p2, p3);
            }

            float getPointRatio(float p, int index, in CubeConversionInfo cubeInfo)
            {
                return saturate((p - cubeInfo.points[index]) / (cubeInfo.points[index + 1] - cubeInfo.points[index]));
            }

            float4 cube_projection(float4 world_point, out float4 color)
            {
                CubeConversionInfo cubeInfo;
                computeCubeInfo(cubeInfo);

                // float original_depth = _MapDepth - world_point;
                float4 world_proj_point = float4(world_point.xy, _MapDepth, world_point.w);
                float p = abs(world_proj_point.x);
                float sign = p / world_proj_point.x;
                color = float4(saturate(p / _WorldWidth), 0, 0, 1);
                float3 ratio = float3(getPointRatio(p, 0, cubeInfo), getPointRatio(p, 1, cubeInfo), getPointRatio(p, 2, cubeInfo));
                // float4 displace = float4(cubeInfo.width * ratio.x - cubeInfo.width * ratio.z, 0, _MapDepth - cubeInfo.height * ratio.y, world_proj_point.w);
                float4 displace = float4(cubeInfo.width * (ratio.x - ratio.z) * sign, world_point.y, _MapDepth - cubeInfo.height * ratio.y, world_proj_point.w);
                return displace;
            }

            v2f vert (appdata v)
            {
                v2f o;
                float4 world_point = mul(unity_ObjectToWorld, v.vertex);
                float4 cproj = cube_projection(world_point, o.color);
                o.vertex = mul(UNITY_MATRIX_VP, cproj);
                // o.vertex = mul(UNITY_MATRIX_VP, world_point);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return i.color;
            }
            ENDCG
        }
    }
}
