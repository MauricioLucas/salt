;: Title: Yaml Parser by HotKeyIt

;
; Function: Yaml_Init
; Description:
;      Yaml_Init must be used at least once to start using Yaml parser.<br>Note when parameter is omited, all loaded files will be saved.
; Syntax: Yaml_Init(FilePath)
; Parameters:
;	   <b>Parameter</b> - <b>Description</b>
;	   FilePath - This must be the path of a yaml file.<br>Alternatively you can pass yaml text.<br>Also empty parameter can be passed to create new yaml database.
; Return Value:
;     When a new file is loaded, pointer to the database is returned. This can be used later for other Yaml functions.<br>When a file is already loaded, its pointer will be returned for anonymous access.
; Remarks:
;		A key can be a word (\w+) or any characters included in quotes (".+").<b>However you must not use dots (.) in keys and a key must not be a number. Because this will be in conflict with dot syntax and indexing service.
; Related:
; Example:
;		file:
;

;
; Function: Yaml_Get
; Description:
;      Yaml_Get can be used to retrieve value from database.
; Syntax: Yaml_Get(FilePath or pointer, Key)
; Parameters:
;	   <b>Parameter</b> - <b>Description</b>
;	   FilePath or pointer - This must be a ponter of a yaml database that was previously loaded via pointer:=Yaml_Init(FilePath).<br>Alternatively you can pass yaml text, in this case function will resolve the path to a pointer saved in internal database.
;	   Key - Key to get value from to get a subkey use dot syntax, e.g. data.key.subkey.<br>When a key contains subkeys, data.key.0 will contain count of subkeys and data.key.1 and so on the name of subkey. 
; Return Value:
;     Value/text stored for key will be returned.
; Remarks:
;		To check if a key does not exist use Yaml_Exist().
; Related:
; Example:
;		file:
;

;
; Function: Yaml_Set
; Description:
;      Yaml_Set can be used to set a value for a key in a database.
; Syntax: Yaml_Set(FilePath or pointer, Key, Value)
; Parameters:
;	   <b>Parameter</b> - <b>Description</b>
;	   FilePath or pointer - This must be a ponter of a yaml database that was previously loaded via pointer:=Yaml_Init(FilePath).<br>Alternatively you can pass yaml text, in this case function will resolve the path to a pointer saved in internal database.
;	   Key - Key to set value for. You can use dot syntax as well.
;	   Value - Value to store for above key.
; Return Value:
;     When a value was saved successfully, 0 is returned, else -1 is returned because dictionary was not found
; Remarks:
;		To check if a key exist before setting it use Yaml_Exist(), then if it does not exist use Yaml_Add(...) instead.
; Related:
; Example:
;		file:
;

;
; Function: Yaml_Add
; Description:
;      Yaml_Add can be used to create new key and a value for that key in a database.
; Syntax: Yaml_Add(FilePath or pointer, Key, Value)
; Parameters:
;	   <b>Parameter</b> - <b>Description</b>
;	   FilePath or pointer - This must be a ponter of a yaml database that was previously loaded via pointer:=Yaml_Init(FilePath).<br>Alternatively you can pass yaml text, in this case function will resolve the path to a pointer saved in internal database.
;	   Key - Key to set value for. You can use dot syntax as well.
;	   Value - Value to store for above key.
; Return Value:
;     When a value was saved successfully, 0 is returned, else -1 is returned because dictionary was not found
; Remarks:
;		If a section does not exist it will be created automatically. Indexing service will be updated as well.
; Related:
; Example:
;		file:
;

;
; Function: Yaml_Exist
; Description:
;      Yaml_Exist can be used to check if a key exist.
; Syntax: Yaml_Exist(FilePath or pointer, Key)
; Parameters:
;	   <b>Parameter</b> - <b>Description</b>
;	   FilePath or pointer - This must be a ponter of a yaml database that was previously loaded via pointer:=Yaml_Init(FilePath).<br>Alternatively you can pass yaml text, in this case function will resolve the path to a pointer saved in internal database.
;	   Key - Key to check for existence.
; Return Value:
;     When a key does not exist, 0 is returned.
; Remarks:
;		None.
; Related:
; Example:
;		file:
;

