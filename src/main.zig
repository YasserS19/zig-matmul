const std = @import("std");

pub fn main() !void {
    const n: usize = 512;

    var a: [n][n]f32 = undefined;
    var b: [n][n]f32 = undefined;
    var c: [n][n]f32 = undefined;

    const rand = std.crypto.random;

    for (0..n) |v| {
        for (0..n) |w| {
            a[v][w] = rand.float(f32);
            b[v][w] = rand.float(f32);
        }
    }

    for (0..5) |_| {
        var timer: std.time.Timer = try std.time.Timer.start();
        const start = timer.read();

        for (0..n) |i| {
            for (0..n) |j| {
                var acc: f32 = 0;
                for (0..n) |k| {
                    acc += a[i][k] * b[k][j];
                }

                c[i][j] = acc;
            }
        }

        const flop: f32 = @as(f32, @floatFromInt(2 * n * n * n));
        const end = timer.lap();
        const elapsed: f32 = @as(f32, @floatFromInt(end - start)) * 1e-9;

        std.debug.print("{d:.3} gflop/s", .{(flop / elapsed) * 1e-9});

        if (elapsed > 1) {
            std.debug.print(", {d:.2} s\n", .{elapsed});
        } else {
            std.debug.print(", {d:.2} ms\n", .{elapsed * 1e3});
        }
    }
}
