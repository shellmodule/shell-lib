#!/bin/sh
# file: src/shell_array.sh

function _array_is_empty()
{
	if [ $1 ]; then
		eval local length=\${#$1[*]}
		if [ $length == 0 ]; then
			echo true
			return 0
		else
			echo false
			return 2
		fi
	fi
	return 1
}

function _array_contain()
{
	if [ $1 -a $2 ]; then
		local index=0
		eval local length=\${#$1[*]}
		while [ $index -lt $length ]; do
			eval local item=\${$1[$index]}
			if [ $item -a $item = $2 ]; then
				echo true
				return 0
			fi
			let index=$index+1
		done
		echo false
		return 2
	fi
	return 1
}

function _array_contain_array()
{
	if [ $1 -a $2 ]; then
		local index=0
		eval local length=\${#$2[*]}
		while [ $index -lt $length ]; do
			eval local item=\${$2[$index]}
			local contain_result=$(_array_contain $1 $item)
			if [ $contain_result = false ]; then
				echo false
				return 2
			fi
			let index=$index+1
		done
		echo true
		return 0
	fi
	return 1
}

function _array_size()
{
	if [ $1 ]; then
		eval echo \${#$1[*]}
		return 0
	fi
	return 1
}

function _array_get_value()
{
	if [ $1 -a $2 ]; then
		eval local length=\${#$1[*]}
		if [ $2 -ge 0 -a $2 -lt $length ]; then
			eval echo \${$1[$2]}
			return 0
		else
			return 2
		fi
	fi
	return 1
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
				return 0
			fi
			let index=$index+1
		done
		echo -1
		return 2
	fi
	return 1
}

function _array_add()
{
	if [ $1 -a $2 ]; then
		eval local length=\${#$1[*]}
		eval $1[$length]=$2
		return 0
	fi
	return 1
}

function _array_add_array()
{
	if [ $1 -a $2 ]; then
		local index=0
		eval local source_last_index=\${#$1[*]}
		eval local dest_length=\${#$2[*]}
		while [ $index -lt $dest_length ]; do
			eval local item=\${$2[$index]}
			if [ $item ]; then
				eval $1[$source_last_index]=$item
				let source_last_index=$source_last_index+1
			fi
			let index=$index+1
		done
		return 0
	fi
	return 1
}