;
; Function: Yaml_Save
; Description:
;      Yaml_Save can be used to save an yaml file.
; Syntax: Yaml_Save(FilePath or pointer, FilePathTo)
; Parameters:
;	   <b>Parameter</b> - <b>Description</b>
;	   FilePath or pointer - This must be a ponter of a yaml database that was previously loaded via pointer:=Yaml_Init(FilePath).<br>Alternatively you can pass yaml text, in this case function will resolve the path to a pointer saved in internal database.
;	   FilePathTo - File to save database to. When this parameter is empty dump of database as text is returned only.
; Return Value:
;     A dump of the database as text is returned, else nothing is returned so the database was not found.
; Remarks:
;		None.
; Related:
; Example:
;		file:
;

/*
YamlText=
(
yaml 
--- # demo yaml 
'meine daten': 
  'alpha 1': 
    'mein text': value1
    'test': ja
  beta: 
    mytext: value2 
gamma: 
  mylist:
    - test
    - test it
    - test
anotherlist:
  - test
  - test2
  - test 3
---
other:
  _1:1
  _2:
    _1:1
    _2:2
  'zu ende': [ first, second]
)
;~ Yaml_Init(yaml:="x:\test.yml") ;see below, passing a dictionary pointer to Yaml_Get & Yaml_Set is faster than filepath !!!


;~ MsgBox % Yaml_Get(yaml) ;returns main sections separated by ,
;~ 		. "`n" Yaml_Get(yaml,0) ;count main sections
;~ 		. "`n" firstsection:=Yaml_Get(yaml,1) ;first section
;~ MsgBox % Yaml_Dump(yaml,var)
;~ MsgBox % Yaml_Dump(yaml,othervar,"data 1")
;~ MsgBox % Yaml_Get(yaml,firstsection ".0") ;count of items in first subsection
;~ MsgBox % Yaml_Get(yaml,firstsection ".1")
;~ MsgBox % Yaml_Get(yaml,firstsection "." Yaml_Get(yaml,firstsection ".1"))
;~ MsgBox % Yaml_Get(yaml,"push.name")
;~ MsgBox % Yaml_Get(yaml,"push.data")
;~ MsgBox % "Liste: " Yaml_Get(yaml,"push.liste") "`n" "Total: " Yaml_Get(yaml,"push.liste.0")
;~ 		 . "`n1: " Yaml_Get(yaml,"push.liste.1") "`n2: " Yaml_Get(yaml,"push.liste.2") "`n3: " Yaml_Get(yaml,"push.liste.3")
;~ Yaml_Set(yaml,"push.author","ich")
;~ Yaml_Dump(yaml,output)
;~ MsgBox % output

dic:=Yaml_Init(YamlText) ;initialize Yaml from text rather than from file
MsgBox ENDE
MsgBox % Yaml_Get(dic,"gamma.mylist")
MsgBox % Yaml_Get(dic,"gamma.mylist.0")
MsgBox % Yaml_Get(dic,"gamma.mylist.1")
;~ MsgBox % Yaml_Get(dic,"meine daten.alpha 1")
;~ MsgBox % Yaml_Get(dic,"meine daten.alpha 1.0")
;~ MsgBox % Yaml_Get(dic,"meine daten.gamma.mylist") " <<<"
;~ MsgBox % Yaml_Get(dic,"meine daten.gamma.mylist.0") " <<<"
;~ MsgBox % Yaml_Get(dic,Yaml_Get(dic,1) ".0")
;~ MsgBox % Yaml_Get(dic,Yaml_Get(dic,1) ".alpha 1")
;~ Yaml_Add(dic,"other.author","ich") ;add new item
;~ MsgBox % Yaml_Get(dic,"other.0")
MsgBox % Yaml_Save(dic,"") ;dump yaml database to text

;Create Yaml programatically
new:=Yaml_Init("") ;create empty yaml
Yaml_Set(new,"data.mydata.new1","value1") ;parent keys will be created automatically if they don't exist
Yaml_Set(new,"data.mydata.new1","value2") ;parent keys will be created automatically if they don't exist
Yaml_Set(new,"data.mydata 1.subkey","value1")
Yaml_Set(new,"data.mydata.subkey","value2")
MsgBox % Yaml_Get(new,"data.0") "=" Yaml_Get(new,"data")
MsgBox % Yaml_Get(new,"data.mydata.0") "=" Yaml_Get(new,"data.mydata")
MsgBox % Yaml_Get(new,"data.mydata.new.0") "=" Yaml_Get(new,"data.mydata.new")
MsgBox % Yaml_Save(new) ;dump new Yaml database to text

new:=Yaml_Init("") ;create empty yaml
Yaml_Set(new,"data.mydata.new1","value1")
Yaml_Set(new,"data.mydata.new1","value2") 
MsgBox % Yaml_Get(new,"data.mydata.new1")
Yaml_Add(new,"data.mydata.new2","value1")
Yaml_Add(new,"data.mydata.new2","value2") 
MsgBox % Yaml_Get(new,"data.mydata.new2")
Yaml_Dump(new,var:="")
MsgBox % var




OnExit, SaveAllYamlFiles ;using Yaml_Init() all loaded files will be saved

ExitApp

SaveAllYamlFiles: ;OnExit subroutine so no changes are lost.
Yaml_Init()
ExitApp
*/
;~ new:=Yaml_Init("")
;~ loop,1
;~ While, % (3 > x:=A_Index ) 
;~ While, % (3 >  y:=A_Index ) 
;~ While, % (3 >  z:=A_index ) 
;~ Loop, 3 
;~ {
;~ count++
;~ data%count% :="data.xset " x ".yset " y ".zset " z ".entry" a_Index
;~ value%count%:= "value " A_index
;~ data.= data%count% " = " value%count% "`n"
;~ }
;~ MsgBox % data
;~ Loop % count
;~ 	If !Yaml_Exist(data%A_Index%)
;~ 		Yaml_Add(new,data%A_Index%,value%A_Index%)
;~ Yaml_Add(new,"test.value1","value1")
;~ Yaml_Add(new,"test.value2","value1")
;~ Yaml_Add(new,"test.value3","value1")
;~ MsgBox % Yaml_Save(new) ;dump new Yaml database to text 

