#!/bin/sh
# file: src/shell_array.sh

function _array_is_empty()
{
	if [ $1 ]; then
		eval local length=\${#$1[*]}
		if [ $length == 0 ]; then
			return 1
		fi
	fi
	return 0
}

function _array_contain()
{
	if [ $1 -a $2 ]; then
		local index=0
		eval local length=\${#$1[*]}
		while [ $index -lt $length ]; do
			eval local item=\${$1[$index]}
			if [ $item -a $item = $2 ]; then
				return 1
			fi
			let index=$index+1
		done
	fi
	return 0
}

function _array_contain_array()
{
	if [ $1 -a $2 ]; then
		local index=0
		eval local length=\${#$2[*]}
		while [ $index -lt $length ]; do
			eval local item=\${$2[$index]}
			_array_contain $1 $item
			if [ $? -eq 0 ]; then
				return 0
			fi
			let index=$index+1
		done
		return 1
	fi
	return 0
}

function _array_size()
{
	if [ $1 ]; then
		eval local length=\${#$1[*]}
		return $length
	fi
	return 0
}

function _array_get_value()
{
	if [ $1 -a $2 -a $3 ]; then
		eval local length=\${#$1[*]}
		if [ $3 -ge 0 -a $3 -lt $length ]; then
			eval $2=\${$1[$3]}
		fi
	fi
}

function _array_get_index()
{
	if [ $1 -a $2 ]; then
		local index=0
		eval local length=\${#$1[*]}
		while [ $index -lt $length ]; do
			eval local item=\${$1[$index]}
			if [ $item -a $item = $2 ]; then
				echo $index
				break
			fi
			let index=$index+1
		done
	fi
}