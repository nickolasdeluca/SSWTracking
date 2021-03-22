unit Controller;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  JsonDataObjects,
  RESTRequest4D, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, Vcl.Grids, Vcl.DBGrids, XDBGrid, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TFController = class(TForm)
    btRequest: TButton;
    mtData: TFDMemTable;
    dsData: TDataSource;
    XDBGrid1: TXDBGrid;
    mtDataDATAHORA: TDateTimeField;
    mtDataUNIDADE: TStringField;
    mtDataSITUACAO: TBlobField;
    edChave: TEdit;
    procedure btRequestClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FController: TFController;

implementation

{$R *.dfm}

procedure TFController.btRequestClick(Sender: TObject);
var
  bodydata, response, header, trackingData: TJsonObject;
  tracking: TJsonArray;
  I: Integer;
begin
  bodydata := TJsonObject.Create;

  bodydata.S['chave_nfe'] := Trim(edChave.Text);

  response := TJsonObject.Parse(TRequest
            .New
            .BaseURL('https://ssw.inf.br/api/trackingdanfe')
            .ContentType('application/json')
            .Accept('application/json')
            .AddBody(bodydata.ToJSON)
            .Post
            .Content) as TJsonObject;

  header := response.O['documento'].O['header'];
  tracking := response.O['documento'].A['tracking'];

  for trackingData in tracking do
  begin
    ShowMessage(trackingData.S['descricao']);
  end;

  ShowMessage(header.ToJSON(false));
  ShowMessage(tracking.ToJSON(false));
end;

end.
