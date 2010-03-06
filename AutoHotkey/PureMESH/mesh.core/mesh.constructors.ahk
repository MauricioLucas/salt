/**
 * mesh.constructors 1.0
 * mesh.constructors are part of MESH 1.0
 *
 *   This set of functions is intended register guis, modules and label overrides
 *   Labeloverrides come in two flavors, PreExec and PostExec
 *   They may be getting a Priority which indicates their executiontime
 *   The Pre/PostExec Extensions may also be registered at runtime either all
 *   or a single extension
 *
 *   The functionality of this library relies on mCore 1.0
 *
 *   written Jan-2010 by derRaphael
 *   Distributed under the EUPL 1.1 or later
 *
 * see the ReadMe.txt of Salt for more informations
 */

; Add an Item with a priority to a stack
mConst_PriorityStack( Stack, Item, ItemPriority = "Auto" )
{
	If ( ItemPriority = "Auto" )
	{
		ItemPriority := mCore_countStack( Stack ) + 1
	}
	
	Return % mCore_push( Stack, ItemPriority " " Item )
}

; Remove a given entity from a defined stack
mConst_UnregisterFromStack( stack, sLabel )
{
	If ( sLabel = "All" )
	{
		Return % mCore_del( stack )
	}
	Else
	{
		Return % mCore_removeFromStack( stack, sLabel )
	}
}

; Syntax Sugar for adding globally known Module names
mConst_RegisterModule( ModuleName )
{
	Return % mCore_push( "AvailModules", ModuleName )
}

; Syntax Sugar for adding globally known Gui names
mConst_RegisterGui( GuiName )
{
	Return % mCore_push( "Guis", GuiName )
}

; Syntax Sugar for adding ovverides to given labels
; No priority mechanism is used, since only one Override per Label 
; may be given for each function
mConst_RegisterOverride( OldLabel, NewLabel )
{
	Return % mCore_set( "Override" OldLabel, NewLabel )
}

; Syntax Sugar for removing an existing ovveride for a given label
mConst_UnRegisterOverride( OldLabel, NewLabel )
{
	Return % mCore_removeFromStack( "Override" Oldlabel, NewLabel )
}

; Syntax Sugar for adding pre execution extension for a given label
mConst_RegisterPreExec( OldLabel, NewLabel, LabelPriority = "Auto" )
{
	Return % mConst_PriorityStack( "PreExec" OldLabel, NewLabel, LabelPriority )
}

; Syntax Sugar for adding post execution extension for a given label
mConst_RegisterPostExec( OldLabel, NewLabel, LabelPriority = "Auto" )
{
	Return % mConst_PriorityStack( "PostExec" OldLabel, NewLabel, LabelPriority )
}

; Syntax Sugar for removing pre execution extensions for a given label
mConst_UnRegisterPreExec( OldLabel, NewLabel = "All" )
{
	Return % mConst_UnregisterFromStack( "PreExec" OldLabel, NewLabel )
}

; Syntax Sugar for removing pre execution extensions for a given label
mConst_UnRegisterPostExec( OldLabel, NewLabel = "All" )
{
	Return % mConst_UnregisterFromStack( "PostExec" OldLabel, NewLabel )
}

; Syntax Sugar for checking for label overrides
mConst_IsOverride( MeshLabel )
{
	Return % ( StrLen( mCore_get( "Override" MeshLabel ) ) != 0 )
}

; Syntax Sugar for checking for label pre execution extension
mConst_IsPreExec( MeshLabel )
{
	Return % mCore_countStack( "PreExec" MeshLabel )
}

; Syntax Sugar for checking for label post execution extension
mConst_IsPostExec( MeshLabel )
{
	Return % mCore_countStack( "PostExec" MeshLabel )
}
