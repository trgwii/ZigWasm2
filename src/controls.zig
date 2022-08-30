const KeyState = extern struct {
    pressed: bool = false,
    changed: bool = false,
};

pub const Controls = extern struct {
    up: KeyState,
    left: KeyState,
    down: KeyState,
    right: KeyState,
};

pub var controls = Controls{};

export fn getControls() *anyopaque {
    _ = controls;
    return &controls;
}

const expect = @import("std").testing.expect;

test "sizeOf KeyState" {
    comptime {
        try expect(@sizeOf(KeyState) == 2);
    }
}
