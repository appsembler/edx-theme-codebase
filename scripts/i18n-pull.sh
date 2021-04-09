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
#       $ tox -e i18n-pull
#
##################################################################

set -e

if test -e "${OPENEDX_RELEASE}"; then
  echo "The OPENEDX_RELEASE environment variable is not set, please only run this script via '$ tox'.";
fi

cd "${TOX_INI_DIR}"

rm -rf conf/locale/en/LC_MESSAGES/*.po

echo "Extracting i18n strings..."
i18n_tool extract

msgcat conf/locale/en/LC_MESSAGES/{mako,django-partial}.po -o conf/locale/en/LC_MESSAGES/django.po
mv conf/locale/en/LC_MESSAGES/underscore.po conf/locale/en/LC_MESSAGES/djangojs.po
rm -vf conf/locale/en/LC_MESSAGES/{mako,django-partial}.po

python ./scripts/skim.py

echo "Pulling strings from POEditor.com..."
poeditor pull

# Remove the fuzzy header to avoid translations being hidden
sed -i -e 's/^#, fuzzy.*$//' -- conf/locale/*/LC_MESSAGES/*.po

echo "Building dummy Esperanto strings..."
i18n_tool dummy

echo "Compiling strings..."
i18n_tool generate --strict -v
