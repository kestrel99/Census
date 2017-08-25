{ -------------------------------------------------------------------------------------}
 { A "break apart strings" component for CodeGear Delphi 2007/2009.                     }
 { Copyright 1999-2009, Jean-Fabien Connault and Patrick Brisacier. All Rights Reserved.}
 { This component can be freely used and distributed in commercial and private          }
 { environments, provided this notice is not modified in any way.                       }
 { -------------------------------------------------------------------------------------}
 { Feel free to contact us if you have any questions, comments or suggestions at:       }
 {   cycocrew@orange.fr (Jean-Fabien Connault)                                          }
 { You can always find the latest version of this component at:                         }
 {   http://pagesperso-orange.fr/cycocrew/delphi/components.html                        }
 { -------------------------------------------------------------------------------------}
 { Date last modified:  2009.07.13                                                      }
 { -------------------------------------------------------------------------------------}

 { -------------------------------------------------------------------------------------}
 { TJFCBreakApart v1.07                                                                 }
 { -------------------------------------------------------------------------------------}
 { Description:                                                                         }
 {   A component that allows you to break apart strings.                                }
 { Properties:                                                                          }
 {   property AllowEmptyString: Boolean;                                                }
 {   property BreakString: string;                                                      }
 {   property BaseString: string;                                                       }
 {   property CaseSensitive: Boolean;                                                   }
 {   property DoubleQuoteMode: Boolean;                                                 }
 {   property StringList: TStringList;                                                  }
 { Procedures and functions:                                                            }
 {   procedure BreakApart;                                                              }
 {   procedure ReverseBreakApart;                                                       }
 { -------------------------------------------------------------------------------------}
 { See example contained in example.zip file for more details.                          }
 { -------------------------------------------------------------------------------------}
 { Revision History:                                                                    }
 { 1.00:  + Initial release                                                             }
 { 1.01:  + Added CaseSensitive property                                                }
 { 1.02:  + Changed Register page to "System" (2001.06.16)                              }
 { 1.03:  + Cosmetic changes (2001.08.13)                                               }
 { 1.04:  + Added CodeGear Delphi 2007 support (2007.05.25)                             }
 { 1.05:  + Renamed component to TJFCBreakApart (2008.09.23)                            }
 {        + Renamed unit to JFCBreakApart (2008.09.23)                                  }
 { 1.06:  + Added CodeGear Delphi 2009 support (2008.11.04)                             }
 { 1.07:  + Added DoubleQuoteMode property (2009.07.13)                                 }
 { -------------------------------------------------------------------------------------}

// converted to Lazarus by Justin Wilkins, August 2011

unit BreakApart;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs;

type
  TBreakApart = class(TComponent)
  private
    { Private declarations }
    FAllowEmptyString: Boolean;
    FBaseString: string;
    FBreakString: string;
    FCaseSensitive: Boolean;
    FDoubleQuoteMode: Boolean;
    FStringList: TStringList;
    procedure SetStringList(AStringList: TStringList);
  protected
    { Protected declarations }
  public
    { Public declarations }
    property StringList: TStringList read FStringList write SetStringList;
    procedure BreakApart;
    procedure ReverseBreakApart;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
    property AllowEmptyString: Boolean read FAllowEmptyString write FAllowEmptyString;
    property BreakString: string read FBreakString write FBreakString;
    property BaseString: string read FBaseString write FBaseString;
    property CaseSensitive: Boolean read FCaseSensitive write FCaseSensitive;
    property DoubleQuoteMode: Boolean read FDoubleQuoteMode write FDoubleQuoteMode;
  end;

procedure Register;

implementation

procedure Register;
begin
  {$I breakapart_icon.lrs}
  RegisterComponents('Custom',[TBreakApart]);
end;

{*****************************************************************************}
{* CONSTRUCTOR                                                               *}
{*****************************************************************************}

constructor TBreakApart.Create(AOwner: TComponent);
begin
 inherited Create(AOwner);
 FStringList := TStringList.Create;
end;

{*****************************************************************************}
{* DESTRUCTOR                                                                *}
{*****************************************************************************}

destructor TBreakApart.Destroy;
begin
 FStringList.Free;
 inherited Destroy;
end;

{*****************************************************************************}
{* PROCEDURE SetStringList                                                   *}
{*****************************************************************************}

procedure TBreakApart.SetStringList(AStringList: TStringList);
begin
 FStringList.Assign(AStringList);
end;

{*****************************************************************************}
{* PROCEDURE BreakApart                                                      *}
{*****************************************************************************}

procedure TBreakApart.BreakApart;
var
 EndOfCurrentString, i: integer;
 TempStr, TempBaseString: string;
 StartMerge: Boolean;

 function CountDoubleQuotes(AString: string): integer;
 var
   i: integer;
 begin
   Result := 0;
   for i := 1 to Length(AString) do
     if (AString[i] = '"') then
       inc(Result);
 end;

begin
 FStringList.Clear;
 TempBaseString := FBaseString;

 repeat
   if (FCaseSensitive = True) then
     EndOfCurrentString := pos(FBreakString, TempBaseString)
   else
     EndOfCurrentString := pos(lowerCase(FBreakString), lowerCase(TempBaseString));

   if (EndOfCurrentString = 0) then
     TempStr := TempBaseString
   else
     TempStr := Copy(TempBaseString, 1, EndOfCurrentString - 1);

   if ((TempStr = '') and (FAllowEmptyString = True)) or (TempStr <> '') then
     FStringList.add(TempStr);

   TempBaseString := Copy(TempBaseString, EndOfCurrentString +
     Length(FBreakString), Length(TempBaseString) - EndOfCurrentString);
 until EndOfCurrentString = 0;

 if (FDoubleQuoteMode = True) then
 begin
   i := 0;
   StartMerge := False;
   while (i < FStringList.Count - 1) do
   begin
     if Odd(CountDoubleQuotes(FStringList[i])) and
       (pos('"', FStringList[i]) = 1) and (StartMerge = False) then
     begin
       StartMerge := True;
       inc(i);
     end;

     if (StartMerge = True) then
     begin
       FStringList[i - 1] := FStringList[i - 1] + FBreakString + FStringList[i];

       if (CountDoubleQuotes(FStringList[i]) = 1) and
         (pos('"', FStringList[i]) = Length(FStringList[i])) then
         StartMerge := False;

       FStringList.Delete(i);
     end
     else
       inc(i);
   end;
 end;
end;

{*****************************************************************************}
{* PROCEDURE ReverseBreakApart                                               *}
{*****************************************************************************}

procedure TBreakApart.ReverseBreakApart;
var
 i: integer;
begin
 if (FStringList.Count > 0) then
 begin
   FBaseString := FStringList[0];
   for i := 1 to FStringList.Count - 1 do
     if ((FStringList[i] = '') and (FAllowEmptyString = True)) or
       (FStringList[i] <> '') then
         FBaseString := FBaseString + FBreakString + FStringList[i];
 end
 else
   FBaseString := '';
end;


end.
