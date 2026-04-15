{
  description = "LaTeX Document Demo";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
      ];
      forAllSystems = with nixpkgs; (lib.genAttrs supportedSystems);
      pname = "paper";
      texPackages =
        ps: with ps; [
          latexmk
          luavlna
          microtype
          polyglossia
          hyphen-polish # fixes line-break issues from polyglossia
          titling
          listings
          titlesec
          hyperref
          geometry
          fontspec
          xifthen
        ];
    in
    rec {
      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          tex = pkgs.texliveBasic.withPackages texPackages;
        in
        {
          default =
            with pkgs;
            mkShell {
              packages = [
                texlab
                tex
                inkscape
                imagemagick
              ];
              shellHook = ''
                alias latex-watch="latexmk -interaction=nonstopmode -pdf -lualatex -pvc -view=pdf"
              '';
            };
        }
      );
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          tex = pkgs.texliveBasic.withPackages texPackages;
        in
        {
          document = pkgs.stdenvNoCC.mkDerivation rec {
            name = pname;
            src = pkgs.lib.cleanSource ./.;
            buildInputs = [
              pkgs.coreutils
              tex
            ];
            phases = [
              "unpackPhase"
              "buildPhase"
              "installPhase"
            ];
            buildPhase = ''
              export PATH="${pkgs.lib.makeBinPath buildInputs}";
              # Prevent LuaLaTeX from scanning host OS fonts (huge speedup)
              export OSFONTDIR=""
              # Prevent "sh: tput: not found" warning
              export TERM=dumb
              # Copy the pre-built Nix texlive cache to our writable directory
              export TEXMFVAR=$(mktemp -d)
              cp -a ${tex}/share/texmf-var/* $TEXMFVAR/
              chmod -R u+w $TEXMFVAR

              export TEXMFHOME=.cache
              export SOURCE_DATE_EPOCH=${toString self.lastModified}

              latexmk -interaction=nonstopmode -pdf -lualatex \
                  -pretex="\pdfvariable suppressoptionalinfo 512\relax" \
                  -usepretex \
                  -shell-escape \
                  ${name}.tex
            '';
            installPhase = ''
              mkdir -p $out
              cp ${name}.pdf $out/
            '';
          };
        }
      );
      defaultPackage = forAllSystems (system: packages.${system}.document);
    };
}