;~ ExitApp
Yaml_Add(pYaml,key1="",key2=""){
	If (recursive:=InStr(key1,".")=1 ? 1 : 0)
		StringTrimLeft,key1,key1,1
	If InStr(key1,".")
		parent:=SubStr(key1,1,InStr(key1,".",1,0)-1)
	StringTrimLeft,key,key1,% InStr(key1,".",1,0)
	If (parent!="" && !Yaml_Exist(pYaml,key1))
		Yaml_Add(pYaml,"." parent,key)
	If !Yaml_Exist(pYaml,key1){
		count:=Yaml_Get(pYaml,parent!="" ? (parent "." 0) : 0)
		count++
		Yaml_Assign(pYaml,parent!="" ? (parent "." 0) : 0,count)
		Yaml_Assign(pYaml,parent!="" ? (parent "." count) : count,key)
	} else if (!recursive){
		count:=Yaml_Get(pYaml,key1 "." 0)
		If (count=""){
			count=2
			Yaml_Assign(pYaml,key1 ".1",Yaml_Get(pYaml,key1))
		} else
			count++
		Yaml_Assign(pYaml,key1 "." 0,count)
		Yaml_Assign(pYaml,key1 "." count,key2)
	}
	key2:=(RegExMatch(Key2,"^\s?\w+\s?$") ? key2 : "'" key2 "'")
	Yaml_Assign(pYaml,key1,Yaml_Get(pYaml,key1)="" ? key2 : Yaml_Get(pYaml,key1) "," key2)
}
Yaml_Exist(pYaml,Key=""){
	VarSetCapacity(var,16,0),NumPut(8, var)
	If A_IsUnicode
		wStr:=Key
	else
		VarSetCapacity(wStr, StrLen(Key)*2+1,0)
		,DllCall("MultiByteToWideChar", "UInt",0, "UInt",0, "UInt",&Key, "Int",-1, "UInt",&wStr, "Int",StrLen(Key)+1)
	NumPut(DllCall("oleaut32\SysAllocString","Str",wStr),var,8)
	DllCall(NumGet(NumGet(pYaml+0)+48), "UInt",pYaml, "UInt",&var, "IntP",bExist)
	DllCall("oleaut32\SysFreeString", "UInt",NumGet(var,8)),NumPut(0,var,8)
	Return bExist
}

