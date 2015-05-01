# Introduction #

Basically the MESH Script contains a skeletton in which the main script's functionality becomes embedded. All labels within the skeletton and - if desired - in the script's labels may be extended by either pre execution, post execution, or completly by overriding the label and having it replaced with a new one. The major advantage of such an approach is that the script may be extended with modules which can be switched on and off just as needed without the need for changing the script.

# Major Drawbacks #

At 1st sight it is terribly complicated as the main skeletton script contains a vast numbers of functions and satellite scripts without a noticible relation. The modules do have to follow a specific grammar and include a bunch of keywords/labels. Because of the extensibility feature most of the code looks like spaghetti code at 1st sight. But MESH is not an acronym for My Extented Spaghetticode Hell, but for ModulE Scripting Helper. The reached comfort for the enduser has its price. Also the script cannot be compiled and extended with modules.