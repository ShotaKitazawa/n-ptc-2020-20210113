#!/bin/bash

SCRIPT_PATH=/home/ptc-user/app/apitest
export PYTHONPATH=$PATHONPATH:$SCRIPT_PATH/scripts
export IMAGE_PATH=$SCRIPT_PATH/images
export expired_token="eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE1OTk2MzY2NDMsImlhdCI6MTU5OTYzMzA0MywidXNlcm5hbWUiOiJzYXdhZHkiLCJyb2xlIjoib3duZXIifQ.opVQE0FKG9caqZrgqGewJEZabHYuwzCs1M9Y_Zig3WY"
export url="http://localhost:5000/api"
export jwt_secret_token=gDO8foHif1IuPjst6eT6mrJyeU3kjuzxYmw2Dd4z0Bor3PZkuO

cd $SCRIPT_PATH
python3.7 -m pytest --tavern-global-cfg=${SCRIPT_PATH}/tavern/config.yaml -W ignore::pytest.PytestDeprecationWarning