Yaml_Dump(pYaml,ByRef Output,key=""){
	If (key=""){
;~ 			Output:="yaml`n"
		Loop % Yaml_Get(pYaml,0)
		{
			mainkey:=Yaml_Get(pYaml,A_Index)
			Output .= Yaml_Get(pYaml,mainkey ".")="" ? "" : Yaml_Get(pYaml,mainkey ".") "`n" ;"---`r`n"
			value:=Yaml_Get(pYaml,mainkey)
			Output .= (RegExMatch(mainkey,"^\w+$") ? mainkey : ("'" mainkey "'")) ":"
			if (sub:=Yaml_Get(pYaml,mainkey "." 1)){
				if !Yaml_Exist(pYaml,mainkey "." sub){
					Output .= "`n"
					Loop % Yaml_Get(pYaml,mainkey ".0"){
						value:=Yaml_Get(pYaml,mainkey "." A_Index)
						Output .= "  - " (RegExMatch(value,"^\w+$") ? value : "'" value "'") "`n"
					}
					Continue
				} else Output .= "`n"
			} else Output .= " " value "`n"
			Yaml_Dump(pYaml,Output,"." mainkey)
		}
		return Output
	} else {
		If (-1 < (start:=RegExMatch(key,"[^\.]")-1)){
			Loop % start*2
				recurse .= A_Space
			StringTrimLeft,_key,key,%start%
		} else _key:=key
		Loop % Yaml_Get(pYaml,_key "." 0){
			key1:=Yaml_Get(pYaml,_key "." A_Index)
			Output .= Yaml_Get(pYaml,_key "." key1 ".")="" ? "" : Yaml_Get(pYaml,_key "." key1 ".") "`n"
			value:=Yaml_Get(pYaml,_key "." key1)
			Output .= recurse (RegExMatch(key1,"^\w+$") ? key1 : ("'" key1 "'")) ":"
			if (sub:=Yaml_Get(pYaml,_key "." key1 ".1")){
				if !Yaml_Exist(pYaml,_key "." key1 "." sub){
					Output .= "`n"
					Loop % Yaml_Get(pYaml,_key "." key1 ".0"){
						value:=Yaml_Get(pYaml,_key "." key1 "." A_Index)
						Output .= recurse "  - " value "`n"
					}
					Continue
				} else Output .= "`n"
			} else Output .= " " value "`n"
			Yaml_Dump(pYaml,Output, "." key "." key1)
		}
	}
	Return output
}

Yaml_Save(pYaml,ToFile=""){
	Yaml_Dump(pYaml,file)
	If (ToFile!="" && FileExist(ToFile)){
		StringReplace,savefile,file,`n,`r`n,A
		FileMove,%ToFile%,%ToFile%.bkp.yaml
		If FileExist(ToFile){
			MsgBox Error Saving File
		}
		FileAppend,%savefile%,%ToFile%
		If (ErrorLevel){
			MsgBox Error Saving File
		}
		FileDelete,%ToFile%.bkp.yaml
		If (ErrorLevel){
			MsgBox Error Saving File
			FileDelete,%ToFile%.bkp
			FileMove,%ToFile%.bkp.yaml,%ToFile%
		}
	} else if (ToFile!=""){
		StringReplace,savefile,file,`n,`r`n,A
		FileAppend,%savefile%,%ToFile%
			If (ErrorLevel){
				MsgBox Error Saving File
			}
	}
	Return file
}

