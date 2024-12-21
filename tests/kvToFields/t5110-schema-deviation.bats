#!/usr/bin/env bats

load fixture

@test "passed schema still allows addition of new keys but warns" {
    run kvToFields --unbuffered -F - --footer-legend --schema 'count-elem-reserved-option-flag' <<'EOF'
elem=null-flag=_
count=1-elem=foo-flag=F-surprise=hey
count=2-flag=T-option=X
count=3-sneak=true-elem=baz-option=Y
count=4-elem=quux
EOF
    [ $status -eq 0 ]
    assert_output - <<'EOF'
-null---_
Warning: Unknown key: surprise (-:2 field 4)
1-foo---F-hey
2---X-T-
Warning: Unknown key: sneak (-:4 field 2)
3-baz--Y---true
4-quux-----
# count-elem-reserved-option-flag-surprise-sneak
EOF
}

@test "schema deviation warn warns but still allows addition of new keys" {
    run kvToFields --unbuffered -F - --footer-legend --schema 'count-elem-reserved-option-flag' --schema-deviation warn <<'EOF'
elem=null-flag=_
count=1-elem=foo-flag=F-surprise=hey
count=2-flag=T-option=X
count=3-sneak=true-elem=baz-option=Y
count=4-elem=quux
EOF
    [ $status -eq 0 ]
    assert_output - <<'EOF'
-null---_
Warning: Unknown key: surprise (-:2 field 4)
1-foo---F-hey
2---X-T-
Warning: Unknown key: sneak (-:4 field 2)
3-baz--Y---true
4-quux-----
# count-elem-reserved-option-flag-surprise-sneak
EOF
}

@test "schema deviation accept allows addition of new keys" {
    run kvToFields --unbuffered -F - --footer-legend --schema 'count-elem-reserved-option-flag' --schema-deviation accept <<'EOF'
elem=null-flag=_
count=1-elem=foo-flag=F-surprise=hey
count=2-flag=T-option=X
count=3-sneak=true-elem=baz-option=Y
count=4-elem=quux
EOF
    [ $status -eq 0 ]
    assert_output - <<'EOF'
-null---_
1-foo---F-hey
2---X-T-
3-baz--Y---true
4-quux-----
# count-elem-reserved-option-flag-surprise-sneak
EOF
}

@test "schema deviation skip ignores new keys" {
    run kvToFields --unbuffered -F - --footer-legend --schema 'count-elem-reserved-option-flag' --schema-deviation skip <<'EOF'
elem=null-flag=_
count=1-elem=foo-flag=F-surprise=hey
count=2-flag=T-option=X
count=3-sneak=true-elem=baz-option=Y
count=4-elem=quux
EOF
    [ $status -eq 0 ]
    assert_output - <<'EOF'
-null---_
1-foo---F
2---X-T
3-baz--Y-
4-quux---
# count-elem-reserved-option-flag
EOF
}

@test "schema deviation aborts when encountering new keys" {
    run kvToFields --unbuffered -F - --footer-legend --schema 'count-elem-reserved-option-flag' --schema-deviation abort <<'EOF'
elem=null-flag=_
count=1-elem=foo-flag=F-surprise=hey
count=2-flag=T-option=X
count=3-sneak=true-elem=baz-option=Y
count=4-elem=quux
EOF
    [ $status -eq 1 ]
    assert_output - <<'EOF'
-null---_
ERROR: Unknown key: surprise (-:2 field 4)
EOF
}
