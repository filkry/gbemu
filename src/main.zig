const std = @import("std");
const z32 = @import("zigwin32");
const z32found = z32.foundation;
const z32window = z32.ui.windows_and_messaging;
const u8to16le = std.unicode.utf8ToUtf16LeStringLiteral;

//pub fn main() !void {
// Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)
// std.debug.print("All your {s} are belong to us.\n", .{"codebase"});

// stdout is for the actual output of your application, for example if you
// are implementing gzip, then only the compressed bytes should be sent to
// stdout, not any debugging messages.
// const stdout_file = std.io.getStdOut().writer();
// var bw = std.io.bufferedWriter(stdout_file);
// const stdout = bw.writer();

// try stdout.print("Run `zig build test` to run the tests.\n", .{});

//try bw.flush(); // Don't forget to flush!
//}

pub export fn wWinMain(
    hInstance: z32found.HINSTANCE,
    _: ?z32found.HINSTANCE,
    _: ?std.os.windows.LPWSTR,
    _: u16, // nCmdShow
) callconv(std.os.windows.WINAPI) i32 {
    const wc = z32window.WNDCLASSEXW{
        .cbSize = @sizeOf(z32window.WNDCLASSEXW),
        .style = std.mem.zeroes(z32window.WNDCLASS_STYLES),
        .lpfnWndProc = WindowProc,
        .cbClsExtra = 0,
        .cbWndExtra = 0,
        .hInstance = hInstance,
        .hIcon = null,
        .hCursor = null,
        .hbrBackground = null,
        .lpszMenuName = null,
        .lpszClassName = u8to16le("Test Window"),
        .hIconSm = null,
    };

    _ = z32window.RegisterClassExW(&wc);

    const hwnd = z32window.CreateWindowExW(
        std.mem.zeroes(z32window.WINDOW_EX_STYLE),
        wc.lpszClassName,
        wc.lpszClassName,
        z32window.WS_OVERLAPPED,
        0,
        0,
        640,
        480,
        null,
        null,
        hInstance,
        null,
    );

    std.log.err("{}", .{hwnd.?});
    if (hwnd) |window| {
        // 2025-02-10: nCmdShow is u16 as called from the zig OS layer, but zigwin32 treats it as a packed u32, so the cast is not safe - for now just use a zeroed-out version
        const fakeShow = std.mem.zeroes(z32window.SHOW_WINDOW_CMD);
        _ = z32window.ShowWindow(window, fakeShow);
        //_ = z32window.MessageBoxW(window, u8to16le("hello"), u8to16le("title"), 0);
    } else {
        const err_code = z32found.GetLastError();
        std.log.err("{}", .{err_code});
    }

    return 0;
}

pub export fn WindowProc(
    hwnd: z32found.HWND,
    uMsg: u32,
    wParam: z32found.WPARAM,
    lParam: z32found.LPARAM,
) callconv(std.os.windows.WINAPI) z32found.LRESULT {
    return z32window.DefWindowProcW(hwnd, uMsg, wParam, lParam);
}
