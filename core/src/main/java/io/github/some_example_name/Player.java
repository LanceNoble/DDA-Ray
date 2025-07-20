package io.github.some_example_name;

import java.util.Vector;

import com.badlogic.gdx.math.Vector2;

public class Player {
    private float x;
    private float y;
    private float viewField;
    private float moveSpeed;
    private float lookSpeed;
    private float lookAngle;

    public Player(float x, float y, float viewField, float moveSpeed, float lookSpeed, float lookAngle) {
        this.x = x;
        this.y = y;
        this.viewField = viewField;
        this.moveSpeed = moveSpeed;
        this.lookSpeed = lookSpeed;
        this.lookAngle = lookAngle;
    }

    public void Turn(boolean directionIsRight) {
        if (directionIsRight == true) {
            this.lookAngle = this.lookAngle - this.lookSpeed;
        } else {
            this.lookAngle = this.lookAngle + this.lookSpeed;
        }
    }

    public void Move(MoveInput combo, World space) {
        Vector2 forward = new Vector2((float)Math.cos(this.lookAngle), (float)Math.sin(lookAngle));
        Vector2 left = new Vector2(-forward.y, forward.x);
        
        Vector2 culmination = new Vector2(0, 0);
        if (combo.IsDown(MoveInput.W)) {
            culmination.add(forward);
        }
        if (combo.IsDown(MoveInput.A)) {
            culmination.add(left);
        }
        if (combo.IsDown(MoveInput.S)) {
            culmination.sub(forward);
        }
        if (combo.IsDown(MoveInput.D)) {
            culmination.sub(left);
        }

        culmination.nor();
        if (culmination.x != 0) {
            Vector2 ray = space.SpawnRay(new Vector2(this.x, this.y), lookAngle);
            // if (culmination.x < 0)
        }
        if (culmination.y != 0) {

        }
    }
}