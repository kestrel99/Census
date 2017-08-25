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

unit importfolder;

{$mode delphi}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ShellCtrls,
  ComCtrls, StdCtrls, CheckLst;

type

  { TfrmImportFolder }

  TfrmImportFolder = class(TForm)
    btnImport: TButton;
    btnCancel: TButton;
    btnAll: TButton;
    btnNone: TButton;
    chkWarn: TCheckBox;
    clbFiles: TCheckListBox;
    GroupBox1: TGroupBox;
    grpFiles: TGroupBox;
    stvDir: TShellTreeView;
    procedure btnAllClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnImportClick(Sender: TObject);
    procedure btnNoneClick(Sender: TObject);
    procedure dlgDirClose(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GetFiles(DirStr: string; filelist: TStrings; rec: Boolean);
    procedure FindFiles(FilesList: TStrings; StartDir, FileMask: string);
    Procedure ShellTreeViewSetTextPath(STV:TShelltreeview; Path:String);
    procedure stvDirChange(Sender: TObject; Node: TTreeNode);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  frmImportFolder: TfrmImportFolder;
  rNode: TTreeNode;

const
  {$ifdef windows}
  strOS = 'Windows';
  strDelim = '\'
  {$endif}
  {$ifdef unix}
  strOS = 'Linux';
  strDelim = '/'
  {$endif};

implementation

uses main, progress, failedimport;

{$R *.lfm}

{ TfrmImportFolder }


procedure TfrmImportFolder.FormShow(Sender: TObject);
begin
  ShellTreeViewSetTextPath(stvDir, ExtractFilePath(frmMain.zConn.Database));
end;

Procedure TfrmImportFolder.ShellTreeViewSetTextPath(STV:TShelltreeview; Path:String);
Var
  Str: TStringList;
  ANode: TTreeNode;
  i: integer;
  strE: string;
Begin
  If Not DirectoryExistsUTF8(Path) Then
  begin
    //ShowMessage('Folder not found');
    Exit;
  end;

  Str := TStringList.Create;
  Str.Delimiter := strDelim;
  Str.DelimitedText := StringReplace(Path, ' ', 'ç£', [rfReplaceAll]);

  For i := Str.Count - 1 Downto 0 Do
    If Str[i]='' Then
      Str.Delete(i);

  {$ifdef unix}
    Str.Insert(0, '/');
  {$endif}

  //showmessage(str.Text);

  {$ifdef windows}
    Str[0] := Str[0] + strDelim;
  {$endif}

  STV.BeginUpdate;
  ANode := STV.TopItem;

  For i := 0 To Str.Count - 1 Do
    Begin
      strE := StringReplace(str[i], 'ç£', ' ', [rfReplaceAll]);
      //showmessage(strE);
      While (ANode <> Nil) And (ANode.Text <> strE) Do
        Begin
          //ShowMessage(Anode.Text);
          ANode := ANode.GetNextSibling;
        End;
      If Anode<>Nil Then
        Begin
          Anode.Expanded := True;
          ANode.Selected := True;
          Anode := ANode.GetFirstChild;
        End
      Else
       begin
         str.free;
         STV.EndUpdate;
         Exit;
       end;
    End;
  str.free;
  STV.EndUpdate;
End;

procedure TfrmImportFolder.stvDirChange(Sender: TObject; Node: TTreeNode);
var
  n: Integer;
  lstFiles: TStrings;
begin
  lstFiles := TStringList.Create;
  stvDir.GetFilesInDir(stvDir.GetSelectedNodePath(), '*.xml', [otNonFolders], lstFiles, fstAlphabet);
  //GetFiles(stvDir.GetSelectedNodePath() + strDelim + '*.xml', lstFiles, False);
  clbFiles.Clear;
  for n := 0 to lstFiles.Count - 1 do
  begin
    clbFiles.Items.Add(ExtractFileName(lstFiles[n]));
    clbFiles.Checked[n] := True;
  end;

  //ShowMessage(lstFiles.Text);
  //FindFiles(lstFiles, dlgDir.FileName, '*.xml');
  if lstFiles.Count = 0 then
  begin
    //MessageDlg('No suitable XML output files found in this directory.', mtInformation,
    //  [mbOK], 0);
    Exit;
  end;
end;

procedure TfrmImportFolder.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmImportFolder.btnImportClick(Sender: TObject);
var
  n, intItems: Integer;
  lstFailed: TStringList;
begin
  try
    if not Assigned(frmProgress) then
      frmProgress := TfrmProgress.Create(Application);
    frmProgress.Show;
    frmProgress.Tag := 0;

    frmProgress.Caption := 'Importing runs...';

    lstFailed := TStringList.Create;

    intItems := 0;
    frmProgress.prgImport.Position := 0;
    for n := 0 to clbFiles.Count - 1 do
      if clbFiles.Checked[n] then
        intItems := intItems + 1;

    frmProgress.prgImport.Max := intItems;

    for n := 0 to clbFiles.Count - 1 do
    begin
      if clbFiles.Checked[n] then
      begin
        frmProgress.pnlImport.Caption := clbFiles.Items[n];
        frmProgress.Refresh;
        Application.ProcessMessages;
        //Showmessage(stvDir.GetSelectedNodePath());
        try
          frmMain.CaptureRunXML(stvDir.GetSelectedNodePath() + strDelim + clbFiles.Items[n], chkWarn.Checked);
        except
          lstFailed.Add(clbFiles.Items[n]);
        end;
        frmProgress.prgImport.Position := frmProgress.prgImport.Position + 1;
        frmProgress.Refresh;
        Application.ProcessMessages;
        // interrupt
        if frmProgress.Tag = 1 then
        begin
          MessageDlg('Import operation interrupted...', mtInformation, [mbOK], 0);
          Exit;
        end;
      end;
    end;

  finally
    frmProgress.Close;

    if lstFailed.Count > 0 then
    begin
      if not Assigned(frmFailImports) then
        frmFailImports := TfrmFailImports.Create(Application);
      frmFailImports.Memo1.Lines.Assign(lstFailed);
      frmFailImports.ShowModal;
    end;
    lstFailed.Free;
    Close;
  end;
end;

procedure TfrmImportFolder.btnNoneClick(Sender: TObject);
var
  n: Integer;
begin
  for n := 0 to clbFiles.Items.Count - 1 do
    begin
      clbFiles.Checked[n] := False;
    end;
end;

procedure TfrmImportFolder.dlgDirClose(Sender: TObject);
begin

end;

procedure TfrmImportFolder.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  CloseAction := caFree;
  frmImportFolder := nil;
end;

procedure TfrmImportFolder.FormCreate(Sender: TObject);
begin

end;


procedure TfrmImportFolder.btnAllClick(Sender: TObject);
var
  n: Integer;
begin
  for n := 0 to clbFiles.Items.Count - 1 do
    begin
      clbFiles.Checked[n] := True;
    end;
end;

procedure TfrmImportFolder.GetFiles(DirStr: string; filelist: TStrings; rec: Boolean);
var
  DirInfo: TSearchRec;
  r: Integer;
  pattern: string;
  blnRecurse: Boolean;
  //aNode, rNode: TTreeNode;
begin
  pattern := ExtractFileName(DirStr);
  if Pos('*', pattern) > 0 then
    DirStr := ExtractFilePath(DirStr)
  else
    pattern := '*.*';
  if DirStr[Length(DirStr)] <> strDelim then
    DirStr := DirStr + strDelim;
  if SetCurrentDir((DirStr)) then
  begin
    //rNode := tvDir.Items.Add(nil, DirStr);
    r := FindFirst(pattern, FaAnyfile, DirInfo);
    while r = 0 do
    begin
      if (DirInfo.Attr and faDirectory) = 0 then
      begin
        filelist.Add(DirStr + DirInfo.Name);
        //aNode := tvDir.Items.AddChild(rNode, DirInfo.Name);
      end;
      r := FindNext(DirInfo);
    end;
    FindClose(DirInfo);
    if rec then
    begin
      r := FindFirst('*.*', FaAnyfile, DirInfo);
      while r = 0 do
      begin
        if (DirInfo.Attr and faDirectory) <> 0 then
          if (DirInfo.Name <> '.') and (DirInfo.Name <> '..') then
          begin
            //aNode := tvDir.Items.AddChild(rNode, DirStr + DirInfo.Name + strDelim);
            GetFiles(DirStr + DirInfo.Name + strDelim + '*.xml', filelist, True);
          end;
        r := FindNext(DirInfo);
      end;
    end;
    FindClose(DirInfo);
  end;

end;

procedure TfrmImportFolder.FindFiles(FilesList: TStrings; StartDir, FileMask: string);
var
  SR: TSearchRec;
  DirList: TStringList;
  IsFound: Boolean;
  i: integer;
  aNode: TTreeNode;
begin
{  if StartDir[length(StartDir)] <> strDelim then
    StartDir := StartDir + strDelim;         }

  { Build a list of the files in directory StartDir
     (not the directories!)                         }
{
  IsFound :=
    FindFirst(StartDir + FileMask, faAnyFile-faDirectory, SR) = 0;
  while IsFound do
  begin
    FilesList.Add(StartDir + SR.Name);
    aNode := tvDir.Items.AddChild(rNode, SR.Name);
    IsFound := FindNext(SR) = 0;
  end;
  FindClose(SR);

  // Build a list of subdirectories
  DirList := TStringList.Create;
  IsFound := FindFirst(StartDir + '*.*', faAnyFile, SR) = 0;
  while IsFound do begin
    if ((SR.Attr and faDirectory) <> 0) and
         (SR.Name[1] <> '.') then
    begin
      DirList.Add(StartDir + SR.Name);
      //aNode := tvDir.Items.AddChild(rNode, SR.Name);
    end;
    IsFound := FindNext(SR) = 0;
  end;
  FindClose(SR);

  // Scan the list of subdirectories
  for i := 0 to DirList.Count - 1 do
  begin
    rNode := tvDir.Items.AddChild(rNode, SR.Name);
    FindFiles(FilesList, DirList[i], FileMask);
  end;
  DirList.Free; }
end;


end.

