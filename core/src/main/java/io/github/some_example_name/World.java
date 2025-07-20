package io.github.some_example_name;

import com.badlogic.gdx.math.Vector2;

public class World {
    private int[][] map;

    public World(int width, int height) {
        map = new int[width][height];
        for (int i = 0; i < map.length; i++) {
            for (int j = 0; j < map.length; j++) {
                if (i == 0 || i == height || j == 0 || j == width) {
                    map[i][j] = 1;
                } else {
                    map[i][j] = 0;
                }
            }
        }
    }

    public Vector2 SpawnRay(Vector2 position, float radians) {
        Vector2 direction = new Vector2((float) Math.cos(radians), (float) Math.sin(radians));

        float distancePerX = 1 / Math.abs(direction.x);
        float distancePerY = 1 / Math.abs(direction.y);

        float xDistance;
        if (direction.x < 0) {
            xDistance = (position.x - (float) Math.floor(position.x)) * distancePerX;
        } else {
            xDistance = ((float) Math.ceil(position.x) - position.x) * distancePerX;
        }

        float yDistance;
        if (direction.y < 0) {
            yDistance = (position.y - (float) Math.floor(position.y)) * distancePerY;
        } else {
            yDistance = ((float) Math.ceil(position.y) - position.y) * distancePerY;
        }

        boolean hit = false;
        float rayDistance = 0;
        while (hit != false) {
            if (xDistance < yDistance || Float.isInfinite(distancePerY) == true) {
                rayDistance = xDistance;
                xDistance = xDistance + distancePerX;
            } else {
                rayDistance = yDistance;
                yDistance = yDistance + distancePerY;
            }

            Vector2 foo = new Vector2(position).mulAdd(direction, rayDistance + (float) .2);
            Vector2 bar = new Vector2(position).mulAdd(direction, rayDistance);

            if (foo.y < 1 || foo.y > map.length || foo.x < 1 || foo.x > map[0].length
                    || map[(int) foo.y][(int) bar.x] == 1 || map[(int) bar.y][(int) foo.x] == 1) {
                hit = true;
            }
        }

        return new Vector2(direction.x * rayDistance, direction.y * rayDistance);
    }
}
