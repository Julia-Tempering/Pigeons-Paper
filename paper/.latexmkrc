#$pdflatex = "! pdflatex -halt-on-error %O %S | grep -A3 '^!'";
$pdflatex = "! pdflatex -halt-on-error %O %S | cat";
$pdf_mode = 1;
$postscript_mode = 0;
$dvi_mode = 0;

sub build_header {
  system("ruby ./prep.rb")
}

build_header()

