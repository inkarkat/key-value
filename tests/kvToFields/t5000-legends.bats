#!/usr/bin/env bats

load fixture

@test "print header legend" {
    run kvToFields --header-legend <<'EOF'
elem=null flag=_
count=1 elem=foo flag=F
count=2 flag=T option=X
count=3 elem=baz option=Y
count=4 elem=quux
EOF
    [ $status -eq 0 ]
    assert_output - <<'EOF'
# elem flag
null _
foo F 1
 T 2 X
baz  3 Y
quux  4 
EOF
}

@test "print footer legend with custom output separator" {
    run kvToFields --output-separator . --footer-legend <<'EOF'
elem=null flag=_
count=1 elem=foo flag=F
count=2 flag=T option=X
count=3 elem=baz option=Y
count=4 elem=quux
EOF
    [ $status -eq 0 ]
    assert_output - <<'EOF'
null._
foo.F.1
.T.2.X
baz..3.Y
quux..4.
# elem.flag.count.option
EOF
}
