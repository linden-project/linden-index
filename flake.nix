{
  description = "linden-index — the index engine and lindexer CLI for Linny notebooks";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      version = nixpkgs.lib.fileContents ./VERSION;

      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];

      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);

      nixpkgsFor = forAllSystems (system: import nixpkgs {
        inherit system;
        overlays = [ self.overlays.default ];
      });

      hasGo = builtins.pathExists ./go.mod;
    in
    {
      overlays.default = final: _prev: {
        lindexer = final.callPackage ./nix/package.nix { inherit version; };
      };

      packages = forAllSystems (system:
        let pkgs = nixpkgsFor.${system}; in
        nixpkgs.lib.optionalAttrs hasGo {
          lindexer = pkgs.lindexer;
          default = pkgs.lindexer;
        });

      devShells = forAllSystems (system:
        let pkgs = nixpkgsFor.${system}; in {
          default = pkgs.mkShell {
            packages = [
              pkgs.go
              pkgs.gopls
              pkgs.golangci-lint
              pkgs.git
              pkgs.hugo
              pkgs.goreleaser
              pkgs.gh
            ];
          };
        });

      checks = forAllSystems (system:
        let pkgs = nixpkgsFor.${system}; in
        nixpkgs.lib.optionalAttrs hasGo {
          gotest = pkgs.lindexer;

          lint = pkgs.lindexer.overrideAttrs (old: {
            pname = "lindexer-lint";
            nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.golangci-lint ];
            doCheck = false;
            buildPhase = ''
              runHook preBuild
              export GOLANGCI_LINT_CACHE="$TMPDIR/golangci-cache"
              golangci-lint run ./...
              runHook postBuild
            '';
            installPhase = ''
              mkdir -p "$out"
              touch "$out/lint-ok"
            '';
          });

          coverage = pkgs.lindexer.overrideAttrs (old: {
            pname = "lindexer-coverage";
            nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.git pkgs.hugo ];
            doCheck = false;
            buildPhase = ''
              runHook preBuild
              export HOME="$TMPDIR"
              go test ./... -coverpkg=./... -covermode=atomic -coverprofile=cover.out
              total=$(go tool cover -func=cover.out | awk '/^total:/ { gsub("%","",$3); print $3 }')
              echo "total statement coverage: $total% (floor 70%)"
              awk -v t="$total" 'BEGIN { if (t+0 < 70.0) { printf "FAIL: total coverage %s%% is below the 70%% gate\n", t; exit 1 } }'

              echo "core package coverage (floor 80%):"
              core="index"
              coreFail=0
              for p in $core; do
                pct=$(go test ./$p/ -cover 2>/dev/null | sed -n 's/.*coverage: \([0-9.]*\)%.*/\1/p')
                printf '  %s: %s%%\n' "$p" "''${pct:-0}"
                if ! awk -v c="''${pct:-0}" 'BEGIN { exit (c+0 < 80.0) }'; then
                  echo "  FAIL: $p is below the 80% core floor"
                  coreFail=1
                fi
              done
              [ "$coreFail" = 0 ] || exit 1
              runHook postBuild
            '';
            installPhase = ''
              mkdir -p "$out"
              cp cover.out "$out/cover.out"
            '';
          });
        });

      formatter = forAllSystems (system: nixpkgsFor.${system}.nixpkgs-fmt);
    };
}
