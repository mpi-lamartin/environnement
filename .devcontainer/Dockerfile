FROM ocaml/opam:debian

RUN opam init && \
    opam update && \
    opam install ocaml-lsp-server ocamlformat dune utop ocamlformat-rpc ppx_inline_test
    
RUN sudo apt-get install -y gdb
