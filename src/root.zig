const std = @import("std");

pub fn readFile(io: std.Io, allocator: std.mem.Allocator, filename: []const u8) !void {
    const cwd = std.Io.Dir.cwd();
    const file = try cwd.openFile(io, filename, .{ .mode = .read_only });
    defer file.close(io);

    const filesize = try file.length(io);
    std.debug.print("file length: {any}\n", .{ filesize });

    const buffer = try allocator.alloc(u8, 8192);
    defer allocator.free(buffer);
    var fr = file.reader(io, buffer);

    const fr_buffer = try allocator.alloc(u8, filesize);
    defer allocator.free(fr_buffer);
    _ = fr.interface.readSliceAll(fr_buffer) catch 0;

    std.debug.print("{s}\n", . { fr_buffer });
}

test "testing file reading" {
    var dbga = std.heap.DebugAllocator(.{}){};
    defer _ = dbga.deinit();
    const allocator = dbga.allocator();

    try readFile(std.testing.io, allocator, "some.txt");
}
