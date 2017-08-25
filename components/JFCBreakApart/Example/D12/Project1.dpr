program Project1;

uses
  Forms,
  Unit1 in '..\Source\Unit1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'TJFCBreakApart';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
