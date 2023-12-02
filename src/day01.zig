const std = @import("std");
const expect = @import("std").testing.expect;
const isDigit = @import("std").ascii.isDigit;
const IntArrayList = std.ArrayList(u8);

pub fn main() !void {
    var input = @embedFile("data/day1.txt");
    std.log.info("Part 1 = {}", .{try part1(input)});
    std.log.info("Part 2 = {}", .{try part2(input)});
}

fn part1(input: []const u8) !u32 {
    var sum: u32 = 0;
    var lines = std.mem.split(u8, input, "\n");
    while (lines.next()) |line| {
        var numbers = [2]u8{ 0, 0 };
        for (line) |c| {
            if (isDigit(c)) {
                if (numbers[0] == 0) {
                    numbers[0] = c;
                }
                numbers[1] = c;
            }
        }
        sum += try std.fmt.parseInt(u32, &numbers, 10);
    }

    return sum;
}

fn part2(input: []const u8) !i64 {
    const digit_replacements = [_][]const u8{ "zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine" };

    var sum: i64 = 0;
    var lines = std.mem.split(u8, input, "\n");
    while (lines.next()) |line| {
        var i: u8 = 0;
        var numbers = [2]u8{ 0, 0 };
        while (i < line.len) : (i += 1) {
            var c = line[i];
            if (isDigit(c)) {
                if (numbers[0] == 0) {
                    numbers[0] = c;
                }
                numbers[1] = c;
                continue;
            }
            for (digit_replacements, 0..) |name, idx| {
                if (std.mem.startsWith(u8, line[i..], name)) {
                    if (numbers[0] == 0) {
                        numbers[0] = '0' + @as(u8, @truncate(idx));
                    }
                    numbers[1] = '0' + @as(u8, @truncate(idx));
                }
            }
        }

        const number = try std.fmt.parseInt(u32, &numbers, 10);
        std.log.info("Line = {s}, number = {}", .{ line, number });
        sum += number;
    }
    return sum;
}

test "part 1" {
    var input =
        \\1abc2
        \\pqr3stu8vwx
        \\a1b2c3d4e5f
        \\treb7uchet
    ;
    try expect(try part1(input) == 142);
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
    try expect(try part2(input) == 281);
}
