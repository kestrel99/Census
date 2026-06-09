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

unit edit;

{$mode delphi}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, DbCtrls,
  ExtCtrls, StdCtrls, EditBtn, db, ZDataset;

type

  { TfrmEdit }

  TfrmEdit = class(TForm)
    btnSave: TButton;
    btnCancel: TButton;
    cbxParentNo: TComboBox;
    DBMemo1: TDBMemo;
    GroupBox5: TGroupBox;
    qryEditcatab: TMemoField;
    qryEditcatabMD5: TMemoField;
    qryEditComment: TMemoField;
    qryEditComments: TMemoField;
    qryEditcotab: TMemoField;
    qryEditcotabMD5: TMemoField;
    qryEditmutab: TMemoField;
    qryEditmutabMD5: TMemoField;
    qryEditmytab: TMemoField;
    qryEditmytabMD5: TMemoField;
    qryEditOFV: TFloatField;
    qryEditParentNo: TMemoField;
    qryEditpatab: TMemoField;
    qryEditpatabMD5: TMemoField;
    qryEditRunNo: TMemoField;
    qryEditsdtab: TMemoField;
    qryEditsdtabMD5: TMemoField;
    qryCbx: TZQuery;
    srcEdit: TDatasource;
    edtPatab: TFileNameEdit;
    edtCatab: TFileNameEdit;
    edtCotab: TFileNameEdit;
    edtMytab: TFileNameEdit;
    edtMutab: TFileNameEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    edtSdtab: TFileNameEdit;
    GroupBox4: TGroupBox;
    Label1: TLabel;
    txtLabel: TDBText;
    txtRunNo: TDBText;
    GroupBox2: TGroupBox;
    GroupBox1: TGroupBox;
    GroupBox3: TGroupBox;
    qryEdit: TZQuery;
    qryEx: TZQuery;
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure qryEditcatabGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryEditcatabMD5GetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryEditCommentGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryEditCommentsGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryEditcotabGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryEditcotabMD5GetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryEditmutabGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryEditmutabMD5GetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryEditmytabGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryEditmytabMD5GetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryEditParentNoGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryEditpatabGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryEditpatabMD5GetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryEditRunNoGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryEditsdtabGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryEditsdtabMD5GetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    function SigDig(fltIn: Double; intPrec: Integer): Double;
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  frmEdit: TfrmEdit;

implementation

uses main, md5, math;

{$R *.lfm}

{ TfrmEdit }

procedure TfrmEdit.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmEdit.btnSaveClick(Sender: TObject);
var
  txtSdtab, txtPatab, txtCatab, txtCotab, txtMytab, txtMutab,
    txtSdtabMD5, txtPatabMD5, txtCatabMD5, txtCotabMD5, txtMytabMD5, txtMutabMD5: string;
  lstSQL: TStringList;
  fltdOFV: Double;
