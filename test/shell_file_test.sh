#!/bin/sh
# file: test/shell_file_test.sh

. ../src/shell_file.sh

function setUp()
{
	echo "before..."
}

function tearDown()
{
	echo "after..."
}

. ../lib/shunit2