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

unit options;

{$mode delphi}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  StdCtrls, ExtCtrls, Spin, Grids, EditBtn, IniFiles;

type

  { TfrmOptions }

  TfrmOptions = class(TForm)
    btnDone: TButton;
    cgrImporting: TCheckGroup;
    dlgWFN: TFileNameEdit;
    dlgNONMEM: TFileNameEdit;
    fedTheta: TFloatSpinEdit;
    fedCorrLimit: TFloatSpinEdit;
    fedOmega: TFloatSpinEdit;
    fedSigma: TFloatSpinEdit;
    dlgR: TFileNameEdit;
    dlgPerl: TFileNameEdit;
    dlgPsN: TFileNameEdit;
    gbxWarnings: TGroupBox;
    GroupBox1: TGroupBox;
    gbxFilenames: TGroupBox;
    gbxR: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    pgcOptions: TPageControl;
    sedCondNoLimit: TSpinEdit;
    sedSigDig: TSpinEdit;
    sgrFilenames: TStringGrid;
    sgrFileExamples: TStringGrid;
    tabGeneral: TTabSheet;
    tabFiles: TTabSheet;
    procedure btnDoneClick(Sender: TObject);
    procedure dlgNONMEMChange(Sender: TObject);
    procedure dlgPerlChange(Sender: TObject);
    procedure dlgPsNChange(Sender: TObject);
    procedure dlgRChange(Sender: TObject);
    procedure dlgWFNChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure LoadOptions;
    procedure SaveOptions;
    procedure sgrFilenamesEditingDone(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  frmOptions: TfrmOptions;

implementation

{$R *.lfm}

{ TfrmOptions }

procedure TfrmOptions.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction := caFree;
  frmOptions := nil;
end;

procedure TfrmOptions.FormCreate(Sender: TObject);
begin
  gbxR.Visible := True;
  pgcOptions.ActivePage := tabGeneral;
  LoadOptions;
end;

procedure TfrmOptions.btnDoneClick(Sender: TObject);
begin
  try
    SaveOptions;
  finally
    Close;
  end;
end;

procedure TfrmOptions.dlgNONMEMChange(Sender: TObject);
begin
  if FileExists(dlgNONMEM.FileName) = False then
  begin
    MessageDlg('No such file exists. Please try again.', mtError, [mbOK], 0);
    dlgNONMEM.FileName := '';
  end;
end;

procedure TfrmOptions.dlgPerlChange(Sender: TObject);
begin
  if FileExists(dlgPerl.FileName) = False then
 begin
   MessageDlg('No such file exists. Please try again.', mtError, [mbOK], 0);
   dlgPerl.FileName := '';
 end;
end;

procedure TfrmOptions.dlgPsNChange(Sender: TObject);
begin
    if FileExists(dlgPsN.FileName) = False then
  begin
    MessageDlg('No such file exists. Please try again.', mtError, [mbOK], 0);
    dlgPsN.FileName := '';
  end;
end;

procedure TfrmOptions.dlgRChange(Sender: TObject);
begin
   if FileExists(dlgR.FileName) = False then
  begin
    MessageDlg('No such file exists. Please try again.', mtError, [mbOK], 0);
    dlgR.FileName := '';
  end;
end;

procedure TfrmOptions.dlgWFNChange(Sender: TObject);
begin
    if FileExists(dlgWFN.FileName) = False then
  begin
    MessageDlg('No such file exists. Please try again.', mtError, [mbOK], 0);
    dlgWFN.FileName := '';
  end;
end;

procedure TfrmOptions.LoadOptions;
var
  cfgFile: string;
  iniOpts: TIniFile;
begin
  cfgFile := GetAppConfigFile(False);
  //iniOpts := TIniFile.Create(cfgFile, True);
  //if (DirectoryExists(ExtractFilePath(cfgFile)) = False) then
  try
    CreateDir(ExtractFilePath(cfgFile));
  except
    MessageDlg('Unable to create the folder for the Census configuration file (' +
      ExtractFilePath(cfgFile) + '). Please create it manually and try again.',
      mtWarning, [mbOK], 0);
    Close;
  end;
  iniOpts := TIniFile.Create(cfgFile, True);
  try
    cgrImporting.Checked[0] := iniOpts.ReadBool('Importing','NonNumericRunConfirm',False);
    cgrImporting.Checked[1] := iniOpts.ReadBool('Importing','CaptureMD5',True);

    fedCorrLimit.Value := iniOpts.ReadFloat('Warnings','CorrelationLimit',0.9);
    sedCondNoLimit.Value := iniOpts.ReadInteger('Warnings','ConditionNumberLimit',1000);
    sedSigDig.Value := iniOpts.ReadInteger('Display','SignificantDigits',4);

    fedTheta.Value := iniOpts.ReadFloat('Warnings','ThetaRSE',0.3);
    fedOmega.Value := iniOpts.ReadFloat('Warnings','OmegaRSE',0.5);
    fedSigma.Value := iniOpts.ReadFloat('Warnings','SigmaRSE',0.3);

    sgrFilenames.Cells[1,0] := iniOpts.ReadString('Filenames','ControlStreamExt','.mod');
    sgrFilenames.Cells[1,1] := iniOpts.ReadString('Filenames','OutputFileExt','.lst');
    sgrFilenames.Cells[1,2] := iniOpts.ReadString('Filenames','RunPrefix','run');
    sgrFilenames.Cells[1,3] := iniOpts.ReadString('Filenames','TableExt','');
    sgrFilenames.Cells[1,4] := iniOpts.ReadString('Filenames','MSFExt','.msf');

    dlgR.FileName := iniOpts.ReadString('ProgramPaths','R','');
    dlgNONMEM.FileName := iniOpts.ReadString('ProgramPaths','NONMEM','');
    dlgPsN.FileName := iniOpts.ReadString('ProgramPaths','PsN','');
    dlgPerl.FileName := iniOpts.ReadString('ProgramPaths','Perl','');
    dlgWFN.FileName := iniOpts.ReadString('ProgramPaths','WFN','');
  finally
    iniOpts.Free;
  end;
end;

procedure TfrmOptions.SaveOptions;
var
  cfgFile: string;
  iniOpts: TIniFile;
begin
  cfgFile := GetAppConfigFile(False);
  iniOpts := TIniFile.Create(cfgFile, True);
  try
    iniOpts.WriteBool('Importing','NonNumericRunConfirm',cgrImporting.Checked[0]);
    iniOpts.WriteBool('Importing','CaptureMD5',cgrImporting.Checked[1]);

    iniOpts.WriteFloat('Warnings','CorrelationLimit',fedCorrLimit.Value);
    iniOpts.WriteInteger('Warnings','ConditionNumberLimit',sedCondNoLimit.Value);
    iniOpts.WriteInteger('Display','SignificantDigits',sedSigDig.Value);

    iniOpts.WriteFloat('Warnings','ThetaRSE',fedTheta.Value);
    iniOpts.WriteFloat('Warnings','OmegaRSE',fedOmega.Value);
    iniOpts.WriteFloat('Warnings','SigmaRSE',fedSigma.Value);

    iniOpts.WriteString('Filenames','ControlStreamExt',sgrFilenames.Cells[1,0]);
    iniOpts.WriteString('Filenames','OutputFileExt',sgrFilenames.Cells[1,1]);
    iniOpts.WriteString('Filenames','RunPrefix',sgrFilenames.Cells[1,2]);
    iniOpts.WriteString('Filenames','TableExt',sgrFilenames.Cells[1,3]);
    iniOpts.WriteString('Filenames','MSFExt',sgrFilenames.Cells[1,4]);

    iniOpts.WriteString('ProgramPaths','R',dlgR.FileName);
    iniOpts.WriteString('ProgramPaths','NONMEM',dlgNONMEM.FileName);
    iniOpts.WriteString('ProgramPaths','PsN',dlgPsN.FileName);
    iniOpts.WriteString('ProgramPaths','Perl',dlgPerl.FileName);
    iniOpts.WriteString('ProgramPaths','WFN',dlgWFN.FileName);
  finally
    iniOpts.Free;
  end;
end;

procedure TfrmOptions.sgrFilenamesEditingDone(Sender: TObject);
begin
  if Trim(sgrFilenames.Cells[1,3]) = '.' then
    sgrFilenames.Cells[1,3] := '';

  sgrFileExamples.Cells[0,0] := Trim(sgrFilenames.Cells[1,2]) + '42' +
    sgrFilenames.Cells[1,0];
  sgrFileExamples.Cells[0,1] := Trim(sgrFilenames.Cells[1,2]) + '42' +
    sgrFilenames.Cells[1,1];

  sgrFileExamples.Cells[0,3] := 'sdtab42' +
    sgrFilenames.Cells[1,3] + ', patab42' + sgrFilenames.Cells[1,3];
  sgrFileExamples.Cells[0,4] := Trim(sgrFilenames.Cells[1,2]) + '42' +
    sgrFilenames.Cells[1,4];
end;

end.

