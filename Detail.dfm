object FDetail: TFDetail
  Left = 0
  Top = 0
  Caption = 'Detalhes do evento'
  ClientHeight = 261
  ClientWidth = 519
  Color = clBtnFace
  Constraints.MaxHeight = 300
  Constraints.MaxWidth = 535
  Constraints.MinHeight = 300
  Constraints.MinWidth = 535
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object edDataHora: TXEdit
    Left = 8
    Top = 8
    Width = 121
    Height = 21
    ReadOnly = True
    TabOrder = 0
  end
  object edDominio: TXEdit
    Left = 135
    Top = 8
    Width = 121
    Height = 21
    ReadOnly = True
    TabOrder = 1
  end
  object edFilial: TXEdit
    Left = 262
    Top = 8
    Width = 121
    Height = 21
    ReadOnly = True
    TabOrder = 2
  end
  object edCidade: TXEdit
    Left = 389
    Top = 8
    Width = 121
    Height = 21
    ReadOnly = True
    TabOrder = 3
  end
  object edOcorrencia: TXEdit
    Left = 8
    Top = 35
    Width = 502
    Height = 21
    ReadOnly = True
    TabOrder = 4
  end
  object mmDescricao: TMemo
    Left = 8
    Top = 62
    Width = 502
    Height = 131
    ReadOnly = True
    TabOrder = 5
  end
  object edTipo: TXEdit
    Left = 8
    Top = 199
    Width = 121
    Height = 21
    ReadOnly = True
    TabOrder = 6
  end
  object edDataHoraEfetiva: TXEdit
    Left = 135
    Top = 199
    Width = 121
    Height = 21
    ReadOnly = True
    TabOrder = 7
  end
  object edNomeRecebedor: TXEdit
    Left = 262
    Top = 199
    Width = 121
    Height = 21
    ReadOnly = True
    TabOrder = 8
  end
  object edNumeroDocumento: TXEdit
    Left = 389
    Top = 199
    Width = 121
    Height = 21
    ReadOnly = True
    TabOrder = 9
  end
  object btClose: TButton
    Left = 435
    Top = 226
    Width = 75
    Height = 25
    Caption = 'Fechar'
    TabOrder = 10
  end
end
