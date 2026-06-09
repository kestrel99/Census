//  **
//   * Census 2, a NONMEM project manager
//   *
//   * Copyright 2017, Justin J Wilkins.
//   *
//   * This is free software; you can redistribute it and/or modify it
//   * under the terms of the GNU Lesser General Public License as
//   * published by the Free Software Foundation; either version 2.1 of
//   * the License, or (at your option) any later version.
//   *
//   * This software is distributed in the hope that it will be useful,
//   * but WITHOUT ANY WARRANTY; without even the implied warranty of
//   * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
//   * Lesser General Public License for more details.
//   *
//   * You should have received a copy of the GNU Lesser General Public
//   * License along with this software; if not, write to the Free
//   * Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
//   * 02110-1301 USA, or see the FSF site: http://www.fsf.org.
//   */

unit rproc;

{$mode delphi}

interface

uses
  Classes, SysUtils, FileUtil, SynMemo, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, Process, IniFiles;

type

  { TfrmRProc }

  TfrmRProc = class(TForm)
    Button2: TButton;
    memR: TSynMemo;
    timIdle: TIdleTimer;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure timIdleTimer(Sender: TObject);
    procedure RSend(strCmd: string);
  private
    { private declarations }
  public
    { public declarations }
  end;

const
  READ_BYTES = 2048;

var
  frmRProc: TfrmRProc;
  rProcess: TProcess;
  rCommand: String;
  rOutput: TStringList;
  rStream: TMemoryStream;
  NumBytes: LongInt;
  BytesRead: LongInt;

implementation

{$R *.lfm}

{ TfrmRProc }

procedure TfrmRProc.Button1Click(Sender: TObject);
begin


end;

procedure TfrmRProc.Button2Click(Sender: TObject);
begin
  rProcess.Free;
  Close;
end;

procedure TfrmRProc.RSend(strCmd: string);
var
  InputStrings: string;
begin
  if rProcess.Running then
  begin
    InputStrings := strCmd + #10;
    rProcess.Input.Write(InputStrings[1], length(InputStrings));
  end;
end;

procedure TfrmRProc.Button3Click(Sender: TObject);
begin
  RSend('setwd()');
end;

procedure TfrmRProc.FormCreate(Sender: TObject);
var
  cfgFile: string;
  iniOpts: TIniFile;
begin
  cfgFile := GetAppConfigFile(False);
  iniOpts := TIniFile.Create(cfgFile, True);

  rStream := TMemoryStream.Create;
  BytesRead := 0;

  rProcess := TProcess.Create(nil);

  rCommand:='invalid command, please fix the IFDEFS.';
  {$IFDEF Windows}
  rCommand:='cmd.exe /c "dir /s c:\windows\"';
  {$ENDIF Windows}
  {$IFDEF Unix}
  rCommand := iniOpts.ReadString('ProgramPaths','R','');
  {$ENDIF Unix}
  iniOpts.Free;

  memR.Lines.Add('-- Going to run: ' + rCommand);
  rProcess.Executable := rCommand;
  rprocess.Parameters.Add('--no-save');

  rProcess.Options := [poUsePipes];
  memR.Lines.Add('-- External program run started');
  //rProcess.Active := True;
  rProcess.Execute;

  timIdle.Enabled := True;

  RSend('library(xpose4)');
  RSend('library(ggplot2)');
end;

procedure TfrmRProc.timIdleTimer(Sender: TObject);
var
  NoMoreOutput: boolean;

  procedure DoStuffForProcess(Process: TProcess;
    memR: TSynMemo);
  var
    Buffer: string;
    BytesAvailable: DWord;
    BytesRead:LongInt;
  begin
    if rProcess.Running then
    begin
      BytesAvailable := rProcess.Output.NumBytesAvailable;
      BytesRead := 0;
      while BytesAvailable>0 do
      begin
        SetLength(Buffer, BytesAvailable);
        BytesRead := rProcess.OutPut.Read(Buffer[1], BytesAvailable);
        memR.Text := memR.Text + copy(Buffer,1, BytesRead);
        BytesAvailable := rProcess.Output.NumBytesAvailable;
        NoMoreOutput := false;
      end;
      if BytesRead>0 then
        memR.SelStart := Length(memR.Text);
    end;
  end;
begin
  repeat
    NoMoreOutput := true;
    DoStuffForProcess(rProcess, memR);
  until noMoreOutput;
end;

end.




