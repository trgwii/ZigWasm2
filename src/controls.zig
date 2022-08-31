const KeyState = extern struct {
    pressed: bool = false,
    changed: bool = false,
};

pub const Controls = extern struct {
    up: KeyState = KeyState{},
    left: KeyState = KeyState{},
    down: KeyState = KeyState{},
    right: KeyState = KeyState{},
    pub fn direction(self: Controls) @Vector(2, f32) {
        var dir = @Vector(2, f32){
            (@intToFloat(f32, @boolToInt(self.down.pressed)) -
                @intToFloat(f32, @boolToInt(self.up.pressed))),
            (@intToFloat(f32, @boolToInt(self.right.pressed)) -
                @intToFloat(f32, @boolToInt(self.left.pressed))),
        };
        const len = @sqrt(@reduce(.Add, dir * dir));
        if (len != 0) dir /= @splat(2, len);
        return dir;
    }
};

pub var controls = Controls{};

export fn getControls() *anyopaque {
    return &controls;
}
export fn sizeOfControls() u32 {
    return @intCast(u32, @sizeOf(Controls));
}

const expect = @import("std").testing.expect;

test "sizeOf KeyState" {
    comptime {
        try expect(@sizeOf(KeyState) == 2);
    }
}
