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

unit xml;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  StdCtrls, DOM, XMLRead, XMLWrite, XMLCfg, XMLUtils,
  XMLStreaming;

type

  { TfrmXML }

  TfrmXML = class(TForm)
    Button1: TButton;
    Memo: TMemo;
    TreeView1: TTreeView;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  frmXML: TfrmXML;

implementation

{$R *.lfm}

{ TfrmXML }

procedure TfrmXML.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmXML.FormShow(Sender: TObject);
var
  Doc: TXMLDocument;
  Child: TDOMNode;
  j: Integer;
begin
  try
    ReadXMLFile(Doc, '/Users/justin/projects/wxCensus/F_FLAG04est2b.xml');
    Memo.Lines.Clear;
    // using FirstChild and NextSibling properties
    Child := Doc.DocumentElement.FirstChild;
    while Assigned(Child) do
    begin
      Memo.Lines.Add(Child.NodeName + ' ' + Child.Attributes.Item[0].NodeValue);
      // using ChildNodes method
      with Child.ChildNodes do
      try
        for j := 0 to (Count - 1) do
          Memo.Lines.Add(format('%s %s (%s=%s; %s=%s)',
                                [
                                  Item[j].NodeName,
                                  Item[j].FirstChild.NodeValue,
                                  Item[j].Attributes.Item[0].NodeName,  // 1st attribute details
                                  Item[j].Attributes.Item[0].NodeValue,
                                  Item[j].Attributes.Item[1].NodeName,  // 2nd attribute details
                                  Item[j].Attributes.Item[1].NodeValue
                                ]));
      finally
        Free;
      end;
      Child := Child.NextSibling;
    end;
  finally
    Doc.Free;
  end;
end;

end.

