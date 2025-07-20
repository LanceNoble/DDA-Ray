package io.github.some_example_name;

import com.badlogic.gdx.math.Vector2;

public class Player {
    private float moveSpeed;
    private float viewField;
    private float lookSpeed;
    private float lookAngle;
    private World space;
    private Vector2 position;
    private float[] rays;

    public Player(float moveSpeed, float viewField, float lookSpeed, float lookAngle, World space) {
        this.moveSpeed = moveSpeed;
        this.viewField = viewField;
        this.lookSpeed = lookSpeed;
        this.lookAngle = lookAngle;
        this.space = space;
        this.position = space.GetSpawn();
        this.rays = new float[1920];
        for (int i = 0; i < rays.length; i++) {
            this.rays[i] = 0;
        }
    }

    public void Turn(boolean directionIsRight) {
        if (directionIsRight == false) {
            this.lookAngle = this.lookAngle - this.lookSpeed;
        } else {
            this.lookAngle = this.lookAngle + this.lookSpeed;
        }
    }

    public void Move(byte input) {
        Vector2 forward = new Vector2((float) Math.cos(this.lookAngle), (float) Math.sin(this.lookAngle));
        Vector2 left = new Vector2(-forward.y, forward.x);

        Vector2 culmination = new Vector2(0, 0);
        if ((input & 0b00000001) == 0b00000001) {
            culmination.add(forward);
        }
        if ((input & 0b00000010) == 0b00000010) {
            culmination.sub(left);
        }
        if ((input & 0b00000100) == 0b00000100) {
            culmination.sub(forward);
        }
        if ((input & 0b00001000) == 0b00001000) {
            culmination.add(left);
        }

        culmination.nor();
        if (culmination.x != 0) {
            Vector2 end;
            if (culmination.x < 0) {
                end = this.space.SpawnRay(this.position, (float) Math.PI);
            } else {
                end = this.space.SpawnRay(this.position, 0);
            }
            if (this.position.dst(end) < Math.abs(culmination.x * this.moveSpeed)) {
                if (culmination.x < 0) {
                    this.position.x = end.x + (float) 0.01;
                } else {
                    this.position.x = end.x - (float) 0.01;
                }
            } else {
                this.position.x = this.position.x + culmination.x * this.moveSpeed;
            }
        }
        if (culmination.y != 0) {
            Vector2 end;
            if (culmination.y < 0) {
                end = this.space.SpawnRay(this.position, (float) (Math.PI * 1.5));
            } else {
                end = this.space.SpawnRay(this.position, (float) (Math.PI * 0.5));
            }
            if (this.position.dst(end) < Math.abs(culmination.y * this.moveSpeed)) {
                if (culmination.y < 0) {
                    this.position.y = end.y + (float) 0.01;
                } else {
                    this.position.y = end.y - (float) 0.01;
                }
            } else {
                this.position.y = this.position.y + culmination.y * this.moveSpeed;
            }
        }
    }

    public float[] Look() {
        int halfScreen = (int) (rays.length * 0.5);
        float halfView = this.viewField * (float) 0.5;
        for (int i = 0; i < halfScreen; i++) {
            float angle = (float) Math.atan(Math.sin(halfView) / halfScreen * i / Math.cos(halfView));
            Vector2 west = this.space.SpawnRay(this.position, this.lookAngle - angle);
            Vector2 east = this.space.SpawnRay(this.position, this.lookAngle + angle);
            this.rays[halfScreen - i] = this.position.dst(west) * (float) Math.cos(angle);
            this.rays[halfScreen + i] = this.position.dst(east) * (float) Math.cos(angle);
        }
        return this.rays;
    }
}