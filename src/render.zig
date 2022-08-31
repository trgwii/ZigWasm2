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
const std = @import("std");

pub fn render(rects: []const main.ColoredRect) void {
    for (rects) |rect| {
        const ry = @floatToInt(u32, rect.rect.v[0]);
        const rx = @floatToInt(u32, rect.rect.v[1]);
        const rh = @floatToInt(u32, rect.rect.v[2]);
        const rw = @floatToInt(u32, rect.rect.v[3]);
        const yMax = ry + rh;
        const xMax = rx + rw;
        var y: u32 = ry;
        while (y < yMax) : (y += 1) {
            const stride = y * width;
            var x: u32 = rx;
            while (x < xMax) : (x += 1) {
                const i = stride + x;
                if (i >= screen.len) break;
                screen[i] = Pixel{ .pixel = rect.color };
            }
        }
    }
}
