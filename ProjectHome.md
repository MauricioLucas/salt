![http://salt.googlecode.com/svn/trunk/site/images/logo_full.png](http://salt.googlecode.com/svn/trunk/site/images/logo_full.png)

# SALT - Standard AutoHotkey Library Transfer #

## A quick sum up ##
This project consists of multiple parts:

  * a frontend script
> This script will incorporate modules and allow coders aswell as users to pull or push information to SALT services. A module for staff members verifying public sent in scripts will also be available.
  * a script API
> This API 'll allow to control, eg install update or upgrade existing stdLib files from other scripts
  * a server backend
> This will be based in php and include a SQLite server which will be used for mirroring services
  * a webbased API
> This will be used for the script and as officially documented also by other scripts (if anybody wants to)
  * a webbased frontend
> This allows same functionality as the script. eg update, propose, install, update, and verify

## This is what the project will provide ##
  * An easy way for browsing all available stdLibs from web or salt script
  * for developer: easy way for uploading and maintaining scripts on salt.domain.tld (eg salt.autohotkey.com) this helps avoiding doubled or tripled maintenance work, since all stdLib script are available at once place
  * staff members for verifying public proposals
  * mirrored services - due to the fact, that everything is hosted is a scalable one-file database (SQLite)
  * easy links and searchable categories for each script.
  * if desired existing stdLib script may be updates instantly by the time it gets updates in the content stream
  * dependcies management and versioning

Supporter are welcome. Anonymous checkouts via SVN:

`svn checkout http://salt.googlecode.com/svn/trunk/ salt-read-only`

## Where to start? ##

  * Read about the idea of this project at the [SALT\_Concept](SALT_Concept.md)
  * Read about the [AHK Script](saltClientScript.md) it provides
  * [WTH is PureMESH](PureMESH.md)?!??

Greets
dR
