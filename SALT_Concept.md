# **SALT** #

SALT provides basic PACKET MANAGER functionalitys. It has special features for SdtLib functions, but is not limited to them.


# 1.	Backend #
The Backend  includes the sqllite Database, with some php scripts. In the database the full PACKAGES (also StdLib) with a unique PACKEAGE ID are hosted. The backend uses http GET/POST (php skript) as API to communicate with the clients.

This includes all relevant data (code/binarys/other files) and other relevant infos:
  * Version information
  * Dependencies
  * License, Coder
  * Links to discussion
  * Links to samples
  * Links to documentation
For more informations about a SALT-PACKAGE see the main article. (SALT-PACKAGE)


Server is mirrored to give redundancy.

# 1.	Frontend #
## 1.1	Web Frontend ##
### 1.1.1	User Account ###
Authenticate Users. (Trusted developers and so on…) Allow edit/update owned StdLib’s. May use the autohotkey.com User/PW; to authenticate.

### 1.1.2	Create StdLib Form ###
Submit new StdLib Functions. Except some trusted coders, the submitted code is reviewed by SALT staff, before it’s added to the downloadable contend of the client.

Unlike that, submitted StdLib’s (or modifications; new versions) are instantly accessible through the **Web-Frontend** for every one. So after creation/update from the StdLib, the developer can post the **Web-Frontend** Link to the AHK Forum, and doesn't have to wait until his code is checked.

### 1.1.3	SALT-StdLib-Frontend ###
This provides an online StdLib code review – as it’s done until now in the AHK Forum for anyone. So the Developer has only to create a new StdLib on SALT and can back link from the AHK Forum to the **Web-Frontend**  This prevents developers from having multiple places where they have to take care to have their StdLib’s up to date.

### 1.1.4	Edit StdLib-Frontend ###
The owner of a StdLib project can easily edit/update his StdLib. Here rules the same policy which is used by the creation of a StdLib:
The update is instantly accessible through the **Web-Frontend** to give the same possibilities that exist now. But (except of trusted developer), the update isn’t available to the SALT-client, until the SALT-staff has reviewed the code and marked as secure.

In Fact, this is the main advantage to the “Forum/Thread-Hosted-Code” version of SALT. So it’s much more secure to the users.

## 1.2	SALT Client (saltservice / saltservice-GUI) ##

We have a local service "saltservice", without GUI. It provides a OPEN API (saltserviceAPI.ahk) which is used for the saltservice-GUI and also 3th party scripts can use the SALT functionality.

The saltservice-GUI is a Tool for any AHK Developer/User. Features:
  * Keep Existing StdLib’s up to date
  * Automatic install StdLib’s which depends on another.
  * Browse existing StdLib’s; Search by keywords.
  * SALT-client has an open API, therefore Scripts can use it to get the SALT-Client installing StdLib’s on which the script itself depend on.
  * saltservice-GUI frontend is to be build on a modular structure, this allows having modules for staffmembers for easy reviewing, for StdLib coders which can easily update through API, a module for browsing the discussion.