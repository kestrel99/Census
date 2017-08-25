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

unit exportrun;

{$mode delphi}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Grids, ExtCtrls, ComCtrls, ZDataset, LR_Desgn, LR_DBSet, IpHtml, Ipfilebroker,
  math;

type

  { TfrmExportRun }

  TfrmExportRun = class(TForm)
    btnCancel: TButton;
    btnExport: TButton;
    CheckGroup1: TCheckGroup;
    dlgSave: TSaveDialog;
    htmlPanel: TIpHtmlPanel;
    ipProvider: TIpFileDataProvider;
    Label1: TLabel;
    pnlLatex: TPanel;
    qryRuns: TZReadOnlyQuery;
    qrySumOm: TZReadOnlyQuery;
    qrySumSi: TZReadOnlyQuery;
    qrySumTh: TZReadOnlyQuery;
    rgOutput: TRadioGroup;
    rgVar: TRadioGroup;
    procedure btnCancelClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure CheckGroup1ItemClick(Sender: TObject; Index: integer);
    procedure ExportRun(strType: string);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure rgOutputClick(Sender: TObject);
    function SigDig(fltIn: Double; intPrec: Integer): Double;
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  frmExportRun: TfrmExportRun;
  lstHtml, lstLaTeX: TStrings;

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

{ TfrmExportRun }

procedure TfrmExportRun.ExportRun(strType: string);
var
  myCursor: TCursor;
  n, m, intThetas, intEtas, intEpsilons, p, q: Integer;
  txtUser, txtTemp: string;
