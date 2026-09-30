#!/bin/sh
# Run as the normal Codespaces user before publishing an image.
set -eu
for tool in gcc gdb make sqlite3 ocaml ocamlc ocamlopt utop ocamlformat ocamlformat-rpc ocamllsp git; do
    command -v "$tool"
done
if command -v opam; then
    echo "OPAM must not be present in the runtime image" >&2
    exit 1
fi
test "$(id -u)" -ne 0
test -w "$HOME"

tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' EXIT
cd "$tmp_dir"
printf '#include <stdio.h>\nint main(void) { puts("C OK"); return 0; }\n' > test.c
printf 'all:\n\tgcc -g -Wall -Wextra -fsanitize=address,undefined test.c -o test-c\n' > Makefile
make
./test-c
gdb --batch -ex 'file test-c' -ex 'info functions main'
test "$(sqlite3 :memory: 'select 6 * 7;')" = 42
printf 'let () = print_endline "OCaml OK"\n' > test.ml
ocaml test.ml
ocamlc test.ml -o test-bytecode
./test-bytecode
ocamlopt test.ml -o test-native
./test-native
printf 'print_endline "utop OK";;\n' | utop -init /dev/null -stdin
ocamlformat --enable-outside-detected-project --impl test.ml > formatted.ml
ocamlc formatted.ml -o test-formatted
./test-formatted
ocamllsp --version
bash -ic ':' 2>&1 | grep -F 'Compiler test.ml et exécuter'
