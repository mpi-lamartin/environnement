FROM ocaml/opam:debian

RUN opam init && \
    # opam update && \
    opam install ocaml-lsp-server utop ocamlformat ocamlformat-rpc
    
RUN sudo apt-get install -y gdb
