object FrmImportImageAsSHP: TFrmImportImageAsSHP
  Left = 193
  Top = 108
  BorderIcons = []
  BorderStyle = bsToolWindow
  Caption = 'Import Image as SHP'
  ClientHeight = 302
  ClientWidth = 358
  Color = clBtnFace
  TransparentColor = True
  TransparentColorValue = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  DesignSize = (
    358
    302)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 311
    Height = 13
    Caption = 
      'Please enter the location of the first frame using the browse bu' +
      'tton'
  end
  object Bevel1: TBevel
    Left = 0
    Top = 252
    Width = 361
    Height = 14
    Anchors = [akLeft, akBottom]
    Shape = bsBottomLine
  end
  object BackgroundOverrideBox: TGroupBox
    Left = 168
    Top = 136
    Width = 185
    Height = 122
    Hint = 
      'Selects how the program treats the first colour of the palette o' +
      'n conversion. The game usually treats it as transparent'
    Anchors = [akLeft, akBottom]
    Caption = 'Background Colour:'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 7
    object bcDefault: TRadioButton
      Left = 16
      Top = 32
      Width = 89
      Height = 17
      Hint = 
        'This uses the first colour of the palette as the colour 0 of the' +
        ' palette.'
      HelpType = htKeyword
      Caption = 'Palette Default'
      Checked = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      TabStop = True
      OnClick = bcDefaultClick
    end
    object bcCustom: TRadioButton
      Left = 16
      Top = 48
      Width = 89
      Height = 17
      Hint = 
        'This allows you to set your own colour to override the palette c' +
        'olour 0. Good for those who used a wrong colour for the backgrou' +
        'nd of the image.'
      HelpType = htKeyword
      Caption = 'Custom'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      TabStop = True
      OnClick = bcCustomClick
    end
    object bcAutoSelect: TRadioButton
      Left = 16
      Top = 64
      Width = 89
      Height = 17
      Hint = 
        'This auto selects the background colour by checking the colour o' +
        'f the first frame of the image.'
      HelpType = htKeyword
      Caption = 'Auto Select'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      TabStop = True
      OnClick = bcAutoSelectClick
    end
    object bcNone: TRadioButton
      Left = 16
      Top = 80
      Width = 89
      Height = 17
      Hint = 
        'Use this setting if you are making cameos to avoid cameos to loo' +
        'k corrupted in game.'
      HelpType = htKeyword
      Caption = 'None'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      TabStop = True
      OnClick = bcNoneClick
    end
    object bcColourEdit: TPanel
      Left = 112
      Top = 56
      Width = 57
      Height = 41
      BevelOuter = bvLowered
      Color = clSilver
      TabOrder = 4
      OnClick = bcColourEditChange
    end
  end
  object ColourConversionBox: TGroupBox
    Left = 0
    Top = 136
    Width = 161
    Height = 86
    Hint = 
      'The colour conversion method determines the way it converts the ' +
      '24bit colours to the palette colours during the import. This hea' +
      'vly affects the final result.'
    Anchors = [akLeft, akBottom]
    Caption = 'Colour Conversion Method:'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
    object ccmStu: TRadioButton
      Left = 16
      Top = 16
      Width = 113
      Height = 17
      Hint = 
        'R, G, B Difference is a method that only chooses the closest col' +
        'our that has all (R, G, B) smaller or equal than the current one' +
        '. Results tends to be influenced by the ammount of red, green an' +
        'd blue colours of the palette loosing a bit of quality, but this' +
        ' method is very efficient when using custom backgrounds.'
      HelpType = htKeyword
      Caption = 'R,G,B Difference'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
    end
    object ccmBanshee: TRadioButton
      Left = 16
      Top = 48
      Width = 113
      Height = 17
      Hint = 
        'R+G+B Difference is a method that it gets the colour with the ne' +
        'arest (R,G,B) combinated. Usually it'#39's gets better colours than ' +
        'R, G, B Diffference, but it not as reliable as the other method ' +
        'when using a custom background.'
      HelpType = htKeyword
      Caption = 'R+G+B Difference'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
    object ccmStu2: TRadioButton
      Left = 16
      Top = 32
      Width = 137
      Height = 17
      Hint = 
        'R, G, B Difference with Lightning is a method that only chooses ' +
        'the closest colour that has all (R, G, B) smaller or equal than ' +
        'the current one. Results tends to be influenced by the ammount o' +
        'f red, green and blue colours of the palette loosing a bit of qu' +
        'ality, but this method is very efficient when using custom backg' +
        'rounds. The lighting effect makes the result a bit lighter than ' +
        'the method above. The difference is usually very hard to notice,' +
        ' but sometimes it can be noticeable. This lighting has a small c' +
        'hance of corrupt the colours in few cases.'
      HelpType = htKeyword
      Caption = 'R,G,B Diff. w/ Lighting'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
    end
    object ccmBanshee2: TRadioButton
      Left = 16
      Top = 64
      Width = 129
      Height = 17
      Hint = 
        'R+G+B Full Difference is a method that it gets the colour with t' +
        'he smallest result of the square root of the square of the sum o' +
        'f the diference between the file (R,G,B) and palette (R, G, B) c' +
        'ombined. It definitelly gets the best colours in 99% of the situ' +
        'ations and is heavly recommended to be used. This is a great imp' +
        'rovement of R+G+B Difference.'
      HelpType = htKeyword
      Caption = 'R+G+B Full Difference'
      Checked = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      TabStop = True
    end
  end
  object Image_Location: TEdit
    Left = 8
    Top = 24
    Width = 265
    Height = 21
    Color = clSilver
    ReadOnly = True
    TabOrder = 0
  end
  object Button1: TButton
    Left = 280
    Top = 24
    Width = 75
    Height = 21
    Caption = 'Browse'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 184
    Top = 272
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'OK'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 272
    Top = 272
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = Button3Click
  end
  object FileListBox: TFileListBox
    Left = 184
    Top = 24
    Width = 17
    Height = 17
    ItemHeight = 13
    Mask = '*.bmp'
    TabOrder = 4
    Visible = False
  end
  object ProgressBar: TProgressBar
    Left = 8
    Top = 276
    Width = 161
    Height = 16
    Anchors = [akLeft, akBottom]
    TabOrder = 5
    Visible = False
  end
  object ConversionOptimizeBox: TGroupBox
    Left = 0
    Top = 48
    Width = 161
    Height = 81
    Hint = 
      'This loads pre-defined optimized settings for your import. So, y' +
      'ou can import the way you want.'
    Anchors = [akLeft, akBottom]
    Caption = 'Optimize Conversion For:'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 8
    DesignSize = (
      161
      81)
    object ocfTS: TRadioButton
      Left = 8
      Top = 24
      Width = 41
      Height = 17
      HelpType = htKeyword
      HelpKeyword = 
        'This will optimize the conversion for the the TS kind image sele' +
        'cted below by selecting the apropriated palette for it.'
      Caption = 'TS'
      TabOrder = 0
      OnClick = ocfTSClick
    end
    object ocfRA2: TRadioButton
      Left = 56
      Top = 24
      Width = 49
      Height = 17
      HelpType = htKeyword
      HelpKeyword = 
        'This will optimize the conversion for the the RA2 kind image sel' +
        'ected below by selecting the apropriated palette for it'
      Caption = 'RA2'
      TabOrder = 1
      OnClick = ocfRA2Click
    end
    object ocfComboOptions: TComboBox
      Left = 8
      Top = 48
      Width = 145
      Height = 21
      AutoDropDown = True
      Style = csDropDownList
      Anchors = [akLeft, akBottom]
      ItemHeight = 13
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnChange = ocfComboOptionsChange
    end
    object ocfNone: TRadioButton
      Left = 104
      Top = 24
      Width = 49
      Height = 17
      HelpType = htKeyword
      HelpKeyword = 'It will use the current selected palette for the conversion.'
      Caption = 'None'
      Checked = True
      TabOrder = 3
      TabStop = True
      OnClick = ocfNoneClick
    end
  end
  object ConversionRangeBox: TGroupBox
    Left = 168
    Top = 48
    Width = 185
    Height = 81
    Hint = 'This is where you set the frames to be imported.'
    Anchors = [akLeft, akBottom]
    Caption = 'Conversion Range:'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 9
    DesignSize = (
      185
      81)
    object Label2: TLabel
      Left = 8
      Top = 56
      Width = 23
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = 'From'
    end
    object Label3: TLabel
      Left = 96
      Top = 56
      Width = 13
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = 'To'
    end
    object crAllFrames: TRadioButton
      Left = 24
      Top = 16
      Width = 113
      Height = 17
      Caption = 'All frames'
      Checked = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      TabStop = True
    end
    object crCustomFrames: TRadioButton
      Left = 24
      Top = 32
      Width = 113
      Height = 17
      Caption = 'Custom'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
    object crFrom: TSpinEdit
      Left = 40
      Top = 50
      Width = 49
      Height = 22
      Anchors = [akLeft, akBottom]
      EditorEnabled = False
      MaxValue = 0
      MinValue = 0
      TabOrder = 2
      Value = 0
      OnChange = crFromChange
    end
    object crTo: TSpinEdit
      Left = 120
      Top = 50
      Width = 49
      Height = 22
      Anchors = [akLeft, akBottom]
      EditorEnabled = False
      MaxValue = 0
      MinValue = 0
      TabOrder = 3
      Value = 0
      OnChange = crToChange
    end
  end
  object SplitShadowBox: TGroupBox
    Left = 0
    Top = 225
    Width = 161
    Height = 33
    Hint = 'Use force shadows for everything but animations or cameos.'
    Caption = 'Shadow Settings:'
    TabOrder = 10
    object ssShadow: TCheckBox
      Left = 32
      Top = 13
      Width = 121
      Height = 17
      Hint = 
        'When the colours of the last half of frames are not background, ' +
        'they will be detected as shadows. Recommended if your picture in' +
        'cludes shadows (even if they are in the wrong colours). Do not u' +
        'se this with cameos and animations that uses no shadows.'
      Caption = 'Optimize Shadows'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
    end
  end
  object OpenPictureDialog: TOpenPictureDialog
    Filter = 
      'Bitmaps (*0000.bmp)|*0000.bmp|JPEGs (*0000.jpg, *0000.jpeg)|*000' +
      '0.jpg;*0000.jpeg'
    Left = 200
    Top = 24
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Filter = 'Bitmap (*.bmp)|*.bmp|JPEG (*.jpg, *.jpeg)|*.jpg;*.jpeg'
    Left = 248
    Top = 24
  end
  object ColorDialog1: TColorDialog
    Left = 296
    Top = 151
  end
end
