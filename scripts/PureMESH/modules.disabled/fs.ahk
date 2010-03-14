/**
 * MESH fs Module
 *
 * SYNOPSIS
 *   This module provides basic fsIO functionality to all scripts in the MESH
 * See ReadMe.txt from Mesh for additional information
 *
 * LICENCE
 *   This File is licensed under EUPL 1.1 or later
 *   written Jan 2010 by derRaphael for Salt 1.0
 *
 */

fsAutoExecute:
	Author  := "derRaphael"
	Version := "1.0"
	Purpose := "This module adds basic file system handling for input and output."
	Licence := "EUPL 1.1 or later"
	i18n    := false
	
	extType := "core"
	extAttr := "noMenu"
	
	extCat  := "CoreFileSystemIO"
	extFunc := "fs_FileGetContent, fs_FilePutText, fs_FilePutContent, fs_IsDir, fs_UnlinkPath"
	
	ModuleRequiresSalt := "EqualOrLater:0.5.2010-01-30"
	
	; After Registration, the above variables are stored in the MeshModuleInfo functions
	; and the global variables are deleted
	mHelper_RegisterModule()
Return

/**
 * Returns a content from a given FilePath
 *
 * @param DataBuffer - The Data to write
 * @param FilePath - Path to target
 * @returns ErrorLevel
 */
fs_FileGetContent( FilePath )
{
	FileRead, Data, % FilePath
	Return Data
}

/**
 * Writes textual content to given FilePath
 *
 * @param DataBuffer - The Data to write
 * @param FilePath - Path to target
 * @returns ErrorLevel
 */
fs_FilePutText( DataBuffer, FilePath )
{
	if ( ! fs_IsDir( FilePath ) )
	{
		fs_UnlinkPath( FilePath )
		FileAppend, % DataBuffer, % FilePath
	}
	Else
	{
		ErrorLevel := "FilePath is a directory"
	}
	Return ErrorLevel
}

/**
 * Writes binary content as is to given FilePath
 *
 * @param DataBuffer - The actualy data to write
 * @param DataBufferSize - The size of the data to write
 * @param FilePath - Path to target
 * @returns WrittenBytes or ErrorLevel
 */
fs_FilePutContent( byRef DataBuffer, FilePath, DataBufferSize = "0" )
{
	if ( fs_IsDir( FilePath ) )
	{
		ErrorLevel := "FilePath is a directory"
		Return -2
	}
	
	if ( ( handle := DllCall("CreateFile"
			,"str",FilePath,"Uint", ( GENERIC_WRITE := 0x40000000 )
			,"Uint",0,"UInt",0,"UInt",( FILE_SHARE_DELETE := 0x4 )
			,"Uint",0,"UInt",0) ) = -1 )
	{
		ErrorLevel := "Could nto create File"
		Return -1
	}
	
	if ( ( result := DllCall("SetFilePointerEx"
			,"Uint",handle,"Int64",0,"UInt *",p,"Int",0) ) = 0 )
	{
		A_Error := "Seek Error: ErrorLevel " ErrorLevel
		DllCall("CloseHandle", "Uint", handle)
		ErrorLevel := A_Error
		Return -3
	}
	result := DllCall("WriteFile"
			,"UInt",handle,"Str",DataBuffer,"UInt",DataBufferSize,"UInt *",Written,"UInt",0) 
	result := DllCall("CloseHandle", "Uint", handle)
	
	Return % Written
}

/**
 * Returns is a FilePath is a directory
 *
 * @param FilePath - Path to target
 * @returns Boolean
 */
fs_IsDir( FilePath )
{
	return % ( InStr( FileExist( FilePath ), "D" ) )
}

/**
 * Unlinks a given Path from FileSystem
 *
 * @param FilePath - Path to target
 * @returns ErrorLevel
 */
fs_UnlinkPath( FilePath )
{
	if ( fs_IsDir( FilePath ) )
	{
		FileRemoveDir, % FilePath, 1
	}
	else
	{
		FileDelete, % FilePath
	}
	Return ErrorLevel
}