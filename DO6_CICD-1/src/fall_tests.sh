#!/bin/bash

cd cat/
bash run_tests.sh &> res_cat.txt
RES_C=$(grep -c "FAILED" res_cat.txt)
if [ "$RES_C" -ne 0 ]; then
    exit 1
fi
rm -rf res_cat.txt
cd ../grep
bash run_tests.sh &> res_grep.txt
RES_G=$(grep -c "FAILED" res_grep.txt)
if [ "$RES_G" -ne 0 ]; then
    exit 1
fi
rm -rf res_grep.txt




# #!/bin/bash

# cd cat/Tests/
# sh test_func_cat.sh &> result_test_cat.txt
# RES_C=$(grep -c "fail" result_test_cat.txt)
# if [ "$RES_C" -ne 0 ]; then
#     exit 1
# fi
# rm -rf result_test_cat.txt

# cd ../../grep/test_grep/
# sh test_func_grep.sh &> result_test_grep.txt
# RES_G=$(grep -c "fail" result_test_grep.txt)
# if [ "$RES_G" -ne 0 ]; then
#     exit 1
# fi
# rm -rf result_test_grep.txt
