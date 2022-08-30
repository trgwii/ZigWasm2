const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const lib = b.addStaticLibrary("ZigWasm2", "src/main.zig");
    lib.setOutputDir("public/wasm");
    lib.linkage = .dynamic;
    lib.setBuildMode(.Debug);
    lib.setTarget(.{
        .cpu_arch = .wasm32,
        .os_tag = .freestanding,
    });
    lib.install();
}