begin
  if not Assigned(lstHtml) then
    lstHtml := TStringList.Create
  else
    lstHtml.Clear;

  if strOS = 'Linux' then
    txtUser := GetEnvironmentVariable('USER');
  if strOS = 'Windows' then
    txtUser := GetEnvironmentVariable('USERNAME');

  if frmMain.qryRuns.Active then
  try

    myCursor := Screen.Cursor;
    Screen.Cursor := crHourglass;
    p := 0;

    qrySumTh.Active := False;
    qrySumTh.SQL.Clear;
    if frmMain.qryEst.RecordCount > 1 then
    begin
      qrySumTh.SQL.Add('SELECT th.Theta, th.ThetaValue, th.ThetaSE, th.ThetaRSE, th.ThetaLabel, th.ThetaCIs');
      qrySumTh.SQL.Add('FROM thetas th, ');
      qrySumTh.SQL.Add('  (SELECT max(EstNo) as maxest');
      qrySumTh.SQL.Add('   FROM thetas) maxests');
      qrySumTh.SQL.Add('WHERE RunNo = ''' + frmMain.qryRunsRunNo.Value + ''' AND th.EstNo = maxests.maxest');
      qrySumTh.SQL.Add('ORDER BY Theta;');
    end
    else
    begin
      qrySumTh.SQL.Add('SELECT th.Theta, th.ThetaValue, th.ThetaSE, th.ThetaRSE, th.ThetaLabel, th.ThetaCIs');
      qrySumTh.SQL.Add('FROM thetas th');
      qrySumTh.SQL.Add('WHERE RunNo = ''' + frmMain.qryRunsRunNo.Value + '''');
      qrySumTh.SQL.Add('ORDER BY Theta;');
    end;
    qrySumTh.Active := True;

    intThetas := qrySumTh.RecordCount;
    qrySumTh.First;
    //ShowMessage(IntToStr(intthetas));
    //ShowMessage(qrySumTh.SQL.Text);

    qrySumOm.SQL.Clear;
    if frmMain.qryEst.RecordCount > 1 then
    begin
      qrySumOm.SQL.Add('SELECT om.Omega, om.OmegaValue, om.OmegaSE, om.OmegaRSE, om.OmegaLabel, om.OmegaCIs, om.EtaShrinkage, om.EtaBar, om.EtaBarSE, om.EtaPVal');
      qrySumOm.SQL.Add('FROM omegas om, ');
      qrySumOm.SQL.Add('  (SELECT max(EstNo) as maxest');
      qrySumOm.SQL.Add('   FROM omegas) maxests');
      qrySumOm.SQL.Add('WHERE RunNo = ''' + frmMain.qryRunsRunNo.Value + ''' AND om.EstNo = maxests.maxest');
      qrySumOm.SQL.Add('ORDER BY Omega;');
    end
    else
    begin
      qrySumOm.SQL.Add('SELECT om.Omega, om.OmegaValue, om.OmegaSE, om.OmegaRSE, om.OmegaLabel, om.OmegaCIs, om.EtaShrinkage, om.EtaBar, om.EtaBarSE, om.EtaPVal');
      qrySumOm.SQL.Add('FROM omegas om');
      qrySumOm.SQL.Add('WHERE RunNo = ''' + frmMain.qryRunsRunNo.Value + '''');
      qrySumOm.SQL.Add('ORDER BY Omega;');
    end;
    qrySumOm.Active := True;

    intEtas := qrySumOm.RecordCount;
    qrySumOm.First;

    qrySumSi.SQL.Clear;
    if frmMain.qryEst.RecordCount > 1 then
    begin
      qrySumSi.SQL.Add('SELECT si.Sigma, si.SigmaValue, si.SigmaSE, si.SigmaRSE, si.SigmaLabel, si.SigmaCIs, si.EpsilonShrinkage');
      qrySumSi.SQL.Add('FROM sigmas si, ');
      qrySumSi.SQL.Add('  (SELECT max(EstNo) as maxest');
      qrySumSi.SQL.Add('   FROM sigmas) maxests');
      qrySumSi.SQL.Add('WHERE RunNo = ''' + frmMain.qryRunsRunNo.Value + ''' AND si.EstNo = maxests.maxest');
      qrySumSi.SQL.Add('ORDER BY Sigma;');
    end
    else
    begin
      qrySumSi.SQL.Add('SELECT si.Sigma, si.SigmaValue, si.SigmaSE, si.SigmaRSE, si.SigmaLabel, si.SigmaCIs, si.EpsilonShrinkage');
      qrySumSi.SQL.Add('FROM sigmas si');
      qrySumSi.SQL.Add('WHERE RunNo = ''' + frmMain.qryRunsRunNo.Value + '''');
      qrySumSi.SQL.Add('ORDER BY Sigma;');
    end;
    qrySumSi.Active := True;

    intEpsilons := qrySumSi.RecordCount;
    qrySumSi.First;

    //ShowMessage(IntToStr(CheckGroup1.Items.Count  ));
    with lstHtml do
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
      //ShowMessage('1');
      for n := 0 to CheckGroup1.Items.Count - 1 do
        if CheckGroup1.Checked[n] then
        begin
          Add('  <COL />');
          p := p + 1;
        end;
      Add('<TBODY>');
      Add('    <TR VALIGN=TOP>');
      //ShowMessage('2');
      for n := 0 to CheckGroup1.Items.Count - 1 do
        if CheckGroup1.Checked[n] then
        begin
          Add('    <TH WIDTH=' + IntToStr(Round((1/ p) * 100)) + ' %>');
          case n of
            0: Add('    <P ALIGN=LEFT>No</P>');
            1: Add('    <P ALIGN=LEFT>Parameter</P>');
            2: Add('    <P ALIGN=LEFT>Estimate</P>');
            3: Add('    <P ALIGN=LEFT>S.E.</P>');
            4: Add('    <P ALIGN=LEFT>% Relative S.E.</P>');
            5: Add('    <P ALIGN=LEFT>Asymptotic 95% C.I.</P>');
            6: Add('    <P ALIGN=LEFT>Shrinkage</P>');
            7: Add('    <P ALIGN=LEFT>EtaBar</P>');
            8: Add('    <P ALIGN=LEFT>EtaBar S.E.</P>');
            9: Add('    <P ALIGN=LEFT>EtaBar P-value</P>');
          end;
    	  Add('    </TH>');
        end;
    	Add('    </TR>');
    	Add('</TBODY>');

        Add('<TBODY>');

        // Thetas

        for n := 0 to intThetas - 1 do
        begin
          Add('    <TR VALIGN=TOP>');
          //ShowMessage('3');
          for m := 0 to CheckGroup1.Items.Count - 1 do
            if CheckGroup1.Checked[m] then
            begin
              case m of
                0: begin
                     Add('    <TD WIDTH=' + IntToStr(Round((1/p) * 100)) + '% SDVAL="' + qrySumTh.FieldByName('Theta').AsString + '" SDNUM="9;">');
                     Add('        <P ALIGN=LEFT>&theta;<sub>' + qrySumTh.FieldByName('Theta').AsString + '</sub></P> ');
                     Add('    </TD>');
                   end;
                1: begin
                     Add('    <TD WIDTH=' + IntToStr(Round((1/p) * 100)) + '% SDVAL="' + qrySumTh.FieldByName('ThetaLabel').AsString + '" SDNUM="9;">');
                     Add('        <P ALIGN=LEFT>' + qrySumTh.FieldByName('ThetaLabel').AsString + '</P> ');
                     Add('    </TD>');
                   end;
                2: begin
                     Add('    <TD WIDTH=' + IntToStr(Round((1/p) * 100)) + '% SDVAL="' + qrySumTh.FieldByName('ThetaValue').AsString + '" SDNUM="9;">');
                     //Add('        <P ALIGN=LEFT>' + FloatToStrF(qrySumTh.FieldByName('ThetaValue').AsFloat, ffGeneral, 5, 4) + '</P> ');
                     Add('        <P ALIGN=LEFT>' + FloatToStr(SigDig(qrySumTh.FieldByName('ThetaValue').AsFloat, 4)) + '</P> ');
                     Add('    </TD>');
                   end;
                3: begin
                     Add('    <TD WIDTH=' + IntToStr(Round((1/p) * 100)) + '% SDVAL="' + qrySumTh.FieldByName('ThetaSE').AsString + '" SDNUM="9;">');
                     //Add('        <P ALIGN=LEFT>' + FloatToStrF(qrySumTh.FieldByName('ThetaSE').AsFloat, ffGeneral, 5, 4) + '</P> ');
                     Add('        <P ALIGN=LEFT>' + FloatToStr(SigDig(qrySumTh.FieldByName('ThetaSE').AsFloat, 4)) + '</P> ');
                     Add('    </TD>');
                   end;
                4: begin
                     Add('    <TD WIDTH=' + IntToStr(Round((1/p) * 100)) + '% SDVAL="' + qrySumTh.FieldByName('ThetaRSE').AsString + '" SDNUM="9;">');
                     //Add('        <P ALIGN=LEFT>' + FloatToStrF(qrySumTh.FieldByName('ThetaRSE').AsFloat, ffGeneral, 5, 4) + '</P> ');
                     Add('        <P ALIGN=LEFT>' + FloatToStr(SigDig(qrySumTh.FieldByName('ThetaRSE').AsFloat, 4)) + '</P> ');
                     Add('    </TD>');
                   end;
                5: begin
                     Add('    <TD WIDTH=' + IntToStr(Round((1/p) * 100)) + '% SDVAL="' + qrySumTh.FieldByName('ThetaCIs').AsString + '" SDNUM="9;">');
                     Add('        <P ALIGN=LEFT>' + qrySumTh.FieldByName('ThetaCIs').AsString + '</P> ');
                     Add('    </TD>');
                   end;
                6: begin
                     Add('    <TD WIDTH=' + IntToStr(Round((1/p) * 100)) + '% SDVAL="0" SDNUM="9;">');
                     Add('        <P ALIGN=LEFT>-</P> ');
                     Add('    </TD>');
                   end;
                7: begin
                     Add('    <TD WIDTH=' + IntToStr(Round((1/p) * 100)) + '% SDVAL="0" SDNUM="9;">');
                     Add('        <P ALIGN=LEFT>-</P> ');
                     Add('    </TD>');
                   end;
                8: begin
                     Add('    <TD WIDTH=' + IntToStr(Round((1/p) * 100)) + '% SDVAL="0" SDNUM="9;">');
                     Add('        <P ALIGN=LEFT>-</P> ');
                     Add('    </TD>');
                   end;
                9: begin
                     Add('    <TD WIDTH=' + IntToStr(Round((1/p) * 100)) + '% SDVAL="0" SDNUM="9;">');
                     Add('        <P ALIGN=LEFT>-</P> ');
                     Add('    </TD>');
                   end;
              end;
            end;
          Add('    </TR>');
          qrySumTh.Next;
        end;

        // Etas
        for n := 0 to intEtas - 1 do
        begin
          Add('    <TR VALIGN=TOP>');
          //ShowMessage('4');
          for m := 0 to CheckGroup1.Items.Count - 1 do
            if CheckGroup1.Checked[m] then
            begin
              case m of
                0: begin
                     Add('    <TD WIDTH=' + IntToStr(Round((1/p) * 100)) + ' % SDVAL="' + qrySumOm.FieldByName('Omega').AsString + '" SDNUM="9;">');
                     Add('        <P ALIGN=LEFT>&omega;<sub>' + qrySumOm.FieldByName('Omega').AsString + '</sub><sup>2</sup></P> ');
                     Add('    </TD>');
                   end;
                1: begin
                     Add('    <TD WIDTH=' + IntToStr(Round((1/p) * 100)) + ' % SDVAL="' + qrySumOm.FieldByName('OmegaLabel').AsString + '" SDNUM="9;">');
                     Add('        <P ALIGN=LEFT>' + qrySumOm.FieldByName('OmegaLabel').AsString + '</P> ');
                     Add('    </TD>');
                   end;
                2: begin
                     Add('    <TD WIDTH=' + IntToStr(Round((1/p) * 100)) + ' % SDVAL="' + qrySumOm.FieldByName('OmegaValue').AsString + '" SDNUM="9;">');
                     //Add('        <P ALIGN=LEFT>' + FloatToStrF(qrySumOm.FieldByName('OmegaValue').AsFloat, ffGeneral, 5, 4) + '</P> ');
                     Add('        <P ALIGN=LEFT>' + FloatToStr(SigDig(qrySumOm.FieldByName('OmegaValue').AsFloat, 4)) + '</P> ');
                     Add('    </TD>');
                   end;
                3: begin
                     Add('    <TD WIDTH=' + IntToStr(Round((1/p) * 100)) + ' % SDVAL="' + qrySumOm.FieldByName('OmegaSE').AsString + '" SDNUM="9;">');
                     //Add('        <P ALIGN=LEFT>' + FloatToStrF(qrySumOm.FieldByName('OmegaSE').AsFloat, ffGeneral, 5, 4) + '</P> ');
                     Add('        <P ALIGN=LEFT>' + FloatToStr(SigDig(qrySumOm.FieldByName('OmegaSE').AsFloat, 4)) + '</P> ');
                     Add('    </TD>');
                   end;
                4: begin
                     Add('    <TD WIDTH=' + IntToStr(Round((1/p) * 100)) + ' % SDVAL="' + qrySumOm.FieldByName('OmegaRSE').AsString + '" SDNUM="9;">');
                     //Add('        <P ALIGN=LEFT>' + FloatToStrF(qrySumOm.FieldByName('OmegaRSE').AsFloat, ffGeneral, 5, 4) + '</P> ');
                     Add('        <P ALIGN=LEFT>' + FloatToStr(SigDig(qrySumOm.FieldByName('OmegaRSE').AsFloat, 4)) + '</P> ');
                     Add('    </TD>');
                   end;
                5: begin
                     Add('    <TD WIDTH=' + IntToStr(Round((1/p) * 100)) + ' % SDVAL="' + qrySumOm.FieldByName('OmegaCIs').AsString + '" SDNUM="9;">');
                     Add('        <P ALIGN=LEFT>' + qrySumOm.FieldByName('OmegaCIs').AsString + '</P> ');
                     Add('    </TD>');
                   end;
                6: begin
                     Add('    <TD WIDTH=' + IntToStr(Round((1/p) * 100)) + ' % SDVAL="' + qrySumOm.FieldByName('EtaShrinkage').AsString + '" SDNUM="9;">');
                     Add('        <P ALIGN=LEFT>' + qrySumOm.FieldByName('EtaShrinkage').AsString + '</P> ');
                     Add('    </TD>');
                   end;
                7: begin
                     Add('    <TD WIDTH=' + IntToStr(Round((1/p) * 100)) + ' % SDVAL="' + qrySumOm.FieldByName('EtaBar').AsString + '" SDNUM="9;">');
                     Add('        <P ALIGN=LEFT>' + qrySumOm.FieldByName('EtaBar').AsString + '</P> ');
                     Add('    </TD>');
                   end;
                8: begin
                     Add('    <TD WIDTH=' + IntToStr(Round((1/p) * 100)) + ' % SDVAL="' + qrySumOm.FieldByName('EtaBarSE').AsString + '" SDNUM="9;">');
                     Add('        <P ALIGN=LEFT>' + qrySumOm.FieldByName('EtaBarSE').AsString + '</P> ');
                     Add('    </TD>');
                   end;
                9: begin
                     Add('    <TD WIDTH=' + IntToStr(Round((1/p) * 100)) + ' % SDVAL="' + qrySumOm.FieldByName('EtaPVal').AsString + '" SDNUM="9;">');
                     Add('        <P ALIGN=LEFT>' + qrySumOm.FieldByName('EtaPVal').AsString + '</P> ');
                     Add('    </TD>');
                   end;
              end;
            end;
          Add('    </TR>');
          qrySumOm.Next;
        end;

        // Epsilons
        for n := 0 to intEpsilons - 1 do
        begin
          Add('    <TR VALIGN=TOP>');
          //ShowMessage('5');
          for m := 0 to CheckGroup1.Items.Count - 1 do
            if CheckGroup1.Checked[m] then
            begin
              case m of
                0: begin
                     Add('    <TD WIDTH=' + IntToStr(Round((1/p) * 100)) + ' % SDVAL="' + qrySumSi.FieldByName('Sigma').AsString + '" SDNUM="9;">');
                     Add('        <P ALIGN=LEFT>&sigma;<sub>' + qrySumSi.FieldByName('Sigma').AsString + '</sub><sup>2</sup></P> ');
                     Add('    </TD>');
                   end;
                1: begin
                     Add('    <TD WIDTH=' + IntToStr(Round((1/p) * 100)) + ' % SDVAL="' + qrySumSi.FieldByName('SigmaLabel').AsString + '" SDNUM="9;">');
                     Add('        <P ALIGN=LEFT>' + qrySumSi.FieldByName('SigmaLabel').AsString + '</P> ');
                     Add('    </TD>');
                   end;
                2: begin
                     Add('    <TD WIDTH=' + IntToStr(Round((1/p) * 100)) + ' % SDVAL="' + qrySumSi.FieldByName('SigmaValue').AsString + '" SDNUM="9;">');
                     //Add('        <P ALIGN=LEFT>' + FloatToStrF(qrySumSi.FieldByName('SigmaValue').AsFloat, ffGeneral, 5, 4) + '</P> ');
                     Add('        <P ALIGN=LEFT>' + FloatToStr(SigDig(qrySumSi.FieldByName('SigmaValue').AsFloat, 4)) + '</P> ');
                     Add('    </TD>');
                   end;
                3: begin
                     Add('    <TD WIDTH=' + IntToStr(Round((1/p) * 100)) + ' % SDVAL="' + qrySumSi.FieldByName('SigmaSE').AsString + '" SDNUM="9;">');
                     //Add('        <P ALIGN=LEFT>' + FloatToStrF(qrySumSi.FieldByName('SigmaSE').AsFloat, ffGeneral, 5, 4) + '</P> ');
                     Add('        <P ALIGN=LEFT>' + FloatToStr(SigDig(qrySumSi.FieldByName('SigmaSE').AsFloat, 4)) + '</P> ');
                     Add('    </TD>');
                   end;
                4: begin
                     Add('    <TD WIDTH=' + IntToStr(Round((1/p) * 100)) + ' % SDVAL="' + qrySumSi.FieldByName('SigmaRSE').AsString + '" SDNUM="9;">');
                     //Add('        <P ALIGN=LEFT>' + FloatToStrF(qrySumSi.FieldByName('SigmaRSE').AsFloat, ffGeneral, 5, 4) + '</P> ');
                     Add('        <P ALIGN=LEFT>' + FloatToStr(SigDig(qrySumSi.FieldByName('SigmaRSE').AsFloat, 4)) + '</P> ');
                     Add('    </TD>');
                   end;
                5: begin
                     Add('    <TD WIDTH=' + IntToStr(Round((1/p) * 100)) + ' % SDVAL="' + qrySumSi.FieldByName('SigmaCIs').AsString + '" SDNUM="9;">');
                     Add('        <P ALIGN=LEFT>' + qrySumSi.FieldByName('SigmaCIs').AsString + '</P> ');
                     Add('    </TD>');
                   end;
                6: begin
                     Add('    <TD WIDTH=' + IntToStr(Round((1/p) * 100)) + ' % SDVAL="' + qrySumSi.FieldByName('EpsilonShrinkage').AsString + '" SDNUM="9;">');
                     Add('        <P ALIGN=LEFT>' + qrySumSi.FieldByName('EpsilonShrinkage').AsString + '</P> ');
                     Add('    </TD>');
                   end;
                7: begin
                     Add('    <TD WIDTH=' + IntToStr(Round((1/p) * 100)) + ' % SDVAL="0" SDNUM="9;">');
                     Add('        <P ALIGN=LEFT>-</P> ');
                     Add('    </TD>');
                   end;
                8: begin
                     Add('    <TD WIDTH=' + IntToStr(Round((1/p) * 100)) + ' % SDVAL="0" SDNUM="9;">');
                     Add('        <P ALIGN=LEFT>-</P> ');
                     Add('    </TD>');
                   end;
                9: begin
                     Add('    <TD WIDTH=' + IntToStr(Round((1/p) * 100)) + ' % SDVAL="0" SDNUM="9;">');
                     Add('        <P ALIGN=LEFT>-</P> ');
                     Add('    </TD>');
                   end;
              end;
            end;
          Add('    </TR>');
          qrySumSi.Next;
        end;

    	Add('</TBODY>');
    	Add('</TABLE>');
    	Add('<P STYLE="margin-bottom: 0in"><BR>');
    	Add('</P>');
    	Add('</BODY>');
    	Add('</HTML>');

    end;

    lstHtml.SaveToFile(GetTempDir(False) + 'demo.html');
    htmlPanel.OpenURL('FILE://' + GetTempDir(False) + 'demo.html');
    htmlPanel.Refresh;

    p := 0;

    qrySumTh.First;
    qrySumOm.First;
    qrySumSi.First;

    if strType = 'latex' then
    begin
      lstLatex.Clear;

      with lstLaTeX do
      begin
        Add('\documentclass[12pt]{article}');
        Add('\usepackage{ctable}');
        Add('\usepackage{relsize}');
        Add('\begin{document}');
        Add('');
        Add('\ctable[');
        Add('	pos=H,');
        Add('	doinside=\smaller,');
        Add('	label   = tab:census,');
        Add('	width=\textwidth,');
        Add('	caption = Parameter estimates for run ' + frmMain.qryRunsRunNo.Value + '.');
      end;

      txtTemp := ']{';

      for n := 0 to CheckGroup1.Items.Count - 1 do
        if CheckGroup1.Checked[n] then
        begin
          if (n = 1) then
            txtTemp := txtTemp + '>{\raggedright}p{3cm}'
          else
            txtTemp := txtTemp + 'l';
          p := p + 1;
        end;

      txtTemp := txtTemp + '}{\tnote[a]{Standard error}\tnote[b]{Relative standard error}\tnote[c]{Asymptotic confidence interval}}{ ';
      lstLaTeX.Add(txtTemp);
      lstLaTeX.Add('\FL');
      txtTemp := '';
      q := 0;

      for n := 0 to CheckGroup1.Items.Count - 1 do
        if CheckGroup1.Checked[n] then
        begin
          case n of
            0: txtTemp := txtTemp + '\textbf{No}';
            1: txtTemp := txtTemp + '\textbf{Parameter}';
            2: txtTemp := txtTemp + '\textbf{Estimate}';
            3: txtTemp := txtTemp + '\textbf{SE}\tmark[a]';
            4: txtTemp := txtTemp + '\textbf{\% RSE}\tmark[b]';
            5: txtTemp := txtTemp + '\textbf{95\% CI}\tmark[c]';
            6: txtTemp := txtTemp + '\textbf{Shrinkage}';
            7: txtTemp := txtTemp + '\textbf{EtaBar}';
            8: txtTemp := txtTemp + '\textbf{EtaBar SE}\tmark[a]';
            9: txtTemp := txtTemp + '\textbf{EtaBar P-value}';
          end;
          if (q < p - 1) then
            txtTemp := txtTemp + ' & ';
    	  q := q + 1;
        end;

      lstLaTeX.Add(txtTemp);
      lstLaTeX.Add('\ML');
      txtTemp := '';
      q := 0;

      // Thetas
      for n := 0 to intThetas - 1 do
      begin
        for m := 0 to CheckGroup1.Items.Count - 1 do
          if CheckGroup1.Checked[m] then
          begin
            case m of
              0: txtTemp := txtTemp + '$\theta_{' + qrySumTh.FieldByName('Theta').AsString + '}$';
              1: txtTemp := txtTemp + qrySumTh.FieldByName('ThetaLabel').AsString;
              //2: txtTemp := txtTemp + FloatToStrF(qrySumTh.FieldByName('ThetaValue').AsFloat, ffGeneral, 5, 4);
              //3: txtTemp := txtTemp + FloatToStrF(qrySumTh.FieldByName('ThetaSE').AsFloat, ffGeneral, 5, 4);
              //4: txtTemp := txtTemp + FloatToStrF(qrySumTh.FieldByName('ThetaRSE').AsFloat, ffGeneral, 5, 4);
              2: txtTemp := txtTemp + FloatToStr(SigDig(qrySumTh.FieldByName('ThetaValue').AsFloat, 4));
              3: txtTemp := txtTemp + FloatToStr(SigDig(qrySumTh.FieldByName('ThetaSE').AsFloat, 4));
              4: txtTemp := txtTemp + FloatToStr(SigDig(qrySumTh.FieldByName('ThetaRSE').AsFloat, 4));
              5: txtTemp := txtTemp + qrySumTh.FieldByName('ThetaCIs').AsString;
              6: txtTemp := txtTemp + '$-$';
              7: txtTemp := txtTemp + '$-$';
              8: txtTemp := txtTemp + '$-$';
              9: txtTemp := txtTemp + '$-$';
            end;
            if (q < p - 1) then
              txtTemp := txtTemp + ' & ';
            if (q = p - 1) and (n < intThetas - 1) then
               txtTemp := txtTemp + '\NN'
            else
              if (q = p - 1) and (n = intThetas - 1) then
                 txtTemp := txtTemp + '\ML';
      	    q := q + 1;
          end;
        lstLaTeX.Add(txtTemp);
        q := 0;
        txtTemp := '';
        qrySumTh.Next;
      end;

      // Omegas
      for n := 0 to intEtas - 1 do
      begin
        for m := 0 to CheckGroup1.Items.Count - 1 do
          if CheckGroup1.Checked[m] then
          begin
            case m of
              0: txtTemp := txtTemp + '$\omega_{' + qrySumOm.FieldByName('Omega').AsString + '}^{2}$';
              1: txtTemp := txtTemp + qrySumOm.FieldByName('OmegaLabel').AsString;
              //2: txtTemp := txtTemp + FloatToStrF(qrySumOm.FieldByName('OmegaValue').AsFloat, ffGeneral, 5, 4);
              //3: txtTemp := txtTemp + FloatToStrF(qrySumOm.FieldByName('OmegaSE').AsFloat, ffGeneral, 5, 4);
              //4: txtTemp := txtTemp + FloatToStrF(qrySumOm.FieldByName('OmegaRSE').AsFloat, ffGeneral, 5, 4);
              2: txtTemp := txtTemp + FloatToStr(SigDig(qrySumOm.FieldByName('OmegaValue').AsFloat, 4));
              3: txtTemp := txtTemp + FloatToStr(SigDig(qrySumOm.FieldByName('OmegaSE').AsFloat, 4));
              4: txtTemp := txtTemp + FloatToStr(SigDig(qrySumOm.FieldByName('OmegaRSE').AsFloat, 4));
              5: txtTemp := txtTemp + qrySumOm.FieldByName('OmegaCIs').AsString;
              6: txtTemp := txtTemp + qrySumOm.FieldByName('EtaShrinkage').AsString;
              7: txtTemp := txtTemp + qrySumOm.FieldByName('EtaBar').AsString;
              8: txtTemp := txtTemp + qrySumOm.FieldByName('EtaBarSE').AsString;
              9: txtTemp := txtTemp + qrySumOm.FieldByName('EtaPVal').AsString;
            end;
            if (q < p-1) then
              txtTemp := txtTemp + ' & ';
            if (q = p-1) and (n < intEtas - 1) then
               txtTemp := txtTemp + '\NN'
            else
              if (q = p-1) and (n = intEtas - 1) then
                 txtTemp := txtTemp + '\ML';
      	    q := q + 1;
          end;
        lstLaTeX.Add(txtTemp);
        q := 0;
        txtTemp := '';
        qrySumOm.Next;
      end;

      // Sigmas
      for n := 0 to intEpsilons - 1 do
      begin
        for m := 0 to CheckGroup1.Items.Count - 1 do
          if CheckGroup1.Checked[m] then
          begin
            case m of
              0: txtTemp := txtTemp + '$\sigma_{' + qrySumSi.FieldByName('Sigma').AsString + '}^{2}$';
              1: txtTemp := txtTemp + qrySumSi.FieldByName('SigmaLabel').AsString;
              //2: txtTemp := txtTemp + FloatToStrF(qrySumSi.FieldByName('SigmaValue').AsFloat, ffGeneral, 5, 4);
              //3: txtTemp := txtTemp + FloatToStrF(qrySumSi.FieldByName('SigmaSE').AsFloat, ffGeneral, 5, 4);
              //4: txtTemp := txtTemp + FloatToStrF(qrySumSi.FieldByName('SigmaRSE').AsFloat, ffGeneral, 5, 4);
              2: txtTemp := txtTemp + FloatToStr(SigDig(qrySumSi.FieldByName('SigmaValue').AsFloat, 4));
              3: txtTemp := txtTemp + FloatToStr(SigDig(qrySumSi.FieldByName('SigmaSE').AsFloat, 4));
              4: txtTemp := txtTemp + FloatToStr(SigDig(qrySumSi.FieldByName('SigmaRSE').AsFloat, 4));
              5: txtTemp := txtTemp + qrySumSi.FieldByName('SigmaCIs').AsString;
              6: txtTemp := txtTemp + qrySumSi.FieldByName('EpsilonShrinkage').AsString;
              7: txtTemp := txtTemp + '$-$';
              8: txtTemp := txtTemp + '$-$';
              9: txtTemp := txtTemp + '$-$';
            end;
            if (q < p-1) then
              txtTemp := txtTemp + ' & ';
            if (q = p-1) and (n < intEpsilons - 1) then
               txtTemp := txtTemp + '\NN'
            else
              if (q = p-1) and (n = intEpsilons - 1) then
                 txtTemp := txtTemp + '\LL' ;
      	    q := q + 1;
          end;
        lstLaTeX.Add(txtTemp);
        q := 0;
        txtTemp := '';
        qrySumSi.Next;
      end;

      lstLaTeX.Add('}');
      lstLaTeX.Add('\end{document}');

    end;

  finally
    Screen.Cursor := myCursor;
  end;

  //ShowMessage(GetTempDir(False) + 'test.html');

end;

procedure TfrmExportRun.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  CloseAction := caFree;
  frmExportRun := nil;
end;

procedure TfrmExportRun.FormCreate(Sender: TObject);
begin
  lstHtml := TStringList.Create;
  lstLatex := TStringList.Create;
  //ExportRun('html');
  {$ifdef windows}
  Label1.Font.Size := 0;
  Label1.Height := 48;
  pnlLatex.Height := 72;
  {$endif}
  {$ifdef darwin}
  Label1.Font.Size := -11;
  Label1.Height := 48;
  pnlLatex.Height := 72;
  {$endif}
end;

procedure TfrmExportRun.FormShow(Sender: TObject);
begin
  ExportRun('html');
end;

procedure TfrmExportRun.rgOutputClick(Sender: TObject);
begin
  if rgOutput.ItemIndex = 1 then
    pnlLatex.Visible := True
  else
    pnlLatex.Visible := False;
end;

procedure TfrmExportRun.btnExportClick(Sender: TObject);
begin
  if rgOutput.ItemIndex = 0 then
  begin
    dlgSave.Filter := 'HTML file (*.html)|*.html';
    dlgSave.DefaultExt := '.html';
  end
  else
  begin
    dlgSave.Filter := 'LaTeX file (*.tex)|*.tex';
    dlgSave.DefaultExt := '.tex';
  end;

  if dlgSave.Execute then
  begin
    //if FileExists(dlgSave.FileName) then
    //  if MessageDlg('A file with this name already exists at this location.' +
    //    ' Do you wish to overwrite it?', mtWarning, [mbYes, mbNo], 0) = mrNo then
    //    Exit
    //  else
      if rgOutput.ItemIndex = 0 then
      begin
        ExportRun('html');
        lstHtml.SaveToFile(dlgSave.FileName);
      end
      else
      begin
        ExportRun('latex');
        lstLaTeX.SaveToFile(dlgSave.FileName);
     end;

  end;
end;

procedure TfrmExportRun.CheckGroup1ItemClick(Sender: TObject; Index: integer);
begin
  ExportRun('html');
end;

procedure TfrmExportRun.btnCancelClick(Sender: TObject);
begin
  //if Assigned(lstHtml) then
  //  lstHtml.Free;
  //if Assigned(lstLaTeX) then
  //  lstLaTeX.Free;
  Close;
end;

function TfrmExportRun.SigDig(fltIn: Double; intPrec: Integer): Double;
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

{$R *.lfm}

end.

