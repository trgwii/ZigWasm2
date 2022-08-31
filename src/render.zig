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
pub const screenRect = main.Rect.origin(width, height);
pub var screen: [width * height]Pixel = undefined;

export fn getScreen() *anyopaque {
    return &screen;
}
export fn sizeOfScreen() u32 {
    return @intCast(u32, @sizeOf(@TypeOf(screen)));
}
export fn screenWidth() u32 {
    return width;
}
export fn screenHeight() u32 {
    return height;
}

const main = @import("main.zig");

pub fn render() void {
    // Background
    if (width % 4 == 0) {
        var y: u32 = 0;
        while (y < height) : (y += 1) {
            const stride = y * width;
            var x: u32 = 0;
            while (x < width) : (x += 4) {
                screen[stride + x] = Pixel{ .pixel = 0xFF0000FF };
                screen[stride + x + 1] = Pixel{ .pixel = 0xFF0000FF };
                screen[stride + x + 2] = Pixel{ .pixel = 0xFF0000FF };
                screen[stride + x + 3] = Pixel{ .pixel = 0xFF0000FF };
            }
        }
    } else {
        var y: u32 = 0;
        while (y < height) : (y += 1) {
            const stride = y * width;
            var x: u32 = 0;
            while (x < width) : (x += 1) {
                screen[stride + x] = Pixel{ .pixel = 0xFF0000FF };
            }
        }
    }
    {
        const game = main.game;
        // Player
        var y: u32 = @floatToInt(u32, game.pos[0]);
        while (y < @floatToInt(u32, game.pos[0]) + 10) : (y += 1) {
            const stride = y * width;
            var x: u32 = @floatToInt(u32, game.pos[1]);
            while (x < @floatToInt(u32, game.pos[1]) + 10) : (x += 1) {
                screen[stride + x] = Pixel{ .pixel = 0xFFFFFFFF };
            }
        }
    }
}
