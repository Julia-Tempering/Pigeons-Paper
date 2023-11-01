$success_cmd = "cat paper.log 1>&2";
$warning_cmd = "cat paper.log 1>&2";
$failure_cmd = "cat paper.log 1>&2";

sub build_header {
  system("ruby ./prep.rb")
}

build_header()

