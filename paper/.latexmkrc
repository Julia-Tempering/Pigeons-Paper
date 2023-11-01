$failure_cmd = "cat paper.log 1>&2";
sub build_header {
  system("ruby ./prep.rb")
}

build_header()

