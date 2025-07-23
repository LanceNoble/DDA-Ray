package io.github.some_example_name;

import com.badlogic.gdx.math.Vector2;

public class World {
    private Vector2 spawnPoint;
    private int[][] map;

    public World(int width, int height) {
        map = new int[width][height];
        for (int i = 0; i < map.length; i++) {
            for (int j = 0; j < map.length; j++) {
                if (i == 0 || i == height - 1 || j == 0 || j == width - 1) {
                    map[i][j] = 1;
                } else {
                    map[i][j] = 0;
                }
            }
        }
        map[15][13] = 1;
        map[13][13] = 1;
        map[11][13] = 1;
        map[9][13] = 1;
        map[7][13] = 1;
        map[5][13] = 1;
        map[3][13] = 1;
        map[1][13] = 1;
        spawnPoint = new Vector2((float) (width * 0.5), (float) (height * 0.5));
    }

    public Vector2 GetSpawn() {
        return spawnPoint;
    }

    public Vector2 SpawnRay(Vector2 position, float radians) {
        Vector2 direction = new Vector2((float) Math.cos(radians), (float) Math.sin(radians));

        float distancePerX;
        float xDistance;
        if (direction.x < 0) {
            distancePerX = 1 / direction.x * -1;
            xDistance = (position.x - (int) position.x) * distancePerX;
        } else {
            distancePerX = 1 / direction.x;
            xDistance = ((int) position.x + 1 - position.x) * distancePerX;
        }

        float distancePerY;
        float yDistance;
        if (direction.y < 0) {
            distancePerY = 1 / direction.y * -1;
            yDistance = (position.y - (int) position.y) * distancePerY;
        } else {
            distancePerY = 1 / direction.y;
            yDistance = ((int) position.y + 1 - position.y) * distancePerY;
        }

        Vector2 contact = position.cpy();
        while ((int) (contact.y + direction.y * 0.01) > 0
                && (int) (contact.y + direction.y * 0.01) < this.map.length - 1
                && (int) (contact.x + direction.x * 0.01) > 0
                && (int) (contact.x + direction.x * 0.01) < this.map[0].length - 1
                && this.map[(int) (contact.y + direction.y * 0.01)][(int) contact.x] != 1
                && this.map[(int) contact.y][(int) (contact.x + direction.x * 0.01)] != 1) {

            float rayDistance;
            if (xDistance < yDistance || Float.isInfinite(distancePerY) == true) {
                rayDistance = xDistance;
                xDistance = xDistance + distancePerX;
            } else {
                rayDistance = yDistance;
                yDistance = yDistance + distancePerY;
            }

            contact.x = position.x + direction.x * rayDistance;
            contact.y = position.y + direction.y * rayDistance;
        }

        return contact;
    }
}