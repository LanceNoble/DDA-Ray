package io.github.some_example_name;

import com.badlogic.gdx.Input;

public enum MoveInput {
    W(Input.Keys.W),
    A(Input.Keys.A),
    S(Input.Keys.S),
    D(Input.Keys.D);

    private int code;

    MoveInput(int code) {
        this.code = code;
    }

    public int GetCode() {
        return this.code;
    }

    public void Add(MoveInput input) {
        this.code |= input.GetCode();
    }

    public boolean IsDown(MoveInput input) {
        return (this.code & input.GetCode()) == input.GetCode();
    }
}