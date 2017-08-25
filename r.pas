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

unit r;

{$mode delphi}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, blcksock;

type

  { TfrmR }

  TfrmR = class(TForm)
    Button1: TButton;
    stBar: TStatusBar;
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    function parse_SEXP(buf: String; offset: Integer): string ;
    function Rserve_eval(socket: TTCPBlockSocket; command: string): string;
    function mkp_str(cmd: Integer; str: string): string;
    function int8(buf: string; o: Integer): Integer;
    function int24(buf: string; o: Integer): Integer;
    function int32(buf: string; o: Integer): Integer;
    function mkint32(i: Integer): string;
    function mkint24(i: Integer): string;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmR: TfrmR;
  sockR: TTCPBlockSocket;

implementation

{$R *.lfm}

{ TfrmR }

procedure TfrmR.Button1Click(Sender: TObject);
var
  z: string;
begin
  z := Rserve_eval(sockR, '5+5');
  ShowMessage(z);

end;

procedure TfrmR.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  sockR.Free;
  CloseAction := caFree;
  frmR := nil;
end;

procedure TfrmR.FormCreate(Sender: TObject);
var
  s: string;
begin
  sockR := TTCPBlockSocket.Create;
  try
    sockR.Connect('127.0.0.1','6311');
    s := sockR.recvstring(15000);
    ShowMessage(s);
  except
    MessageDlg('Error connecting to Rserve', mtError, [mbOK], 0);
  end;
  stBar.Panels[0].Text := 'Connected to Rserve at 127.0.0.1:6311 - ' + s;

end;

// parse SEXP results -- limited implementation for now (large packets and some data types are not supported)
function TfrmR.parse_SEXP(buf: String; offset: Integer): string ;
var
  r, attr: string;
  i, ra, rl, eoa, al: Integer;
  a: array of string;
begin
  r := buf;
  i := offset;

  ra := int8(r, i);
  rl := int24(r, i + 1);
  i := i + 4;

  eoa := offset;
  offset := i + rl;

  if ((ra and 64) = 64) then
  begin
    ShowMessage('sorry, long packets are not supported (yet).');
    Result := '' ;
  end;

  if (ra > 127) then
  begin
    ra := ra and 127;
    al := int24(r, i + 1);
    attr := parse_SEXP(buf, i);
    i := i + al + 4;
  end;

  if (ra = 0) then
    Result := '';

  //if (ra = 16) then
  //begin
    //a = array();
    //while ($i < $eoa)
    //    $a[] = parse_SEXP($buf, /* & */ $i);
    //// if the 'names' attribute is set, convert the plain array into a map
    //if (isset($attr['names'])) {
    //    $names = $attr['names']; $na = array(); $n = count($a);
    //    for ($k = 0; $k < $n; $k++) $na[$names[$k]] = $a[$k];
    //    return $na;
    //}
  //end;
//
//	return $a;
//    }
 //   if (ra = 19) { // symbol
	//$oi = $i; while ($i < $eoa && ord($r[$i]) != 0) $i++;
	//return substr($buf, $oi, $i - $oi);
 //   }
 //   if ($ra == 20 || $ra == 22) { // pairlist w/o tags
	//$a = array();
	//while ($i < $eoa) $a[] = parse_SEXP($buf, /* & */ $i);
	//return $a;
 //   }
 //   if ($ra == 21 || $ra == 23) { // pairlist with tags
	//$a = array();
	//while ($i < $eoa) { $val = parse_SEXP($buf, /* & */ $i); $tag = parse_SEXP($buf, /* & */ $i); $a[$tag] = $val; }
	//return $a;
 //   }
 //   if ($ra == 32) { // integer array
	//$a = array();
	//while ($i < $eoa) { $a[] = int32($r, $i); $i += 4; }
	//if (count($a) == 1) return $a[0];
 // end;
  Result := r;
