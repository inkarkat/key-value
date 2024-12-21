#!/usr/bin/env bats

load fixture

@test "new keys appended in following lines" {
    run kvToFields <<'EOF'
count=1 elem=foo
count=2 elem=bar flag=F
count=3 elem=baz flag=T option=X
count=4 elem=quux flag=F option=Y comment=what
EOF
    [ $status -eq 0 ]
    assert_output - <<'EOF'
1 foo
2 bar F
3 baz T X
4 quux F Y what
EOF
}

@test "trailing keys dropping in following lines" {
    run kvToFields <<'EOF'
count=1 elem=foo flag=F option=Y comment=what
count=2 elem=bar flag=T option=X
count=3 elem=baz flag=F
count=4 elem=quux
EOF
    [ $status -eq 0 ]
    assert_output - <<'EOF'
1 foo F Y what
2 bar T X 
3 baz F  
4 quux   
EOF
}

@test "arbitrary keys dropping in following lines" {
    run kvToFields <<'EOF'
count=1 elem=foo flag=F option=Y comment=what
count=2 flag=T option=X
count=3 elem=baz flag=F
count=4 elem=quux
EOF
    [ $status -eq 0 ]
    assert_output - <<'EOF'
1 foo F Y what
2  T X 
3 baz F  
4 quux   
EOF
}

@test "three fixed keys reordered" {
    run kvToFields <<'EOF'
count=1 elem=foo flag=F
count=2 flag=T elem=bar
elem=baz count=3 flag=T
flag=X elem=quux count=4
EOF
    [ $status -eq 0 ]
    assert_output - <<'EOF'
1 foo F
2 bar T
3 baz T
4 quux X
EOF
}

@test "keys added, dropped, and reordered in following lines" {
    run kvToFields <<'EOF'
elem=null flag=_
count=1 elem=foo flag=F
count=2 flag=T option=X
count=3 elem=baz flag=F
count=4 elem=quux
EOF
    [ $status -eq 0 ]
    assert_output - <<'EOF'
null _
foo F 1
 T 2 X
baz F 3 
quux  4 
EOF
}
