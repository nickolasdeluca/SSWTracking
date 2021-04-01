unit ThreadCustom;

interface

uses
  System.Classes, System.SysUtils, System.Threading, System.SyncObjs;

type
  Exception = System.SysUtils.Exception;

  TOnError = reference to procedure(const E: Exception; out AContinue: Boolean);

  THC = class(TThread)
  private
    FEvent: TEvent;
    FInitialize: TThreadProcedure;
    FFinish: TThreadProcedure;
    FError: TOnError;
    FAdd: TArray<ITask>;
  protected
    procedure Execute; override;
  public
    function Initialize(const AProc: TThreadProcedure): THC;
    function InitializeAsync(const AProc: TThreadProcedure): THC;
    function InitializeSync(const AProc: TThreadProcedure): THC;
    function Add(const AProc: TThreadProcedure): THC;
    function AddAsync(const AProc: TThreadProcedure): THC;
    function AddSync(const AProc: TThreadProcedure): THC;
    function Error(const AProc: TOnError): THC;
    function Finish(const AProc: TThreadProcedure): THC;
    function FinishAsync(const AProc: TThreadProcedure): THC;
    function FinishSync(const AProc: TThreadProcedure): THC;
    function Start: THC;
    function StartWait: THC;
    procedure Finalize(var AObject);

    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;

    class function New: THC;
    class procedure Synchronize(const AProc: TThreadProcedure);
    class procedure SynchronizeAsync(const AProc: TThreadProcedure);
  end;

implementation

{ THC }

class function THC.New: THC;
begin
  Result := THC.Create(True);
end;

class procedure THC.Synchronize(const AProc: TThreadProcedure);
begin
  if Assigned(AProc) then
    if (Current.ThreadID = MainThreadID) then
      AProc
    else
      TThread.Synchronize(nil, AProc);
end;

class procedure THC.SynchronizeAsync(const AProc: TThreadProcedure);
begin
  if Assigned(AProc) then
    if Current.ThreadID = MainThreadID then
      AProc
    else
      TThread.Queue(nil, AProc);
end;

procedure THC.AfterConstruction;
begin
  FEvent := TEvent.Create;

  FAdd := [];
  FInitialize := nil;
  FFinish := nil;
  FError := nil;

  FreeOnTerminate := True;
  inherited Start;
end;

procedure THC.BeforeDestruction;
begin
  FEvent.DisposeOf;
end;

function THC.Initialize(const AProc: TThreadProcedure): THC;
begin
  Result := Self;
  FInitialize := AProc;
end;

function THC.InitializeAsync(const AProc: TThreadProcedure): THC;
begin
  Result := Initialize(
    procedure
    begin
      Self.SynchronizeAsync(AProc);
    end);
end;

function THC.InitializeSync(const AProc: TThreadProcedure): THC;
begin
  Result := Initialize(
    procedure
    begin
      Self.Synchronize(AProc);
    end);
end;

function THC.Add(const AProc: TThreadProcedure): THC;
begin
  Result := Self;
  FAdd := Concat(FAdd, [TTask.Create(
    procedure
    begin
      if not Terminated then
        AProc;
    end)]);
end;

function THC.AddAsync(const AProc: TThreadProcedure): THC;
begin
  Result := Add(
    procedure
    begin
      Self.SynchronizeAsync(AProc);
    end);
end;

function THC.AddSync(const AProc: TThreadProcedure): THC;
begin
  Result := Add(
    procedure
    begin
      Self.Synchronize(AProc);
    end);
end;

function THC.Error(const AProc: TOnError): THC;
begin
  Result := Self;
  FError := AProc;
end;

function THC.Finish(const AProc: TThreadProcedure): THC;
begin
  Result := Self;
  FFinish :=
      procedure
    begin
      if not Terminated then
        AProc;
    end;
end;

function THC.FinishAsync(const AProc: TThreadProcedure): THC;
begin
  Result := Finish(
    procedure
    begin
      Self.SynchronizeAsync(AProc);
    end);
end;

function THC.FinishSync(const AProc: TThreadProcedure): THC;
begin
  Result := Finish(
    procedure
    begin
      Self.Synchronize(AProc);
    end);
end;

function THC.Start: THC;
begin
  Result := Self;
  FEvent.SetEvent;
end;

function THC.StartWait: THC;
begin
  FreeOnTerminate := False;
  Result := Start;
  WaitFor;
  DisposeOf;
end;

procedure THC.Execute;
var
  LIsContinue: Boolean;
begin
  FEvent.WaitFor(INFINITE);
  FEvent.ResetEvent;

  LIsContinue := True;

  try
    try
      if Assigned(FInitialize) then
        FInitialize;

      if Length(FAdd) > 0 then
      begin
        TParallel.For(Low(FAdd), High(FAdd),
          procedure(Index: Integer)
          begin
            FAdd[Index].Start;
          end);

        try
          TTask.WaitForAll(FAdd);
        except
          on E: EAggregateException do
            if Assigned(FError) then
              FError(E.InnerExceptions[0], LIsContinue)
            else
              raise;

          on E: Exception do
            Exit;
        end;
      end;
    except
      on E: Exception do
        if Assigned(FError) then
          FError(E, LIsContinue)
        else
          raise;
    end;
  finally
    try
      if Assigned(FFinish) and LIsContinue then
        FFinish;
    finally
      if not FreeOnTerminate then
        Terminate;
    end;
  end;
end;

procedure THC.Finalize(var AObject);
begin
  if not Assigned(TObject(AObject)) then
    Exit;

  if not Terminated then
  begin
    Terminate;

    if Length(FAdd) > 0 then
      TParallel.For(Low(FAdd), High(FAdd),
        procedure(Index: Integer)
        begin
          FAdd[Index].Cancel;
        end);

    Pointer(AObject) := nil;
  end;
end;

end.
