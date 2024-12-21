#!/usr/bin/env bats

load fixture

@test "passed schema affects field order" {
    run kvToFields --schema 'count elem reserved option flag' <<'EOF'
elem=null flag=_
count=1 elem=foo flag=F
count=2 flag=T option=X
count=3 elem=baz option=Y
count=4 elem=quux
EOF
    [ $status -eq 0 ]
    assert_output - <<'EOF'
 null   _
1 foo   F
2   X T
3 baz  Y 
4 quux   
EOF
}

@test "passed schema with header legend" {
    run kvToFields --header-legend --schema 'count elem reserved option flag' <<'EOF'
elem=null flag=_
count=1 elem=foo flag=F
count=2 flag=T option=X
count=3 elem=baz option=Y
count=4 elem=quux
EOF
    [ $status -eq 0 ]
    assert_output - <<'EOF'
# count elem reserved option flag
 null   _
1 foo   F
2   X T
3 baz  Y 
4 quux   
EOF
}

@test "schema with custom field separator supports spaces in keys" {
    run kvToFields -F - --schema 'item count-elem-reserved value-special option-single flag' --footer-legend <<'EOF'
elem=null-single flag=_
item count=1-elem=foo-single flag=F
item count=2-single flag=T-special option=X
item count=3-elem=baz-special option=Y
item count=4-elem=quux
EOF
    [ $status -eq 0 ]
    assert_output - <<'EOF'
-null---_
1-foo---F
2---X-T
3-baz--Y-
4-quux---
# item count-elem-reserved value-special option-single flag
EOF
}
