pub const Pixel = extern union {
    pixel: u32,
    color: extern struct {
        r: u8,
        g: u8,
        b: u8,
        a: u8,
    },
    colors: [4]u8,
};

const expect = @import("std").testing.expect;
test "sizeOf pixel" {
    comptime {
        try expect(@sizeOf(Pixel) == 4);
    }
}

pub const width = 960;
pub const height = 540;
pub var screen: [width * height]Pixel = undefined;

export fn getScreen() *anyopaque {
    return &screen;
}

pub fn render() void {
    var y: u32 = 0;
    while (y < height) : (y += 1) {
        const stride = y * width;
        var x: u32 = 0;
        while (x < width) : (x += 1) {
            screen[stride + x] = Pixel{ .pixel = 0xFF0000FF };
        }
    }
}
