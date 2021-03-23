unit Detail;

interface

uses
  { WinAPI }
  Winapi.Windows, Winapi.Messages,
  { System }
  System.SysUtils, System.Variants, System.Classes, System.DateUtils,
  { Vcl }
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  { JsonDataObjects }
  JsonDataObjects,
  { XComponents }
  XEdit;

type
  TFDetail = class(TForm)
    edDataHora: TXEdit;
    edDominio: TXEdit;
    edFilial: TXEdit;
    edCidade: TXEdit;
    edOcorrencia: TXEdit;
    mmDescricao: TMemo;
    edTipo: TXEdit;
    edDataHoraEfetiva: TXEdit;
    edNomeRecebedor: TXEdit;
    edNumeroDocumento: TXEdit;
    btClose: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure loadData(DataAsJson: TJsonObject);
  end;

var
  FDetail: TFDetail;

implementation

{$R *.dfm}

{ TFDetail }

procedure TFDetail.loadData(DataAsJson: TJsonObject);
begin
  edDataHora.Text := DateToStr(ISO8601ToDate(DataAsJson.S['data_hora']));
  edDominio.Text := DataAsJson.S['dominio'];
  edFilial.Text := DataAsJson.S['filial'];
  edCidade.Text := DataAsJson.S['cidade'];
  edOcorrencia.Text := DataAsJson.S['ocorrencia'];
  mmDescricao.Lines.Clear;
  mmDescricao.Lines.Add(DataAsJson.S['descricao']);
  edTipo.Text := DataAsJson.S['tipo'];
  edDataHoraEfetiva.Text := DateToStr(ISO8601ToDate(DataAsJson.S['data_hora_efetiva']));
  edNomeRecebedor.Text := DataAsJson.S['nome_recebedor'];
  edNumeroDocumento.Text := DataAsJson.S['nro_doc_recebedor'];
end;

end.
