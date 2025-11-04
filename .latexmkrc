# .latexmkrc - Build configuration for a0poster.tex

# Use LuaLaTeX
$pdf_mode = 4;
$postscript_mode = $dvi_mode = 0;

# LuaLaTeX command with SyncTeX enabled
$lualatex = 'lualatex -halt-on-error -interaction=nonstopmode -synctex=1';

# Note: VS Code's "compile (fast - for editing)" recipe runs lualatex directly (1 pass, ~5 sec)
#       VS Code's "compile (full - for submission)" recipe uses this latexmk config (2 passes, ~10 sec)
