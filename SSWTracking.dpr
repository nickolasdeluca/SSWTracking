program SSWTracking;

uses
  Vcl.Forms,
  Controller in 'Controller.pas' {FController},
  Detail in 'Detail.pas' {FDetail},
  ThreadCustom in 'ThreadCustom.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFController, FController);
  Application.Run;
end.
