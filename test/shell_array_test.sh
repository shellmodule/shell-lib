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

	local empty_result=$(_array_is_empty "empty_array")
	local not_empty_result=$(_array_is_empty "not_empty_array")

	assertEquals "The empty array should be empty" true $empty_result
	assertEquals "The not empty array should not be empty" false $not_empty_result
}

function testArrayContain()
{
	local test_array=("aa" "bb")

	local contain_result=$(_array_contain "test_array" "aa")
	local not_contain_result=$(_array_contain "test_array" "cc")

	assertEquals "The test array should contain (aa)" true $contain_result
	assertEquals "The test array should not contain (cc)" false $not_contain_result
}

function testArrayContainArray()
{
	local test_array=("aa" "bb" "cc" "dd" "ee")
	local test_sub_array1=("bb" "ee")
	local test_sub_array2=("cc" "ff")
	local test_sub_array3=("ff" "gg")

	local contain_result=$(_array_contain_array "test_array" "test_sub_array1")
	local not_contain_result1=$(_array_contain_array "test_array" "test_sub_array2")
	local not_contain_result2=$(_array_contain_array "test_array" "test_sub_array3")

	assertEquals "The test array should contain (bb ee)" true $contain_result
	assertEquals "The test array should not contain (cc ff)" false $not_contain_result1
	assertEquals "The test array should not contain (ff gg)" false $not_contain_result2
}

function testArraySize()
{
	local test_array=("aa" "bb" "cc")

	local size_result=$(_array_size "test_array")

	assertEquals "The test array size should is 3" 3 $size_result
}

function testArrayGetValue()
{
	local test_array=("aa" "bb" "cc")

	local aa_value=$(_array_get_value "test_array" 0)
	local bb_value=$(_array_get_value "test_array" 1)
	local cc_value=$(_array_get_value "test_array" 2)
	local no_value=$(_array_get_value "test_array" 4)

	assertEquals "The first value of test_array should be (aa)" "aa" $aa_value
	assertEquals "The second value of test_array should be (bb)" "bb" $bb_value
	assertEquals "The third value of test_array should be (cc)" "cc" $cc_value
	assertFalse "The other value of test_array should be empty" "[ $no_value ]"
}

function testArrayGetIndex()
{
	local test_array=("aa" "bb" "cc")

	local aa_index=$(_array_get_index "test_array" "aa")
	local bb_index=$(_array_get_index "test_array" "bb")
	local cc_index=$(_array_get_index "test_array" "cc")
	local no_index=$(_array_get_index "test_array" "ff")

	assertEquals "The index of first value in test_array should be (0)" 0 $aa_index
	assertEquals "The index of second value in test_array should be (1)" 1 $bb_index
	assertEquals "The index of third value in test_array should be (2)" 2 $cc_index
	assertEquals "The other index of the test_array should be (-1)" -1 $no_index
}

## "array add"
{
	## "should add the value at end of the array by default"
	function testArrayAdd1()
	{
		local test_array=("aa")

		_array_add "test_array" "bb"

		assertEquals "The second value in test_array should be (bb)" "bb" ${test_array[1]}
	}
	## "should add the value on point index"
	function testArrayAdd2()
	{
		local test_array=("aa" "bb")

		_array_add "test_array" "cc" 1

		assertEquals "The first value in test_array should be (aa)" "aa" ${test_array[0]}
		assertEquals "The second value in test_array should be (cc)" "cc" ${test_array[1]}
		assertEquals "The third value in test_array should be (bb)" "bb" ${test_array[2]}
	}
}

function testArrayAddArray()
{
	local test_array=("aa")
	test_sub_array=("bb" "cc")

	_array_add_array "test_array" "test_sub_array"

	assertEquals "The second value in test_array should be (bb)" "bb" ${test_array[1]}
	assertEquals "The third value in test_array should be (cc)" "cc" ${test_array[2]}
}

# private method

## "array move next"
{
	## "should move all the values to next one step by default"
	function testArrayMoveNext1()
	{
		local test_array=("aa" "bb" "cc")
		local expect_array=("" "aa" "bb" "cc")

		__array_move_next "test_array"

		assertEquals "The test_array should be equal expect_array" "${expect_array[*]}" "${test_array[*]}"
	}
	## "should move the values from point index to next one step by default"
	function testArrayMoveNext2()
	{
		local test_array=("aa" "bb" "cc")
		local expect_array=("aa" "" "bb" "cc")

		__array_move_next "test_array" 1

		assertEquals "The test_array should be equal expect_array" "${expect_array[*]}" "${test_array[*]}"
	}
	## "should move the values from point index to next point steps"
	function testArrayMoveNext3()
	{
		local test_array=("aa" "bb" "cc")
		local expect_array=("aa" "" "" "bb" "cc")

		__array_move_next "test_array" 1 2

		assertEquals "The test_array should be equal expect_array" "${expect_array[*]}" "${test_array[*]}"
	}
	## "should not move the values when the from index over the length of array."
	function testArrayMoveNext4()
	{
		local test_array=("aa" "bb")
		local expect_array=("aa" "bb")

		__array_move_next "test_array" 2 1
		local move_result=$?

		assertEquals "The test_array should not be changed" "${expect_array[*]}" "${test_array[*]}"
		assertEquals "The return value should be equal (2)" 2 $move_result
	}
	## "should not move the values when the move count is zero."
	function testArrayMoveNext5()
	{
		local test_array=("aa" "bb")
		local expect_array=("aa" "bb")

		__array_move_next "test_array" 1 0
		local move_result=$?

		assertEquals "The test_array should not be changed" "${expect_array[*]}" "${test_array[*]}"
		assertEquals "The return value should be equal (2)" 2 $move_result
	}
}

. ../lib/shunit2