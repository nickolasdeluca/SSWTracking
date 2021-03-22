object FController: TFController
  Left = 0
  Top = 0
  Caption = 'FController'
  ClientHeight = 352
  ClientWidth = 542
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object btRequest: TButton
    Left = 224
    Top = 319
    Width = 75
    Height = 25
    Caption = 'Request'
    TabOrder = 0
    OnClick = btRequestClick
  end
  object XDBGrid1: TXDBGrid
    Left = 8
    Top = 35
    Width = 526
    Height = 278
    DataSource = dsData
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
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
        Width = 247
        Visible = True
      end>
  end
  object edChave: TEdit
    Left = 8
    Top = 8
    Width = 526
    Height = 21
    TabOrder = 2
    Text = '43210347960950041901550130005528921074868179'
    TextHint = 'Chave da NFE'
  end
  object mtData: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 168
    Top = 120
    object mtDataDATAHORA: TDateTimeField
      FieldName = 'DATAHORA'
    end
    object mtDataUNIDADE: TStringField
      FieldName = 'UNIDADE'
    end
    object mtDataSITUACAO: TBlobField
      FieldName = 'SITUACAO'
    end
  end
  object dsData: TDataSource
    DataSet = mtData
    Left = 168
    Top = 168
  end
end
