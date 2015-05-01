## Introduction ##

**saltservice** is the core of the local SALT Client. Started directly it shows up a easy to use GUI.
But **saltservice** can also be used as service, due it's implementation of IPC.
The IPC communication is internaly used by the **saltserviceAPI** to fully remotecontrol saltservice.
The **saltserviceAPI** allows 3th party tools to easy use the SALT package manager, for example to perform a installation/update of a stdLib file.


## Saltservice API ##

The API is mainly a collection of Wrapper-Functions for the InterProc communication (IPC) to get easy access to the saltservice and control it.

_more information comes soon_

## Repository Management ##

The local Salt Service can have any count of Repos which are checked out. The Repos can have redundancy (to secure the avaiability), but don't must have it.

_Furter, first implementation of SALT will have only support for StdLibs, but this may change in furter releases to support any scripts with own install instructions._

This will work compareable to apt-get under Ubuntu Linux.


### Files ###
  * saltservice.ahk       // salt core
  * saltserviceAPI.ahk    // Open API of IPC implementation
  * IPC.ahk               // Interproc Com Lib