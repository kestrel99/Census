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

unit runrec;

{$mode delphi}

interface

uses
  Classes, SysUtils, FileUtil, Ipfilebroker, Forms, Controls, Graphics, math,
  Dialogs, ExtCtrls, StdCtrls, DBGrids, ComCtrls, db, ZDataset, ZConnection;

type

  { TfrmRunRec }

  TfrmRunRec = class(TForm)
    btnCancel: TButton;
    btnExport: TButton;
    chkSigDig: TCheckBox;
    chkMinimization: TCheckBox;
    chkWarnings: TCheckBox;
    chkCondNo: TCheckBox;
    chk1: TCheckBox;
    chk2: TCheckBox;
    chk3: TCheckBox;
    chk5: TCheckBox;
    chk4: TCheckBox;
    chkAll: TCheckBox;
    dsRuns: TDatasource;
    dlgSave: TSaveDialog;
    grdRunRec: TDBGrid;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    img1: TImage;
    img2: TImage;
    img3: TImage;
    img4: TImage;
    img5: TImage;
    ipProvider: TIpFileDataProvider;
    Label1: TLabel;
    pnlLatex: TPanel;
    pnlRunRec: TPanel;
    qryRuns: TZReadOnlyQuery;
    qryRunsComment: TMemoField;
    qryRunsComments: TMemoField;
    qryRunsConditionNumber: TFloatField;
    qryRunsdOFV: TFloatField;
    qryRunsFnEvals: TLongintField;
    qryRunsiRunNo: TLongintField;
    qryRunsKeyRun: TLongintField;
    qryRunsMinShort: TMemoField;
    qryRunsOFV: TFloatField;
    qryRunsParentNo: TMemoField;
    qryRunsRunNo: TMemoField;
    qryRunsSigDigits: TFloatField;
    qryRunsWarnings: TMemoField;
    rgOutput: TRadioGroup;
    stBar: TStatusBar;
    procedure FormCreate(Sender: TObject);
    procedure rgOutputClick(Sender: TObject);
    function Round2(const Number: extended; const Places: longint): extended;
    procedure btnCancelClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure chk1Change(Sender: TObject);
    procedure chk2Change(Sender: TObject);
    procedure chk3Change(Sender: TObject);
    procedure chk4Change(Sender: TObject);
    procedure chk5Change(Sender: TObject);
    procedure chkAllChange(Sender: TObject);
    procedure chkCondNoChange(Sender: TObject);
    procedure chkMinimizationChange(Sender: TObject);
    procedure chkSigDigChange(Sender: TObject);
    procedure chkWarningsChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure qryRunsCommentGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsCommentsGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsConditionNumberGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsdOFVGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsFnEvalsGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsMinShortGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsOFVGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsParentNoGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsRunNoGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsSigDigitsGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsWarningsGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure UpdateRunRec;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmRunRec: TfrmRunRec;

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

uses main;

{$R *.lfm}

{ TfrmRunRec }

function TfrmRunRec.Round2(const Number: extended; const Places: longint): extended;
var
  t: extended;
begin
   t := power(10, places);
   Round2 := round(Number*t)/t;
end;

procedure TfrmRunRec.rgOutputClick(Sender: TObject);
begin
  if rgOutput.ItemIndex = 2 then
    pnlLatex.Visible := True
  else
    pnlLatex.Visible := False;
end;

procedure TfrmRunRec.FormCreate(Sender: TObject);
begin
  {$ifdef windows}
  Label1.Font.Size := 0;
  Label1.Height := 112;
  pnlLatex.Height := 128;
  {$endif}
  {$ifdef darwin}
  Label1.Font.Size := -11;
  Label1.Height := 96;
  pnlLatex.Height := 120;
  {$endif}
end;

procedure TfrmRunRec.chk1Change(Sender: TObject);
begin
  UpdateRunRec;
end;

procedure TfrmRunRec.btnCancelClick(Sender: TObject);
begin
  qryRuns.Active := False;
  Close;
end;

procedure TfrmRunRec.btnExportClick(Sender: TObject);
var
  strOut, txtUser: string;
  lstOut: TStringList;
  n, m, p: Integer;
