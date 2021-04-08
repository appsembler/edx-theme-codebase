"""
A Python script to remove duplicate entries from the theme po files.
"""

import os
import polib
from subprocess import check_call

SCRIPTS_DIR_NAME = os.path.dirname(__file__)


def skim(release, po_file_name):
    """
    Remove entries from `dest` that exists in `base`.

    Useful to make it cut Translation time by removing entries that is in the Open edX translation files.

    :param theme_file: The path to the theme po file e.g. django.po
    :return:
    """
    release_po_name = '{release}-{file}'.format(release=release, file=po_file_name)
    base_po = polib.pofile(os.path.join(SCRIPTS_DIR_NAME, 'open-edx-releases/en', release_po_name))

    dest_po = polib.pofile(os.path.join(SCRIPTS_DIR_NAME, '../conf/locale/en/LC_MESSAGES', po_file_name))

    for entry in reversed(dest_po):
        if entry in base_po:
            dest_po.remove(entry)

    dest_po.save()


def get_open_edx_release():
    """
    Read the OPENEDX_RELEASE environment variable from the `tox.ini` file.
    """
    release = os.getenv('OPENEDX_RELEASE')
    if release:
        return release

    raise RuntimeError('Error: The OPENEDX_RELEASE is not set. Please run this script only from within "$ tox".')


def make_transifex_config_file(release):
    """
    Generate a the `.tx/config` file to pull Open edX release translations.
    """
    with open(os.path.join(SCRIPTS_DIR_NAME, '../.tx/config.template')) as template_file:
        transifex_config_template = template_file.read()

    config_content = transifex_config_template.format(release=release)

    with open(os.path.join(SCRIPTS_DIR_NAME, '../.tx/config'), 'w') as config_file:
        config_file.write(config_content)


def pull_release_files_from_transifex():
    """
    Pull the Open edX release po files from Transifex for skimming.
    """
    repo_dir = os.path.join(SCRIPTS_DIR_NAME, '..')
    check_call(['tx', 'pull', '--source', '--force'], cwd=repo_dir)


def main():
    """
    Run the script.
    """
    release = get_open_edx_release()
    make_transifex_config_file(release)
    pull_release_files_from_transifex()
    skim(release, 'django.po')
    skim(release, 'djangojs.po')


if __name__ == '__main__':
    main()
