//
// Created by Danilo Lucas - developer.dlio@gmail.com
// 01-03-2021
//

unit ThreadCustom;

interface

uses
  System.SysUtils, System.Classes, System.Threading;

type
  TThread = System.Classes.TThread;

  Exception = System.SysUtils.Exception;

  TOnExecute = reference to procedure;

  TOnError = reference to procedure(const E: Exception; out AContinue: Boolean);

  ITH = interface
    ['{8754415A-5B91-4372-BE5E-3B08C173B6B6}']
    function Initialize(const AProc: TOnExecute): ITH;
    function InitializeAsync(const AProc: TOnExecute): ITH;
    function InitializeSync(const AProc: TOnExecute): ITH;
    function Add(const AProc: TOnExecute): ITH;
    function AddAsync(const AProc: TOnExecute): ITH;
    function AddSync(const AProc: TOnExecute): ITH;
    function Error(const AProc: TOnError): ITH;
    function Finish(const AProc: TOnExecute): ITH;
    function FinishAsync(const AProc: TOnExecute): ITH;
    function FinishSync(const AProc: TOnExecute): ITH;
    procedure Start;
    procedure StartWait;
  end;

  THC = class(TInterfacedObject, ITH)
  private
    FBegin: TOnExecute;
    FEnd: TOnExecute;
    FError: TOnError;
    FTask: TArray<ITask>;
    function StartThread: TThread;
  protected
    constructor Create;
  public
    function Initialize(const AProc: TOnExecute): ITH;
    function InitializeAsync(const AProc: TOnExecute): ITH;
    function InitializeSync(const AProc: TOnExecute): ITH;
    function Add(const AProc: TOnExecute): ITH;
    function AddAsync(const AProc: TOnExecute): ITH;
    function AddSync(const AProc: TOnExecute): ITH;
    function Error(const AProc: TOnError): ITH;
    function Finish(const AProc: TOnExecute): ITH;
    function FinishAsync(const AProc: TOnExecute): ITH;
    function FinishSync(const AProc: TOnExecute): ITH;
    procedure Start;
    procedure StartWait;

    class function New: ITH;
    class procedure Synchronize(const AProc: TOnExecute);
    class procedure SynchronizeAsync(const AProc: TOnExecute);
  end;

  // THC.New
  // .Initialize(
  // procedure
  // begin
  // THC.Synchronize(
  // procedure
  // begin
  // end);
  // end)
  //
  // .Add(
  // procedure
  // begin
  // end)
  //
  // .Add(
  // procedure
  // begin
  // end)
  //
  // .Error(
  // procedure(const E: Exception; out AContinue: Boolean)
  // begin
  // AContinue := True;
  // end)
  //
  // .Finish(
  // procedure
  // begin
  // THC.Synchronize(
  // procedure
  // begin
  // end);
  // end)
  //
  // .Start;

implementation

{ THC }

class function THC.New: ITH;
begin
  Result := THC.Create;
end;

class procedure THC.Synchronize(const AProc: TOnExecute);
begin
  TThread.Synchronize(nil,
    procedure
    begin
      if Assigned(AProc) then
        AProc;
    end);
end;

class procedure THC.SynchronizeAsync(const AProc: TOnExecute);
begin
  TThread.Queue(nil,
    procedure
    begin
      if Assigned(AProc) then
        AProc;
    end);
end;

constructor THC.Create;
begin
  inherited;
  FTask := [];
  FBegin := nil;
  FEnd := nil;
  FError := nil;
end;

function THC.Initialize(const AProc: TOnExecute): ITH;
begin
  Result := Self;
  FBegin := AProc;
end;

function THC.InitializeAsync(const AProc: TOnExecute): ITH;
begin
  Result := Initialize(
    procedure
    begin
      Self.SynchronizeAsync(AProc)
    end);
end;

function THC.InitializeSync(const AProc: TOnExecute): ITH;
begin
  Result := Initialize(
    procedure
    begin
      Self.Synchronize(AProc)
    end);
end;

function THC.Add(const AProc: TOnExecute): ITH;
begin
  Result := Self;
  FTask := Concat(FTask, [TTask.Create(
    procedure
    begin
      if Assigned(AProc) then
        AProc;
    end)]);
end;

function THC.AddAsync(const AProc: TOnExecute): ITH;
begin
  Result := Add(
    procedure
    begin
      Self.SynchronizeAsync(AProc)
    end);
end;

function THC.AddSync(const AProc: TOnExecute): ITH;
begin
  Result := Add(
    procedure
    begin
      Self.Synchronize(AProc)
    end);
end;

function THC.Error(const AProc: TOnError): ITH;
begin
  Result := Self;
  FError := AProc;
end;

function THC.Finish(const AProc: TOnExecute): ITH;
begin
  Result := Self;
  FEnd := AProc;
end;

function THC.FinishAsync(const AProc: TOnExecute): ITH;
begin
  Result := Finish(
    procedure
    begin
      Self.SynchronizeAsync(AProc)
    end);
end;

function THC.FinishSync(const AProc: TOnExecute): ITH;
begin
  Result := Finish(
    procedure
    begin
      Self.Synchronize(AProc)
    end);
end;

procedure THC.Start;
begin
  StartThread;
end;

procedure THC.StartWait;
var
  LT: TThread;
begin
  LT := StartThread;
  LT.FreeOnTerminate := False;
  LT.WaitFor;
end;

function THC.StartThread: TThread;
var
  LBegin: TOnExecute;
  LEnd: TOnExecute;
  LError: TOnError;
  LTasks: TArray<ITask>;
  LIsContinue: Boolean;
  LThread: TThread;
begin
  LBegin := FBegin;
  LEnd := FEnd;
  LError := FError;
  LTasks := FTask;
  LIsContinue := True;

  LThread := TThread.CreateAnonymousThread(
    procedure
    begin
      try
        try
          if Assigned(LBegin) then
            LBegin;

          if Length(LTasks) > 0 then
          begin
            TParallel.for(Low(LTasks), High(LTasks),
              procedure(Index: Integer)
              begin
                LTasks[Index].Start;
              end);

            TTask.WaitForAll(LTasks);
          end;
        except
          on E: Exception do
            if Assigned(LError) then
              LError(E, LIsContinue)
            else
              raise;
        end;
      finally
        if not LThread.FreeOnTerminate then
          LThread.Terminate;

        if Assigned(LEnd) and LIsContinue then
          LEnd;
      end;
    end);
  LThread.Start;

  Result := LThread;
end;

end.
