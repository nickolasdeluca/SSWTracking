{
  *************************************
  Created by Danilo Lucas
  Github - https://github.com/dliocode
  *************************************
}

unit ThreadCustom;

interface

uses
  System.SysUtils, System.Classes, System.Threading;

type
  TThread = System.Classes.TThread;

  Exception = System.SysUtils.Exception;

  TOnError = reference to procedure(const E: Exception; out AContinue: Boolean);

  ITH = interface
    ['{8754415A-5B91-4372-BE5E-3B08C173B6B6}']
    function Initialize(const AProc: TThreadProcedure): ITH;
    function InitializeAsync(const AProc: TThreadProcedure): ITH;
    function InitializeSync(const AProc: TThreadProcedure): ITH;
    function Add(const AProc: TThreadProcedure): ITH;
    function AddAsync(const AProc: TThreadProcedure): ITH;
    function AddSync(const AProc: TThreadProcedure): ITH;
    function Error(const AProc: TOnError): ITH;
    function Finish(const AProc: TThreadProcedure): ITH;
    function FinishAsync(const AProc: TThreadProcedure): ITH;
    function FinishSync(const AProc: TThreadProcedure): ITH;
    procedure Start;
    procedure StartWait;
  end;

  THC = class sealed(TInterfacedObject, ITH)
  private
    FException: Exception;
    FInitialize: TThreadProcedure;
    FFinish: TThreadProcedure;
    FError: TOnError;
    FAdd: TArray<ITask>;

    function StartThread: TThread;
  protected
    constructor Create;
  public
    function Initialize(const AProc: TThreadProcedure): ITH;
    function InitializeAsync(const AProc: TThreadProcedure): ITH;
    function InitializeSync(const AProc: TThreadProcedure): ITH;
    function Add(const AProc: TThreadProcedure): ITH;
    function AddAsync(const AProc: TThreadProcedure): ITH;
    function AddSync(const AProc: TThreadProcedure): ITH;
    function Error(const AProc: TOnError): ITH;
    function Finish(const AProc: TThreadProcedure): ITH;
    function FinishAsync(const AProc: TThreadProcedure): ITH;
    function FinishSync(const AProc: TThreadProcedure): ITH;
    procedure Start;
    procedure StartWait;

    class function New: ITH;

    class procedure Synchronize(const AProc: TThreadProcedure);
    class procedure SynchronizeAsync(const AProc: TThreadProcedure);
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

class procedure THC.Synchronize(const AProc: TThreadProcedure);
begin
  if (TThread.Current.ThreadID = MainThreadID) then
    AProc
  else
    TThread.Synchronize(nil, AProc);
end;

class procedure THC.SynchronizeAsync(const AProc: TThreadProcedure);
begin
  if TThread.Current.ThreadID = MainThreadID then
    AProc
  else
    TThread.Queue(nil, AProc);
end;

constructor THC.Create;
begin
  inherited;
  FAdd := [];
  FInitialize := nil;
  FFinish := nil;
  FError := nil;
end;

function THC.Initialize(const AProc: TThreadProcedure): ITH;
begin
  Result := Self;
  FInitialize := AProc;
end;

function THC.InitializeAsync(const AProc: TThreadProcedure): ITH;
begin
  Result := Initialize(
    procedure
    begin
      Self.SynchronizeAsync(AProc)
    end);
end;

function THC.InitializeSync(const AProc: TThreadProcedure): ITH;
begin
  Result := Initialize(
    procedure
    begin
      Self.Synchronize(AProc)
    end);
end;

function THC.Add(const AProc: TThreadProcedure): ITH;
begin
  Result := Self;
  FAdd := Concat(FAdd, [TTask.Create(
    procedure
    begin
      try
        if Assigned(AProc) then
          AProc;
      except
        on E: Exception do
        begin
          FException := E;
          raise;
        end;
      end;
    end)]);
end;

function THC.AddAsync(const AProc: TThreadProcedure): ITH;
begin
  Result := Add(
    procedure
    begin
      Self.SynchronizeAsync(AProc)
    end);
end;

function THC.AddSync(const AProc: TThreadProcedure): ITH;
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

function THC.Finish(const AProc: TThreadProcedure): ITH;
begin
  Result := Self;
  FFinish := AProc;
end;

function THC.FinishAsync(const AProc: TThreadProcedure): ITH;
begin
  Result := Finish(
    procedure
    begin
      Self.SynchronizeAsync(AProc)
    end);
end;

function THC.FinishSync(const AProc: TThreadProcedure): ITH;
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
  LInitialize: TThreadProcedure;
  LFinish: TThreadProcedure;
  LError: TOnError;
  LAdd: TArray<ITask>;
  LIsContinue: Boolean;
  LThread: TThread;
begin
  LInitialize := FInitialize;
  LFinish := FFinish;
  LError := FError;
  LAdd := FAdd;
  LIsContinue := True;

  LThread := TThread.CreateAnonymousThread(
    procedure
    begin
      try
        try
          if Assigned(LInitialize) then
            LInitialize;

          if Length(LAdd) > 0 then
          begin
            TParallel.for(Low(LAdd), High(LAdd),
              procedure(Index: Integer)
              begin
                LAdd[Index].Start;
              end);

            TTask.WaitForAll(LAdd);
          end;
        except
          on E: Exception do
            if Assigned(LError) then
              if Assigned(FException) then
                LError(FException, LIsContinue)
              else
                LError(E, LIsContinue);
            else
              raise;
        end;
      finally
        if not LThread.FreeOnTerminate then
          LThread.Terminate;

        if Assigned(LFinish) and LIsContinue then
          LFinish;
      end;
    end);
  LThread.Start;

  Result := LThread;
end;

end.