Yaml_Clone(pYaml){
	static CLSIDString:="{EE09B103-97E0-11CF-978F-00A02463E06F}", IIDString:="{42C642C1-97E1-11CF-978F-00A02463E06F}", StrGet:="StrGet"
	If (!Init && Init:=1){ ;Initialize COM and create database
		DllCall("ole32\CoInitialize", "UInt",0),VarSetCapacity(var1, 16),VarSetCapacity(var2, 16)
		NumPut(8, var1),NumPut(8, var2),VarSetCapacity(CLSID, 16),VarSetCapacity(wKey, 79),VarSetCapacity(IID, 16)
		If A_IsUnicode
			DllCall("ole32\CLSIDFromString", "Str",CLSIDString, "Str",CLSID)
			,DllCall("ole32\CLSIDFromString", "Str",IIDString, "Str",IID)
		else
			DllCall("MultiByteToWideChar", "UInt",0, "UInt",0, "UInt",&CLSIDString, "Int",-1, "UInt",&wKey, "Int",39)
			,DllCall("ole32\CLSIDFromString", "Str",wKey, "Str",CLSID)
			,DllCall("MultiByteToWideChar", "UInt",0, "UInt",0, "UInt",&IIDString, "Int",-1, "UInt",&wKey, "Int",39)
			,DllCall("ole32\CLSIDFromString", "Str",wKey, "Str",IID)
	}
	DllCall("ole32\CoCreateInstance", "Str",CLSID, "UInt",0, "UInt",5, "Str",IID, "UIntP",_pYaml) ; CLSCTX=5
	,DllCall(NumGet(NumGet(_pYaml+0)+72), "UInt",_pYaml, "Int",1)
	VarSetCapacity(var1, 16),VarSetCapacity(var2, 16),NumPut(8, var1),NumPut(8, var2)
	DllCall(NumGet(NumGet(pYaml+0)+80), "UInt",pYaml, "UIntP",penum) ; create key-list in penum
	Loop {
		If (DllCall(NumGet(NumGet(penum+0)+12), "UInt",penum, "UInt",1, "UInt",&var1, "UInt",0)) {
			DllCall(NumGet(NumGet(penum+0)+8), "UInt",penum)   ; END: destroy key-list
			penum=                                                  ; signal end of list
			ErrorLevel=                                                  ; empty
			Return _pYaml     		                                           
		}
		If A_IsUnicode
			wStr:=%StrGet%(NumGet(var1,8))
		else
			nLen := DllCall("WideCharToMultiByte", "UInt",0, "UInt",0, "UInt",NumGet(var1,8), "Int",-1, "UInt",0, "Int",0, "UInt",0, "UInt",0)
			,VarSetCapacity(wKey, nLen)
			,DllCall("WideCharToMultiByte", "UInt",0, "UInt",0, "UInt",NumGet(var1,8), "Int",-1, "Str",wKey, "Int",nLen, "UInt",0, "UInt",0)
		DllCall("oleaut32\SysFreeString", "UInt",NumGet(var1,8)),NumPut(0,var1,8)
		Yaml_Assign(_pYaml,wKey,Yaml_Get(pYaml,wKey))
	}
}

