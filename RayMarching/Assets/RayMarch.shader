Shader "Unlit/RayMarch"
{
  
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Shape ("shape", Int) = 0
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
            
            #define MAX_STEPS 100
            #define MAX_DIST  100
            #define SURF_DIST 0.001

            //float _Shape; 
            
            float3 _Sphere1_Pos;    // Sphere 오브젝트 월드 위치
            float _Sphere1_R;
            
            float3 _Sphere2_Pos;    // Sphere 오브젝트 월드 위치
            float _Sphere2_R;
            
            int _SerialNum;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 ro :TEXCOORD1;
                float3 hitPos:TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.ro = mul(unity_WorldToObject, float4(_WorldSpaceCameraPos, 1.0f));
                //o.ro =  _WorldSpaceCameraPos;
                //o.hitPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.hitPos = v.vertex;
                return o;
            }
           
              
            float opSoftUnion(float d1, float d2, float k)
            {
                float h = saturate(0.5 + 0.5 * (d2 - d1) / k);
                return lerp(d2, d1, h) - k * h * (1.0 - h);
            }
              
            float GetDist(float3 p) // p는 월드 공간 좌표
            { 
                float distSphere1 = length(p - _Sphere1_Pos) - _Sphere1_R;
                float distSphere2 = length(p - _Sphere2_Pos) - _Sphere2_R;
                
                float dist = min(distSphere1, distSphere2);

                //if(abs(distSphere1 - distSphere2) < 0.01f)
                //    dist = opSoftUnion(distSphere1, distSphere2, (_Sphere2_R + _Sphere1_R) * 0.5f);
 
                return dist;
            }

           

            float3 GetNormal(float3 p) 
            {
                float e = 1e-3;
                
                float3 normal = float3(GetDist(p) - GetDist(p - float3(e,0,0)),
                                GetDist(p) - GetDist(p - float3(0,e,0)),
                                GetDist(p) - GetDist(p - float3(0,0,e)));

                return normalize(normal); 
            }


            float RayMarching(float3 o, float3 dir)
            {
                float totalT  = 0.0;
                float t = 0.0;

                for(int i = 0; i < MAX_STEPS; i++)
                {
                    t = GetDist(o);
                    totalT += t;

                    if( t < SURF_DIST || t > MAX_DIST) break;
                    
                    o = o + dir  * t;
                }

                return totalT;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texturez
                float2 uv = i.uv * 2.0 - 1;
                    
                float3 ro = i.ro;//  float3(0,0, -3);
                float3 dir = normalize(i.hitPos - ro);//normalize(float3(uv, 1));

                float t = RayMarching(ro, dir);

                fixed4 texCol = tex2D(_MainTex ,i.uv);
                float m = dot(uv, uv);

                fixed4 col = 0;
                if(t < MAX_DIST)
                {
                    float3 p = ro + dir * t;
                    float3 normal = GetNormal(p);
                    col.xyz= normal;

                }
                else discard;
                return col;
            }
            ENDCG
        }
    }
}
