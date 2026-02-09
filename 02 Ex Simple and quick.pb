IncludeFile "Menugadget.pbi"

EnableExplicit

;- Win
Define Window, Event

If OpenWindow(Window, 0, 0, 500, 450, "MenuGadget Simple", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  TextGadget(1, 200, 30, 100, 30, "RIGHT CLICK ON THE WINDOW !")
  
  UsePNGImageDecoder()
  
  LoadImage(1, #PB_Compiler_Home + "Examples\Sources\Data\ToolBar\Open.png")
  
  
  Define Gadget
  MenuGadget(Gadget, 10, 10, #MenuGadget_DefaultWidth, #MenuGadget_DefaultHeight, #MenuGadget_FontLarge | #MenuGadget_BorderRaised , Window); Big font + border
  
  ;Quick menu = All text menus in a single string
  Define MenuAll$ = "New|Open|Save||Quit|"; Menubar = no text
                                          ;   Define MenuAll$ = "|Ne&w" + #TAB$ + "Ctrl+W" + "|Open|Save|Save As...|Close||Quit#TAB$Ctrl+Q|"
  AddMenuGadgetItems(Gadget, MenuAll$)
  
  ;   SetMenuGadgetItemImage(Gadget, 1, ImageID(1)); add an icon
  
  
  ;- Loop
  Repeat
    Event = WaitWindowEvent()
    
    Select Event
      Case #PB_Event_RightClick
        DisplayMenuGadget(Gadget, Window)
        
      Case #PB_Event_Gadget
        Select EventGadget()
          Case Gadget
            Select EventType()
              Case #PB_EventType_LeftClick
                Debug "N°= " + GetMenu(Gadget)
            EndSelect
        EndSelect
        
    EndSelect
  Until Event = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 6.30 (Windows - x64)
; CursorPosition = 45
; FirstLine = 12
; EnableXP
; DPIAware
; CompileSourceDirectory