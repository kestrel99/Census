unit uDemo;
{Works from D4 to D2009}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  HistoryFiles, Menus, StdCtrls;

type
  TfDemo = class(TForm)
    MainMenu: TMainMenu;
    Memo: TMemo;
    GroupBox: TGroupBox;
    chkShowFullPath: TCheckBox;
    chkShowNumber: TCheckBox;
    chkSorted: TCheckBox;
    mnuFile: TMenuItem;
    mnuExit: TMenuItem;
    HistoryFiles: THistoryFiles;
    OpenDialog: TOpenDialog;
    mnuOpen: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure chkShowFullPathClick(Sender: TObject);
    procedure chkShowNumberClick(Sender: TObject);
    procedure chkSortedClick(Sender: TObject);
    procedure mnuExitClick(Sender: TObject);
    procedure mnuOpenClick(Sender: TObject);
    procedure HistoryFilesClickHistoryItem(Sender: TObject;
      Item: TMenuItem; const Filename: String);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure HistoryFilesCreateItem(Sender: TObject; Item: TMenuItem;
      const Filename: String);
  private
    { Private declarations }
     bBitmap : TBitmap;
     bBitmapOpen : TBitmap;
  public
    { Public declarations }
  end;

var
  fDemo: TfDemo;

implementation

{$R *.DFM}

procedure TfDemo.FormCreate(Sender: TObject);
var
 sPath : string;
begin
  bBitmap := TBitmap.Create;
  bBitmap.LoadFromFile('new.bmp');
  bBitmap.Transparent := true;

  bBitmapOpen := TBitmap.Create;
  bBitmapOpen.LoadFromFile('open.bmp');
  bBitmapOpen.Transparent := true;

  // Update the check boxes
  chkShowFullPath.Checked := HistoryFiles.ShowFullPath;
  chkShowNumber.Checked := HistoryFiles.ShowNumber;
  chkSorted.Checked := HistoryFiles.Sorted;

  // Store local path
  sPath := ExtractFilePath(Application.ExeName);
  HistoryFiles.LocalPath := sPath;

  // Define the ini filename and where is it.
  HistoryFiles.IniFile := sPath + 'Demo.ini';

  // Add the history on the parent menu
  HistoryFiles.UpdateParentMenu;
end;

procedure TfDemo.chkShowFullPathClick(Sender: TObject);
begin
  HistoryFiles.ShowFullPath := chkShowFullPath.Checked;
  // Refresh the menu
  HistoryFiles.UpdateParentMenu;
end;

procedure TfDemo.chkShowNumberClick(Sender: TObject);
begin
  HistoryFiles.ShowNumber := chkShowNumber.Checked;
  // Refresh the menu
  HistoryFiles.UpdateParentMenu;
end;

procedure TfDemo.chkSortedClick(Sender: TObject);
begin
  HistoryFiles.Sorted := chkSorted.Checked;
  // Refresh the menu
  HistoryFiles.UpdateParentMenu;
end;

procedure TfDemo.mnuExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfDemo.mnuOpenClick(Sender: TObject);
var iShift : integer;
begin
  with OpenDialog do
  begin
    Execute;
    if FileName <> '' then
    begin
      Memo.Lines.LoadFromFile(FileName);

      // Add the filename into the history and refresh the menu
      HistoryFiles.UpdateList(FileName);

      if not chkSorted.Checked then
      begin
        // Change the icon
        with HistoryFiles do
        begin
          if Separator in [sepBoth,SepTop] then
            iShift:=1
          else
            iShift:=0;

          ParentMenu.Items[Position + iShift].Bitmap := bBitmapOpen;
        end;
      end;
    end;
  end;
end;

procedure TfDemo.HistoryFilesClickHistoryItem(Sender: TObject;
  Item: TMenuItem; const Filename: String);
var i : integer;
    iShift : integer;
begin
  // Reset the check for all history items
  with HistoryFiles do
  begin
    if Separator in [sepBoth,SepTop] then
      iShift:=1
    else
      iShift:=0;

    for i := iShift to Count - 1 + iShift do
      ParentMenu.Items[Position + i].Bitmap := bBitmap;
  end;

  // When a Item is clicked I can
  // change the properties like I want
  Item.Bitmap := bBitmapOpen;

  // When an Item is clicked the file is loaded on the Memo
  Memo.Lines.LoadFromFile(FileName);
end;

procedure TfDemo.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  bBitmap.Free;
  bBitmapOpen.Free;
end;

procedure TfDemo.HistoryFilesCreateItem(Sender: TObject; Item: TMenuItem;
  const Filename: String);
begin
    // When a new Item is created I can
    // change the properties like I want
    Item.Bitmap := bBitmap;
end;

end.
