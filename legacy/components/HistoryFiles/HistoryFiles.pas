{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Author:       Andrea Russo Italy
Description:  THistoryFiles store the recent files list into an .ini file and
              show the result into a menu.
              It's possibile to insert the list into any point of your menu.
              A method help you to have access of all property and method
              of the Menu Items so for example do you can specify the image
              of each items.

EMail:        http://www.andrearusso.it
              info@andrearusso.it

Creation:     January 2005
Modifed:      May 2009 (see Readme.txt)

Version:      1.2.1 For Delphi 2,3,4,5,6,7,8,D2005,D2009,Kylix and Lazarus
              (also all standard and personal editions)

Tested on:    Delphi 2,3,4,6,7,D2005,D2009 all personal or standard editions;
              Kylix 3 Open Edition
              Lazarus

Support:      If do you find a bug, please make a short program which reproduce
              the problem attach it to a message addressed to me.
              If I can reproduce the problem, I can find a fix !
              Do not send exe file but just source code and instructions.
              Always use the latest version (beta if any) before reporting any bug.

Legal issues: Copyright (C) 2005-2009 by Andrea Russo
              info@andrearusso.it
              http://www.andrearusso.it

              This software is provided 'as-it-is', without any express or
              implied warranty. In no event will the author be held liable
              for any damages arising from the use of this software.

              Permission is granted to anyone to use this software for any
              purpose, including commercial applications, and to alter it
              and redistribute it freely, subject to the following
              restrictions:

              1. The origin of this software must not be misrepresented,
                 you must not claim that you wrote the original software.
                 If you use this software in a product, an acknowledgment
                 in the product documentation would be appreciated but is
                 not required.

              2. Altered source versions must be plainly marked as such, and
                 must not be misrepresented as being the original software.

              3. This notice may not be removed or altered from any source
                 distribution.

              4. If do you alter this component please send to me the source
                 to following email address: info@andrearusso.it
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

unit HistoryFiles;

{$IFDEF FPC} //Lazarus
  {$mode objfpc}{$H+}
{$ENDIF}

interface

{$IFDEF FPC} //Lazarus
  uses IniFiles,Menus,SysUtils,Classes,Dialogs,Forms,LResources,LazarusPackageIntf;
{$Else}
  {$IfNDef LINUX} //Delphi
    uses IniFiles,Menus,SysUtils,Classes,Dialogs,Forms;
  {$Else} //Kylix
    uses IniFiles,QMenus,SysUtils,Classes,QDialogs,QForms;
  {$EndIf}
{$ENDIF}

Const

MsgPositionOutOfRange = 'Position out of range';
MsgParentMenuNotAssigned = 'ParentMenu not assigned';

Type

TSeparatorStyle = (sepNone, sepTop, sepBottom, sepBoth);

THistoryItemClick = procedure (Sender: TObject; Item: TMenuItem; const Filename: string) of object;
THistoryCreateItem = procedure (Sender: TObject; Item: TMenuItem; const Filename: string) of object;

Items = 1..255;

  THistoryFiles = class(TComponent)
  private
    FItems : TStringList;

    FOnHistoryItemClick : THistoryItemClick;
    FOnHistoryCreateItem : THistoryCreateItem;

    FMaxItems : Items;
    FIniKey : string;
    FLocalPath : string;
    FIniFile : string;
    FParentMenu : TMenuItem;
    FSeparator : TSeparatorStyle;
    FShowFullPath : boolean;
    FPosition : integer;
    FNumberOfItems : Integer;
    FCount : Integer;
    FFileMustExist : boolean;
    FOriginalMainMenuItems : Integer;
    FSorted : boolean;
    FShowNumber : boolean;

    procedure ClearMenu(MainMenu: TMenuItem);
    procedure OnMainMenuClickHistoryItem(Sender:TObject);
    procedure SetParentMenu(const Value: TMenuItem);
    procedure SetPosition(const Value: Integer);
  protected
  public
    constructor Create( AOwner : TComponent ); override;
    destructor Destroy; override;
    procedure UpdateList(thefile: string);
    procedure UpdateParentMenu;

    property Count : Integer read FCount;
  published
    property MaxItems : Items read FMaxItems write FMaxItems default 5;
    property IniKey : string read FIniKey write FIniKey;
    property LocalPath : string read FLocalPath write FLocalPath;
    property ShowFullPath : boolean read FShowFullPath write FShowFullPath default True;
    property IniFile : string read FIniFile write FIniFile;
    property ParentMenu : TMenuItem read FParentMenu write SetParentMenu;
    property Separator : TSeparatorStyle read FSeparator write FSeparator default sepNone;
    property Position : Integer read FPosition write SetPosition default 0;
    property FileMustExist : boolean read FFileMustExist write FFileMustExist default False;
    property Sorted : boolean read FSorted write FSorted default False;
    property ShowNumber : boolean read FShowNumber write FShowNumber default True;
    property OnClickHistoryItem : THistoryItemClick read FOnHistoryItemClick write FOnHistoryItemClick;
    property OnCreateItem : THistoryCreateItem read FOnHistoryCreateItem write FOnHistoryCreateItem;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('AR', [THistoryFiles]);
end;

constructor THistoryFiles.Create( AOwner : TComponent );
begin
  inherited Create( AOwner );
  FIniKey:='History Files';
  FMaxItems:=5;
  FLocalPath:='';
  FIniFile:='History.ini';
  FParentMenu:=nil;
  FSeparator:=sepNone;
  FOriginalMainMenuItems:=0;
  FItems := TStringList.Create;
  FShowFullPath:=True;
  FPosition:=0;
  FNumberOfItems:=0;
  FCount:=0;
  FOnHistoryItemClick:=nil;
  FOnHistoryCreateItem:=nil;
  FFileMustExist:=False;
  FSorted:=False;
  FShowNumber:=True;
end;

destructor THistoryFiles.Destroy;
Begin
  Inherited destroy;
  FItems.Free;
End;

function Upper(s : string): string;
begin
{$IfNDef LINUX}
  Result:=UpperCase(s);
{$Else}
  Result:=s;
{$EndIf}

end;

procedure THistoryFiles.SetPosition(const Value: Integer);
begin
  if AsSigned(FParentMenu) then
    begin
      if Value>FParentMenu.Count then
        MessageDlg(MsgPositionOutOfRange, mtError, [mbOk], 0)
      else
        FPosition:=Value;
    end
  else
    FPosition:=Value;
end;

procedure THistoryFiles.SetParentMenu(const Value: TMenuItem);
begin
  if AsSigned(FParentMenu) then
    ClearMenu(FParentMenu);

  FParentMenu:=Value;
  FOriginalMainMenuItems:=FParentMenu.Count;

  if (csDesigning in ComponentState) and not(csLoading in ComponentState) then
    FPosition:=FParentMenu.Count
  else
    if FPosition>FParentMenu.Count then
      FPosition:=FParentMenu.Count;
end;

procedure THistoryFiles.OnMainMenuClickHistoryItem(Sender:TObject);
var
 thefile : string;
begin
  thefile:='';
  If AsSigned(FOnHistoryItemClick) Then
  begin
   thefile := FItems.Strings[TMenuItem(sender).tag-1];
   if thefile<>'' then
      FOnHistoryItemClick(Self, TMenuItem(sender), thefile);
  end;
end;

procedure THistoryFiles.ClearMenu(MainMenu: TMenuItem);
var i : integer;
begin
  for i:= 1 to FNumberOfItems do
    MainMenu.items[FPosition].destroy;

  FNumberOfItems:=0;
  FCount:=0;
  FItems.Clear;
end;

procedure THistoryFiles.UpdateList(thefile: string);
 var
  A, B: string;
  n: integer;
  LocalIniFile : TIniFile;
  NewList : TStringList;
begin
 NewList := TStringList.Create;
 LocalIniFile := TIniFile.create(FIniFile);
try
 NewList.Clear;

 A := thefile;

 if ExtractFilePath(A)='' then
   A:=FLocalPath+A;

 NewList.Add(A);

 for n:= 1 to FMaxItems do
 begin
   B := LocalIniFile.ReadString(FIniKey, inttostr(n), '');
   if (Upper(B) <> Upper(A)) and (NewList.Count<=FMaxItems) and (trim(B)<>'') then
       NewList.Add(B);
 end;

 if FSorted then
   NewList.Sort;

 for n:=NewList.Count+1 to FMaxItems do
   NewList.Add('');

 for n:=0 to NewList.Count-1 do
   LocalIniFile.WriteString(FIniKey, inttostr(n+1), NewList.Strings[n]);

 UpdateParentMenu;
finally
  NewList.Free;
  LocalIniFile.Free;
end;
end;

procedure THistoryFiles.UpdateParentMenu;
var
  LocalIniFile : TIniFile;
  NewItem: TMenuItem;
  ItemNumber, A, B, wipe: string;
  n, m: integer;
  bSepTop : boolean;
  sFile : string;
  s : string;
begin

if AsSigned(FParentMenu) then
begin
  bSepTop:=False;

  LocalIniFile := TIniFile.create(FIniFile);
  try
    ClearMenu(FParentMenu);

    for n := 1 to FMaxItems do
    begin
      ItemNumber := inttostr(n);

      repeat
        A := LocalIniFile.ReadString(FIniKey, ItemNumber, '');
        sFile:=A;

        if A<>'' then
        begin
          if FFileMustExist and not fileexists(sFile) then
          begin
            for m := strtoint(ItemNumber) to FMaxItems do
              begin
                B := LocalIniFile.ReadString(FIniKey, inttostr(m+1), '');
                LocalIniFile.WriteString(FIniKey, inttostr(m), B);
                wipe := inttostr(m+1);
              end;
              LocalIniFile.WriteString(FIniKey,wipe,'');
            end;
          end;
      until (A='') or ((A<>'') and not(FFileMustExist)) or ((A<>'') and fileexists(sFile));

      if A<>'' then
      begin
        if (FSeparator in [sepTop,sepBoth]) and not(bSepTop) then
        begin
          bSepTop:=True;
          NewItem := TMenuItem.Create(FParentMenu);
          NewItem.Caption := '-';
          FParentMenu.insert(FPosition+FNumberOfItems,NewItem);
          Inc(FNumberOfItems);
        end;

        NewItem := TMenuItem.Create(FParentMenu);

        if FShowFullPath then
          begin
            if Upper(ExtractFilePath(A))=Upper(FLocalPath) then
              s := ExtractFileName(A)
            else
              s:=A;
          end
        else
          s:=ExtractFileName(A);

        if FShowNumber then
          NewItem.Caption := '&'+ ItemNumber + ' ' + s
        else
          NewItem.Caption := s;

        {$IFDEF FPC}
           NewItem.onclick :=  @OnMainMenuClickHistoryItem; //Lazarus
        {$ELSE}
           NewItem.onclick :=  OnMainMenuClickHistoryItem;
        {$ENDIF}

        NewItem.tag := n;

        FItems.Add(A);

        FParentMenu.Insert(FPosition+FNumberOfItems,NewItem);

        if AsSigned(FOnHistoryCreateItem) then
          FOnHistoryCreateItem(Self,NewItem,A);

        Inc(FNumberOfItems);
        Inc(FCount);
      end;
    end;

    if (FSeparator in [sepBottom,sepBoth]) and (FNumberOfItems>0) then
    begin
      NewItem := TMenuItem.Create(FParentMenu);
      NewItem.Caption := '-';
      FParentMenu.insert(FPosition+FNumberOfItems,NewItem);
      Inc(FNumberOfItems);
    end;
  finally
    LocalIniFile.Free;
  end;
end
  else
    MessageDlg(MsgParentMenuNotAssigned, mtError, [mbOk], 0);
end;

{$IFDEF FPC} //Lazarus
  initialization
    {$i HistoryLazarus.lrs}
{$ENDIF}
end.