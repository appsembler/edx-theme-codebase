#!/usr/bin/env bash

###################################################################
#
#   Extract i18n strings and push them to Transifex.
#
#   You will need to configure your Transifex credentials as
#   described here:
#
#       http://docs.transifex.com/developer/client/setup
#
#   You also need to install gettext:
#
#       https://www.gnu.org/software/gettext/
#
#   Usage:
#
#       ./i18n-push.sh
#
##################################################################

cd `dirname $BASH_SOURCE` && cd ..

# Note we only extract the English language strings so they can be
# sent to Transifex. All other language strings will be pulled
# down from Transifex and so don't need to be generated.

CUSTOMER_BRANCH_NAME=$(cd customer_specific && git rev-parse --abbrev-ref HEAD)

if [ "$CUSTOMER_BRANCH_NAME" != "ficus/amc" ]; then
    echo "Error: Currently only 'ficus/amc' is supported for customer_specific."
    echo "       Checkout ficus/amc and re-run the script"
    exit 1
fi

echo "Extracting i18n strings..."
i18n_tool extract

read -p "Push strings to Transifex? [y/n]  " RESP
if [ "$RESP" = "y" ]; then
    i18n_tool transifex push
    echo " == Pushed strings to Transifex"
else
    echo "Cancelled"
fi
