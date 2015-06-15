#!/bin/sh
# file: src/shell_array.sh

function _array_is_empty()
{
	if [ $1 ]; then
		eval length=\${#$1[*]}
		if [ $length == 0 ]; then
			return 1
		fi
	fi
	return 0
}

function _array_contain()
{
	if [ $1 -a $2 ]; then
		index=0
		eval length=\${#$1[*]}
		while [ $index -lt $length ]; do
			eval item=\${$1[$index]}
			if [ $item -a $item = $2 ]; then
				return 1
			fi
			let index=$index+1
		done
	fi
	return 0
}