

# Introduction #

The SALT script is the swiss army knife script for stdLibs. Due to its modular nature it might be extended by modules without breaking its functionality. It's supposed to be an universal tool for any audience. This inlcudes but is not limited to: Users, who wish to browse and use SALT, stdLib developers, and staffmembers.


# Details #

The SALT client is build upon PureMESH (Pure ModulE Scripting Helper, that is). The modules to be included in the very 1st version of the SALT client:
  * PureMESH ModuleManager
  * YAML Parser
  * SALT ContentStream Browser
  * SALT Delta StreamUpdater
  * SALT Delta StdLibUpdater
  * StdLib DirectJumperBrowser
  * SALT StdLib Proposer
  * SALT StdLib Uploader
  * SALT Staff Helper
  * SALT DeltaMerger

## Rough details about the modules ##

### PureMESH ModuleManager ###

This is a part of PureMESH. It allows enabling or disabling modules in a MESH Script.

### YAML Parser ###

YAML is a human readable method to store data. Same as XML, or JSON but better to understand when not being a computer and with less overhead. It was generated as an alternative to XML and now currently has evolved to a comparable standard. The default filesuffix is ".yml". The YAML Parser needed in this project doenst need to be a fully qualified YAML parser, but basically just needs to "understand" the concepts of lists and name-value-pairs. An additional feature 'd be an anonymized accessor so our script may work without knowing details about the YAML stream (unlike XPATH, but comparable to JavaScript's DOM traversing).

Have a look at [this primer](http://components.symfony-project.org/yaml/trunk/book/02-YAML) to learn more about YAML.

### SALT ContentStream Browser ###

The content stream browser needs to understand which context it is actually browsing. It's main task is to display the parsed information in a nice GUI.

### SALT Delta StreamUpdater ###

The delta stream updater is supposed to be capable to update sync offline database with stream details it got from the SALT service.

### SALT Delta StdLibUpdater ###

The StdLib Updater takes care of versioning and updating existing stdLib files where desired. Under no circumstances it should destroy any existing configurations and thus break scripts.

### StdLib DirectJumperBrowser ###

This is supposed to be a build in browser control (see this one: [Skan's 27L MiniBrowser](http://www.autohotkey.com/forum/viewtopic.php?t=34358)) which jumps directly at a standardLib discussion, documenation, samples, author's page whatever.

### SALT StdLib Proposer ###

This module is intended to be a module for public audience to name and upload a script as a standardLib candidate. It features the same functions as the webfrontend.

### SALT StdLib Uploader ###

This module is intended to be a module for StdLib Developers to upload or update a script standardLib candidate. It features the same functions as the webfrontend.

### SALT Staff Helper ###

This module is intended to be a module for staff members to review proposed scripts standardLib candidates. It features the same functions as the webfrontend.

### SALT DeltaMerger ###

The deltaMerger is a script which works with standard diffs so it is capable to modify an existing script by just downloading and changing the neccessary data chunks which actually changed.

Have a look at this [GoogleCode Project](http://code.google.com/p/google-diff-match-patch/)