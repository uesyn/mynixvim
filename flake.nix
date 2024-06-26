{
  description = "Elyth's NeoVim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nixvim.url = "github:nix-community/nixvim";
  };

  outputs = {
    nixpkgs,
    nixvim,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["aarch64-linux" "x86_64-linux" "aarch64-darwin" "x86_64-darwin"];

      perSystem = {
        system,
        pkgs,
        ...
      }: let
        nixvim' = nixvim.legacyPackages.${system};
        nvim-nightly = nixvim'.makeNixvimWithModule {
          pkgs = import nixpkgs {
            inherit system;
            overlays = [inputs.neovim-nightly-overlay.overlay];
          };
          module = ./config;
        };

        nvim = nixvim'.makeNixvimWithModule {
          pkgs = import nixpkgs {
            inherit system;
          };
          module = ./config;
        };
      in {
        formatter = pkgs.alejandra;

        packages.default = nvim;
        packages.nvim = nvim;
        packages.nvim-nightly = nvim-nightly;
      };
    };
}
