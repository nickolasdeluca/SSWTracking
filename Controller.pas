unit Controller;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  JsonDataObjects,
  RESTRequest4D;

type
  TFController = class(TForm)
    btRequest: TButton;
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
  Json: TJsonObject;
begin
  Json := TJsonObject.Create;

  Json.S['chave_nfe'] := '43210347960950041901550130005528921074868179';

  ShowMessage(
  TRequest
    .New
    .BaseURL('https://ssw.inf.br/api/trackingdanfe')
    .ContentType('application/json')
    .Accept('application/json')
    .AddBody(Json.ToJSON)
    .Post
    .Content
  );
end;

end.
