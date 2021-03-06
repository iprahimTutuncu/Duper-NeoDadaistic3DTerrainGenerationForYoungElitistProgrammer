#ifndef COLLISIONHANDLER_H
#define COLLISIONHANDLER_H

#include <memory>
#include <unordered_map>
#include "Terrain.h"
#include "MouseRay.h"

struct Ray{
    glm::vec3 direction;
    float length;
    glm::vec3 origin;
};

class CollisionHandler
{
    public:
        CollisionHandler(std::shared_ptr<Camera> camera);
        ~CollisionHandler();
        bool isRayOnTerrain(glm::vec3& intersection);
        bool isRayOnWater(glm::vec3& intersection);
        bool isRayOnMesh();
        bool isRayOnGrass();

        int currGrass();
        int currMesh();

        void setRayDirection(glm::vec3 direction);
        void setRayLength(float length);
        void setRayOrigin(glm::vec3 origin);

        void addMeshPosition(int ID, glm::vec3 position);
        void addGrassPosition(int ID, glm::vec3 position);

        void setWaterLevel(float waterLevel);
        void setTerrain(std::shared_ptr<Terrain> terrain);
        void moveCameraOutOfTerrain();

    private:
        std::shared_ptr<Camera> camera;
        std::unordered_map<int, glm::vec3> meshTerrainPosition;
        std::unordered_map<int, glm::vec3> grassTerrainPosition;
        Ray currRay;
        float waterLevel;

        Grid grid;
        std::shared_ptr<Terrain> terrain;

};

#endif // COLLISIONHANDLER_H
