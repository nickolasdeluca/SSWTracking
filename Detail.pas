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
  XEdit, Vcl.ExtCtrls;

type
  TFDetail = class(TForm)
    edOcorrencia: TXEdit;
    mmDescricao: TMemo;
    btClose: TButton;
    edRemetente: TXEdit;
    edDestinatario: TXEdit;
    pnHeaderDocumentData: TPanel;
    pnTrackingData: TPanel;
    edDataHora: TXEdit;
    edDominio: TXEdit;
    edFilial: TXEdit;
    edCidade: TXEdit;
    pnTrackingDataFooter: TPanel;
    edTipo: TXEdit;
    edDataHoraEfetiva: TXEdit;
    edNomeRecebedor: TXEdit;
    edNumeroDocumento: TXEdit;
    edNumeroNf: TXEdit;
    edNumeroPedido: TXEdit;
    procedure btCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure loadData(HeaderAsJson: TJsonObject; DataAsJson: TJsonObject);
  end;

var
  FDetail: TFDetail;

implementation

{$R *.dfm}

{ TFDetail }

procedure TFDetail.btCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFDetail.loadData(HeaderAsJson: TJsonObject; DataAsJson: TJsonObject);
begin
  edRemetente.Text := HeaderAsJson.S['remetente'];
  edDestinatario.Text := HeaderAsJson.S['destinatario'];
  edNumeroNf.Text := HeaderAsJson.S['nro_nf'];
  edNumeroPedido.Text := HeaderAsJson.S['pedido'];

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
