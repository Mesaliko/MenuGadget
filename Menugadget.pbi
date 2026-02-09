;- TOP

;|-------------------------------------------------------------------------------------------------
;|
;|  Title            : MenuGadget
;|  Version          : 1.0
;|  Copyright        : Mesaliko
;|
;|  PureBasic        : 6.xx
;|  Operating System : Windows, Linux ?, MacOS ?
;|  Processor        : x86, x64, arm ?
;|
;|-------------------------------------------------------------------------------------------------
;|
;|  Description      : Gadget for pop up a custom menu
;|
;|  Forum Topic      :
;|
;|  Website          :
;|
;|  2026
;|-------------------------------------------------------------------------------------------------




CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
CompilerEndIf



;|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
;-  1. Constantes
;|__________________________________________________________________________________________________


; Attributes
EnumerationBinary
  
  #MenuGadget_None = 0
  #MenuGadget_Image
  #MenuGadget_FontSystemSize
  #MenuGadget_FontLarge
  #MenuGadget_BorderLess
  #MenuGadget_BorderFlat
  #MenuGadget_BorderRaised  ;default
  #MenuGadget_BorderSingle
  #MenuGadget_BorderDouble
  #MenuGadget_Nested        ;use a canvas already created
  
EndEnumeration

; Other attributes
#MenuGadget_DefaultHeight = 0
#MenuGadget_DefaultWidth  = 0

; Global attributes
EnumerationBinary
  #MenuGadget_BorderW
  #MenuGadget_BorderH
  #MenuGadget_MarginTop
  #MenuGadget_MarginBottom
  #MenuGadget_MarginLeft
  #MenuGadget_MarginRight
  #MenuGadget_Interline
  #MenuGadget_ImageSpace   ; Space from image to text
  #MenuGadget_ImageSize
  #MenuGadget_DataValue
  #MenuGadget_Color_Menu
  #MenuGadget_Color_LineColor
  #MenuGadget_Color_Text
  #MenuGadget_Color_FaceColor
  #MenuGadget_Color_TextColorSelected
  #MenuGadget_Color_FaceColorSelected
  #MenuGadget_FontSize
  
EndEnumeration

; Events
Enumeration #PB_EventType_FirstCustomValue
  
  #MenuGadget_EventType_Updated      ; (intern)
  #MenuGadget_EventType_Resize       ;
  
EndEnumeration

; Items
Enumeration
  
  #MenuGadgetItem_None = -1
  
EndEnumeration

; States
EnumerationBinary
  
  #MenuGadget_Checked
  #MenuGadget_Disabled
  
EndEnumeration


; Default colors
#MenuGadgetColor_MenuDefault         = $D0D0D0
#MenuGadgetColor_LineDefault         = $808080
#MenuGadgetColor_FaceDefault         = $D0D0D0
#MenuGadgetColor_FaceSelectedDefault = $D0D0D0
#MenuGadgetColor_TextDefault         = $000000
#MenuGadgetColor_TextSelectedDefault = $000000




;|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
;-  2. Structures
;|__________________________________________________________________________________________________


; ItemColor
Structure MenuGadgetItemColor
  Text.i
  Background.i
  FaceColor.i
  FaceColorSelected.i
  TextColorSelected .i
  LineColor.i
  
EndStructure

; ItemLayout
Structure MenuGadgetItemLayout
  X.d         ; X-Position
  Y.d         ; Y-Position
  Width.d     ;
  Height.d    ;
  TextX.d     ; Text position
  TextY.d
  TextW.d
  TextH.d
  TextShortCutX.d     ; TextShortCut position
  TextShortCutY.d
  TextShortCutW.d
  TextShortCutH.d
  ImageX.d    ; Icon-Position
  ImageY.d    ;
  ImageH.d
EndStructure

; ItemMenu
Structure MenuGadgetItem
  Text.s
  TextShortCut.s
  TopLineY.d
  MiddleLineY.d ;Menubar
  BottomLineY.d
  Color.MenuGadgetItemColor
  Image.i
  DataValue.i
  Disabled.i
  Checked.i
  Layout.MenuGadgetItemLayout ;Item Layout (TEMP)
  FontID.i
  FontSize.d
  UnderlineCharPos.i
  UnderlineC.s
  UnderlineX.d
  UnderlineY.d
  UnderlineW.d
  UnderlineT.d ;Thickness
  
EndStructure


; Struct

Structure MenuGadget
  
  Array y0.d(1);y for Text
  Array yy.d(1);y for lines up and down
  
  index.i;= 0 => 1st utilisation
  CountLines.i;count of menus
  
  xm.d;x du texte=marge h
  ym.d;y du texte=marge v
  pad.d;interlifne
  TextHeight.d
  TextHeightVisible.d
  TextHeightOffset.d
  Menu.s
  
  X.i
  Y.i
  W.i
  H.i
  Container.i ; to encapsulate the canvas menu inside to have nice borders
  Number.i    ; GadgetID
  Window.i    ; WindowID
  MenuID.i    ;(internal)
  FontID.i
  FontSize.d
  DefaultFontID.i                   ; FontID
  DefaultFontSize.d
  DataValue.i                       ; User data value
  Attributes.i                      ; Attribute
  ColorTheme.s                      ; Default theme
  Nested.i                          ; To use with a existing canvas
  RBorder.i                         ; due to the container border
  BorderW.d
  BorderH.d
  MarginTop.d
  MarginBottom.d
  MarginLeft.d
  MarginRight.d
  Interline.d
  TabLength.d;tabulation between text and shortcut
  W_WithoutText.d
  MaxLengthText.d
  TextX.d
  TextShortCutX.d
  
  MouseIn.i;The mouse is inside the canvas
  
  HoverItem.i
  MenuClicked.i
  
  PBMenuID.i;PureBasic Menu id
  
  List Item.MenuGadgetItem()
  
  MouseX.i
  MouseY.i
  
  EventTab.i
  
  Resized.i
  
  UpdatePosted.i                 ; après un PostEvent #True
  
  DrawingID.i                    ; Drawing handle for API text drawing
  
  MenuColor.i
  MenuColorDefault.i
  FaceColor.i
  TextColor.i
  FaceColorSelected.i
  TextColorSelected.i
  LineColor.i
  LineColorDefault.i
  
  ImageSpace.i
  ImageSize.i
  
  DrawDisabled.i                 ; Disable redraw
  
  ImageCheckID.i
  
EndStructure

; Declare public
;
; Set & Get Declare



;|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
;-  3. Initializations
;|__________________________________________________________________________________________________



;|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
;-  4. Procedures & Macros
;|__________________________________________________________________________________________________



;-  4.1 Private procedures for internal calculations ! Not for use !
;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
; StartDrawing()
Procedure.i MenuGadget_StartDrawing(*MenuGadget.MenuGadget)
  ;Found in: Update(*), Callback(), UpdateMenuGadget(Gadget.i)
  
  *MenuGadget\DrawingID = StartVectorDrawing(CanvasVectorOutput(*MenuGadget\Number))
  
  ProcedureReturn *MenuGadget\DrawingID
EndProcedure


; StopDrawing()
;Update(*), Callback(),, UpdateMenuGadget(Gadget.i)
Procedure MenuGadget_StopDrawing(*MenuGadget.MenuGadget)
  StopVectorDrawing()
EndProcedure

