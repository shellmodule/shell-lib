#!/bin/sh
# file: src/shell_array.sh

function _array_is_empty()
{
	if [ $1 ]; then
		eval length=\${#$1[*]}
		if [ $length == 0 ]; then
			return 1
		else 
			return 0
		fi
	else
		return 0
	fi
}