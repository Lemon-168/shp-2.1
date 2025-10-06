object frmReplaceColour: TfrmReplaceColour
  Left = 338
  Top = 211
  BorderIcons = [biSystemMenu]
  BorderStyle = bsToolWindow
  Caption = 'Replace Colour'
  ClientHeight = 331
  ClientWidth = 389
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 184
    Top = 56
    Width = 73
    Height = 13
    Caption = 'Replace Colour'
  end
  object Label2: TLabel
    Left = 296
    Top = 56
    Width = 65
    Height = 13
    Caption = 'Replace With'
  end
  object Bevel1: TBevel
    Left = 8
    Top = 288
    Width = 377
    Height = 10
    Shape = bsBottomLine
  end
  object Label3: TLabel
    Left = 192
    Top = 96
    Width = 57
    Height = 13
    Alignment = taCenter
    AutoSize = False
  end
  object Label4: TLabel
    Left = 296
    Top = 96
    Width = 57
    Height = 13
    Alignment = taCenter
    AutoSize = False
  end
  object Label5: TLabel
    Left = 192
    Top = 128
    Width = 57
    Height = 13
    Alignment = taCenter
    AutoSize = False
  end
  object Label6: TLabel
    Left = 296
    Top = 128
    Width = 57
    Height = 13
    Alignment = taCenter
    AutoSize = False
  end
  object Label7: TLabel
    Left = 192
    Top = 160
    Width = 57
    Height = 13
    Alignment = taCenter
    AutoSize = False
  end
  object Label8: TLabel
    Left = 296
    Top = 160
    Width = 57
    Height = 13
    Alignment = taCenter
    AutoSize = False
  end
  object Label9: TLabel
    Left = 192
    Top = 192
    Width = 57
    Height = 13
    Alignment = taCenter
    AutoSize = False
  end
  object Label10: TLabel
    Left = 296
    Top = 192
    Width = 57
    Height = 13
    Alignment = taCenter
    AutoSize = False
  end
  object Label11: TLabel
    Left = 192
    Top = 224
    Width = 57
    Height = 13
    Alignment = taCenter
    AutoSize = False
  end
  object Label12: TLabel
    Left = 296
    Top = 224
    Width = 57
    Height = 13
    Alignment = taCenter
    AutoSize = False
  end
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 153
    Height = 281
    BevelOuter = bvLowered
    TabOrder = 0
    object cnvPalette: TPaintBox
      Left = 1
      Top = 1
      Width = 151
      Height = 279
      Align = alClient
      OnMouseUp = cnvPaletteMouseUp
      OnPaint = cnvPalettePaint
    end
  end
  object Panel2: TPanel
    Left = 192
    Top = 80
    Width = 57
    Height = 17
    BevelOuter = bvLowered
    TabOrder = 1
    OnClick = Panel3Click
  end
  object Panel3: TPanel
    Left = 296
    Top = 80
    Width = 57
    Height = 17
    TabOrder = 2
    OnClick = Panel3Click
  end
  object Memo1: TMemo
    Left = 168
    Top = 16
    Width = 217
    Height = 33
    BorderStyle = bsNone
    Color = clBtnFace
    Ctl3D = False
    Lines.Strings = (
      'Select a colour form the left for the replace '
      'colour and then the replace with colour')
    ParentCtl3D = False
    TabOrder = 3
  end
  object Button1: TButton
    Left = 232
    Top = 304
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 4
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 312
    Top = 304
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 5
    OnClick = Button2Click
  end
  object CheckBox1: TCheckBox
    Left = 168
    Top = 80
    Width = 17
    Height = 17
    Checked = True
    Enabled = False
    State = cbChecked
    TabOrder = 6
  end
  object CheckBox2: TCheckBox
    Left = 168
    Top = 112
    Width = 17
    Height = 17
    TabOrder = 7
    OnClick = CheckBox2Click
  end
  object CheckBox3: TCheckBox
    Left = 168
    Top = 144
    Width = 17
    Height = 17
    TabOrder = 8
    OnClick = CheckBox3Click
  end
  object CheckBox4: TCheckBox
    Left = 168
    Top = 176
    Width = 17
    Height = 17
    TabOrder = 9
    OnClick = CheckBox4Click
  end
  object CheckBox5: TCheckBox
    Left = 168
    Top = 208
    Width = 17
    Height = 17
    TabOrder = 10
    OnClick = CheckBox5Click
  end
  object Panel4: TPanel
    Left = 192
    Top = 112
    Width = 57
    Height = 17
    BevelOuter = bvLowered
    TabOrder = 11
    OnClick = Panel3Click
  end
  object Panel5: TPanel
    Left = 296
    Top = 112
    Width = 57
    Height = 17
    BevelOuter = bvLowered
    TabOrder = 12
    OnClick = Panel3Click
  end
  object Panel6: TPanel
    Left = 192
    Top = 144
    Width = 57
    Height = 17
    BevelOuter = bvLowered
    TabOrder = 13
    OnClick = Panel3Click
  end
  object Panel7: TPanel
    Left = 296
    Top = 144
    Width = 57
    Height = 17
    BevelOuter = bvLowered
    TabOrder = 14
    OnClick = Panel3Click
  end
  object Panel8: TPanel
    Left = 192
    Top = 176
    Width = 57
    Height = 17
    BevelOuter = bvLowered
    TabOrder = 15
    OnClick = Panel3Click
  end
  object Panel9: TPanel
    Left = 296
    Top = 176
    Width = 57
    Height = 17
    BevelOuter = bvLowered
    TabOrder = 16
    OnClick = Panel3Click
  end
  object Panel10: TPanel
    Left = 192
    Top = 208
    Width = 57
    Height = 17
    BevelOuter = bvLowered
    TabOrder = 17
    OnClick = Panel3Click
  end
  object Panel11: TPanel
    Left = 296
    Top = 208
    Width = 57
    Height = 17
    BevelOuter = bvLowered
    TabOrder = 18
    OnClick = Panel3Click
  end
  object ApplyToAll: TCheckBox
    Left = 168
    Top = 248
    Width = 153
    Height = 17
    Caption = 'Apply To All Frames'
    TabOrder = 19
  end
  object ProgressBar1: TProgressBar
    Left = 168
    Top = 264
    Width = 217
    Height = 16
    Min = 0
    Max = 100
    TabOrder = 20
    Visible = False
  end
end