begin
  if FileExists(edtSdtab.FileName) then
  begin
    txtSdtab := edtSdtab.FileName;
    txtSdtabMD5 := LowerCase(MDPrint(MDFile(edtSdtab.FileName, MD_VERSION_5, 1024)));
  end
  else
  if (Length(edtSdtab.FileName) > 0) then
  begin
    MessageDlg('File ' + edtSdtab.FileName + ' does not exist.', mtWarning, [mbOK], 0);
    Exit;
  end
  else
  begin
    txtSdtab := 'NULL';
    txtSdtabMD5 := 'NULL';
  end;

  if FileExists(edtPatab.FileName) then
  begin
    txtPatab := edtPatab.FileName;
    txtPatabMD5 := LowerCase(MDPrint(MDFile(edtPatab.FileName, MD_VERSION_5, 1024)));
  end
  else
  if (Length(edtPatab.FileName) > 0) then
  begin
    MessageDlg('File ' + edtPatab.FileName + ' does not exist.', mtWarning, [mbOK], 0);
    Exit;
  end
  else
  begin
    txtPatab := 'NULL';
    txtPatabMD5 := 'NULL';
  end;

  if FileExists(edtCatab.FileName) then
  begin
    txtCatab := edtCatab.FileName;
    txtCatabMD5 := LowerCase(MDPrint(MDFile(edtCatab.FileName, MD_VERSION_5, 1024)));
  end
  else
  if (Length(edtCatab.FileName) > 0) then
  begin
    MessageDlg('File ' + edtCatab.FileName + ' does not exist.', mtWarning, [mbOK], 0);
    Exit;
  end
  else
  begin
    txtCatab := 'NULL';
    txtCatabMD5 := 'NULL';
  end;

  if FileExists(edtCotab.FileName) then
  begin
    txtCotab := edtCotab.FileName;
    txtCotabMD5 := LowerCase(MDPrint(MDFile(edtCotab.FileName, MD_VERSION_5, 1024)));
  end
  else
  if (Length(edtCatab.FileName) > 0) then
  begin
    MessageDlg('File ' + edtCatab.FileName + ' does not exist.', mtWarning, [mbOK], 0);
    Exit;
  end
  else
  begin
    txtCotab := 'NULL';
    txtCotabMD5 := 'NULL';
  end;

  if FileExists(edtMytab.FileName) then
  begin
    txtMytab := edtMytab.FileName;
    txtMytabMD5 := LowerCase(MDPrint(MDFile(edtMytab.FileName, MD_VERSION_5, 1024)));
  end
  else
  if (Length(edtMytab.FileName) > 0) then
  begin
    MessageDlg('File ' + edtMytab.FileName + ' does not exist.', mtWarning, [mbOK], 0);
    Exit;
  end
  else
  begin
    txtMytab := 'NULL';
    txtMytabMD5 := 'NULL';
  end;

  if FileExists(edtMutab.FileName) then
  begin
    txtMutab := edtMutab.FileName;
    txtMutabMD5 := LowerCase(MDPrint(MDFile(edtMutab.FileName, MD_VERSION_5, 1024)));
  end
  else
  if (Length(edtMutab.FileName) > 0) then
  begin
    MessageDlg('File ' + edtMutab.FileName + ' does not exist.', mtWarning, [mbOK], 0);
    Exit;
  end
  else
  begin
    txtMutab := 'NULL';
    txtMutabMD5 := 'NULL';
  end;

    // get dOFV

  //ShowMessage(cbxParentNo.Text)   ;
  if Length(cbxParentNo.Text) > 0 then
  begin
    with qryEx do
    begin
      Active := False;
      SQL.Clear;
      SQL.Add('select OFV from runs');
      SQL.Add('where RunNo = ' + QuotedStr(cbxParentNo.Text) + ';');
      Active := True;
    end;
    fltdOFV := SigDig(qryEditOFV.Value - qryEx.Fields[0].AsFloat, 4);
  end;

  //ShowMessage(FloatToStr(qryEditOFV.Value));
  //ShowMessage(FloatToStr(qryEx.Fields[0].AsFloat));
  //ShowMessage(FloatToStr(fltdOFV));

  lstSQL := TStringList.Create;
  lstSQL.Add('UPDATE runs');
  lstSQL.Add('SET ParentNo = ' + QuotedStr(cbxParentNo.Text) + ', ');
  lstSQL.Add('dOFV = ' + FloatToStr(fltdOFV) + ', ');
  lstSQL.Add('sdtab = ' + QuotedStr(txtSdtab) + ', sdtabMD5 = ' + QuotedStr(txtSdtabMD5) + ', ');
  lstSQL.Add('patab = ' + QuotedStr(txtPatab) + ', patabMD5 = ' + QuotedStr(txtPatabMD5) + ', ');
  lstSQL.Add('catab = ' + QuotedStr(txtCatab) + ', catabMD5 = ' + QuotedStr(txtCatabMD5) + ', ');
  lstSQL.Add('cotab = ' + QuotedStr(txtCotab) + ', cotabMD5 = ' + QuotedStr(txtCotabMD5) + ', ');
  lstSQL.Add('mytab = ' + QuotedStr(txtMytab) + ', mytabMD5 = ' + QuotedStr(txtMytabMD5) + ', ');
  lstSQL.Add('mutab = ' + QuotedStr(txtMutab) + ', mutabMD5 = ' + QuotedStr(txtMutabMD5));
  lstSQL.Add('WHERE RunNo = ' + QuotedStr(qryEditRunNo.Value) + ';');

  //ShowMessage(lstSQL.Text);

  try
    qryEx.SQL.Clear;
    qryEx.SQL.Assign(lstSQL);
    qryEx.ExecSQL;
  finally
    lstSQL.Free;
    Close;
  end;
end;

procedure TfrmEdit.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var
  bkMark: TBookmark;
begin
  try
    bkMark := frmMain.qryRuns.GetBookmark;
    frmMain.qryRuns.Refresh;
    frmMain.qryRuns.GotoBookmark(bkMark);
    frmMain.qryRuns.FreeBookmark(bkMark);
    frmMain.BuildTree;
  finally
    CloseAction := caFree;
    frmEdit := nil;
  end;
