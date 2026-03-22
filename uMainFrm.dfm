object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = #20013#21326#22825#25991#21382
  ClientHeight = 733
  ClientWidth = 1060
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  TextHeight = 15
  object pnl1: TPanel
    Left = 0
    Top = 403
    Width = 1060
    Height = 330
    Align = alBottom
    TabOrder = 0
    object spl1: TSplitter
      Left = 353
      Top = 1
      Height = 328
      ExplicitLeft = 377
    end
    object mmo1: TMemo
      Left = 1
      Top = 1
      Width = 352
      Height = 328
      Align = alLeft
      Lines.Strings = (
        '')
      ScrollBars = ssVertical
      TabOrder = 0
      StyleName = 'Windows'
    end
    object SynEdit1: TSynEdit
      Left = 356
      Top = 1
      Width = 703
      Height = 328
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Consolas'
      Font.Style = []
      Font.Quality = fqClearTypeNatural
      TabOrder = 1
      UseCodeFolding = False
      Gutter.Font.Charset = DEFAULT_CHARSET
      Gutter.Font.Color = clWindowText
      Gutter.Font.Height = -11
      Gutter.Font.Name = 'Consolas'
      Gutter.Font.Style = []
      Gutter.Bands = <
        item
          Kind = gbkMarks
          Width = 13
        end
        item
          Kind = gbkLineNumbers
        end
        item
          Kind = gbkFold
        end
        item
          Kind = gbkTrackChanges
        end
        item
          Kind = gbkMargin
          Width = 3
        end>
      Lines.Strings = (
        'SynEdit1')
      SelectedColor.Alpha = 0.400000005960464500
    end
  end
  object pnlTop: TPanel
    Left = 0
    Top = 35
    Width = 1060
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object lblLat: TLabel
      Left = 445
      Top = 12
      Width = 48
      Height = 17
      Caption = #32463#24230#65306
      Color = clHighlight
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clHighlight
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object lblLon: TLabel
      Left = 586
      Top = 12
      Width = 48
      Height = 17
      Caption = #32428#24230#65306
      Color = clHighlight
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clHighlight
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object lbl1: TLabel
      Left = 4
      Top = 12
      Width = 48
      Height = 17
      Caption = #30465#20221#65306
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object lbl2: TLabel
      Left = 224
      Top = 12
      Width = 48
      Height = 17
      Caption = #22478#24066#65306
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object cbbCity: TComboBox
      Left = 273
      Top = 8
      Width = 163
      Height = 25
      Style = csDropDownList
      DropDownCount = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ImeMode = imClose
      ParentFont = False
      TabOrder = 0
      StyleElements = [seClient, seBorder]
      OnChange = cbbCityChange
    end
    object cbbPro: TComboBox
      Left = 56
      Top = 8
      Width = 153
      Height = 25
      Style = csDropDownList
      DropDownCount = 24
      ExtendedUI = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ImeMode = imClose
      ParentFont = False
      TabOrder = 1
      StyleElements = [seClient, seBorder]
      OnChange = cbbProChange
    end
  end
  object pgcMain: TPageControl
    Left = 0
    Top = 76
    Width = 1060
    Height = 327
    ActivePage = tsMonthCalendar
    Align = alClient
    TabOrder = 2
    StyleName = 'Windows'
    object tsMonthCalendar: TTabSheet
      Caption = #26376#21382
    end
    object tsYearCalendar: TTabSheet
      Caption = #24180#21382
      ImageIndex = 1
    end
    object tsTest: TTabSheet
      Caption = #27979#35797
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = []
      ImageIndex = 2
      ParentFont = False
      object edt1: TEdit
        Left = 16
        Top = 12
        Width = 121
        Height = 29
        TabOrder = 0
        Text = '2024'
      end
      object edt2: TEdit
        Left = 16
        Top = 48
        Width = 121
        Height = 29
        TabOrder = 1
        Text = '3'
      end
      object edt3: TEdit
        Left = 16
        Top = 84
        Width = 121
        Height = 29
        TabOrder = 2
        Text = '27'
      end
      object btn10: TButton
        Left = 191
        Top = 139
        Width = 161
        Height = 25
        Caption = #34892#26143#25968#25454#26684#24335#36716#25442#24037#20855
        TabOrder = 3
        OnClick = btn10Click
      end
      object btn11: TButton
        Left = 349
        Top = 83
        Width = 75
        Height = 25
        Caption = 'btn11'
        TabOrder = 4
        OnClick = btn11Click
      end
      object btn7: TButton
        Left = 254
        Top = 83
        Width = 75
        Height = 25
        Caption = 'btn7'
        TabOrder = 5
        OnClick = btn7Click
      end
      object btn5: TButton
        Left = 160
        Top = 83
        Width = 75
        Height = 25
        Caption = 'btn5'
        TabOrder = 6
        OnClick = btn5Click
      end
      object btn6: TButton
        Left = 349
        Top = 42
        Width = 75
        Height = 25
        Caption = 'btn6'
        TabOrder = 7
        OnClick = btn6Click
      end
      object btnTrunc: TButton
        Left = 446
        Top = 11
        Width = 145
        Height = 25
        Caption = '360'#20043#38388#30340#24230#25968
        TabOrder = 8
        OnClick = btnTruncClick
      end
      object btnFloor: TButton
        Left = 349
        Top = 11
        Width = 75
        Height = 25
        Caption = 'btnFloor'
        TabOrder = 9
        OnClick = btnFloorClick
      end
      object btn2: TButton
        Left = 254
        Top = 11
        Width = 75
        Height = 25
        Caption = 'btn2'
        TabOrder = 10
        OnClick = btn2Click
      end
      object btn4: TButton
        Left = 254
        Top = 47
        Width = 75
        Height = 25
        Caption = 'btn4'
        TabOrder = 11
        OnClick = btn4Click
      end
      object btn9: TButton
        Left = 446
        Top = 83
        Width = 75
        Height = 25
        Caption = 'btn9'
        TabOrder = 12
        OnClick = btn9Click
      end
      object btn8: TButton
        Left = 446
        Top = 42
        Width = 75
        Height = 25
        Caption = 'btn8'
        TabOrder = 13
        OnClick = btn8Click
      end
      object btn3: TButton
        Left = 160
        Top = 47
        Width = 75
        Height = 25
        Caption = 'btn3'
        TabOrder = 14
        OnClick = btn3Click
      end
      object btn1: TButton
        Left = 160
        Top = 11
        Width = 75
        Height = 25
        Caption = 'btn1'
        TabOrder = 15
        OnClick = btn1Click
      end
      object cbb1: TComboBox
        Left = 16
        Top = 124
        Width = 121
        Height = 29
        ItemIndex = 0
        TabOrder = 16
        Text = 'B0'
        Items.Strings = (
          'B0'
          'B1'
          'B2'
          'L4'
          'L5')
      end
      object btn12: TButton
        Left = 568
        Top = 83
        Width = 75
        Height = 25
        Caption = 'btn12'
        TabOrder = 17
        OnClick = btn12Click
      end
      object btn13: TButton
        Left = 568
        Top = 152
        Width = 75
        Height = 25
        Caption = 'btn13'
        TabOrder = 18
        OnClick = btn13Click
      end
      object edt4: TEdit
        Left = 400
        Top = 150
        Width = 121
        Height = 29
        TabOrder = 19
        Text = '2436116.31'
      end
    end
  end
  object pnlContinents: TPanel
    Left = 0
    Top = 0
    Width = 1060
    Height = 35
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    object lblDateTime: TLabel
      Left = 20
      Top = 7
      Width = 91
      Height = 21
      Caption = 'lblDateTime'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold, fsItalic]
      ParentFont = False
    end
    object lblSQDateTime: TLabel
      Left = 808
      Top = 10
      Width = 84
      Height = 15
      Caption = 'lblSQDateTime'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clIndianred
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblCity: TLabel
      Left = 544
      Top = 10
      Width = 34
      Height = 15
      Caption = 'lblCity'
    end
    object cbbContinents: TComboBox
      Left = 224
      Top = 5
      Width = 145
      Height = 25
      Style = csDropDownList
      DropDownCount = 6
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ImeMode = imClose
      ItemIndex = 0
      ParentFont = False
      TabOrder = 0
      Text = #20122#27954
      StyleElements = [seClient, seBorder]
      OnChange = cbbContinentsChange
      Items.Strings = (
        #20122#27954
        #27431#27954
        #21271#32654#27954
        #20013#21335#32654#27954
        #38750#27954
        #22823#27915#27954)
    end
    object cbbSQ: TComboBox
      Left = 380
      Top = 5
      Width = 145
      Height = 25
      Style = csDropDownList
      DropDownCount = 30
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ImeMode = imClose
      ParentFont = False
      TabOrder = 1
      StyleElements = [seClient, seBorder]
      OnChange = cbbSQChange
    end
  end
end
