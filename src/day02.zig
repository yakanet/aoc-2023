const std = @import("std");
const expect = @import("std").testing.expect;
const isDigit = @import("std").ascii.isDigit;
const GameArrayList = std.ArrayList(Game);
const SetArrayList = std.ArrayList(Set);

const Game = struct {
    id: u32,
    sets: []Set,
};

const Set = struct {
    red: u32,
    blue: u32,
    green: u32,
};

pub fn main() !void {
    var input = @embedFile("data/day2.txt");
    std.log.info("Part 1 = {}", .{try part1(input)});
    std.log.info("Part 2 = {}", .{try part2(input)});
}

fn part1(input: []const u8) !u32 {
    var sum: u32 = 0;
    const reference = Set{
        .red = 12,
        .green = 13,
        .blue = 14,
    };
    var games = try parseGame(input);
    for (games) |game| {
        if (isPossible(game.sets, reference)) {
            sum += game.id;
        }
    }

    return sum;
}

fn isPossible(from: []Set, compare: Set) bool {
    for (from) |item| {
        if (item.red > compare.red) {
            return false;
        }
        if (item.blue > compare.blue) {
            return false;
        }
        if (item.green > compare.green) {
            return false;
        }
    }
    return true;
}

fn parseGame(input: []const u8) ![]Game {
    const allocator = std.heap.page_allocator;
    var list = GameArrayList.init(allocator);

    var lines = std.mem.split(u8, input, "\n");
    while (lines.next()) |line| {
        var rawParts = std.mem.split(u8, line, ":");
        const id = rawParts.first()[5..];
        var data = rawParts.next().?;
        var datas = std.mem.split(u8, data, ";");
        var setList = SetArrayList.init(allocator);
        while (datas.next()) |rset| {
            var values = std.mem.split(u8, std.mem.trim(u8, rset, " "), ",");
            var set = Set{
                .red = 0,
                .blue = 0,
                .green = 0,
            };
            while (values.next()) |rexpr| {
                var exprs = std.mem.split(u8, std.mem.trim(u8, rexpr, " "), " ");
                while (exprs.next()) |count| {
                    var color = std.mem.trim(u8, exprs.next().?, " ");
                    if (std.mem.eql(u8, color, "red")) {
                        set.red = try std.fmt.parseInt(u8, std.mem.trim(u8, count, " "), 10);
                    } else if (std.mem.eql(u8, color, "blue")) {
                        set.blue = try std.fmt.parseInt(u8, std.mem.trim(u8, count, " "), 10);
                    } else if (std.mem.eql(u8, color, "green")) {
                        set.green = try std.fmt.parseInt(u8, std.mem.trim(u8, count, " "), 10);
                    } else {
                        std.log.err("Unknown color '{s}' on line : {s}", .{ color, line });
                        unreachable;
                    }
                }
            }
            try setList.append(set);
        }
        try list.append(Game{
            .id = try std.fmt.parseInt(u8, id, 10),
            .sets = setList.items,
        });
    }
    return list.items;
}

fn part2(input: []const u8) !u32 {
    var sum: u32 = 0;

    var games = try parseGame(input);
    for (games) |game| {
        var set = minimalRequirements(game.sets);
        sum += set.red * set.blue * set.green;
    }
    return sum;
}

fn minimalRequirements(sets: []Set) Set {
    var result = Set{
        .red = 0,
        .blue = 0,
        .green = 0,
    };
    for (sets) |item| {
        if (item.red > result.red) {
            result.red = item.red;
        }
        if (item.blue > result.blue) {
            result.blue = item.blue;
        }
        if (item.green > result.green) {
            result.green = item.green;
        }
    }

    return result;
}

test "part 1" {
    var input =
        \\Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
        \\Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
        \\Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
        \\Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
        \\Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
    ;
    try expect(try part1(input) == 8);
}

test "part 2" {
    var input =
        \\Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
        \\Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
        \\Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
        \\Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
        \\Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
    ;
    try expect(try part2(input) == 2286);
}
