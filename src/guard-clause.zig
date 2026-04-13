/// Guard clauses are a great way to improve readability. This reduces the number of level of nesting by inverting the
/// condition and returning early

const std = @import("std");

/// Idiomatic way to do a guard clause in zig for early return on optional
pub fn guardAgainstOptional(num: ?u32) void {
    const my_mandatory_number = num orelse return;
    std.debug.print("My number is {d}\n", .{ my_mandatory_number });
}

/// What if I wanted to do something in the null branching path?
/// We can use blocks since they are expressions
pub fn guardAgainstOptionalWithBranchingLogic(num: ?u32) void {
    const my_mandatory_number = num orelse {
        std.debug.print("My number is optional sadge :(\n", .{});
        return;
    };
    std.debug.print("My number is {d}\n", .{ my_mandatory_number });
}

test {
    const optional_num: ?u32 = null;
    const my_num: ?u32 = 42;

    guardAgainstOptional(optional_num);
    guardAgainstOptional(my_num);

    guardAgainstOptionalWithBranchingLogic(optional_num);
    guardAgainstOptionalWithBranchingLogic(my_num);
}