Yaml_Get(pYaml,key1=""){
	static StrGet:="StrGet"
	VarSetCapacity(var1, 16),VarSetCapacity(var2, 16),NumPut(8, var1),NumPut(8, var2)
	If A_IsUnicode
		wStr:=key1
	else
		VarSetCapacity(wStr, StrLen(Key1)*2+1,0)
		,DllCall("MultiByteToWideChar", "UInt",0, "UInt",0, "UInt",&Key1, "Int",-1, "UInt",&wStr, "Int",StrLen(Key1)+1)
	NumPut(DllCall("oleaut32\SysAllocString","Str",wStr),var1,8)
	DllCall(NumGet(NumGet(pYaml+0)+48), "UInt",pYaml, "UInt",&var1, "IntP",bExist)
	If bExist {
		DllCall(NumGet(NumGet(pYaml+0)+36), "UInt",pYaml, "UInt",&var1, "UInt",&var2)
		If A_IsUnicode
			Key2:=%StrGet%(NumGet(var2,8))
		else
			nLen := DllCall("WideCharToMultiByte", "UInt",0, "UInt",0, "UInt",NumGet(var2,8), "Int",-1, "UInt",0, "Int",0, "UInt",0, "UInt",0)
			,VarSetCapacity(Key2, nLen,0)
			,DllCall("WideCharToMultiByte", "UInt",0, "UInt",0, "UInt",NumGet(var2,8), "Int",-1, "Str",Key2, "Int",nLen, "UInt",0, "UInt",0)
		DllCall("oleaut32\SysFreeString", "UInt",NumGet(var2,8)),NumPut(0,var2,8)
	}
	DllCall("oleaut32\SysFreeString", "UInt",NumGet(var1,8)),NumPut(0,var1,8)
	Return Key2
}
Yaml_Set(pYaml,key1="",key2=""){
	If !Yaml_Exist(pYaml,key1){
;~ 			MsgBox % key1
		Yaml_Add(pYaml,key1,key2)
;~ 			MsgBox
		return
	}
	Yaml_Assign(pYaml,key1,key2)
	Return
}
Yaml_Assign(pYaml,key1,key2=""){
	Loop % (2){
		VarSetCapacity(var%A_Index%,16,0),NumPut(8,var%A_Index%)
		If A_IsUnicode
			wStr:=Key%A_Index%
		else
			VarSetCapacity(wStr, StrLen(Key%A_Index%)*2+1,0)
			,DllCall("MultiByteToWideChar", "UInt",0, "UInt",0, "UInt",&Key%A_Index%, "Int",-1, "UInt",&wStr, "Int",StrLen(Key%A_Index%)+1)
		NumPut(DllCall("oleaut32\SysAllocString","Str",wStr),var%A_Index%,8)
	}
	DllCall(NumGet(NumGet(pYaml+0)+32), "UInt",pYaml, "UInt",&var1, "UInt",&var2)  ; 8 (Set0 -> 7)
	Loop 2
		DllCall("oleaut32\SysFreeString", "UInt",NumGet(var%A_Index%,8)),NumPut(0,var%A_Index%,8)
}
Yaml_Insert(_pYaml,Yaml_File,MainItem0){
	If FileExist(Yaml_File){
		FileRead,Yaml_File_,%Yaml_File%
		If (ErrorLevel){
			MsgBox Error Reading File
			Return
		}
	} else Yaml_File_:=Yaml_File
	Loop,Parse,MainItem0,.
	{
		space.=A_Space A_Space
		_depth:=A_Index-1
		MainItem%_depth%:=A_LoopField
	}
	Loop,Parse,Yaml_File_,`n,`r
	{
;~ 		MsgBox % A_LoopField
		If A_LoopField=
			Continue
		if !create
			Key1:="",Key2:="",Key3:="",Item:=""
		If (!create){
			RegExMatch(A_LoopField,"^\s+-\s(.*)$",Key)
			If (Key1!=""){
				count:=Yaml_Get(_pYaml,LastItem ".0")
				count++
;~ 				MsgBox % count "`n" LastItem "`n" Yaml_Get(_pYaml,LastItem)
				Yaml_Assign(_pYaml,LastItem "." count,Key1)
				Yaml_Assign(_pYaml,LastItem ".0", count)
				item:=Yaml_Get(_pYaml,LastItem)
;~ 				key1:=(RegExMatch(Key1,"^\s?\w+\s?$") ? key1 : "'" key1 "'")
				Yaml_Assign(_pYaml,LastItem,item="" ? Key1 : item "," key1)
;~ 				MsgBox % Yaml_Get(_pYaml,LastItem)
				Continue
			}
			Loop 3
				Key%A_Index%=
			RegExMatch(A_LoopField,"^(\s*)(\w+)\s?:\s?(.*)\s?$",Key)
			If (Key2=""){
				Loop 3
					 Key%A_Index%=
				RegExMatch(A_LoopField,"^(\s*)'(.+)':\s?(.*)\s?$",Key)
			}
			If (Key2=""){
				LastLine.=Space A_LoopField "`n"
				Continue
			}
			If (SubStr(LastLine,0)="`n")
				StringTrimRight,LastLine,LastLine,1
			depth:=Round(Strlen(Key1)/2,0)+_depth+1
;~ 			MsgBox % depth
			MainItem%depth%:=Key2
			Item:=MainItem0
;~ 			MsgBox % "1`n" A_LoopField "`n" Item
			While % ((i:=A_Index) && depth>A_Index)
				Item.= "." . MainItem%i%
;~ 			ListVars
;~ 			MsgBox % "2`n" A_LoopField "`n" Item
			If !Yaml_Exist(_pYaml,Item "." key2){
				MainItem:=Yaml_Get(_pYaml,Item)
				count:=Yaml_Get(_pYaml,Item . ".0")
				count++
				Yaml_Assign(_pYaml,Item . ".0",count)
				Yaml_Assign(_pYaml,Item . "." . count,key2)
				Yaml_Assign(_pYaml,Item,MainItem . (MainItem="" ? "" : ",") . (RegExMatch(Key2,"^\s?\w+\s?$") ? key2 : "'" key2 "'"))
			}
			Item.="." . key2
			Yaml_Assign(_pYaml,Item,key3)
			LastItem:=Item
			If LastLine!=
				Yaml_Assign(_pYaml,Item . ".",LastLine),LastLine:=""
;~ 			MsgBox % "exist: " Yaml_Exist(_pYaml,Item)
		} else 
			Yaml_Assign(_pYaml,Item,Yaml_Get(_pYaml,Item) . A_LoopField)
		If RegExMatch(Key3,"^\s*""")
			create:=1
		if (create && RegExMatch(A_LoopField,"""\s*$"))
			create:=0
	}
}
Yaml_DeleteAll(pYaml){
	DllCall(NumGet(NumGet(pYaml+0)+68), "UInt",pYaml) ;delete all keys
}
Yaml_Delete(pYaml,key){
	VarSetCapacity(var1,16,0),NumPut(8,var1)
	If A_IsUnicode
		wStr:=key
	else
		VarSetCapacity(wStr, StrLen(Key)*2+1,0)
		,DllCall("MultiByteToWideChar", "UInt",0, "UInt",0, "UInt",&Key, "Int",-1, "UInt",&wStr, "Int",StrLen(Key)+1)
	NumPut(DllCall("oleaut32\SysAllocString","Str",wStr),var1,8)
	DllCall(NumGet(NumGet(pYaml+0)+64), "UInt",pYaml, "UInt",&var1)
	DllCall("oleaut32\SysFreeString", "UInt",NumGet(var1,8)),NumPut(0,var1,8)
}
Yaml_Init(Yaml_File="?",pointerYaml=""){
	static pYaml, CLSID,IID,Init,FileIndex
	static CLSIDString:="{EE09B103-97E0-11CF-978F-00A02463E06F}", IIDString:="{42C642C1-97E1-11CF-978F-00A02463E06F}"
	If (!Init && Init:=1){ ;Initialize COM and create database
		DllCall("ole32\CoInitialize", "UInt",0),VarSetCapacity(var1, 16),VarSetCapacity(var2, 16)
		NumPut(8, var1),NumPut(8, var2),VarSetCapacity(CLSID, 16),VarSetCapacity(wKey, 79),VarSetCapacity(IID, 16)
		If A_IsUnicode
			DllCall("ole32\CLSIDFromString", "Str",CLSIDString, "Str",CLSID)
			,DllCall("ole32\CLSIDFromString", "Str",IIDString, "Str",IID)
		else
			DllCall("MultiByteToWideChar", "UInt",0, "UInt",0, "UInt",&CLSIDString, "Int",-1, "UInt",&wKey, "Int",39)
			,DllCall("ole32\CLSIDFromString", "Str",wKey, "Str",CLSID)
			,DllCall("MultiByteToWideChar", "UInt",0, "UInt",0, "UInt",&IIDString, "Int",-1, "UInt",&wKey, "Int",39)
			,DllCall("ole32\CLSIDFromString", "Str",wKey, "Str",IID)
		DllCall("ole32\CoCreateInstance", "Str",CLSID, "UInt",0, "UInt",5, "Str",IID, "UIntP",pYaml) ; CLSCTX=5
		DllCall(NumGet(NumGet(pYaml+0)+72), "UInt",pYaml, "Int",0) ; Set compare mode binary (casesensitive)
	}
	If (Yaml_File="?"){
		Loop % Yaml_Get(pYaml,0)
			Yaml_Save(Yaml_Get(pYaml,Yaml_Get(pYaml,A_Index)),Yaml_Get(pYaml,A_Index))
		Return
	}
	Loop,%Yaml_File%
		Yaml_File:=A_LoopFileLongPath
	If (!Yaml_Exist(_pYaml,Yaml_File) && !Yaml_Exist(pointerYaml))
		DllCall("ole32\CoCreateInstance", "Str",CLSID, "UInt",0, "UInt",5, "Str",IID, "UIntP",_pYaml) ; CLSCTX=5
		,DllCall(NumGet(NumGet(_pYaml+0)+72), "UInt",_pYaml, "Int",1) ; Set compare mode text (caseinsensitive)
	else if (pointerYaml)
		_pYaml:=pointerYaml
	else
		return Yaml_Get(pYaml,Yaml_File) ;DllCall(NumGet(NumGet(pYaml+0)+68), "UInt",pYaml) ;delete all keys
	If FileExist(Yaml_File){
		FileRead,Yaml_File_,%Yaml_File%
		If (ErrorLevel){
			MsgBox Error Reading File
			Return
		}
		FileIndex++
		Yaml_Assign(pYaml,0,FileIndex)
		Yaml_Assign(pYaml,FileIndex,Yaml_File)
		Yaml_Assign(pYaml,Yaml_File,_pYaml)
	} else Yaml_File_:=Yaml_File
	Loop,Parse,Yaml_File_,`n,`r
	{
		If A_LoopField=
			Continue
		if !create
			Key1:="",Key2:="",Key3:="",Item:=""
		If (MainItem0="" || (!create && !RegExMatch(A_LoopField,"^\s"))){
			If !RegExMatch(A_LoopField,"^(\w+)\s?:\s?(.*)\s*$",MainItem)
				If !RegExMatch(A_LoopField,"^'(.+)'\s?:\s?(.*)\s*$",MainItem){
					Key1=
					RegExMatch(A_LoopField,"^\s+-\s(.*)$",Key)
					If (Key1!=""){
						count:=Yaml_Get(_pYaml,MainItem0 ".0")
						count++
						Yaml_Assign(_pYaml,MainItem0 "." count,Key1)
						Yaml_Assign(_pYaml,MainItem0 ".0", count)
						item:=Yaml_Get(_pYaml,MainItem0)
;~ 						key1:=(RegExMatch(key1,"^\s?\w+\s?$") ? key1 : "'" key1 "'")
						Yaml_Assign(_pYaml,MainItem0,item="" ? Key1 : item "," key1)
						Continue
					}
					LastLine.=A_LoopField "`n"
					Continue
				}
			MainItem0:=MainItem1
			ItemCount++
			MainItem:=Yaml_Get(_pYaml,"") . (Yaml_Get(_pYaml,"")!="" ? "," : "") . (RegExMatch(MainItem0,"^\s?\w+\s?$") ? MainItem0 : "'" MainItem0 "'")
			Yaml_Assign(_pYaml,"",MainItem)
			Yaml_Assign(_pYaml,0,ItemCount)
			Yaml_Assign(_pYaml,ItemCount,MainItem0)
			Yaml_Assign(_pYaml,MainItem0,MainItem2)
			If (SubStr(LastLine,0)="`n")
				StringTrimRight,LastLine,LastLine,1
			Yaml_Assign(_pYaml,MainItem0 ".",LastLine)
			MainItem:="",MainItem1:="",MainItem2:="",LastLine:=""
			LastItem:=MainItem0
			Continue
		}
;~ 		MsgBox % Yaml_Get(_pYaml,0)
		If (!create){
			Key1=
			RegExMatch(A_LoopField,"^\s+-\s(.*)$",Key)
			If (Key1!=""){
				count:=Yaml_Get(_pYaml,LastItem ".0")
				count++
;~ 				MsgBox % count "`n" LastItem "`n" Yaml_Get(_pYaml,LastItem)
				Yaml_Assign(_pYaml,LastItem "." count,Key1)
				Yaml_Assign(_pYaml,LastItem ".0", count)
				item:=Yaml_Get(_pYaml,LastItem)
;~ 				key1:=(RegExMatch(Key1,"^\s?\w+\s?$") ? key1 : "'" key1 "'")
				Yaml_Assign(_pYaml,LastItem,item="" ? Key1 : item "," key1)
;~ 				MsgBox % Yaml_Get(_pYaml,LastItem)
				Continue
			}
			Loop 3
				Key%A_Index%=
			RegExMatch(A_LoopField,"^(\s+)(\w+)\s?:\s?(.*)\s?$",Key)
			If (Key2=""){
				Loop 3
					 Key%A_Index%=
				RegExMatch(A_LoopField,"^(\s+)'(.+)':\s?(.*)\s?$",Key)
			}
			If (Key2=""){
				LastLine.=A_LoopField "`n"
				Continue
			}
			If (SubStr(LastLine,0)="`n")
				StringTrimRight,LastLine,LastLine,1
			depth:=Round(Strlen(Key1)/2,0)
			MainItem%depth%:=Key2
			Item:=MainItem0
;~ 			MsgBox % "1`n" A_LoopField "`n" Item
			While % ((i:=A_Index) && depth>A_Index)
				Item.= "." . MainItem%i%
;~ 			ListVars
;~ 			MsgBox % "2`n" A_LoopField "`n" Item
			If !Yaml_Exist(_pYaml,Item "." key2){
				MainItem:=Yaml_Get(_pYaml,Item)
				count:=Yaml_Get(_pYaml,Item . ".0")
				count++
				Yaml_Assign(_pYaml,Item . ".0",count)
				Yaml_Assign(_pYaml,Item . "." . count,key2)
				Yaml_Assign(_pYaml,Item,MainItem . (MainItem="" ? "" : ",") . (RegExMatch(Key2,"^\s?\w+\s?$") ? key2 : "'" key2 "'"))
			}
			Item.="." . key2
			Yaml_Assign(_pYaml,Item,key3)
			LastItem:=Item
			If LastLine!=
				Yaml_Assign(_pYaml,Item . ".",LastLine),LastLine:=""
;~ 			MsgBox % "exist: " Yaml_Exist(_pYaml,Item)
		} else 
			Yaml_Assign(_pYaml,Item,Yaml_Get(_pYaml,Item) . A_LoopField)
		If RegExMatch(Key3,"^\s*""")
			create:=1
		if (create && RegExMatch(A_LoopField,"""\s*$"))
			create:=0
	}
	Return _pYaml
}