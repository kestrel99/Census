{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit brkapart; 

interface

uses
  BreakApart, LazarusPackageIntf;

implementation

procedure Register; 
begin
  RegisterUnit('BreakApart', @BreakApart.Register); 
end; 

initialization
  RegisterPackage('brkapart', @Register); 
end.
