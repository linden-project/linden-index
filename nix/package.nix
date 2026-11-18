{ lib, buildGoModule, version ? "0.0.0-dev" }:

buildGoModule {
  pname = "lindexer";
  inherit version;

  src = lib.cleanSourceWith {
    src = ../.;
    filter = path: type:
      let base = baseNameOf path; in
      !(lib.elem base [ ".git" ".jj" ".direnv" "result" ".beans" "openspec" "docs" "dist" "testdata-gen" ]);
  };

  vendorHash = "sha256-bJr7Z5q1qDCswS876IjDNxaf3qDcz0I0ScJ/f5w/Buo=";

  subPackages = [ "cmd/lindexer" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/linden-project/linden-index/internal/buildinfo.Version=${version}"
  ];

  doCheck = true;

  meta = {
    description = "Index engine and lindexer CLI for Linny notebooks";
    homepage = "https://github.com/linden-project/linden-index";
    license = lib.licenses.mit;
    mainProgram = "lindexer";
    platforms = lib.platforms.unix;
  };
}
