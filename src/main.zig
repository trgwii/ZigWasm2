const controls = @import("controls.zig");
const render = @import("render.zig");

export fn updateAndRender(delta: f64) void {
    _ = delta;
    render.render();
}

const std = @import("std");