; (Re)définir une nouvelle icône pour l'onglet
Procedure MenuGadget_ReplaceImage(*MenuGadget.MenuGadget, *Item.MenuGadgetItem, NewImageID.i = #Null)
  ;,,AddMenuGadgetItem(G,),SetMenuGadgetItemImage(G)
  
  With *MenuGadget
    If IsImage(*Item\Image)
      FreeImage(*Item\Image)
      *Item\Image = #Null
    EndIf
    
    If NewImageID
      *Item\Image = NewImageID
      
    EndIf
  EndWith
EndProcedure

; La position.
Procedure.i MenuGadget_ItemID(*MenuGadget.MenuGadget, Position.i)
  ;ItemID(*), Examine(*)(wheel), AddMenuGadgetItem()
  ;,, MenuGadgetItemID(G,),RemoveMenuGadgetItem(G,),SetMenuGadgetState(G,),SetMenuGadgetItemAttribute(G,)
  ;,, SetMenuGadgetItemImage(G,), SetMenuGadgetItemPosition(G,),SetMenuGadgetItemState(G,)
  
  With *MenuGadget
    
    
    If Position >= 0 And Position < ListSize(\Item())
      ProcedureReturn SelectElement(\Item(), Position)
    ElseIf Position >= ListSize(\Item())
      ForEach \Item()
        If @\Item() = Position
          ProcedureReturn @\Item()
        EndIf
      Next
    EndIf
    
    
  EndWith
  
EndProcedure

; 	
Procedure MenuGadget_ClearItem(*MenuGadget.MenuGadget, *Item.MenuGadgetItem) ; Code OK
  
  If IsImage(*Item\Image)
    FreeImage(*Item\Image)
  EndIf
  
EndProcedure




; Détermine l'apparence et l'emplacement des onglets
Procedure MenuGadget_Examine(*MenuGadget.MenuGadget)
  ;1xCallback()
  
  Protected i
  
  
  With *MenuGadget
    ; Initialisation
    \MouseX = GetGadgetAttribute(\Number, #PB_Canvas_MouseX)
    \MouseY = GetGadgetAttribute(\Number, #PB_Canvas_MouseY)
    
    
    
    Select EventType()
      Case #PB_EventType_MouseMove
        For i = 1 To \CountLines
          If \MouseY <= \yy(i)
            Break
          EndIf
        Next i
        
        i - 1
        \HoverItem = i
        
        ;Case #PB_EventType_LeftButtonUp
        ;Debug "up"
        
      Case #PB_EventType_MouseLeave
        \MouseIn = #False
        
      Case #PB_EventType_MouseEnter
        \MouseIn = #True
        
      Case #PB_EventType_LeftClick
        HideGadget(\Container, 1) 
        If \Item()\Disabled Or \Item()\Text = ""
          \MenuClicked = -1
          ProcedureReturn -1
        Else
          \MenuClicked = \HoverItem -1
          If \PBMenuID >=0
            PostEvent(#PB_Event_Menu, \Window, \MenuClicked)
          EndIf
        EndIf
    EndSelect
    
    
  EndWith
  
EndProcedure



; Détermine l'apparence et l'emplacement des onglets
Procedure MenuGadget_Update(*MenuGadget.MenuGadget)
  ;Callback()
  ;,, UpdateMenuGadget(G)
  
  Protected i
  Protected Y.d, y0.d, W.d, TextWidthVisible.d
  Protected Line$
  
  
  With *MenuGadget
    
    ;ajout des items
    If \UpdatePosted
      
      Y = \MarginTop
      
      ; préparation
      VectorFont(\FontID, \FontSize)
      
      If \H = #MenuGadget_DefaultHeight
        
        ; a new size calculation = *MenuGadget\H = 0
        
        \H                 = \BorderH + \MarginTop + VectorTextHeight("ÎÇ") + \interline + \MarginBottom + \BorderH
        \TextHeight        = VectorTextHeight("ÎÇ")
        \TextHeightVisible = VectorTextHeight("ÎÇ", #PB_VectorText_Visible)
        \TextHeightOffset  = VectorTextHeight("ÎÇ", #PB_VectorText_Visible | #PB_VectorText_Offset)
        
        If \W = #MenuGadget_DefaultWidth
          \ImageSize     = \TextHeightVisible
          \TextX         = \BorderW + \MarginLeft + \ImageSize + \ImageSpace
          \W             = \TextX + \TabLength + \MarginRight + \BorderW
          \W_WithoutText = \W
          
        EndIf
      EndIf
      
      
      
      For i = 1 To \CountLines

        SelectElement(\Item(), i - 1)
        
        y0 = \Interline - \TextHeightOffset + Y
        
        \y0(i) = y0
        \yy(i) = y
        
        \Item()\Layout\TextW         = VectorTextWidth(\Item()\Text, #PB_VectorText_Visible)
        \Item()\Layout\TextShortCutW = VectorTextWidth(\Item()\TextShortCut, #PB_VectorText_Visible)
        
        TextWidthVisible = \Item()\Layout\TextW + \Item()\Layout\TextShortCutW
        
        If TextWidthVisible > \MaxLengthText
          \MaxLengthText = TextWidthVisible
          \W             = \W_WithoutText + \MaxLengthText
        EndIf
        
        \Item()\TopLineY       = \Interline + Y
        \Item()\MiddleLineY    = \Interline + \TextHeightVisible / 2 + Y
        \Item()\BottomLineY    = \Interline + \TextHeightVisible + Y
        \Item()\Layout\X       = 0
        \Item()\Layout\Y       = y0
        \Item()\Layout\Width   = \W             ; Largeur (intérieure)
        \Item()\Layout\ Height = \TextHeight    ; Hauteur (intérieure)
        
        \Item()\Layout\TextX         = \TextX
        \Item()\Layout\TextY         = y0
        \Item()\Layout\TextShortCutX = \W - \MarginRight - \Item()\Layout\TextShortCutW
        
        \Item()\Layout\ImageX = \BorderW + \MarginLeft
        \Item()\Layout\ImageY = y0   ;
        \Item()\Layout\ImageH = \TextHeight
        
        
        If \Item()\UnderlineCharPos
          \Item()\UnderlineC = Mid(\Item()\Text, \Item()\UnderlineCharPos, 1)
          \Item()\UnderlineX = \Item()\Layout\TextX + VectorTextWidth(Left(\Item()\Text, \Item()\UnderlineCharPos - 1), #PB_VectorText_Visible)
          \Item()\UnderlineY = \y0(i) + VectorTextHeight(\Item()\UnderlineC)
          \Item()\UnderlineW = VectorTextWidth(\Item()\UnderlineC, #PB_VectorText_Visible)
        EndIf
        
        Y + \Interline + \TextHeightVisible
        
      Next i
      
      \H = Y + \MarginBottom
      
      
      ; Redimensionnement du gadget
      
      MenuGadget_StopDrawing(*MenuGadget)
      ResizeGadget(\Container, #PB_Ignore, #PB_Ignore, DesktopUnscaledX(\W + \RBorder), DesktopUnscaledY(\H + \RBorder))
      ResizeGadget(\Number, #PB_Ignore, #PB_Ignore, DesktopUnscaledX(\W), DesktopUnscaledY(\H))                         
                                                                                                                                                                                                                                         
      PostEvent(#PB_Event_Gadget, \Window, \Number, #MenuGadget_EventType_Resize, - 1)
      MenuGadget_StartDrawing(*MenuGadget)
      VectorFont(\FontID)
      \Resized = #True
      
    EndIf
  EndWith
  
EndProcedure



; Dessine tout le MenuGadget
Procedure MenuGadget_Draw(*MenuGadget.MenuGadget)
  ;Callback()
  ;,, UpdateMenuGadget(G)
  
  With *MenuGadget
    If \DrawDisabled
      ProcedureReturn
    EndIf
    
    Protected *n
    Protected i
    Protected Line$, tmp$, c$
    Protected y0.f, ux.f, uy.f, uw.f
    
    
    ; initialisation = CLS
    VectorFont(\FontID, \FontSize)
    VectorSourceColor(\MenuColor)
    FillVectorOutput()
    
    ;draw text
    *n = FirstElement(\Item());SelectElement(\Item(),0)
    
    
    If ListSize(\Item()) > 0
      
      For i = 1 To \CountLines
        Line$ = \Item()\Text
        
        ;draw text
        If *n
          If Line$
            
            VectorSourceColor(\Item()\Color\FaceColor)
            AddPathBox(\BorderW, \y0(i), VectorOutputWidth() - \BorderW - \BorderW, \TextHeightVisible)
            FillPath()
            If \Item()\Disabled
              VectorSourceColor(\Item()\Color\Text & $FFFFFF | $40 << 24)
            Else
              VectorSourceColor(\Item()\Color\Text)
            EndIf
            MovePathCursor(\Item()\Layout\TextX, \y0(i))
            DrawVectorText(Line$)
            MovePathCursor(\Item()\Layout\TextShortCutX, \y0(i))
            DrawVectorText(\Item()\TextShortCut)
            
            ;underscore
            If \Item()\UnderlineCharPos
              MovePathCursor(\Item()\UnderlineX, \Item()\UnderlineY)
              AddPathLine(\Item()\UnderlineX + \Item()\UnderlineW, \Item()\UnderlineY)
              StrokePath(\Item()\UnderlineT)
            EndIf
            
          Else
            ;If the text to draw is "" and ColorLine>0 then draw a line
            If \LineColor
              VectorSourceColor(\LineColor)
              
              MovePathCursor(\Item()\Layout\TextX, \Item()\MiddleLineY)
              AddPathLine(VectorOutputWidth() - \MarginRight - \BorderW, \Item()\MiddleLineY)
              StrokePath(1)
            EndIf
          EndIf
          
          ;Image
          If \Item()\Checked
            MovePathCursor(\Item()\Layout\ImageX, \Item()\Layout\ImageY)
            DrawVectorImage(\ImageCheckID, $FF, \Item()\Layout\ImageH, \Item()\Layout\ImageH)
          EndIf
          
          If \Item()\Image
            MovePathCursor(\Item()\Layout\ImageX, \Item()\Layout\ImageY)
            If \Item()\Disabled
              DrawVectorImage(\Item()\Image, $40, \Item()\Layout\ImageH, \Item()\Layout\ImageH)
            Else
              DrawVectorImage(\Item()\Image, $FF, \Item()\Layout\ImageH, \Item()\Layout\ImageH)
            EndIf
          EndIf
        EndIf
        
        ;draw outlines
        ;MovePathCursor(\Item()\Layout\TextX, \Item()\TopLineY)
        ;AddPathLine( VectorOutputWidth(), \Item()\TopLineY)
        ;MovePathCursor(\Item()\Layout\TextX, \Item()\BottomLineY)
        ;AddPathLine(VectorOutputWidth(), \Item()\BottomLineY)
        ;StrokePath(1)
        *n = NextElement(\Item())
      Next i
      
      
      If \MouseIn
        If \HoverItem > 0
          
          y0 = \y0(\HoverItem)
          SelectElement(\Item(), \HoverItem - 1)
          line$ = \Item()\Text
          If line$
            VectorSourceColor(\Item()\Color\FaceColorSelected)
            AddPathBox(\BorderW, y0, VectorOutputWidth() - \BorderW - \BorderW, \TextHeightVisible)
            FillPath()
            VectorSourceColor(\Item()\Color\TextColorSelected)
            MovePathCursor(\Item()\Layout\TextX, y0)
            DrawVectorText(line$)
          EndIf
        EndIf
      EndIf
    EndIf
    
  EndWith
  
EndProcedure

; 	

; Envoie un événement pour mettre à jour l'onglet.
Procedure MenuGadget_PostUpdate(*MenuGadget.MenuGadget)
  ;,,AddMenuGadgetItem(G,),RemoveMenuGadgetItem(G,),ClearMenuGadgetItems(G),SetMenuGadgetAttribute(G
  ;,,SetMenuGadgetFont(G,)
  ;,,SetMenuGadgetState(G,),SetMenuGadgetColor(G,),SetMenuGadgetItemAttribute(G,),SetMenuGadgetItemColor(G),
  ;,,SetMenuGadgetItemImage(G,),SetMenuGadgetItemPosition(G,),SetMenuGadgetItemState(G,),
  ;,,SetMenuGadgetItemText(G,)
  
  If *MenuGadget\UpdatePosted = #False
    *MenuGadget\UpdatePosted = #True
    PostEvent(#PB_Event_Gadget, *MenuGadget\Window, *MenuGadget\Number, #MenuGadget_EventType_Updated, - 1)
  EndIf
  
EndProcedure


Procedure MenuGadget_Callback()
  ;,,FreeMenuGadget(G), MenuGadget(G,)
  
  Protected *MenuGadget.MenuGadget = GetGadgetData(EventGadget())
  If *MenuGadget = #Null
    ProcedureReturn
  EndIf
  
  If EventType() >= #PB_EventType_FirstCustomValue
    *MenuGadget\EventTab = EventData()
    Select EventType()
        
      Case #MenuGadget_EventType_Updated
        If MenuGadget_StartDrawing(*MenuGadget)
          MenuGadget_Update(*MenuGadget)
          MenuGadget_Draw(*MenuGadget)
          MenuGadget_StopDrawing(*MenuGadget)
          *MenuGadget\UpdatePosted = #False
        Else
          *MenuGadget\UpdatePosted = #False
        EndIf
    EndSelect
  Else
    If MenuGadget_StartDrawing(*MenuGadget)
      MenuGadget_Examine(*MenuGadget)
      MenuGadget_Update(*MenuGadget)
      MenuGadget_Draw(*MenuGadget)
      MenuGadget_StopDrawing(*MenuGadget)
    EndIf
  EndIf
  
EndProcedure


;-  4.2 Procedures for the MenuGadget
;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯


; Effectue une mise à jour calcul et redessine le gadget.
Procedure UpdateMenuGadget(Gadget.i)
  ;,,1xMenuGadget(G,)
  
  Protected *MenuGadget.MenuGadget = GetGadgetData(Gadget)

  If MenuGadget_StartDrawing(*MenuGadget)
    MenuGadget_Update(*MenuGadget)
    MenuGadget_Draw(*MenuGadget)
    MenuGadget_StopDrawing(*MenuGadget)
  EndIf
  
EndProcedure


Procedure FreeMenuGadget(Gadget.i)
  
  If Not IsGadget(Gadget)
    ProcedureReturn
  EndIf
  
  Protected *MenuGadget.MenuGadget = GetGadgetData(Gadget)
  SetGadgetData(Gadget, #Null)
  
  UnbindGadgetEvent(*MenuGadget\Number, @MenuGadget_Callback())
  FreeGadget(Gadget)
  If IsGadget(*MenuGadget\Container)
    FreeGadget(*MenuGadget\Container)
  EndIf
  ForEach *MenuGadget\Item()
    MenuGadget_ClearItem(*MenuGadget, *MenuGadget\Item())
  Next
  ClearStructure(*MenuGadget, MenuGadget)
  FreeMemory(*MenuGadget)
  
EndProcedure

Macro UseThemeColor()
  
  Select UCase(ColorTheme)
      
    Case "BLACKDARK"
      *MenuGadget\MenuColor         = $FF000000
      *MenuGadget\FaceColor         = $FF3B2C29
      *MenuGadget\TextColor         = $FFFFFFFF
      *MenuGadget\FaceColorSelected = $FF000000
      *MenuGadget\TextColorSelected = $FFFFFFFF
      *MenuGadget\LineColor         = $80808080
      
    Case "BLACKBLACK"
      *MenuGadget\MenuColor         = $FF000000
      *MenuGadget\FaceColor         = $FF000000
      *MenuGadget\TextColor         = $FFFFFFFF
      *MenuGadget\FaceColorSelected = $FF000000
      *MenuGadget\TextColorSelected = $FFFFFFFF
      *MenuGadget\LineColor         = $80808080
      
    Case "BLUEORANGE"
      *MenuGadget\MenuColor         = $FF996B5C
      *MenuGadget\FaceColor         = $FF804E3A
      *MenuGadget\TextColor         = $FFFFFFFF
      *MenuGadget\FaceColorSelected = $FF5192F1
      *MenuGadget\TextColorSelected = $FFDEDEDE
      *MenuGadget\LineColor         = $FF5192F1
      
    Case "BLUEBLUE"
      *MenuGadget\MenuColor         = $FFC25455
      *MenuGadget\FaceColor         = $FFC25455
      *MenuGadget\TextColor         = $FFFFFFFF
      *MenuGadget\FaceColorSelected = $FFC25455
      *MenuGadget\TextColorSelected = $FFFFFFFF
      *MenuGadget\LineColor         = $80808080
      
    Case "SYSTEM"
      CompilerSelect #PB_Compiler_OS
        CompilerCase #PB_OS_Windows
          *MenuGadget\MenuColor         = $FF << 24 | GetSysColor_(#COLOR_BTNFACE)
          *MenuGadget\FaceColor         = $FF << 24 | GetSysColor_(#COLOR_BTNFACE)
          *MenuGadget\TextColor         = $FF << 24 | GetSysColor_(#COLOR_BTNTEXT)
          *MenuGadget\FaceColorSelected = *MenuGadget\FaceColor
          *MenuGadget\TextColorSelected = *MenuGadget\TextColor
          *MenuGadget\LineColor         = $FF << 24 | GetSysColor_(#COLOR_3DSHADOW)
        CompilerDefault
          *MenuGadget\MenuColor         = $FF << 24 | #MenuGadgetColor_MenuDefault
          *MenuGadget\FaceColor         = $FF << 24 | #MenuGadgetColor_FaceDefault
          *MenuGadget\TextColor         = $FF << 24 | #MenuGadgetColor_TextDefault
          *MenuGadget\FaceColorSelected = *MenuGadget\FaceColor
          *MenuGadget\TextColorSelected = *MenuGadget\TextColor
          *MenuGadget\LineColor         = $FF << 24 | #MenuGadgetColor_LineDefault
      CompilerEndSelect
      
    Default
      CompilerSelect #PB_Compiler_OS
        CompilerCase #PB_OS_Windows
          *MenuGadget\MenuColor = $FF << 24 | GetSysColor_(#COLOR_BTNFACE)
        CompilerDefault
          *MenuGadget\MenuColor = $FF << 24 | #MenuGadgetColor_MenuDefault
      CompilerEndSelect
      *MenuGadget\FaceColor         = *MenuGadget\MenuColor
      *MenuGadget\TextColor         = $FF000000
      *MenuGadget\FaceColorSelected = $80800000
      *MenuGadget\TextColorSelected = $FFFFFFFF
      *MenuGadget\LineColor         = $80808080
  EndSelect
  
EndMacro

Procedure MenuGadget(Gadget.i, X.i, Y.i, Width.i, Height.i, Attributes.i, Window.i, ColorTheme.s = "", Nested = #False)
  Protected *MenuGadget.MenuGadget = AllocateMemory(SizeOf(MenuGadget))
  Protected Result.i, OldGadgetList.i, DummyGadget.i, Container.i, Border.i, RBorder.i
  
  InitializeStructure(*MenuGadget, MenuGadget)
  
  If Attributes & #MenuGadget_Nested
    Result = Gadget
  Else
    If Attributes & #MenuGadget_BorderRaised
      Border = #PB_Container_Raised:RBorder = 6
    ElseIf Attributes & #MenuGadget_BorderFlat
      Border = #PB_Container_Flat:RBorder = 1
    ElseIf Attributes & #MenuGadget_BorderSingle
      Border = #PB_Container_Single:RBorder = 2
    ElseIf Attributes & #MenuGadget_BorderDouble
      Border = #PB_Container_Double:RBorder = 4
    Else
      Border = #PB_Container_BorderLess:RBorder = 0
    EndIf
    
    Container = ContainerGadget(#PB_Any, X, Y, Width, Height, Border)
    Result    = CanvasGadget(Gadget, 0, 0, Width, Height)
    CloseGadgetList()
    
  EndIf
  
  If Gadget = #PB_Any
    Gadget = Result
  EndIf
  
  SetGadgetData(Gadget, *MenuGadget)
  
  
  With *MenuGadget
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Windows
        
        Protected NONCLIENTMETRICS.NONCLIENTMETRICS
        NONCLIENTMETRICS\cbSize = SizeOf(NONCLIENTMETRICS)
        SystemParametersInfo_(#SPI_GETNONCLIENTMETRICS, 0, @NONCLIENTMETRICS, 0)
        Protected Name$ = PeekS(@NONCLIENTMETRICS\lfMenuFont\lfFaceName[0])
        Protected DC = GetDC_(0)
        Protected size.d = Round(Abs(PeekL(@NONCLIENTMETRICS\lfMenuFont\lfHeight)) * 72 / GetDeviceCaps_(DC, #LOGPIXELSY), #PB_Round_Nearest)
        ReleaseDC_(0, DC)
        \DefaultFontID   = FontID(LoadFont(#PB_Any, Name$, size))
        \DefaultFontSize = size
      CompilerCase #PB_OS_Linux
        \DefaultFontID   = GetGadgetFont(#PB_Default)
        \DefaultFontSize = 11
      CompilerDefault
        DummyGadget      = TextGadget(#PB_Any, 0, 0, 10, 10, "Dummy")
        \DefaultFontID   = GetGadgetFont(DummyGadget)
        \DefaultFontSize = 11
        FreeGadget(DummyGadget)
    CompilerEndSelect
    
    If Attributes & #MenuGadget_FontLarge
      \DefaultFontSize = 14
    EndIf
    
    
    \Container  = Container
    \Number     = Gadget
    \X          = X
    \Y          = Y
    \W          = Width
    \H          = Height
    \RBorder    = RBorder
    \Attributes = Attributes
    \Window     = Window
    \ColorTheme = ColorTheme
    
    \FontID   = \DefaultFontID
    \FontSize = \DefaultFontSize
    \Nested   = Nested
    \EventTab = #MenuGadgetItem_None
    
    ;Common
    \BorderW      = DesktopScaledX(2)
    \BorderH      = DesktopScaledY(2)
    \MarginTop    = DesktopScaledY(0)
    \MarginBottom = DesktopScaledY(3)
    \MarginLeft   = DesktopScaledX(3)
    \MarginRight  = DesktopScaledX(6)
    \Interline    = DesktopScaledY(0)
    \ImageSpace   = DesktopScaledX(10)  ; Space from image au text
    \ImageSize    = DesktopScaledX(16)
    \TabLength    = DesktopScaledX(32)
    \CountLines   = 0
    
    
    
    UseThemeColor(); Custom attributes need to be after the attributes by default
    \MenuColorDefault = \MenuColor
    \LineColorDefault = \LineColor
    
    \ImageCheckID = ImageID(CatchImage(#PB_Any, ?check_png_start, ?check_png_end - ?check_png_start))
    \PBMenuID     = -1
    
  EndWith
  ; 		
  BindGadgetEvent(Gadget, @MenuGadget_Callback())
  ; 		UpdateMenuGadget(Gadget)
  
  ProcedureReturn Result
EndProcedure

Procedure.i AddMenuGadgetItem(Gadget.i, Position.i, Text.s, ImageID.i = #Null, DataValue.i = #Null)
  
  Protected *MenuGadget.MenuGadget = GetGadgetData(Gadget)
  Protected *Item.MenuGadgetItem
  Protected tmp$
  Protected Pos
  
  
  If Position = -1
    LastElement(*MenuGadget\Item())
    *Item    = AddElement(*MenuGadget\Item())
    Position = ListIndex(*MenuGadget\Item())
  ElseIf Bool(Position >= 0 And Position < ListSize(*MenuGadget\Item()))
    *Item = InsertElement(*MenuGadget\Item())
  Else
    ProcedureReturn - 1
  EndIf
  
  
  *MenuGadget\CountLines = *MenuGadget\CountLines + 1
  
  ReDim *MenuGadget\y0(*MenuGadget\CountLines)
  ReDim *MenuGadget\yy(*MenuGadget\CountLines)
  
  
  With *Item
    \Text             = StringField(Text, 1, #TAB$)
    \TextShortCut     = StringField(Text, 2, #TAB$)
    tmp$              = ReplaceString(\Text, "&&", Chr(1)); underline a char or add '&'
    \UnderlineCharPos = FindString(tmp$, "&", 0, #PB_String_NoCase)
    tmp$              = RemoveString(tmp$, "&", #PB_String_NoCase)
    \Text             = ReplaceString(tmp$, Chr(1), "&", #PB_String_NoCase)
    
      MenuGadget_ReplaceImage(*MenuGadget, *Item, ImageID)
    
    \DataValue               = DataValue
    \Color\Text              = *MenuGadget\TextColor
    \Color\Background        = *MenuGadget\FaceColor
    \Color\FaceColorSelected = *MenuGadget\FaceColorSelected
    \Color\TextColorSelected = *MenuGadget\TextColorSelected
    \Color\LineColor         = *MenuGadget\LineColor
    \FontID                  = *MenuGadget\FontID
    \FontSize                = *MenuGadget\FontSize
    \UnderlineT              = 1.1
  EndWith
  
  MenuGadget_PostUpdate(*MenuGadget)
  
  ProcedureReturn Position
  
EndProcedure

Procedure.i AddMenuBar(Gadget.i)
  
  ProcedureReturn AddMenuGadgetItem(Gadget, - 1, "")
  
EndProcedure

Procedure.i AddMenuGadgetItems(Gadget.i, Text.s)
  
  Protected i, n, Position
  Protected item.s
  
  n = CountString(Text, "|")
  
  For i = 1 To n
    item = StringField(Text, i, "|")
    If FindString(item, "#TAB$")
      item = StringField(item, 1, "#TAB$") + #TAB$ + StringField(item, 2, "#TAB$")
    EndIf
    Position = AddMenuGadgetItem(Gadget, - 1, item)
  Next i
  
  ProcedureReturn Position
  
EndProcedure

Procedure.i MenuGadgetItemID(Gadget.i, Position.i)
  
  Protected *MenuGadget.MenuGadget = GetGadgetData(Gadget)
  
  ProcedureReturn MenuGadget_ItemID(*MenuGadget, Position)
  
EndProcedure

Procedure UsePBMenu(Gadget.i, MenuID.i)
  Protected *MenuGadget.MenuGadget = GetGadgetData(Gadget)
  Protected i, Result
  
  With *MenuGadget
    
    If IsMenu(MenuID)
      FreeMenu(MenuID)
      \PBMenuID = -1
    EndIf
    
    Result = CreatePopupImageMenu(MenuID)
    
    If MenuID = #PB_Any
      \PBMenuID = Result
    Else
      \PBMenuID = MenuID
    EndIf
    
    If \PBMenuID >= 0
      ForEach \Item()
        i + 1
        MenuItem(i, \Item()\Text, \Item()\Image)
      Next
    EndIf
    
  EndWith
  
EndProcedure

Procedure FreePBMenu(Gadget.i)
  Protected *MenuGadget.MenuGadget = GetGadgetData(Gadget)
  Protected i, Result
  
  With *MenuGadget
    
    If IsMenu(\MenuID)
      FreeMenu(\MenuID)
      \PBMenuID = -1
    EndIf
    
  EndWith
  
EndProcedure


;-  4.3 Set- & Get-Procedure
;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯

Procedure SetMenuGadgetAttribute(Gadget.i, Attribute.i, Value.f)
  
  Protected *MenuGadget.MenuGadget = GetGadgetData(Gadget)
  
  
  Select Attribute
    Case #MenuGadget_MarginTop
      If Value > 0
        *MenuGadget\MarginTop = Value
      EndIf
    Case #MenuGadget_MarginBottom
      If Value > 0
        *MenuGadget\MarginBottom = Value
      EndIf
      
    Case #MenuGadget_MarginLeft
      If Value > 0
        *MenuGadget\MarginLeft = Value
      EndIf
      
    Case #MenuGadget_MarginRight
      If Value > 0
        *MenuGadget\MarginRight = Value
      EndIf
      
    Case #MenuGadget_Interline
      If Value > 0
        *MenuGadget\Interline = Value
      EndIf
      
    Case #MenuGadget_ImageSpace
      If Value > 0
        *MenuGadget\ImageSpace = Value
      EndIf
      
    Case #MenuGadget_ImageSize
      If Value > 0
        *MenuGadget\ImageSize = Value
      EndIf
  EndSelect
  
  MenuGadget_PostUpdate(*MenuGadget)
  
EndProcedure



; Renvoie la valeur d'un attribut.
Procedure.i GetMenuGadgetAttribute(Gadget.i, Attribute.i)
  
  Protected *MenuGadget.MenuGadget = GetGadgetData(Gadget)
  
  Select Attribute
    Case #MenuGadget_MarginTop
      ProcedureReturn *MenuGadget\MarginTop
      
    Case #MenuGadget_MarginBottom
      ProcedureReturn *MenuGadget\MarginBottom
      
    Case #MenuGadget_MarginLeft
      ProcedureReturn *MenuGadget\MarginLeft
      
    Case #MenuGadget_MarginRight
      ProcedureReturn *MenuGadget\MarginRight
      
    Case #MenuGadget_Interline
      ProcedureReturn *MenuGadget\Interline
      
    Case #MenuGadget_ImageSpace
      ProcedureReturn *MenuGadget\ImageSpace
      
    Case #MenuGadget_ImageSize
      ProcedureReturn *MenuGadget\ImageSize
  EndSelect
  
EndProcedure

; Modifie la valeur data.
Procedure SetMenuGadgetData(Gadget.i, DataValue.i)
  
  Protected *MenuGadget.MenuGadget = GetGadgetData(Gadget)
  
  *MenuGadget\DataValue = DataValue
  
EndProcedure

Procedure.i GetMenuGadgetData(Gadget.i)
  
  Protected *MenuGadget.MenuGadget = GetGadgetData(Gadget)
  
  ProcedureReturn *MenuGadget\DataValue
  
EndProcedure

Procedure SetMenuGadgetFontSize(Gadget.i, FontSize.d)
  
  Protected *MenuGadget.MenuGadget = GetGadgetData(Gadget)
  
  *MenuGadget\FontSize = FontSize
  ; Reset to 0 to force a new size calculation
  *MenuGadget\W = 0
  *MenuGadget\H = 0
  
  MenuGadget_PostUpdate(*MenuGadget)
  
EndProcedure

Procedure SetMenuGadgetFont(Gadget.i, FontID.i)
  
  Protected *MenuGadget.MenuGadget = GetGadgetData(Gadget)
  
  If FontID = #PB_Default
    *MenuGadget\FontID = *MenuGadget\DefaultFontID
  Else
    *MenuGadget\FontID = FontID
  EndIf
  
  ; Reset to 0 to force a new size calculation
  *MenuGadget\W = 0
  *MenuGadget\H = 0
  
  MenuGadget_PostUpdate(*MenuGadget)
  
EndProcedure

Procedure SetMenuGadgetItemData(Gadget.i, Menu.i, DataValue.i)
  
  Protected *Item.MenuGadgetItem = MenuGadgetItemID(Gadget, Menu)
  
  If *Item
    *Item\DataValue = DataValue
  EndIf
  
EndProcedure

Procedure.i GetMenuGadgetItemData(Gadget.i, Menu.i)
  
  Protected *Item.MenuGadgetItem = MenuGadgetItemID(Gadget, Menu)
  
  If *Item
    ProcedureReturn *Item\DataValue
  EndIf
  
EndProcedure

Procedure SetMenuGadgetColor(Gadget.i, Type.i, Color.i)
  
  Protected *MenuGadget.MenuGadget = GetGadgetData(Gadget)
  
  If *MenuGadget
    
    Select Type
        
      Case #MenuGadget_Color_Menu
        *MenuGadget\MenuColor = Color
        
      Case #MenuGadget_Color_LineColor
        *MenuGadget\LineColor = Color
        
      Case #PB_Default
        Select Color
          Case #PB_Default
            *MenuGadget\MenuColor = *MenuGadget\MenuColorDefault
            *MenuGadget\LineColor = *MenuGadget\LineColorDefault
            ForEach *MenuGadget\Item()
              *MenuGadget\Item()\Color\FaceColor         = *MenuGadget\FaceColor
              *MenuGadget\Item()\Color\Text              = *MenuGadget\TextColor
              *MenuGadget\Item()\Color\FaceColorSelected = *MenuGadget\FaceColorSelected
              *MenuGadget\Item()\Color\TextColorSelected = *MenuGadget\TextColorSelected
            Next
            
          Case #MenuGadget_Color_Menu
            *MenuGadget\MenuColor = *MenuGadget\MenuColorDefault
          Case #MenuGadget_Color_LineColor
            *MenuGadget\LineColor = *MenuGadget\LineColorDefault
        EndSelect
        
    EndSelect
    MenuGadget_PostUpdate(GetGadgetData(Gadget))
  EndIf
  
EndProcedure

Procedure SetMenuGadgetItemColor(Gadget.i, Menu.i, Type.i, Color.i)
  
  Protected *MenuGadget.MenuGadget = GetGadgetData(Gadget)
  Protected *Item.MenuGadgetItem = MenuGadgetItemID(Gadget, Menu)
  
  If *Item
    
    Select Type
        
      Case #PB_Gadget_FrontColor, #MenuGadget_Color_Text
        *Item\Color\Text = Color
        
      Case #PB_Gadget_BackColor, #MenuGadget_Color_FaceColor
        *Item\Color\FaceColor = Color
        
      Case #MenuGadget_Color_FaceColorSelected
        *Item\Color\FaceColorSelected = Color
        
      Case #MenuGadget_Color_TextColorSelected
        *Item\Color\TextColorSelected = Color
        
      Case #PB_Default
        Select Color
          Case #PB_Default
            *Item\Color\Text              = *MenuGadget\TextColor
            *Item\Color\FaceColor         = *MenuGadget\FaceColor
            *Item\Color\FaceColorSelected = *MenuGadget\FaceColorSelected
            *Item\Color\TextColorSelected = *MenuGadget\TextColorSelected
          Case #PB_Gadget_FrontColor, #MenuGadget_Color_Text
            *Item\Color\Text = *MenuGadget\TextColor
          Case #PB_Gadget_BackColor, #MenuGadget_Color_FaceColor
            *Item\Color\FaceColor = *MenuGadget\FaceColor
          Case #MenuGadget_Color_FaceColorSelected
            *Item\Color\FaceColorSelected = *MenuGadget\FaceColorSelected
          Case #MenuGadget_Color_TextColorSelected
            *Item\Color\TextColorSelected = *MenuGadget\TextColorSelected
        EndSelect
        
    EndSelect
    MenuGadget_PostUpdate(GetGadgetData(Gadget))
  EndIf
  
EndProcedure

Procedure.i GetMenuGadgetItemColor(Gadget.i, Menu.i, Type.i)
  
  Protected *Item.MenuGadgetItem = MenuGadgetItemID(Gadget, Menu)
  
  If *Item
    Select Type
      Case #PB_Gadget_FrontColor, #MenuGadget_Color_Text
        ProcedureReturn *Item\Color\Text & $FFFFFF
      Case #PB_Gadget_BackColor, #MenuGadget_Color_FaceColor
        ProcedureReturn *Item\Color\FaceColor & $FFFFFF
      Case #MenuGadget_Color_FaceColorSelected
        ProcedureReturn *Item\Color\FaceColorSelected & $FFFFFF
      Case #MenuGadget_Color_TextColorSelected
        ProcedureReturn *Item\Color\TextColorSelected & $FFFFFF
    EndSelect
  EndIf
  
EndProcedure

Procedure SetMenuGadgetItemImage(Gadget.i, Menu.i, ImageID.i)
  
  Protected *MenuGadget.MenuGadget = GetGadgetData(Gadget)
  Protected *Item.MenuGadgetItem = MenuGadget_ItemID(*MenuGadget, Menu)
  
  If *Item
    MenuGadget_ReplaceImage(*MenuGadget, *Item, ImageID)
    MenuGadget_PostUpdate(*MenuGadget)
  EndIf
  
EndProcedure

Procedure SetMenuGadgetItemState(Gadget.i, Menu.i, State.i, Mask.i = #MenuGadget_Disabled | #MenuGadget_Checked)
  
  Protected *MenuGadget.MenuGadget = GetGadgetData(Gadget)
  Protected *Item.MenuGadgetItem = MenuGadget_ItemID(*MenuGadget, Menu)
  
  If *Item
    If Mask & #MenuGadget_Disabled
      *Item\Disabled = Bool((State * #MenuGadget_Disabled) & #MenuGadget_Disabled)
    EndIf
    If Mask & #MenuGadget_Checked
      *Item\Checked = Bool((State * #MenuGadget_Checked) & #MenuGadget_Checked)
    EndIf
    
    MenuGadget_PostUpdate(*MenuGadget)
  EndIf
  
EndProcedure

Procedure.i GetMenuGadgetItemState(Gadget.i, Menu.i)
  
  Protected *Item.MenuGadgetItem = MenuGadgetItemID(Gadget, Menu)
  
  If *Item
    ProcedureReturn (*Item\Disabled * #MenuGadget_Disabled) | (*Item\Checked * #MenuGadget_Checked)
  EndIf
  
EndProcedure

Procedure SetMenuGadgetItemText(Gadget.i, Menu.i, Text.s)
  
  Protected *Item.MenuGadgetItem = MenuGadgetItemID(Gadget, Menu)
  Protected tmp$
  
  If *Item
    ;     *Item\Text = Text
    *Item\Text             = StringField(Text, 1, #TAB$)
    *Item\TextShortCut     = StringField(Text, 2, #TAB$)
    tmp$                   = ReplaceString(*Item\Text, "&&", Chr(1)); underline a char or add '&'
    *Item\UnderlineCharPos = FindString(tmp$, "&", 0, #PB_String_NoCase)
    tmp$                   = RemoveString(tmp$, "&", #PB_String_NoCase)
    *Item\Text             = ReplaceString(tmp$, Chr(1), "&", #PB_String_NoCase)
    
    MenuGadget_PostUpdate(GetGadgetData(Gadget))
  EndIf
  
EndProcedure


Procedure.s GetMenuGadgetItemText(Gadget.i, Menu.i)
  
  Protected *Item.MenuGadgetItem = MenuGadgetItemID(Gadget, Menu)
  
  If *Item
    ProcedureReturn *Item\Text
  EndIf
  
EndProcedure

Procedure GetMenu(Gadget.i)
  Protected *MenuGadget.MenuGadget = GetGadgetData(Gadget)

 If *MenuGadget\MenuClicked
   ProcedureReturn *MenuGadget\MenuClicked
 EndIf
  
EndProcedure

Procedure GetPBMenu(Gadget.i)
  Protected *MenuGadget.MenuGadget = GetGadgetData(Gadget)
  Protected Result = -1
  
  With *MenuGadget
    If IsMenu(\PBMenuID)
      Result = \PBMenuID
    EndIf
  EndWith
  
  ProcedureReturn Result
  
EndProcedure

Procedure DisplayMenuGadget(Gadget.i, WindowID.i, X.i = #PB_Ignore, Y.i = #PB_Ignore)
  
    If IsGadget(Gadget)
      
      Protected *MenuGadget.MenuGadget = GetGadgetData(Gadget)
      
      If IsWindow(WindowID)
        
        If X = #PB_Ignore:X = WindowMouseX(WindowID):EndIf
        If Y = #PB_Ignore:Y = WindowMouseY(WindowID):EndIf
        
        If Y > WindowHeight(WindowID) - *MenuGadget\H
          Y = WindowHeight(WindowID) - *MenuGadget\H
        EndIf
        
        ResizeGadget(*MenuGadget\Container, X, Y, #PB_Ignore, #PB_Ignore)
        HideGadget(*MenuGadget\Container, #False)
        
      Else
        ProcedureReturn
      EndIf
    Else
      ProcedureReturn
    EndIf
    
EndProcedure

;Image png of a 'check' 512x512
DataSection
  check_png_start:
  ; size : 6641 bytes
  Data.q $0A1A0A0D474E5089, $524448490D000000, $0002000000020000, $D478F40000000608, $49427304000000FA
  Data.q $64087C0808080854, $5948700900000088, $0D0000D70D000073, $0000789B284201D7, $6F53745845741900
  Data.q $7700657261777466, $63736B6E692E7777, $9B67726F2E657061, $496E1900001A3CEE, $7FDDED9C78544144
  Data.q $67D7F1D75DF9E5AC, $2EED010BAD142EDA, $4D2E351AAD023569, $DB2A901A680D431A, $2C7FD203FD45B68A
  Data.q $43F2D34626B51318, $26A268A6920FF41A, $EDD481451311AD12, $5A0AB0540201BB4E, $5D946205A8552245
  Data.q $F96EEED45B50D2DA, $CEF75F9D33BDC7F8, $478F3FBE7F7CE7B9, $FE7EE7339DC99932, $9DEE739F39EBCDD8
  Data.q $6B6B9630000F7BD6, $8000009E5800001F, $0000901800000901, $0090180000090180, $9018000009018000
  Data.q $1800000901800000, $0000090180000090, $0009018000009018, $0901800000901800, $0180000090180000
  Data.q $8000009018000009, $0000901800000901, $0090180000090180, $9018000009018000, $1800000901800000
  Data.q $0000090180000090, $0009018000009018, $0901800000901800, $0180000090180000, $8000009018000009
  Data.q $0000901800000901, $0090180000090180, $9018000009018000, $1800000901800000, $0000090180000090
  Data.q $0009018000009018, $0901800000901800, $0180000090180000, $8000009018000009, $0000901800000901
  Data.q $0090180000090180, $9018000009018000, $1800000901800000, $0000090180000090, $0009018000009018
  Data.q $0901800000901800, $0180000090180000, $8000009018000009, $0000901800000901, $0090180000090180
  Data.q $0003ED773D018000, $287927E7B5AD1540, $E95F9248F926E7C9, $F5ADEEA9EEB33FBD, $6B46EC00033ED7DE
  Data.q $2717C92ABC928BED, $8FF9F0FF83673879, $49ABF24F7878EF07, $3FCFF9D4F1FF3C9E, $3A1647FBDE89E49B
  Data.q $B5A25C0000045DF6, $E7A3C9287F24DCF6, $491BFD4F44F77E3F, $DEF7AE49E3C92A7E, $0000883DE7A27A7F
  Data.q $6BC93B3ED6B43B80, $4AECE757C93ABC93, $8F24F5C92BFF6E7F, $0005A0799F777925, $921BFEDBFF3B9C00
  Data.q $FF9478AD17925B7C, $7D73EBF7BD2DE49C, $2D6B5AF0C0000102, $AE97926B7925D7C9, $EE6F249BFD5B9C7C
  Data.q $0000589FA9EBFFBD, $B7F24B1FDAD6B430, $44F12E59F6B23C92, $0284F54D3FE042CE, $C924BED6B5218000
  Data.q $40E59F6BE5F24A3F, $F7BDF3F926F7C93D, $C3000004C9F53B5F, $E4917F92657DAD69, $C93E7E11CB3ED6F3
  Data.q $F893CA773FEF7A6B, $17F6B5A50C00804E, $CE4FF1C7BEA57673, $9D57B5AD93F0A3DE, $D6B42180000224F2
  Data.q $3B7F24C3FDAD681E, $4C1E89CF3ED673C9, $04FB1CAFED6B78F2, $0BDAD6BCA000025E, $967DAC579240FC93
  Data.q $FF7BD4DF24E3FC19, $B4A0000090FE55D4, $2F24AEF2481FDAD6, $1E49B7FA332CFB5E, $00203FD0EC7FBDED
  Data.q $3F24B2F6B5AB2800, $923F157FDEBEFD9C, $60F21ECFEF7BABE4, $3FC6C1A4A00001EF, $D83E87EDE4995E49
  Data.q $B7FE380CE500000D, $20F7EFBBFDEF637A, $927F8F8329400001, $B89FF7BD95E4933C, $FF8C3280000241EC
  Data.q $FFFBDEF2F24E1F4D, $09400003DE01E8B8, $6ABFC92DBF36FFC6, $0000100F45CE7DAD, $FC9247A7BFF19EEC
  Data.q $EC00004BD37E8B8D, $25F24DFFD4BFF19A, $00DC37F3BE5FF7BD, $9F9EBEFFC65BB000, $00006E1BF5EF5BE4
  Data.q $FC9367B07FE325D8, $6E83F5BF7FFBDE9E, $CF257FE31DD80000, $0006E83F3BD6F24D, $1E49E947FE315D80
  Data.q $01B80F8DCCFFBDE9, $925AD1FF8C376000, $B00000DC07DB79BF, $5EF1B92F127FC607, $9FF19E6C00003700
  Data.q $60000085F8DCD7CC, $0BF1BD1EA4FF8CD3, $727FC659B000012F, $DD27FBDEFCF9274F, $0F167FC649B00000
  Data.q $6C00004BC4AAF924, $009789A3D59FF190, $92A7BB3FE318D800, $FF8C33600000A17C, $C136000025E65E62
  Data.q $AB0000058BEA2FF8, $B00000587B8BFE33, $7AC000010ABFE32A, $30EB0000046AFF8C, $38B00000487AABFE
  Data.q $0020197D87BABFE3, $000161F09BFE328B, $25ED3C66FF8C62C0, $23E537FC61160000, $79CDFF19D9800002
  Data.q $49BFE32B3000004A, $37FC636600000A4F, $69BFE30F3000004B, $F3CDFF19E9800002, $E177FC65A600001E
  Data.q $FF18C9800007DF49, $612600001BA978DD, $0A0FF7BD83E377FC, $7AE577FC664E0000, $77FC624E00000892
  Data.q $8E00001EF124F1E7, $A0BE4913E777FC66, $C638E00002DFEEF7, $E274FEF7B07E977F, $EB77FC608E000025
  Data.q $2B800009785F8DFA, $F517926CF5BBFE31, $15C0000371257FDE, $4FF18DC77B5DFF18, $6BBFE320700000DC
  Data.q $F3FFEF7A4BC92FFF, $C65F700000DC07C6, $B89FE3ADEEFEF77F, $7DEEFF8C3EE00001, $EB7A3FDEF517C922
  Data.q $5FE321700000DD07, $000DC4FF1CEEDBC2, $67347C25FE301700, $06E1BF9DC4FFFB7F, $E3BE32FF18BB8000
  Data.q $0EE00001B89FE35E, $BF6D7C92C78CBFC6, $FF1937000005E860, $B7F45D97C9367E32, $97F8CE70000044FF
  Data.q $C2FFBDEF2F24B1F1, $7F8C00001EF20F65, $3FC6FDFD7926CF1D, $BCA5FE33C3000011, $4BD03C8723FEF7A9
  Data.q $777CA5FE33030000, $0000583E878DFDEF, $D79258F297F8CA0C, $09780FF4399FDEF5, $72C794BFC6406000
  Data.q $00089FE3C1FFBAF6, $FF8C6E52FF18E180, $2060000283FD57D3, $00113FC7A394BFC6, $FE349CA5FE30C300
  Data.q $E52FF18218000089, $C6794000044FF1E4, $044FF182657794BF, $E57794BFC6694000, $0044FF1E4EFD4BEC
  Data.q $FC74994BFC659400, $652FF19250000113, $C6394000044FF1F2, $0000113FC65994BF, $44FF1B6652FF18A5
  Data.q $75994BFC61940000, $2FF18250000113FC, $EEC000044FF1F665, $0044FF191652FF19, $F1B1652FF19AEC00
  Data.q $52FF196EC000044F, $92EC000044FF1D16, $00044FF1F1652FF1, $FF195652FF18EEC0, $652FF18AEC000044
  Data.q $186EC000044FF1B5, $000044FF1D5652FF, $4FF1F5652FF182EC, $3652FF19E6C00004, $E334D8000089FE31
  Data.q $0000113FC666CA5F, $27F8D4D94BFC659B, $9B297F8C93600002, $F18E6C000044FF1B, $8000089FE393652F
  Data.q $13FC766CA5FE314D, $4D94BFC619B00001, $F8C1360000227F8F, $C000044FF1F9B297, $44FF18BB297F8CEA
  Data.q $9BB297F8CAAC0000, $7F8C6AC000044FF1, $AC000044FF1ABB29, $044FF1BBB297F8C2, $1CBB297F8CE2C000
  Data.q $97F8CA2C000044FF, $62C000044FF1DBB2, $0044FF1EBB297F8C, $F1FBB297F8C22C00, $297F8CECC000044F
  Data.q $32B30000113FC625, $000044FF1994A5FE, $13FC6A5297F8C6CC, $B94A5FE30B300001, $7F8CE4C000044FF1
  Data.q $930000113FC72529, $0044FF1D94A5FE32, $FC7A5297F8C64C00, $4A5FE30930000113, $8CC9C000044FF1F9
  Data.q $0000227F8C43297F, $13FC66194BFC624E, $50CA5FE334700001, $FF18A38000089FE3, $5C000044FF1B8652
  Data.q $044FF1C8652FF199, $1D8652FF1895C000, $97F8CC1C000044FF, $000044FF1E0678F2, $D79278F297F8C41C
  Data.q $2FB8000089FE3C8E, $0000273FF18A5FE3, $10B7FE314BFC612E, $FF18A5FE30170000, $A5FE307B8000083B
  Data.q $30770000107BFF18, $8000080BFF18A5FE, $0425FF8C52FF185B, $BFF18A5FE339C000, $F18C5FE31000010F
  Data.q $4BFC67860000803F, $8CD0C0001207FE31, $3000040AFFC6297F, $0122BFF18A5FE32C, $8FFC6297F8C90C00
  Data.q $8C52FF18E1800020, $5FE31430000491FF, $61860000813FF18A, $C0001227FE314BFC, $02027FC6297F8C10
  Data.q $27FC6297F8CF2800, $C6297F8CD2800022, $97F8CB280002427F, $8C9280002627FC62, $FB5DCF067FC6297F
  Data.q $A1E49F9ED6B43700, $7E49C3F3F2DF0F24, $C7FCF279278F926B, $EBDFFF7BDD7E3753, $F18A5FE332D8169C
  Data.q $5B89F3AFBDEB499F, $24D1E49D5E49BDFB, $FFCD3C4783C92FBF, $7FD9C9EF24A1F249, $43B27A7FBDEBEF24
  Data.q $33FE314BFC63BB02, $F9240F6B5A002C5A, $3E19CEFFE8CCF9C3, $F7A2781899F2C7CD, $8CA3600E7C336BFE
  Data.q $4007B3667FC6297F, $1FC93D7F2491ED6B, $9EEDD93F5982F24F, $FDEF4EFE49E3F24D, $BFC605605E7E0B9D
  Data.q $B5A002D980BFE314, $93EBC935BC92BBF6, $927DFEE1C93E59B4, $0073E5687FDEF4B7, $4C85FF18A5FE3033
  Data.q $DBE491DFB5AD001E, $E4FA4CE792437C92, $D6FBC0859CB1FBA7, $F18A5FE30D30083E, $617B5AD00164D05F
  Data.q $4C0F24C6F924B792, $7B9BE49EB9F3A4F2, $19E38041F6BD3FEF, $800926C2FF8C52FF, $FB2CD3FC926BDAD6
  Data.q $F8A25ECE7AA9FF1A, $3347004297D6BEF6, $001C9C15FF18A5FE, $FFAC8EF92737B5AD, $F437C9207EB1FF3A
  Data.q $31870083ED7D7FDE, $001D1C95FF18A5FE, $F4FE491DE7B8DFE7, $13F924CFC75A27A4, $E5C020FB5A5FF7BD
  Data.q $0547457FC6297F8C, $E499DE49C5ED6B40, $F24D1F3D689F9365, $70083ED77BFBDEBA, $2BB2BFE314BFC66F
  Data.q $ECE457B5AD005BFF, $417C927F8D2AEACB, $07DAD37DAD6A1F92, $1BFE314BFC66EE01, $C92ABDAD6800A570
  Data.q $DD59C73CE179268F, $D6DBDAD6FDFC92F3, $E314BFC619F0083E, $8DFE7004BF0711BF, $3DFECF7DC7327E7D
  Data.q $043ED69BFBDEAEFA, $E437FC6297F8CE8C, $1E4983DAD6801BA0, $B5B97F249FE338CB, $FE3323010FB5F6F6
  Data.q $B4006FB98DFF18A5, $3A5E49E7F925AED6, $8C4AC004473671FF, $01B90E837FC6297F, $1B20FB9AAF24CEF8
  Data.q $E314BFC661600226, $F6B5A007BE9751BF, $34D9C772C9FE49F5, $8C52FF18058009EF, $13FFE700185D86FF
  Data.q $6DA27A2D67C92FBE, $F18A5FE323300113, $8C7B78025ECBB8DF, $FE3133001CBC9DFF, $9C0067B81DFF18A5
  Data.q $BD967C2C57FFBD7F, $F18A5FE331300110, $B5AD68025EBB89DF, $689CABA5F24FEF24, $A5FE3013001CBC3F
  Data.q $EBC00DD7B91DFF18, $644E0026E10FFC63, $0DDB733BFE314BFC, $31903E4939ED6B40, $08E0026E58FFE6BF
  Data.q $DE7743BFE314BFC6, $04DCAAFFC621BC00, $F8C7AE52FF1915C0, $F3DAD6801BCDD2EF, $D13D578BC9287C92
  Data.q $52FF18038009B97E, $6E9F7FC653F927AE, $B853FF18F2F801BD, $FF18A5FE30FB8009, $14ED5D1E0035BB9D
  Data.q $C52FF180B8008875, $6ACD7C006B7017F8, $7F8C1DC00445A8A7, $5AD2496B88BFC629, $00224A6FF9BC497B
  Data.q $37217F8C52FF19CE, $80227A7FEDFC006E, $37317F8C52FF19E1, $0C0110F3FFEBC002, $496A0BFC6297F8CB
  Data.q $F9581E49A3E4905E, $FC62864112F9952C, $07F24B5D45FE314B, $18618026E6E7FC63, $7C92D7617F8C52FF
  Data.q $3CA008841887DAE1, $925AEE2FF18A5FE3, $65004440C43ED787, $C00400FF8C52FF19, $8C52FF18E50044F2
  Data.q $6500443AC00420FF, $C00440FF8C52FF18, $314BFC67BB00447A, $0FB5A1E496B983FE, $52FF196EC0113031
  Data.q $F9244F925A80FF8C, $004FBE70641F6BCD, $BA83FE314BFC62BB, $EC013700B087FF76, $5AEC0FF8C52FF186
  Data.q $004449043ED72792, $BB83FE314BFC603B, $224DC10FB5A9E496, $DC7F18A5FE32CD80, $7F8C736008906C00
  Data.q $44AB6002249FC629, $DCFE314BFC619B00, $E33AB0044BB60024, $DB600236E7F18A5F, $7F18A5FE31AB0044
  Data.q $087DAF2FC92D72EE, $C52FF19C5802252E, $7C920BC92D4F73F8, $F9CB859F2B03C934, $FC6297F8C22C4166
  Data.q $FC9227FBDEB5D0B9, $3004DCBEE107DAF8, $3752E7F18A5FE33B, $43829EABE3E013BE, $FE314BFC63660089
  Data.q $29EABEB8008DD7DC, $297F8CE4C0110AB8, $FBDE924B5C839FC6, $70E167CAFCFC9307, $3F8C52FF18C98022
  Data.q $B00B72031FF5BB07, $8C52FF199380222F, $C01F78006B72573F, $314BFC668E0088FE, $A2FD9FBDEB595CFE
  Data.q $AF179250F925E7B5, $12B9044BE18E227A, $6F3728E7F18A5FE3, $15F6F924CFEF7A00, $E3307004DCF1C2CF
  Data.q $006F3768E7F18A5F, $481F249CF6B5A492, $04DC29C44ED5D2F2, $24E7F18A5FE32970, $274FF7BD2007BEB7
  Data.q $04DCE9C2CE9596F9, $64E7F18A5FE32170, $25AD6B492400DDB7, $4C44E55D2F927F79, $18A5FE31B7004DC1
  Data.q $B3F40FCEED71267F, $6E3A61670AF37822, $99FC6297F8C9B802, $B5A37F3700375DCC, $C4C38F658AF926F7
  Data.q $FC6297F8CE0C04DC, $5378B700375DD499, $26E16610752D4F92, $E4CFE314BFC66060, $F24C7FFBDE800C2E
  Data.q $030110F30B3C16E7, $D971667F18A5FE32, $6DE493DFEF7A400D, $18818088F9859D0B, $67F1AD7927AE52FF
  Data.q $5A03E6E007BE170E, $C8B55F08FFB396BB, $FC671404F7939889, $16658A5EFE31B94B, $983DAD6924800DF7
  Data.q $022055041BE2A7E4, $77667F18A5FE328A, $9E3FDEF437004BE9, $5871EF3E3E4935E4, $18A5FE320A039780
  Data.q $EF4924005071167F, $CECF2499FC92E7FD, $FE310A0222161C77, $24007073167F18A5, $22367F2489FDEF49
  Data.q $C52FF180501102A0, $F49240052BA8B3F8, $B0110AA0222FBFDE, $B3F8C77794BFC663, $118A022240072BB0
  Data.q $CE77794BFC643B01, $02A3A8B3F8DFCEBE, $311D8088C5011120, $007473567F18A5FE, $C603B01118A02224
  Data.q $800A4EAACFE314BF, $F8CC360223140444, $9001C9DD59FC6297, $FF1906C044628088, $240049309B3F8C52
  Data.q $BFC621B01118A022, $8900164C66CFE314, $2FF1806C04462808, $2240069329B3F8C5, $A5FE322B01118A02
  Data.q $444800F267367F18, $14BFC60560223140, $08890012CD26CFE3, $6297F8C82C044628, $01112002D9ACD9FC
  Data.q $8C52FF18058088C5, $A02224006B369B3F, $F18A5FE323301118, $140444800F66F367, $FE314BFC60660223
  Data.q $628088900122C2EC, $9FC6297F8C84C044, $8C501112002C58DD, $B3F8C52FF1809808, $118A022240068B2B
  Data.q $767F18A5FE302701, $223140444800F167, $2ECFE314BFC608E0, $04462808890012AD, $5BB3F8C52FF1815C
  Data.q $01118A02224005AB, $6D767F18A5FE3007, $E0223140444800D5, $ADEECFE314BFC612, $DC0446280889001E
  Data.q $26C253F8C52FF183, $5B8088C501112002, $266C653F8C52FF18, $F188088C50111200, $2002A6CA53F8C62F
  Data.q $BFC6011D0CC50111, $44800B9B394FE314, $52FF180464331404, $111200326D253F8C, $314BFC601150CC50
  Data.q $40444800D9B594FE, $F8C52FF180444331, $C501112003A6DA53, $A7F18A5FE3008E94, $298A02224007CDBC
  Data.q $10CFE314BFC60119, $54A6280889001176, $D8C33F8C52FF1804, $111298A02224004D, $57650CFE314BFC60
  Data.q $011D766280889001, $177670CFE314BFC6, $6011976628088900, $0197690CFE314BFC, $C601157662808890
  Data.q $001B76B0CFE314BF, $FC60111766280889, $9001D76D0CFE314B, $BFC6011D36628088, $89001F76F0CFE314
  Data.q $4BFC601193662808, $808890012290FE31, $E314BFC601153662, $8A02224004CAE70F, $3F8C52FF180444D9
  Data.q $98A022240054A2DC, $E1FC6297F8C02355, $ACC501112002E50E, $F70FE314BFC60112, $A2CC501112003250
  Data.q $8170FE314BFC6011, $89166280889001B2, $944B87F18A5FE300, $046B33140444800E, $F947DC3F8C52FF18
  Data.q $8044B33140444800, $088601C3F8C52FF1, $1804693314044480, $0098681C3F8C52FF, $F180449331404448
  Data.q $A1B070FE313DE52F, $01149CC501112002, $C693F924F794BFC6, $A02224005C370E1F, $FC6297F8C022A398
  Data.q $8A022240064308E1, $3F8C52FF180452B9, $3140444800D8691C, $C3F8C52FF1804507, $73140444800E8609
  Data.q $9C3F8C52FF180469, $F73140444800F868, $0987F18A5FE3008C, $22DB94A022738008, $AD2261FC6297F8C0
  Data.q $F6B5A53619F6BEF7, $3ED773C92CFF24BA, $E313DF24AEFB270B, $7B80090987F1855F, $B581E49D3CA50110
  Data.q $004C4C3F8CC9C10F, $987F1866C004405C, $60027BC05C00F781, $425C0044CC3F8C13, $0048CC3F8CAAC004
  Data.q $987F1855800887DC, $1945800880380099, $800890380080587F, $02B80088587F1845, $0120B0FE32B30011
  Data.q $61FC616600224570, $6526002208E00261, $002248E0020561FC, $04E0022561FC6126, $024561FC624E0022
  Data.q $61FC628E002244E0, $C4AE002202600265, $008889800806C3F8, $1300108D87F18838, $221B0FE329700112
  Data.q $3F8C9EE002262600, $DB80088198008C6C, $1113300120D87F18, $9800966C3F8C4900, $4C361FC670600891
  Data.q $0FE32830044CCC00, $8C1802201600271B, $01110B00101D87F1, $0580084EC3F8C20C, $0223B0FE338A0089
  Data.q $EC3F8CA280226160, $E318A0088158008C, $2802225600243B0F, $891580094EC3F8C2, $80098EC3F8CE7600
  Data.q $CEC3F8CA76008995, $F18CEC01100D8009, $76008846C0040287, $444360021143F8C2, $B00110A1FC671B00
  Data.q $8C50FE328D802231, $7F18C6C01120D800, $236008946C004828, $044C360025143F8C, $8D8009850FE332B0
  Data.q $027143F8C4AC0113, $30FE330B00440760, $1885802213B00100, $C01111D80084187F, $80086187F1889ECC
  Data.q $5F2489E4CC01119D, $448760021C61FC6B, $B0012030FE331300, $94187F1889802253, $3F8C89C01131D800
  Data.q $48E0089CEC004C0C, $01100A0027061FC6, $2215400407F1915C, $280089207F190380, $49B81FC61F700445
  Data.q $07F180B802231400, $C1DC01120A00236E, $00894500117703F8, $6140049EE07F19CE, $0090B81FC6786022
  Data.q $9703F8CB0C044E28, $FE31C30110030012, $6180884180097DC0, $2220600220E07F18, $0C004C1C0FE33CA0
  Data.q $112B81FC65940446, $E07F18E501120300, $C6194044A0C004CA, $D8089818008A381F, $4E0C004D1C0FE33D
  Data.q $00224E07F196EC04, $099381FC63FB0110, $C0FE311D80889200, $33CD808937000424, $0111B7000464C0FE
  Data.q $EE00094981FC659B, $139303F8C7360222, $0FE30CD80893DC00, $3AB01121700042CC, $1129700046CC0FE3
  Data.q $70004ACC0FE31AB0, $9D981FC67160225F, $1FC631602220E000, $76602260E0008458, $444AE0008C581FC6
  Data.q $C00128B03F8C6CC0, $71607F19C9808995, $7F18C98088A38002, $938089A380021560, $8893800235607F19
  Data.q $800255607F19A380, $EAC0FE332B808993, $FE33070110930004, $EE022326000826C0, $949800219B03F8CB
  Data.q $00453607F190B808, $6C0FE31770113930, $E326E0221660008E, $C022366000926C0F, $C0D5980025DB03F8
  Data.q $CC00134D81FC6011, $09E6C0FE3008C06E, $F24DAF011E711600, $E3197FB332CFB5C9, $F7BD31600080EC0F
  Data.q $7DAE2FC922BC92C7, $FF7BDADF24F41996, $AFBDEB41EC0FE33A, $24FCFB5AD306067D, $A9947CAC8FE497DF
  Data.q $B9DFDEF7D7C9327C, $C58006E50E0041F6, $F92557C9357FDEF5, $E498BF02659F6B7B, $55800237B03F8CCB
  Data.q $2485FFBDED9FDEF4, $A473CFB599E498DF, $597FFBDEF2F24D1F, $55580025570020FB, $0F926579241FFDEF
  Data.q $EF9254F82B967DAC, $7600336FCF47F24C, $244FFBDEBAB00047, $5697E490DE49FDF9, $491DE49D3EE5CC3D
  Data.q $51F7BD6BFF7BDA5E, $D9009BC82811ACBE, $E498DE4903DAD694, $D0DCE3E570BC939B, $FFBDE96F927F7C93
  Data.q $C0010530030FB5B7, $94BF92537ED6B526, $F28F15DCF926AFE4, $8AFF7F7BDCDE4983, $5AD360009C980067
  Data.q $4D1E4975E4979F6B, $FB4F81673E4995F2, $F7BDFDF24F5C935F, $009C5803E7C0B77F, $37B39D9F6B5A3760
  Data.q $89A2F041673ABE0C, $F1E49BDE4953FA9E, $F3D130BFEF7BD724, $6B5AB76000966C02, $7927B7E056ECE48F
  Data.q $BB9C3F3FE743C938, $9E49C3E49D3E0A6F, $21FFCFF9D4F1FF3C, $63A17D7FDEF70FC9, $DAD6A4A000826C03
  Data.q $63673F3C1059C96F, $2A7BAC6FFBDE91FF, $DF2030000010ED80, $6000002406000007, $0000240600000240
  Data.q $0024060000024060, $2406000002406000, $0600000240600000, $0000024060000024, $0002406000002406
  Data.q $0240600000240600, $4060000024060000, $6000002406000002, $0000240600000240, $0024060000024060
  Data.q $2406000002406000, $0600000240600000, $0000024060000024, $0002406000002406, $0240600000240600
  Data.q $4060000024060000, $6000002406000002, $0000240600000240, $0024060000024060, $2406000002406000
  Data.q $0600000240600000, $0000024060000024, $0002406000002406, $0240600000240600, $4060000024060000
  Data.q $6000002406000002, $0000240600000240, $0024060000024060, $2406000002406000, $0600000240600000
  Data.q $0000024060000024, $0002406000002406, $0240600000240600, $4060000024060000, $6000002406000002
  Data.q $0000240600000240, $0024060000024060, $C15EC91FFF406000, $0000008F669B7D4E, $6042AE444E454900
  Data.b $82
  check_png_end:
EndDataSection






CompilerIf #PB_Compiler_IsMainFile
  
  ;-
  ;- >>>>>>>TEST>>>>>> 
  ; ------------------------------------------------
  ; UseModule MenuGadget
  
  EnableExplicit
  
  ;Not mandatory
  Procedure Menu(n)
    
    Select n
      Case 1
        ;Do something
      Case 2
        ;Do something
      Case 3
        ;Do something
      Case 4
        ;Do something
      Case 5
        ;Do something
      Case 6
        End; Quit
              
    EndSelect
    
  EndProcedure
  
  ;Not mandatory
  Procedure MenuClick()
    
    Protected Gadget = EventGadget()
    Protected *MenuGadget.MenuGadget = GetGadgetData(Gadget)
    Protected c
    
    Select *MenuGadget\MenuClicked
      Case 0
        If GetMenuGadgetItemState(Gadget, 0) = #MenuGadget_Checked
          SetMenuGadgetItemState(Gadget, 0, 0, #MenuGadget_Checked)
        Else
          SetMenuGadgetItemState(Gadget, 0, 1, #MenuGadget_Checked)
        EndIf
      Case 1
        Debug *MenuGadget\Item()\Text
      Case 2
        Debug *MenuGadget\Item()\Text
      Case 3
        Debug *MenuGadget\Item()\Text
      Case 4
        Debug *MenuGadget\Item()\Text
      Case 5
        Debug *MenuGadget\Item()\Text
      Case 6
        Debug *MenuGadget\Item()\Text
        FreeMenuGadget(Gadget)
        Menu(7);End
        
    EndSelect
    
    ProcedureReturn *MenuGadget\MenuClicked
  EndProcedure
  
  Procedure MenuPB()
    Debug "Menu clic"
  EndProcedure
  
  
  
  ;- Win
  Define Window = 0, Event
  
  If OpenWindow(Window, 0, 0, 500, 450, "VectorDrawing", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    
    UsePNGImageDecoder()
    
    ;Try different font
    ;LoadFont(0, "Monotype Corsiva", 20)
    ;   LoadFont(0, "Times New Roman", 20)
    LoadFont(0, "", 20)
    ;   LoadFont(0, "Times New Roman", 11)
    
    
    LoadImage(1, #PB_Compiler_Home + "Examples\Sources\Data\ToolBar\Open.png")
    LoadImage(6, #PB_Compiler_Home + "Examples\Sources\Data\ToolBar\Delete.png")
    
    Define pad.f      = 0
    Define FontSize.f = 40
    Define y.f        = 0
    Define x.f        = 20
    Define Menu       = 1
    Define Menu$      = "New" + #LF$ + "Open" + #LF$ + "Save" + #LF$ + "Save as..." + #LF$ + "Close" + #LF$ + "" + #LF$ + "Quit"
    ;Menu$ = "NewÎÇ"+#LF$+"OpenÎÇ"+#LF$+"SaveÎÇ"+#LF$+"Save as...ÎÇ"+#LF$+"CloseÎÇ"+#LF$+""+#LF$+"QuitÎÇ"
    Define Width = 500
    
    Define Gadget = 0
    MenuGadget(Gadget, X, Y, #MenuGadget_DefaultWidth, #MenuGadget_DefaultHeight, #MenuGadget_FontLarge | #MenuGadget_BorderRaised , Window);#MenuGadget_None
    AddMenuGadgetItem(Gadget, - 1, "&Nouveau" + #TAB$ + "Ctrl+N")
    AddMenuGadgetItem(Gadget, - 1, "Ou&vrir" + Chr(9) + "Ctrl+O", ImageID(1))
    AddMenuGadgetItem(Gadget, - 1, "Enregis&&trer")
    AddMenuGadgetItem(Gadget, - 1, "&&&Enregistrer sous..." + Chr(9) + "Ctrl+Maj+F10")
    AddMenuGadgetItem(Gadget, - 1, "&Fermer&&", ImageID(6))
    AddMenuBar(Gadget);AddMenuGadgetItem(Gadget, - 1, "")
    AddMenuGadgetItem(Gadget, - 1, "Quitter")
    
    
    SetMenuGadgetItemState(Gadget, 4, 1, #MenuGadget_Disabled)
    SetMenuGadgetItemState(Gadget, 0, 1, #MenuGadget_Checked)
    
    ;     UsePBMenu(Gadget, 0)
    UsePBMenu(Gadget, #PB_Any)
    
    
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
                Case #PB_EventType_MouseMove
                  If Menu
                    ;                     Debug "move"
                  EndIf
                Case #PB_EventType_LeftClick
                  Debug "N°=" + MenuClick()
              EndSelect
          EndSelect
          
        Case #PB_Event_Menu      ; Un élément du menu a été sélectionné
          Debug "Menu Event " + Str(EventMenu())
          ;           Select EventMenu()     ; On recupère le numéro de cet élement...
          ;             Case 0 : Debug "Menu Event 0"
          ;             Case 1 : Debug "Menu Event 1"
          ;             Case 2 : Debug "Menu Event 2"
          ;             Case 3 : Debug "Menu Event 3"
          ;             Case 4 : Debug "Menu Event 4"
          ;             Case 5 : Debug "Menu Event 5"
          ;             Case 6 : Debug "Menu Event 6"
          ;           EndSelect
          
          
      EndSelect
    Until Event = #PB_Event_CloseWindow
  EndIf
  
CompilerEndIf
; IDE Options = PureBasic 6.03 LTS (Windows - x86)
; CursorPosition = 1719
; FirstLine = 1692
; Folding = --------
; EnableXP
; DPIAware
; CompileSourceDirectory