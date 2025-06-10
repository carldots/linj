{
  description = "Declaring and pinning dependecies for my Python project";

  inputs = {
    # Pinning Python to 3.13.1
    # Source of ref: https://www.nixhub.io/packages/python
    nixpkgs.url = "github:nixos/nixpkgs?ref=50165c4f7eb48ce82bd063e1fb8047a0f515f8ce";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    pkgs = nixpkgs.legacyPackages."x86_64-linux";
  in {
    # A devshell gives you the ability to `nix develop`
    # Enter a code development environment with all your dependencies
    devShells."x86_64-linux".default = pkgs.mkShell {
      packages = [
        pkgs.python3
        # LSP
        pkgs.pyright
        # Automatically pull dependencies when entering project directory
        # Run `direnv allow` first time entering project directory
        pkgs.nix-direnv
        # Pulling Python modules/libraries
        (pkgs.python3.withPackages (python-pkgs: [
          # Fetching from API
          python-pkgs.requests
          # For managing API key auth
          python-pkgs.python-dotenv
          # Is crucial for the script to work, not sure
          python-pkgs.dbus-python
        ]))
      ];
    };
  };
}
