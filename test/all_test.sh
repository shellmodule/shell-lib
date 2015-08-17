#!/bin/sh
# file: test/all_test.sh

cd test

bash ./shell_array_test.sh
return_code=$?; if [ $return_code -ne 0 ]; then exit $return_code; fi

bash ./shell_file_test.sh
return_code=$?; if [ $return_code -ne 0 ]; then exit $return_code; fi