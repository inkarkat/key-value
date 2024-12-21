#!/usr/bin/env bats

load fixture

@test "syntax error aborts by default" {
    run kvToFields --unbuffered <<'EOF'
count=1 elem=foo flag=F
count=2 notAnElement flag=T
count=3 elem=baz flag=T
EOF
    [ $status -eq 1 ]
    assert_output - <<'EOF'
1 foo F
ERROR: Not a key-value pair: notAnElement (-:2 field 2)
EOF
}

@test "syntax error aborts with --syntax-error abort" {
    run kvToFields --unbuffered --syntax-error abort <<'EOF'
count=1 elem=foo flag=F
count=2 notAnElement flag=T
count=3 elem=baz flag=T
EOF
    [ $status -eq 1 ]
    assert_output - <<'EOF'
1 foo F
ERROR: Not a key-value pair: notAnElement (-:2 field 2)
EOF
}

@test "syntax error warns with --syntax-error warn" {
    run kvToFields --unbuffered --syntax-error warn <<'EOF'
count=1 elem=foo flag=F
count=2 notAnElement flag=T
count=3 elem=baz flag=T
EOF
    [ $status -eq 0 ]
    assert_output - <<'EOF'
1 foo F
Warning: Not a key-value pair: notAnElement (-:2 field 2)
2  T
3 baz T
EOF
}