end;

procedure TfrmEdit.FormCreate(Sender: TObject);
var
  n: Integer;
begin

  qryCbx.SQL.Clear;
  qryCbx.SQL.Add('select RunNo');
  qryCbx.SQL.Add('from runs');
  qryCbx.SQL.Add('order by iRunNo;');

  qryEdit.SQL.Clear;
  qryEdit.SQL.Add('select RunNo,ParentNo,Comment,Comments,sdtab,patab,cotab,catab,mytab,mutab,sdtabMD5,patabMD5,cotabMD5,catabMD5,mytabMD5,mutabMD5,OFV');
  qryEdit.SQL.Add('from runs');
  qryEdit.SQL.Add('where RunNo = ' + QuotedStr(frmMain.qryRunsRunNo.Value) + ';');
  if frmMain.zConn.Connected then
  begin
    qryEdit.Active := True;
    qryCbx.Active := True;
  end
  else
    Close;

  qryCbx.First;
  for n := 0 to qryCbx.RecordCount - 1 do
  begin
    cbxParentNo.Items.Add(qryCbx.Fields[0].Value);
    qryCbx.Next;
  end;

  // populate file dialogs
  if FileExists(qryEditSdtab.Value) then
    edtSdtab.FileName := qryEditSdtab.Value;
  if FileExists(qryEditPatab.Value) then
    edtPatab.FileName := qryEditPatab.Value;
  if FileExists(qryEditCatab.Value) then
    edtCatab.FileName := qryEditCatab.Value;
  if FileExists(qryEditCotab.Value) then
    edtCotab.FileName := qryEditCotab.Value;
  if FileExists(qryEditMytab.Value) then
    edtMytab.FileName := qryEditMytab.Value;
  if FileExists(qryEditMutab.Value) then
    edtMutab.FileName := qryEditMutab.Value;

  cbxParentNo.Text := qryEditParentNo.Value;

end;

procedure TfrmEdit.qryEditcatabGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryEditcatab.AsString, 1, 5000);
end;

procedure TfrmEdit.qryEditcatabMD5GetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryEditcatabMD5.AsString, 1, 5000);
end;

procedure TfrmEdit.qryEditCommentGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryEditComment.AsString, 1, 5000);
end;

procedure TfrmEdit.qryEditCommentsGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryEditComments.AsString, 1, 5000);
end;

procedure TfrmEdit.qryEditcotabGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryEditcotab.AsString, 1, 5000);
end;

procedure TfrmEdit.qryEditcotabMD5GetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryEditcotab.AsString, 1, 5000);
end;

procedure TfrmEdit.qryEditmutabGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryEditmutab.AsString, 1, 5000);
end;

procedure TfrmEdit.qryEditmutabMD5GetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryEditmutabMD5.AsString, 1, 5000);
end;

procedure TfrmEdit.qryEditmytabGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryEditmytab.AsString, 1, 5000);
end;

procedure TfrmEdit.qryEditmytabMD5GetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryEditmytabMD5.AsString, 1, 5000);
end;

procedure TfrmEdit.qryEditParentNoGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryEditParentNo.AsString, 1, 5000);
end;

procedure TfrmEdit.qryEditpatabGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryEditpatab.AsString, 1, 5000);
end;

procedure TfrmEdit.qryEditpatabMD5GetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryEditpatabMD5.AsString, 1, 5000);
end;

procedure TfrmEdit.qryEditRunNoGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryEditRunNo.AsString, 1, 5000);
end;

procedure TfrmEdit.qryEditsdtabGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryEditsdtab.AsString, 1, 5000);
end;

procedure TfrmEdit.qryEditsdtabMD5GetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryEditsdtabMD5.AsString, 1, 5000);
end;

// ********************************************************************
// significant figures function
// ********************************************************************

function TfrmEdit.SigDig(fltIn: Double; intPrec: Integer): Double;
var
  shifted, magn: Double;
  pow, d: Integer;
begin
  if fltIn = 0 then
    Result := 0
  else
  begin
    if (fltIn < 0) then
      d := Ceil(Log10(-1 * fltIn))
    else
      d := Ceil(Log10(fltIn));
    pow := intPrec - d;
    magn := Power(10, pow);
    shifted := Round(fltIn * magn);
    Result := shifted / magn;
  end;

end;

end.

