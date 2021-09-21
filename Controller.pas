unit Controller;

interface

uses
  { WinAPI }
  Winapi.Windows, Winapi.Messages,
  { System }
  System.SysUtils, System.Variants, System.Classes, System.DateUtils,
  { Vcl }
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids,
  { JsonDataObjects }
  JsonDataObjects,
  { RESTRequest4D }
  RESTRequest4D,
  { FireDAC }
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  { Data }
  Data.DB,
  { XComponents }
  XDBGrid, Vcl.Menus;

type
  TFController = class(TForm)
    btRequest: TButton;
    mtData: TFDMemTable;
    dsData: TDataSource;
    XDBGrid: TXDBGrid;
    mtDataDATAHORA: TDateTimeField;
    mtDataUNIDADE: TStringField;
    edChave: TEdit;
    mtDataSITUACAO: TStringField;
    mtDataDETAIL: TStringField;
    tiRefresh: TTimer;
    pnLightBase: TPanel;
    pnLightBulb: TPanel;
    pmEdChave: TPopupMenu;
    miSaveChave: TMenuItem;
    mtDataHEADER: TStringField;
    procedure btRequestClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure XDBGridCellDblClick(Column: TColumn);
    procedure tiRefreshTimer(Sender: TObject);
    procedure edChaveChange(Sender: TObject);
    procedure miSaveChaveClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FController: TFController;
  Settings: TJsonObject;

implementation

{$R *.dfm}

uses Detail, ThreadCustom, Globals;

procedure TFController.btRequestClick(Sender: TObject);
begin
  THC.New
    .Initialize(
      procedure
      var
        bodydata, response, header: TJsonObject;
        tracking: TJsonArray;
        procedure _setBulbColor(AColor: TColor);
        begin
          THC.SynchronizeAsync(
          procedure
          begin
            pnLightBulb.Color := AColor;
          end);
        end;
      begin
        _setBulbColor(clRed);

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

        if not(response.B['success']) then
        begin
          _setBulbColor(clGreen);

          Exit;
        end;

        header := response.O['documento'].O['header'];
        tracking := response.O['documento'].A['tracking'];

        THC.SynchronizeAsync(
        procedure
        var
          trackingData: TJsonObject;
        begin
          mtData.EmptyDataSet;

          mtData.DisableControls;
          try
            for trackingData in tracking do
            begin
              mtData.Append;
              mtDataDATAHORA.AsDateTime := ISO8601ToDate(trackingData.S['data_hora']);
              mtDataUNIDADE.AsString := trackingData.S['cidade'];
              mtDataSITUACAO.AsString := trackingData.S['descricao'];
              mtDataDETAIL.AsString := trackingData.ToJSON;
              mtDataHEADER.AsString := header.ToJSON;
              mtData.Post;
            end;
          finally
            mtData.EnableControls;
          end;
        end);

        _setBulbColor(clGreen);
      end).Start;
end;

procedure TFController.edChaveChange(Sender: TObject);
begin
  Settings.S['chave'] := Trim(edChave.Text);
end;

procedure TFController.FormCreate(Sender: TObject);
begin
  mtData.CreateDataSet;

  Settings := TJsonObject.Create;

  if FileExists(SettingsFileName) then
  begin
    Settings.LoadFromFile(SettingsFileName);
    edChave.Text := Settings.S['chave'];
  end;
end;

procedure TFController.miSaveChaveClick(Sender: TObject);
begin
  Settings.SaveToFile(SettingsFileName);
end;

procedure TFController.tiRefreshTimer(Sender: TObject);
begin
  if not(Trim(edChave.Text).IsEmpty) then
    btRequest.Click;
end;

procedure TFController.XDBGridCellDblClick(Column: TColumn);
begin
  if not(Assigned(FDetail)) then
    Application.CreateForm(TFDetail, FDetail);

  FDetail.loadData(TJsonObject.Parse(mtDataHEADER.AsString) as TJsonObject, TJsonObject.Parse(mtDataDETAIL.AsString) as TJsonObject);
  FDetail.Show;
end;

end.
