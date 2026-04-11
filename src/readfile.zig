const std = @import("std");

/// Reading a file using a std.Io interface, with a std.mem.Allocator interface
/// This reads the entire contents of the file into memory.
pub fn readFile(io: std.Io, allocator: std.mem.Allocator, filename: []const u8) !void {
    // Use the cwd of the process to read from file
    const cwd = std.Io.Dir.cwd();
    const file = try cwd.openFile(io, filename, .{ .mode = .read_only });
    defer file.close(io);

    const filesize = try file.length(io);
    std.debug.print("file length: {any}\n", .{ filesize });

    // Heap allocated []u8 can be used as a buffer
    const buffer = try allocator.alloc(u8, 4096);
    defer allocator.free(buffer);
    var fr = file.reader(io, buffer);

    // []u8 defined on the stack can also be used, but we'd need to pass a pointer
    // to the buffer and the buffer must also be mutable.
    // var buffer: [4096]u8 = undefined;
    // var fr = file.reader(io, &buffer);

    const fr_buffer = try allocator.alloc(u8, filesize);
    defer allocator.free(fr_buffer);
    fr.interface.readSliceAll(fr_buffer) catch |err| {
        std.log.err("read failed: {}", .{ err });
    };

    std.debug.print("{s}\n", . { fr_buffer });
}

test "testing file reading" {
    // var dbga = std.heap.DebugAllocator(.{}){};
    // defer _ = dbga.deinit();
    // const allocator = dbga.allocator();

    var threaded: std.Io.Threaded = .init_single_threaded;
    const io = threaded.io();

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    try readFile(io, allocator, "some.txt");
}
