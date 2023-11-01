
sub build_header {
  system("ruby ./prep.rb")
}

build_header()
system("cat ./paper.log")
