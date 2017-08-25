unit udemo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs,
  HistoryFiles, Menus, ExtCtrls, StdCtrls;

type

  { TFDemo }

  TFDemo = class(TForm)
    chkShowFullPath: TCheckBox;
    chkShowNumber: TCheckBox;
    chkSorted: TCheckBox;
    GroupBox: TGroupBox;
    HistoryFiles: THistoryFiles;
    MainMenu1: TMainMenu;
    Memo: TMemo;
    MenuItem1: TMenuItem;
    mnuExit: TMenuItem;
    mnuFile: TMenuItem;
    mnuOpen: TMenuItem;
    OpenDialog: TOpenDialog;
    procedure chkShowFullPathClick(Sender: TObject);
    procedure chkShowNumberClick(Sender: TObject);
    procedure chkSortedClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure HistoryFilesClickHistoryItem(Sender: TObject; Item: TMenuItem;
      const Filename: string);
    procedure HistoryFilesCreateItem(Sender: TObject; Item: TMenuItem;
      Filename: string);
    procedure mnuExitClick(Sender: TObject);
    procedure mnuOpenClick(Sender: TObject);
  private
    { private declarations }
     bBitmap : TBitmap;
     bBitmapOpen : TBitmap;
  public
    { public declarations }
  end; 

var
  FDemo: TFDemo;

implementation

{ TFDemo }

procedure TFDemo.mnuOpenClick(Sender: TObject);
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

procedure TFDemo.FormCreate(Sender: TObject);
var
 sPath : string;

begin
  bBitmap := TBitmap.Create;
  bBitmap.LoadFromFile('NEW.BMP');
  bBitmap.Transparent:= true;

  bBitmapOpen := TBitmap.Create;
  bBitmapOpen.LoadFromFile('OPEN.BMP');
  bBitmapOpen.Transparent:= true;

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

procedure TFDemo.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  bBitmap.Free;
  bBitmapOpen.Free;
end;

procedure TFDemo.chkShowFullPathClick(Sender: TObject);
begin
  HistoryFiles.ShowFullPath := chkShowFullPath.Checked;
  // Refresh the menu
  HistoryFiles.UpdateParentMenu;
end;

procedure TFDemo.chkShowNumberClick(Sender: TObject);
begin
  HistoryFiles.ShowNumber := chkShowNumber.Checked;
  // Refresh the menu
  HistoryFiles.UpdateParentMenu;
end;

procedure TFDemo.chkSortedClick(Sender: TObject);
begin
  HistoryFiles.Sorted := chkSorted.Checked;
  // Refresh the menu
  HistoryFiles.UpdateParentMenu;
end;

procedure TFDemo.HistoryFilesCreateItem(Sender: TObject; Item: TMenuItem;
  Filename: string);
begin
    // When a new Item is created I can
    // change the properties like I want
    Item.Bitmap := bBitmap;
end;

procedure TFDemo.HistoryFilesClickHistoryItem(Sender: TObject; Item: TMenuItem;
  const Filename: string);
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

procedure TFDemo.mnuExitClick(Sender: TObject);
begin
  Close;
end;

initialization
  {$I udemo.lrs}

end.