begin
  lstOut := TStringList.Create;
  strOut := '';

  if strOS = 'Linux' then
    txtUser := GetEnvironmentVariable('USER');
  if strOS = 'Windows' then
    txtUser := GetEnvironmentVariable('USERNAME');

  // CSV
  if rgOutput.ItemIndex = 0 then
  begin
    dlgSave.Filter := 'Comma-separated values (*.csv)|*.csv';
    dlgSave.Title := 'Export to CSV...';
    dlgSave.DefaultExt := '.csv';
    try
      qryRuns.First;
      if dlgSave.Execute then
        begin
          strOut := '"Run No"' + DefaultFormatSettings.ListSeparator +
                    '"Comment"' + DefaultFormatSettings.ListSeparator +
                    '"OFV"' + DefaultFormatSettings.ListSeparator +
                    '"dOFV"' + DefaultFormatSettings.ListSeparator +
                    '"Parent"';
          if chkMinimization.Checked then
            strOut := strOut + DefaultFormatSettings.ListSeparator + '"Minimization"';
          if chkWarnings.Checked then
            strOut := strOut + DefaultFormatSettings.ListSeparator + '"Warnings"';
          if chkCondNo.Checked then
            strOut := strOut + DefaultFormatSettings.ListSeparator + '"Condition No"';
          if chkSigDig.Checked then
            strOut := strOut + DefaultFormatSettings.ListSeparator + '"Sig Digits"';
          lstOut.Add(strOut);

          while not qryRuns.EOF do
          begin
            strOut := '"' + qryRuns.FieldByName('RunNo').asString    + '"' + DefaultFormatSettings.ListSeparator + '"' +
                            qryRuns.FieldByName('Comment').AsString  + '"' + DefaultFormatSettings.ListSeparator + '"' +
                            qryRuns.FieldByName('OFV').asString      + '"' + DefaultFormatSettings.ListSeparator + '"' +
                            qryRuns.FieldByName('dOFV').asString     + '"' + DefaultFormatSettings.ListSeparator + '"' +
                            qryRuns.FieldByName('ParentNo').asString + '"';
            if chkMinimization.Checked then
              strOut := strOut + DefaultFormatSettings.ListSeparator + '"' + qryRuns.FieldByName('MinShort').asString + '"';
            if chkWarnings.Checked then
              strOut := strOut + DefaultFormatSettings.ListSeparator + '"' + qryRuns.FieldByName('Warnings').asString + '"';
            if chkCondNo.Checked then
              strOut := strOut + DefaultFormatSettings.ListSeparator + '"' + qryRuns.FieldByName('ConditionNumber').asString + '"';
            if chkSigDig.Checked then
              strOut := strOut + DefaultFormatSettings.ListSeparator + '"' + qryRuns.FieldByName('SigDigits').asString + '"';
            lstOut.Add(strOut);
            qryRuns.Next;
          end;
          lstOut.SaveToFile(dlgSave.FileName);
        end;
    finally
      qryRuns.First;
    end;
  end;

  // HTML
  if rgOutput.ItemIndex = 1 then
  begin
    dlgSave.Filter := 'HTML files (*.html)|*.html';
    dlgSave.Title := 'Export to HTML...';
    dlgSave.DefaultExt := '.html';

    with lstOut do
    begin
      Add('<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">');
      Add('<HTML>');
      Add('<HEAD>');
      Add('<META HTTP-EQUIV="CONTENT-TYPE" CONTENT="text/html; charset=utf-8">');
      Add('<TITLE></TITLE>');
      Add('<META NAME="GENERATOR" CONTENT="Census 2.0">');
      Add('<META NAME="AUTHOR" CONTENT="' + txtUser + '">');
      Add('<META NAME="CREATED" CONTENT="' + IntToStr(Trunc((Now - EncodeDate(1970, 1 ,1)) * 24 * 60 * 60)) + '">');
      Add('<STYLE TYPE="text/css">');
      Add('    <!--');
      Add('        @page { margin: 0.79in }');
      Add('        P { margin-bottom: 0.08in }');
      Add('        TD P { margin-bottom: 0in }');
      Add('        TH P { margin-bottom: 0in }');
      Add('    --> ');
      Add('</STYLE>');
      Add('</HEAD>');
      Add('<BODY LANG="en" DIR="LTR"> ');
      Add('<TABLE WIDTH=100% BORDER=2 BORDERCOLOR="#000000" CELLPADDING=2 CELLSPACING=0 FRAME=HSIDES RULES=GROUPS>');

      p := 5;
      if chkMinimization.Checked then
        p := p + 1;
      if chkWarnings.Checked then
        p := p + 1;
      if chkSigDig.Checked then
        p := p + 1;
      if chkCondNo.Checked then
        p := p + 1;

      for n := 1 to p do
        Add('  <COL />');

      Add('<TBODY>');
      Add('    <TR VALIGN=TOP>');

      for n := 1 to 5 do
      begin
        Add('    <TH WIDTH=' + IntToStr(Round((1/ p) * 100)) + ' %>');
        case n of
          1: Add('    <P ALIGN=LEFT>Run No</P>');
          2: Add('    <P ALIGN=LEFT>Comment</P>');
          3: Add('    <P ALIGN=LEFT>OFV</P>');
          4: Add('    <P ALIGN=LEFT>dOFV</P>');
          5: Add('    <P ALIGN=LEFT>Parent</P>');
        end;
        Add('    </TH>');
      end;
      if chkMinimization.Checked then
      begin
        Add('    <TH WIDTH=' + IntToStr(Round((1/ p) * 100)) + ' %>');
        Add('    <P ALIGN=LEFT>Minimization</P>');
        Add('    </TH>');
      end;
      if chkWarnings.Checked then
      begin
        Add('    <TH WIDTH=' + IntToStr(Round((1/ p) * 100)) + ' %>');
        Add('    <P ALIGN=LEFT>Warnings</P>');
        Add('    </TH>');
      end;
      if chkSigDig.Checked then
      begin
        Add('    <TH WIDTH=' + IntToStr(Round((1/ p) * 100)) + ' %>');
        Add('    <P ALIGN=LEFT>Sig Digits</P>');
        Add('    </TH>');
      end;
      if chkCondNo.Checked then
      begin
        Add('    <TH WIDTH=' + IntToStr(Round((1/ p) * 100)) + ' %>');
        Add('    <P ALIGN=LEFT>Cond No</P>');
        Add('    </TH>');
      end;
      Add('    </TR>');
      Add('</TBODY>');

      Add('<TBODY>');
    end;

    try
      qryRuns.First;
      if dlgSave.Execute then
        begin

          for n := 0 to qryRuns.RecordCount - 1 do
          begin
          with lstOut do
            begin
              Add('    <TR VALIGN=TOP>');

              for m := 1 to 5 do
                begin
                  case m of
                    1: begin
                         Add('    <TD WIDTH=' + IntToStr(Round((1/p) * 100)) + '% SDVAL="' + qryRuns.FieldByName('RunNo').AsString + '" SDNUM="9;">');
                         Add('        <P ALIGN=LEFT>' + qryRuns.FieldByName('RunNo').AsString + '</P> ');
                         Add('    </TD>');
                       end;
                    2: begin
                         Add('    <TD WIDTH=' + IntToStr(Round((1/p) * 100)) + '% SDVAL="' + qryRuns.FieldByName('Comment').AsString + '" SDNUM="9;">');
                         Add('        <P ALIGN=LEFT>' + qryRuns.FieldByName('Comment').AsString + '</P> ');
                         Add('    </TD>');
                       end;
                    3: begin
                         Add('    <TD WIDTH=' + IntToStr(Round((1/p) * 100)) + '% SDVAL="' + qryRuns.FieldByName('OFV').AsString + '" SDNUM="9;">');
                         Add('        <P ALIGN=LEFT>' + FloatToStrF(qryRuns.FieldByName('OFV').AsFloat, ffGeneral, 8, 4) + '</P> ');
                         Add('    </TD>');
                       end;
                    4: begin
                         Add('    <TD WIDTH=' + IntToStr(Round((1/p) * 100)) + '% SDVAL="' + qryRuns.FieldByName('dOFV').AsString + '" SDNUM="9;">');
                         Add('        <P ALIGN=LEFT>' + qryRuns.FieldByName('dOFV').AsString + '</P> ');
                         Add('    </TD>');
                       end;
                    5: begin
                         Add('    <TD WIDTH=' + IntToStr(Round((1/p) * 100)) + '% SDVAL="' + qryRuns.FieldByName('ParentNo').AsString + '" SDNUM="9;">');
                         Add('        <P ALIGN=LEFT>' + qryRuns.FieldByName('ParentNo').AsString + '</P> ');
                         Add('    </TD>');
                       end;
                  end;
                end;

              if chkMinimization.Checked then
              begin
                Add('    <TD WIDTH=' + IntToStr(Round((1/p) * 100)) + '% SDVAL="' + qryRuns.FieldByName('MinShort').AsString + '" SDNUM="9;">');
                Add('        <P ALIGN=LEFT>' + qryRuns.FieldByName('MinShort').AsString + '</P> ');
                Add('    </TD>');
              end;
              if chkWarnings.Checked then
              begin
                Add('    <TD WIDTH=' + IntToStr(Round((1/p) * 100)) + '% SDVAL="' + qryRuns.FieldByName('Warnings').AsString + '" SDNUM="9;">');
                Add('        <P ALIGN=LEFT>' + qryRuns.FieldByName('Warnings').AsString + '</P> ');
                Add('    </TD>');
              end;
              if chkSigDig.Checked then
              begin
                Add('    <TD WIDTH=' + IntToStr(Round((1/p) * 100)) + '% SDVAL="' + qryRuns.FieldByName('SigDigits').AsString + '" SDNUM="9;">');
                Add('        <P ALIGN=LEFT>' + qryRuns.FieldByName('SigDigits').AsString + '</P> ');
                Add('    </TD>');
              end;
              if chkCondNo.Checked then
              begin
                Add('    <TD WIDTH=' + IntToStr(Round((1/p) * 100)) + '% SDVAL="' + qryRuns.FieldByName('ConditionNumber').AsString + '" SDNUM="9;">');
                Add('        <P ALIGN=LEFT>' + FloatToStr(Round2(qryRuns.FieldByName('ConditionNumber').AsFloat, 2))  + '</P> ');
                Add('    </TD>');
              end;

              Add('    </TR>');
              qryRuns.Next;
            end;
          end;

          lstOut.Add('</TBODY>');
          lstOut.Add('</TABLE>');
          lstOut.Add('<P STYLE="margin-bottom: 0in"><BR>');
          lstOut.Add('</P>');
          lstOut.Add('</BODY>');
          lstOut.Add('</HTML>');

          lstOut.SaveToFile(dlgSave.FileName);

        end;

    finally
      qryRuns.First;
    end;

  end;

  // LaTeX
  if rgOutput.ItemIndex = 2 then
  begin
    dlgSave.Filter := 'LaTeX files (*.tex)|*.tex';
    dlgSave.Title := 'Export to LaTeX...';
    dlgSave.DefaultExt := '.tex';

    with lstOut do
    begin
      Add('\documentclass[12pt]{article}');
      Add('\usepackage{ctable}');
      Add('\usepackage{relsize}');
      Add('\begin{document}');
      Add('');
      Add('\ctable[');
      Add('	pos=H,');
      Add('	doinside=\smaller,');
      Add('	label   = tab:censusrunrecord,');
      Add('	width=\textwidth,');
      Add('	caption = Summary of key runs.');
    end;

    strOut := ']{l>{\raggedright}p{4cm}lll';

    p := 5;
    if chkMinimization.Checked then
    begin
      p := p + 1;
      strOut := strOut + 'l';
    end;
    if chkWarnings.Checked then
    begin
      p := p + 1;
      strOut := strOut + '>{\raggedright}p{4cm}'
    end;
    if chkSigDig.Checked then
    begin
      p := p + 1;
      strOut := strOut + 'l';
    end;
    if chkCondNo.Checked then
    begin
      p := p + 1;
      strOut := strOut + 'l';
    end;

    strOut := strOut + '}{';

    //footnotes
    strOut := strOut + '\tnote[a]{Objective function value}';
    strOut := strOut + '\tnote[b]{Change in objective function value}';

    strOut := strOut + '}{ ';
    lstOut.Add(strOut);
    lstOut.Add('\FL');
    strOut := '';

    for n := 1 to 5 do
      begin
        case n of
          1: strOut := strOut + '\textbf{Run No}';
          2: strOut := strOut + '\textbf{Comment}';
          3: strOut := strOut + '\textbf{OFV}\tmark[a]';
          4: strOut := strOut + '\textbf{$\Delta$OFV}\tmark[b]';
          5: strOut := strOut + '\textbf{Parent}';
        end;
        if n < 5 then
          strOut := strOut + ' & ';
      end;

    if chkMinimization.Checked then
      strOut := strOut + ' & \textbf{Minimization}';
    if chkWarnings.Checked then
      strOut := strOut + ' & \textbf{Warnings}';
    if chkSigDig.Checked then
      strOut := strOut + ' & \textbf{Sig Digits}';
    if chkCondNo.Checked then
      strOut := strOut + ' & \textbf{Condition No}';

    lstOut.Add(strOut);
    lstOut.Add('\ML');

    strOut := '';

    if dlgSave.Execute then
    begin
    try
      for n := 0 to qryRuns.RecordCount - 1 do
      begin
         for m := 1 to 5 do
         begin
           case m of
             1: strOut := strOut + qryRuns.FieldByName('RunNo').AsString;
             2: strOut := strOut + qryRuns.FieldByName('Comment').AsString;
             3: strOut := strOut + FloatToStrF(qryRuns.FieldByName('OFV').AsFloat, ffGeneral, 8, 4);
             4: strOut := strOut + qryRuns.FieldByName('dOFV').AsString;
             5: strOut := strOut + qryRuns.FieldByName('ParentNo').AsString;
           end;
           if m < 5 then
             strOut := strOut + ' & ';
         end;

        if chkMinimization.Checked then
          strOut := strOut + ' & ' + qryRuns.FieldByName('MinShort').AsString;
        if chkWarnings.Checked then
          strOut := strOut + ' & ' + qryRuns.FieldByName('Warnings').AsString;
        if chkSigDig.Checked then
          strOut := strOut + ' & ' + qryRuns.FieldByName('SigDigits').AsString;
        if chkCondNo.Checked then
          strOut := strOut + ' & ' + FloatToStr(Round2(qryRuns.FieldByName('ConditionNumber').AsFloat, 2));

        if n < qryRuns.RecordCount - 1 then
          strOut := strOut + '\NN'
        else
          strOut := strOut + '\LL';

        lstOut.Add(strOut);
        strOut := '';
        qryRuns.Next;

      end;
      finally
        lstOut.Add('}');
        lstOut.Add('\end{document}');
        qryRuns.First;
        lstOut.SaveToFile(dlgSave.FileName);
      end;
    end;
  end;

  lstOut.Free;
