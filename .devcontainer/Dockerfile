# syntax=docker/dockerfile:1
FROM debian:trixie-slim AS ocaml-tools

# OPAM and compilation dependencies are confined to this build stage.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates curl git build-essential ocaml opam pkg-config libgmp-dev \
    && rm -rf /var/lib/apt/lists/*

RUN opam init --bare --disable-sandboxing --no-setup -y \
    && opam switch create /opt/ocaml ocaml-system -y \
    && opam install --switch=/opt/ocaml -y --jobs=2 \
        utop.2.16.0 ocamlformat.0.27.0 ocaml-lsp-server.1.23.1 \
    && opam clean --switch=/opt/ocaml --all-switches --download-cache -y

# Strip only native executables; utop is bytecode and must remain intact.
RUN strip --strip-debug /opt/ocaml/_opam/bin/ocamllsp \
        /opt/ocaml/_opam/bin/ocamlformat /opt/ocaml/_opam/bin/ocamlformat-rpc \
        /opt/ocaml/_opam/bin/dune /opt/ocaml/_opam/bin/ocaml-index

FROM debian:trixie-slim
LABEL org.opencontainers.image.source="https://github.com/mpi-lamartin/environnement"

# libc6-dev is needed for C headers; gcc also brings the sanitizer runtimes.
# Git, SSH, curl and procps support the editor and normal Codespaces usage.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates curl git openssh-client procps sudo \
        gcc libc6-dev gdb make sqlite3 ocaml libgmp10 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && useradd --create-home --uid 1000 --shell /bin/bash vscode \
    && printf 'vscode ALL=(ALL) NOPASSWD:ALL\n' > /etc/sudoers.d/vscode \
    && chmod 0440 /etc/sudoers.d/vscode

# Preserve the installation prefix for findlib/utop, without OPAM, its
# repository, source archives, build directories or compiler duplication.
COPY --from=ocaml-tools /opt/ocaml/_opam/bin/ /opt/ocaml/_opam/bin/
COPY --from=ocaml-tools /opt/ocaml/_opam/lib/ /opt/ocaml/_opam/lib/
COPY --from=ocaml-tools /opt/ocaml/_opam/share/ /opt/ocaml/_opam/share/
ENV PATH="/opt/ocaml/_opam/bin:${PATH}" \
    OCAMLPATH="/opt/ocaml/_opam/lib" \
    CAML_LD_LIBRARY_PATH="/opt/ocaml/_opam/lib/stublibs" \
    LANG=C.UTF-8

COPY terminal-help.sh /etc/mpi-terminal-help.sh
RUN printf '\n. /etc/mpi-terminal-help.sh\n' >> /home/vscode/.bashrc

USER vscode
WORKDIR /home/vscode
CMD ["/bin/bash"]
