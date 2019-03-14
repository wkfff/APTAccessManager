object fmDataBaseConfig: TfmDataBaseConfig
  Left = 0
  Top = 0
  Caption = #45936#51060#53552#48288#51060#49828#54872#44221#49444#51221
  ClientHeight = 321
  ClientWidth = 456
  Color = clBtnFace
  Font.Charset = HANGEUL_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #45208#45588#44256#46357
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 15
  object btn_Save: TW7SpeedButton
    Left = 51
    Top = 257
    Width = 130
    Height = 48
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Caption = #51201#50857
    Flat = False
    Light = False
    FadeInInterval = 15
    FadeOutInterval = 40
    ImageIndex = 0
    IconSize = is32px
    ArrowType = atDown
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 5978398
    Font.Height = -8
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    OnClick = btn_SaveClick
  end
  object btn_Close: TW7SpeedButton
    Left = 257
    Top = 257
    Width = 128
    Height = 48
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Caption = #52712#49548
    Flat = False
    Light = False
    FadeInInterval = 15
    FadeOutInterval = 40
    ImageIndex = 1
    IconSize = is32px
    ArrowType = atDown
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 5978398
    Font.Height = -8
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    OnClick = btn_CloseClick
  end
  object rg_DBType: TRadioGroup
    Left = 0
    Top = 0
    Width = 456
    Height = 44
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alTop
    Caption = 'DB Type'
    Columns = 4
    ItemIndex = 0
    Items.Strings = (
      'MSSQL'
      'PostgreSQL'
      'MDB'
      'FireBird')
    TabOrder = 0
    OnClick = rg_DBTypeClick
  end
  object AdvPanel1: TAdvPanel
    Left = 0
    Top = 44
    Width = 456
    Height = 189
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -8
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    UseDockManager = True
    Version = '2.3.0.0'
    Caption.Color = clHighlight
    Caption.ColorTo = clNone
    Caption.Font.Charset = DEFAULT_CHARSET
    Caption.Font.Color = clWindowText
    Caption.Font.Height = -8
    Caption.Font.Name = 'Tahoma'
    Caption.Font.Style = []
    Caption.Height = 21
    StatusBar.Font.Charset = DEFAULT_CHARSET
    StatusBar.Font.Color = clWindowText
    StatusBar.Font.Height = -11
    StatusBar.Font.Name = 'Tahoma'
    StatusBar.Font.Style = []
    Text = ''
    FullHeight = 200
    object Label5: TLabel
      Left = 20
      Top = 152
      Width = 145
      Height = 18
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      AutoSize = False
      Caption = #45936#51060#53552#48288#51060#49828' Name'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 20
      Top = 119
      Width = 145
      Height = 16
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      AutoSize = False
      Caption = #49324#50857#51088' '#48708#48128#48264#54840
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 20
      Top = 85
      Width = 145
      Height = 19
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      AutoSize = False
      Caption = #49324#50857#51088' '#44228#51221
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 20
      Top = 55
      Width = 145
      Height = 15
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      AutoSize = False
      Caption = #45936#51060#53552#48288#51060#49828' PORT'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = []
      ParentFont = False
    end
    object Label1: TLabel
      Left = 20
      Top = 23
      Width = 129
      Height = 16
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      AutoSize = False
      Caption = #45936#51060#53552#48288#51060#49828' IP'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = []
      ParentFont = False
    end
    object edPasswd: TEdit
      Left = 171
      Top = 114
      Width = 269
      Height = 28
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ImeName = 'Microsoft IME 2003'
      ParentFont = False
      PasswordChar = '*'
      TabOrder = 0
      Text = 'sapasswd'
    end
    object edDataBaseName: TEdit
      Left = 171
      Top = 145
      Width = 269
      Height = 28
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ImeName = 'Microsoft IME 2003'
      ParentFont = False
      TabOrder = 1
      Text = 'ZMOS'
    end
    object edUserid: TEdit
      Left = 171
      Top = 81
      Width = 269
      Height = 28
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ImeName = 'Microsoft IME 2003'
      ParentFont = False
      TabOrder = 2
      Text = 'sa'
    end
    object edServerPort: TEdit
      Left = 171
      Top = 50
      Width = 269
      Height = 28
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ImeName = 'Microsoft IME 2003'
      ParentFont = False
      TabOrder = 3
      Text = '1433'
    end
    object edServerIP: TEdit
      Left = 171
      Top = 17
      Width = 269
      Height = 28
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ImeName = 'Microsoft IME 2003'
      ParentFont = False
      TabOrder = 4
      Text = '127.0.0.1'
    end
  end
end