end;

procedure TfrmRunRec.chk2Change(Sender: TObject);
begin
  UpdateRunRec;
end;

procedure TfrmRunRec.chk3Change(Sender: TObject);
begin
  UpdateRunRec;
end;

procedure TfrmRunRec.chk4Change(Sender: TObject);
begin
  UpdateRunRec;
end;

procedure TfrmRunRec.chk5Change(Sender: TObject);
begin
  UpdateRunRec;
end;

procedure TfrmRunRec.chkAllChange(Sender: TObject);
begin
  if chkAll.Checked then
  begin
    chk1.Enabled := False;
    chk2.Enabled := False;
    chk3.Enabled := False;
    chk4.Enabled := False;
    chk5.Enabled := False;
  end
  else
  begin
    chk1.Enabled := True;
    chk2.Enabled := True;
    chk3.Enabled := True;
    chk4.Enabled := True;
    chk5.Enabled := True;
  end;
  UpdateRunRec;
end;

procedure TfrmRunRec.chkCondNoChange(Sender: TObject);
begin
  UpdateRunRec;
end;

procedure TfrmRunRec.chkMinimizationChange(Sender: TObject);
begin
  UpdateRunRec;
end;

procedure TfrmRunRec.chkSigDigChange(Sender: TObject);
begin
  UpdateRunRec;