//end;
//
// return $a;
//    }
//    if ($ra == 33) { // double array
//	$a = array();
//	while ($i < $eoa) { $a[] = flt64($r, $i); $i += 8; }
//	if (count($a) == 1) return $a[0];
//	return $a;
//    }
//    if ($ra == 34) { // string array
//        $a = array();
//	$oi = $i;
//	while ($i < $eoa) {
//	    if (ord($r[$i]) == 0) {
//		$a[] = substr($r, $oi, $i - $oi);
//		$oi = $i + 1;
//	    }
//	    $i++;
//	}
//	if (count($a) == 1) return $a[0];
//	return $a;
//    }
//    if ($ra == 36) { // boolean vector
//	$n = int32($r, $i); $i += 4; $k = 0;
//	$a = array();
//	while ($k < $n) { $v = int8($r, $i++); $a[$k++] = ($v == 1) ? TRUE : (($v == 0) ? FALSE : NULL); }
//	if ($n == 1) return $a[0];
//	return $a;
//    }
//    if ($ra == 37) { // raw vector
//	$len = int32($r, $i); $i += 4;
//	return substr($r, $i, $len);
//    }
//    if ($ra == 48) { // unimplemented type in Rserve
//	$uit = int32($r, $i);
//	// echo "Note: result contains type #$uit unsupported by Rserve.<br/>";
//	return NULL;
//    }
//    echo "Warning: type ".$ra." is currently not implemented in the PHP client.";
//    return FALSE;
end;


function TfrmR.Rserve_eval(socket: TTCPBlockSocket; command: string): string;
var
  pkt, r: string;
  i, res, sc, rr: Integer;
begin
  pkt := mkp_str(3, command);
  ShowMessage(pkt);
  sockR.SendBlock(pkt);
  r := sockR.RecvString(15000);
  res := int32(r, 0);
  sc := (res Shr 24) and 127;
  rr := res and 255;
  if (rr <> 1) then
  begin
    ShowMessage('eval failed with error code ' + IntToStr(sc));
    Result := '';
  end;
  if (int8(r, 17) <> 10) then
  begin
    ShowMessage('invalid response (expecting SEXP)');
    Result := '';
  end;

  i := 20;

  Result := parse_SEXP(r, i);
end;

function TfrmR.mkp_str(cmd: Integer; str: string): string;
var
  n: integer;
begin
    n := Length(str) + 1;
    str := str + #0;
    while ((n and 3) <> 0) do
    begin
      str := str + #1;
      n := n + 1;
    end;

    Result := mkint32(cmd) + mkint32(n + 4) + mkint32(0) + mkint32(0) + #4 + mkint24(n) + str;
end;

function TfrmR.int8(buf: string; o: Integer): Integer;
begin
  Result := Ord(buf[o]);
end;

function TfrmR.int24(buf: string; o: Integer): Integer;
begin
  Result := (Ord(buf[o]) or (ord(buf[o + 1]) Shl 8) or (ord(buf[o + 2]) Shl 16));
end;

function TfrmR.int32(buf: string; o: Integer): Integer;
begin
  Result := (Ord(buf[o]) or (Ord(buf[o + 1]) Shl 8) or (Ord(buf[o + 2]) Shl 16) or (Ord(buf[o + 3]) Shl 24));
end;

function TfrmR.mkint32(i: Integer): string;
var
  r: string;
begin
  r := Chr(i and 255);
  i := i Shr 8;
  r := r + Chr(i and 255);
  i := i Shr 8;
  r := r + Chr(i and 255);
  i := i Shr 8;
  r := r + Chr(i and 255);
  Result := r;
end;

function TfrmR.mkint24(i: Integer): string;
var
  r: string;
begin
  r := Chr(i and 255);
  i := i Shr 8;
  r := r + Chr(i and 255);
  i := i Shr 8;
  r := r + Chr(i and 255);
  Result := r;
end;

//function TfrmR.flt64(buf: string, o: Integer): ;
//begin
//  ss := Copy(buf, o, 8);
//  if (machine_is_bigendian) then
//    for k := 0 to 6 do
//      ss[7 - k] := buf[o + k];
//      r := unpack("d", substr($buf, $o, 8)); return $r[1]; }
//end;

end.

