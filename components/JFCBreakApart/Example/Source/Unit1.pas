unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JFCBreakApart, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    JFCBreakApart1: TJFCBreakApart;
    BaseStringEdit: TEdit;
    Label1: TLabel;
    BreakApartButton: TButton;
    ReverseBreakApartButton: TButton;
    BreakApartListBox: TListBox;
    AllowEmptyStringCheckBox: TCheckBox;
    CaseSensitiveCheckBox: TCheckBox;
    DoubleQuoteModeCheckBox: TCheckBox;
    BreakStringEdit: TEdit;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure BreakApartButtonClick(Sender: TObject);
    procedure ReverseBreakApartButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.BreakApartButtonClick(Sender: TObject);
begin
  JFCBreakApart1.BaseString := BaseStringEdit.Text;
  JFCBreakApart1.BreakString := BreakStringEdit.Text;
  JFCBreakApart1.AllowEmptyString := AllowEmptyStringCheckBox.Checked;
  JFCBreakApart1.CaseSensitive := CaseSensitiveCheckBox.Checked;
  JFCBreakApart1.DoubleQuoteMode := DoubleQuoteModeCheckBox.Checked;

  JFCBreakApart1.BreakApart;

  BreakApartListBox.Items.Assign(JFCBreakApart1.StringList);
  ReverseBreakApartButton.Enabled := (BreakApartListBox.Items.Count > 0);
end;

procedure TForm1.ReverseBreakApartButtonClick(Sender: TObject);
begin
  JFCBreakApart1.BreakString := BreakStringEdit.Text;
  JFCBreakApart1.AllowEmptyString := AllowEmptyStringCheckBox.Checked;
  JFCBreakApart1.CaseSensitive := CaseSensitiveCheckBox.Checked;
  JFCBreakApart1.DoubleQuoteMode := DoubleQuoteModeCheckBox.Checked;

  JFCBreakApart1.ReverseBreakApart;

  BaseStringEdit.Text := JFCBreakApart1.BaseString;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  BaseStringEdit.Text := JFCBreakApart1.BaseString;
  BreakStringEdit.Text := JFCBreakApart1.BreakString;
  AllowEmptyStringCheckBox.Checked := JFCBreakApart1.AllowEmptyString;
  CaseSensitiveCheckBox.Checked := JFCBreakApart1.CaseSensitive;
  DoubleQuoteModeCheckBox.Checked := JFCBreakApart1.DoubleQuoteMode;
end;

end.
