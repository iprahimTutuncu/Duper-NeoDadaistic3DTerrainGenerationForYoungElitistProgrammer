#version 330 core

layout (location = 0) in vec3 position;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec2 texel;
layout (location = 3) in vec3 tangent;
layout (location = 4) in vec3 bitangent;

out out_Vertex{
    vec3 position;
    vec3 normal;
    vec2 texel;
    vec4 shadowCoord;
    vec3 tangentLightPosition;
    vec3 tangentViewPosition;
    vec3 tangentFragPosition;
} outVertex;

uniform mat4 model;
uniform mat4 modelView;
uniform mat4 viewProj;
uniform mat4 lightSpaceCoordinate;
uniform sampler2D heightmap;
uniform float terrainWidth;
uniform float terrainHeight;

out float outHeight;

void main()
{
    /*
    mat3 normalMatrix = transpose(inverse(mat3(model)));
    vec3 T = normalize(normalMatrix * aTangent);
    vec3 N = normalize(normalMatrix * aNormal);
    T = normalize(T - dot(T, N) * N);
    vec3 B = cross(N, T);

    mat3 TBN = transpose(mat3(T, B, N));
    vs_out.TangentLightPos = TBN * lightPos;
    vs_out.TangentViewPos  = TBN * viewPos;
    vs_out.TangentFragPos  = TBN * vs_out.FragPos;
*/

    vec3 HMpos = position;
    vec2 uv = vec2(position.x/terrainWidth, position.z/terrainWidth) + 0.5;
    float height = texture(heightmap, uv).r;
    if(height < 0.5f)
        ;//height = 1.0f - height;
    HMpos.y += height * 50.0f;

    // # P.xy store the position for which we want to calculate the normals
      // # height() here is a function that return the height at a point in the terrain

      // read neightbor heights using an arbitrary small offset
      vec3 offset = vec3(1.0/terrainWidth, 1.0/terrainWidth, 0.0);
      float hL = texture(heightmap, uv - offset.xz).g;
      float hR = texture(heightmap, uv + offset.xz).g;
      float hD = texture(heightmap, uv - offset.zy).g;
      float hU = texture(heightmap, uv + offset.zy).g;

      // deduce terrain normal
      vec3 N = vec3(1.0);
      N.x = hL - hR;
      N.y = hD - hU;
      N.z = 2.0;
      N = normalize(N);

    outVertex.position = (model*vec4(HMpos, 1.0f)).xyz;
    outVertex.normal   = mat3(transpose(inverse(model))) * N;
    outVertex.texel    = texel;
    outVertex.shadowCoord = lightSpaceCoordinate * vec4(outVertex.position, 1.0);
    outHeight = height;

    gl_Position = viewProj * model * vec4(HMpos , 1.0f);
}