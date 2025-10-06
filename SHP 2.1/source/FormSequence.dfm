object FrmSequence: TFrmSequence
  Left = 191
  Top = 106
  Width = 696
  Height = 562
  BorderIcons = [biSystemMenu, biMaximize]
  BorderStyle = bsSizeToolWin
  Caption = 'Sequence Maker'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 688
    Height = 497
    Align = alClient
    BevelOuter = bvLowered
    TabOrder = 0
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 185
      Height = 495
      Align = alLeft
      TabOrder = 0
      object Panel6: TPanel
        Left = 1
        Top = 105
        Width = 183
        Height = 384
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object lblTools: TLabel
          Left = 0
          Top = 0
          Width = 183
          Height = 13
          Align = alTop
          Caption = ' INI Code'
          Color = clBtnHighlight
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
        end
        object INI_Code: TRichEdit
          Left = 16
          Top = 21
          Width = 153
          Height = 356
          BevelInner = bvNone
          BevelOuter = bvNone
          Color = clBtnFace
          PlainText = True
          PopupMenu = PopupMenu1
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 0
          WantReturns = False
          WordWrap = False
        end
      end
      object Panel7: TPanel
        Left = 1
        Top = 1
        Width = 183
        Height = 104
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        object Label3: TLabel
          Left = 8
          Top = 48
          Width = 29
          Height = 21
          AutoSize = False
          Caption = 'Frame'
          Layout = tlCenter
        end
        object Label4: TLabel
          Left = 104
          Top = 48
          Width = 13
          Height = 21
          AutoSize = False
          Caption = 'To'
          Layout = tlCenter
        end
        object Label5: TLabel
          Left = 0
          Top = 0
          Width = 183
          Height = 13
          Align = alTop
          Caption = ' Sequence'
          Color = clBtnHighlight
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
        end
        object ComboBoxEx1: TComboBoxEx
          Left = 16
          Top = 19
          Width = 161
          Height = 22
          ItemsEx.CaseSensitive = False
          ItemsEx.SortType = stNone
          ItemsEx = <
            item
              Caption = 'Ready'
            end
            item
              Caption = 'Guard'
            end
            item
              Caption = 'Prone'
            end
            item
              Caption = 'Down'
            end
            item
              Caption = 'Crawl'
            end
            item
              Caption = 'Walk'
            end
            item
              Caption = 'Up'
            end
            item
              Caption = 'Idle1'
            end
            item
              Caption = 'Idle2'
            end
            item
              Caption = 'Die1'
            end
            item
              Caption = 'Die2'
            end
            item
              Caption = 'Die3'
            end
            item
              Caption = 'Die4'
            end
            item
              Caption = 'Die5'
            end
            item
              Caption = 'FireUp'
            end
            item
              Caption = 'FireProne'
            end
            item
              Caption = 'Paradrop'
            end
            item
              Caption = 'Cheer'
            end
            item
              Caption = 'Panic'
            end
            item
              Caption = 'Deployed'
            end
            item
              Caption = 'DeployedFire'
            end
            item
              Caption = 'Undeploy'
            end
            item
              Caption = 'Fly'
            end
            item
              Caption = 'Hover'
            end
            item
              Caption = 'Tumble'
            end
            item
              Caption = 'FireFly'
            end>
          StyleEx = []
          ItemHeight = 16
          TabOrder = 0
          Text = 'Action'
          OnChange = ComboBoxEx1Change
          DropDownCount = 8
        end
        object From_Frame: TSpinEdit
          Left = 48
          Top = 48
          Width = 49
          Height = 22
          MaxLength = 100
          MaxValue = 0
          MinValue = 0
          TabOrder = 1
          Value = 0
          OnChange = From_FrameChange
        end
        object To_Frame: TSpinEdit
          Left = 128
          Top = 48
          Width = 49
          Height = 22
          MaxLength = 100
          MaxValue = 0
          MinValue = 0
          TabOrder = 2
          Value = 0
        end
        object Button1: TButton
          Left = 128
          Top = 80
          Width = 49
          Height = 17
          Caption = 'Edit'
          TabOrder = 3
          OnClick = Button1Click
        end
      end
    end
    object Panel3: TPanel
      Left = 186
      Top = 1
      Width = 501
      Height = 495
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object ScrollBox1: TScrollBox
        Left = 0
        Top = 241
        Width = 501
        Height = 254
        HorzScrollBar.Tracking = True
        VertScrollBar.Tracking = True
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        DragMode = dmAutomatic
        TabOrder = 0
        object Frame_Image_List: TImage
          Left = 0
          Top = 0
          Width = 105
          Height = 105
          AutoSize = True
        end
      end
      object ScrollBox2: TScrollBox
        Left = 0
        Top = 32
        Width = 501
        Height = 177
        HorzScrollBar.Tracking = True
        VertScrollBar.Tracking = True
        Align = alTop
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        TabOrder = 1
        object Sequence_Image: TImage
          Left = 0
          Top = 0
          Width = 105
          Height = 105
          AutoSize = True
        end
      end
      object Panel4: TPanel
        Left = 0
        Top = 0
        Width = 501
        Height = 32
        Align = alTop
        Caption = 'Sequence'
        TabOrder = 2
      end
      object Panel5: TPanel
        Left = 0
        Top = 209
        Width = 501
        Height = 32
        Align = alTop
        Caption = 'Frame List'
        TabOrder = 3
      end
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 497
    Width = 688
    Height = 19
    Panels = <
      item
        Width = 50
      end>
    SimplePanel = False
  end
  object MainMenu1: TMainMenu
    Left = 96
    Top = 72
    object File1: TMenuItem
      Caption = 'File'
      object Reset1: TMenuItem
        Caption = 'Reset'
        OnClick = Reset1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object SaveSequence1: TMenuItem
        Caption = 'Save Sequence As Image'
        OnClick = SaveSequence1Click
      end
      object SaveFrameListAsBMP1: TMenuItem
        Caption = 'Save Frame List As Image'
        OnClick = SaveFrameListAsBMP1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'Exit'
        OnClick = Exit1Click
      end
    end
    object Sequence1: TMenuItem
      Caption = 'Sequence'
      object FrameList1: TMenuItem
        Caption = 'Frame List'
        Checked = True
        OnClick = Preview1Click
      end
      object Preview1: TMenuItem
        Caption = 'Preview'
        OnClick = Preview1Click
      end
    end
  end
  object SaveSequencePictureDialog: TSavePictureDialog
    DefaultExt = 'bmp'
    Filter = 'Bitmap|*.bmp|JPG|*.jpg;*.jpeg'
    Left = 128
    Top = 72
  end
  object Refresh_Timer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = Refresh_TimerTimer
    Left = 40
    Top = 128
  end
  object PopupMenu1: TPopupMenu
    Left = 96
    Top = 128
    object Copy1: TMenuItem
      Caption = 'Copy Selection'
      OnClick = Copy1Click
    end
  end
  object SequenceTimer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = SequenceTimerTimer
    Left = 128
    Top = 128
  end
end
