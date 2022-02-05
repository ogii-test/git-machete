FROM nixos/nix:2.3.6

RUN nix-env -i git

WORKDIR /root/nixpkgs

RUN git init
RUN git remote add NixOS https://github.com/NixOS/nixpkgs.git
RUN git fetch --depth=1 NixOS master
RUN git checkout -B master NixOS/master

RUN nix-env -i bash curl jq

SHELL ["bash", "-e", "-o", "pipefail", "-u", "-x", "-c"]

ENV VERSION=3.6.1
RUN \
  expression_path=pkgs/applications/version-management/git-and-tools/git-machete/default.nix; \
  sed -i "s/version = \".*\";/version = \"$VERSION\";/" $expression_path; \
  sed -i 's/test "/#&/' $expression_path

RUN nix-build -A gitAndTools.git-machete
