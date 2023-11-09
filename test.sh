#!/bin/bash

CRED=`/bin/echo -e '\033[31;01m'`
CCYAN=`/bin/echo -e '\033[36;01m'`
CGREEN=`/bin/echo -e '\033[32;01m'`
CYELLOW=`/bin/echo -e '\033[93;01m'`
CRST=`/bin/echo -e '\033[00m'`

test_info()
{
	echo -n "${1}..."
}

test_is_ok()
{
	echo "OK"
}

test_is_fail()
{
	echo "${CRED}FAIL${CRST}"
	echo "$1"
	exit 1
}

exec < ./test.data

test_info "(err) Wrong fd"
data=`./fdseek 10 2>&1`
ret=$?
if [[ $ret -ne 1 ]]; then
	test_is_fail "fdseek exit code is not 1: $ret"
fi
if [[ "$data" != "lseek() error: Bad file descriptor" ]]; then
	test_is_fail "fdseek wrong error message: '$data'"
fi
test_is_ok

test_info "(err) fd isn't number"
data=`./fdseek h 2>&1`
ret=$?
if [[ $ret -ne 1 ]]; then
	test_is_fail "fdseek exit code is not 1: $ret"
fi
if [[ "$data" != "fd should be a number: h" ]]; then
	test_is_fail "fdseek wrong error message: '$data'"
fi
test_is_ok

test_info "(err) offset isn't number"
data=`./fdseek 10 h 2>&1`
ret=$?
if [[ $ret -ne 1 ]]; then
	test_is_fail "fdseek exit code is not 1: $ret"
fi
if [[ "$data" != "Offset should be a number: h" ]]; then
	test_is_fail "fdseek wrong error message: '$data'"
fi
test_is_ok

test_info "(err) Wrong whence"
data=`./fdseek 10 0 set 2>&1`
ret=$?
if [[ $ret -ne 1 ]]; then
	test_is_fail "fdseek exit code is not 1: $ret"
fi
if [[ "$data" != "Whence should be one of 'start', 'cur' or 'end': set" ]]; then
	test_is_fail "fdseek wrong error message: '$data'"
fi
test_is_ok

test_info "Read before seek"
read line
if [[ "$line" != "1111" ]]; then
	test_is_fail "line is not '1111': '$line'"
fi
test_is_ok

test_info "Get current offset"
data=`./fdseek 0`
ret=$?
if [[ $ret -ne 0 ]]; then
	test_is_fail "fdseek exit code is not 0: $ret"
fi
if [[ $data -ne 5 ]]; then
	test_is_fail "fdseek return not 5: $data"
fi
read line
if [[ "$line" != "222" ]]; then
	test_is_fail "line is not '222': '$line'"
fi
test_is_ok

test_info "Set current offset"
data=`./fdseek 0 12`
ret=$?
if [[ $ret -ne 0 ]]; then
	test_is_fail "fdseek exit code is not 0: $ret"
fi
if [[ $data -ne 12 ]]; then
	test_is_fail "fdseek return not 12: $data"
fi
read line
if [[ "$line" != "33" ]]; then
	test_is_fail "line is not '33': '$line'"
fi
test_is_ok

test_info "Set current offset from start"
data=`./fdseek 0 10 start`
ret=$?
if [[ $ret -ne 0 ]]; then
	test_is_fail "fdseek exit code is not 0: $ret"
fi
if [[ $data -ne 10 ]]; then
	test_is_fail "fdseek return not 10: $data"
fi
read line
if [[ "$line" != "3333" ]]; then
	test_is_fail "line is not '3333': '$line'"
fi
test_is_ok

test_info "Set current offset from cur"
data=`./fdseek 0 2 cur`
ret=$?
if [[ $ret -ne 0 ]]; then
	test_is_fail "fdseek exit code is not 0: $ret"
fi
if [[ $data -ne 17 ]]; then
	test_is_fail "fdseek return not 17: $data"
fi
read line
if [[ "$line" != "44" ]]; then
	test_is_fail "line is not '44': '$line'"
fi
test_is_ok

test_info "Set current negative offset from cur"
data=`./fdseek 0 -8 cur`
ret=$?
if [[ $ret -ne 0 ]]; then
	test_is_fail "fdseek exit code is not 0: $ret"
fi
if [[ $data -ne 12 ]]; then
	test_is_fail "fdseek return not 12: $data"
fi
read line
if [[ "$line" != "33" ]]; then
	test_is_fail "line is not '33': '$line'"
fi
test_is_ok

test_info "Set current negative offset from end"
data=`./fdseek 0 -8 end`
ret=$?
if [[ $ret -ne 0 ]]; then
	test_is_fail "fdseek exit code is not 0: $ret"
fi
if [[ $data -ne 15 ]]; then
	test_is_fail "fdseek return not 15: $data"
fi
read line
if [[ "$line" != "4444" ]]; then
	test_is_fail "line is not '4444': '$line'"
fi
test_is_ok

