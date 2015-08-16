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
		local insert_index=$length
		if [ $3 ]; then
			if [ $3 -ge 0 -a $3 -lt $length ]; then
				insert_index=$3
				__array_move_next $1 $insert_index
			fi
		fi
		eval $1[$insert_index]=$2
		return 0
	fi
	return 1
}

function _array_add_array()
{
	if [ $1 -a $2 ]; then
		eval local length=\${#$1[*]}
		eval local dest_length=\${#$2[*]}
		local insert_index=$length
		if [ $3 ]; then
			if [ $3 -ge 0 -a $3 -lt $length ]; then
				insert_index=$3
				__array_move_next $1 $insert_index $dest_length
			fi
		fi
		local index=0
		while [ $index -lt $dest_length ]; do
			eval local item=\${$2[$index]}
			if [ $item ]; then
				eval $1[$insert_index]=$item
				let insert_index=$insert_index+1
			fi
			let index=$index+1
		done
		return 0
	fi
	return 1
}

function _array_sub_array()
{
	if [ $1 ]; then
		eval local length=\${#$1[*]}
		local to_length=$2+$3
		let to_length=$to_length-1
		if [ $to_length -gt $length ]; then $to_length=$length; fi
		eval echo \${$1[*]:$2:$to_length}
	fi
	return 1
}

function _array_sub_array_from()
{
	if [ $1 ]; then
		eval local length=\${#$1[*]}
		if [ $2 -ge 0 -a $2 -lt $length ]; then
			eval echo \${$1[*]:$2}
		fi
	fi
	return 1
}

function _array_remove()
{
	if [ $1 ]; then
		eval local length=\${#$1[*]}
		if [ $2 -ge 0 -a $2 -lt $length ]; then
			eval let start_index=$2+1
			eval let end_index=$length-1
			if [ $2 -eq 0 ]; then
				eval echo \${$1[*]:1}
			elif [ $2 -eq $end_index ]; then
				eval echo \${$1[*]:0:$end_index}
			else
				eval echo \${$1[*]:0:$2} \${$1[*]:$start_index:$end_index}
			fi
		else
			eval echo \${$1[*]}
		fi
	fi 
	return 1
}

# private method
function __array_move_next()
{
	if [ $1 ]; then
		local move_index=0
		local move_count=1
		if [ $2 ]; then move_index=$2; fi
		if [ $3 ]; then move_count=$3; fi
		eval local length=\${#$1[*]}
		if [ $move_index -ge $length -o $move_count -eq 0 ]; then return 2; fi

		let local src_index=$length-1
		let local move_start=$move_index+$move_count
		let local des_index=$length+$move_count-1
		while [ $des_index -ge $move_start ]; do
			eval $1[$des_index]=\${$1[$src_index]}
			let src_index=$src_index-1
			let des_index=$des_index-1
		done
		local index=$move_index
		while [ $index -lt $move_start ]; do
			eval $1[$index]=""
			let index=$index+1
		done
		return 0
	fi
	return 1
}