end;

procedure TfrmRunRec.chkWarningsChange(Sender: TObject);
begin
  UpdateRunRec;
end;

procedure TfrmRunRec.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction := caFree;
  frmRunRec := nil;
end;

procedure TfrmRunRec.qryRunsCommentGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunsComment.AsString, 1, 250);
end;

procedure TfrmRunRec.qryRunsCommentsGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunsComments.AsString, 1, 250);
end;

procedure TfrmRunRec.qryRunsConditionNumberGetText(Sender: TField;
  var aText: string; DisplayText: Boolean);
begin
  aText := FloatToStrF(qryRunsOFV.Value, ffGeneral, 8, 4);
end;

procedure TfrmRunRec.qryRunsdOFVGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunsdOFV.AsString, 1, 50);
end;

procedure TfrmRunRec.qryRunsFnEvalsGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunsFnEvals.AsString, 1, 50);
end;

procedure TfrmRunRec.qryRunsMinShortGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunsMinShort.AsString, 1, 250);
end;

procedure TfrmRunRec.qryRunsOFVGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := FloatToStrF(qryRunsOFV.Value, ffGeneral, 8, 4);
end;

procedure TfrmRunRec.qryRunsParentNoGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunsParentNo.AsString, 1, 50);
end;

procedure TfrmRunRec.qryRunsRunNoGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunsRunNo.AsString, 1, 50);
end;

