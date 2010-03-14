/**
 * mCore
 * mCore is part of Mesh 1.0
 *
 *   This set of functions is intended to provide access to globally available strings
 *   without defining these as global, but handling them in as statically defined in
 *   the mCore_mem function
 *
 *   written Jan-2010 by derRaphael
 *   Distributed under the EUPL 1.1 or later
 *
 * see the ReadMe.txt of Mesh for more informations
 */

mCore_mem( Item, Value, Mode = "GET" )
{
	Static
	
	; Normalize Name
	Item := RegExReplace( Item, "\W" )
	
	If ( Mode = "SET" )
	{
		_%Item% := Value
	}
	Else If ( Mode = "DEL" )
	{
		VarSetCapacity(_%Item%,0)
	}
	Return % _%Item%
}

mCore_get( item )
{
	return % mCore_mem( item, "", "GET" )
}

mCore_set( item, value = "" )
{
	return % mCore_mem( item,  value, "SET" )
}

mCore_del( item )
{
	return % mCore_mem( item, "", "DEL" )
}

mCore_push( item, value, itemDelimiter = "`n" )
{
	collection := mCore_get( item )
	return % mCore_set( item, collection ( StrLen( collection ) ? ItemDelimiter : "" ) value )
}

mCore_shift( item, ItemDelimiter = "`n" )
{
	collection := mCore_get( item )
	new := ""
	Loop,Parse,collection, % ItemDelimiter
	{
		if ( A_Index = 1 )
		{
			result := A_LoopField
		}
		Else
		{
			new .= ( StrLen( new ) ? ItemDelimiter : "" ) A_LoopField
		}
	}
	mCore_set( item, new )
	return % result
}

mCore_sortStack( stack, options = "NR", StackDelimiter = "`n" )
{
	collection := mCore_get( stack )
	if ( StackDelimiter != "`n" )
	{
		options .= "D" StackDelimiter
	}
	Sort, collection, % options
	return % mCore_set( stack, collection )
}

mCore_removeFromStack( stack, Value, StackDelimiter = "`n" )
{
	collection := mCore_get( stack )
	new := ""
	Loop, parse, collection, % stackDelimiter
	{
		if ( ! RegExMatch( A_LoopField, Value ) )
		{
			new .= ( StrLen( new ) ? StackDelimiter : "" ) A_LoopField
		}
	}
	return % mCore_set( stack, new )
}

mCore_countStack( stack, StackDelimiter = "`n" )
{
	collection := mCore_get( stack )
	StringSplit,cnt,collection,% StackDelimiter
	return % cnt0
}