#!/bin/sh
# file: test/shell_array_test.sh

. ../src/shell_array.sh

function setUp()
{
	echo "before..."
}

function tearDown()
{
	echo "after..."
}

function testArrayIsEmpty()
{
	empty_array=()
	not_empty_array=("aa","bb")

	_array_is_empty "empty_array"
	empty_result=$?
	_array_is_empty "not_empty_array"
	not_empty_result=$?

	assertEquals "The empty array should be empty" 1 $empty_result
	assertEquals "The not empty array should not be empty" 0 $not_empty_result
}

. ../lib/shunit2