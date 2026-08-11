{
  description = "Nix package set for the sandbox image";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "aarch64-linux" ];

      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      pkgsFor = system: import nixpkgs {
        inherit system;
        config.allowUnfreePredicate = pkg:
          builtins.elem (nixpkgs.lib.getName pkg) [ "claude-code" ];
      };
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = pkgsFor system;
        in
        {
          sandbox-tools = pkgs.buildEnv {
            name = "sandbox-tools";

            paths = with pkgs; [
              claude-code
              codex
              pi-coding-agent
              uv
            ];

            pathsToLink = [
              "/bin"
              "/etc"
              "/lib"
              "/share"
            ];
          };

          default = self.packages.${system}.sandbox-tools;
        });
    };
}
