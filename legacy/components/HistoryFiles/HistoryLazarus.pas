{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit HistoryLazarus; 

interface

uses
  HistoryFiles, LazarusPackageIntf;

implementation

procedure Register; 
begin
  RegisterUnit('HistoryFiles', @HistoryFiles.Register); 
end; 

initialization
  RegisterPackage('HistoryLazarus', @Register); 
end.
