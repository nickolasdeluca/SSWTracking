program SSWTracking;

uses
  Vcl.Forms,
  Controller in 'Controller.pas' {FController};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFController, FController);
  Application.Run;
end.
