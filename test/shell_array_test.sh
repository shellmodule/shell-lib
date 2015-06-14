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

. ../lib/shunit2