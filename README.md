# UWr LaTeX Thesis Template

A LaTeX template for bachelor's, engineer's, and master's theses at the Institute of Computer Science, University of Wrocław. Built with LuaLaTeX and managed via [Nix](https://nixos.org/).

## Prerequisites

Install [Nix](https://nixos.org/download/) with flakes enabled.

## Quick Start

1. **Clone the repo** and enter the directory:

   ```sh
   git clone <this-repo-url> && cd uwr-latex-thesis-template
   ```

2. **Enter the dev shell** (installs all LaTeX packages and tools automatically):

   ```sh
   nix develop
   ```

3. **Edit `paper.tex`** — fill in your details at the top of the file:

   ```latex
   \documentclass[shortabstract, inz, polish]{iithesis}

   \polishtitle    {Twój tytuł}
   \englishtitle   {Your Title}
   \polishabstract {Streszczenie...}
   \englishabstract{Abstract...}
   \author         {Imię Nazwisko}
   \advisor        {dr/prof Imię Nazwisko}
   ```

4. **Build the PDF** (one-off):

   ```sh
   latexmk -interaction=nonstopmode -pdf -lualatex paper.tex
   ```

   Or **watch for changes** and rebuild automatically:

   ```sh
   latex-watch paper.tex
   ```

The output PDF will be `paper.pdf`.

## Thesis Type

Set the thesis type in the `\documentclass` options:

| Option | Thesis type |
|--------|-------------|
| `lic`  | Licencjacka (bachelor's) |
| `inz`  | Inżynierska (engineer's) |
| `mgr`  | Magisterska (master's) |

## Language

Set `polish` or `english` in the `\documentclass` options to change the main language. Regardless of the chosen language, both Polish and English titles and abstracts are required.

## Reproducible Build (without dev shell)

You can build the PDF in a single command without entering the dev shell:

```sh
nix build .#document
```

The result will be in `./result/paper.pdf`.
