# Quick start

Align is a basic cli utility to align code.
Right now only aligment up to a `=` is done.

It's a stupid utility meant to be used with _Vim_ and is aiming to replace `column`.

## Dependencies

You need the newst zig binary to be able to it - I myself built it with 0.9.0-dev.852+8c41a8e76.

# Compilation
`zig build-exe align.zig -O ReleaseFast --strip --single-threaded`
