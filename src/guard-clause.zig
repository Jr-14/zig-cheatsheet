/// Guard clauses are a great way to improve readability. This reduces the number of level of nesting by inverting the
/// condition and returning early

const std = @import("std");

pub fn guardAgainstOptional(num: ?u32) void {
    // Idiomatic way to do a guard clause in zig for early return on optional
    const my_mandator_number = num orelse return;
    std.debug.print("My number is {d}\n", .{ my_mandator_number });
}

test "guardAgainstOptional" {
    const optional_num: ?u32 = null;
    const my_num: ?u32 = 42;

    guardAgainstOptional(optional_num);
    guardAgainstOptional(my_num);
}
