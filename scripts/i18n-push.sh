#!/usr/bin/env bash

###################################################################
#
#   Extract i18n strings and push them to POEditor.com.
#
#
#   More information is on the README.md of this document.
#
#   Usage:
#
#       ./i18n-push.sh
#
##################################################################

cd `dirname $BASH_SOURCE` && cd ..

# Note we only extract the English language strings so they can be
# sent to POEditor.com. All other language strings will be pulled
# down from POEditor.com and so don't need to be generated.

CUSTOMER_BRANCH_NAME=$(cd customer_specific && git rev-parse --abbrev-ref HEAD)

if [ "$CUSTOMER_BRANCH_NAME" != "ficus/amc" ]; then
    echo "Error: Currently only 'ficus/amc' is supported for customer_specific."
    echo "       Checkout ficus/amc and re-run the script"
    exit 1
fi

rm -rf conf/locale/en/LC_MESSAGES/*.po

echo "Extracting i18n strings..."
i18n_tool extract

mv conf/locale/en/LC_MESSAGES/mako.po conf/locale/en/LC_MESSAGES/django.po
mv conf/locale/en/LC_MESSAGES/underscore.po conf/locale/en/LC_MESSAGES/djangojs.po

read -p "Push strings to POEditor.com? [y/n]  " RESP
if [ "$RESP" = "y" ]; then
    poeditor --sync-terms pushTerms
    echo " == Pushed strings to POEditor.com"
else
    echo "Cancelled"
fi
