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
  AddMenuGadgetItem(Gadget, - 1, "&New" + #TAB$ + "Ctrl+N")
  AddMenuGadgetItem(Gadget, - 1, "&Open" + Chr(9) + "Ctrl+O", ImageID(1))
  AddMenuGadgetItem(Gadget, - 1, "Sa&ve")
  AddMenuBar(Gadget)
  AddMenuGadgetItem(Gadget, - 1, "Quit")
  
  
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
; CursorPosition = 43
; FirstLine = 10
; EnableXP
; DPIAware
; CompileSourceDirectory