/**
 * A static memory constructor for avoiding the need for global variables
 *
 * @param var    - the name of the storage
 * @param value  - the value to be passed
 * @param method - may be one of the following: "GET", "SET", "DEL"
 *
 * @return String - the stored value, if any
 */
db_statix( var, value = "", method = "GET" )
{	; (w) by dR - Version 2010-02-25
	static
	
	if ( method = "DEL" ) {
		VarSetCapacity( _%var%, 0 )
		return, 0
	} else if ( method = "SET" ) {
		_%var% := value
	}
	return _%var%
}

/**
 * Getter for the db_statix
 *
 * @param var - the name of the variable
 *
 * @return String - the stored value, if any
 */
db_mGet( var )
{	; (w) by dR - Version 2010-02-25
	return db_statix( var, "", "GET" )
}

/**
 * Setter for the db_statix
 *
 * @param var   - the name of the variable
 * @param value - the value to store
 *
 * @return String - the stored value, if any
 */
db_mSet( var, value = "" )
{	; (w) by dR - Version 2010-02-25
	return db_statix( var, value, "SET" )
}

/**
 * Remover for the db_statix
 *
 * @param var   - the name of the variable
 *
 * @return bool, 0 on success
 */
db_mDel( var )
{	; (w) by dR - Version 2010-02-25
	return db_statix( var, "", "DEL" )
}

/**
 * Sets a Value to a Name or an Index in a Stack
 *
 * @param Value - The Value to set
 * @param NameOrIndex - Name or Index of the stack, If ommited, a new entry will be made
 * @param Stack - The name of the stack, if ommited the last known stack will be used
 *
 * @return String
 */
db_PokeStack( Value = "", NameOrIndex = "", Stack = "" )
{	; (w) by dR - Version 2010-02-25.2
	Stack := db_CurrentStack( Stack )
	if ( ! NameOrIndex+0 ) {
		NameOrIndex := db_CountStack( db_CurrentStack( Stack ) )
		db_mSet( Stack "_0", ++NameOrIndex )
	}
	return db_mSet( Stack "_" NameOrIndex, Value )
}

/**
 * Returns a value of a Name or an Index in a Stack
 *
 * @param NameOrIndex - Name or Index of the stack, If ommited, a last entry will be returned
 * @param Stack - The name of the stack, if ommited the last known stack will be used
 *
 * @return String
 */
db_PeekStack( NameOrIndex = "", Stack = "" )
{	; (w) by dR - Version 2010-02-25
	Stack := db_CurrentStack( Stack )
	if ( ! NameOrIndex+0 ) {
		NameOrIndex := db_CountStack( Stack )
	}
	return db_mGet( Stack "_" NameOrIndex )
	
}

/**
 * Removes all indexed stack entries
 *
 * @param Stack - The name of the stack, if ommited the last known stack will be used
 *
 * @return Bool
 */
db_PurgeStack( Stack = "" )
{	; (w) by dR - Version 2010-02-25
	Stack := db_CurrentStack( Stack )
	Loop, % db_CountStack( Stack )
	{
		db_mDel( Stack "_" A_Index )
	}
	return db_mDel( Stack "_0" )
}

/**
 * Dumps a Stack to a CR seperated list
 *
 * @param Stack - The name of the stack, if ommited the last known stack will be used
 *
 * @return String - The List of the Stack
 */
db_DumpStack( Stack = "" )
{  ; (w) by dR - Version 2010-02-26
	Return db_JoinStack( Stack, "`n" )
}


/**
 * Dumps a Stack to a list seperated by a custom gluestring
 *
 * @param Stack - The name of the stack, if ommited the last known stack will be used
 * @param GlueString - The string to glue the stack together with, if ommited CR will be used
 *
 * @return String - The List of the Stack
 */
db_JoinStack( Stack = "", GlueString = "`n" )
{  ; (w) by dR - Version 2010-02-26
	Stack := db_CurrentStack( Stack )
	Loop, % db_CountStack()
		Out .= ( StrLen( Out ) ? GlueString : "" ) db_PeekStack( A_Index, Stack )
	Return Out
}

/**
 * Returns the count of all numeric stacked entries
 *
 * @param Stack - The name of the stack, if ommited the last known stack will be used
 *
 * @return Integer
 */
db_CountStack( Stack = "" )
{	; (w) by dR - Version 2010-02-25.2
	Return ! StrLen( ( stackCount := db_mGet( db_CurrentStack( Stack ) "_0" ) ) ) ? 0 : stackCount
}

/**
 * Pushes a value onto the end of the stack
 *
 * @param Value - The value to push the stack onto
 * @param Stack - The Stackname of the stack
 * @return String
 */
db_PushStack( Value, Stack = "" )
{	; (w) by dR - Version 2010-02-25
	return db_PokeStack( Value, "", Stack )
}

/**
 * Pushes a value afront the beginning of a stack
 *
 * @param Value - The value to push the stack onto
 * @param Stack - The Stackname of the stack
 *
 * @return String
 */
db_UnshiftStack( Value, Stack = "" )
{  ; (w) by dR - Version 2010-02-26
	Stack := db_CurrentStack( Stack )
	Loop, % Cnt := db_CountStack()
		db_PokeStack( db_PeekStack( Cnt - A_Index + 1 ), Cnt - A_Index + 2 ) 
	db_mSet( Stack "_0", Cnt+1 )
	
	Return db_PokeStack( Value, 1 )
}

/**
 * Retrieves the last value of a stack and shortens the stack by one
 *
 * @param Stack - The Stackname of the stack
 *
 * @return String
 */
db_PopStack( Stack = "" )
{  ; (w) by dR - Version 2010-02-26
	Stack := db_CurrentStack( Stack )
	Value := db_PeekStack()
	db_mDel( Stack "_" db_CountStack() )
	db_mSet( Stack "_0", db_CountStack()-1 )
	Return Value
}


/**
 * Retrieves the first value of a stack and shortens the stack by one
 *
 * @param Stack - The Stackname of the stack
 *
 * @return String
 */
db_ShiftStack( Stack = "" )
{  ; (w) by dR - Version 2010-02-26
	Stack := db_CurrentStack( Stack )
	Value := db_PeekStack( 1 )
	Loop, % ( Cnt := db_CountStack() ) - 1
	{
		db_PokeStack( db_PeekStack( A_Index + 1 ), A_Index )
	}
	Return Value
}

/**
 * Sets or Gets the last used Stack
 *
 * @param Stack - The Stackname
 * @return String
 */
db_CurrentStack( Stack = "" )
{	; (w) by dR - Version 2010-02-25
	return Stack == "" ? db_mGet( "TopMostStack" ) : db_mSet( "TopMostStack", Stack )
}