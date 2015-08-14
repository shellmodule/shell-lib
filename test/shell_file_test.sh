#!/bin/sh
# file: test/shell_file_test.sh

. ../src/shell_file.sh

setUp()
{
	echo "before..."
}

tearDown()
{
	echo "after..."
}

. ../lib/shunit2