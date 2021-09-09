const std = @import("std");

const Kilobyte = 1024;
const Megabyte = Kilobyte * 1024;

const Line = struct {
    startWhitespace: []const u8,
    line: []const u8,
    eqlPos: ?usize,
};

pub fn main() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    var allocator = &arena.allocator;
    defer arena.deinit();

    var stdinInput = try std.io.getStdIn().reader().readAllAlloc(allocator, 1000 * Megabyte);

    var lines = std.ArrayList(Line).init(allocator);
    var linesIt = std.mem.split(u8, stdinInput, "\n");

    var maxEqlPos: usize = 0;
    while (linesIt.next()) |line| {
        if (line.len > 0) {
            var trimmedLine = std.mem.trim(u8, line, &std.ascii.spaces);
            var whitespace = line[0 .. line.len - trimmedLine.len];

            var insertLine: Line = .{ .startWhitespace = whitespace, .line = trimmedLine, .eqlPos = null };

            if (std.mem.indexOf(u8, trimmedLine, "=")) |eqlPos| {
                insertLine.eqlPos = eqlPos;
                maxEqlPos = std.math.max(maxEqlPos, eqlPos);
            }

            try lines.append(insertLine);
        }
    }

    std.debug.print("lines: length = {}\n", .{lines.items.len});

    const spaces = " " ** 128;

    for (lines.items) |line| {
        if (line.eqlPos) |eqlPos| {
            std.debug.print("{s}{s}{s}{s}\n", .{
                line.startWhitespace,
                line.line[0..eqlPos],
                spaces[0..(maxEqlPos - eqlPos)],
                line.line[eqlPos..],
            });
        } else {
            std.debug.print("{s}{s}\n", .{ line.startWhitespace, line.line });
        }
    }
}
