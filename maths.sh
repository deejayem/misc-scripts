#!/bin/bash

expr=${@/x/*}
echo "scale=6;${expr}"|bc
