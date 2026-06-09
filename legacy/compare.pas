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

unit compare;

{$mode delphi}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids,
  ExtCtrls, StdCtrls, db, ZDataset, math;

type

  { TfrmCompare }

  TfrmCompare = class(TForm)
    btnExport: TButton;
    Button1: TButton;
    grdCompare: TStringGrid;
    GroupBox1: TGroupBox;
    Panel1: TPanel;
    Panel21: TPanel;
    qrySumTh: TZReadOnlyQuery;
    qryRuns: TZReadOnlyQuery;
    dlgSave: TSaveDialog;
    qrySumOm: TZReadOnlyQuery;
    qrySumSi: TZReadOnlyQuery;
    Splitter1: TSplitter;
    procedure btnExportClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure RefreshCompare;
    function SaveToCSV: Boolean;
    function SigFig(fltIn: Double; intPrec: Integer): Double;
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  frmCompare: TfrmCompare;

implementation

uses main;

{$R *.lfm}

procedure TfrmCompare.RefreshCompare;
var
  n, m, intThetas, intEtas, intEpsilons, p: Integer;
  myCol: TGridColumn;
  myCursor: TCursor;
begin
  if frmMain.qryRuns.Active then
  begin
  // Disconnect DB tables
    try

    myCursor := Screen.Cursor;
    Screen.Cursor := crHourglass;

    //grdCompare.Visible := False;

    qrySumTh.Active := False;
    qrySumTh.SQL.Clear;
    qrySumTh.SQL.Add('SELECT MAX(Theta) as maxtheta FROM thetas;');
    qrySumTh.Active := True;

    intThetas := qrySumTh.Fields[0].AsInteger;
    //showMessage(IntToStr(intThetas));

    qrySumTh.Active := False;
    qrySumTh.SQL.Clear;
    qrySumTh.SQL.Add('SELECT MAX(Omega) as maxomega FROM omegas;');
    qrySumTh.Active := True;

    intEtas := qrySumTh.Fields[0].AsInteger;
    //showMessage(IntToStr(intEtas));

    qrySumTh.Active := False;
    qrySumTh.SQL.Clear;
    qrySumTh.SQL.Add('SELECT MAX(Sigma) as maxsigma FROM sigmas;');
    qrySumTh.Active := True;

    intEpsilons := qrySumTh.Fields[0].AsInteger;
    //showMessage(IntToStr(intEpsilons));

    qrySumTh.Active := False;

  //ShowMessage(IntToStr(intThetas));
  //ShowMessage(IntToStr(intEtas));
  //ShowMessage(IntToStr(intEpsilons));

    grdCompare.BeginUpdate;
    //grdCompare.ColCount := 8 + intThetas + intEtas + intEpsilons;

    grdCompare.FixedRows := 1;

    grdCompare.ColCount := 0;

    //myCol := grdCompare.Columns.Add;
    //myCol.Title.Caption := 'Run No';
    //myCol.Width := 64;

    myCol := grdCompare.Columns.Add;
    myCol.Title.Caption := 'Label';
    myCol.Width := 160;

    myCol := grdCompare.Columns.Add;
    myCol.Title.Caption := 'OFV';
    myCol.Width := 64;

    myCol := grdCompare.Columns.Add;
    myCol.Title.Caption := 'dOFV';
    myCol.Width := 64;

    myCol := grdCompare.Columns.Add;
    myCol.Title.Caption := 'Parent';
    myCol.Width := 64;

    myCol := grdCompare.Columns.Add;
    myCol.Title.Caption := 'Cond No';
    myCol.Width := 64;

    myCol := grdCompare.Columns.Add;
    myCol.Title.Caption := 'Notes';
    myCol.Width := 160;

    myCol := grdCompare.Columns.Add;
    myCol.Title.Caption := 'Minimization';
    myCol.Width := 96;

    myCol := grdCompare.Columns.Add;
    myCol.Title.Caption := 'Warnings';
    myCol.Width := 160;

    myCol := grdCompare.Columns.Add;
    myCol.Title.Caption := 'Problem';
    myCol.Width := 160;

    myCol := grdCompare.Columns.Add;
    myCol.Title.Caption := 'Str Model';
    myCol.Width := 160;

    myCol := grdCompare.Columns.Add;
    myCol.Title.Caption := 'Cov Model';
    myCol.Width := 160;

    myCol := grdCompare.Columns.Add;
    myCol.Title.Caption := 'IIV';
    myCol.Width := 160;

    myCol := grdCompare.Columns.Add;
    myCol.Title.Caption := 'IOV';
    myCol.Width := 160;

    myCol := grdCompare.Columns.Add;
    myCol.Title.Caption := 'RV';
    myCol.Width := 160;

    myCol := grdCompare.Columns.Add;
    myCol.Title.Caption := 'Estimation';
    myCol.Width := 160;

    myCol := grdCompare.Columns.Add;
    myCol.Title.Caption := 'Description';
    myCol.Width := 160;

    for n := 1 to intThetas do
    begin
      myCol := grdCompare.Columns.Add;
      myCol.Title.Caption := 'Th ' + IntToStr(n);
      myCol.Width := 64;
    end;

    for n := 1 to intEtas do
    begin
      myCol := grdCompare.Columns.Add;
      myCol.Title.Caption := 'Om ' + IntToStr(n);
      myCol.Width := 64;
    end;

    for n := 1 to intEpsilons do
    begin
      myCol := grdCompare.Columns.Add;
      myCol.Title.Caption := 'Si ' + IntToStr(n);
      myCol.Width := 64;
    end;

    //now standard errors
    for n := 1 to intThetas do
    begin
      myCol := grdCompare.Columns.Add;
      myCol.Title.Caption := 'Th ' + IntToStr(n) + ' SE';
      myCol.Width := 64;
    end;

    for n := 1 to intEtas do
    begin
      myCol := grdCompare.Columns.Add;
      myCol.Title.Caption := 'Om ' + IntToStr(n) + ' SE';
      myCol.Width := 64;
    end;

    for n := 1 to intEpsilons do
    begin
      myCol := grdCompare.Columns.Add;
      myCol.Title.Caption := 'Si ' + IntToStr(n) + ' SE';
      myCol.Width := 64;
    end;

    grdCompare.FixedCols := 1;

    with qryRuns do
    begin
      SQL.Clear;
      SQL.Add('SELECT RunNo, Label, OFV, dOFV, ParentNo, ConditionNumber, Comments, MinShort,' +
         'Warnings, Comment, StructuralModel, CovariateModel, IIV, IOV, RV, Estimation,' +
         'Description');
      SQL.Add('FROM runs');
      SQL.Add('ORDER BY iRunNo;');
      Active := True;
    end;

    grdCompare.RowCount := qryRuns.RecordCount + 1;

    qryRuns.First;
    for n := 1 to qryRuns.RecordCount do
    begin
      with grdCompare do
      begin
        Cells[0, n] := qryRuns.FieldByName('RunNo').AsString;
        Cells[1, n] := qryRuns.FieldByName('Label').AsString;
        // if FloatToStr(qryRunsOFV.Value) <> '0' then
        Cells[2, n] := qryRuns.FieldByName('OFV').AsString;
        //if FloatToStr(qryRunsdOFV.Value) <> '0' then
        Cells[3, n] := qryRuns.FieldByName('dOFV').AsString;
        //if FloatToStr(qryRunsdOFV.Value) <> '0' then
        Cells[4, n] := qryRuns.FieldByName('ParentNo').AsString;
        //if FloatToStr(qryRunsConditionNumber.Value) <> '0' then
        Cells[5, n] := qryRuns.FieldByName('ConditionNumber').AsString;
        Cells[6, n] := qryRuns.FieldByName('Comments').AsString;
        Cells[7, n] := qryRuns.FieldByName('MinShort').AsString;
        Cells[8, n] := qryRuns.FieldByName('Warnings').AsString;

        // new fields
        Cells[9, n] := qryRuns.FieldByName('Comment').AsString;
        Cells[10, n] := qryRuns.FieldByName('StructuralModel').AsString;
        Cells[11, n] := qryRuns.FieldByName('CovariateModel').AsString;
        Cells[12, n] := qryRuns.FieldByName('IIV').AsString;
        Cells[13, n] := qryRuns.FieldByName('IOV').AsString;
        Cells[14, n] := qryRuns.FieldByName('RV').AsString;
        Cells[15, n] := qryRuns.FieldByName('Estimation').AsString;
        Cells[16, n] := qryRuns.FieldByName('Description').AsString;

        qrySumTh.Active := False;
        qrySumTh.SQL.Clear;
        qrySumTh.SQL.Add('SELECT th.Theta, th.ThetaValue, th.ThetaSE, th.ThetaRSE');
        qrySumTh.SQL.Add('FROM thetas th, ');
        qrySumTh.SQL.Add('  (SELECT max(EstNo) as maxest');
        qrySumTh.SQL.Add('   FROM thetas) maxests');
        qrySumTh.SQL.Add('WHERE RunNo = ''' + qryRuns.FieldByName('RunNo').AsString + ''' AND th.EstNo = maxests.maxest');
        qrySumTh.SQL.Add('ORDER BY Theta;');
        qrySumTh.Active := True;

        qrySumTh.First;
        p := 0;
       // ShowMessage(IntToStr(qrySumTh.RecordCount));
        for m := 17 to 17 + intThetas - 1 do
        begin
          if p < qrySumTh.RecordCount then
            if FloatToStr(qrySumTh.Fields[1].AsFloat) <> '0' then
              Cells[m, n] := FloatToStr(qrySumTh.Fields[1].AsFloat)
            else
              Cells[m, n] := ''
          else
            Cells[m, n] := '';
          p := p + 1;
          qrySumTh.Next;
        end;

        qrySumOm.SQL.Clear;
        qrySumOm.SQL.Add('SELECT om.Omega, om.OmegaValue, om.OmegaSE, om.OmegaRSE');
        qrySumOm.SQL.Add('FROM omegas om, ');
        qrySumOm.SQL.Add('  (SELECT max(EstNo) as maxest');
        qrySumOm.SQL.Add('   FROM omegas) maxests');
        qrySumOm.SQL.Add('WHERE RunNo = ''' + qryRuns.FieldByName('RunNo').AsString + ''' AND om.EstNo = maxests.maxest');
        qrySumOm.SQL.Add('ORDER BY Omega;');
        qrySumOm.Active := True;

        qrySumOm.First;
        p := 0;
        for m := 17 + intThetas to 17 + intThetas + intEtas - 1 do
        begin
          if p < qrySumOm.RecordCount then
            Cells[m, n] := FloatToStr(qrySumOm.Fields[1].AsFloat)
          else
            Cells[m, n] := '';
          p := p + 1;
          qrySumOm.Next;
        end;

        qrySumSi.SQL.Clear;
        qrySumSi.SQL.Add('SELECT si.Sigma, si.SigmaValue, si.SigmaSE, si.SigmaRSE');
        qrySumSi.SQL.Add('FROM sigmas si, ');
        qrySumSi.SQL.Add('  (SELECT max(EstNo) as maxest');
        qrySumSi.SQL.Add('   FROM sigmas) maxests');
        qrySumSi.SQL.Add('WHERE RunNo = ''' + qryRuns.FieldByName('RunNo').AsString + ''' AND si.EstNo = maxests.maxest');
        qrySumSi.SQL.Add('ORDER BY Sigma;');
        qrySumSi.Active := True;

        qrySumSi.First;
        p := 0;
        for m := 17 + intThetas + intEtas to 17 + intThetas + intEtas + intEpsilons - 1 do
        begin
          if p < qrySumSi.RecordCount then
            Cells[m, n] := FloatToStr(qrySumSi.Fields[1].AsFloat)
          else
            Cells[m, n] := '';
          p := p + 1;
          qrySumSi.Next;
        end;

        // SEs

        qrySumTh.First;
        p := 0;
        for m := 17 + intThetas + intEtas + intEpsilons to 17 + intThetas + intEtas + intEpsilons + intThetas - 1 do
        begin
          if p < qrySumTh.RecordCount then
          begin
            if FloatToStr(qrySumTh.Fields[2].AsFloat) <> '0' then
              Cells[m, n] := FloatToStr(qrySumTh.Fields[2].AsFloat)
            else
              Cells[m, n] := '';
          end
          else
            Cells[m, n] := '';
          p := p + 1;
          qrySumTh.Next;
        end;

        qrySumOm.First;
        p := 0;
        for m := 17 + intThetas + intEtas + intEpsilons + intThetas to 17 + intThetas + intEtas + intEpsilons + intThetas + intEtas - 1 do
        begin
          if p < qrySumOm.RecordCount then
          begin
            if FloatToStr(qrySumOm.Fields[2].AsFloat) <> '0' then
              Cells[m, n] := FloatToStr(qrySumOm.Fields[2].AsFloat)
            else
              Cells[m, n] := '';
          end
          else
            Cells[m, n] := '';
          p := p + 1;
          qrySumOm.Next;
        end;

        qrySumSi.First;
        p := 0;
        for m := 17 + intThetas + intEtas + intEpsilons + intThetas + intEtas to 17 + intThetas + intEtas + intEpsilons + intThetas + intEtas + intEpsilons - 1 do
        begin
          if p < qrySumSi.RecordCount then
          begin
            if FloatToStr(qrySumSi.Fields[2].AsFloat) <> '0' then
              Cells[m, n] := FloatToStr(qrySumSi.Fields[2].AsFloat)
            else
              Cells[m, n] := '';
          end
          else
            Cells[m, n] := '';
          p := p + 1;
          qrySumSi.Next;
        end;

      end;
      qryRuns.Next;
    end;

    finally

      qryRuns.Active := False;
      //grdCompare.Visible := True;
      Screen.Cursor := myCursor;
      grdCompare.Cells[0,0] := 'Run No';
      grdCompare.EndUpdate(True);
    end;
  end;

end;

procedure TfrmCompare.Button1Click(Sender: TObject);
begin
  frmCompare.Close;
end;

procedure TfrmCompare.btnExportClick(Sender: TObject);
begin
  SaveToCSV;
end;

procedure TfrmCompare.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction := caFree;
  frmCompare := nil;
end;

procedure TfrmCompare.FormShow(Sender: TObject);
begin
  RefreshCompare;
end;

// from http://www.swissdelphicenter.ch/en/showcode.php?id=1743
function TfrmCompare.SaveToCSV: Boolean;
var
  SD: TSaveDialog;
  I: Integer;
  CSV: TStrings;
  strTemp: string;
  FileName: String;
begin
  try
    if dlgSave.Execute = True then
    begin
      if FileExists(dlgSave.FileName) then
        if MessageDlg('A file with this name already exists. Would you like to overwrite it?',
          mtWarning, [mbYes, mbNo], 0) = mrNo then
          Exit;
      FileName := dlgSave.FileName;
      if Copy(FileName, Pos('.', FileName), Length(FileName) - Pos('.', FileName) + 1) <> '.csv' then
        FileName := FileName + '.csv';
      Screen.Cursor := crHourGlass;

      CSV := TStringList.Create;
      try
        for I := 0 to grdCompare.ColCount - 1 do
        begin
          if I > 0 then
            strTemp := strTemp + ',';
          strTemp := strTemp + grdCompare.Columns[I].Title.Caption;
        end;
        CSV.Add(strTemp);
        for I := 1 To grdCompare.RowCount - 1 do
          CSV.Add(grdCompare.Rows[I].CommaText);
        CSV.SaveToFile(FileName);
        Result := True;
      finally
        CSV.Free;
      end;
    end;

  finally
    SD.Free;
    Screen.Cursor := crDefault;
  end;
end;

// ********************************************************************
// significant figures function
// ********************************************************************

function TfrmCompare.SigFig(fltIn: Double; intPrec: Integer): Double;
var
  intDP: extended;
begin
  if fltIn = 0 then
    Result := 0
  else
  begin
    intDP := Int(intPrec - log10(Abs(fltIn)));
    Result := RoundTo(fltIn, Round(intDP));
  end;
end;




end.

