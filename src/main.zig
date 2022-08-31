const std = @import("std");

const controller = @import("controls.zig");
const render = @import("render.zig");

extern fn _print(ptr: [*]const u8, len: u32) void;
pub fn print(comptime fmt: []const u8, args: anytype) void {
    var buf: [1024]u8 = undefined;
    const slice = std.fmt.bufPrint(&buf, fmt, args) catch unreachable;
    _print(slice.ptr, @intCast(u32, slice.len));
}

pub fn panic(msg: []const u8, stack: ?*std.builtin.StackTrace) noreturn {
    print("{s}", .{msg});
    var buf: [16384]u8 = undefined;
    var stream = std.io.fixedBufferStream(&buf);
    const writer = stream.writer();
    if (stack) |s| {
        s.format("{}", .{}, writer) catch unreachable;
    }
    print("{s}", .{buf[0..writer.context.pos]});
    unreachable;
}

const Game = struct {
    pos: @Vector(2, f32) = .{ 100, 100 },
    enemies: [10]@Vector(2, f32) = [_]@Vector(2, f32){
        .{ 200, 300 },
        .{ 300, 200 },
        .{ 150, 300 },
        .{ 300, 150 },
        .{ 350, 300 },
        .{ 300, 350 },
        .{ 400, 300 },
        .{ 300, 400 },
        .{ 300, 300 },
        .{ 300, 300 },
    },
    speed: f32 = 200,
};

pub var game = Game{};

pub const Rect = struct {
    v: @Vector(4, f32),
    pub fn origin(w: f32, h: f32) Rect {
        return Rect{ .v = .{ 0, 0, h, w } };
    }
    pub fn create(x: f32, y: f32, w: f32, h: f32) Rect {
        return Rect{ .v = .{ y, x, h, w } };
    }
    pub fn subSquare(self: Rect, s: f32) Rect {
        return Rect.create(self.v[1], self.v[0], self.v[3] - s, self.v[2] - s);
    }
    pub fn clamp(self: Rect, _v: @Vector(2, f32)) @Vector(2, f32) {
        var v = _v;
        if (v[0] < self.v[0]) v[0] = self.v[0];
        if (v[1] < self.v[1]) v[1] = self.v[1];
        if (v[0] > self.v[2]) v[0] = self.v[2];
        if (v[1] > self.v[3]) v[1] = self.v[3];
        return v;
    }
};

pub const ColoredRect = struct {
    color: u32,
    rect: Rect,
};

var entities: [256]ColoredRect = undefined;

fn flip(x: f32) f32 {
    return if (x < 0) -x else x;
}

export fn updateAndRender(delta: f32) void {
    const dir = controller.controls.direction();
    game.pos += @splat(2, delta * game.speed) * dir;
    game.pos = render.screenRect.subSquare(10).clamp(game.pos);
    for (game.enemies) |*enemy| {
        if (flip(enemy.*[0] - game.pos[0]) > flip(enemy.*[1] - game.pos[1])) {
            enemy.*[0] += if (game.pos[0] < enemy.*[0]) -1 else 1;
        } else {
            enemy.*[1] += if (game.pos[1] < enemy.*[1]) -1 else 1;
        }
    }

    entities[0].color = 0xFF0000FF;
    entities[0].rect = render.screenRect;
    entities[1].color = 0xFFFFFFFF;
    entities[1].rect = Rect.create(game.pos[1], game.pos[0], 10, 10);
    for (entities[2..12]) |*entity, i| {
        entity.color = 0xFFFF0000;
        entity.rect = Rect.create(game.enemies[i][1], game.enemies[i][0], 20, 20);
    }
    render.render(entities[0..13]);
}
