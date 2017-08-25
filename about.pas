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

unit about;

{$mode delphi}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, ComCtrls, LCLProc;

type

  { TfrmAbout }

  TfrmAbout = class(TForm)
    btnOK: TButton;
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    Label2: TLabel;
    memLGPL: TMemo;
    memGPL: TMemo;
    Panel3: TPanel;
    pgcLicense: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    tabGPL: TTabSheet;
    tabLGPL: TTabSheet;
    procedure btnOKClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure pgcLicenseChange(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  frmAbout: TfrmAbout;

implementation

{$R *.lfm}

{ TfrmAbout }


{ TfrmAbout }


{ TfrmAbout }

procedure TfrmAbout.FormShow(Sender: TObject);
begin

end;

procedure TfrmAbout.Image2Click(Sender: TObject);
begin
  if pgcLicense.Visible then
  begin
    pgcLicense.Visible := False;
    frmAbout.Height := 390;
  end
  else
  begin
    pgcLicense.Visible := True;
    frmAbout.Height := 709;
    pgcLicense.ActivePage := tabLGPL;
    memGPL.SelStart := UTF8Pos('GNU GENERAL PUBLIC LICENSE', memGPL.Text) - 1;
    memGPL.SelLength := 0;
    //memGPL.SetFocus;

    memLGPL.SelStart := UTF8Pos('GNU LESSER GENERAL PUBLIC LICENSE', memLGPL.Text) - 1;
    memLGPL.SelLength := 0;
    memLGPL.SetFocus;
  end;
end;

procedure TfrmAbout.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction := caFree;
  frmAbout := nil;
end;

procedure TfrmAbout.btnOKClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAbout.pgcLicenseChange(Sender: TObject);
begin
  case pgcLicense.ActivePageIndex of
    0: begin
      memGPL.SelStart := UTF8Pos('GNU GENERAL PUBLIC LICENSE', memGPL.Text) - 1;
      memGPL.SelLength := 0;
      memGPL.SetFocus;
    end;
    1: begin
      memLGPL.SelStart := UTF8Pos('GNU LESSER GENERAL PUBLIC LICENSE', memLGPL.Text) - 1;
      memLGPL.SelLength := 0;
      memLGPL.SetFocus;
    end;
  end;
end;

end.

