object FController: TFController
  Left = 0
  Top = 0
  Caption = 'FController'
  ClientHeight = 386
  ClientWidth = 973
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    973
    386)
  PixelsPerInch = 96
  TextHeight = 13
  object btRequest: TButton
    Left = 479
    Top = 353
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Request'
    TabOrder = 0
    OnClick = btRequestClick
  end
  object XDBGrid1: TXDBGrid
    Left = 8
    Top = 35
    Width = 957
    Height = 312
    Anchors = [akLeft, akTop, akRight, akBottom]
    DataSource = dsData
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnCellDblClick = XDBGrid1CellDblClick
    Columns = <
      item
        Expanded = False
        FieldName = 'DATAHORA'
        Title.Caption = 'Data/Hora'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'UNIDADE'
        Title.Caption = 'Unidade'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'SITUACAO'
        Title.Caption = 'Situa'#231#227'o'
        Width = 673
        Visible = True
      end>
  end
  object edChave: TEdit
    Left = 8
    Top = 8
    Width = 957
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
    Text = '43210347960950041901550130005528921074868179'
    TextHint = 'Chave da NFE'
  end
  object pnLightBase: TPanel
    Left = 8
    Top = 355
    Width = 20
    Height = 20
    Caption = 'pnLightBase'
    ShowCaption = False
    TabOrder = 3
    object pnLightBulb: TPanel
      AlignWithMargins = True
      Left = 2
      Top = 2
      Width = 16
      Height = 16
      Margins.Left = 1
      Margins.Top = 1
      Margins.Right = 1
      Margins.Bottom = 1
      Align = alClient
      Caption = 'pnLightBulb'
      Color = clGreen
      ParentBackground = False
      ShowCaption = False
      TabOrder = 0
    end
  end
  object mtData: TFDMemTable
    FieldDefs = <>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 168
    Top = 120
    object mtDataDATAHORA: TDateTimeField
      FieldName = 'DATAHORA'
    end
    object mtDataUNIDADE: TStringField
      FieldName = 'UNIDADE'
    end
    object mtDataSITUACAO: TStringField
      FieldName = 'SITUACAO'
      Size = 1000
    end
    object mtDataDETAIL: TStringField
      FieldName = 'DETAIL'
      Size = 1000
    end
  end
  object dsData: TDataSource
    DataSet = mtData
    Left = 168
    Top = 168
  end
  object tiRefresh: TTimer
    Interval = 3600000
    OnTimer = tiRefreshTimer
    Left = 480
    Top = 200
  end
end
