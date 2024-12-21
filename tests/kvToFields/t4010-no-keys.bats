#!/usr/bin/env bats

load fixture

@test "lines without keys are dropped" {
    run kvToFields --syntax-error ignore <<'EOF'
This is a general introduction.
Commentary at the beginning count=1 elem=foo flag=F
More stuff here...          count=2 elem=bar flag=T
Totally unrelated line, pls ignore ;-)
count=3 elem=baz flag=T Now spamming the end...
count=4 elem=quux flag=X
Final epilogue.
EOF
    [ $status -eq 0 ]
    assert_output - <<'EOF'
1 foo F
2 bar T
3 baz T
4 quux X
EOF
}

@test "print header legend after ignoring lines without keys" {
    run kvToFields --header-legend --syntax-error ignore <<'EOF'
This is a general introduction.
Commentary at the beginning count=1 elem=foo flag=F
More stuff here...          count=2 elem=bar flag=T
EOF
    [ $status -eq 0 ]
    assert_output - <<'EOF'
# count elem flag
1 foo F
2 bar T
EOF
}
