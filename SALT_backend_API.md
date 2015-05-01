# Introduction #

The SALT backend is a webserver, including a Database and PHP Skripts. Connection to the backend is done through http.
You have to use GET/POST parameters to comunicate with /api/server.php
The default charset used for communication is utf-8.

Authentication is very improtant, as we have autoupdated code (stdlib) and other sensitive data. Security bases on standard implemantation of user-pw generated session id's. -> Cookies


## DATA TYPES ##

> ### PACKAGE\_DESCRIPTOR ###
> A yaml object, which fully describes a PACKAGE. Including filesize,author, version information, genre...and more. Standard format is yaml.

> ### PACKAGE\_DATA ###
> All data and installation instructions for saltservice, to install a PACKAGE.

> ### PACKAGE\_ID ###
> Identifier for a Package. Primary key in the database.

## Authentication ##

Authetification will be token based. The token used by SALT backend is a cookie containing the session information. Once the script's user identified to salt's backend the session will be kept alive for 5 minutes without interaction. Successfull access to the services will keep the session alive, any unsuccessfull interactions (such as wrong authentification, staff actions, admin actions etc) will terminate the session.

## Supported commands for backend ##

> The generic usage of commands is to be used in the form
```
    <SALT's backend uri>/<Command>/<Feature>/<Parameter1>/<Parameter2>
```

  * `VERSION`
    * returns current webApi Version

  * `LOGIN/<Username>/<Password>`
    * identifies the user **Username** with the password **Password** to SALT's backend


## Information Gathering ##

> The command for information gathering is **GET**.

> It is to be used in the form
```
    <SALT's backend uri>/GET/<Feature>/<Parameter1>/<Parameter2>
```

### Following features are supported ###

  * `LIST`
    * returns a collection of PACKAGE\_DESCRIPTORs as a yaml notated list

  * `DATA/<PacketId>/<VersionInfo>`

> Note: VersionInfo may be ommitted. In that case the latest package will be send

  * returns all data, and information to install the desired Packet. **This has to be clarified**

  * `DESCRIPTOR/<PacketId>`
    * returns all details for the specified packetId. The output is yaml notated.


## Information Commiting ##

> The command for information gathering is **CREATE**.

> It is to be used in the form
```
    <SALT's backend uri>/CREATE/<Feature>
```

### Features only to be used as postdata ###

  * `PACKAGE`
    * post: data::PACKET\_DATA, desc::PACKAGE\_DESCRIPTOR
    * returns PACKET\_ID or ERR::ERR\_CODE

  * `UPDATE`
    * post: data::PACKET\_DATA, desc::PACKAGE\_DESCRIPTOR, PacketId::PACKAGE\_ID
    * returns SUCCESS or ERR::ERR\_CODE

## Errorcodes ##

> Errorcodes will follow.