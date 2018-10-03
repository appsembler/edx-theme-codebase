#!/usr/bin/env bash

###################################################################
#
#   Pull i18n strings from POEditor.com.
#
#
#   More information is on the README.md of this document.
#
#   Usage:
#
#       ./i18n-pull.sh
#
##################################################################

set -e

cd `dirname $BASH_SOURCE` && cd ..

rm -rf conf/locale/en/LC_MESSAGES/*.po

echo "Extracting i18n strings..."
i18n_tool extract

mv conf/locale/en/LC_MESSAGES/mako.po conf/locale/en/LC_MESSAGES/django.po
mv conf/locale/en/LC_MESSAGES/underscore.po conf/locale/en/LC_MESSAGES/djangojs.po

echo "Pulling strings from POEditor.com..."
poeditor pull

# Remove the fuzzy header to avoid translations being hidden
sed -i -e 's/^#, fuzzy.*$//' -- conf/locale/*/LC_MESSAGES/*.po

echo "Building dummy Esperanto strings..."
i18n_tool dummy

echo "Validating strings..."
i18n_tool validate

echo "Compiling strings..."
i18n_tool generate