procedure TfrmRunRec.qryRunsSigDigitsGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunsSigDigits.AsString, 1, 50);
end;

procedure TfrmRunRec.qryRunsWarningsGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunsWarnings.AsString, 1, 250);
end;

procedure TfrmRunRec.UpdateRunRec;
var
  strIn: string;
begin
  strIn := '';
  if chk1.Checked then
    strIn := strIn + '1,';
  if chk2.Checked then
    strIn := strIn + '2,';
  if chk3.Checked then
    strIn := strIn + '3,';
  if chk4.Checked then
    strIn := strIn + '4,';
  if chk5.Checked then
    strIn := strIn + '5,';

  if Length(strIn) > 0 then
    strIn := Copy(strIn, 1, Length(strIn)-1);   // drop trailing comma

  //ShowMessage(strIn);
  // fields
  if chkWarnings.Checked then
    grdRunRec.Columns.Items[6].Width := 250
  else
    grdRunRec.Columns.Items[6].Width := 0;

  if chkMinimization.Checked then
    grdRunRec.Columns.Items[5].Width := 150
  else
    grdRunRec.Columns.Items[5].Width := 0;

  if chkSigDig.Checked then
    grdRunRec.Columns.Items[7].Width := 96
  else
    grdRunRec.Columns.Items[7].Width := 0;

  if chkCondNo.Checked then
    grdRunRec.Columns.Items[8].Width := 96
  else
    grdRunRec.Columns.Items[8].Width := 0;
  grdRunRec.Repaint;

  if (Length(strIn) > 0) or (chkAll.Checked) then
    with qryRuns do
    begin
      Active := False;
      SQL.Clear;
      SQL.Add('SELECT RunNo, Comment, Comments, OFV, dOFV, ParentNo, Warnings, ConditionNumber, MinShort, FnEvals, SigDigits, iRunNo, KeyRun');
      SQL.Add('FROM runs');
      if (chkAll.Checked = False) and (Length(strIn) > 0) then
        SQL.Add('WHERE KeyRun IN (' + strIn + ')');
      SQL.Add('ORDER BY iRunNo;');
      Active := True;
    end
  else
    qryRuns.Active := False;

  if qryRuns.Active then
  begin
    if qryRuns.RecordCount > 0 then
      stBar.Panels[0].Text := IntToStr(qryRuns.RecordCount) + ' runs selected'
    else
      stBar.Panels[0].Text := 'No runs selected';
  end
  else
    stBar.Panels[0].Text := 'No runs selected';

end;


end.

