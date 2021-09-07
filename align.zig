const std = @import("std");

const Kilobyte = 1024;
const Megabyte = Kilobyte * 1024;

const EqlLine = struct {
  startWhitespace: []const u8,
  line: []const u8,
  eqlPos: usize,
};

pub fn main() anyerror!void {
  var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
  var allocator = &arena.allocator;

  var stdinInput = try std.io.getStdIn().reader().readAllAlloc(allocator, 10 * Megabyte);

  var eqlLines = std.ArrayList(EqlLine).init(allocator);
  var linesIt = std.mem.split(u8, stdinInput, "\n");

  var maxEqlPos: usize = 0;
  while(linesIt.next()) | line | {
    var trimmedLine = std.mem.trimLeft(u8, line, &std.ascii.spaces);
    var whitespace = line[0..line.len - trimmedLine.len];

    if(std.mem.indexOf(u8, trimmedLine, "=")) | eqlPos | {
      try eqlLines.append(.{ .startWhitespace = whitespace, .line = trimmedLine, .eqlPos = eqlPos });
      maxEqlPos = std.math.max(maxEqlPos, eqlPos);
    }
  }

  const spaces = " "**128;

  for(eqlLines.items) | eqlLine | {
    // std.log.debug("Line {d}[{d}]:{s}", .{ eqlLine.eqlPos, maxEqlPos, eqlLine.line });
    std.debug.print("{s}{s}{s}{s}\n", .{
        eqlLine.startWhitespace,
        eqlLine.line[0..eqlLine.eqlPos],
        spaces[0..(maxEqlPos-eqlLine.eqlPos)],
        eqlLine.line[eqlLine.eqlPos..],
    });
  }
}
