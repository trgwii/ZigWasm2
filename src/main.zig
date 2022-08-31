const std = @import("std");

const controller = @import("controls.zig");
const render = @import("render.zig");

const Game = struct {
    pos: @Vector(2, f32) = .{ 100, 100 },
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

export fn updateAndRender(delta: f32) void {
    const dir = controller.controls.direction();
    game.pos += @splat(2, delta * game.speed) * dir;
    game.pos = render.screenRect.subSquare(10).clamp(game.pos);
    render.render();
}
