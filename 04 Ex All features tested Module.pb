IncludeFile "MenugadgetModule.pbi"

UseModule Menugadget

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
  
  ;Quick menu
  ;   Define MenuAll$ = "||New|Open|Save|Save as...|Close||Quit|"
  ;   Define MenuAll$ = "|Ne&w" + #TAB$ + "Ctrl+W" + "|Open|Save|Save As...|Close||Quit#TAB$Ctrl+Q|"
  ;   AddMenuGadgetItems(Gadget, MenuAll$)
  ;
  
  
  
  ;- Test some setters
  ;====================
  ;   SetMenuGadgetAttribute(Gadget, #MenuGadget_MarginTop , 20)
  ;   SetMenuGadgetAttribute(Gadget, #MenuGadget_Interline , 20)
  ;   SetMenuGadgetAttribute(Gadget, #MenuGadget_MarginRight, 200)
  ;   SetMenuGadgetAttribute(Gadget, #MenuGadget_MarginBottom,20)
  ;   Debug getMenuGadgetData(Gadget)
  ;   SetMenuGadgetData(Gadget, 10)
  ;   Debug getMenuGadgetData(Gadget)
  ;
  ;   SetMenuGadgetFontSize(Gadget, 40)
  ;   LoadFont(0,"Courier New",24,#PB_Font_Underline)
  ;   SetMenuGadgetFont(Gadget, FontID(0))
  ;   SetMenuGadgetFont(Gadget, #PB_Default)
  ;   SetMenuGadgetItemData(Gadget, 0, 12)
  ;   Debug getMenuGadgetItemData(Gadget, 0)
  ;   SetMenuGadgetItemColor(Gadget, 1, #MenuGadget_Color_Text, RGBA(255,0,0,255))
  ;   SetMenuGadgetItemColor(Gadget, 2, #MenuGadget_Color_TextColorSelected, RGBA(255,0,0,255))
  ;   SetMenuGadgetItemColor(Gadget, 3, #MenuGadget_Color_FaceColorSelected, RGBA(255,0,0,255))
  ;   SetMenuGadgetItemColor(Gadget, 4, #MenuGadget_Color_FaceColor, RGBA(255,0,0,255))
  ;   SetMenuGadgetColor(Gadget, #MenuGadget_Color_LineColor, RGBA(255,0,0,255))
  ;   SetMenuGadgetColor(Gadget, #MenuGadget_Color_LineColor, 0);No line
  ;   SetMenuGadgetColor(Gadget, #MenuGadget_Color_Menu, RGBA(255,255,255,255))
  ;   SetMenuGadgetColor(Gadget, #PB_Default, #PB_Default)
  ;   LoadImage(11,#PB_Compiler_Home + "Examples\Sources\Data\ToolBar\Properties.png")
  ;   SetMenuGadgetItemImage(Gadget, 0, ImageID(11))
  ;   SetMenuGadgetItemImage(Gadget, 1, ImageID(11))
  ;   SetMenuGadgetItemState(Gadget, 1, 1, #MenuGadget_Disabled)
  SetMenuGadgetItemState(Gadget, 2, 1, #MenuGadget_Disabled)
  SetMenuGadgetItemState(Gadget, 0, 1, #MenuGadget_Checked)
  ;   SetMenuGadgetItemState(Gadget, 0, 1, #MenuGadget_Disabled)
  ;   Debug GetMenuGadgetItemState(Gadget, 0)&#MenuGadget_Disabled
  ;   Debug GetMenuGadgetItemState(Gadget, 0)&#MenuGadget_Checked
  ;
  ;   Debug GetMenuGadgetItemText(Gadget, 1)
  ;   SetMenuGadgetItemText(Gadget, 1, "New&Text"+#TAB$+"Ctrl+T")
  ;   Debug GetMenuGadgetItemText(Gadget, 1)
  ;
  ;   UsePBMenu(Gadget, 0)
  UsePBMenu(Gadget, #PB_Any)
  ;   Debug "GetPBMenu(Gadget)=" + GetPBMenu(Gadget)
  
  
  ;- For advanced programmers, test some direct things
  ;       Define *MenuGadget.MenuGadget = AllocateMemory(SizeOf(MenuGadget))
  ;       InitializeStructure(*MenuGadget, MenuGadget)
  ;       Define *MenuGadget.MenuGadget = GetGadgetData(Gadget)
  
  ;       Debug *MenuGadget\DefaultFontSize
  ;
  ;       Debug ListSize(*MenuGadget\Item())
  ;       ForEach *MenuGadget\Item()
  ;         Debug *MenuGadget\Item()\Text
  ;       Next
  
  
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
        
      Case #PB_Event_Menu      ; Un élément du menu a été sélectionné
        Debug "Menu Event " + Str(EventMenu())
        If EventMenu() = 0
          If GetMenuGadgetItemState(Gadget, 0) = #MenuGadget_Checked
            SetMenuGadgetItemState(Gadget, 0, 0, #MenuGadget_Checked)
          Else
            SetMenuGadgetItemState(Gadget, 0, 1, #MenuGadget_Checked)
          EndIf
        EndIf
        If EventMenu() = 4:End:EndIf
        
    EndSelect
    
  Until Event = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 6.30 (Windows - x64)
; CursorPosition = 120
; FirstLine = 86
; EnableXP
; DPIAware
; CompileSourceDirectory