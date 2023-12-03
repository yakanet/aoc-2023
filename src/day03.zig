const std = @import("std");
const expect = @import("std").testing.expect;
const isDigit = @import("std").ascii.isDigit;
const IndexedGrid = std.AutoArrayHashMap(Point, Token);

const Point = struct { x: usize, y: usize };
const TokenType = enum { Number, Symbol };
const Token = union(TokenType) {
    Number: struct { value: u32, visited: bool, size: usize },
    Symbol: struct { value: u8 },
};

pub fn main() !void {
    //const input = @embedFile("data/day03.txt");
    const input =
        \\467..114..
        \\...*......
        \\..35..633.
        \\......#...
        \\617*......
        \\.....+.58.
        \\..592.....
        \\......755.
        \\...$.*....
        \\.664.598..
    ;
    std.log.info("Part 1 = {}", .{try part1(input)});
    std.log.info("Part 2 = {}", .{try part2(input)});
}

fn part1(input: []const u8) !u32 {
    var grid = try indexGrid(input);
    defer grid.deinit();
    var sum: u32 = 0;
    var row: usize = 0;
    _ = row;
    var col: usize = 0;
    _ = col;
    var i: usize = 0;
    _ = i;
    var items = grid.iterator();
    while (items.next()) |item| {
        switch (item.value_ptr.*) {
            .Symbol => {
                //std.log.debug("Symbol {} at {}x{}", .{ item, col, row });
                const xSym = @field(item.key_ptr.*, "x");
                const ySym = @field(item.key_ptr.*, "y");
                for ((xSym - 1)..(xSym + 2)) |x| { // no included range for max value
                    for ((ySym - 1)..(ySym + 2)) |y| {
                        var point = grid.get(Point{ .x = x, .y = y }) orelse continue;
                        switch (point) {
                            .Number => |number| {
                                if (!number.visited) {
                                    // has to do this weird trick as number is a const
                                    @field(point.Number, "visited") = true;
                                    sum += number.value;
                                }
                            },
                            else => {},
                        }
                    }
                }
            },
            else => {},
        }
    }

    //while (i < input.len) : (i += 1) {
    //    if (input[i] == '\n') {
    //        row += 1;
    //        col = 0;
    //        continue;
    //    }
    //    if (grid.get(Point{ .x = col, .y = row })) |index| {
    //        switch (index) {
    //            .Symbol => {
    //                std.log.debug("Symbol {} at {}x{}", .{ index, col, row });
    //
    //                for ((col - 1)..(col + 2)) |x| {
    //                    for ((row - 1)..(row + 2)) |y| {
    //                        if (grid.get(Point{ .x = x, .y = y })) |idx| {
    //                            switch (idx) {
    //                                .Number => |value| {
    //                                    if (!value.visited[0]) {
    //                                        std.log.debug("Number {} at {}x{}", .{ value.value, y, x });
    //                                        value.visited[0] = true;
    //                                        sum += value.value;
    //                                    }
    //                                },
    //                                else => {},
    //                            }
    //                        }
    //                    }
    //                }
    //            },
    //            else => {},
    //        }
    //    }
    //    col += 1;
    //}
    return sum;
}

fn part2(input: []const u8) !u32 {
    _ = input;

    var sum: u32 = 0;

    return sum;
}

fn indexGrid(input: []const u8) !IndexedGrid {
    var map = IndexedGrid.init(std.heap.page_allocator);

    var row: usize = 0;
    var col: usize = 0;
    var i: usize = 0;
    while (i < input.len) : (i += 1) {
        const c = input[i];
        switch (c) {
            '0'...'9' => {
                var start = i;
                while (std.ascii.isDigit(input[i])) {
                    i += 1;
                }
                var token = Token{
                    .Number = .{
                        .value = try std.fmt.parseInt(u32, input[start..i], 10),
                        .visited = false,
                        .size = i - start,
                    },
                };

                for (start..i) |_| {
                    //std.log.debug("{}-{}: {}", .{ row, col, token.Number });
                    try map.putNoClobber(Point{ .x = col, .y = row }, &token);
                    col += 1;
                }
            },
            '\n' => {
                row += 1;
                col = 0;
                continue;
            },
            '.' => {},
            else => {
                try map.put(Point{ .x = col, .y = row }, &Token{ .Symbol = .{ .value = c } });
            },
        }
        col += 1;
    }
    return map;
}

test "part 1" {
    var input =
        \\467..114..
        \\...*......
        \\..35..633.
        \\......#...
        \\617*......
        \\.....+.58.
        \\..592.....
        \\......755.
        \\...$.*....
        \\.664.598..
    ;
    try expect(try part1(input) == 4361);
}

test "part 2" {
    var input =
        \\two1nine
        \\eightwothree
        \\abcone2threexyz
        \\xtwone3four
        \\4nineeightseven2
        \\zoneight234
        \\7pqrstsixteen
    ;
    try expect(try part2(input) == 0);
}
