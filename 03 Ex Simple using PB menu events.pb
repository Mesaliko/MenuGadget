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
  
  ;To Use PB Menus => Call this procedure after you have add all menus with AddMenuGadgetItem() or AddMenuGadgetItems()
  UsePBMenu(Gadget, 0); You can use #PB_Any
  
  
  ;- Loop
  Repeat
    Event = WaitWindowEvent()
    
    Select Event
      Case #PB_Event_RightClick
        DisplayMenuGadget(Gadget, Window)
        
      Case #PB_Event_Menu
        Select EventMenu()
          Case 0 : Debug "Menu Event 0"
          Case 1 : Debug "Menu Event 1"
          Case 2 : Debug "Menu Event " + EventMenu()
            ;           Case 3 : No, it's a menubar
          Case 4 : End
        EndSelect
    EndSelect
    
  Until Event = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 6.30 (Windows - x64)
; CursorPosition = 37
; FirstLine = 14
; EnableXP
; DPIAware
; CompileSourceDirectory