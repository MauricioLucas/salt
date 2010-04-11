; by evl
; http://www.autohotkey.com/forum/viewtopic.php?t=9266
LV_ColorInitiate(Gui_Number=1, Control="") ; initiate listview color change procedure
{
  global hw_LV_ColorChange
  If Control =
    Control =SysListView321
  Gui, %Gui_Number%:+Lastfound
  Gui_ID := WinExist()
  ControlGet, hw_LV_ColorChange, HWND,, %Control%, ahk_id %Gui_ID%
  OnMessage( 0x4E, "WM_NOTIFY" )
}

LV_ColorChange(Index="", TextColor="", BackColor="") ; change specific line's color or reset all lines
{
  global
  If Index =
    Loop, % LV_GetCount()
      LV_ColorChange(A_Index)
  Else
    {
    Line_Color_%Index%_Text := TextColor
    Line_Color_%Index%_Back := BackColor
    WinSet, Redraw,, ahk_id %hw_LV_ColorChange%
    }
}


;modified by IsNull (bug fix)
WM_NOTIFY( p_w, p_l, p_m )
{
  local  draw_stage, Current_Line, Index
  if ( DecodeInteger( "uint4", p_l, 0 ) = hw_LV_ColorChange ) {
      if ( DecodeInteger( "int4", p_l, 8 ) = -12 ) {                            ; NM_CUSTOMDRAW
          draw_stage := DecodeInteger( "uint4", p_l, 12 )
          if ( draw_stage = 1 )                                                 ; CDDS_PREPAINT
              return, 0x20                                                      ; CDRF_NOTIFYITEMDRAW
          else if ( draw_stage = 0x10000|1 ){                                   ; CDDS_ITEM
              Current_Line := DecodeInteger( "uint4", p_l, 36 )+1
              LV_GetText(Index, Current_Line)
              If (Line_Color_%Current_Line%_Text != ""){
                  EncodeInteger( Line_Color_%Current_Line%_Text, 4, p_l, 48 )   ; foreground
                  EncodeInteger( Line_Color_%Current_Line%_Back, 4, p_l, 52 )   ; background
                }
            }
        }
    }
}

DecodeInteger( p_type, p_address, p_offset, p_hex=true )
{
  old_FormatInteger := A_FormatInteger
  ifEqual, p_hex, 1, SetFormat, Integer, hex
  else, SetFormat, Integer, dec
  StringRight, size, p_type, 1
  loop, %size%
      value += *( ( p_address+p_offset )+( A_Index-1 ) ) << ( 8*( A_Index-1 ) )
  if ( size <= 4 and InStr( p_type, "u" ) != 1 and *( p_address+p_offset+( size-1 ) ) & 0x80 )
      value := -( ( ~value+1 ) & ( ( 2**( 8*size ) )-1 ) )
  SetFormat, Integer, %old_FormatInteger%
  return, value
}

EncodeInteger( p_value, p_size, p_address, p_offset )
{
  loop, %p_size%
    DllCall( "RtlFillMemory", "uint", p_address+p_offset+A_Index-1, "uint", 1, "uchar", p_value >> ( 8*( A_Index-1 ) ) )
} 