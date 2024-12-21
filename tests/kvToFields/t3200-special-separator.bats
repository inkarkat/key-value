#!/usr/bin/env bats

load fixture

@test "keys with dash separators" {
    run kvToFields -F - <<'EOF'
count=1-elem=foo-flag=F
count=2-elem=bar-flag=T
count=3-elem=baz-flag=T
count=4-elem=quux-flag=X
EOF
    [ $status -eq 0 ]
    assert_output - <<'EOF'
1-foo-F
2-bar-T
3-baz-T
4-quux-X
EOF
}

@test "keys with double space separators" {
    run kvToFields -F '  ' <<'EOF'
count=1  elem=foo  flag=F
count=2  elem=bar  flag=T
count=3  elem=baz  flag=T
count=4  elem=quux  flag=X
EOF
    [ $status -eq 0 ]
    assert_output - <<'EOF'
1  foo  F
2  bar  T
3  baz  T
4  quux  X
EOF
}

@test "keys with tab separators support values with spaces" {
    run kvToFields -F $'\t' <<'EOF'
elem=foo	value=foo bar	list=1 2 3
elem=bar	value=b b	list=4, 5, 6
EOF
    assert_output - <<'EOF'
foo	foo bar	1 2 3
bar	b b	4, 5, 6
EOF
}
