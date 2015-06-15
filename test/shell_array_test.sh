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
	local empty_array=()
	local not_empty_array=("aa" "bb" "cc")

	_array_is_empty "empty_array"
	local empty_result=$?
	_array_is_empty "not_empty_array"
	local not_empty_result=$?

	assertEquals "The empty array should be empty" 1 $empty_result
	assertEquals "The not empty array should not be empty" 0 $not_empty_result
}

function testArrayContain()
{
	local test_array=("aa" "bb")

	_array_contain "test_array" "aa"
	local contain_result=$?
	_array_contain "test_array" "cc"
	local not_contain_result=$?

	assertEquals "The test array should contain (aa)" 1 $contain_result
	assertEquals "The test array should not contain (cc)" 0 $not_contain_result
}

function testArrayContainArray()
{
	local test_array=("aa" "bb" "cc" "dd" "ee")
	local test_sub_array1=("bb" "ee")
	local test_sub_array2=("cc" "ff")
	local test_sub_array3=("ff" "gg")

	_array_contain_array "test_array" "test_sub_array1"
	local contain_result=$?
	_array_contain_array "test_array" "test_sub_array2"
	local not_contain_result1=$?
	_array_contain_array "test_array" "test_sub_array3"
	local not_contain_result2=$?

	assertEquals "The test array should contain (bb ee)" 1 $contain_result
	assertEquals "The test array should not contain (cc ff)" 0 $not_contain_result1
	assertEquals "The test array should not contain (ff gg)" 0 $not_contain_result2
}

. ../lib/shunit2