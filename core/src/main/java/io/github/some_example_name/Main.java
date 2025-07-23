package io.github.some_example_name;

import com.badlogic.gdx.ApplicationAdapter;
import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.Input;
import com.badlogic.gdx.graphics.glutils.ShapeRenderer;
import com.badlogic.gdx.graphics.glutils.ShapeRenderer.ShapeType;
import com.badlogic.gdx.utils.ScreenUtils;

/**
 * {@link com.badlogic.gdx.ApplicationListener} implementation shared by all
 * platforms.
 */
public class Main extends ApplicationAdapter {
    private ShapeRenderer shape;
    private World world1;
    private Player player1;

    @Override
    public void create() {
        this.shape = new ShapeRenderer();
        this.world1 = new World(20, 20);
        this.player1 = new Player((float) .25, (float) (Math.PI * 0.5), (float) 0.025, 0, world1);
    }

    @Override
    public void render() {
        if (Gdx.input.isKeyPressed(Input.Keys.J)) {
            this.player1.Turn(false);
        }
        if (Gdx.input.isKeyPressed(Input.Keys.L)) {
            this.player1.Turn(true);
        }

        byte input = 0b00000000;
        if (Gdx.input.isKeyPressed(Input.Keys.W)) {
            input = (byte) (input | 0b00000001);
        }
        if (Gdx.input.isKeyPressed(Input.Keys.A)) {
            input = (byte) (input | 0b00000010);
        }
        if (Gdx.input.isKeyPressed(Input.Keys.S)) {
            input = (byte) (input | 0b00000100);
        }
        if (Gdx.input.isKeyPressed(Input.Keys.D)) {
            input = (byte) (input | 0b00001000);
        }
        player1.Move(input);

        ScreenUtils.clear(0.15f, 0.15f, 0.2f, 1f);
        this.shape.begin(ShapeType.Filled);
        float[] rays = player1.Look();
        for (int i = 0; i < rays.length; i++) {
            float height = Gdx.graphics.getHeight() / rays[i];
            float columnWidth = Gdx.graphics.getWidth() / rays.length;
            float screenCenterY = Gdx.graphics.getHeight() * (float) .5;
            float shade = 1 / rays[i];
            this.shape.setColor(shade, shade, shade, 1);
            this.shape.rect(i * columnWidth, screenCenterY - height * (float) .5, columnWidth, height);
        }
        this.shape.end();
    }

    @Override
    public void dispose() {
        this.shape.dispose();
    }
}