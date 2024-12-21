#!/usr/bin/env bats

load fixture

@test "keys with dash output separator" {
    run kvToFields --output-separator - <<'EOF'
count=1 elem=foo flag=F
count=2 elem=bar flag=T
count=3 elem=baz flag=T
count=4 elem=quux flag=X
EOF
    [ $status -eq 0 ]
    assert_output - <<'EOF'
1-foo-F
2-bar-T
3-baz-T
4-quux-X
EOF
}

@test "keys with dash separators outputs with custom separator" {
    run kvToFields -F - --output-separator $':\t' <<'EOF'
count=1-elem=foo-flag=F
count=2-elem=bar-flag=T
count=3-elem=baz-flag=T
count=4-elem=quux-flag=X
EOF
    [ $status -eq 0 ]
    assert_output - <<'EOF'
1:	foo:	F
2:	bar:	T
3:	baz:	T
4:	quux:	X
EOF
}
