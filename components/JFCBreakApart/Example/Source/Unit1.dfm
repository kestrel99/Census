object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'TJFCBreakApart'
  ClientHeight = 315
  ClientWidth = 628
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 20
  object Label1: TLabel
    Left = 20
    Top = 7
    Width = 79
    Height = 20
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Base string :'
  end
  object Label2: TLabel
    Left = 20
    Top = 66
    Width = 85
    Height = 20
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Break string :'
  end
  object BaseStringEdit: TEdit
    Left = 20
    Top = 31
    Width = 589
    Height = 28
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    TabOrder = 0
  end
  object BreakApartButton: TButton
    Left = 20
    Top = 216
    Width = 165
    Height = 32
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'BreakApart'
    TabOrder = 5
    OnClick = BreakApartButtonClick
  end
  object ReverseBreakApartButton: TButton
    Left = 20
    Top = 259
    Width = 165
    Height = 32
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'ReverseBreakApart'
    Enabled = False
    TabOrder = 6
    OnClick = ReverseBreakApartButtonClick
  end
  object BreakApartListBox: TListBox
    Left = 199
    Top = 90
    Width = 410
    Height = 201
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    ItemHeight = 20
    TabOrder = 7
  end
  object AllowEmptyStringCheckBox: TCheckBox
    Left = 20
    Top = 136
    Width = 165
    Height = 17
    Caption = 'Allow empty string'
    TabOrder = 2
  end
  object CaseSensitiveCheckBox: TCheckBox
    Left = 20
    Top = 159
    Width = 165
    Height = 17
    Caption = 'Case sensitive'
    TabOrder = 3
  end
  object DoubleQuoteModeCheckBox: TCheckBox
    Left = 20
    Top = 182
    Width = 165
    Height = 17
    Caption = 'Double quote mode'
    TabOrder = 4
  end
  object BreakStringEdit: TEdit
    Left = 20
    Top = 90
    Width = 165
    Height = 28
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    TabOrder = 1
  end
  object JFCBreakApart1: TJFCBreakApart
    AllowEmptyString = False
    BreakString = ','
    BaseString = '"AAA,BBB,CCC","DDD",,"EEE","","FFF,GGG"'
    CaseSensitive = False
    DoubleQuoteMode = False
    Left = 240
    Top = 112
  end
end
