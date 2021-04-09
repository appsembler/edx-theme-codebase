Overview
========

This directory stores the Appsembler custom codebase for theme authoring, developed and tested on Open edX Dogwood version.
It enables advanced theme authoring, with improved flexibility, custom SASS codebase and utilizes our new architecture for Open edX themes, which relies on our custom SASS, "Design templates" which hold "building blocks" designs for creating pages, "Translator templates" which (where needed) serve as translators between Open edX standard templates and their variables and our Design templates, Discovery templates for Backbone rendered content that we customize and a main theme-variables.html template which directs other templates, defining the building blocks to be used/included on particular pages and their content.


Why this new architecture?
==========================

When doing advanced customizations of themes, especially creating a number of them that need to be maintaned, a problem occurs when updating edX platform on instances that these themes are used on - because of constant evolution/changes of Open edX platform, heavily customized templates are likely to create errors and need a hefty amount of debugging. When maintaining multiple heavily customized themes, that proves to be a problem that makes platfrom updates a time-consuming process. By separating custom design into its own templates that get non-changing variables passed to them through the main templates or translator templates, we keep debugging concentrated into same points on all themes - fixing main templates and translator templates (which are identical for all themes) in one theme, we can propagate them to all themes making them fully functional for the new edX version.


Warning
=======

This new codebase is built custom to accommodate the development needs and long-term product development plans for Appsembler, meaning some of design choices are made with that in mind. Also, this codebase is currently still in development and not finished, so it's not recommended to use it in production. Theme-variables template is designed with internal future plans in mind - which is why it may not seem perfectly intuitive for all uses and purposes.


Usage - templates and content
=============================

Unlike standard Open edX theme development, all pages and shared page elements content is changed/defined through one file - theme-variables.html. It passes its variables to standard Open edX templates, telling them which design blocks to use, in which order, and what content they should display. For an example, you use it to tell which course tile design to use on which pages, set the paths to static content like brand logos, add additional links to theme's header or footer, etc. Since this is still in alpha, the documentation of all available building blocks and variables isn't available, but the default included theme-variables.html file includes a lot of examples so you can try to make changes. It's also well commented with instructions on how to define stuff and which variables need to be included.


Usage - styling
===============

The theme doesn't use Open edX paver process to compile the SASS, so it needs to be pre-compiled into the "static/css/main.css" file.
You can change the many variables included into the src/base/basic-branding.scss file to make changes - just remember to recompile it :)
The reason why we do compiling on our own is because we include the main.css file manually after Open edX standard css, escaping the issue of Open edX styles overriding our own.


Screenshots
========

![Alt text](/theme-index.jpg?raw=true "Index page screenshot")

Index page using the following blocks: hero-section-01, heading-plus-text-plus-cta, line-separator, course-listing-01 with course-tile-01 tile template, headig-plus-text-plus-cta, photo-grid-01

![Alt text](/theme-courses.jpg?raw=true "Course catalogue page screenshot")

Course catalogue page using the following blocks: hero-section-01, course-catalogue-01; with course tile set to course-tile-02, and discovery facet set to facet-01 and search input set to discovery-search-01.

![Alt text](/theme-course-about.jpg?raw=true "Open edX Default Theme Screenshot")

Single course about page using the following blocks: course-about-01, line separator, heading-plus-text-plus-cta

![Alt text](/theme-register.jpg?raw=true "Open edX Default Theme Screenshot")

Register page

![Alt text](/theme-dashboard.jpg?raw=true "Open edX Default Theme Screenshot")

Dashboard page


Theme Authoring
===============
To customize your theme:
- Install [Devstack](https://github.com/appsembler/devstack) either on your host or via [Sultan](https://github.com/appsembler/sultan). 
- Make a new branch in this repository e.g. `omar/header-color`
- Change the files you'd like and make a pull request against the release branch e.g. `juniper/main`.


How to use on Devstack
======================
 1. Go to your devstacks main directory and you should see the `edx-theme-codebase` directory besides the `edx-platform`
 2. To change to a specific customer's code:
   - Go to `customer_specific` directory
   - Checkout the customer's branch `$ git checkout juniper/tahoe`
 5. To compile the SCSS files run the following command in LMS:
    - `$ make lms-shell`
    - `$ paver update_assets lms --skip-collect`  # Compiles lms
    - `$ paver update_assets studio --skip-collect`  # Compiles Studio styles
 6. In another shell, use the following command to compile the SASS file:
   - `$ cd edx-theme-codebase`
   - `$ sassc lms/static/sass/main.scss lms/static/css/main.css`

	
Working with Translations
=========================
For information about working with translations, see the [Internationalization Support](http://edx.readthedocs.io/projects/xblock-tutorial/en/latest/edx_platform/edx_lms.html#internationalization-support) section of the [Open edX XBlock Tutorial](https://xblock-tutorial.readthedocs.io/en/latest/).

The translation strings of this theme are split into two POEditor.com projects:

 - [Appsembler Theme](https://poeditor.com/projects/view?id=213943)
 - [Appsembler Theme (JavaScript)](https://poeditor.com/projects/view?id=213945)

Working with POEditor
---------------------

Also ensure that the [POEditor client](https://github.com/lukin0110/poeditor-client) has the correct API access token
by setting the environment variable `POEDITOR_TOKEN` to the value from your [account settings](https://poeditor.com/account/api).

Push new strings to POEditor:
```
$ tox -e i18n-push
```

To get the latest translations from POEditor:
```
$ tox -e i18n-pull
```

Upgrading to another release
============================
 - The `OPENEDX_RELEASE` environment variable should be updated (hardcoded) in the `tox.ini` file,
so the i18n scripts work properly.
 - The `tox -e build-release-requirements` should be run to update the release file. Other tox scripts will fail otherwise due to missing requirements file.

License
=======

The code in this repo is licensed under the Apache 2.0 License.
See [LICENSE.txt](LICENSE.txt) for more info.
