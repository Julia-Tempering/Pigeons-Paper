$success_cmd = "cat paper.log 1>&2";
$warning_cmd = "cat paper.log 1>&2";
$failure_cmd = "cat paper.log 1>&2";
$pdflatex = "pdflatex -halt-on-error %O %S 1>&2";

sub build_header {
  system("ruby ./prep.rb")
}

build_header()

