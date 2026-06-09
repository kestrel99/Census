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

unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ButtonPanel, ComCtrls, ExtCtrls, DBGrids, Grids, StdCtrls, DbCtrls, ActnList,
  IDEWindowIntf, SynEdit, SynHighlighterXML, SynHighlighterAny, db, BufDataset,
  ZConnection, ZDataset, ZSqlUpdate, BreakApart, HistoryFiles, DOM, XMLRead,
  Math, XMLUtils, RegExpr, md5, types, IniFiles, Zipper, LResources;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    actExport: TAction;
    actRunRec: TAction;
    actList: TActionList;
    brkUpp: TBreakApart;
    btnDelete: TToolButton;
    btnImport: TToolButton;
    btnImportFolder: TToolButton;
    btnNew: TToolButton;
    btnOpen: TToolButton;
    btnPlot: TToolButton;
    btnPrefs: TToolButton;
    btnQuit: TToolButton;
    btnReport: TToolButton;
    btnDetails: TButton;
    btnPsNAdd: TButton;
    btnPsNDelete: TButton;
    chkExpanded: TCheckBox;
    dlgDir: TSelectDirectoryDialog;
    grdCnv: TStringGrid;
    grdExt: TStringGrid;
    grdPhi: TStringGrid;
    grdPhm: TStringGrid;
    grdShk: TStringGrid;
    grdGrd: TStringGrid;
    grdOmega: TDBGrid;
    dlgColor: TColorDialog;
    dlgPsN: TOpenDialog;
    dsPsN: TDatasource;
    grdOmegaCorrMatrix: TStringGrid;
    grdOmegaMatrix: TStringGrid;
    grdOmegaInitMatrix: TStringGrid;
    grdRuns: TDBGrid;
    grdSigmaInitMatrix: TStringGrid;
    grdSigmaCorrMatrix: TStringGrid;
    grdSigmaSEMatrix: TStringGrid;
    grdSigmaMatrix: TStringGrid;
    grdOmegaSEMatrix: TStringGrid;
    grdPsN: TDBGrid;
    grdSigma: TDBGrid;
    histFiles: THistoryFiles;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label2: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    itmKey: TMenuItem;
    memNMTran: TSynEdit;
    memProbInfo: TSynEdit;
    MenuItem12: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem17: TMenuItem;
    MenuItem18: TMenuItem;
    MenuItem19: TMenuItem;
    MenuItem20: TMenuItem;
    MenuItem21: TMenuItem;
    MenuItem22: TMenuItem;
    MenuItem23: TMenuItem;
    MenuItem24: TMenuItem;
    mnuExportRunRec: TMenuItem;
    mnuArchive: TMenuItem;
    mnuArchiveS: TMenuItem;
    mnuArchiveAll: TMenuItem;
    mnuImport: TMenuItem;
    mnuImportFolder: TMenuItem;
    mnuDelete: TMenuItem;
    MenuItem29: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    mnuExportLatex: TMenuItem;
    mnuAbout: TMenuItem;
    pgcTables: TPageControl;
    Panel12: TPanel;
    Panel15: TPanel;
    Panel18: TPanel;
    Panel39: TPanel;
    Panel40: TPanel;
    Panel41: TPanel;
    Panel42: TPanel;
    Panel43: TPanel;
    Panel44: TPanel;
    Panel45: TPanel;
    Panel46: TPanel;
    Panel47: TPanel;
    Panel48: TPanel;
    Panel49: TPanel;
    Panel50: TPanel;
    pgcSigma: TPageControl;
    pgcOmega: TPageControl;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel13: TPanel;
    Panel14: TPanel;
    Panel16: TPanel;
    Panel17: TPanel;
    Panel19: TPanel;
    Panel20: TPanel;
    Panel22: TPanel;
    Panel23: TPanel;
    Panel25: TPanel;
    Panel26: TPanel;
    Panel28: TPanel;
    Panel29: TPanel;
    Panel31: TPanel;
    Panel32: TPanel;
    Panel34: TPanel;
    Panel35: TPanel;
    Panel37: TPanel;
    Panel38: TPanel;
    Panel4: TPanel;
    grdData: TStringGrid;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    anySyn: TSynAnySyn;
    mnuRuns: TPopupMenu;
    mnuCopy: TPopupMenu;
    qryEstCenteredEta: TLongintField;
    qryEstComments: TMemoField;
    qryEstCondEst: TLongintField;
    qryEstConditionNumber: TFloatField;
    qryEstCorrMatrix: TMemoField;
    qryEstCovariance: TMemoField;
    qryEstCovElapsedTime: TFloatField;
    qryEstCovMatrix: TMemoField;
    qryEstCovShort: TMemoField;
    qryEstCovStep: TMemoField;
    qryEstDF: TFloatField;
    qryEstdOFV: TFloatField;
    qryEstEigenvalues: TMemoField;
    qryEstEstElapsedTime: TFloatField;
    qryEstEstNo: TLongintField;
    qryEstFnEvals: TLongintField;
    qryEstGoalFunction: TMemoField;
    qryEstIAccept: TFloatField;
    qryEstID: TLongintField;
    qryEstInteraction: TLongintField;
    qryEstInvCovMatrix: TMemoField;
    qryEstISample: TLongintField;
    qryEstISampleM1: TLongintField;
    qryEstISampleM2: TLongintField;
    qryEstISampleM3: TLongintField;
    qryEstKeyEst: TLongintField;
    qryEstLaplacian: TLongintField;
    qryEstMethLong: TMemoField;
    qryEstMethod: TMemoField;
    qryEstMinimization: TMemoField;
    qryEstMinShort: TMemoField;
    qryEstNBurn: TFloatField;
    qryEstNIter: TLongintField;
    qryEstNSIG: TLongintField;
    qryEstOAccept: TFloatField;
    qryEstOFV: TFloatField;
    qryEstOFVType: TMemoField;
    qryEstOmegaCorrMatrix: TMemoField;
    qryEstOmegaCSEMatrix: TMemoField;
    qryEstOmegaInitMatrix: TMemoField;
    qryEstOmegaMatrix: TMemoField;
    qryEstOmegaSEMatrix: TMemoField;
    qryEstOSampleM1: TLongintField;
    qryEstOSampleM2: TLongintField;
    qryEstPAccept: TFloatField;
    qryEstParentNo: TMemoField;
    qryEstPSampleM1: TLongintField;
    qryEstPSampleM2: TLongintField;
    qryEstPSampleM3: TLongintField;
    qryEstRunNo: TMemoField;
    qryEstSeed: TLongintField;
    qryEstSigDigits: TMemoField;
    qryEstSIGL: TLongintField;
    qryEstSigmaCorrMatrix: TMemoField;
    qryEstSigmaCSEMatrix: TMemoField;
    qryEstSigmaInitMatrix: TMemoField;
    qryEstSigmaMatrix: TMemoField;
    qryEstSigmaSEMatrix: TMemoField;
    qryEstTimestamp: TLongintField;
    qryEstTOL: TLongintField;
    qryEstUser: TMemoField;
    qryEstWarnings: TMemoField;
    qryOmegaBlocks: TLongintField;
    qryOmegaEstNo: TLongintField;
    qryOmegaEtaBar: TMemoField;
    qryOmegaEtaBarSE: TMemoField;
    qryOmegaEtaPVal: TMemoField;
    qryOmegaEtaShrinkage: TMemoField;
    qryOmegaID: TLongintField;
    qryOmegaOmega: TLongintField;
    qryOmegaOmegaCILower: TFloatField;
    qryOmegaOmegaCIs: TMemoField;
    qryOmegaOmegaCIUpper: TFloatField;
    qryOmegaOmegaCRSE: TFloatField;
    qryOmegaOmegaCSE: TFloatField;
    qryOmegaOmegaInit: TFloatField;
    qryOmegaOmegaLabel: TMemoField;
    qryOmegaOmegaModel: TMemoField;
    qryOmegaOmegaPerc: TFloatField;
    qryOmegaOmegaRSE: TFloatField;
    qryOmegaOmegaSE: TFloatField;
    qryOmegaOmegaSigDig: TFloatField;
    qryOmegaOmegaValue: TFloatField;
    qryOmegaRunNo: TMemoField;
    qryOmegaTimestamp: TLongintField;
    qryOmegaUser: TMemoField;
    qryPsNCommand: TMemoField;
    qryPsNDirectory: TMemoField;
    qryPsNID: TLongintField;
    qryPsNiRunNo: TLongintField;
    qryPsNPDF: TMemoField;
    qryPsNPsNVersion: TMemoField;
    qryPsNRawFile: TMemoField;
    qryPsNResultsFile: TMemoField;
    qryPsNRunNo: TMemoField;
    qryPsNTimestamp: TLongintField;
    qryPsNTool: TMemoField;
    qryPsNUser: TMemoField;
    qryRunscatab: TMemoField;
    qryRunscatabMD5: TMemoField;
    qryRunscnv: TMemoField;
    qryRunscnvMD5: TMemoField;
    qryRunscoi: TMemoField;
    qryRunscoiMD5: TMemoField;
    qryRunsComment: TMemoField;
    qryRunsComments: TMemoField;
    qryRunsConditionNumber: TFloatField;
    qryRunsControlStream: TMemoField;
    qryRunscor: TMemoField;
    qryRunscorMD5: TMemoField;
    qryRunscotab: TMemoField;
    qryRunscotabMD5: TMemoField;
    qryRunscov: TMemoField;
    qryRunsCovariateModel: TMemoField;
    qryRunscovMD5: TMemoField;
    qryRunsCovTime: TFloatField;
    qryRunsCtlFile: TMemoField;
    qryRunsCtlFileMD5: TMemoField;
    qryRunscwtab: TMemoField;
    qryRunscwtabDeriv: TMemoField;
    qryRunscwtabDerivMD5: TMemoField;
    qryRunscwtabEst: TMemoField;
    qryRunscwtabEstMD5: TMemoField;
    qryRunscwtabMD5: TMemoField;
    qryRunsData: TMemoField;
    qryRunsDataFile: TMemoField;
    qryRunsDataFileMD5: TMemoField;
    qryRunsDescription: TMemoField;
    qryRunsdOFV: TFloatField;
    qryRunsEstimation: TMemoField;
    qryRunsEstTime: TFloatField;
    qryRunsext: TMemoField;
    qryRunsextMD5: TMemoField;
    qryRunsFitFile: TMemoField;
    qryRunsFitFileMD5: TMemoField;
    qryRunsFnEvals: TLongintField;
    qryRunsgrd: TMemoField;
    qryRunsgrdMD5: TMemoField;
    qryRunsID: TLongintField;
    qryRunsIIV: TMemoField;
    qryRunsIndividuals: TLongintField;
    qryRunsIOV: TMemoField;
    qryRunsiRunNo: TLongintField;
    qryRunsKeyRun: TLongintField;
    qryRunsLabel: TMemoField;
    qryRunsMinimization: TMemoField;
    qryRunsMinShort: TMemoField;
    qryRunsModel: TMemoField;
    qryRunsModelMD5: TMemoField;
    qryRunsMSF: TMemoField;
    qryRunsMSFMD5: TMemoField;
    qryRunsmutab: TMemoField;
    qryRunsmutabMD5: TMemoField;
    qryRunsmytab: TMemoField;
    qryRunsmytabMD5: TMemoField;
    qryRunsNMTran: TMemoField;
    qryRunsObsRecs: TLongintField;
    qryRunsOFV: TFloatField;
    qryRunsOutputFile: TMemoField;
    qryRunsOutputFileMD5: TMemoField;
    qryRunsParentNo: TMemoField;
    qryRunspatab: TMemoField;
    qryRunspatabMD5: TMemoField;
    qryRunsphi: TMemoField;
    qryRunsphiMD5: TMemoField;
    qryRunsphm: TMemoField;
    qryRunsphmMD5: TMemoField;
    qryRunsProblemInfo: TMemoField;
    qryRunsrmt: TMemoField;
    qryRunsrmtMD5: TMemoField;
    qryRunsRunNo: TMemoField;
    qryRunsRV: TMemoField;
    qryRunssdtab: TMemoField;
    qryRunssdtabMD5: TMemoField;
    qryRunsshk: TMemoField;
    qryRunsshkMD5: TMemoField;
    qryRunsSigDigits: TFloatField;
    qryRunssmt: TMemoField;
    qryRunssmtMD5: TMemoField;
    qryRunsStartTime: TMemoField;
    qryRunsStopTime: TMemoField;
    qryRunsStructuralModel: TMemoField;
    qryRunsTimestamp: TLongintField;
    qryRunstxt: TMemoField;
    qryRunstxtMD5: TMemoField;
    qryRunsUser: TMemoField;
    qryRunsWarnings: TMemoField;
    qryRunsXML: TMemoField;
    qryRunsXMLMD5: TMemoField;
    qrySigmaBlocks: TLongintField;
    qrySigmaEpsilonShrinkage: TMemoField;
    qrySigmaEstNo: TLongintField;
    qrySigmaID: TLongintField;
    qrySigmaRunNo: TMemoField;
    qrySigmaSigma: TLongintField;
    qrySigmaSigmaCILower: TFloatField;
    qrySigmaSigmaCIs: TMemoField;
    qrySigmaSigmaCIUpper: TFloatField;
    qrySigmaSigmaCRSE: TFloatField;
    qrySigmaSigmaCSE: TFloatField;
    qrySigmaSigmaInit: TFloatField;
    qrySigmaSigmaLabel: TMemoField;
    qrySigmaSigmaModel: TMemoField;
    qrySigmaSigmaRSE: TFloatField;
    qrySigmaSigmaSE: TFloatField;
    qrySigmaSigmaSigDig: TFloatField;
    qrySigmaSigmaValue: TFloatField;
    qrySigmaTimestamp: TLongintField;
    qrySigmaUser: TMemoField;
    qryThetaEstNo: TLongintField;
    qryThetaID: TLongintField;
    qryThetaInitial: TFloatField;
    qryThetaLower: TFloatField;
    qryThetaModel: TMemoField;
    qryThetaRunNo: TMemoField;
    qryThetaTheta: TLongintField;
    qryThetaThetaCILower: TFloatField;
    qryThetaThetaCIs: TMemoField;
    qryThetaThetaCIUpper: TFloatField;
    qryThetaThetaLabel: TMemoField;
    qryThetaThetaMatrix: TMemoField;
    qryThetaThetaRSE: TFloatField;
    qryThetaThetaSE: TFloatField;
    qryThetaThetaSigDig: TFloatField;
    qryThetaThetaValue: TFloatField;
    qryThetaTimestamp: TLongintField;
    qryThetaUpper: TFloatField;
    qryThetaUser: TMemoField;
    qryTransAction: TMemoField;
    qryTransID: TLongintField;
    qryTransRunNo: TMemoField;
    qryTransTimestamp: TLongintField;
    qryTransUser: TMemoField;
    dlgR: TSaveDialog;
    dlgZip: TSaveDialog;
    Splitter3: TSplitter;
    synCor: TSynEdit;
    synCoi: TSynEdit;
    memCtl: TSynEdit;
    memSummary: TSynEdit;
    synPatab: TSynEdit;
    synCatab: TSynEdit;
    synCotab: TSynEdit;
    synMytab: TSynEdit;
    synMutab: TSynEdit;
    synSdtab: TSynEdit;
    synXML: TSynEdit;
    synPhm: TSynEdit;
    synShk: TSynEdit;
    synPhi: TSynEdit;
    synExt: TSynEdit;
    synCov: TSynEdit;
    synGrd: TSynEdit;
    synCnv: TSynEdit;
    synRmt: TSynEdit;
    synSmt: TSynEdit;
    tabPsN: TTabSheet;
    tabOmegaEstimates: TTabSheet;
    tabOmegaMatrix: TTabSheet;
    tabOmegaSEMatrix: TTabSheet;
    tabOmegaInitMatrix: TTabSheet;
    tabOmegaCorrMatrix: TTabSheet;
    tabSdtab: TTabSheet;
    tabPatab: TTabSheet;
    tabCatab: TTabSheet;
    tabCotab: TTabSheet;
    tabMytab: TTabSheet;
    tabMutab: TTabSheet;
    tabExtC: TTabSheet;
    tabphiC: TTabSheet;
    tabPhmC: TTabSheet;
    tabcnvC: TTabSheet;
    tabShkC: TTabSheet;
    tabGrdC: TTabSheet;
    tabTables: TTabSheet;
    tabSigmaCorrMatrix: TTabSheet;
    tabSigmaMatrix: TTabSheet;
    tabSigmaSEMatrix: TTabSheet;
    tabSigmaInitMatrix: TTabSheet;
    tabSigmaEstimates: TTabSheet;
    btnCompare: TToolButton;
    timScreen: TTimer;
    btnRunRec: TToolButton;
    ToolButton11: TToolButton;
    tvRuns: TTreeView;
    txtPatab: TDBText;
    txtPatabMD5: TDBText;
    txtCatab: TDBText;
    txtCatabMD5: TDBText;
    txtCotab: TDBText;
    txtCotabMD5: TDBText;
    txtMytab: TDBText;
    txtMytabMD5: TDBText;
    txtMutab: TDBText;
    txtMutabMD5: TDBText;
    txtSdtab: TDBText;
    txtSdtabMD5: TDBText;
    xmlSyn: TSynXMLSyn;
    tabCov: TTabSheet;
    tabCor: TTabSheet;
    tabCoi: TTabSheet;
    tabPhi: TTabSheet;
    tabRmt: TTabSheet;
    tabSmt: TTabSheet;
    tabShk: TTabSheet;
    tabCnv: TTabSheet;
    tabGrd: TTabSheet;
    tabXML: TTabSheet;
    tabPhm: TTabSheet;
    txtCor: TDBText;
    txtCorMD5: TDBText;
    txtCoi: TDBText;
    txtCoiMD5: TDBText;
    txtXML: TDBText;
    txtXMLMD5: TDBText;
    txtPhm: TDBText;
    txtShk: TDBText;
    txtPhmMD5: TDBText;
    txtGrd: TDBText;
    txtCnv: TDBText;
    txtRmt: TDBText;
    txtRmtMD5: TDBText;
    txtSmt: TDBText;
    txtShkMD5: TDBText;
    txtPhi: TDBText;
    txtPhiMD5: TDBText;
    txtExt: TDBText;
    txtCov: TDBText;
    txtExtMD5: TDBText;
    txtCovMD5: TDBText;
    txtOutput: TDBText;
    txtData: TDBText;
    txtOutputMD5: TDBText;
    Label1: TLabel;
    grdEst: TDBGrid;
    dsEst: TDatasource;
    dsTheta: TDatasource;
    dsOmega: TDatasource;
    dsSigma: TDatasource;
    dsTrans: TDatasource;
    dsRuns: TDatasource;
    grdCorMatrix: TStringGrid;
    grdCovMatrix: TStringGrid;
    grdEigen: TStringGrid;
    grdInvCovMatrix: TStringGrid;
    grdTheta: TDBGrid;
    imgList: TImageList;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    mnuProperties: TMenuItem;
    MenuItem13: TMenuItem;
    mnuRestartR: TMenuItem;
    MenuItem15: TMenuItem;
    mnuExit: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    mnuNew: TMenuItem;
    mnuOpen: TMenuItem;
    mnuClose: TMenuItem;
    mnuRecent: TMenuItem;
    mnuMain: TMainMenu;
    dlgOpen: TOpenDialog;
    dlgImport: TOpenDialog;
    PageControl1: TPageControl;
    pgcFiles: TPageControl;
    Panel2: TPanel;
    Panel3: TPanel;
    pgcMisc: TPageControl;
    Panel1: TPanel;
    pgcBottom: TPageControl;
    pgcParams: TPageControl;
    pnlTop: TPanel;
    pgcMain: TPageControl;
    dlgNew: TSaveDialog;
    sbMain: TStatusBar;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    synOutput: TSynEdit;
    tabCorMatrix: TTabSheet;
    tabCovMatrix: TTabSheet;
    tabEigen: TTabSheet;
    tabInvCovMatrix: TTabSheet;
    tabMatrices: TTabSheet;
    tabMisc: TTabSheet;
    tabOmega: TTabSheet;
    tabOverview: TTabSheet;
    tabRunFiles: TTabSheet;
    TabSheet1: TTabSheet;
    tabMinSummary: TTabSheet;
    tabNMTran: TTabSheet;
    tabProbInfo: TTabSheet;
    tabControlStream: TTabSheet;
    tabOutput: TTabSheet;
    tabData: TTabSheet;
    tabExt: TTabSheet;
    tabSigma: TTabSheet;
    tabTheta: TTabSheet;
    tbMain: TToolBar;
    ToolButton10: TToolButton;
    ToolButton2: TToolButton;
    ToolButton6: TToolButton;
    txtDataMD5: TDBText;
    txtGrdMD5: TDBText;
    txtCnvMD5: TDBText;
    txtSmtMD5: TDBText;
    zConn: TZConnection;
    sqlCreate: TZQuery;
    sqlParent: TZQuery;
    qryGeneral: TZQuery;
    qryRuns: TZReadOnlyQuery;
    qryEst: TZReadOnlyQuery;
    qryTheta: TZReadOnlyQuery;
    qryOmega: TZReadOnlyQuery;
    qrySigma: TZReadOnlyQuery;
    qryTrans: TZReadOnlyQuery;
    qryPsN: TZReadOnlyQuery;
    qryAdd: TZQuery;
    procedure actExportExecute(Sender: TObject);
    procedure actRunRecExecute(Sender: TObject);
    procedure btnCompareClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnDetailsClick(Sender: TObject);
    procedure btnImportFolderClick(Sender: TObject);
    procedure btnPlotClick(Sender: TObject);
    procedure btnPrefsClick(Sender: TObject);
    procedure btnPsNAddClick(Sender: TObject);
    procedure btnPsNDeleteClick(Sender: TObject);
    procedure btnReportClick(Sender: TObject);
    procedure chkExpandedClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormShow(Sender: TObject);
    procedure grdEstPrepareCanvas(sender: TObject; DataCol: Integer;
      Column: TColumn; AState: TGridDrawState);
    procedure grdOmegaPrepareCanvas(sender: TObject; DataCol: Integer;
      Column: TColumn; AState: TGridDrawState);
    procedure grdRunsDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure grdRunsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure grdRunsCellClick(Column: TColumn);
    procedure grdRunsKeyPress(Sender: TObject; var Key: char);
    procedure grdRunsKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure grdRunsPrepareCanvas(sender: TObject; DataCol: Integer;
      Column: TColumn; AState: TGridDrawState);
    procedure grdSigmaPrepareCanvas(sender: TObject; DataCol: Integer;
      Column: TColumn; AState: TGridDrawState);
    procedure grdThetaPrepareCanvas(sender: TObject; DataCol: Integer;
      Column: TColumn; AState: TGridDrawState);
    procedure histFilesClickHistoryItem(Sender: TObject; Item: TMenuItem;
      const Filename: string);
    procedure itmKeyClick(Sender: TObject);
    procedure itmNotKeyClick(Sender: TObject);
    procedure Label15Click(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure MenuItem16Click(Sender: TObject);
    procedure MenuItem17Click(Sender: TObject);
    procedure MenuItem18Click(Sender: TObject);
    procedure MenuItem19Click(Sender: TObject);
    procedure MenuItem20Click(Sender: TObject);
    procedure MenuItem21Click(Sender: TObject);
    procedure MenuItem23Click(Sender: TObject);
    procedure MenuItem24Click(Sender: TObject);
    procedure MenuItem26Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure mnuArchiveAllClick(Sender: TObject);
    procedure mnuExportLatexClick(Sender: TObject);
    procedure mnuAboutClick(Sender: TObject);
    procedure pgcBottomChange(Sender: TObject);
    procedure pgcBottomPageChanged(Sender: TObject);
    procedure pgcFilesChange(Sender: TObject);
    procedure pgcMainChange(Sender: TObject);
    procedure pgcOmegaChange(Sender: TObject);
    procedure pgcOmegaPageChanged(Sender: TObject);
    procedure pgcParamsChange(Sender: TObject);
    procedure pgcParamsPageChanged(Sender: TObject);
    procedure pgcSigmaChange(Sender: TObject);
    procedure pgcSigmaPageChanged(Sender: TObject);
    procedure pgcTablesChange(Sender: TObject);
    procedure qryEstAfterOpen(DataSet: TDataSet);
    procedure qryEstAfterScroll(DataSet: TDataSet);
    procedure qryEstCovElapsedTimeGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryEstEstElapsedTimeGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryEstMethodGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryEstMinShortGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryOmegaEtaBarGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryOmegaEtaBarSEGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryOmegaEtaPValGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryOmegaEtaShrinkageGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryOmegaOmegaCIsGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryOmegaOmegaInitGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryOmegaOmegaLabelGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryOmegaOmegaPercGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryOmegaOmegaRSEGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryOmegaOmegaSEGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryOmegaOmegaSigDigGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryOmegaOmegaValueGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryPsNCommandGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryPsNDirectoryGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryPsNRawFileGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryPsNResultsFileGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryPsNToolGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsAfterScroll(DataSet: TDataSet);
    procedure qryRunscatabGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunscatabMD5GetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunscnvGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunscnvMD5GetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunscoiGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunscoiMD5GetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsCommentGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsCommentsGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsConditionNumberGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunscorGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunscorMD5GetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunscotabGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunscotabMD5GetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsCovariateModelGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunscovGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunscovMD5GetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsCovTimeGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsDataFileGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsDataFileMD5GetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsDataGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsDescriptionGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsdOFVGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsEstimationGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsEstTimeGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsextGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsextMD5GetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsgrdGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsgrdMD5GetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsIIVGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsIndividualsGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsIOVGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsKeyRunGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsLabelGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsMinShortGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsMSFGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsMSFMD5GetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsmutabGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsmutabMD5GetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsmytabGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsmytabMD5GetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsObsRecsGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsOFVGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsOutputFileGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsOutputFileMD5GetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsParentNoGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunspatabGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunspatabMD5GetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsphiGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsphiMD5GetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsphmGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsphmMD5GetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsrmtGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsrmtMD5GetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsRunNoGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsRVGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunssdtabGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunssdtabMD5GetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsshkGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsshkMD5GetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunssmtGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunssmtMD5GetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsStartTimeGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsStopTimeGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsStructuralModelGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsWarningsGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsXMLGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryRunsXMLMD5GetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qrySigmaEpsilonShrinkageGetText(Sender: TField;
      var aText: string; DisplayText: Boolean);
    procedure qrySigmaSigmaCIsGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qrySigmaSigmaInitGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qrySigmaSigmaLabelGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qrySigmaSigmaRSEGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qrySigmaSigmaSEGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qrySigmaSigmaValueGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryThetaInitialGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryThetaLowerGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryThetaThetaCIsGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryThetaThetaLabelGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryThetaThetaRSEGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryThetaThetaSEGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryThetaThetaValueGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryThetaUpperGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure btnImportClick(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure btnQuitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mnuCloseClick(Sender: TObject);
    procedure mnuExitClick(Sender: TObject);
    function Pad(RunNo: string): WideString;
    procedure CaptureRunXML(nmFile: string; flgReplace: Boolean);
    procedure CaptureRunLst(nmFile: string);
    procedure timScreenTimer(Sender: TObject);
    procedure tvRunsSelectionChanged(Sender: TObject);
    procedure XMLToTree(tree: TTreeView; XMLDoc: TXMLDocument);
    function ExtractNumberInString(strFileName: string): Integer;
    function LineBreaks(inTxt: WideString): TStringList;
    function BrkUp(brkStr: string; brkBase: string;
      brkInt: Integer): string;
    procedure AddThetaMSFInits(str: string; lstInit,
      lstLower, lstUpper: TStrings);
    function SigFig(fltIn: Double; intPrec: Integer): Double;
    function PowerFn (number, exponent: Double): Double;
    function StripSpaces(st: string): string;
    function RoundTo(const AValue : extended ; const ADigit : Integer): extended ;
    procedure GridMatrix(inField: TMemoField; Grid: TStringGrid; brkStr: string;
      ParMatrix: Boolean; ParType: string);
    procedure GridMatrixF(inField: TMemoField; Grid: TStringGrid);
    procedure Eigens;
    function IsStrAFloat(const S: string): Boolean;
    procedure OpenData;
    procedure CloseData;
    procedure RefreshCfg(Startup: Boolean);
    procedure NukeRun(strRun: string);
    procedure FindNewRec(strRun: string);
    function GetNodeByText(ATree : TTreeView; AValue:String;
      AVisible: Boolean): TTreeNode;
    procedure BuildTree;
    procedure WalkChildren(Node: TTreeNode; List: TStringList);
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: integer);
    procedure CheckFields;
    procedure ArchiveRun(FileName: string; IncData: Boolean; DataSet: TDataSet);
    procedure CreateRunsTable;
    procedure CreateThetaTable;
    procedure CreateOmegaTable;
    procedure CreateSigmaTable;
    procedure CreateEstTable;
    procedure CreateTransTable;
    procedure CreatePsNTable;
  private
    { private declarations }

  public
    { public declarations }
  end; 

type
  PRunRec = ^TRunRec;
  TRunRec = packed record
    RunNo: WideString;
    Problem: WideString;
    Lbl: WideString;
    OFV: WideString;
    dOFV: WideString;
    CondNo: WideString;
    Description: WideString;
    MinShort: WideString;
    Inds: WideString;
    FnEvals: WideString;
    Observations: WideString;
    SigDigits: WideString;
    Key: Integer;
    Parent: WideString;
    Warnings: WideString;
    iRunNo: WideString;
    Data: WideString;
    EstTime: WideString;
    CovTime: WideString;
    StructuralModel: WideString;
    CovariateModel: WideString;
    IIV: WideString;
    IOV: WideString;
    RV: WideString;
    Estimation: WideString;
  end;

  INode = class
    public
    RunNo: WideString;
    Problem: WideString;
    Lbl: WideString;
    OFV: WideString;
    dOFV: WideString;
    CondNo: WideString;
    Description: WideString;
    MinShort: WideString;
    Inds: WideString;
    FnEvals: WideString;
    Observations: WideString;
    SigDigits: WideString;
    Key: Integer;
    Parent: WideString;
    Warnings: WideString;
    iRunNo: WideString;
    Data: WideString;
    EstTime: WideString;
    CovTime: WideString;
    StructuralModel: WideString;
    CovariateModel: WideString;
    IIV: WideString;
    IOV: WideString;
    RV: WideString;
    Estimation: WideString;
  end;

  PPsNRunRec = ^TPsNRunRec;
  TPsNRunRec = packed record
    BasedOn: WideString;
    Description: WideString;
    PsNLabel: WideString;
    StructuralModel: WideString;
    CovariateModel: WideString;
    InterIndividualVariability: WideString;
    InterOccasionVariability: WideString;
    ResidualVariability: WideString;
    Estimation: WideString;
  end;

  POptions = ^TOptions;
  TOptions = packed record
    CtlSuffix: WideString;
    LstSuffix: WideString;
    RunPrefix: WideString;
    TabSuffix: WideString;
    MsfSuffix: WideString;
    ThetaCVLimit: Double;
    OmegaCVLimit: Double;
    SigmaCVLimit: Double;
    CondNoLimit: Integer;
    CorrLimit: Double;
    UseMD5: Boolean;
    Precision: Integer;
    NonNumericConfirm: Boolean;
  end;

  type TMatrix = array of array of string;

var
  frmMain: TfrmMain;
  CurCol: Integer;

const
  {$ifdef windows}
  strOS = 'Windows';
  strDelim = '\'
  {$endif}
  {$ifdef unix}
  strOS = 'Linux';
  strDelim = '/'
  {$endif};

implementation

{$R *.lfm}

uses options, about, importfolder, edit, exportrun, compare, progress, runrec, rproc;

var
  sqlDB, strSrc, strDest: TStrings;
  cenOpts: TOptions;

{ TfrmMain }


procedure TfrmMain.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin

end;

procedure TfrmMain.FormShow(Sender: TObject);
begin

end;

procedure TfrmMain.grdEstPrepareCanvas(sender: TObject; DataCol: Integer;
  Column: TColumn; AState: TGridDrawState);
begin
   with (Sender as TDBGrid) do
   begin
     Canvas.Font.Color := clDefault;    // needed for Windows
     if (DataSource.DataSet.FieldByName('MinShort').asString = 'Terminated')
      then
      begin
        //Canvas.Brush.Color := FixedColor;   // or whatever color wanted
        if Column.FieldName = 'MinShort' then
          Canvas.Font.Color := clRed; // idem
        // Canvas.TextStyle.Alignment:=taCenter     // another tip to center the text in the cell
      end;
  end;
end;

procedure TfrmMain.grdOmegaPrepareCanvas(sender: TObject; DataCol: Integer;
  Column: TColumn; AState: TGridDrawState);
begin
  with (Sender as TDBGrid) do
   begin
     if (DataSource.DataSet.FieldByName('OmegaRSE').AsString <> '') then
       if (DataSource.DataSet.FieldByName('OmegaRSE').AsFloat/100 > cenOpts.OmegaCVLimit)
         then
         begin
            //Canvas.Brush.Color := FixedColor;   // or whatever color wanted
            if Column.FieldName = 'OmegaRSE' then
            Canvas.Font.Color := clRed; // idem
            // Canvas.TextStyle.Alignment:=taCenter     // another tip to center the text in the cell
         end;
     if (DataSource.DataSet.FieldByName('OmegaPerc').AsString <> '') then
         begin
            //Canvas.Brush.Color := FixedColor;   // or whatever color wanted
            if Column.FieldName = 'OmegaPerc' then
            Canvas.Font.Color := clGray; // idem
            // Canvas.TextStyle.Alignment:=taCenter     // another tip to center the text in the cell
         end;
       //if (DataSource.DataSet.FieldByName('EtaPVal').AsFloat < 0.05)
   if qryOmegaEtaPVal.AsString <> '' then
     if StrToFloat(qryOmegaEtaPVal.Value) < 0.05
       then
       begin
         //Canvas.Brush.Color := FixedColor;   // or whatever color wanted
         if Column.FieldName = 'EtaPVal' then
           Canvas.Font.Color := clRed; // idem
           // Canvas.TextStyle.Alignment:=taCenter     // another tip to center the text in the cell
       end;
    end;
end;

procedure TfrmMain.grdRunsDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  bitmap : TBitmap;
  fixRect : TRect;
  bmpWidth : integer;
  imgIndex : integer;
begin
  fixRect := Rect;

  if Column.FieldName = 'KeyRun' then
    begin
      if qryRunsKeyRun.Value = 1 then
      begin
        bitmap := TBitmap.Create;
        try
          imgList.GetBitmap(29, bitmap);
          bmpWidth := (Rect.Bottom - Rect.Top);
          fixRect.Right := Rect.Left + bmpWidth;
          grdRuns.Canvas.StretchDraw(fixRect,bitmap);
        finally
          bitmap.Free;
        end;
      end;
      if qryRunsKeyRun.Value = 2 then
      begin
        bitmap := TBitmap.Create;
        try
          imgList.GetBitmap(25, bitmap);
          bmpWidth := (Rect.Bottom - Rect.Top);
          fixRect.Right := Rect.Left + bmpWidth;
          grdRuns.Canvas.StretchDraw(fixRect,bitmap);
        finally
          bitmap.Free;
        end;
      end;
      if qryRunsKeyRun.Value = 3 then
      begin
        bitmap := TBitmap.Create;
        try
          imgList.GetBitmap(24, bitmap);
          bmpWidth := (Rect.Bottom - Rect.Top);
          fixRect.Right := Rect.Left + bmpWidth;
          grdRuns.Canvas.StretchDraw(fixRect,bitmap);
        finally
          bitmap.Free;
        end;
      end;
      if qryRunsKeyRun.Value = 4 then
      begin
        bitmap := TBitmap.Create;
        try
          imgList.GetBitmap(23, bitmap);
          bmpWidth := (Rect.Bottom - Rect.Top);
          fixRect.Right := Rect.Left + bmpWidth;
          grdRuns.Canvas.StretchDraw(fixRect,bitmap);
        finally
          bitmap.Free;
        end;
      end;
      if qryRunsKeyRun.Value = 5 then
      begin
        bitmap := TBitmap.Create;
        try
          imgList.GetBitmap(28, bitmap);
          bmpWidth := (Rect.Bottom - Rect.Top);
          fixRect.Right := Rect.Left + bmpWidth;
          grdRuns.Canvas.StretchDraw(fixRect,bitmap);
        finally
          bitmap.Free;
        end;
      end;
    end;

end;

procedure TfrmMain.grdRunsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

end;

procedure TfrmMain.grdRunsCellClick(Column: TColumn);
begin

end;

procedure TfrmMain.grdRunsKeyPress(Sender: TObject; var Key: char);
begin
     try
      //grdEst.DataSource := nil;
      //grdTheta.DataSource := nil;
      //grdOmega.DataSource := nil;
      //grdSigma.DataSource := nil;
      //grdRuns.DataSource := nil;
      with qryEst do
      begin
        Active := False;
        Unprepare;
        SQL.Clear;
        SQL.Add('select * from est');
        SQL.Add('where RunNo = ' + QuotedStr(qryRunsRunNo.Value));
        SQL.Add('order by EstNo;');
        Prepare;
        Active := True;
        First;
      end;

      with qryPsN do
      begin
        Active := False;
        Unprepare;
        SQL.Clear;
        SQL.Add('select * from psn');
        SQL.Add('where RunNo = ' + QuotedStr(qryRunsRunNo.Value));
        SQL.Add('order by Tool,Timestamp;');
        Prepare;
        Active := True;
        First;
      end;

    finally
      //grdRuns.DataSource := dsRuns;
      //grdEst.DataSource := dsEst;
      //grdTheta.DataSource := dsTheta;
      //grdOmega.DataSource := dsOmega;
      //grdSigma.DataSource := dsSigma;
      Application.ProcessMessages;
    end;


  if pgcParams.TabIndex = 3 then
  begin
    pgcBottomPageChanged(Sender);
    //ShowMessage('go');
  end;
end;

procedure TfrmMain.grdRunsKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
end;

procedure TfrmMain.grdRunsPrepareCanvas(sender: TObject; DataCol: Integer;
  Column: TColumn; AState: TGridDrawState);
begin
  with (Sender as TDBGrid) do
   begin
     Canvas.Font.Color := clDefault;    // needed for Windows
     if (DataSource.DataSet.FieldByName('dOFV').asFloat > 0)
      then
      begin
        //Canvas.Brush.Color := FixedColor;   // or whatever color wanted
        if Column.FieldName = 'dOFV' then
          Canvas.Font.Color := clRed; // idem
        // Canvas.TextStyle.Alignment:=taCenter     // another tip to center the text in the cell
      end;
     if (DataSource.DataSet.FieldByName('ConditionNumber').asFloat > cenOpts.CondNoLimit)
      then
      begin
        //Canvas.Brush.Color := FixedColor;   // or whatever color wanted
        if Column.FieldName = 'ConditionNumber' then
          Canvas.Font.Color := clRed; // idem
        // Canvas.TextStyle.Alignment:=taCenter     // another tip to center the text in the cell
      end;

     // flag background
     case DataSource.DataSet.FieldByName('KeyRun').asInteger of
       0: Canvas.Brush.Color := clWindow;
       1: Canvas.Brush.Color := RGBToColor(245, 230, 230); //$00EFEFFF red;
       2: Canvas.Brush.Color := RGBToColor(253, 245, 230); //$00EFF8FF orange;
       3: Canvas.Brush.Color := RGBToColor(230, 248, 243); //$00EBFFE9 green;
       4: Canvas.Brush.Color := RGBToColor(240, 255, 255); //$00FFEBEB blue;
       5: Canvas.Brush.Color := RGBToColor(220, 208, 255); //$00FFEEFF purple;
     end;

  end;

end;

procedure TfrmMain.grdSigmaPrepareCanvas(sender: TObject; DataCol: Integer;
  Column: TColumn; AState: TGridDrawState);
begin
  with (Sender as TDBGrid) do
   begin
     if (DataSource.DataSet.FieldByName('SigmaRSE').asFloat/100 > cenOpts.SigmaCVLimit)
      then
      begin
        //Canvas.Brush.Color := FixedColor;   // or whatever color wanted
        if Column.FieldName = 'SigmaRSE' then
          Canvas.Font.Color := clRed; // idem
        // Canvas.TextStyle.Alignment:=taCenter     // another tip to center the text in the cell
      end;
  end;
end;

procedure TfrmMain.grdThetaPrepareCanvas(sender: TObject; DataCol: Integer;
  Column: TColumn; AState: TGridDrawState);
begin
  with (Sender as TDBGrid) do
   begin
     if (DataSource.DataSet.FieldByName('ThetaRSE').asFloat/100 > cenOpts.ThetaCVLimit)
      then
      begin
        //Canvas.Brush.Color := FixedColor;   // or whatever color wanted
        if Column.FieldName = 'ThetaRSE' then
          Canvas.Font.Color := clRed; // idem
        // Canvas.TextStyle.Alignment:=taCenter     // another tip to center the text in the cell
      end;
  end;
end;

procedure TfrmMain.histFilesClickHistoryItem(Sender: TObject; Item: TMenuItem;
  const Filename: string);
begin
  if FileExists(FileName) then
  begin
    zConn.Connected := False;
    zConn.Database := FileName;
    OpenData;
  end;
end;

procedure TfrmMain.itmKeyClick(Sender: TObject);
var
  bkMark: TBookmark;
begin
  bkMark := qryRuns.GetBookmark;
  with qryAdd do
  begin
    SQL.Clear;
    SQL.Add('update runs');
    SQL.Add('set KeyRun=1');
    SQL.Add('where RunNo=' + QuotedStr(qryRunsRunNo.Value) + ';');
    ExecSQL;
  end;
  qryRuns.Refresh;
  qryRuns.GotoBookmark(bkMark);
  qryRuns.FreeBookmark(bkMark);
end;

procedure TfrmMain.itmNotKeyClick(Sender: TObject);
begin

end;

procedure TfrmMain.Label15Click(Sender: TObject);
begin
  if chkExpanded.Checked then
    chkExpanded.Checked := False
  else
    chkExpanded.Checked := True;
  if chkExpanded.Checked then
    tvRuns.FullExpand
  else
    tvRuns.FullCollapse;
end;

procedure TfrmMain.MenuItem12Click(Sender: TObject);
begin
  synOutput.CopyToClipboard;
end;

procedure TfrmMain.MenuItem16Click(Sender: TObject);
var
  bkMark: TBookmark;
begin
  bkMark := qryRuns.GetBookmark;
  with qryAdd do
  begin
    SQL.Clear;
    SQL.Add('update runs');
    SQL.Add('set KeyRun=2');
    SQL.Add('where RunNo=' + QuotedStr(qryRunsRunNo.Value) + ';');
    ExecSQL;
  end;
  qryRuns.Refresh;
  qryRuns.GotoBookmark(bkMark);
  qryRuns.FreeBookmark(bkMark);
end;

procedure TfrmMain.MenuItem17Click(Sender: TObject);
var
  bkMark: TBookmark;
begin
  bkMark := qryRuns.GetBookmark;
  with qryAdd do
  begin
    SQL.Clear;
    SQL.Add('update runs');
    SQL.Add('set KeyRun=3');
    SQL.Add('where RunNo=' + QuotedStr(qryRunsRunNo.Value) + ';');
    ExecSQL;
  end;
  qryRuns.Refresh;
  qryRuns.GotoBookmark(bkMark);
  qryRuns.FreeBookmark(bkMark);
end;

procedure TfrmMain.MenuItem18Click(Sender: TObject);
begin
end;

procedure TfrmMain.MenuItem19Click(Sender: TObject);
var
  bkMark: TBookmark;
begin
  bkMark := qryRuns.GetBookmark;
  with qryAdd do
  begin
    SQL.Clear;
    SQL.Add('update runs');
    SQL.Add('set KeyRun=0');
    SQL.Add('where RunNo=' + QuotedStr(qryRunsRunNo.Value) + ';');
    ExecSQL;
  end;
  qryRuns.Refresh;
  qryRuns.GotoBookmark(bkMark);
  qryRuns.FreeBookmark(bkMark);
end;

procedure TfrmMain.MenuItem20Click(Sender: TObject);
var
  bkMark: TBookmark;
begin
  bkMark := qryRuns.GetBookmark;
  with qryAdd do
  begin
    SQL.Clear;
    SQL.Add('update runs');
    SQL.Add('set KeyRun=4');
    SQL.Add('where RunNo=' + QuotedStr(qryRunsRunNo.Value) + ';');
    ExecSQL;
  end;
  qryRuns.Refresh;
  qryRuns.GotoBookmark(bkMark);
  qryRuns.FreeBookmark(bkMark);
end;

procedure TfrmMain.MenuItem21Click(Sender: TObject);
var
  bkMark: TBookmark;
begin
  bkMark := qryRuns.GetBookmark;
  with qryAdd do
  begin
    SQL.Clear;
    SQL.Add('update runs');
    SQL.Add('set KeyRun=5');
    SQL.Add('where RunNo=' + QuotedStr(qryRunsRunNo.Value) + ';');
    ExecSQL;
  end;
  qryRuns.Refresh;
  qryRuns.GotoBookmark(bkMark);
  qryRuns.FreeBookmark(bkMark);
end;

procedure TfrmMain.MenuItem23Click(Sender: TObject);
var
  lstOut, lstTemp: TStrings;
  strTemp: string;
  n,m: integer;
begin
  lstTemp := TStringList.Create;
  lstOut := TStringList.Create;
  strTemp := '';

  lstOut.Add('# Means and variance-covariance matrix for run ' + qryRunsRunNo.Value);
  lstOut.Add('# Generated by Census on ' + FormatDateTime('c', Date));
  lstOut.Add('');

  lstOut.Add('# typical parameter estimates');
  lstOut.Add('');

  strTemp := 'mu <- c(';
  qryTheta.First;
  for n := 0 to qryTheta.RecordCount - 1 do
  begin
    if n < qryTheta.RecordCount - 1 then
      strTemp := strTemp + FloatToStr(qryThetaThetaValue.Value) + ','
    else
      strTemp := strTemp + FloatToStr(qryThetaThetaValue.Value) + ',  # Thetas';
    qryTheta.Next;
  end;
  lstOut.Add(strTemp);

  lstTemp.Text := qryEstSigmaMatrix.AsString;
  for m := 0 to lstTemp.Count - 1 do
    if m < lstTemp.Count - 1 then
      lstOut.Add('           ' + lstTemp[m] + ',')
    else
      lstOut.Add('           ' + lstTemp[m] + ',   # Sigmas');

  lstTemp.Text := qryEstOmegaMatrix.AsString;
  for m := 0 to lstTemp.Count - 1 do
    if m < lstTemp.Count - 1 then
      lstOut.Add('           ' + lstTemp[m] + ',')
    else
      lstOut.Add('           ' + lstTemp[m] + ')   # Omegas');
  lstTemp.Clear;

  if Length(qryRunscov.Value) > 0 then
  begin
    lstOut.Add('');
    lstOut.Add('# variance-covariance matrix');
    lstOut.Add('');
    lstOut.Add('vcov <- read.table("' + StringReplace(qryRunscov.Value, '\', '/', [rfReplaceAll]) + '", skip=1, head=T, row.names=1)');
    lstOut.Add('vcov <- as.matrix(vcov) ');
    lstOut.Add('');
    lstOut.Add('library(MASS)');
    lstOut.Add('mat <- mvrnorm(1000, mu=mu, Sigma=vcov)');
  end;

  //ShowMessage(lstOut.Text);
  if dlgR.Execute then
    lstOut.SaveToFile(dlgR.FileName);

  lstOut.Free;
  lstTemp.Free;
end;

procedure TfrmMain.MenuItem24Click(Sender: TObject);
begin
  // Archive
  dlgZip.FileName := 'run' + qryRunsRunNo.Value + '.zip';
  if dlgZip.Execute then
    if FileExists(dlgZip.FileName) then
    begin
      if MessageDlg('This file (' + ExtractFileName(dlgZip.FileName) + ') already exists. Overwrite?',
        mtWarning, [mbYes,mbNo], 0) = mrYes then
      begin
        DeleteFile(dlgZip.FileName);
        ArchiveRun(dlgZip.FileName, True, qryRuns);
      end
      else
        Exit
    end
    else
      ArchiveRun(dlgZip.FileName, True, qryRuns);
end;

procedure TfrmMain.MenuItem26Click(Sender: TObject);
begin

end;

procedure TfrmMain.ArchiveRun(FileName: string; IncData: Boolean; Dataset: TDataSet);
var
  Zipper: TZipper;
  OldCursor: TCursor;
begin
  OldCursor := Screen.Cursor;
  Screen.Cursor := crHourglass;
  Zipper := TZipper.Create;
  Zipper.FileName := FileName;

  if FileExists(DataSet.FieldByName('Model').AsString) then
    Zipper.Entries.AddFileEntry(DataSet.FieldByName('Model').AsString, ExtractFileName(DataSet.FieldByName('Model').AsString));
  if FileExists(DataSet.FieldByName('CtlFile').AsString) then
    Zipper.Entries.AddFileEntry(DataSet.FieldByName('CtlFile').AsString, ExtractFileName(DataSet.FieldByName('CtlFile').AsString));
  if (FileExists(DataSet.FieldByName('DataFile').AsString) and (IncData)) then
    Zipper.Entries.AddFileEntry(DataSet.FieldByName('DataFile').AsString, ExtractFileName(DataSet.FieldByName('DataFile').AsString));
  if FileExists(DataSet.FieldByName('OutputFile').AsString) then
    Zipper.Entries.AddFileEntry(DataSet.FieldByName('OutputFile').AsString, ExtractFileName(DataSet.FieldByName('OutputFile').AsString));
  if FileExists(DataSet.FieldByName('MSF').AsString) then
    Zipper.Entries.AddFileEntry(DataSet.FieldByName('MSF').AsString, ExtractFileName(DataSet.FieldByName('MSF').AsString));
  if FileExists(DataSet.FieldByName('FitFile').AsString) then
    Zipper.Entries.AddFileEntry(DataSet.FieldByName('FitFile').AsString, ExtractFileName(DataSet.FieldByName('FitFile').AsString));
  if FileExists(DataSet.FieldByName('patab').AsString) then
    Zipper.Entries.AddFileEntry(DataSet.FieldByName('patab').AsString, ExtractFileName(DataSet.FieldByName('patab').AsString));
  if FileExists(DataSet.FieldByName('sdtab').AsString) then
    Zipper.Entries.AddFileEntry(DataSet.FieldByName('sdtab').AsString, ExtractFileName(DataSet.FieldByName('sdtab').AsString));
  if FileExists(DataSet.FieldByName('catab').AsString) then
    Zipper.Entries.AddFileEntry(DataSet.FieldByName('catab').AsString, ExtractFileName(DataSet.FieldByName('catab').AsString));
  if FileExists(DataSet.FieldByName('cotab').AsString) then
    Zipper.Entries.AddFileEntry(DataSet.FieldByName('cotab').AsString, ExtractFileName(DataSet.FieldByName('cotab').AsString));
  if FileExists(DataSet.FieldByName('mytab').AsString) then
    Zipper.Entries.AddFileEntry(DataSet.FieldByName('mytab').AsString, ExtractFileName(DataSet.FieldByName('mytab').AsString));
  if FileExists(DataSet.FieldByName('mutab').AsString) then
    Zipper.Entries.AddFileEntry(DataSet.FieldByName('mutab').AsString, ExtractFileName(DataSet.FieldByName('mutab').AsString));
  if FileExists(DataSet.FieldByName('txt').AsString) then
    Zipper.Entries.AddFileEntry(DataSet.FieldByName('txt').AsString, ExtractFileName(DataSet.FieldByName('txt').AsString));
  if FileExists(DataSet.FieldByName('ext').AsString) then
    Zipper.Entries.AddFileEntry(DataSet.FieldByName('ext').AsString, ExtractFileName(DataSet.FieldByName('ext').AsString));
  if FileExists(DataSet.FieldByName('cor').AsString) then
    Zipper.Entries.AddFileEntry(DataSet.FieldByName('cor').AsString, ExtractFileName(DataSet.FieldByName('cor').AsString));
  if FileExists(DataSet.FieldByName('cov').AsString) then
    Zipper.Entries.AddFileEntry(DataSet.FieldByName('cov').AsString, ExtractFileName(DataSet.FieldByName('cov').AsString));
  if FileExists(DataSet.FieldByName('coi').AsString) then
    Zipper.Entries.AddFileEntry(DataSet.FieldByName('coi').AsString, ExtractFileName(DataSet.FieldByName('coi').AsString));
  if FileExists(DataSet.FieldByName('phi').AsString) then
    Zipper.Entries.AddFileEntry(DataSet.FieldByName('phi').AsString, ExtractFileName(DataSet.FieldByName('phi').AsString));
  if FileExists(DataSet.FieldByName('XML').AsString) then
    Zipper.Entries.AddFileEntry(DataSet.FieldByName('XML').AsString, ExtractFileName(DataSet.FieldByName('XML').AsString));
  if FileExists(DataSet.FieldByName('phm').AsString) then
    Zipper.Entries.AddFileEntry(DataSet.FieldByName('phm').AsString, ExtractFileName(DataSet.FieldByName('phm').AsString));
  if FileExists(DataSet.FieldByName('shk').AsString) then
    Zipper.Entries.AddFileEntry(DataSet.FieldByName('shk').AsString, ExtractFileName(DataSet.FieldByName('shk').AsString));
  if FileExists(DataSet.FieldByName('grd').AsString) then
    Zipper.Entries.AddFileEntry(DataSet.FieldByName('grd').AsString, ExtractFileName(DataSet.FieldByName('grd').AsString));
  if FileExists(DataSet.FieldByName('cnv').AsString) then
    Zipper.Entries.AddFileEntry(DataSet.FieldByName('cnv').AsString, ExtractFileName(DataSet.FieldByName('cnv').AsString));
  if FileExists(DataSet.FieldByName('smt').AsString) then
    Zipper.Entries.AddFileEntry(DataSet.FieldByName('smt').AsString, ExtractFileName(DataSet.FieldByName('smt').AsString));
  if FileExists(DataSet.FieldByName('rmt').AsString) then
    Zipper.Entries.AddFileEntry(DataSet.FieldByName('rmt').AsString, ExtractFileName(DataSet.FieldByName('rmt').AsString));
  if FileExists(DataSet.FieldByName('cwtab').AsString) then
    Zipper.Entries.AddFileEntry(DataSet.FieldByName('cwtab').AsString, ExtractFileName(DataSet.FieldByName('cwtab').AsString));
  if FileExists(DataSet.FieldByName('cwtabEst').AsString) then
    Zipper.Entries.AddFileEntry(DataSet.FieldByName('cwtabEst').AsString, ExtractFileName(DataSet.FieldByName('cwtabEst').AsString));
  if FileExists(DataSet.FieldByName('cwtabDeriv').AsString) then
    Zipper.Entries.AddFileEntry(DataSet.FieldByName('cwtabDeriv').AsString, ExtractFileName(DataSet.FieldByName('cwtabDeriv').AsString));

  try
    Zipper.ZipAllFiles;
    //ShowMessage(Zipper.FileName);
  finally
    Screen.Cursor := OldCursor;
    Zipper.Free;
  end;

end;


procedure TfrmMain.MenuItem7Click(Sender: TObject);
begin
  if not Assigned(frmEdit) then
    frmEdit := TfrmEdit.Create(Application);
  frmEdit.Show;
end;

procedure TfrmMain.mnuArchiveAllClick(Sender: TObject);
var
  n, intItems: Integer;
  FileName: string;
begin
  // get folder
  dlgDir.InitialDir := ExtractFilePath(zConn.Database);

  if dlgDir.Execute then
    if Length(dlgDir.FileName) > 0 then
    begin
      try
        // get list of runs
        qryGeneral.Active := False;

        with qryGeneral do
        begin
          SQL.Clear;
          SQL.Add('select *');
          SQL.Add('from runs');
          SQL.Add('order by iRunNo;');
          Active := True;
          First;
        end;

        if not Assigned(frmProgress) then
          frmProgress := TfrmProgress.Create(Application);
        frmProgress.Show;
        frmProgress.Tag := 0;

        intItems := 0;
        frmProgress.prgImport.Position := 0;
        frmProgress.prgImport.Max := qryGeneral.RecordCount;
        frmProgress.Caption := 'Archiving...';

        for n := 0 to qryGeneral.RecordCount - 1 do
        begin
          // Archive
          FileName := dlgDir.FileName + strDelim + 'run' + qryGeneral.FieldByName('RunNo').Value + '.zip';
          //ShowMessage(FileName);
          frmProgress.pnlImport.Caption := 'run' + qryGeneral.FieldByName('RunNo').Value + '.zip';
          frmProgress.Refresh;
          Application.ProcessMessages;
          if FileExists(FileName) then
            begin
              if MessageDlg('This file (' + ExtractFileName(FileName) + ') already exists. Overwrite?',
                mtWarning, [mbYes,mbNo], 0) = mrYes then
              begin
                DeleteFile(FileName);
                ArchiveRun(FileName, True, qryGeneral);
              end
            end
            else
              ArchiveRun(FileName, True, qryGeneral);
            frmProgress.prgImport.Position := frmProgress.prgImport.Position + 1;
            frmProgress.Refresh;
            Application.ProcessMessages;
            qryGeneral.Next;

            // interrupt
            if frmProgress.Tag = 1 then
            begin
              MessageDlg('Archiving operation interrupted...', mtInformation, [mbOK], 0);
              Exit;
            end;
        end;
      finally
        frmProgress.Close;
        qryGeneral.Active := False;
      end;
    end;
end;

procedure TfrmMain.mnuExportLatexClick(Sender: TObject);
begin

end;

procedure TfrmMain.mnuAboutClick(Sender: TObject);
begin
  if not Assigned(frmAbout) then
    frmAbout := TfrmAbout.Create(Application);
  frmAbout.ShowModal;
end;

procedure TfrmMain.pgcBottomChange(Sender: TObject);
begin
  pgcBottomPageChanged(Sender);
end;



procedure TfrmMain.pgcBottomPageChanged(Sender: TObject);
var
  myCursor: TCursor;
begin
  if qryEst.Active then
  try
    myCursor := Screen.Cursor;
    Screen.Cursor := crHourglass;
    case pgcBottom.TabIndex of
      0: GridMatrix(qryEstCovMatrix, grdCovMatrix, ';', False, '');
      1: GridMatrixF(qryRunscor, grdCorMatrix);
      2: GridMatrixF(qryRunscoi, grdInvCovMatrix);
      3: Eigens;
    end;
  finally
    Screen.Cursor := myCursor;
  end;
end;

procedure TfrmMain.pgcFilesChange(Sender: TObject);
var
  myCursor: TCursor;
begin
  if qryRuns.Active then
  try
    myCursor := Screen.Cursor;
    Screen.Cursor := crHourglass;
    case pgcFiles.TabIndex of
      0: if FileExists(qryRunsOutputFile.Value) then
        synOutput.Lines.LoadFromFile(qryRunsOutputFile.Value);
      1: if FileExists(qryRunsXML.Value) then
        synXML.Lines.LoadFromFile(qryRunsXML.Value);
      //2: if FileExists(qryRunsDataFile.Value) then
      //  LoadGridFromCSVFile(grdData, qryRunsDataFile.Value);
      3: if FileExists(qryRunsext.Value) then
        synExt.Lines.LoadFromFile(qryRunsext.Value);
      4: if FileExists(qryRunscov.Value) then
        synCov.Lines.LoadFromFile(qryRunscov.Value);
      5: if FileExists(qryRunscor.Value) then
        synCor.Lines.LoadFromFile(qryRunscor.Value);
      6: if FileExists(qryRunscoi.Value) then
        synCoi.Lines.LoadFromFile(qryRunscoi.Value);
      7: if FileExists(qryRunsphi.Value) then
        synPhi.Lines.LoadFromFile(qryRunsphi.Value);
      8: if FileExists(qryRunsphm.Value) then
        synPhm.Lines.LoadFromFile(qryRunsphm.Value);
      9: if FileExists(qryRunsshk.Value) then
        synShk.Lines.LoadFromFile(qryRunsshk.Value);
      10: if FileExists(qryRunsgrd.Value) then
        synGrd.Lines.LoadFromFile(qryRunsgrd.Value);
      11: if FileExists(qryRunscnv.Value) then
        synCnv.Lines.LoadFromFile(qryRunscnv.Value);
      12: if FileExists(qryRunssmt.Value) then
        synSmt.Lines.LoadFromFile(qryRunssmt.Value);
      13: if FileExists(qryRunsrmt.Value) then
        synRmt.Lines.LoadFromFile(qryRunsrmt.Value);
      14: if FileExists(qryRunssdtab.Value) then
        synSdtab.Lines.LoadFromFile(qryRunssdtab.Value);
      15: if FileExists(qryRunspatab.Value) then
        synPatab.Lines.LoadFromFile(qryRunspatab.Value);
      16: if FileExists(qryRunscatab.Value) then
        synCatab.Lines.LoadFromFile(qryRunscatab.Value);
      17: if FileExists(qryRunscotab.Value) then
        synCotab.Lines.LoadFromFile(qryRunscotab.Value);
      18: if FileExists(qryRunsmytab.Value) then
        synMytab.Lines.LoadFromFile(qryRunsmytab.Value);
      19: if FileExists(qryRunsmutab.Value) then
        synMutab.Lines.LoadFromFile(qryRunsmutab.Value);
    end;
    finally
      Screen.Cursor := myCursor;
    end;
end;

procedure TfrmMain.pgcMainChange(Sender: TObject);
begin
  if pgcMain.TabIndex = 1 then
    pgcFilesChange(pgcFiles);
end;

procedure TfrmMain.pgcOmegaChange(Sender: TObject);
begin
  pgcOmegaPageChanged(Sender);
end;



procedure TfrmMain.pgcOmegaPageChanged(Sender: TObject);
var
  myCursor: TCursor;
begin
  if qryEst.Active then
  try
     myCursor := Screen.Cursor;
     Screen.Cursor := crHourglass;
    case pgcOmega.TabIndex of
      1: GridMatrix(qryEstOmegaMatrix, grdOmegaMatrix, ',', True, 'ETA');
      2: GridMatrix(qryEstOmegaSEMatrix, grdOmegaSEMatrix, ',', True, 'ETA');
      3: GridMatrix(qryEstOmegaCorrMatrix, grdOmegaCorrMatrix, ',', True, 'ETA');
      4: GridMatrix(qryEstOmegaInitMatrix, grdOmegaInitMatrix, ',', True, 'ETA');
    end;
  finally
    Screen.Cursor := myCursor;
  end;
end;

procedure TfrmMain.pgcParamsChange(Sender: TObject);
begin
  pgcParamsPageChanged(Sender);
end;

procedure TfrmMain.pgcParamsPageChanged(Sender: TObject);
begin

  if pgcParams.TabIndex = 3 then
    pgcBottomPageChanged(pgcParams);

  if pgcParams.TabIndex = 4 then
    pgcTablesChange(pgcParams);

  if pgcParams.TabIndex = 5 then
  begin

    memCtl.Lines.Text := Copy(qryRunsControlStream.AsString, 1, 250000);
    memSummary.Lines.Text := Copy(qryRunsMinimization.AsString, 1, 250000);
    memNMTran.Lines.Text := Copy(qryRunsNMTran.AsString, 1, 250000);
    memProbInfo.Lines.Text := Copy(qryRunsProblemInfo.AsString, 1, 250000);

  end;
end;

procedure TfrmMain.pgcSigmaChange(Sender: TObject);
begin
  pgcSigmaPageChanged(Sender);
end;

procedure TfrmMain.pgcSigmaPageChanged(Sender: TObject);
var
  myCursor: TCursor;
begin
  if qryEst.Active then
  try
    myCursor := Screen.Cursor;
    Screen.Cursor := crHourglass;
    case pgcSigma.TabIndex of
      1: GridMatrix(qryEstSigmaMatrix, grdSigmaMatrix, ',', True, 'EPS');
      2: GridMatrix(qryEstSigmaSEMatrix, grdSigmaSEMatrix, ',', True, 'EPS');
      3: GridMatrix(qryEstSigmaCorrMatrix, grdSigmaCorrMatrix, ',', True, 'EPS');
      4: GridMatrix(qryEstSigmaInitMatrix, grdSigmaInitMatrix, ',', True, 'EPS');
    end;
  finally
    Screen.Cursor := myCursor;
  end;
end;

procedure TfrmMain.pgcTablesChange(Sender: TObject);
var
  myCursor: TCursor;
begin
  if qryRuns.Active then
  try
    myCursor := Screen.Cursor;
    Screen.Cursor := crHourglass;
    case pgcTables.TabIndex of
      0: GridMatrixF(qryRunsext, grdExt);
      1: GridMatrixF(qryRunsphi, grdPhi);
      2: GridMatrixF(qryRunsphm, grdPhm);
      3: GridMatrixF(qryRunsshk, grdShk);
      4: GridMatrixF(qryRunsgrd, grdGrd);
      5: GridMatrixF(qryRunscnv, grdCnv);
    end;
  finally
    Screen.Cursor := myCursor;
  end;
end;

procedure TfrmMain.qryEstAfterOpen(DataSet: TDataSet);
begin

end;



procedure TfrmMain.qryEstAfterScroll(DataSet: TDataSet);
begin
  // Thetas
  with qryTheta do
  begin
    Unprepare;
    Active := False;
    SQL.Clear;
    SQL.Add('select * from thetas');
    SQL.Add('where RunNo = ''' + qryEstRunNo.Value + '''');
    SQL.Add('and EstNo = ' + IntToStr(qryEstEstNo.Value));
    SQL.Add('order by Theta;');
    Prepare;
    Active := True;
    First;
  end;

  // Omegas
  with qryOmega do
  begin
    Unprepare;
    Active := False;
    SQL.Clear;
    SQL.Add('select * from omegas');
    SQL.Add('where RunNo = ''' + qryEstRunNo.Value + '''');
    SQL.Add('and EstNo = ' + IntToStr(qryEstEstNo.Value));
    SQL.Add('order by Omega;');
    Prepare;
    Active := True;
    First;
  end;

  // Sigmas
  with qrySigma do
  begin
    Unprepare;
    Active := False;
    SQL.Clear;
    SQL.Add('select * from sigmas');
    SQL.Add('where RunNo = ''' + qryEstRunNo.Value + '''');
    SQL.Add('and EstNo = ' + IntToStr(qryEstEstNo.Value));
    SQL.Add('order by Sigma;');
    Prepare;
    Active := True;
    First;
  end;
end;

procedure TfrmMain.qryEstCovElapsedTimeGetText(Sender: TField;
  var aText: string; DisplayText: Boolean);
begin
  aText := FloatToStr(SigFig(qryEstCovElapsedTime.Value, 4));
end;

procedure TfrmMain.qryEstEstElapsedTimeGetText(Sender: TField;
  var aText: string; DisplayText: Boolean);
begin
  aText := FloatToStr(SigFig(qryEstEstElapsedTime.Value, 4));
end;

procedure TfrmMain.qryEstMethodGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryEstMethod.AsString, 1, 50);
end;

procedure TfrmMain.qryEstMinShortGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryEstMinShort.AsString, 1, 50);
end;

procedure TfrmMain.qryOmegaEtaBarGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryOmegaEtaBar.AsString, 1, 50);
end;

procedure TfrmMain.qryOmegaEtaBarSEGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryOmegaEtaBarSE.AsString, 1, 50);
end;

procedure TfrmMain.qryOmegaEtaPValGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryOmegaEtaPVal.AsString, 1, 50);
end;

procedure TfrmMain.qryOmegaEtaShrinkageGetText(Sender: TField;
  var aText: string; DisplayText: Boolean);
begin
  aText := Copy(qryOmegaEtaShrinkage.AsString, 1, 50);
end;

procedure TfrmMain.qryOmegaOmegaCIsGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryOmegaOmegaCIs.AsString, 1, 50);
end;

procedure TfrmMain.qryOmegaOmegaInitGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  if qryOmegaOmegaInit.AsString <> '' then
    aText := FloatToStr(SigFig(qryOmegaOmegaInit.Value, 4));
end;

procedure TfrmMain.qryOmegaOmegaLabelGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryOmegaOmegaLabel.AsString, 1, 50);
end;

procedure TfrmMain.qryOmegaOmegaPercGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  if qryOmegaOmegaPerc.AsString <> '' then
    aText := FloatToStr(SigFig(qryOmegaOmegaPerc.Value, 4));
end;

procedure TfrmMain.qryOmegaOmegaRSEGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  if qryOmegaOmegaRSE.AsString <> '' then
    aText := FloatToStr(SigFig(qryOmegaOmegaRSE.Value, 4));
end;

procedure TfrmMain.qryOmegaOmegaSEGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  if qryOmegaOmegaSE.AsString <> '' then
    aText := FloatToStr(SigFig(qryOmegaOmegaSE.Value, 4));
end;

procedure TfrmMain.qryOmegaOmegaSigDigGetText(Sender: TField;
  var aText: string; DisplayText: Boolean);
begin
  if qryOmegaOmegaSigDig.AsString <> '' then
    aText := FloatToStr(SigFig(qryOmegaOmegaSigDig.Value, 4));
end;

procedure TfrmMain.qryOmegaOmegaValueGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  if qryOmegaOmegaValue.AsString <> '' then
    aText := FloatToStr(SigFig(qryOmegaOmegaValue.Value, 4));
end;

procedure TfrmMain.qryPsNCommandGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryPsNCommand.AsString, 1, 5000);
end;

procedure TfrmMain.qryPsNDirectoryGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryPsNDirectory.AsString, 1, 5000);
end;

procedure TfrmMain.qryPsNRawFileGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := ExtractFileName(qryPsNRawFile.AsString);
end;

procedure TfrmMain.qryPsNResultsFileGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := ExtractFileName(qryPsNResultsFile.AsString);
end;

procedure TfrmMain.qryPsNToolGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryPsNTool.AsString, 1, 5000);
end;

procedure TfrmMain.qryRunsAfterScroll(DataSet: TDataSet);
begin
  try
    //grdEst.DataSource := nil;
    //grdTheta.DataSource := nil;
    //grdOmega.DataSource := nil;
    //grdSigma.DataSource := nil;
    //grdRuns.DataSource := nil;
    with qryEst do
    begin
      Active := False;
      Unprepare;
      SQL.Clear;
      SQL.Add('select * from est');
      SQL.Add('where RunNo = ' + QuotedStr(qryRunsRunNo.Value));
      SQL.Add('order by EstNo;');
      Prepare;
      Active := True;
      First;
    end;

    with qryPsN do
    begin
      Active := False;
      Unprepare;
      SQL.Clear;
      SQL.Add('select * from psn');
      SQL.Add('where RunNo = ' + QuotedStr(qryRunsRunNo.Value));
      SQL.Add('order by Tool,Timestamp;');
      Prepare;
      Active := True;
      First;
    end;

  finally
    //grdRuns.DataSource := dsRuns;
    //grdEst.DataSource := dsEst;
    //grdTheta.DataSource := dsTheta;
    //grdOmega.DataSource := dsOmega;
    //grdSigma.DataSource := dsSigma;
    Application.ProcessMessages;
  end;

  if pgcParams.TabIndex = 3 then
    pgcBottomPageChanged(grdRuns);

  if pgcParams.TabIndex = 4 then
  begin
    memCtl.Lines.Text := Copy(qryRunsControlStream.AsString, 1, 250000);
    memSummary.Lines.Text := Copy(qryRunsMinimization.AsString, 1, 250000);
    memNMTran.Lines.Text := Copy(qryRunsNMTran.AsString, 1, 250000);
    memProbInfo.Lines.Text := Copy(qryRunsProblemInfo.AsString, 1, 250000);
  end;
end;

procedure TfrmMain.qryRunscatabGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunscatab.AsString, 1, 5000);
end;

procedure TfrmMain.qryRunscatabMD5GetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunscatabMD5.AsString, 1, 5000);
end;

procedure TfrmMain.qryRunscnvGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunscnv.AsString, 1, 5000);
end;

procedure TfrmMain.qryRunscnvMD5GetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunscnvMD5.AsString, 1, 5000);
end;

procedure TfrmMain.qryRunscoiGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunscoi.AsString, 1, 5000);
end;

procedure TfrmMain.qryRunscoiMD5GetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunscoiMD5.AsString, 1, 5000);
end;

procedure TfrmMain.qryRunsCommentGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunsComment.AsString, 1, 250);
end;

procedure TfrmMain.qryRunsCommentsGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunsComments.AsString, 1, 250);
end;

procedure TfrmMain.qryRunsConditionNumberGetText(Sender: TField;
  var aText: string; DisplayText: Boolean);
begin
  aText := FloatToStrF(qryRunsConditionNumber.Value, ffGeneral, 5, 4);
end;

procedure TfrmMain.qryRunscorGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunscor.AsString, 1, 5000);
end;

procedure TfrmMain.qryRunscorMD5GetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunscorMD5.AsString, 1, 5000);
end;

procedure TfrmMain.qryRunscotabGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunscotab.AsString, 1, 5000);
end;

procedure TfrmMain.qryRunscotabMD5GetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunscotabMD5.AsString, 1, 5000);
end;

procedure TfrmMain.qryRunsCovariateModelGetText(Sender: TField;
  var aText: string; DisplayText: Boolean);
begin
  aText := Copy(qryRunsCovariateModel.AsString, 1, 250);
end;

procedure TfrmMain.qryRunscovGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunscov.AsString, 1, 5000);
end;

procedure TfrmMain.qryRunscovMD5GetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunscovMD5.AsString, 1, 5000);
end;

procedure TfrmMain.qryRunsCovTimeGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := FloatToStrF(qryRunsCovTime.Value, ffGeneral, 8, 4);
end;

procedure TfrmMain.qryRunsDataFileGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunsDataFile.AsString, 1, 500);
end;

procedure TfrmMain.qryRunsDataFileMD5GetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunsDataFileMD5.AsString, 1, 5000);
end;


procedure TfrmMain.GridMatrix(inField: TMemoField; Grid: TStringGrid; brkStr: string;
  ParMatrix: Boolean; ParType: string);
var
  lstTemp: TStringList;
  strTemp: string;
  n, m, intCt: Integer;
begin
  lstTemp := TStringList.Create;
  lstTemp.Text := inField.AsString;
  //Showmessage(lstTemp.Text);
  //showmessage(inField.Value);

  if ParMatrix then
  begin
    strTemp := '';
    for n := 0 to lstTemp.Count - 1 do
    begin
      lstTemp[n] := ParType + '(' + IntToStr(n+1) + ')' + ',' + lstTemp[n];
      strTemp := strTemp + ',' + ParType + '(' + IntToStr(n+1) + ')';
    end;
    lstTemp.Insert(0, strTemp);
  end;

  Grid.Clear;
  Grid.ColCount := lstTemp.Count;
  Grid.RowCount := lstTemp.Count;

  // TODO: fix SAME initial estimates case (need to pad with 0s)

  for n := 0 to lstTemp.Count - 1 do
  begin
    brkUpp.BaseString := lstTemp[n];
    brkUpp.BreakString := brkStr;
    brkUpp.AllowEmptyString := True;
    brkUpp.BreakApart;
    for m := 0 to brkUpp.StringList.Count - 1 do
      if IsStrAFloat(brkUpp.StringList[m]) then
      begin
        if StrToFloat(brkUpp.StringList[m]) <> 10000000000 then
          Grid.Cells[m,n] := FloatToStr(SigFig(StrToFloat(brkUpp.StringList[m]), 4))
        else
          Grid.Cells[m,n] := '-';
      end
      else
        Grid.Cells[m,n] := brkUpp.StringList[m];
  end;
  lstTemp.Free;
end;

procedure TfrmMain.GridMatrixF(inField: TMemoField; Grid: TStringGrid);
var
  lstTemp: TStringList;
  strTemp: string;
  n, m: Integer;
begin

  lstTemp := TStringList.Create;
  lstTemp.Text := inField.AsString;

  if FileExists(inField.AsString) then
    lstTemp.LoadFromFile(inField.AsString)
  else
  begin
    lstTemp.Free;
    Exit;
  end;

  lstTemp.Delete(0);   // drop first line

  brkUpp.BreakString := ' ';
  brkUpp.AllowEmptyString := False;
  for n := 0 to lstTemp.Count - 1 do
  begin
    brkUpp.BaseString := lstTemp[n];
    brkUpp.BreakApart;
    if n = 0 then
    begin
      Grid.ColCount := brkUpp.StringList.Count;
      Grid.RowCount := lstTemp.Count;
    end;
    for m := 0 to brkUpp.StringList.Count - 1 do
      if IsStrAFloat(brkUpp.StringList[m]) then
      begin
        if StrToFloat(brkUpp.StringList[m]) <> 10000000000 then
          Grid.Cells[m,n] := FloatToStr(SigFig(StrToFloat(brkUpp.StringList[m]), 4))
        else
          Grid.Cells[m,n] := '-';
      end
      else
        Grid.Cells[m,n] := brkUpp.StringList[m];
  end;
  lstTemp.Free;

end;

function TfrmMain.IsStrAFloat(const S: string): Boolean;
begin
  Result := True;
  try
    StrToFloat(S);
  except
    Result := False;
  end;
end;

procedure TfrmMain.Eigens;
var
  lstTemp: TStringList;
  n,m: Integer;
begin
  lstTemp := TStringList.Create;
  lstTemp.Text := qryEstEigenvalues.AsString;
  //Showmessage(lstTemp.Text);
  //showmessage(tblEstEigenvalues.AsString);
  grdEigen.Clear;
  grdEigen.ColCount := lstTemp.Count + 1;
  grdEigen.RowCount := lstTemp.Count + 1;

  for n := 0 to lstTemp.Count - 1 do
    grdEigen.Cells[n+1, 0] := FloatToStr(SigFig(StrToFloat(lstTemp[n]), 4));

  for n := 0 to lstTemp.Count - 1 do
  begin
    grdEigen.Cells[0,n+1] := FloatToStr(SigFig(StrToFloat(lstTemp[n]), 4));
    for m := 0 to lstTemp.Count - 1 do
    begin
      //ShowMessage(brkUpp.StringList[m]);
      //ShowMessage(brkUpp.StringList[n]);
      //ShowMessage(FloatToStr(SigFig(StrToFloat(brkUpp.StringList[m])/StrToFloat(brkUpp.StringList[n]), 4)));
      grdEigen.Cells[m+1,n+1] := FloatToStr(SigFig(StrToFloat(lstTemp[m])/StrToFloat(lstTemp[n]), 4));
    end;
  end;
  lstTemp.Free;
end;

procedure TfrmMain.FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin

end;

procedure TfrmMain.btnPrefsClick(Sender: TObject);
begin
  if not Assigned(frmOptions) then
    frmOptions := TfrmOptions.Create(Application);
  try
    frmOptions.ShowOnTop;
  finally
    RefreshCfg(False);
  end;
end;

procedure TfrmMain.btnPsNAddClick(Sender: TObject);
var
  txtDir, txtTool, txtRaw, txtUser: string;
  strCmd, strVer: TStrings;
begin
  strCmd := TStringList.Create;
  strVer := TStringList.Create;
  if dlgPsN.Execute then
    if FileExists(dlgPsN.FileName) then
    begin
      txtTool := '';
      txtDir := ExtractFilePath(dlgPsN.FileName);
      // bootstrap
      if Pos('bootstrap', ExtractFileName(dlgPsN.FileName)) > 0 then
        txtTool := 'bootstrap';
      // cdd
      if Pos('cdd', ExtractFileName(dlgPsN.FileName)) > 0 then
        txtTool := 'cdd';
      // llp
      if Pos('llp', ExtractFileName(dlgPsN.FileName)) > 0 then
        txtTool := 'llp';
      // npc
      if Pos('npc', ExtractFileName(dlgPsN.FileName)) > 0 then
        txtTool := 'npc';
      // sse
      if Pos('sse', ExtractFileName(dlgPsN.FileName)) > 0 then
        txtTool := 'sse';
      // vpc
      if Pos('vpc', ExtractFileName(dlgPsN.FileName)) > 0 then
        txtTool := 'vpc';
      // scm
      if Pos('scm', ExtractFileName(dlgPsN.FileName)) > 0 then
        txtTool := 'scm';
      // mcmp
      if Pos('mcmp', ExtractFileName(dlgPsN.FileName)) > 0 then
        txtTool := 'mcmp';

      if txtTool = '' then
      begin
        MessageDlg('This file was not created by a supported PsN tool.',
          mtError, [mbOK], 0);
        Exit;
      end;

      if FileExists(txtDir + strDelim + 'raw_results.csv') then
        txtRaw := txtDir + strDelim + 'raw_results.csv';
      if FileExists(txtDir + strDelim + 'raw_results1.csv') then
        txtRaw := txtDir + strDelim + 'raw_results1.csv';

      if FileExists(txtDir + strDelim + 'command.txt') then
          strCmd.LoadFromFile(txtDir + strDelim + 'command.txt');

      if FileExists(txtDir + strDelim + 'version_and_option_info.txt') then
        strVer.LoadFromFile(txtDir + strDelim + 'version_and_option_info.txt');

      if strOS = 'Linux' then
        txtUser := GetEnvironmentVariable('USER');
      if strOS = 'Windows' then
        txtUser := GetEnvironmentVariable('USERNAME');

      try
        with qryAdd do
        begin
          SQL.Clear;
          SQL.Add('insert into psn (RunNo, iRunNo, Tool, ResultsFile, RawFile, Directory, Command, PsNVersion, Timestamp, User)');
          SQL.Add('values ('  +
               '''' + qryRunsRunNo.Value + ''',' +
               IntToStr(qryRunsiRunNo.Value) + ',' +
               '''' + txtTool + ''',' +
               '''' + dlgPsN.FileName + ''',' +
               '''' + txtRaw + ''',' +
               '''' + txtDir + ''',' +
               '''' + strCmd.Text + ''',' +
               '''' + strVer.Text + ''',' +
               IntToStr(Trunc((Now - EncodeDate(1970, 1 ,1)) * 24 * 60 * 60)) + ',' +
               '''' + txtUser + ''');');
          ExecSQL;
        end;
      finally
        strCmd.Free;
        strVer.Free;
        grdPsN.Refresh;
        qryPsN.Refresh;
      end;
    end;
end;


procedure TfrmMain.btnPsNDeleteClick(Sender: TObject);
begin
  if MessageDlg('This will remove this PsN output set (' + qryPsNTool.Value +
    ', run ' + qryPsNRunNo.Value + ', in ' + qryPsNDirectory.Value + ') from the ' +
    'database. Do you wish the proceed? No changes will be made to the source files.',
    mtConfirmation, [mbYes,mbNo], 0) = mrYes then
  begin
    with qryAdd do
    begin
      SQL.Clear;
      SQL.Add('delete from psn');
      SQL.Add('where Tool = ''' + qryPsNTool.Value + '''');
      SQL.Add('and RunNo = ''' + qryPsNRunNo.Value + '''');
      SQL.Add('and Directory = ''' + qryPsNDirectory.Value + ''';');
      ExecSQL;
    end;
    grdPsN.Refresh;
  end;
end;

procedure TfrmMain.btnReportClick(Sender: TObject);
begin
  //MessageDlg('Not implemented yet!', mtInformation, [mbOK], 0);
end;

procedure TfrmMain.chkExpandedClick(Sender: TObject);
begin
  if chkExpanded.Checked then
    tvRuns.FullExpand
  else
    tvRuns.FullCollapse;
end;

procedure TfrmMain.btnDeleteClick(Sender: TObject);
var
  n: Integer;
begin
  if MessageDlg('Delete this run record (' + qryRunsRunNo.Value + ') from the database? Source files will not be removed.',
    mtConfirmation, [mbYes,mbNo], 0) = mrYes then
      NukeRun(qryRunsRunNo.Value);

  if pgcParams.TabIndex = 3 then
    pgcBottomPageChanged(Sender);

end;

procedure TfrmMain.btnDetailsClick(Sender: TObject);
begin

end;

procedure TfrmMain.actExportExecute(Sender: TObject);
begin
  if not Assigned(frmExportRun) then
    frmExportRun := TfrmExportRun.Create(Application);
  frmExportRun.Show;
end;

procedure TfrmMain.actRunRecExecute(Sender: TObject);
begin
  if not Assigned(frmRunRec) then
    frmRunRec := TfrmRunRec.Create(Application);
  frmRunRec.ShowModal;
end;

procedure TfrmMain.btnCompareClick(Sender: TObject);
begin
  if not Assigned(frmCompare) then
    frmCompare := TfrmCompare.Create(Application);
  frmCompare.Show;
end;

procedure TfrmMain.btnImportFolderClick(Sender: TObject);
//var
//  n: Integer;
//  lstFiles: TStrings;
begin
  if not Assigned(frmImportFolder) then
    frmImportFolder := TfrmImportFolder.Create(Application);
  frmImportFolder.Show;

  ////if dlgDir.Execute then
  ////begin
  //
  //  //if Length(dlgDir.FileName) > 0 then
  //  //begin
  //    if not Assigned(frmImportFolder) then
  //      frmImportFolder := TfrmImportFolder.Create(Application);
  //    frmImportFolder.Show;
  //
  //    with frmImportFolder do
  //    begin
  //      lstFiles := TStringList.Create;
  //      ShellTreeViewSetTextPath(stvDir, dlgDir.FileName);
  //
  //    //if MessageDlg('Would you like to scan subfolders as well?',
  //    //  mtInformation, [mbYes, mbNo], 0) = mrYes then
  //    //  GetFiles(dlgDir.FileName + strDelim + '*.xml', lstFiles, True)
  //    //else
  //
  //    GetFiles(dlgDir.FileName + strDelim + '*.xml', lstFiles, False);
  //      for n := 0 to lstFiles.Count - 1 do
  //        clbFiles.Items.Add(ExtractFileName(lstFiles[n]));
  //
  //    //ShowMessage(lstFiles.Text);
  //    //FindFiles(lstFiles, dlgDir.FileName, '*.xml');
  //      if lstFiles.Count = 0 then
  //      begin
  //        MessageDlg('No suitable XML output files found in this directory.', mtInformation,
  //          [mbOK], 0);
  //        Exit;
  //      end;
  //      lstFiles.Free;
  //    end;
  //  end;
  //end;
end;

procedure TfrmMain.btnPlotClick(Sender: TObject);
begin
  //MessageDlg('Not implemented yet!', mtInformation, [mbOK], 0);
  if not Assigned(frmRProc) then
    frmRProc := TfrmRProc.Create(Application);
  frmRProc.ShowModal;
end;


procedure TfrmMain.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var
  iniOpts: TIniFile;
  cfgFile: string;
begin
  cfgFile := GetAppConfigFile(False);
  if not DirectoryExists(ExtractFilePath(cfgFile)) then
    CreateDir(ExtractFilePath(cfgFile));
  iniOpts := TIniFile.Create(cfgFile, True);
  try
    iniOpts.WriteInteger('MainForm','Left',Left);
    iniOpts.WriteInteger('MainForm','Top',Top);
    iniOpts.WriteInteger('MainForm','Width',Width);
    iniOpts.WriteInteger('MainForm','Height',Height);
  finally
    iniOpts.Free;
  end;

  try
    CloseData;
  except
    ;
  end;
  timScreen.Enabled := False;
  CloseAction := caFree;
  frmMain := nil;
end;


procedure TfrmMain.SetBounds(ALeft, ATop, AWidth, AHeight: integer);
begin
  if (Left <> ALeft) or (Top <> ATop) or (Width <> AWidth) or (Height <> AHeight) then
    InvalidatePreferredSize;
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
end;

procedure TfrmMain.mnuCloseClick(Sender: TObject);
begin
  CloseData;
end;

procedure TfrmMain.btnQuitClick(Sender: TObject);
begin
  if Assigned(strSrc) then
    strSrc.Free;
  if Assigned(strDest) then
    strDest.Free;
  //frmMain := nil;

  Close;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  n, w: Integer;
  sPath: string;
begin
  // set up header for tree
  {sgrHead.Columns.Clear;
  for n := 0 to vstMain.Header.Columns.Count - 1 do
  begin
    sgrHead.Columns.Add;
    sgrHead.Columns[n].Title.Caption := vstMain.Header.Columns[n].CaptionText;
    sgrHead.Columns[n].Width := vstMain.Header.Columns[n].Width;
    sgrHead.Columns[n].Title.Caption := vstMain.Header.Columns[n].Text;
  end;

  sgrHead.Refresh;    }

  strSrc := TStringList.Create;
  strDest := TStringList.Create;

  // Options

  RefreshCfg(True);

  pgcParams.TabIndex := 0;
  pgcBottom.TabIndex := 0;

  pgcMain.TabIndex := 0;
  pgcFiles.TabIndex := 0;
  pgcOmega.TabIndex := 0;
  pgcSigma.TabIndex := 0;
  pgcMisc.TabIndex := 0;

  // Store local path
  sPath := ExtractFilePath(Application.ExeName);
  histFiles.LocalPath := sPath;

  // Define the ini filename and where it is
  histFiles.IniFile := sPath + 'history.ini';

  // Add the history on the parent menu
  histFiles.UpdateParentMenu;

  // Windows font options
  {$ifdef windows}
  memCtl.Font.Size := 0;
  memSummary.Font.Size := 0;
  memNMTran.Font.Size := 0;
  memProbInfo.Font.Size := 0;
  synOutput.Font.Size := 0;
  synXML.Font.Size := 0;
  synExt.Font.Size := 0;
  synCov.Font.Size := 0;
  synCor.Font.Size := 0;
  synCoi.Font.Size := 0;
  synPhi.Font.Size := 0;
  synPhm.Font.Size := 0;
  synShk.Font.Size := 0;
  synGrd.Font.Size := 0;
  synCnv.Font.Size := 0;
  synSmt.Font.Size := 0;
  synRmt.Font.Size := 0;
  synsdtab.Font.Size := 0;
  synpatab.Font.Size := 0;
  syncatab.Font.Size := 0;
  syncotab.Font.Size := 0;
  synmytab.Font.Size := 0;
  synmutab.Font.Size := 0;
  {$endif}

end;

procedure TfrmMain.RefreshCfg(Startup: Boolean);
var
  cfgFile: string;
  iniOpts: TIniFile;
begin
  cfgFile := GetAppConfigFile(False);
  iniOpts := TIniFile.Create(cfgFile, True);

  try
    cenOpts.CondNoLimit := iniOpts.ReadInteger('Warnings','ConditionNumberLimit',1000);
    cenOpts.CorrLimit   := iniOpts.ReadFloat('Warnings','CorrelationLimit',0.9);
    cenOpts.CtlSuffix   := iniOpts.ReadString('Filenames','ControlStreamExt','.mod');
    cenOpts.LstSuffix   := iniOpts.ReadString('Filenames','OutputFileExt','.lst');
    cenOpts.MsfSuffix   := iniOpts.ReadString('Filenames','MSFExt','.msf');
    cenOpts.TabSuffix   := iniOpts.ReadString('Filenames','TableExt','');
    cenOpts.RunPrefix   := iniOpts.ReadString('Filenames','RunPrefix','run');
    cenOpts.ThetaCVLimit := iniOpts.ReadFloat('Warnings','ThetaRSE',0.3);
    cenOpts.OmegaCVLimit := iniOpts.ReadFloat('Warnings','OmegaRSE',0.5);
    cenOpts.SigmaCVLimit := iniOpts.ReadFloat('Warnings','SigmaRSE',0.3);
    cenOpts.UseMD5 := iniOpts.ReadBool('Importing','CaptureMD5',True);
    cenOpts.Precision := iniOpts.ReadInteger('Display','SignificantDigits',4);
    cenOpts.NonNumericConfirm := iniOpts.ReadBool('Importing','NonNumericRunConfirm',False);
    if (Startup = True) then
      SetBounds(iniOpts.ReadInteger('MainForm','Left',0),
              iniOpts.ReadInteger('MainForm','Top',0),
              iniOpts.ReadInteger('MainForm','Width',1200),
              iniOpts.ReadInteger('MainForm','Height',820));
  finally
    iniOpts.Free;
  end;

  if cenOpts.TabSuffix = '.' then
    cenOpts.TabSuffix := '';
  dlgImport.Filter := 'NONMEM output file (*.xml)|*.xml';

end;

procedure TfrmMain.btnNewClick(Sender: TObject);
var
  n: Integer;
  Stream: TLazarusResourceStream;
begin
  if dlgNew.Execute then
  begin
    try
      if FileExists(dlgNew.FileName) then
      begin
        if MessageDlg('A file with the same name already exists. Overwrite it?',
          mtWarning, [mbYes,mbNo], 0) = mrYes then
          DeleteFile(dlgNew.FileName)
        else
        begin
          Exit;
        end;
      end;

      Stream := nil;
      try
        //load the lazarus resource
        Stream := TLazarusResourceStream.Create('empty', nil);
        //save to a file
        Stream.SaveToFile(dlgNew.FileName);
      finally
        Stream.Free;
      end;

      zConn.Connected := False;
      zConn.Database := dlgNew.FileName;
      //sqlCreate.ExecSQL;
    finally
      if Length(zConn.Database) > 0 then
        OpenData;
    end;
  end;
end;

procedure TfrmMain.btnOpenClick(Sender: TObject);
begin
  if dlgOpen.Execute then
  begin
    if FileExists(dlgOpen.FileName) then
    begin
      zConn.Connected := False;
      zConn.Database := dlgOpen.FileName;
      OpenData;
      // Add the filename into the history and refresh the menu
      histFiles.UpdateList(dlgOpen.FileName);
    end;
  end;
end;


procedure TfrmMain.OpenData;
var
  n: Integer;
  //aiNode: INode;
  //node : TFDNode;
  //aparent : TFDNode;
begin
  try
    try
      zConn.Connected := True;
      //CheckFields;
    except
      zConn.Connected := False;
      zConn.Database := '';
      MessageDlg('This file (' + ExtractFileName(dlgOpen.FileName) + ') cannot be ' +
        'opened due to an unknown error.', mtError, [mbOK], 0);
      frmMain.Caption := 'Census';
      sbMain.Panels[0].Text := 'No file open';
      //Exit;
    end;
  finally
    if zConn.Connected then
    begin
      frmMain.Caption := 'Census - ' + ExtractFileName(zConn.Database);
      sbMain.Panels[0].Text := 'Connected - ' + zConn.Database;

      with qryAdd do
      begin
        SQL.Clear;
        SQL.Add('update est');
        SQL.Add('set dOFV=NULL');
        SQL.Add('where ParentNo=NULL;');
        ExecSQL;
      end;

      with qryRuns do
      begin
        Active := False;
        Unprepare;
        SQL.Clear;
        SQL.Add('select * from runs');
        SQL.Add('order by iRunNo;');
        Prepare;
        Active := True;
        First;
      end;

      with qryEst do
      begin
        Active := False;
        Unprepare;
        SQL.Clear;
        SQL.Add('select * from est');
        SQL.Add('where RunNo = ''' + qryRunsRunNo.Value + '''');
        SQL.Add('order by EstNo;');
        Prepare;
        Active := True;
        First;
      end;

      with qryPsN do
      begin
        Active := False;
        Unprepare;
        SQL.Clear;
        SQL.Add('select * from psn');
        SQL.Add('where RunNo = ''' + qryRunsRunNo.Value + '''');
        SQL.Add('order by Tool,Timestamp;');
        Prepare;
        Active := True;
        First;
      end;

      mnuClose.Enabled := True;
      mnuProperties.Enabled := True;

      mnuImport.Enabled := True;
      mnuImportFolder.Enabled := True;

      if qryRuns.RecordCount > 0 then
      begin
        mnuArchive.Enabled := True;
        mnuArchiveAll.Enabled := True;
        mnuExportLatex.Enabled := True;
        mnuExportRunRec.Enabled := True;
        btnDelete.Enabled := True;
        mnuDelete.Enabled := True;
        btnReport.Enabled := True;
        btnRunRec.Enabled := True;
        btnCompare.Enabled := True;
      end
      else
      begin
        mnuArchive.Enabled := False;
        mnuArchiveAll.Enabled := False;
        mnuExportLatex.Enabled := False;
        mnuExportRunRec.Enabled := False;
        btnDelete.Enabled := False;
        mnuDelete.Enabled := False;
        btnReport.Enabled := False;
        btnRunRec.Enabled := False;
        btnCompare.Enabled := False;
      end;

      btnImport.Enabled := True;
      btnImportFolder.Enabled := True;
      btnPlot.Enabled := True;

      if qryRuns.RecordCount > 0 then
      begin
        btnPsNAdd.Enabled := True;
        btnPsNDelete.Enabled := True;
        btnDetails.Enabled := True;
      end
      else
      begin
        btnPsNAdd.Enabled := False;
        btnPsNDelete.Enabled := False;
        btnDetails.Enabled := False;
      end;

      pgcBottomPageChanged(pgcBottom);
      Application.ProcessMessages;

      grdTheta.Refresh;
      grdOmega.Refresh;
      grdSigma.Refresh;
      grdPsN.Refresh;

    end
    else
    begin
      mnuClose.Enabled := False;
      mnuProperties.Enabled := False;

      btnImport.Enabled := False;
      btnImportFolder.Enabled := False;
      btnDelete.Enabled := False;
      btnPlot.Enabled := False;
      btnReport.Enabled := False;
      btnRunRec.Enabled := False;
      btnCompare.Enabled := False;

      mnuImport.Enabled := False;
      mnuDelete.Enabled := False;
      mnuImportFolder.Enabled := False;
      mnuExportLatex.Enabled := False;
      mnuExportRunRec.Enabled := False;

      btnPsNAdd.Enabled := False;
      btnPsNDelete.Enabled := False;
      btnDetails.Enabled := False;
    end;
  BuildTree;
  end;
end;

procedure TfrmMain.CheckFields;
begin
{  qryPsN.Active := True;
  if
  begin
    qryGeneral.SQL.Clear;
    qryGeneral.SQL.Add('ALTER TABLE psn ADD COLUMN PDF text;');
    try
      qryGeneral.ExecSQL;
    except
      MessageDlg('Error updating the PsN table!', mtError, [mbOK], 0);
      qryPsN.Active := False;
    end;
  end;
  qryPsN.Active := False;   }
end;

procedure TfrmMain.BuildTree;
var
  zNode, rNode, pNode, aNode: TTreeNode;
  n: Integer;
begin
  // build tree
  with qryGeneral do
  begin
    SQL.Clear;
    SQL.Add('select RunNo, ParentNo');
    SQL.Add('from runs');
    SQL.Add('order by iRunNo;');
    Active := True;
  end;

  tvRuns.BeginUpdate;
  tvRuns.Items.Clear;
  zNode := tvRuns.Items.Add(nil, 'All runs');
  qryGeneral.First;
  for n := 0 to qryGeneral.RecordCount - 1 do
  begin
    aNode := tvRuns.Items.AddChild(zNode, qryGeneral.FieldByName('RunNo').Value);
    qryGeneral.Next;
  end;

  qryGeneral.First;
  for n := 0 to qryGeneral.RecordCount - 1 do
  begin
    if qryGeneral.FieldByName('ParentNo').Value <> null then
    begin
      //ShowMessage(qryGeneral.FieldByName('ParentNo').Value);
      pNode := GetNodeByText(tvRuns, qryGeneral.FieldByName('ParentNo').Value, True);
      aNode := GetNodeByText(tvRuns, qryGeneral.FieldByName('RunNo').Value, True);
      try
        if pNode <> nil then
        begin
          rNode := tvRuns.Items.AddChild(pNode, aNode.Text);
          aNode.Free;
        end;
      except ;
      end;
    end;
    qryGeneral.Next;
  end;
  tvRuns.EndUpdate;
  tvRuns.FullCollapse;
end;

function TfrmMain.GetNodeByText(ATree : TTreeView; AValue:String;
  AVisible: Boolean): TTreeNode;
var
    Node: TTreeNode;
begin
  Result := nil;
  if ATree.Items.Count = 0 then Exit;
  Node := ATree.Items[0];
  while Node <> nil do
  begin
    if UpperCase(Node.Text) = UpperCase(AValue) then
    begin
      Result := Node;
      if AVisible then
        Result.MakeVisible;
      Break;
    end;
    Node := Node.GetNext;
  end;
end;

procedure TfrmMain.CloseData;
begin
  if zConn.Connected then
  begin
    try
      qryRuns.Active := False;
      qryEst.Active := False;
      qryTheta.Active := False;
      qryOmega.Active := False;
      qrySigma.Active := False;
      qryTrans.Active := False;
      qryPsN.Active := False;

      qryGeneral.Active := False;
      qryGeneral.SQL.Clear;
      qryGeneral.SQL.Add('VACUUM;');
      qryGeneral.ExecSQL;
    finally
      tvRuns.Items.Clear;
      frmMain.Caption := 'Census';
      sbMain.Panels[0].Text := 'No file open';

      // vstMain.Clear;

      zConn.Connected := False;
      zConn.Database := '';
      frmMain.Caption := 'Census';
      sbMain.Panels[0].Text := 'No file open';

      mnuClose.Enabled := False;
      mnuProperties.Enabled := False;
      mnuExportLatex.Enabled := False;
      mnuExportRunRec.Enabled := False;
      mnuArchive.Enabled := False;
      mnuArchiveAll.Enabled := False;
      mnuImport.Enabled := False;
      mnuImportFolder.Enabled := False;
      mnuDelete.Enabled := False;

      btnImport.Enabled := False;
      btnImportFolder.Enabled := False;
      btnDelete.Enabled := False;
      btnPlot.Enabled := False;
      btnReport.Enabled := False;
      btnRunRec.Enabled := False;

      btnPsNAdd.Enabled := False;
      btnPsNDelete.Enabled := False;
      btnDetails.Enabled := False;
      btnCompare.Enabled := False;
    end;
  end;

end;

procedure TfrmMain.btnImportClick(Sender: TObject);
begin
  if dlgImport.Execute then
  begin
    if ExtractFileExt(dlgImport.FileName) = '.xml' then
      CaptureRunXML(dlgImport.FileName, True);
    if ExtractFileExt(dlgImport.FileName) = cenOpts.LstSuffix then
      //CaptureRunLst(dlgImport.FileName);
      MessageDlg('Not yet implemented.', mtInformation, [mbOK], 0);
  end;
end;

// ********************************************************************
// ExtractNumberInString function
// ********************************************************************

function TfrmMain.ExtractNumberInString(strFileName: string): Integer;
var
  i: Integer;
  ResultStr: string;
begin
  for i := Length(strFileName) downto 1 do
  begin
    if (strFileName[i] in ['0'..'9']) then
    begin
      ResultStr := strFileName[i] + ResultStr;
    end
    else
      if Length(ResultStr) > 0 then
      begin
        Result := StrToIntDef(ResultStr, 0);
        Exit;
      end;
  end;
  Result := StrToIntDef(ResultStr, 0);
end;

procedure TfrmMain.NukeRun(strRun: string);
var
  OldCursor: TCursor;
  n: Integer;
begin
  oldCursor := Screen.Cursor;
  Screen.Cursor := crHourglass;

  try
    // theta
    try
      grdTheta.DataSource := nil;

      qryGeneral.Active := False;
      qryGeneral.SQL.Clear;
      qryGeneral.SQL.Add('DELETE FROM thetas');
      qryGeneral.SQL.Add('WHERE RunNo = ' + QuotedStr(strRun) + ';');
      //ShowMessage(qryGeneral.SQL.Text);
      qryGeneral.ExecSQL;
    finally
      qryTheta.Refresh;
      grdTheta.DataSource := dsTheta;
    end;

    // omega
    try
      grdOmega.DataSource := nil;

      qryGeneral.Active := False;
      qryGeneral.SQL.Clear;
      qryGeneral.SQL.Add('DELETE FROM omegas');
      qryGeneral.SQL.Add('WHERE RunNo = ' + QuotedStr(strRun) + ';');
      qryGeneral.ExecSQL;
    finally
      qryOmega.Refresh;
      grdOmega.DataSource := dsOmega;
    end;

    // sigma
    try
      grdSigma.DataSource := nil;

      qryGeneral.Active := False;
      qryGeneral.SQL.Clear;
      qryGeneral.SQL.Add('DELETE FROM sigmas');
      qryGeneral.SQL.Add('WHERE RunNo = ' + QuotedStr(strRun) + ';');
      qryGeneral.ExecSQL;
    finally
      qrySigma.Refresh;
      grdSigma.DataSource := dsSigma;
    end;

    // est
    try
      grdEst.DataSource := nil;

      qryGeneral.Active := False;
      qryGeneral.SQL.Clear;
      qryGeneral.SQL.Add('DELETE FROM est');
      qryGeneral.SQL.Add('WHERE RunNo = ' + QuotedStr(strRun) + ';');
      qryGeneral.ExecSQL;
    finally
      qryEst.Refresh;
      grdEst.DataSource := dsEst;
    end;

    // runs
    try
      grdRuns.DataSource := nil;
      qryGeneral.Active := False;
      qryGeneral.SQL.Clear;
      qryGeneral.SQL.Add('DELETE FROM runs');
      qryGeneral.SQL.Add('WHERE RunNo = ' + QuotedStr(strRun) + ';');
      qryGeneral.ExecSQL;
    finally
      qryRuns.Refresh;
      grdRuns.DataSource := dsRuns;
    end;

  finally
    Screen.Cursor := oldCursor;
  end;

  if qryRuns.RecordCount > 0 then
  begin
    mnuArchive.Enabled := True;
    mnuArchiveAll.Enabled := True;
    mnuExportLatex.Enabled := True;
    mnuExportRunRec.Enabled := True;
    btnDelete.Enabled := True;
    mnuDelete.Enabled := True;
    btnReport.Enabled := True;
    btnRunRec.Enabled := True;
    btnCompare.Enabled := True;
  end
  else
  begin
    mnuArchive.Enabled := False;
    mnuArchiveAll.Enabled := False;
    mnuExportLatex.Enabled := False;
    mnuExportRunRec.Enabled := False;
    btnDelete.Enabled := False;
    mnuDelete.Enabled := False;
    btnReport.Enabled := False;
    btnRunRec.Enabled := False;
    btnCompare.Enabled := False;
  end;

end;

procedure TfrmMain.CaptureRunLst(nmFile: string);
var
  strComment, strMin, strFnEval, strSigDig, strModel,
    strObsRecs, strInds, strCondEst, strCentEta, strInter,
    strLaplacian, strCov, strObj, strObj2, strMinFull, strRun, strParent, strTemp,
    strBOTicker, strLastMethod: string;
  strList, strOmegaList, strSigmaList: TStrings;
  n, m, p, q, r, intTheta, intOmega, intOmegaBlk, intSigma, intSigmaBlk, intRun, intBOCount,
    intBO2, intBSCount, intBS2, intLines, intT2L, intHessian, intOmegaRatio: Integer;
  ThLabel, ThLower, ThInit, ThUpper, ThValue, ThSE: TStrings;
  OmInit, SigInit, EtaBar, EtaP, EtaBarSE, Eta, Eps, SigSE, OmSE: TStrings;
  lstLog, lstMinTerm, lstCovSum, lstBlockOmega, lstBlockSigma: TStrings;
  EtaLabel, EtaShrinkage, EpsShrinkage, ThetaModel, PKParams, lstMatrixOmega, lstMatrixSigma,
    lstMatrixOmegaInit, lstMatrixSigmaInit, lstLargeSEs, lstZeroCIs,
    lstMatrixOmegaSE, lstMatrixSigmaSE, lstScratch, lstTemp, lstTemp2,
    lstCovMatrix, lstCorrMatrix, lstInvCovMatrix, lstEigen, lstPsNRunRec: TStrings;
  lstOmegaBlkVars, lstSigmaBlkVars, lstNotes, lstOmegaIndex, lstSigmaIndex: TStrings;
  swFP, swSE, swMinTerm, swCovSum, blnDebug, swBlockOmega,
    swBlockSigma, blnLT, blnGoodRun, blnInlineCtl, blnOFVSeen, blnOFVWarn,
    blnNM7Run, blnNMQualRun: Boolean;
  strModFile, strDataFile, strEtaL, strEtaL2, strT, strT2, strWFN: string;
  btnPK, blnARun, blnBOInit, blnBSInit, blnCovStep, blnEtaBlocks,
    blnSigmaBlocks, blnThetasOn, blnEtasOn, blnZeroGradients, btnSub, blnPriors,
    blnFZeroGradients, blnLargeSEs, blnBoundaries, blnZeroCIs, blnPrdErr,
    blnEtaBar, blnCap, blnFO, blnFOCE, blnBayes, blnSAEM, blnITS, blnImp, blnImpMap,
    blnLaplacian, blnMD5, blnAsk: Boolean;
  arSigDig: array of string;
  fltCondNo, fltEigenUpper, fltEigenLower, fltEpsShrinkage, fltEstTime, fltCovTime: Double;
  intEtCt, intFixedOmegas, intFixedSigmas, intBNo, intZeroGradients: Integer;
  PsNRunRec: TPsNRunRec;
begin
// ********************************************************************
// Go to safe page
// ********************************************************************
  pgcMain.ActivePageIndex := 0;
// ********************************************************************
// Initialize variables
// ********************************************************************
  //tblRuns.Filtered := False;
  intEtCt := 0; // Eta count
  brkUpp.AllowEmptyString := False;
  strList := TStringList.Create; // Main output file
  lstLog := TStringList.Create; // Log file
  swFP := True; // Final parameters switch
  swSE := False; // Standard errors switch
  swCovSum := False; // Covariance summary switch
  swMinTerm := False; // MINIMIZATION TERMINATED switch
  swBlockOmega := False; // Block OMEGA switch
  swBlockSigma := False; // Block SIGMA switch
  blnPrdErr := False; // errors in PRDERR
  blnDebug := False; // Debug mode
  if pgcMain.ActivePageIndex = 3 then
    pgcMain.ActivePageIndex := 0;
  ThLabel := TStringList.Create; // List of THETA labels
  strOmegaList := TStringList.Create; // List of OMEGA labels
  strSigmaList := TStringList.Create; // List of SIGMA labels
  ThLower := TStringList.Create; // List of THETA lower bounds
  ThInit := TStringList.Create; // List of THETA initial estimates
  ThUpper := TStringList.Create; // List of THETA upper bounds
  ThValue := TStringList.Create; // List of THETA estimates
  ThSE := TStringList.Create; // List of THETA standard errors
  OmInit := TStringList.Create; // List of OMEGA initial estimates
  OmSE := TStringList.Create; // List of OMEGA standard errors
  SigInit := TStringList.Create; // List of SIGMA initial estimates
  SigSE := TStringList.Create; // List of SIGMA standard errors
  EtaBar := TStringList.Create; // List of ETABARs
  EtaBarSE := TStringList.Create; // List of ETABAR SEs
  EtaP := TStringList.Create; // List of ETABAR P values
  EtaShrinkage := TStringList.Create; // List of ETA shrinkage values
  EtaLabel := TStringList.Create; // List of ETA labels
  Eta := TStringList.Create; // List of ETA estimates
  Eps := TStringList.Create; // List of EPS estimates
  EpsShrinkage := TStringList.Create; // List of EPS shrinkage values
  lstCovSum := TStringList.Create; // Covariance summary
  lstPsNRunRec := TStringList.Create; // PsN runrecord
  lstMinTerm := TStringList.Create; // MINIMIZATION TERMINATED message
  lstBlockOmega := TStringList.Create; // BLOCK OMEGA section
  lstOmegaBlkVars := TStringList.Create; // List of BLOCK OMEGA vars
  lstSigmaBlkVars := TStringList.Create; // List of BLOCK SIGMA vars
  lstOmegaIndex := TStringList.Create;
  lstSigmaIndex := TStringList.Create;
  lstBlockSigma := TStringList.Create; // BLOCK SIGMA section
  lstMatrixOmega := TStringList.Create; // OMEGA matrix
  lstMatrixSigma := TStringList.Create; // SIGMA matrix
  lstMatrixOmegaSE := TStringList.Create; // OMEGA matrix SEs
  lstMatrixSigmaSE := TStringList.Create; // SIGMA matrix SEs
  lstMatrixOmegaInit := TStringList.Create; // OMEGA matrix initial estimates
  lstMatrixSigmaInit := TStringList.Create; // SIGMA matrix initial estimates
  lstCovMatrix := TStringList.Create; // Covariance matrix
  lstCorrMatrix := TStringList.Create; // Correlation matrix
  lstInvCovMatrix := TStringList.Create; // Inverse covariance matrix
  lstEigen := TStringList.Create; // Eigenvalues
  lstScratch := TStringList.Create; // Scratch area
  lstTemp := TStringList.Create; // Another temp list
  lstTemp2 := TStringList.Create; // Another temp list
  lstZeroCIs := TStringList.Create; // Zero CIs
  lstLargeSEs := TStringList.Create; // Large SEs
  lstNotes := TStringList.Create; // Notes
  blnInlineCtl := False; // Inline control stream?
  blnOFVSeen := False;   // OFV present?
  strEtaL := '';
  strEtaL2 := '';
  blnOFVWarn := False;
  blnARun := False;
  blnBOInit := False;
  blnBSInit := False;
  blnCovStep := True;
  blnMD5 := cenOpts.UseMD5;
  blnAsk := False;
  blnCap := False;
  strInter := 'NO';
  strLaplacian := 'NO';
  strCondEst := 'NO';
  strCentEta := 'NO';
  blnEtaBlocks := False;
  blnSigmaBlocks := False;
  blnZeroGradients := False;
  blnFZeroGradients := False;
  blnLargeSEs := False;
  blnBoundaries := False;
  blnZeroCIs := False;
  intOmega := 0;
  fltEpsShrinkage := 0;
  fltEstTime := 0;
  fltCovTime := 0;
  intOmegaBlk := 0;
  intTheta := 0;
  intSigma := 0;
  intSigmaBlk := 0;
  intRun := 0;
  intBOCount := 0;
  intBSCount := 0;
  intZeroGradients := 0;
  strSigDig := '';
  strT := '';
  strT2 := '';
  intLines := 0;
  intT2L := 0;
  intHessian := 0;
  intFixedOmegas := 0;
  intFixedSigmas := 0;
  strParent := '';
  blnGoodRun := False;
  blnNMQualRun := False;
  blnEtaBar := True;
  strBOTicker := '';
  intBNo := 0;
  blnFO := False;
  blnFOCE := False;
  blnSAEM := False;
  blnBayes := False;
  blnITS := False;
  blnImp := False;
  blnImpMap := False;
  blnLaplacian := False;
  strLastMethod := '';

  //blnDebug := True;
// ********************************************************************
// Load output file into strList
// ********************************************************************
  if FileExists(nmFile) = False then
  begin
    MessageDlg('The specified file does not exist.', mtError, [mbOK], 0);
    Exit;
  end;
  if FileExists(nmFile) then
  begin
    try
      strList.LoadFromFile(nmFile);
      // Check for valid input - can be anywhere in the file
      for n := 0 to strList.Count - 1 do
      begin
        if (Pos('ORIGINALLY DEVELOPED BY STUART BEAL, LEWIS SHEINER, AND ALISON BOECKMANN', strList[n]) > 0) then
          blnGoodRun := True;
        if (Pos('<identifier>This log was generated by nmqual.pl', strList[n]) > 0) then
          blnNMQualRun := True;
      end;

      if (blnGoodRun = False) then
      begin
        if MessageDlg('The specified file (' + ExtractFileName(nmFile) +
          ') does not appear to be a ' +
          'NONMEM 7.x output stream. Would you like to attempt to capture it' +
          ' anyway?', mtError, [mbYes, mbNo], 0) = mrNo then
          Exit;
      end;

      lstLog.Add('Opened ' + nmFile + '...');
      lstLog.Add('-----------------------------------------');
      strRun := StringReplace(ExtractFileName(nmFile), cenOpts.RunPrefix, '', [rfReplaceAll]);
      strRun := StringReplace(strRun, cenOpts.LstSuffix, '', [rfReplaceAll]);
      lstLog.Add('Length of filename... ' + IntToStr(Length(strRun)));
      for n := 1 to Length(strRun) do
        if not (strRun[n] in ['0'..'9']) then
          blnARun := True;
      intRun := ExtractNumberInString(ExtractFileName(nmFile));
      if (blnARun) and (blnAsk) {strRun <> IntToStr(intRun)} then
        strRun := InputBox('Please confirm your run number... [' +
          nmFile + ']', 'Run Number', strRun);
      lstLog.Add('Run number... ' + strRun);

      /// does run exist?
      // ***************************************************

      qryGeneral.Active := False;
      qryGeneral.SQL.Clear;
      qryGeneral.SQL.Add('select RunNo');
      qryGeneral.SQL.Add('from runs');
      qryGeneral.SQL.Add('where RunNo = ''' + strRun + ''';');
      qryGeneral.Active := True;

      if qryGeneral.RecordCount > 0 then
      begin
        if MessageDlg('A run with the same name (' + strRun + ') appears to be in the database already. ' +
          'Do you want to replace it?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
          NukeRun(strRun)
        else
          begin
            MessageDlg('Import cancelled.', mtInformation, [mbOK], 0);
            Exit;
          end;
      end;
      qryGeneral.Active := False;
      qryGeneral.SQL.Clear;

      lstLog.Add('Length of output file... ' + IntToStr(strList.Count));

      {regEx := TPerlRegEx.Create;

      regEx.Subject := strList.Text;
      regEx.Options := [preMultiLine,preSingleLine,preUnGreedy];

      regEx.RegEx := '(?<= #OBJV:\*{44})[ ]*-?\d+\.\d+[ ]*(?=(\*{50}))';
      if (regEx.Match) then
      begin
        blnOFVSeen := True;
        strObj := regEx.MatchedText;
        while regEx.MatchAgain do
          strObj := regEx.MatchedText;   // last reported OFV/likelihood is taken
      end;       }

      with TRegExpr.Create do
      try
        Expression := '(?<= #OBJV:\*{44})[ ]*-?\d+\.\d+[ ]*(?=(\*{50}))';
        if Exec(strList.Text) then
        repeat
        begin
          strObj := Match[0];
          blnOFVSeen := True;
        end
        until not ExecNext;
      finally
        Free;
      end;

      if blnOFVSeen = False then
      begin
        //if not Assigned(frmScanDialog) then
          MessageDlg('This run seems to have terminated prematurely, ' +
            'or contains no estimation step. No objective function value ' +
            'appears to be present. Import cancelled.', mtError, [mbOK], 0);
        Exit;
      end;

      {regEx.RegEx := 'THERE ARE ERROR MESSAGES IN FILE PRDERR';
      if (regEx.Match) then
      begin
        blnPrdErr := True;
        lstLog.Add('Errors in PRDERR...');
      end;

      // TODO: hessian resets

      regEx.RegEx := '^\s*\$PROB';
      if (regEx.Match) then
      begin
        blnInlineCtl := True;
        lstLog.Add('Inline control stream found...');
      end;

      regEx.RegEx := 'COVARIANCE STEP ABORTED';
      if (regEx.Match) then
      begin
        blnCovStep := False;
        lstLog.Add('Covariance step aborted...');
          //ShowMessage('Standard Errors on');
      end;

      regEx.RegEx := '(?<=\*{20}[ ]{26}COVARIANCE MATRIX OF ESTIMATE[ ]{25}\*{20}).*(?=(^1))';
      if (regEx.Match) then
      begin
        swFP := False;
        swSE := False;
        lstLog.Add('Covariance matrix detected...');
        //ShowMessage(regEx.MatchedExpression);
      end;

      // TODO: T matrix

      // TODO: covariance step terminated

      regEx.RegEx := '(?<= PROBLEM NO.:[ ]{9}1).*(?=(0DATA CHECKOUT RUN:))';
      if (regEx.Match) then
      begin
        strComment := Trim(regEx.MatchedText);
        lstLog.Add('Comment... ' + strComment);
      end;

// ********************************************************************
// Read no of observations
// ********************************************************************

      strObsRecs := OneLineRegEx(strList.Text, '(?<=TOT. NO. OF OBS RECS:).*?\r?\n', False);
      lstLog.Add('Observation Records... ' + strObsRecs);

// ********************************************************************
// Read no of individuals
// ********************************************************************

      strInds := OneLineRegEx(strList.Text, '(?<=TOT. NO. OF INDIVIDUALS:).*?\r?\n', False);
      lstLog.Add('Individuals... ' + strInds);

// ********************************************************************
// Count THETAs
// ********************************************************************

      intTheta := StrToInt(OneLineRegEx(strList.Text, '(?<=LENGTH OF THETA:).*?\r?\n', False));
      lstLog.Add('THETAs... ' + IntToStr(intTheta));

// ********************************************************************
// PRIORS?
// ********************************************************************

      regEx.Options := [preMultiLine,preSingleLine,preUnGreedy];
      regEx.RegEx := 'PRIOR SUBROUTINE USER-SUPPLIED';
      if (regEx.Match) then
      begin
        lstLog.Add('Priors detected...');
        blnPriors := True;
        //ShowMessage('priors');
      end;

// ********************************************************************
// Count OMEGAs (simple diagonal)
// ********************************************************************

      regEx.Options := [preMultiLine,preUnGreedy];
      regEx.RegEx := '(?<=OMEGA HAS SIMPLE DIAGONAL FORM WITH DIMENSION:).*?\r?\n';
      if (regEx.Match) then
      begin
        lstLog.Add('OMEGAs: Simple diagonal');
        intOmega := StrToInt(Trim(regEx.MatchedText));
        lstLog.Add('OMEGAs... ' + IntToStr(intOmega));
        //ShowMessage(IntToStr(intOmega));
      end;

// ********************************************************************
// Count OMEGAs (block)
// ********************************************************************
      regEx.Options := [preMultiLine,preSingleLine,preUnGreedy];
      regEx.RegEx := '(?<=OMEGA HAS BLOCK FORM:).*(?=(^0))';
      if (regEx.Match) then
      begin
        lstLog.Add('OMEGAs: Block');
        swBlockOmega := True;
        blnEtaBlocks := True;
        intBOCount := 0;
        lstTemp.Clear;
        lstTemp.Add(regEx.MatchedText);

        lstTemp.Text := StringReplace(StringReplace(lstTemp.Text, #10, '£', [rfReplaceAll]), #13, 'ç', [rfReplaceAll]);
        lstTemp.Text := StringReplace(lstTemp.Text, '£ç',#13, [rfReplaceAll]);
        lstTemp.Text := StringReplace(lstTemp.Text, 'ç£', #13, [rfReplaceAll]);
        lstTemp.Text := StringReplace(lstTemp.Text, '£', #13, [rfReplaceAll]);
        lstTemp.Text := StringReplace(lstTemp.Text, 'ç', #13, [rfReplaceAll]);

        lstOmegaBlkVars.Assign(lstTemp);

        //ShowMessage(IntToStr(lstOmegaBlkVars.Count));
        //ShowMessage(lstOmegaBlkVars.Text);

        brkUpp.AllowEmptyString := False;
        //ShowMessage(lstTemp.Text);
        brkUpp.BaseString := StringReplace(StringReplace(lstTemp.Text, #10, '', [rfReplaceAll]), #13, '', [rfReplaceAll]);
        brkUpp.BreakString := ' ';
        brkUpp.BreakApart;
        //ShowMessage(brkUpp.StringList[brkUpp.StringList.Count - 1]);
        intOmegaBlk := StrToInt(brkUpp.StringList[brkUpp.StringList.Count - 1]);

        for n := 1 to 200 do
        begin
          if ((n*n) + n)/2 = brkUpp.StringList.Count then
            intOmega := n;
        end;

        //ShowMessage(intToStr(intOmega));
        lstLog.Add('OMEGAs: ' + IntToStr(intOmega));
        lstLog.Add('OMEGA blocks: ' + IntToStr(intOmegaBlk));

        for n := 1 to intOmega do
        begin
          strOmegaList.Add(Trim(brkUpp.StringList[Round((((n*n) + n)/2)-1)]));
          //lstOmegaBlkVars.Add(Trim(brkUpp.StringList[Round((((n*n) + n)/2)-1)]));
          lstLog.Add('Adding ' + Trim(brkUpp.StringList[Round((((n*n) + n)/2)-1)]) +
            ' to OMEGA block...');
        end;
      end;

// ********************************************************************
// Count SIGMAs (simple diagonal)
// ********************************************************************

      regEx.Options := [preMultiLine,preUnGreedy];
      regEx.RegEx := '(?<=SIGMA HAS SIMPLE DIAGONAL FORM WITH DIMENSION:).*?\r?\n';
      if (regEx.Match) then
      begin
        lstLog.Add('SIGMAs: Simple diagonal');
        intSigma := StrToInt(Trim(regEx.MatchedText));
        lstLog.Add('SIGMAs... ' + IntToStr(intSigma));
        //ShowMessage(IntToStr(intSigma));
      end;

// ********************************************************************
// Count SIGMAs (block)
// ********************************************************************
      regEx.Options := [preMultiLine,preSingleLine,preUnGreedy];
      regEx.RegEx := '(?<=SIGMA HAS BLOCK FORM:).*(?=(^0))';
      if (regEx.Match) then
      begin
        lstLog.Add('SIGMAs: Block');
        swBlockSigma := True;
        blnSigmaBlocks := True;
        intBOCount := 0;
        lstTemp.Clear;
        lstTemp.Add(regEx.MatchedText);

        lstTemp.Text := StringReplace(StringReplace(lstTemp.Text, #10, '£', [rfReplaceAll]), #13, 'ç', [rfReplaceAll]);
        lstTemp.Text := StringReplace(lstTemp.Text, '£ç',#13, [rfReplaceAll]);
        lstTemp.Text := StringReplace(lstTemp.Text, 'ç£', #13, [rfReplaceAll]);
        lstTemp.Text := StringReplace(lstTemp.Text, '£', #13, [rfReplaceAll]);
        lstTemp.Text := StringReplace(lstTemp.Text, 'ç', #13, [rfReplaceAll]);

        lstSigmaBlkVars.Assign(lstTemp);

        //ShowMessage(IntToStr(lstSigmaBlkVars.Count));
        //ShowMessage(lstSigmaBlkVars.Text);

        brkUpp.AllowEmptyString := False;
        //ShowMessage(lstTemp.Text);
        brkUpp.BaseString := StringReplace(StringReplace(lstTemp.Text, #10, '', [rfReplaceAll]), #13, '', [rfReplaceAll]);
        brkUpp.BreakString := ' ';
        brkUpp.BreakApart;
        //ShowMessage(brkUpp.StringList[brkUpp.StringList.Count - 1]);
        intSigmaBlk := StrToInt(brkUpp.StringList[brkUpp.StringList.Count - 1]);

        for n := 1 to 200 do
        begin
          if ((n*n) + n)/2 = brkUpp.StringList.Count then
            intSigma := n;
        end;

        //ShowMessage(intToStr(intOmega));
        lstLog.Add('SIGMAs: ' + IntToStr(intSigma));
        lstLog.Add('SIGMA blocks: ' + IntToStr(intSigmaBlk));

        for n := 1 to intSigma do
        begin
          strSigmaList.Add(Trim(brkUpp.StringList[Round((((n*n) + n)/2)-1)]));
          //lstSigmaBlkVars.Add(Trim(brkUpp.StringList[Round((((n*n) + n)/2)-1)]));
          lstLog.Add('Adding ' + Trim(brkUpp.StringList[Round((((n*n) + n)/2)-1)]) +
            ' to SIGMA block...');
        end;
      end;

// ********************************************************************
// Initial estimates & bounds of THETA
// ********************************************************************
      regEx.Options := [preMultiLine,preSingleLine,preUnGreedy];
      regEx.RegEx := '(?<=INITIAL ESTIMATE OF THETA:).*(?=(0INITIAL ESTIMATE OF OMEGA:))';
      if (regEx.Match) then
      begin
        lstLog.Add('Starting THETA initial estimates...');
        //ShowMessage(regEx.MatchedText);

        lstTemp.Clear;
        lstTemp.Add(regEx.MatchedText);

        lstTemp.Text := StringReplace(StringReplace(lstTemp.Text, #10, '£', [rfReplaceAll]), #13, 'ç', [rfReplaceAll]);
        lstTemp.Text := StringReplace(lstTemp.Text, '£ç',#13, [rfReplaceAll]);
        lstTemp.Text := StringReplace(lstTemp.Text, 'ç£', #13, [rfReplaceAll]);
        lstTemp.Text := StringReplace(lstTemp.Text, '£', #13, [rfReplaceAll]);
        lstTemp.Text := StringReplace(lstTemp.Text, 'ç', #13, [rfReplaceAll]);

        if (Pos('LOWER', lstTemp.Text) > 0) then
        begin
          for m := 1 to intTheta do
          begin
            ThLower.Add(BrkUp(' ', lstTemp[m+1], 0));
            lstLog.Add('THETA(' + IntToStr(m) + ') Lower Bound... ' +
              BrkUp(' ', lstTemp[m+1], 0));
            ThInit.Add(BrkUp(' ', lstTemp[m+1], 1));
            lstLog.Add('THETA(' + IntToStr(m) + ') Initial Est... ' +
              BrkUp(' ', lstTemp[m+1], 1));
            ThUpper.Add(BrkUp(' ', lstTemp[m+1], 2));
            lstLog.Add('THETA(' + IntToStr(m) + ') Upper Bound... ' +
              BrkUp(' ', lstTemp[m+1], 2));
          end;
        end
        else
        begin
          brkUpp.AllowEmptyString := False;
          brkUpp.BaseString := Trim(lstTemp.Text);
          brkUpp.BreakString := ' ';
          brkUpp.BreakApart;
         // ShowMessage(brkUpp.StringList.Text);
          for m := 1 to intTheta do
          begin
            ThLower.Add('-100000');
            ThInit.Add(brkUpp.StringList[m-1]);
            lstLog.Add('THETA(' + IntToStr(m) + ') Initial Est... ' +
              brkUpp.StringList[m-1]);
            ThUpper.Add('100000');
          end;
        end;

        //ShowMessage(ThLower.Text);
        //ShowMessage(ThInit.Text);
        //ShowMessage(ThUpper.Text);
      end;

// ********************************************************************
// Initial estimates of OMEGA
// ********************************************************************

      regEx.RegEx := '(?<=^0INITIAL ESTIMATE OF OMEGA:).*(?=(0INITIAL ESTIMATE OF SIGMA:))';
      if (regEx.Match) then
      begin
        lstTemp.Clear;
        lstTemp.Add(regEx.MatchedText);
        lstTemp.Text := StringReplace(StringReplace(lstTemp.Text, #10, '£', [rfReplaceAll]), #13, 'ç', [rfReplaceAll]);
        lstTemp.Text := StringReplace(lstTemp.Text, '£ç',#13, [rfReplaceAll]);
        lstTemp.Text := StringReplace(lstTemp.Text, 'ç£', #13, [rfReplaceAll]);
        lstTemp.Text := StringReplace(lstTemp.Text, '£', #13, [rfReplaceAll]);
        lstTemp.Text := StringReplace(lstTemp.Text, 'ç', #13, [rfReplaceAll]);
        //ShowMessage(lstTemp.Text);

        lstTemp2.Clear;

        with regEx do
        begin
          regEx := '-?\d\.\d+E[\+|-]\d{2}';   // match scientific number
          Subject := lstTemp.Text;

          if Match then
          begin
            n := 1;
            OmInit.Add(MatchedText);
            while MatchAgain do
            begin
              OmInit.Add(MatchedText);
              n := n + 1;
            end;
          end;
        end;

        lstTemp2.Text := lstOmegaBlkVars.Text;
        if OmInit.Count = intOmegaBlk then  // easy
        begin
          for n := 1 to OmInit.Count do
            lstTemp2.Text := StringReplace(lstTemp2.Text, ' ' + IntToStr(n), ' ' + OmInit[n-1],
              [rfReplaceAll]);
          lstOmegaBlkVars.Text := lstTemp2.Text;
        end
        else      // don't match, might be mixed blocks and SAMEs
        begin
          for n := 0 to lstOmegaBlkVars.Count - 1 do
          begin
            // TODO
          end;
        end;

        // Update OmInit

      end;
      //ShowMessage(lstTemp2.Text);

      // Read from control stream instead
      lstTemp.Clear;
      lstTemp2.Clear;
      regEx.Options := [preMultiLine,preSingleLine,preUnGreedy];
      regEx.RegEx := '^ *\$PROB.*1NONLINEAR MIXED EFFECTS MODEL PROGRAM';
      regEx.Subject := strList.Text;

      if regEx.Match then
      begin
        lstTemp.Add(regEx.MatchedText);
        lstTemp.Text := StringReplace(StringReplace(lstTemp.Text, #10, '£', [rfReplaceAll]), #13, 'ç', [rfReplaceAll]);
        lstTemp.Text := StringReplace(lstTemp.Text, '£ç',#13, [rfReplaceAll]);
        lstTemp.Text := StringReplace(lstTemp.Text, 'ç£', #13, [rfReplaceAll]);
        lstTemp.Text := StringReplace(lstTemp.Text, '£', #13, [rfReplaceAll]);
        lstTemp.Text := StringReplace(lstTemp.Text, 'ç', #13, [rfReplaceAll]);

        for n := 0 to lstTemp.Count - 1 do
        begin
          if Pos('$OMEGA', lstTemp[n]) > 0 then
            blnCap := True;
          if (Pos('$', lstTemp[n]) > 0) and (Pos('$OMEGA', lstTemp[n]) = 0) then
            if (Pos(';', lstTemp[n]) = 0) or (Pos(';', lstTemp[n]) > Pos('$', lstTemp[n])) then
              blnCap := False;
          if blnCap then
            lstTemp2.Add(lstTemp[n]);
        end;
        //ShowMessage(lstTemp2.Text);

        // Get rid of comments
        lstTemp.Clear;
        for n := 0 to lstTemp2.Count - 1 do
          if Pos(';', lstTemp2[n]) > 0 then
            lstTemp.Add(Copy(lstTemp2[n], 1, Pos(';', lstTemp2[n])-1))
          else
            lstTemp.Add(lstTemp2[n]);
        //ShowMessage(lstTemp.Text);

        // get rid of $OMEGAs and FIXes
        lstTemp.Text := StringReplace(lstTemp.Text, '$OMEGA', '', [rfReplaceAll]);
        lstTemp.Text := StringReplace(lstTemp.Text, 'FIX', '', [rfReplaceAll]);

        // deal with BLOCKs
        lstTemp2.Clear;
        for n := 0 to lstTemp.Count - 1 do
        begin
          if Pos('BLOCK', lstTemp[n]) > 0 then
            lstTemp2.Add(Copy(lstTemp[n], Pos(')', lstTemp[n]), 500))
          else
            lstTemp2.Add(lstTemp[n]);
        end;

        lstTemp2.Text := StringReplace(lstTemp2.Text, '(', '', [rfReplaceAll]);
        lstTemp2.Text := StringReplace(lstTemp2.Text, ')', '', [rfReplaceAll]);

        //ShowMessage(lstTemp2.Text);

        // deal with SAME and starting .'s
        strTemp := '';
        lstTemp.Clear;
        for n := 0 to lstTemp2.Count - 1 do
        begin
          if Pos('.', Trim(lstTemp2[n])) = 1 then
          begin
            lstTemp.Add('0' + Trim(lstTemp2[n]));
            strTemp := '0' + Trim(lstTemp2[n]);
          end
          else
          if Pos('SAME', Trim(lstTemp2[n])) > 0 then
            lstTemp.Add(strTemp)
          else
          if Length(lstTemp2[n]) > 0 then
          begin
            lstTemp.Add(Trim(lstTemp2[n]));
            strTemp := Trim(lstTemp2[n]);
          end;
        end;
        //ShowMessage(lstTemp.Text);

        OmInit.Text := StringReplace(lstTemp.Text, ' ', #13, [rfReplaceAll]);
        //ShowMessage(OmInit.Text);

      end;

// ********************************************************************
// Initial estimates of SIGMA
// ********************************************************************

      //ShowMessage('start');
      regEx.Options := [preMultiLine,preSingleLine,preUnGreedy];
      regEx.RegEx := '(?<=^0INITIAL ESTIMATE OF SIGMA:).*(?=(^0))';
      regEx.Subject := strList.Text;
      if (regEx.Match) then
      begin
        lstTemp.Clear;
        lstTemp.Add(regEx.MatchedText);
        lstTemp.Text := StringReplace(StringReplace(lstTemp.Text, #10, '£', [rfReplaceAll]), #13, 'ç', [rfReplaceAll]);
        lstTemp.Text := StringReplace(lstTemp.Text, '£ç',#13, [rfReplaceAll]);
        lstTemp.Text := StringReplace(lstTemp.Text, 'ç£', #13, [rfReplaceAll]);
        lstTemp.Text := StringReplace(lstTemp.Text, '£', #13, [rfReplaceAll]);
        lstTemp.Text := StringReplace(lstTemp.Text, 'ç', #13, [rfReplaceAll]);
        //ShowMessage(lstTemp.Text);

        lstTemp2.Clear;

        with regEx do
        begin
          regEx := '-?\d\.\d+E[\+|-]\d{2}';   // match scientific number
          Subject := lstTemp.Text;

          if Match then
          begin
            n := 1;
            SigInit.Add(MatchedText);
            while MatchAgain do
            begin
              SigInit.Add(MatchedText);
              n := n + 1;
            end;
          end;
        end;

        lstTemp2.Text := lstSigmaBlkVars.Text;
        if SigInit.Count = intSigmaBlk then  // easy
        begin
          for n := 1 to SigInit.Count do
            lstTemp2.Text := StringReplace(lstTemp2.Text, ' ' + IntToStr(n), ' ' + SigInit[n-1],
              [rfReplaceAll]);
          lstSigmaBlkVars.Text := lstTemp2.Text;
        end
        else      // don't match, might be mixed blocks and SAMEs
        begin
          for n := 0 to lstSigmaBlkVars.Count - 1 do
          begin
            // TODO
          end;
        end;

      end;
      //ShowMessage(SigInit.Text);

      // Read from control stream instead
      lstTemp.Clear;
      lstTemp2.Clear;
      regEx.Options := [preMultiLine,preSingleLine,preUnGreedy];
      regEx.RegEx := '^ *\$PROB.*1NONLINEAR MIXED EFFECTS MODEL PROGRAM';
      regEx.Subject := strList.Text;

      if regEx.Match then
      begin
        lstTemp.Add(regEx.MatchedText);
        lstTemp.Text := StringReplace(StringReplace(lstTemp.Text, #10, '£', [rfReplaceAll]), #13, 'ç', [rfReplaceAll]);
        lstTemp.Text := StringReplace(lstTemp.Text, '£ç',#13, [rfReplaceAll]);
        lstTemp.Text := StringReplace(lstTemp.Text, 'ç£', #13, [rfReplaceAll]);
        lstTemp.Text := StringReplace(lstTemp.Text, '£', #13, [rfReplaceAll]);
        lstTemp.Text := StringReplace(lstTemp.Text, 'ç', #13, [rfReplaceAll]);

        for n := 0 to lstTemp.Count - 1 do
        begin
          if Pos('$SIGMA', lstTemp[n]) > 0 then
            blnCap := True;
          if (Pos('$', lstTemp[n]) > 0) and (Pos('$SIGMA', lstTemp[n]) = 0) then
            if (Pos(';', lstTemp[n]) = 0) or (Pos(';', lstTemp[n]) > Pos('$', lstTemp[n])) then
              blnCap := False;
          if blnCap then
            lstTemp2.Add(lstTemp[n]);
        end;
        //ShowMessage(lstTemp2.Text);

        // Get rid of comments
        lstTemp.Clear;
        for n := 0 to lstTemp2.Count - 1 do
          if Pos(';', lstTemp2[n]) > 0 then
            lstTemp.Add(Copy(lstTemp2[n], 1, Pos(';', lstTemp2[n])-1))
          else
            lstTemp.Add(lstTemp2[n]);
        //ShowMessage(lstTemp.Text);

        // get rid of $OMEGAs and FIXes
        lstTemp.Text := StringReplace(lstTemp.Text, '$SIGMA', '', [rfReplaceAll]);
        lstTemp.Text := StringReplace(lstTemp.Text, 'FIX', '', [rfReplaceAll]);

        // deal with BLOCKs
        lstTemp2.Clear;
        for n := 0 to lstTemp.Count - 1 do
        begin
          if Pos('BLOCK', lstTemp[n]) > 0 then
            lstTemp2.Add(Copy(lstTemp[n], Pos(')', lstTemp[n]), 500))
          else
            lstTemp2.Add(lstTemp[n]);
        end;

        lstTemp2.Text := StringReplace(lstTemp2.Text, '(', '', [rfReplaceAll]);
        lstTemp2.Text := StringReplace(lstTemp2.Text, ')', '', [rfReplaceAll]);

        //ShowMessage(lstTemp2.Text);

        // deal with SAME and starting .'s
        strTemp := '';
        lstTemp.Clear;
        for n := 0 to lstTemp2.Count - 1 do
        begin
          if Pos('.', Trim(lstTemp2[n])) = 1 then
          begin
            lstTemp.Add('0' + Trim(lstTemp2[n]));
            strTemp := '0' + Trim(lstTemp2[n]);
          end
          else
          if Pos('SAME', Trim(lstTemp2[n])) > 0 then
            lstTemp.Add(strTemp)
          else
          if Length(lstTemp2[n]) > 0 then
          begin
            lstTemp.Add(Trim(lstTemp2[n]));
            strTemp := Trim(lstTemp2[n]);
          end;
        end;
        //ShowMessage(lstTemp.Text);

        SigInit.Text := StringReplace(lstTemp.Text, ' ', #13, [rfReplaceAll]);
        //ShowMessage(SigInit.Text);
      end;

// ********************************************************************
// FOCE
// ********************************************************************

      strCondEst := OneLineRegEx(strList.Text, '(?<=CONDITIONAL ESTIMATES USED:).*?\r?\n', False);
      if Length(strCondEst) < 1 then
        strCondEst := 'NO';
      lstLog.Add('Conditional Estimates... ' + strCondEst);

// ********************************************************************
// Centered ETA
// ********************************************************************

      strCentEta := OneLineRegEx(strList.Text, '(?<=CENTERED ETA:).*?\r?\n', False);
      lstLog.Add('Centered Eta... ' + strCentEta);

// ********************************************************************
// INTERACTION
// ********************************************************************

      strInter := OneLineRegEx(strList.Text, '(?<=EPS-ETA INTERACTION:).*?\r?\n', False);
      lstLog.Add('Eps-Eta Interaction... ' + strInter);

// ********************************************************************
// Laplacian
// ********************************************************************

      strLaplacian := OneLineRegEx(strList.Text, '(?<=LAPLACIAN OBJ. FUNC.:).*?\r?\n', False);
      lstLog.Add('Laplacian Obj Fn... ' + strLaplacian);

// ********************************************************************
// Method
// ********************************************************************

      // TODO: FO
      // TODO: Imp
      // TODO: ImpMap
      // TODO: Laplacian

      regEx.Options := [preMultiLine,preUnGreedy];
      regEx.RegEx := '(?<=#METH: ).*?\r?\n';
      regEx.Subject := strList.Text;
      if regEx.Match then
      begin
        strTemp := Trim(regEx.MatchedText);
        lstLog.Add('Method... ' + strTemp);
        if Pos('First Order Conditional Estimation', strTemp) > 0 then
        begin
          blnFOCE := True;
          strLastMethod := 'FOCE';
        end;
        if Pos('Stochastic Approximation Expectation-Maximization', strTemp) > 0 then
        begin
          blnSAEM := True;
          strLastMethod := 'SAEM';
        end;
        if Pos('MCMC Bayesian Analysis', strTemp) > 0 then
        begin
          blnBayes := True;
          strLastMethod := 'Bayes';
        end;
        if Pos('Laplacian Conditional Estimation', strTemp) > 0 then
        begin
          blnLaplacian := True;
          strLastMethod := 'Laplacian';
        end;

        while regEx.MatchAgain do
        begin
          strTemp := Trim(regEx.MatchedText);
          lstLog.Add('Method... ' + strTemp);
          if Pos('First Order Conditional Estimation', strTemp) > 0 then
          begin
            blnFOCE := True;
            strLastMethod := 'FOCE';
          end;
          if Pos('Stochastic Approximation Expectation-Maximization', strTemp) > 0 then
          begin
            blnSAEM := True;
            strLastMethod := 'SAEM';
          end;
          if Pos('MCMC Bayesian Analysis', strTemp) > 0 then
          begin
            blnBayes := True;
            strLastMethod := 'Bayes';
          end;
          if Pos('Laplacian Conditional Estimation', strTemp) > 0 then
          begin
            blnLaplacian := True;
            strLastMethod := 'Laplacian';
          end;
        end;
      end;

      //ShowMessage(strLastMethod);

// ********************************************************************
// Check zero gradients and hessian resets
// ********************************************************************
      lstTemp.Clear;
      lstTemp2.Clear;
      regEx.Options := [preMultiLine,preSingleLine,preUnGreedy];
      regEx.RegEx := '(?<=MONITORING OF SEARCH:).*(?=( Elapsed estimation time))';
      regEx.Subject := strList.Text;
      if regEx.Match then
      begin
        lstTemp.Add(regEx.MatchedText);
        lstTemp.Text := StringReplace(StringReplace(lstTemp.Text, #10, '£', [rfReplaceAll]), #13, 'ç', [rfReplaceAll]);
        lstTemp.Text := StringReplace(lstTemp.Text, '£ç',#13, [rfReplaceAll]);
        lstTemp.Text := StringReplace(lstTemp.Text, 'ç£', #13, [rfReplaceAll]);
        lstTemp.Text := StringReplace(lstTemp.Text, '£', #13, [rfReplaceAll]);
        lstTemp.Text := StringReplace(lstTemp.Text, 'ç', #13, [rfReplaceAll]);

        strTemp := '';
        for n := 0 to lstTemp.Count - 1 do
        begin
          if Pos('GRADIENT', lstTemp[n]) > 0 then
            blnCap := True;
          if Pos('ITERATION NO.', lstTemp[n]) > 0 then
          begin
            blnCap := False;
            if Length(strTemp) > 0 then
              lstTemp2.Add(strTemp);
            strTemp := '';
          end;
          if blnCap then
            strTemp := strTemp + lstTemp[n];
        end;
        if Length(strTemp) > 0 then
          lstTemp2.Add(strTemp);
        if Pos('0.0000E+00', strTemp) > 0 then
        begin
          blnFZeroGradients := True;
          lstLog.Add('Zero gradients detected in final iteration...');
        end;

        // count zero gradients
        regExI := TPerlRegEx.Create;
        regExI.Options := [preMultiLine,preSingleLine,preUnGreedy];
        regExI.RegEx := '0.0000E+00';
        regExI.Subject := lstTemp2.Text;
        if regExI.Match then
        begin
          intZeroGradients := 1;
          blnZeroGradients := True;
          while regExI.MatchAgain do
          begin
            intZeroGradients := intZeroGradients + 1;
          end;
        end;
        lstLog.Add(IntToStr(intZeroGradients) + ' zero gradients detected...');
        regExI.Free;

        // count Hessian resets
        regExI := TPerlRegEx.Create;
        regExI.Options := [preMultiLine,preSingleLine,preUnGreedy];
        regExI.RegEx := 'RESET HESSIAN';
        regExI.Subject := lstTemp.Text;
        if regExI.Match then
        begin
          intHessian := 1;
          lstLog.Add('Hessian reset detected...');
          while regExI.MatchAgain do
          begin
            intHessian := intHessian + 1;
            lstLog.Add('Hessian reset detected...');
          end;
        end;
        lstLog.Add(IntToStr(intZeroGradients) + ' Hessian resets detected...');
        regExI.Free;
      end;

      //ShowMessage(lstTemp2.Text);

// ********************************************************************
// Check minimization step    (2 steps)
// ********************************************************************
      lstTemp.Clear;
      lstTemp2.Clear;
      regEx.Options := [preMultiLine,preSingleLine,preUnGreedy];
      regEx.RegEx := '(?<=#TERM:).*(?=( #TERE:))';
      regEx.Subject := strList.Text;
      if regEx.Match then
      begin
        lstMinTerm.Add(regEx.MatchedText);

        while regEx.MatchAgain do
        begin
          lstMinTerm.Add('-------------------------');
          lstMinTerm.Add(regEx.MatchedText);
        end;
      end;

      // now analyse the last seen
      lstTemp.Clear;
      lstTemp2.Clear;
      regEx.Options := [preMultiLine,preSingleLine,preUnGreedy];
      regEx.RegEx := '(?<=#TERM:).*(?=( #TERE:))';
      regEx.Subject := strList.Text;
      if regEx.Match then
      begin
        lstTemp.Add(regEx.MatchedText);

        while regEx.MatchAgain do
        begin
          lstTemp.Clear;
          lstTemp.Add(regEx.MatchedText);
        end;

        lstTemp.Text := StringReplace(StringReplace(lstTemp.Text, #10, '£', [rfReplaceAll]), #13, 'ç', [rfReplaceAll]);
        lstTemp.Text := StringReplace(lstTemp.Text, '£ç',#13, [rfReplaceAll]);
        lstTemp.Text := StringReplace(lstTemp.Text, 'ç£', #13, [rfReplaceAll]);
        lstTemp.Text := StringReplace(lstTemp.Text, '£', #13, [rfReplaceAll]);
        lstTemp.Text := StringReplace(lstTemp.Text, 'ç', #13, [rfReplaceAll]);

        if Pos('MINIMIZATION SUCCESSFUL', lstTemp.Text) > 0 then
          strMin := 'Successful';
        if Pos('MINIMIZATION TERMINATED', lstTemp.Text) > 0 then
        begin
          strMin := 'Terminated';
          swMinTerm := True;
          blnCovStep := False;
        end;
        lstLog.Add('Minimization... ' + strMin);

      end;

      regEx.Options := [preMultiLine,preUnGreedy];
      regEx.RegEx := '(?<=NO. OF FUNCTION EVALUATIONS USED:).*?\r?\n';
      if regEx.Match then
      begin
        strFnEval := Trim(regEx.MatchedText);
        lstLog.Add('Fn Evals... ' + strFnEval);
        //ShowMessage(strInter);
      end;

      regEx.Options := [preMultiLine,preUnGreedy];
      regEx.RegEx := '(?<=NO. OF SIG. DIGITS IN FINAL EST.:).*?\r?\n';
      if regEx.Match then
        strSigDig := Trim(regEx.MatchedText)
      else
        strSigDig := 'UNREPORTABLE';
      lstLog.Add('Significant digits... ' + strSigDig);

// ********************************************************************
// ETABAR
// ********************************************************************
      regEx.Options := [preMultiLine,preSingleLine,preUnGreedy];
      regEx.RegEx := 'SUBMODEL';
      regEx.Subject := strList.Text;
      if regEx.Match then
      begin
        blnEtaBar := False;
        lstLog.Add('Submodels detected - ETABAR turned OFF');
      end
      else
        blnEtaBar := True;

      if (blnEtaBar) and (strLastMethod <> 'Bayes') then
      begin
        regEx.Options := [preMultiLine,preSingleLine,preUnGreedy];
        regEx.RegEx := '(?<= ETABAR:).*(?=( SE:))';
        regEx.Subject := lstTemp.Text;
        if regEx.Match then
        begin
          regExI := TPerlRegEx.Create;
          regExI.Options := [preMultiLine,preSingleLine,preUnGreedy];
          regExI.RegEx := '-?\d\.\d+E[\+|-]\d{2}';
          regExI.Subject := regEx.MatchedText;
          if regExI.Match then
          begin
            n := 1;
            EtaBar.Add(RegExI.MatchedText);
            while regExI.MatchAgain do
            begin
              EtaBar.Add(RegExI.MatchedText);
              n := n + 1;
            end;
          end;
          lstLog.Add('EtaBars added... ' + IntToStr(n));
          regExI.Free;
        end;
      end;

      //ShowMessage(EtaBar.Text);

// ********************************************************************
// ETABAR SE
// ********************************************************************
      if (blnEtaBar) and (strLastMethod <> 'Bayes') then
      begin
        regEx.Options := [preMultiLine,preSingleLine,preUnGreedy];
        regEx.RegEx := '(?<= SE:).*(?=( P VAL.:))';
        regEx.Subject := lstTemp.Text;
        if regEx.Match then
        begin
          regExI := TPerlRegEx.Create;
          regExI.Options := [preMultiLine,preSingleLine,preUnGreedy];
          regExI.RegEx := '-?\d\.\d+E[\+|-]\d{2}';
          regExI.Subject := regEx.MatchedText;
          if regExI.Match then
          begin
            n := 1;
            EtaBarSE.Add(RegExI.MatchedText);
            while regExI.MatchAgain do
            begin
              EtaBarSE.Add(RegExI.MatchedText);
              n := n + 1;
            end;
          end;
          lstLog.Add('EtaBar SEs added... ' + IntToStr(n));
          regExI.Free;
        end;
      end;

      //ShowMessage(EtaBarSE.Text);

// ********************************************************************
// ETABAR P value
// ********************************************************************
      if (blnEtaBar) and (strLastMethod <> 'Bayes') then
      begin
        regEx.Options := [preMultiLine,preSingleLine,preUnGreedy];
        regEx.RegEx := '(?<= P VAL.:).*(?=( ETAshrink\(%\):))';
        regEx.Subject := lstTemp.Text;
        if regEx.Match then
        begin
          regExI := TPerlRegEx.Create;
          regExI.Options := [preMultiLine,preSingleLine,preUnGreedy];
          regExI.RegEx := '-?\d\.\d+E[\+|-]\d{2}';
          regExI.Subject := regEx.MatchedText;
          if regExI.Match then
          begin
            n := 1;
            EtaP.Add(RegExI.MatchedText);
            while regExI.MatchAgain do
            begin
              EtaP.Add(RegExI.MatchedText);
              n := n + 1;
            end;
          end;
          lstLog.Add('EtaBar P-values added... ' + IntToStr(n));
          regExI.Free;
        end;
      end;

      //ShowMessage(EtaP.Text);

// ********************************************************************
// ETA shrinkage
// ********************************************************************
      if (blnEtaBar) and (strLastMethod <> 'Bayes') then
      begin
        regEx.Options := [preMultiLine,preSingleLine,preUnGreedy];
        regEx.RegEx := '(?<= ETAshrink\(%\):).*(?=( EPSshrink\(%\):))';
        regEx.Subject := lstTemp.Text;
        if regEx.Match then
        begin
          regExI := TPerlRegEx.Create;
          regExI.Options := [preMultiLine,preSingleLine,preUnGreedy];
          regExI.RegEx := '-?\d\.\d+E[\+|-]\d{2}';
          regExI.Subject := regEx.MatchedText;
          if regExI.Match then
          begin
            n := 1;
            EtaShrinkage.Add(RegExI.MatchedText);
            while regExI.MatchAgain do
            begin
              EtaShrinkage.Add(RegExI.MatchedText);
              n := n + 1;
            end;
          end;
          lstLog.Add('Eta shrinkages added... ' + IntToStr(n));
          regExI.Free;
        end;
      end;

      //ShowMessage(EtaShrinkage.Text);

// ********************************************************************
// EPS shrinkage
// ********************************************************************

      //ShowMessage(lstTemp.Text);
      if (blnEtaBar) and (strLastMethod <> 'Bayes') then
      begin
      //  fltEpsShrinkage := StrToFloat(OneLineRegEx(strList.Text, '(?<= EPSshrink\(%\):).*?\r?\n', False));
      //  lstLog.Add('Epsilon shrinkage... ' + FloatToStr(fltEpsShrinkage));
        regEx.Options := [preMultiLine,preSingleLine];
        regEx.RegEx := '(?<= EPSshrink\(%\):).*?\r?\n';
        regEx.Subject := lstTemp.Text;
        if regEx.Match then
        begin
          regExI := TPerlRegEx.Create;
          regExI.Options := [preMultiLine,preSingleLine,preUnGreedy];
          regExI.RegEx := '-?\d\.\d+E[\+|-]\d{2}';
          regExI.Subject := regEx.MatchedText;
          if regExI.Match then
          begin
            n := 1;
            EpsShrinkage.Add(RegExI.MatchedText);
            while regExI.MatchAgain do
            begin
              EpsShrinkage.Add(RegExI.MatchedText);
              n := n + 1;
            end;
          end;
          lstLog.Add('Eta shrinkages added... ' + IntToStr(n));
          regExI.Free;
        end;
        if EpsShrinkage.Count > 0 then
          fltEpsShrinkage := StrToFloat(EpsShrinkage[0]);
      end;
      //ShowMessage(EpsShrinkage.Text);
      lstTemp.Clear;

// ********************************************************************
// Elapsed estimation time
// ********************************************************************

      regEx.Options := [preMultiLine,preUnGreedy];
      regEx.RegEx := '(?<=Elapsed estimation time in seconds:).*?\r?\n';
      regEx.Subject := strList.Text;
      if regEx.Match then
      begin
        fltEstTime := StrToFloat(Trim(regEx.MatchedText));
        lstLog.Add('Estimation time... ' + FloatToStr(fltEstTime));
        while regEx.MatchAgain do
        begin
          fltEstTime := fltEstTime + StrToFloat(Trim(regEx.MatchedText));
          lstLog.Add('Estimation time... ' + Trim(regEx.MatchedText));
        end;
      end
      else
        fltEstTime := 0;

// ********************************************************************
// Elapsed covariance time
// ********************************************************************

      strTemp := OneLineRegEx(strList.Text, '(?<=Elapsed covariance time in seconds:).*?\r?\n', False);
      if Length(strTemp) > 0 then
        fltCovTime := StrToFloat(strTemp)
      else
        fltCovTime := 0;
      lstLog.Add('Covariance time... ' + FloatToStr(fltCovTime));

// ********************************************************************
// Read THETA & ETA & EPS estimates
// ********************************************************************

      // grab whole FP block and put in lstTemp
      // we only take the last one in case several steps have been run
      lstTemp.Clear;
      lstTemp2.Clear;
      regEx.Options := [preMultiLine,preSingleLine,preUnGreedy];
      if fltCovTime > 0 then
        regEx.RegEx := '(?<=FINAL PARAMETER ESTIMATE).*(?=(1\r?\n? \*{120}))'
      else
      begin
        regEx.RegEx := '(?<=FINAL PARAMETER ESTIMATE).*';          // nothing after this point, no cov step
        regEx.Options := [preMultiLine,preSingleLine];
      end;
      regEx.Subject := strList.Text;
      if regEx.Match then
      begin
        lstTemp.Add(regEx.MatchedText);
        lstTemp.Text := StringReplace(StringReplace(lstTemp.Text, #10, '£', [rfReplaceAll]), #13, 'ç', [rfReplaceAll]);
        lstTemp.Text := StringReplace(lstTemp.Text, '£ç',#13, [rfReplaceAll]);
        lstTemp.Text := StringReplace(lstTemp.Text, 'ç£', #13, [rfReplaceAll]);
        lstTemp.Text := StringReplace(lstTemp.Text, '£', #13, [rfReplaceAll]);
        lstTemp.Text := StringReplace(lstTemp.Text, 'ç', #13, [rfReplaceAll]);
        while regEx.MatchAgain do
        begin
          lstTemp.Clear;
          lstTemp.Add(regEx.MatchedText);
        end;

        //ShowMessage(lstTemp.Text);
        // get Thetas
        regExI := TPerlRegEx.Create;
        regExI.Options := [preMultiLine,preSingleLine];
        regExI.RegEx := '(?<=THETA - VECTOR OF FIXED EFFECTS PARAMETERS   \*{9}).*(?=(OMEGA))';
        regExI.Subject := lstTemp.Text;
        if regExI.Match then
          lstTemp2.Add(regExI.MatchedText);

        //ShowMessage(lstTemp2.Text);
        regExI.Subject := lstTemp2.Text;
        regExI.RegEx := '-?\d\.\d+E[\+|-]\d{2}';
        if regExI.Match then
        begin
          ThValue.Add(FloatToStr(StrToFloat(RegExI.MatchedText)*1));
          while regExI.MatchAgain do
            ThValue.Add(FloatToStr(StrToFloat(RegExI.MatchedText)*1));
        end;
        regExI.Free;
        //Showmessage(ThValue.Text);

        // get Etas
        lstTemp2.Clear;
        lstScratch.Clear;
        regExI := TPerlRegEx.Create;
        regExI.Options := [preMultiLine,preSingleLine];
        regExI.RegEx := '(?<=OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  \*{8}).*(?=SIGMA)';
        //Showmessage(lstTemp.Text);
        regExI.Subject := lstTemp.Text;
        if regExI.Match then
          lstTemp2.Add(regExI.MatchedText);

        // Sometimes SIGMAs are not present
        if length(Trim(lstTemp2.Text)) = 0 then
        begin
          regExI.RegEx := '(?<=OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  \*{8}).*';
          regExI.Subject := lstTemp.Text;
          if regExI.Match then
            lstTemp2.Add(regExI.MatchedText);
        end;
        //ShowMessage(lstTemp2.Text);

        regExI.Subject := lstTemp2.Text;
        regExI.RegEx := '-?\d\.\d+E[\+|-]\d{2}';
        if regExI.Match then
        begin
          lstScratch.Add(FloatToStr(StrToFloat(RegExI.MatchedText)*1));
          while regExI.MatchAgain do
            lstScratch.Add(FloatToStr(StrToFloat(RegExI.MatchedText)*1));
        end;
        regExI.Free;

        // checking again in case of priors
        for n := 1 to 200 do
        begin
          if ((n*n) + n)/2 = lstScratch.Count then
            intOmega := n;
        end;

        //ShowMessage(inttostr(intomega));
        //showmessage(lstScratch.Text);
        strTemp := '';
        p := 0;   // row
        q := 0;   // index
        r := 0;
        for n := 0 to intOmega - 1 do
        begin
          for m := r to q do
          begin
            if m < q then
              strTemp := strTemp + lstScratch[m] + ','
            else
            begin
              strTemp := strTemp + lstScratch[m];
              Eta.Add(lstScratch[m]);
            end;
          end;
          //showmessage(strTemp);
          //showmessage(inttostr(r) + ' to ' + inttostr(q));
          p := p + 1;
          r := r + p;
          q := q + p + 1;               // correct
          lstMatrixOmega.Add(strTemp);
          strTemp := '';
        end;
        //Showmessage(Eta.Text);
        //showmessage(lstMatrixOmega.Text);

        // get Epsilons
        lstTemp2.Clear;
        lstScratch.Clear;
        regExI := TPerlRegEx.Create;
        regExI.Options := [preMultiLine,preSingleLine];
        regExI.RegEx := '(?<=SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  \*{4}).*';
        regExI.Subject := lstTemp.Text;
        if regExI.Match then
          lstTemp2.Add(regExI.MatchedText);
        //lstTemp.SaveToFile('C:\Users\Administrator\Documents\Delphi\Census\svn\lstTemp.txt');
        //showmessage(lstTemp2.Text);

        regExI.Subject := lstTemp2.Text;
        regExI.RegEx := '-?\d\.\d+E[\+|-]\d{2}';
        if regExI.Match then
        begin
          lstScratch.Add(FloatToStr(StrToFloat(RegExI.MatchedText)*1));
          while regExI.MatchAgain do
            lstScratch.Add(FloatToStr(StrToFloat(RegExI.MatchedText)*1));
        end;
        regExI.Free;

        //ShowMessage('sigmas');
        //ShowMessage(inttostr(intSigma));
        //showmessage(lstScratch.Text);
        strTemp := '';
        p := 0;   // row
        q := 0;   // index
        r := 0;
        for n := 0 to intSigma - 1 do
        begin
          for m := r to q do
          begin
            if m < q then
              strTemp := strTemp + lstScratch[m] + ','
            else
            begin
              strTemp := strTemp + lstScratch[m];
              Eps.Add(lstScratch[m]);
            end;
          end;
          //showmessage(strTemp);
          //showmessage(inttostr(r) + ' to ' + inttostr(q));
          p := p + 1;
          r := r + p;
          q := q + p + 1;               // correct
          lstMatrixSigma.Add(strTemp);
          strTemp := '';
        end;
        //Showmessage(Eps.Text);
        //showmessage(lstMatrixSigma.Text);
      end;

// ********************************************************************
// Read THETA & ETA & EPS SEs
// ********************************************************************

      // grab whole SE block and put in lstTemp
      lstTemp.Clear;
      lstTemp2.Clear;
      regEx.Options := [preMultiLine,preSingleLine,preUnGreedy];
      regEx.RegEx := '(?<=STANDARD ERROR OF ESTIMATE).*(?=(1\r?\n? \*{120}))';
      regEx.Subject := strList.Text;
      if regEx.Match then
      begin
        lstTemp.Add(regEx.MatchedText);

        // replace dots with placeholders
        lstTemp.Text := StringReplace(lstTemp.Text, '.........', '9.99E+99', [rfReplaceAll]);

        // correct line breaks
        lstTemp.Text := StringReplace(StringReplace(lstTemp.Text, #10, '£', [rfReplaceAll]), #13, 'ç', [rfReplaceAll]);
        lstTemp.Text := StringReplace(lstTemp.Text, '£ç',#13, [rfReplaceAll]);
        lstTemp.Text := StringReplace(lstTemp.Text, 'ç£', #13, [rfReplaceAll]);
        lstTemp.Text := StringReplace(lstTemp.Text, '£', #13, [rfReplaceAll]);
        lstTemp.Text := StringReplace(lstTemp.Text, 'ç', #13, [rfReplaceAll]);

        while regEx.MatchAgain do
        begin
          lstTemp.Clear;
          lstTemp.Add(regEx.MatchedText);
        end;

        // get Thetas
        regExI := TPerlRegEx.Create;
        regExI.Options := [preMultiLine,preSingleLine];
        regExI.RegEx := '(?<=THETA - VECTOR OF FIXED EFFECTS PARAMETERS   \*{9}).*(?=(OMEGA))';
        regExI.Subject := lstTemp.Text;
        if regExI.Match then
          lstTemp2.Add(regExI.MatchedText);

        regExI.Subject := regExI.MatchedText;
        regExI.RegEx := '-?\d\.\d+E[\+|-]\d{2}';
        if regExI.Match then
        begin
          if regExI.MatchedText = '9.99E+99' then
            ThSE.Add('...')
          else
            ThSE.Add(FloatToStr(StrToFloat(RegExI.MatchedText)*1));
          while regExI.MatchAgain do
            if regExI.MatchedText = '9.99E+99' then
              ThSE.Add('...')
            else
              ThSE.Add(FloatToStr(StrToFloat(RegExI.MatchedText)*1));
        end;
        regExI.Free;
        //Showmessage(ThSE.Text);

        // get Etas
        lstTemp2.Clear;
        lstScratch.Clear;
        regExI := TPerlRegEx.Create;
        regExI.Options := [preMultiLine,preSingleLine];
        regExI.RegEx := '(?<=OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  \*{8}).*(?=SIGMA)';
        regExI.Subject := lstTemp.Text;
        if regExI.Match then
          lstTemp2.Add(regExI.MatchedText);

        //showmessage(lstTemp.Text);
        // Sometimes SIGMAs are not present
        if length(Trim(lstTemp2.Text)) = 0 then
        begin
          regExI.RegEx := '(?<=OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  \*{8}).*';
          regExI.Subject := lstTemp.Text;
          if regExI.Match then
            lstTemp2.Add(regExI.MatchedText);
        end;
        //ShowMessage(lstTemp2.Text);

        regExI.Subject := lstTemp2.Text;
        regExI.RegEx := '-?\d\.\d+E[\+|-]\d{2}';
        if regExI.Match then
        begin
          if regExI.MatchedText = '9.99E+99' then
            lstScratch.Add('...')
          else
            lstScratch.Add(FloatToStr(StrToFloat(RegExI.MatchedText)*1));
          while regExI.MatchAgain do
            if regExI.MatchedText = '9.99E+99' then
              lstScratch.Add('...')
            else
              lstScratch.Add(FloatToStr(StrToFloat(RegExI.MatchedText)*1));
        end;
        regExI.Free;

        //ShowMessage(inttostr(intomega));
        //showmessage(lstScratch.Text);
        strTemp := '';
        p := 0;   // row
        q := 0;   // index
        r := 0;
        for n := 0 to intOmega - 1 do
        begin
          for m := r to q do
          begin
            if m < q then
              strTemp := strTemp + lstScratch[m] + ','
            else
            begin
              strTemp := strTemp + lstScratch[m];
              OmSE.Add(lstScratch[m]);
            end;
          end;
          //showmessage(strTemp);
          //showmessage(inttostr(r) + ' to ' + inttostr(q));
          p := p + 1;
          r := r + p;
          q := q + p + 1;               // correct
          lstMatrixOmegaSE.Add(strTemp);
          strTemp := '';
        end;
        //Showmessage(OmSE.Text);
        //showmessage(lstMatrixOmegaSE.Text);

        // get Epsilons
        lstTemp2.Clear;
        lstScratch.Clear;
        regExI := TPerlRegEx.Create;
        regExI.Options := [preMultiLine,preSingleLine];
        regExI.RegEx := '(?<=SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  \*{4}).*';
        regExI.Subject := lstTemp.Text;
        if regExI.Match then
          lstTemp2.Add(regExI.MatchedText);
        //lstTemp.SaveToFile('C:\Users\Administrator\Documents\Delphi\Census\svn\lstTemp.txt');
        //showmessage(lstTemp2.Text);

        regExI.Subject := lstTemp2.Text;
        regExI.RegEx := '-?\d\.\d+E[\+|-]\d{2}';
        if regExI.Match then
        begin
          if regExI.MatchedText = '9.99E+99' then
            lstScratch.Add('...')
          else
            lstScratch.Add(FloatToStr(StrToFloat(RegExI.MatchedText)*1));
          while regExI.MatchAgain do
            if regExI.MatchedText = '9.99E+99' then
              lstScratch.Add('...')
            else
              lstScratch.Add(FloatToStr(StrToFloat(RegExI.MatchedText)*1));
        end;
        regExI.Free;

        //ShowMessage(inttostr(intSigma));
        //showmessage(lstScratch.Text);
        strTemp := '';
        p := 0;   // row
        q := 0;   // index
        r := 0;
        for n := 0 to intSigma - 1 do
        begin
          for m := r to q do
          begin
            if m < q then
              strTemp := strTemp + lstScratch[m] + ','
            else
            begin
              strTemp := strTemp + lstScratch[m];
              SigSE.Add(lstScratch[m]);
            end;
          end;
          //showmessage(strTemp);
          //showmessage(inttostr(r) + ' to ' + inttostr(q));
          p := p + 1;
          r := r + p;
          q := q + p + 1;               // correct
          lstMatrixSigmaSE.Add(strTemp);
          strTemp := '';
        end;
        //Showmessage(SigSE.Text);
        //showmessage(lstMatrixSigmaSE.Text);
      end;


// ********************************************************************
// Proper estimation? OFV present?
// ********************************************************************
      for n := 0 to strList.Count - 1 do
      begin


// ********************************************************************
// Covariance matrix
// ********************************************************************
      {  if Pos(' ********************                          COVARIANCE MATRIX OF ESTIMATE', strList.Strings[n]) > 0 then
        begin
          lstLog.Add('Starting covariance matrix...');
          //ShowMessage('Starting Cov matrix');
          p := 5;
          lstScratch.Clear;
          while Pos('***************', strList[n + p]) = 0 do
          begin
            // Nick's exception
            if (Pos('Optimality', strList[n + p]) = 0) and
              (Pos('Optimality', strList[n + p - 1]) = 0) and
              (Pos('Optimality', strList[n + p - 2]) = 0) and
              (Pos('Optimality', strList[n + p - 3]) = 0) and
              (Pos('Optimality', strList[n + p - 4]) = 0) and
              (Pos('Optimality', strList[n + p - 5]) = 0) then
            // On with the show
              lstScratch.Add(strList[n + p]);
            p := p + 1;
          end;
          if Pos('|', lstScratch.Text) = 0 then
          begin
            strT := '';
            for m := 0 to lstScratch.Count - 1 do
            begin
            // Parse line
              if Length(Trim(lstScratch[m])) > 0 then
                strT := strT + '  ' + Trim(lstScratch[m]);
            // Convert and add
              if Length(Trim(lstScratch[m])) = 0 then
              begin
                strT := StringReplace(strT, '+', '', [rfReplaceAll]);
                strT := StringReplace(strT, ' -', '  -', [rfReplaceAll]);
                strT := StringReplace(strT, ' .........', '  .........',
                  [rfReplaceAll]);
                brkUpp.StringList.Clear;
                brkUpp.BaseString := strT;
                brkUpp.BreakString := '  ';
                brkUpp.BreakApart;
                if lstCovMatrix.Count = 0 then
                  strT := ','
                else
                  strT := '';
                for p := 0 to brkUpp.StringList.Count - 1 do
                  if (Pos('TH', brkUpp.StringList[p]) = 0) and
                    (Pos('OM', brkUpp.StringList[p]) = 0) and
                    (Pos('SG', brkUpp.StringList[p]) = 0) and
                    (Pos('...', brkUpp.StringList[p]) = 0) then
                    brkUpp.StringList[p] := FloatToStr(StrToFloat(brkUpp.StringList[p], fs));
                for p := 0 to brkUpp.StringList.Count - 1 do
                  if p = brkUpp.StringList.Count - 1 then
                    strT := strT + Trim(brkUpp.StringList[p])
                  else
                    strT := strT + Trim(brkUpp.StringList[p]) + ',';
                strT := StringReplace(strT, ',.........', ',......',
                  [rfReplaceAll]);
                strT := Trim(strT);
                if (Length(strT) > 1) then
                begin
                  if (Pos('TH 1,TH 2', strT) = 0) then
                    lstCovMatrix.Add(strT)
                  else
                    if lstCovMatrix.Count = 0 then
                      lstCovMatrix.Add(strT);
                end;
              //ShowMessage(strT);
                strT := '';
              end;
            end;
          end
          else
// ********************************************************************
// Alternate covariance matrix
// ********************************************************************
          begin
            lstLog.Add('Alternate covariance matrix structure detected...');
            strT := '';
            lstTemp.Clear;
            for m := 0 to lstScratch.Count - 1 do
              if Pos('|', lstScratch[m]) > 0 then
                strT := strT + lstScratch[m];
            strT := StringReplace(strT, '|', ' ', [rfReplaceAll]);
            brkUpp.StringList.Clear;
            brkUpp.BaseString := strT;
            brkUpp.BreakString := '  ';
            brkUpp.BreakApart;
            //ShowMessage(IntToStr(brkUpp.StringList.Count));
            for m := 0 to brkUpp.StringList.Count - 1 do
              if lstTemp.IndexOf(Trim(brkUpp.StringList[m])) = -1 then
                lstTemp.Add(Trim(brkUpp.StringList[m]));
            //ShowMessage(IntToStr(lstTemp.Count));
            strT := '';
            for m := 0 to lstTemp.Count - 1 do
              strT := strT + ',' + lstTemp[m];
            lstCovMatrix.Add(strT);
            lstTemp2.Clear;
            strT := '';
            for m := 0 to lstScratch.Count - 1 do
              if (Pos('|', lstScratch[m]) = 0) and
                (Pos('1', lstScratch[m]) <> 1) then
                strT := strT + lstScratch[m];
            brkUpp.StringList.Clear;
            brkUpp.BaseString := strT;
            brkUpp.BreakString := ' ';
            brkUpp.BreakApart;
            //ShowMessage(IntToStr(brkUpp.StringList.Count));
            q := 0;
            for m := 0 to lstTemp.Count - 1 do
            begin
              strT := lstTemp[m];
              for p := m + q to m + q + m do
                strT := strT + ',' + FloatToStr(StrToFloat(brkUpp.StringList[p], fs));
              //ShowMessage(strT);
              lstCovMatrix.Add(strT);
              q := q + m;
            end;
          end;
        end;

// ********************************************************************
// Correlation matrix
// ********************************************************************
        if Pos(' ********************                          CORRELATION MATRIX OF ESTIMATE', strList.Strings[n]) > 0 then
        begin
          lstLog.Add('Starting correlation matrix...');
          //ShowMessage('Starting Corr matrix');
          p := 5;
          lstScratch.Clear;
          while Pos('***************', strList[n + p]) = 0 do
          begin
            lstScratch.Add(strList[n + p]);
            p := p + 1;
          end;
          if Pos('|', lstScratch.Text) = 0 then
          begin
            strT := '';
            for m := 0 to lstScratch.Count - 1 do
            begin
            // Parse line
              if Length(Trim(lstScratch[m])) > 0 then
                strT := strT + '  ' + Trim(lstScratch[m]);
            // Convert and add
              if Length(Trim(lstScratch[m])) = 0 then
              begin
                strT := StringReplace(strT, '+', '', [rfReplaceAll]);
                strT := StringReplace(strT, ' -', '  -', [rfReplaceAll]);
                strT := StringReplace(strT, ' .........', '  .........',
                  [rfReplaceAll]);
                brkUpp.StringList.Clear;
                brkUpp.BaseString := strT;
                brkUpp.BreakString := '  ';
                brkUpp.BreakApart;
                if lstCorrMatrix.Count = 0 then
                  strT := ','
                else
                  strT := '';
                for p := 0 to brkUpp.StringList.Count - 1 do
                  if (Pos('TH', brkUpp.StringList[p]) = 0) and
                    (Pos('OM', brkUpp.StringList[p]) = 0) and
                    (Pos('SG', brkUpp.StringList[p]) = 0) and
                    (Pos('...', brkUpp.StringList[p]) = 0) then
                    brkUpp.StringList[p] := FloatToStr(StrToFloat(brkUpp.StringList[p], fs));
                for p := 0 to brkUpp.StringList.Count - 1 do
                  if p = brkUpp.StringList.Count - 1 then
                    strT := strT + Trim(brkUpp.StringList[p])
                  else
                    strT := strT + Trim(brkUpp.StringList[p]) + ',';
                strT := StringReplace(strT, ',.........', ',......',
                  [rfReplaceAll]);
                strT := Trim(strT);
                if (Length(strT) > 1) then
                begin
                  if (Pos('TH 1,TH 2', strT) = 0) then
                    lstCorrMatrix.Add(strT)
                  else
                    if lstCorrMatrix.Count = 0 then
                      lstCorrMatrix.Add(strT);
                end;
              //ShowMessage(strT);
                strT := '';
              end;
            end;
          end
          else
// ********************************************************************
// Alternate correlation matrix
// ********************************************************************
          begin
            lstLog.Add('Alternate correlation matrix structure detected...');
            strT := '';
            lstTemp.Clear;
            for m := 0 to lstScratch.Count - 1 do
              if Pos('|', lstScratch[m]) > 0 then
                strT := strT + lstScratch[m];
            strT := StringReplace(strT, '|', ' ', [rfReplaceAll]);
            brkUpp.StringList.Clear;
            brkUpp.BaseString := strT;
            brkUpp.BreakString := '  ';
            brkUpp.BreakApart;
            //ShowMessage(IntToStr(brkUpp.StringList.Count));
            for m := 0 to brkUpp.StringList.Count - 1 do
              if lstTemp.IndexOf(Trim(brkUpp.StringList[m])) = -1 then
                lstTemp.Add(Trim(brkUpp.StringList[m]));
            //ShowMessage(IntToStr(lstTemp.Count));
            strT := '';
            for m := 0 to lstTemp.Count - 1 do
              strT := strT + ',' + lstTemp[m];
            lstCorrMatrix.Add(strT);
            lstTemp2.Clear;
            strT := '';
            for m := 0 to lstScratch.Count - 1 do
              if (Pos('|', lstScratch[m]) = 0) and
                (Pos('1', lstScratch[m]) <> 1) then
                strT := strT + lstScratch[m];
            brkUpp.StringList.Clear;
            brkUpp.BaseString := strT;
            brkUpp.BreakString := ' ';
            brkUpp.BreakApart;
            //ShowMessage(IntToStr(brkUpp.StringList.Count));
            q := 0;
            for m := 0 to lstTemp.Count - 1 do
            begin
              strT := lstTemp[m];
              for p := m + q to m + q + m do
                strT := strT + ',' + FloatToStr(StrToFloat(brkUpp.StringList[p], fs));
              //ShowMessage(strT);
              lstCorrMatrix.Add(strT);
              q := q + m;
            end;
          end;
        end;
// ********************************************************************
// Inverse covariance matrix
// ********************************************************************
        if Pos(' ********************                      INVERSE COVARIANCE MATRIX OF ESTIMATE', strList.Strings[n]) > 0 then
        begin
          lstLog.Add('Starting inverse covariance matrix...');
          //ShowMessage('Starting InvCov matrix');
          p := 5;
          lstScratch.Clear;
          while (n + p <= strList.Count - 1) and   // FIX
            (Pos('***************', strList[n + p]) = 0) do
          begin
            lstScratch.Add(strList[n + p]);
            p := p + 1;
          end;
          if Pos('|', lstScratch.Text) = 0 then
          begin
            strT := '';
            for m := 0 to lstScratch.Count - 1 do
            begin
            // Parse line
              if Length(Trim(lstScratch[m])) > 0 then
                strT := strT + '  ' + Trim(lstScratch[m]);
            // Convert and add
              if Length(Trim(lstScratch[m])) = 0 then
              begin
                strT := StringReplace(strT, '+', '', [rfReplaceAll]);
                strT := StringReplace(strT, ' -', '  -', [rfReplaceAll]);
                strT := StringReplace(strT, ' .........', '  .........',
                  [rfReplaceAll]);
                brkUpp.StringList.Clear;
                brkUpp.BaseString := strT;
                brkUpp.BreakString := '  ';
                brkUpp.BreakApart;
                if lstInvCovMatrix.Count = 0 then
                  strT := ','
                else
                  strT := '';
                for p := 0 to brkUpp.StringList.Count - 1 do
                  if (Pos('TH', brkUpp.StringList[p]) = 0) and
                    (Pos('OM', brkUpp.StringList[p]) = 0) and
                    (Pos('SG', brkUpp.StringList[p]) = 0) and
                    (Pos('...', brkUpp.StringList[p]) = 0) then
                    brkUpp.StringList[p] := FloatToStr(StrToFloat(brkUpp.StringList[p], fs));
                for p := 0 to brkUpp.StringList.Count - 1 do
                  if p = brkUpp.StringList.Count - 1 then
                    strT := strT + Trim(brkUpp.StringList[p])
                  else
                    strT := strT + Trim(brkUpp.StringList[p]) + ',';
                strT := StringReplace(strT, ',.........', ',......',
                  [rfReplaceAll]);
                strT := Trim(strT);
                if (Length(strT) > 1) then
                begin
                  if (Pos('TH 1,TH 2', strT) = 0) then
                    lstInvCovMatrix.Add(strT)
                  else
                    if lstInvCovMatrix.Count = 0 then
                      lstInvCovMatrix.Add(strT);
                end;
              //ShowMessage(strT);
                strT := '';
              end;
            end;
          end
          else
// ********************************************************************
// Alternate inverse covariance matrix
// ********************************************************************
          begin
            lstLog.Add('Alternate inverse covariance matrix structure detected...');
            strT := '';
            lstTemp.Clear;
            for m := 0 to lstScratch.Count - 1 do
              if Pos('|', lstScratch[m]) > 0 then
                strT := strT + lstScratch[m];
            strT := StringReplace(strT, '|', ' ', [rfReplaceAll]);
            brkUpp.StringList.Clear;
            brkUpp.BaseString := strT;
            brkUpp.BreakString := '  ';
            brkUpp.BreakApart;
            //ShowMessage(IntToStr(brkUpp.StringList.Count));
            for m := 0 to brkUpp.StringList.Count - 1 do
              if lstTemp.IndexOf(Trim(brkUpp.StringList[m])) = -1 then
                lstTemp.Add(Trim(brkUpp.StringList[m]));
            //ShowMessage(IntToStr(lstTemp.Count));
            strT := '';
            for m := 0 to lstTemp.Count - 1 do
              strT := strT + ',' + lstTemp[m];
            lstInvCovMatrix.Add(strT);
            lstTemp2.Clear;
            strT := '';
            for m := 0 to lstScratch.Count - 1 do
              if (Pos('|', lstScratch[m]) = 0) and
                (Pos('1', lstScratch[m]) <> 1) then
                strT := strT + lstScratch[m];
            brkUpp.StringList.Clear;
            brkUpp.BaseString := strT;
            brkUpp.BreakString := ' ';
            brkUpp.BreakApart;
            //ShowMessage(IntToStr(brkUpp.StringList.Count));
            q := 0;
            for m := 0 to lstTemp.Count - 1 do
            begin
              strT := lstTemp[m];
              for p := m + q to m + q + m do
                strT := strT + ',' + FloatToStr(StrToFloat(brkUpp.StringList[p], fs));
              //ShowMessage(strT);
              lstInvCovMatrix.Add(strT);
              q := q + m;
            end;
          end;
        end;                }
// ********************************************************************
// Eigenvalues
// ********************************************************************
        if Pos(' ********************                      EIGENVALUES OF COR MATRIX OF ESTIMATE', strList.Strings[n]) > 0 then
        begin
          lstLog.Add('Starting eigenvalues...');
          lstScratch.Clear;
          strT := '';
          if (Pos('E', strList[n + 5]) >= 1) then
            strT := Trim(strList[n + 5]);
          if (Pos('E', strList[n + 6]) >= 1) then
            strT := strT + strList[n + 6];
          //ShowMessage(strT);
          if (n + 7 <= strList.Count - 1) and
            (NoAlpha(strList[n + 7])) and
            (Pos('****', strList[n + 7]) = 0) and
            (Pos('E', strList[n + 7]) >= 1) then
            strT := strT + strList[n + 7];

          if (n + 8 <= strList.Count - 1) then
            if (Length(Trim(strList[n + 8])) > 0) and
              (NoAlpha(strList[n + 8])) and
              (Pos('****', strList[n + 8]) = 0) and
            (Pos('E', strList[n + 8]) >= 1) then
              strT := strT + strList[n + 8];

          if (n + 9 <= strList.Count - 1) then
            if (Length(Trim(strList[n + 9])) > 0) and
              (NoAlpha(strList[n + 9])) and
              (Pos('****', strList[n + 9]) = 0) and
            (Pos('E', strList[n + 9]) >= 1) then
              strT := strT + strList[n + 9];

          if (n + 10 <= strList.Count - 1) then
            if (Length(Trim(strList[n + 10])) > 0) and
              (NoAlpha(strList[n + 10])) and
              (Pos('****', strList[n + 10]) = 0) and
            (Pos('E', strList[n + 10]) >= 1) then
              strT := strT + strList[n + 10];

          if (n + 11 <= strList.Count - 1) then
            if (Length(Trim(strList[n + 11])) > 0) and
              (NoAlpha(strList[n + 11])) and
              (Pos('****', strList[n + 11]) = 0) and
            (Pos('E', strList[n + 11]) >= 1) then
              strT := strT + strList[n + 11];

          if (n + 12 <= strList.Count - 1) then
            if (Length(Trim(strList[n + 12])) > 0) and
              (NoAlpha(strList[n + 12])) and
              (Pos('****', strList[n + 12]) = 0) and
            (Pos('E', strList[n + 12]) >= 1) then
              strT := strT + strList[n + 12];

          brkUpp.StringList.Clear;
          brkUpp.BaseString := strT;
          brkUpp.BreakString := ' ';
          brkUpp.BreakApart;
          strT := '';

          //showmessage(brkUpp.StringList.Text);
          //ShowMessage(IntToStr(Round((brkUpp.StringList.Count/2)) - 1));
          for p := 0 to brkUpp.StringList.Count - 1 do
            if Pos('E', brkUpp.StringList[p]) >= 1 then
              strT := strT + ',' + FloatToStr(StrToFloat(brkUpp.StringList[p], fs));
          lstEigen.Add(strT);
          SetRoundMode(rmNearest);
          //ShowMessage(strT);

          //ShowMessage(brkUpp.StringList.Text);
          for m := 0 to brkUpp.StringList.Count - 1 do
          begin
            if Pos('E', brkUpp.StringList[m]) >= 1 then
            begin
              strT := FloatToStr(StrToFloat(brkUpp.StringList[m]));
              for p := 0 to brkUpp.StringList.Count - 1 do
              begin
                strT := strT + ',' + FloatToStr(RoundTo(StrToFloat(brkUpp.StringList[m], fs) /
                  StrToFloat(brkUpp.StringList[p], fs), -4));
              end;
              //ShowMessage(strT);
              lstEigen.Add(strT);
            end;
          end;
{          for m := 0 to brkUpp.StringList.Count - 1 do
          begin
            if Pos('E', brkUpp.StringList[m]) >= 1 then
              strT := FloatToStr(StrToFloat(brkUpp.StringList[m], fs));
            for p := 0 to brkUpp.StringList.Count - 1 do
              if Pos('E', brkUpp.StringList[p]) >= 1 then
                strT := strT + ',' +
                  FloatToStr(RoundTo(StrToFloat(brkUpp.StringList[m], fs) /
                  StrToFloat(brkUpp.StringList[p], fs), -4));
            lstEigen.Add(strT);
          end;    }
          lstLog.Add('Starting condition number...');
// ********************************************************************
// Condition number
// ********************************************************************
          fltEigenUpper := 0.00000000001;
          fltEigenLower := 100000000000;
          fltCondNo := 0;
          //ShowMessage(brkUpp.StringList.Text);
          //ShowMessage(lstEigen.Text);
          for m := 0 to brkUpp.StringList.Count - 1 do
          begin
            //ShowMessage(IntToStr(m) + ' ' + brkUpp.StringList[m]);
            if (StrToFloat(brkUpp.StringList[m], fs) > fltEigenUpper) and
              (Pos('E', brkUpp.StringList[m]) >= 1) then
              fltEigenUpper := StrToFloat(brkUpp.StringList[m], fs);
            if (StrToFloat(brkUpp.StringList[m], fs) < fltEigenLower) and
              (Pos('E', brkUpp.StringList[m]) >= 1) then
              fltEigenLower := StrToFloat(brkUpp.StringList[m], fs);
          end;
          fltCondNo := Abs(RoundTo(fltEigenUpper / fltEigenLower, -2));
        end;
      end;
    except
      on E: Exception do
// ********************************************************************
// Exception message
// ********************************************************************
      begin
        MessageDlg('An error has occurred while processing the NONMEM output file. ' +
          'Please check to make sure that the output file being read is ' +
          'correctly structured.' + #10#13#10#13 + 'If it seems correct, please email Justin Wilkins at justin.wilkins@exprimo.com with ' +
          'a description of the error and a copy of the file you were ' +
          'trying to load (' + nmFile + ').' + #10#13#10#13 + E.ClassName + ': ' + E.Message, mtWarning, [mbOK], 0);
        dlgLog.Lines.Assign(lstLog);
        lstLog.SaveToFile(ExtractFilePath(Application.Exename) + 'run' +
          strRun + '_error.log');
        dlgLog.Execute;
      end;
    end;
  end;

// ********************************************************************
// Free strList
// ********************************************************************
  strList.Free;
  lstLog.Add('Completed output file...');
  strT := '';
  //dlgLog.Lines.Assign(lstLog);
  //dlgLog.Execute;
  //Showmessage('parsing done');


// ********************************************************************
// Read model specification file
// ********************************************************************
  lstLog.Add('Starting model specification file...');
  strModFile := StringReplace(nmFile, extLst, extCtl,
    [rfIgnoreCase]);
  // showmessage(strModFile);
  if not FileExists(strModFile) then
  begin
    if FileExists(StringReplace(strModFile, '.mod', '.ctl',
      [rfIgnoreCase])) then
      strModFile := StringReplace(strModFile, '.mod', '.ctl',
        [rfIgnoreCase]);
    if FileExists(StringReplace(strModFile, '.ctl', '.mod',
      [rfIgnoreCase])) then
      strModFile := StringReplace(strModFile, '.ctl', '.mod',
        [rfIgnoreCase]);
  end;
  if not FileExists(strModFile) then
  begin
    lstLog.Add('No control stream found');
    if blnInlineCtl then
      strModFile := nmFile
    else
      if MessageDlg('No likely control stream file (ideally looking for ' +
        strModFile + ') was located for ' +
        'this run (' + strRun + '). ' +
        'Would you like to select one?', mtConfirmation, [mbYes,
        mbNo], 0) = mrYes then
      begin
        if dlgOpenMod.Execute then
          strModFile := dlgOpenMod.FileName;
      end
      else
        strModFile := '';
  end;
  lstLog.Add('-----------------------------------------');
  lstLog.Add('Control stream... ' + strModFile);
  lstLog.Add('Attempting to open...');
  lstLog.Add('-----------------------------------------');
// ********************************************************************
// Open control stream
// ********************************************************************
  if strModFile <> '' then
    if FileExists(strModFile) then
    begin
      strList := TStringList.Create;
      ThetaModel := TStringList.Create;
      strList.LoadFromFile(strModFile);
      PKParams := TStringList.Create;
      blnPriors := False;
      for n := 0 to strList.Count - 1 do
      begin
        try
            //ShowMessage(strList[n]);
// ********************************************************************
// Read ;;;C Parent
// ********************************************************************
          if (Pos(';;;C Parent=', strList[n]) > 0) then
            strParent := Trim(StringReplace(strList[n], ';;;C Parent=', '', [rfReplaceAll]));

// ********************************************************************
// Notes
// ********************************************************************
          if ((Pos(';;', strList[n]) > 0) and (Pos(';;;C', strList[n]) = 0)) then
            lstNotes.Add(Trim(StringReplace(strList[n], ';;', '', [rfReplaceAll])));

// ********************************************************************
// PsN runrecord annotation
// ********************************************************************
          if ((Pos(';;', strList[n]) > 0) and (Pos(';;;C', strList[n]) = 0)) then
            lstPsNRunRec.Add(Trim(strList[n]));

// ********************************************************************
// $SUBROUTINE block on/off
// ********************************************************************
          if ((Pos('$SUBS', strList[n]) > 0) or (Pos('$SUBROUTINES', strList[n]) > 0)) then
          begin
            btnSub := True;
            //ShowMessage('Subs on');
          end;
          if (Pos('$', strList[n]) > 0) and
            ((Pos('$SUBS', strList[n]) = 0) and (Pos('$SUBROUTINES', strList[n]) = 0)) then
          begin
            btnSub := False;
          end;
// ********************************************************************
// Check for priors
// ********************************************************************
          if btnSub then
            if Pos('PRIOR', strList[n]) > 0 then
            begin
              //ShowMessage('Priors on');
              blnPriors := True;
            end;
// ********************************************************************
// Check for priors
// ********************************************************************
          if Pos('$PRIOR', strList[n]) > 0 then
          begin
            //ShowMessage('Priors on');
            blnPriors := True;
          end;
// ********************************************************************
// $PK block on/off
// ********************************************************************
          if Pos('$PK', strList[n]) > 0 then
            btnPK := True;
          if (Pos('$', strList[n]) > 0) and
            (Pos('$PK', strList[n]) = 0) then
            btnPK := False;
// ********************************************************************
// Read $PK block
// ********************************************************************
          if btnPK then
            PKParams.Add(strList[n]);

// ********************************************************************
// Read $DATA block
// ********************************************************************
          if Pos('$DATA', strList.Strings[n]) > 0 then
          begin
            strDataFile := BrkUp(' ', strList.Strings[n], 1);
            //ShowMessage(strDatafile);
            strDataFile := StringReplace(strDataFile, '"', '', [rfReplaceall]);
            strDataFile := StringReplace(strDataFile, '''', '', [rfReplaceall]);
            strDataFile := StringReplace(strDataFile, '/', '\', [rfReplaceall]);
            if Pos(':', strDataFile) = 0 then
              strDataFile := ExtractFilePath(nmFile) + strDataFile;
            lstLog.Add('Datafile... ' + strDataFile);
            //ShowMessage(strDatafile);
          end;
// ********************************************************************
// Read $THETA block
// ********************************************************************
          if (Pos('$THETA', strList.Strings[n]) = 0) and
            (Pos('$', Trim(strList.Strings[n])) = 1) then
            blnThetasOn := False;
          if Pos('$THETA', strList.Strings[n]) > 0 then
          begin
            blnThetasOn := True;
            if ThInit.Count <> intTheta then
              AddThetaMSFInits(strList[n], ThInit, ThLower, ThUpper);
            if Pos(';', strList[n]) > 0 then
            begin
              ThLabel.Add(BrkUp(';', strList.Strings[n], 1));
              lstLog.Add('Theta Label... ' + BrkUp(';', strList.Strings[n], 1));
              //ShowMessage(BrkUp(';', strList.Strings[n], 1) + ' one');
            end
            else
            begin
              ThLabel.Add(' ');
              lstLog.Add('Theta Label... None!');
            end;
          end;
          // In a block
          if (blnThetasOn) and (Pos(';', strList[n]) > 0) and
            (Pos(';', Trim(strList[n])) > 1) and (Pos('$THETA', strList.Strings[n]) = 0) then
          begin
            ThLabel.Add(BrkUp(';', strList.Strings[n], 1));
            lstLog.Add('Theta Label... ' + BrkUp(';', strList.Strings[n], 1));
            //ShowMessage(BrkUp(';', strList.Strings[n], 1) + ' two');
          end;
// ********************************************************************
// Read ETA labels
// ********************************************************************
          if Pos('$OMEGA', strList.Strings[n]) > 0 then
          begin
            // Is it commented out?
            //Showmessage('on');
            if Pos(';', strList.Strings[n]) > Pos('$OMEGA', strList.Strings[n]) then
              blnEtasOn := True;
            // No comment?
            if Pos(';', strList.Strings[n]) = 0 then
              blnEtasOn := True;
          end;

          if (Pos('$OMEGA', strList.Strings[n]) = 0) and
            (Pos('$', Trim(strList.Strings[n])) = 1) then
          begin
            blnEtasOn := False;
            lstTemp.Clear;
            // If populated, process ETA labels
            // If bars are present, assume done and skip
            if (EtaLabel.Count > 0) and (Pos('|', EtaLabel.Text) = 0) then
            begin
              for p := 0 to EtaLabel.Count - 1 do
              begin
                // Is there a comment?
                if Pos(';', EtaLabel[p]) > 0 then
                  // Is there text before the comment?
                  if Pos(';', Trim(EtaLabel[p])) > 1 then
                    lstTemp.Add(EtaLabel[p]);
              end;
              EtaLabel.Clear;
              for p := 0 to lstTemp.Count - 1 do
              begin
                EtaLabel.Add(IntToStr(p+1) + '|' + BrkUp(';', lstTemp[p], 1));
                lstLog.Add('Eta Label... ' + IntToStr(p+1) + '|' + BrkUp(';', lstTemp[p], 1));
                //ShowMessage('Eta Label... ' + IntToStr(p+1) + '|' + BrkUp(';', lstTemp[p], 1));
              end;
              (EtaLabel as TStringList).Sorted := True; // changed 11/10/05
              (EtaLabel as TStringList).Duplicates := dupIgnore;
              //ShowMessage(EtaLabel.Text);
            end;
          end;

          // Collect lines with $OMEGA records
          if blnEtasOn then
            EtaLabel.Add(strList[n]);

          {if Pos('$OMEGA', strList.Strings[n]) > 0 then
          begin
            blnEtasOn := True;
            if (Pos('BLOCK', strList[n]) > 0)
              and (Pos('BLOCK(1)', StringReplace(strList[n], ' ', '', [rfReplaceAll])) = 0) then
            begin
              for m := Pos('(', strList[n]) + 1 to Pos(')', strList[n]) - 1 do
                strT := strT + strList[n][m];
              r := 0;
              try
                r := StrToInt(strT);
              except
                ShowMessage('An error has occurred reading the number of ' +
                  'dimensions in an $OMEGA BLOCK structure.' + #10#13#10#13 +
                  'Control stream line: ' + IntToStr(n) + '; Block dimension: ' + strT);
              end;
              //ShowMessage(IntToStr(r));
              for m := n + 1 to r do
              begin
                if Pos(';', Trim(strList[n])) > 1 then
                begin
                  intEtCt := intEtCt + 1;
                  EtaLabel.Add(IntToStr(intEtCt) + '|' + BrkUp(';', strList.Strings[n], 1));
                  lstLog.Add('Eta Label... ' + IntToStr(intEtCt) + '|' + BrkUp(';', strList.Strings[n], 1));
                  //ShowMessage('Eta Label... ' + IntToStr(intEtCt) + '|' + BrkUp(';', strList.Strings[n], 1));
                end;
              end;
            end
            else
              if (Pos(';', strList[n]) > 0) and (Pos(';', Trim(strList[n])) > 1) then
              begin
                intEtCt := intEtCt + 1;
                EtaLabel.Add(IntToStr(intEtCt) + '|' + BrkUp(';', strList.Strings[n], 1));
                lstLog.Add('Eta Label... ' + IntToStr(intEtCt) + '|' + BrkUp(';', strList.Strings[n], 1));
                //ShowMessage('Eta Label... ' + IntToStr(intEtCt) + '|' + BrkUp(';', strList.Strings[n], 1));
              end
              else
                if (Pos(';', Trim(strList[n])) > 1) then
                begin
                  intEtCt := intEtCt + 1;
                  EtaLabel.Add(IntToStr(intEtCt) + '|' + ' ');
                  lstLog.Add('Eta Label... None!');
                  if RegIni.ReadBool('Options', 'PromptEtaLabels', True) then
                  begin
                    if not Assigned(frmEtaLabels) then
                      frmEtaLabels := TfrmEtaLabels.Create(Application);
                    frmEtaLabels.ShowModal;
                  end;
                end;
          end; }
          // In a block
       {   if (blnEtasOn) and (Pos(';', strList[n]) > 0) and
            (Pos(';', Trim(strList[n])) > 1) then
          begin
            intEtCt := intEtCt + 1;
            EtaLabel.Add(IntToStr(intEtCt) + '|' + BrkUp(';', strList.Strings[n], 1));
            lstLog.Add('Eta Label... ' + BrkUp(';', strList.Strings[n], 1));
            // ShowMessage(BrkUp(';', strList.Strings[n], 1));
          end;   }

// ********************************************************************
// Read $DATA block
// ********************************************************************
          if (Pos('ETA(', strList.Strings[n]) > 0) then
          begin
          end;
        except
          on EStringListError do
            MessageDlg('Error parsing model control ' +
              'stream at line ' + IntToStr(n + 1) + ' (' +
              strList[n] + ').', mtError, [mbOK], 0);
        end;
      end;

    end
    else
      lstLog.Add('No Control stream found!');
// ********************************************************************
// Sort ETA list
// ********************************************************************
  //ShowMessage('Start sort');
  //ShowMessage(EtaLabel.Text);
  lstTemp2.Clear;
  for n := 0 to EtaLabel.Count - 1 do
  begin
    strT := EtaLabel[n];
    if Pos('|', strT) = 2 then
      strT := '0' + strT;
    lstTemp2.Add(strT);
  end;
  EtaLabel.Clear;
  for n := 0 to lstTemp2.Count - 1 do
    EtaLabel.Add(lstTemp2[n]);
  lstTemp2.Clear;
  //ShowMessage('Presort');
  (EtaLabel as TStringList).Sort;
  //ShowMessage('Postsort');
  {for n := 0 to EtaLabel.Count - 1 do
  begin
    strT := EtaLabel[n];
    if Pos('|', EtaLabel[n]) > 0 then
      EtaLabel[n] := Copy(EtaLabel[n], Pos('|', EtaLabel[n]), 500);
  end; }

    //ShowMessage('Checxkpoint');

  regEx.Subject := lstPsNRunRec.Text;
  regEx.Options := [preMultiLine,preSingleLine,preUnGreedy];
  //ShowMessage(regEx.Subject);
  // 1 based on
  regEx.RegEx := '(?<=^;;[ |  |   |    |     |      ]\d\.[ |  |   |    |     |      ]Based on:).*(?=(;;[ |  |   |    |     |      ]\d\.))';
  if (regEx.Match) then
  begin
    PsNRunRec.BasedOn := StripSpaces(Trim(StringReplace(regEx.MatchedText, ';;', '', [rfReplaceAll])));
    //ShowMessage('Based on: ' + PsNRunRec.BasedOn);
  end;

  // 2 description
  regEx.RegEx := '(?<=^;;[ |  |   |    |     |      ]\d\.[ |  |   |    |     |      ]Description:).*(?=(;;[ |  |   |    |     |      ]\d\.))';
  if (regEx.Match) then
  begin
    PsNRunRec.Description := StripSpaces(Trim(StringReplace(regEx.MatchedText, ';;', '', [rfReplaceAll])));
    //ShowMessage('Description: ' + PsNRunRec.Description);
  end;

  // 3 label
  regEx.RegEx := '(?<=^;;[ |  |   |    |     |      ]\d\.[ |  |   |    |     |      ]Label:).*(?=(;;[ |  |   |    |     |      ]\d\.))';
  if (regEx.Match) then
  begin
    PsNRunRec.PsNLabel := StripSpaces(Trim(StringReplace(regEx.MatchedText, ';;', '', [rfReplaceAll])));
    //ShowMessage('Label: ' + PsNRunRec.PsNLabel);
  end;

  // 4 structural model
  regEx.RegEx := '(?<=^;;[ |  |   |    |     |      ]\d\.[ |  |   |    |     |      ]Structural model:).*(?=(;;[ |  |   |    |     |      ]\d\.))';
  if (regEx.Match) then
  begin
    PsNRunRec.StructuralModel := StripSpaces(Trim(StringReplace(regEx.MatchedText, ';;', '', [rfReplaceAll])));
    //ShowMessage('Structural model: ' + PsNRunRec.StructuralModel);
  end;

  // 5 covariate model
  regEx.RegEx := '(?<=^;;[ |  |   |    |     |      ]\d\.[ |  |   |    |     |      ]Covariate model:).*(?=(;;[ |  |   |    |     |      ]\d\.))';
  if (regEx.Match) then
  begin
    PsNRunRec.CovariateModel := StripSpaces(Trim(StringReplace(regEx.MatchedText, ';;', '', [rfReplaceAll])));
    //ShowMessage('Covariate model: ' + PsNRunRec.CovariateModel);
  end;

  // 6 iiv
  regEx.RegEx := '(?<=^;;[ |  |   |    |     |      ]\d\.[ |  |   |    |     |      ]Inter-individual variability:).*(?=(;;[ |  |   |    |     |      ]\d\.))';
  if (regEx.Match) then
  begin
    PsNRunRec.InterIndividualVariability := StripSpaces(Trim(StringReplace(regEx.MatchedText, ';;', '', [rfReplaceAll])));
    //ShowMessage('IIV: ' + PsNRunRec.InterIndividualVariability);
  end;

  // 7 iov
  regEx.RegEx := '(?<=^;;[ |  |   |    |     |      ]\d\.[ |  |   |    |     |      ]Inter-occasion variability:).*(?=(;;[ |  |   |    |     |      ]\d\.))';
  if (regEx.Match) then
  begin
    PsNRunRec.InterOccasionVariability := StripSpaces(Trim(StringReplace(regEx.MatchedText, ';;', '', [rfReplaceAll])));
    //ShowMessage('IOV: ' + PsNRunRec.InterOccasionVariability);
  end;

  // 8 residual
  regEx.RegEx := '(?<=^;;[ |  |   |    |     |      ]\d\.[ |  |   |    |     |      ]Residual variability:).*(?=(;;[ |  |   |    |     |      ]\d\.))';
  if (regEx.Match) then
  begin
    PsNRunRec.ResidualVariability := StripSpaces(Trim(StringReplace(regEx.MatchedText, ';;', '', [rfReplaceAll])));
    //ShowMessage('RV: ' + PsNRunRec.ResidualVariability);
  end;

  regEx.Options := [preMultiLine,preSingleLine];
  // 9 estimation
  regEx.RegEx := '(?<=^;;[ |  |   |    |     |      ]\d\.[ |  |   |    |     |      ]Estimation:).*';
  if (regEx.Match) then
  begin
    PsNRunRec.Estimation := StripSpaces(Trim(StringReplace(regEx.MatchedText, ';;', '', [rfReplaceAll])));
    //ShowMessage('Estimation: ' + PsNRunRec.Estimation);
  end;

  regEx.Options := [];

// ********************************************************************
// Insert into RUNS table
// ********************************************************************

  //dlgLog.Lines.Assign(lstLog);
  //dlgLog.Execute;
  //Showmessage(strCondEst);

  lstLog.Add('-----------------------------------------');
  lstLog.Add('Inserting into database...');
  lstLog.Add('-----------------------------------------');
  try
    if Length(strCondEst) > 0 then       // strCondEst?
    try
      try
        tblRuns.Insert;
        tblRunsUser.Value := txtUser;
        tblRunsTimestamp.Value := Now;
        lstLog.Add('Inserting into Runs table...');
        tblRunsRunNo.Value := strRun;
        lstLog.Add('RunNo...');
        tblRunsiRunNo.Value := intRun;
        lstLog.Add('iRunNo...');
        tblRunsComment.Value := strComment;
        lstLog.Add('Comment...');
        if RegIni.ReadBool('Options', 'PromptComment', False) then
          if dlgComment.Execute then
            tblRunsComments.Assign(dlgComment.Lines);
        lstLog.Add('Long comment...');
        tblRunsObsRecs.Value := StrToInt(strObsRecs);
        lstLog.Add('ObsRecs...');
        tblRunsIndividuals.Value := StrToInt(strInds);
        lstLog.Add('Inds...');
        tblRunsMinShort.Value := CaseConvert(strMin);
        if Length(strMin) < 1 then
          tblRunsMinShort.Value := 'No minimization step';
        lstLog.Add('MinShort...');
        tblRunsEstTime.Value := fltEstTime;
        lstLog.Add('EstTime...');
        tblRunsCovTime.Value := fltCovTime;
        lstLog.Add('CovTime...');
        tblRunsEpsilonShrinkage.Value := fltEpsShrinkage;
        lstLog.Add('EpsilonShrinkage...');
        //showmessage(lstMinTerm.Text);
        {if lstMinTerm.Count > 0 then
          if Pos('NO. OF FUNCTION EVALUATIONS USED:',
            lstMinTerm[lstMinTerm.Count - 1]) > 0 then
            lstMinTerm.Delete(lstMinTerm.Count - 1);
        if lstMinTerm.Count > 0 then
          if Pos('#TERE',
            lstMinTerm[lstMinTerm.Count - 1]) > 0 then
            lstMinTerm.Delete(lstMinTerm.Count - 1); }
        tblRunsMinimization.Assign(lstMinTerm);
        lstLog.Add('MinFull...');
        if strFnEval <> '' then
          tblRunsFnEvals.Value := StrToInt(strFnEval);
        lstLog.Add('FnEval...');
        tblRunsSigDigits.Value := CaseConvert(strSigDig);
        lstLog.Add('SigDigits...');
        if strObj <> '' then
          tblRunsObj.Value := StrToFloat(strObj, fs);
        lstLog.Add('Obj...');
        tblRunsModel.Value := CaseConvert(strModel);
        lstLog.Add('Model...');
        tblRunsCovStep.Assign(lstCovSum);
        lstLog.Add('CovStep...');
        tblRunsCondEst.Value := False;
        if strCondEst = 'YES' then
          tblRunsCondEst.Value := True;
        lstLog.Add('CondEst...');
        if strCentEta = 'YES' then
          tblRunsCenteredEta.Value := True
        else
          tblRunsCenteredEta.Value := False;
        lstLog.Add('CenteredEta...');
        if strInter = 'YES' then
          tblRunsInteraction.Value := True
        else
          tblRunsInteraction.Value := False;
        lstLog.Add('Interaction...');
        if strLaplacian = 'YES' then
          tblRunsLaplacian.Value := True
        else
          tblRunsLaplacian.Value := False;
        lstLog.Add('Laplacian...');
        tblRunsComments.Assign(lstNotes);
        lstLog.Add('Notes...');

        tblRunsMethFO.Value := blnFO;
        tblRunsMethFOCE.Value := blnFOCE;
        tblRunsMethSAEM.Value := blnSAEM;
        tblRunsMethBayes.Value := blnBayes;
        tblRunsMethImp.Value := blnImp;
        tblRunsMethImpMap.Value := blnImpMap;
        tblRunsMethITS.Value := blnITS;

        // PsN runrecord
        tblRunsIIV.Value := PsNRunRec.InterIndividualVariability;
        tblRunsIOV.Value := PsNRunRec.InterOccasionVariability;
        tblRunsLabel.Value := PsNRunRec.PsNLabel;
        tblRunsStructuralModel.Value := PsNRunRec.StructuralModel;
        tblRunsCovariateModel.Value := PsNRunRec.CovariateModel;
        tblRunsRV.Value := PsNRunRec.ResidualVariability;
        tblRunsEstimation.Value := PsNRunRec.Estimation;
        tblRunsDescription.Value := PsNRunRec.Description;

        // Warnings
        strT2 := '';
        lstLog.Add('Warnings - OFV...');
        if blnOFVWarn then
        begin
          if Length(strT2) <> 0 then
            strT2 := strT2 + '; ';
          strT2 := strT2 + 'OFV carried over from final iteration';
        end;
        lstLog.Add('Warnings - Covariance step...');
        if ThSE.Count = 0 then
        begin
          if Length(strT2) <> 0 then
            strT2 := strT2 + '; ';
          strT2 := strT2 + 'No covariance step';
        end;
        lstLog.Add('Warnings - Algorithmically singular S matrix...');
        if (Pos('ALGORITHMICALLY SINGULAR', lstCovSum.Text) > 0) and
          (Pos('S MATRIX', lstCovSum.Text) > 0) then
        begin
          if Length(strT2) <> 0 then
            strT2 := strT2 + '; ';
          strT2 := strT2 + 'S matrix algorithmically singular';
        end;
        lstLog.Add('Warnings - Algorithmically singular R matrix...');
        if (Pos('ALGORITHMICALLY SINGULAR', lstCovSum.Text) > 0) and
          (Pos('R MATRIX', lstCovSum.Text) > 0) then
        begin
          if Length(strT2) <> 0 then
            strT2 := strT2 + '; ';
          strT2 := strT2 + 'R matrix algorithmically singular';
        end;
        lstLog.Add('Warnings - Non-positive-semidefinite S matrix...');
        if (Pos('NON-POSITIVE-SEMIDEFINITE', lstCovSum.Text) > 0) and
          (Pos('S MATRIX', lstCovSum.Text) > 0) then
        begin
          if Length(strT2) <> 0 then
            strT2 := strT2 + '; ';
          strT2 := strT2 + 'S matrix non-positive-semidefinite';
        end;
        lstLog.Add('Warnings - Non-positive-semidefinite R matrix...');
        if (Pos('NON-POSITIVE-SEMIDEFINITE', lstCovSum.Text) > 0) and
          (Pos('R MATRIX', lstCovSum.Text) > 0) then
        begin
          if Length(strT2) <> 0 then
            strT2 := strT2 + '; ';
          strT2 := strT2 + 'R matrix non-positive-semidefinite';
        end;
        lstLog.Add('Warnings - Rounding errors...');
        if (Pos('ROUNDING ERRORS', lstMinTerm.Text) > 0) and
          (Pos('R MATRIX', lstMinTerm.Text) > 0) then
        begin
          if Length(strT2) <> 0 then
            strT2 := strT2 + '; ';
          strT2 := strT2 + 'Rounding errors';
        end;
        lstLog.Add('Warnings - Hessian count...');
        if intHessian > 0 then
        begin
          if Length(strT2) <> 0 then
            strT2 := strT2 + '; ';
          if intHessian = 1 then
            strT2 := strT2 + IntToStr(intHessian) + ' hessian reset'
          else
            strT2 := strT2 + IntToStr(intHessian) + ' hessian resets';
        end;
        lstLog.Add('Warnings - Zero gradients...');
        if blnZeroGradients then
        begin
          if Length(strT2) <> 0 then
            strT2 := strT2 + '; ';
          strT2 := strT2 + 'Zero gradients';
        end;
        lstLog.Add('Warnings - Condition number...');
        if fltCondNo > RegIni.ReadInteger('Options', 'CondLimit', 1000) then
        begin
          if Length(strT2) <> 0 then
            strT2 := strT2 + '; ';
          strT2 := strT2 + 'High condition number';
        end;
        lstLog.Add('Warnings - Final zero gradients...');
        if blnFZeroGradients then
        begin
          if Length(strT2) <> 0 then
            strT2 := strT2 + '; ';
          strT2 := strT2 + 'Final zero gradients';
        end;
        // Check standard errors
        lstLog.Add('Warnings - Polling THETAs...');
        if ThSE.Count > 0 then
        begin
          //Showmessage(IntTostr(intTheta));
          for m := 1 to ThValue.Count do
          begin
            lstLog.Add('Warnings - THETA large SEs (' + IntToStr(m) + ')...');
            if Pos('..', ThSE[m - 1]) = 0 then
              if (StrToFloat(FloatToStrF(Abs(StrToFloat(ThSE[m - 1], fs) /
                StrToFloat(ThValue[m - 1], fs)), ffGeneral, 3, 0)) >
                StrToFloat(RegIni.ReadString('Options', 'ThetaCVLimit', '0.3'))) then
              begin
                blnLargeSEs := True;
                //ShowMessage(RegIni.ReadString('Options', 'ThetaCVLimit', '0.3'));
                lstLargeSEs.Add('Th ' + IntToStr(m));
              end;
            lstLog.Add('Warnings - THETA zero CIs (' + IntToStr(m) + ')...');
            if Pos('..', ThSE[m - 1]) = 0 then
              if ((StrToFloat(FloatToStrF(StrToFloat(ThValue[m - 1], fs) -
                (1.96 * StrToFloat(ThSE[m - 1], fs)), ffGeneral, 3, 0)) < 0) and
                (StrToFloat(FloatToStrF(StrToFloat(ThValue[m - 1], fs) +
                (1.96 * StrToFloat(ThSE[m - 1], fs)), ffGeneral, 3, 0)) > 0)) or
                ((StrToFloat(FloatToStrF(StrToFloat(ThValue[m - 1], fs) -
                (1.96 * StrToFloat(ThSE[m - 1], fs)), ffGeneral, 3, 0)) > 0) and
                (StrToFloat(FloatToStrF(StrToFloat(ThValue[m - 1], fs) +
                (1.96 * StrToFloat(ThSE[m - 1], fs)), ffGeneral, 3, 0)) < 0)) then
              begin
                blnZeroCIs := True;
                lstZeroCIs.Add('Th ' + IntToStr(m));
              end;
          end;
        end;
        if OmSE.Count > 0 then
        begin
          for m := 1 to Eta.Count do
          begin
            lstLog.Add('Warnings - OMEGA large SEs (' + IntToStr(m) + ')...');
            if Pos('...', OmSE[m - 1]) = 0 then
            try
              if StrToFloat(FloatToStrF(Abs(StrToFloat(OmSE[m - 1], fs) /
                StrToFloat(Eta[m - 1], fs)), ffGeneral, 3, 0)) >
                StrToFloat(RegIni.ReadString('Options', 'OmegaCVLimit', '0.5')) then
              begin
                blnLargeSEs := True;
                lstLargeSEs.Add('Om ' + IntToStr(m));
              end;
            except
              ;
            end;
            lstLog.Add('Warnings - OMEGA zero CIs (' + IntToStr(m) + ')...');
            if Pos('...', OmSE[m - 1]) = 0 then
            try
              if StrToFloat(FloatToStrF(StrToFloat(Eta[m - 1], fs) -
                (1.96 * StrToFloat(OmSE[m - 1], fs)), ffGeneral, 3, 0)) < 0 then
              begin
                blnZeroCIs := True;
                lstZeroCIs.Add('Om ' + IntToStr(m));
              end;
            except
              ;
            end;
          end;
        end;
        if SigSE.Count > 0 then
        begin
          for m := 1 to Eps.Count do
          begin
            lstLog.Add('Warnings - SIGMA large SEs (' + IntToStr(m) + ')...');
            if Pos('..', SigSE[m - 1]) = 0 then
              if StrToFloat(Eps[m - 1], fs) <> 0 then
                if StrToFloat(FloatToStrF(Abs(StrToFloat(SigSE[m - 1], fs) /
                  StrToFloat(Eps[m - 1], fs)), ffGeneral, 3, 0)) >
                  StrToFloat(RegIni.ReadString('Options', 'SigmaCVLimit', '0.3')) then
                begin
                  blnLargeSEs := True;
                  lstLargeSEs.Add('Sg ' + IntToStr(m));
                end;
            lstLog.Add('Warnings - SIGMA zero CIs (' + IntToStr(m) + ')...');
            if Pos('..', SigSE[m - 1]) = 0 then
              if StrToFloat(FloatToStrF(StrToFloat(Eps[m - 1], fs) -
                (1.96 * StrToFloat(SigSE[m - 1], fs)), ffGeneral, 3, 0)) < 0 then
              begin
                blnZeroCIs := True;
                lstZeroCIs.Add('Sg ' + IntToStr(m));
              end;
          end;
        end;
        lstLog.Add('Warnings - Large SEs...');
        if blnLargeSEs then
        begin
          if Length(strT2) <> 0 then
            strT2 := strT2 + '; ';
          strT2 := strT2 + 'Large SEs (';
          for m := 0 to lstLargeSEs.Count - 1 do
          begin
            strT2 := strT2 + lstLargeSEs[m];
            if m < lstLargeSEs.Count - 1 then
              strT2 := strT2 + ', ';
          end;
          strT2 := strT2 + ')';
        end;
        lstLog.Add('Warnings - Errors in PRDERR...');
        if blnPrdErr then
        begin
          if Length(strT2) <> 0 then
            strT2 := strT2 + '; ';
          strT2 := strT2 + 'Prediction errors (PRDERR)';
          //pgcNotes.ActivePage := tabPrdErr;
          //pgcMain.ActivePage := tabMisc;
        end;
        lstLog.Add('Warnings - Zero CIs...');
        if blnZeroCIs then
        begin
          if Length(strT2) <> 0 then
            strT2 := strT2 + '; ';
          strT2 := strT2 + 'CIs overlap zero (';
          for m := 0 to lstZeroCIs.Count - 1 do
          begin
            strT2 := strT2 + lstZeroCIs[m];
            if m < lstZeroCIs.Count - 1 then
              strT2 := strT2 + ', ';
          end;
          strT2 := strT2 + ')';
        end;
        tblRunsWarnings.Value := strT2;
        strT2 := '';
        // WFN prefix
        strWFN := ExtractFilePath(nmFile) + StringReplace(ExtractFileName(nmFile),
          ExtLst, '', [rfReplaceAll]) + '.';
        // Xpose structure
        if (FileExists(ExtractFilePath(nmFile) + 'patab' +
          strRun + extXpose)) {or (FileExists(strWFN + 'g77' +
          'patab' + strRun + extXpose)) or (FileExists(strWFN + 'ivf' +
          'patab' + strRun + extXpose)) or (FileExists(strWFN + 'df' +
          'patab' + strRun + extXpose)) or (FileExists(strWFN + 'wc' +
          'patab' + strRun + extXpose)) or (FileExists(strWFN + 'ms' +
          'patab' + strRun + extXpose))}then
        begin
          tblRunspatab.Value := ExtractFilePath(nmFile) +
            'patab' + strRun + extXpose;
          if blnMD5 then
            tblRunspatabMD5.Value := MD5(ExtractFilePath(nmFile) +
              'patab' + strRun + extXpose);
          lstLog.Add('patab...' + tblRunspatab.Value);
        end;
        if (FileExists(ExtractFilePath(nmFile) + 'sdtab' +
          strRun + extXpose)) {or (FileExists(strWFN + 'g77' +
          'sdtab' + strRun + extXpose)) or (FileExists(strWFN + 'ivf' +
          'sdtab' + strRun + extXpose)) or (FileExists(strWFN + 'df' +
          'sdtab' + strRun + extXpose)) or (FileExists(strWFN + 'wc' +
          'sdtab' + strRun + extXpose)) or (FileExists(strWFN + 'ms' +
          'sdtab' + strRun + extXpose))}then
        begin
          tblRunssdtab.Value := ExtractFilePath(nmFile) +
            'sdtab' + strRun + extXpose;
          if blnMD5 then
            tblRunssdtabMD5.Value := MD5(ExtractFilePath(nmFile) +
              'sdtab' + strRun + extXpose);
          lstLog.Add('sdtab...' + tblRunssdtab.Value);
        end;
        if (FileExists(ExtractFilePath(nmFile) + 'catab' +
          strRun + extXpose)) {or (FileExists(strWFN + 'g77' +
          'catab' + strRun + extXpose)) or (FileExists(strWFN + 'ivf' +
          'catab' + strRun + extXpose)) or (FileExists(strWFN + 'df' +
          'catab' + strRun + extXpose)) or (FileExists(strWFN + 'wc' +
          'catab' + strRun + extXpose)) or (FileExists(strWFN + 'ms' +
          'catab' + strRun + extXpose))}then
        begin
          tblRunscatab.Value := ExtractFilePath(nmFile) +
            'catab' + strRun + extXpose;
          if blnMD5 then
            tblRunscatabMD5.Value := MD5(ExtractFilePath(nmFile) +
              'catab' + strRun + extXpose);
          lstLog.Add('catab...' + tblRunscatab.Value);
        end;
        if (FileExists(ExtractFilePath(nmFile) + 'cotab' +
          strRun + extXpose)) {or (FileExists(strWFN + 'g77' +
          'cotab' + strRun + extXpose)) or (FileExists(strWFN + 'ivf' +
          'cotab' + strRun + extXpose)) or (FileExists(strWFN + 'df' +
          'cotab' + strRun + extXpose)) or (FileExists(strWFN + 'wc' +
          'cotab' + strRun + extXpose)) or (FileExists(strWFN + 'ms' +
          'cotab' + strRun + extXpose))}then
        begin
          tblRunscotab.Value := ExtractFilePath(nmFile) +
            'cotab' + strRun + extXpose;
          if blnMD5 then
            tblRunscotabMD5.Value := MD5(ExtractFilePath(nmFile) +
              'cotab' + strRun + extXpose);
          lstLog.Add('cotab...' + tblRunscotab.Value);
        end;
        if (FileExists(ExtractFilePath(nmFile) + 'mutab' +
          strRun + extXpose)) {or (FileExists(strWFN + 'g77' +
          'mutab' + strRun + extXpose)) or (FileExists(strWFN + 'ivf' +
          'mutab' + strRun + extXpose)) or (FileExists(strWFN + 'df' +
          'mutab' + strRun + extXpose)) or (FileExists(strWFN + 'wc' +
          'mutab' + strRun + extXpose)) or (FileExists(strWFN + 'ms' +
          'mutab' + strRun + extXpose)) }then
        begin
          tblRunsmutab.Value := ExtractFilePath(nmFile) +
            'mutab' + strRun + extXpose;
          if blnMD5 then
            tblRunsmutabMD5.Value := MD5(ExtractFilePath(nmFile) +
              'mutab' + strRun + extXpose);
          lstLog.Add('mutab...' + tblRunsmutab.Value);
        end;
        if (FileExists(ExtractFilePath(nmFile) + 'mytab' +
          strRun + extXpose)) {or (FileExists(strWFN + 'g77' +
          'mytab' + strRun + extXpose)) or (FileExists(strWFN + 'ivf' +
          'mytab' + strRun + extXpose)) or (FileExists(strWFN + 'df' +
          'mytab' + strRun + extXpose)) or (FileExists(strWFN + 'wc' +
          'mytab' + strRun + extXpose)) or (FileExists(strWFN + 'ms' +
          'mytab' + strRun + extXpose)) }then
        begin
          tblRunsmytab.Value := ExtractFilePath(nmFile) +
            'mytab' + strRun + extXpose;
          if blnMD5 then
            tblRunsmytabMD5.Value := MD5(ExtractFilePath(nmFile) +
              'mytab' + strRun + extXpose);
          lstLog.Add('mytab...' + tblRunsmytab.Value);
        end;

        // CWRES
        if (FileExists(ExtractFilePath(nmFile) + 'cwtab' +
          strRun + extXpose)) {or (FileExists(strWFN + 'g77' +
          'mytab' + strRun + extXpose)) or (FileExists(strWFN + 'ivf' +
          'mytab' + strRun + extXpose)) or (FileExists(strWFN + 'df' +
          'mytab' + strRun + extXpose)) or (FileExists(strWFN + 'wc' +
          'mytab' + strRun + extXpose)) or (FileExists(strWFN + 'ms' +
          'mytab' + strRun + extXpose)) }then
        begin
          tblRunscwtab.Value := ExtractFilePath(nmFile) +
            'cwtab' + strRun + extXpose;
          if blnMD5 then
            tblRunscwtabMD5.Value := MD5(ExtractFilePath(nmFile) +
              'cwtab' + strRun + extXpose);
          lstLog.Add('cwtab...' + tblRunscwtab.Value);
        end;
        if (FileExists(ExtractFilePath(nmFile) + 'cwtab' +
          strRun + '.est')) {or (FileExists(strWFN + 'g77' +
          'mytab' + strRun + extXpose)) or (FileExists(strWFN + 'ivf' +
          'mytab' + strRun + extXpose)) or (FileExists(strWFN + 'df' +
          'mytab' + strRun + extXpose)) or (FileExists(strWFN + 'wc' +
          'mytab' + strRun + extXpose)) or (FileExists(strWFN + 'ms' +
          'mytab' + strRun + extXpose)) }then
        begin
          tblRunscwtabEst.Value := ExtractFilePath(nmFile) +
            'cwtab' + strRun + '.est';
          if blnMD5 then
            tblRunscwtabEstMD5.Value := MD5(ExtractFilePath(nmFile) +
              'cwtab' + strRun + '.est');
          lstLog.Add('cwtab.est...' + tblRunscwtabEst.Value);
        end;
        if (FileExists(ExtractFilePath(nmFile) + 'cwtab' +
          strRun + '.deriv')) {or (FileExists(strWFN + 'g77' +
          'mytab' + strRun + extXpose)) or (FileExists(strWFN + 'ivf' +
          'mytab' + strRun + extXpose)) or (FileExists(strWFN + 'df' +
          'mytab' + strRun + extXpose)) or (FileExists(strWFN + 'wc' +
          'mytab' + strRun + extXpose)) or (FileExists(strWFN + 'ms' +
          'mytab' + strRun + extXpose)) }then
        begin
          tblRunscwtabDeriv.Value := ExtractFilePath(nmFile) +
            'cwtab' + strRun + '.deriv';
          if blnMD5 then
            tblRunscwtabDerivMD5.Value := MD5(ExtractFilePath(nmFile) +
              'cwtab' + strRun + '.deriv');
          lstLog.Add('cwtab.deriv...' + tblRunscwtabDeriv.Value);
        end;

        tblRunsLst.Value := nmFile;
        if blnMD5 then
          tblRunsLstMD5.Value := MD5(nmFile);
        lstLog.Add('lst...' + nmFile);
        tblRunsData.Value := strDataFile;
        if blnMD5 then
          tblRunsDataMD5.Value := MD5(strDataFile);
        lstLog.Add('dat...' + strDataFile);
        if FileExists(strModFile) then
        begin
          tblRunsCtl.Value := strModFile;
          if blnMD5 then
            tblRunsCtlMD5.Value := MD5(strModFile);
          lstLog.Add('ctl...' + strModFile);
        end;
        if FileExists(StringReplace(nmFile, extLst, extMsf,
          [rfIgnoreCase])) then
        begin
          tblRunsMsf.Value := StringReplace(nmFile, extLst,
            extMSF, [rfIgnoreCase]);
          if blnMD5 then
            tblRunsMsfMD5.Value := MD5(StringReplace(nmFile, extLst,
              extMSF, [rfIgnoreCase]));
          lstLog.Add('MSF...' + tblRunsMsf.Value);
        end;
        if FileExists(StringReplace(nmFile, extLst, '.ext',
          [rfIgnoreCase])) then
        begin
          tblRunsExt.Value := StringReplace(nmFile, extLst,
            '.ext', [rfIgnoreCase]);
          if blnMD5 then
            tblRunsExtMD5.Value := MD5(StringReplace(nmFile, extLst,
              '.ext', [rfIgnoreCase]));
          lstLog.Add('Ext...' + tblRunsExt.Value);
        end;
        if FileExists(StringReplace(nmFile, extLst, '.phi',
          [rfIgnoreCase])) then
        begin
          tblRunsPhi.Value := StringReplace(nmFile, extLst,
            '.phi', [rfIgnoreCase]);
          if blnMD5 then
            tblRunsPhiMD5.Value := MD5(StringReplace(nmFile, extLst,
              '.phi', [rfIgnoreCase]));
          lstLog.Add('Phi...' + tblRunsPhi.Value);
        end;
        if FileExists(StringReplace(nmFile, extLst, '.cov',
          [rfIgnoreCase])) then
        begin
          tblRunsCov.Value := StringReplace(nmFile, extLst,
            '.cov', [rfIgnoreCase]);
          if blnMD5 then
            tblRunsCovMD5.Value := MD5(StringReplace(nmFile, extLst,
              '.cov', [rfIgnoreCase]));
          lstLog.Add('Cov...' + tblRunsCov.Value);
        end;
        if FileExists(StringReplace(nmFile, extLst, '.cor',
          [rfIgnoreCase])) then
        begin
          tblRunsCor.Value := StringReplace(nmFile, extLst,
            '.cor', [rfIgnoreCase]);
          if blnMD5 then
            tblRunsCorMD5.Value := MD5(StringReplace(nmFile, extLst,
              '.cor', [rfIgnoreCase]));
          lstLog.Add('Cor...' + tblRunsCor.Value);
        end;
        if FileExists(StringReplace(nmFile, extLst, '.coi',
          [rfIgnoreCase])) then
        begin
          tblRunsCoi.Value := StringReplace(nmFile, extLst,
            '.coi', [rfIgnoreCase]);
          if blnMD5 then
            tblRunsCoiMD5.Value := MD5(StringReplace(nmFile, extLst,
              '.coi', [rfIgnoreCase]));
          lstLog.Add('Coi...' + tblRunsCoi.Value);
        end;

        if FileExists(StringReplace(nmFile, extLst, extFit,
          [rfIgnoreCase])) then
        begin
          tblRunsFit.Value := StringReplace(nmFile, extLst,
            extFit, [rfIgnoreCase]);
          if blnMD5 then
            tblRunsFitMD5.Value := MD5(StringReplace(nmFile, extLst,
              extFit, [rfIgnoreCase]));
          lstLog.Add('fit...' + tblRunsFit.Value);
        end;
        {if FileExists(ExtractFilePath(nmFile) + '\PRDERR') then
          tblRunsPrdErr.LoadFromFile(ExtractFilePath(nmFile) + '\PRDERR');
        lstLog.Add('PRDERR...');  }
        if fltCondNo <> 0 then
          tblRunsConditionNumber.Value := fltCondNo;

        if Length(PsNRunRec.BasedOn) > 0 then
        begin
          sqlParent.SQL.Clear;
          sqlParent.SQL.Add('SELECT Obj FROM Runs');
          if IsStrANumber(PsNRunRec.BasedOn) then
            sqlParent.SQL.Add('WHERE RunNo = ' + PsNRunRec.BasedOn + ';')
          else
            sqlParent.SQL.Add('WHERE RunNo = ''' + PsNRunRec.BasedOn + ''';');
          try
            sqlParent.Active := True;
            if sqlParent.RecordCount > 0 then
            begin
              tblRunsParentNo.Value := PsNRunRec.BasedOn;
              tblRunsdOFV.Value := RoundD(tblRunsObj.Value - sqlParent.Fields[0].AsFloat, 3);
            end
            else
              if Length(strParent) > 0 then
              begin
                sqlParent.Active := False;
                sqlParent.SQL.Clear;
                sqlParent.SQL.Add('SELECT Obj FROM Runs');
                if IsStrANumber(strParent) then
                  sqlParent.SQL.Add('WHERE RunNo = ' + strParent + ';')
                else
                  sqlParent.SQL.Add('WHERE RunNo = ''' + strParent + ''';');
                try
                  sqlParent.Active := True;
                  if sqlParent.RecordCount > 0 then
                  begin
                    tblRunsParentNo.Value := strParent;
                    tblRunsdOFV.Value := RoundD(tblRunsObj.Value - sqlParent.Fields[0].AsFloat, 3);
                  end;
                finally
                  sqlParent.Active := False;
                end;
              end;
          finally
            sqlParent.Active := False;
          end;
        end;

        lstLog.Add('Condition Number...' + FloatToStr(tblRunsConditionNumber.Value));
// ********************************************************************
// OMEGA initial estimates matrix
// ********************************************************************
        strT := '';
        for n := 1 to lstMatrixOmegaInit.Count do
        begin
          strT := strT + ', ETA(' + IntToStr(n) + ')';
          brkUpp.StringList.Clear;
          brkUpp.BaseString := lstMatrixOmegaInit[n - 1];
          brkUpp.BreakString := ',';
          brkUpp.BreakApart;
          if brkUpp.StringList.Count < n then
            for m := 1 to (n - brkUpp.StringList.Count) do
            //Insert('0,', lstMatrixOmegaInit[n - 1], 1);
              lstMatrixOmegaInit[n - 1] := '0,' + lstMatrixOmegaInit[n - 1];
        end;
        for n := 1 to lstMatrixOmegaInit.Count do
          lstMatrixOmegaInit[n - 1] := ' ETA(' + IntToStr(n) + '),' + lstMatrixOmegaInit[n - 1];
        lstMatrixOmegaInit.Insert(0, strT);
        tblRunsOmegaInitMatrix.Value := lstMatrixOmegaInit.Text;
      {dlgLog.Lines.Assign(lstMatrixOmegaInit);
      dlgLog.Execute;   }
// ********************************************************************
// OMEGA final estimates matrix
// ********************************************************************
        strT := '';
        //ShowMessage(IntToStr(lstMatrixOmega.Count));
        for n := 1 to lstMatrixOmega.Count do
        begin
          strT := strT + ', ETA(' + IntToStr(n) + ')';
          brkUpp.StringList.Clear;
          brkUpp.BaseString := lstMatrixOmega[n - 1];
          brkUpp.BreakString := ',';
          brkUpp.BreakApart;
          if brkUpp.StringList.Count < n then
            for m := 1 to (n - brkUpp.StringList.Count) do
            //Insert('0,', lstMatrixOmegaInit[n - 1], 1);
              lstMatrixOmega[n - 1] := '0,' + lstMatrixOmega[n - 1];
        end;
        for n := 1 to lstMatrixOmega.Count do
          lstMatrixOmega[n - 1] := ' ETA(' + IntToStr(n) + '),' + lstMatrixOmega[n - 1];
        lstMatrixOmega.Insert(0, strT);
        tblRunsOmegaMatrix.Value := lstMatrixOmega.Text;
      {dlgLog.Lines.Assign(lstMatrixOmegaInit);
      dlgLog.Execute;   }
// ********************************************************************
// OMEGA standard errors matrix
// ********************************************************************
        strT := '';
        //ShowMessage(IntToStr(lstMatrixOmegaSE.Count));
        for n := 1 to lstMatrixOmegaSE.Count do
        begin
          strT := strT + ', ETA(' + IntToStr(n) + ')';
          brkUpp.StringList.Clear;
          brkUpp.BaseString := lstMatrixOmegaSE[n - 1];
          brkUpp.BreakString := ',';
          brkUpp.BreakApart;
          if brkUpp.StringList.Count < n then
            for m := 1 to (n - brkUpp.StringList.Count) do
            //Insert('0,', lstMatrixOmegaInit[n - 1], 1);
              lstMatrixOmegaSE[n - 1] := '0,' + lstMatrixOmegaSE[n - 1];
        end;
        for n := 1 to lstMatrixOmegaSE.Count do
          lstMatrixOmegaSE[n - 1] := ' ETA(' + IntToStr(n) + '),' + lstMatrixOmegaSE[n - 1];
        lstMatrixOmegaSE.Insert(0, strT);
        tblRunsOmegaSEMatrix.Value := lstMatrixOmegaSE.Text;
// ********************************************************************
// SIGMA initial estimates matrix
// ********************************************************************
        strT := '';
        for n := 1 to lstMatrixSigmaInit.Count do
        begin
          strT := strT + ', EPS(' + IntToStr(n) + ')';
          brkUpp.StringList.Clear;
          brkUpp.BaseString := lstMatrixSigmaInit[n - 1];
          brkUpp.BreakString := ',';
          brkUpp.BreakApart;
          if brkUpp.StringList.Count < n then
            for m := 1 to (n - brkUpp.StringList.Count) do
            //Insert('0,', lstMatrixOmegaInit[n - 1], 1);
              lstMatrixSigmaInit[n - 1] := '0,' + lstMatrixSigmaInit[n - 1];
        end;
        for n := 1 to lstMatrixSigmaInit.Count do
          lstMatrixSigmaInit[n - 1] := ' EPS(' + IntToStr(n) + '),' + lstMatrixSigmaInit[n - 1];
        lstMatrixSigmaInit.Insert(0, strT);
        tblRunsSigmaInitMatrix.Value := lstMatrixSigmaInit.Text;
      {dlgLog.Lines.Assign(lstMatrixOmegaInit);
      dlgLog.Execute;   }
// ********************************************************************
// SIGMA final estimates matrix
// ********************************************************************
        strT := '';
        for n := 1 to lstMatrixSigma.Count do
        begin
          strT := strT + ', EPS(' + IntToStr(n) + ')';
          brkUpp.StringList.Clear;
          brkUpp.BaseString := lstMatrixSigma[n - 1];
          brkUpp.BreakString := ',';
          brkUpp.BreakApart;
          if brkUpp.StringList.Count < n then
            for m := 1 to (n - brkUpp.StringList.Count) do
            //Insert('0,', lstMatrixOmegaInit[n - 1], 1);
              lstMatrixSigma[n - 1] := '0,' + lstMatrixSigma[n - 1];
        end;
        for n := 1 to lstMatrixSigma.Count do
          lstMatrixSigma[n - 1] := ' EPS(' + IntToStr(n) + '),' + lstMatrixSigma[n - 1];
        lstMatrixSigma.Insert(0, strT);
        tblRunsSigmaMatrix.Value := lstMatrixSigma.Text;
      {dlgLog.Lines.Assign(lstMatrixOmegaInit);
      dlgLog.Execute;   }
// ********************************************************************
// SIGMA standard errors matrix
// ********************************************************************
        strT := '';
        for n := 1 to lstMatrixSigmaSE.Count do
        begin
          strT := strT + ', EPS(' + IntToStr(n) + ')';
          brkUpp.StringList.Clear;
          brkUpp.BaseString := lstMatrixSigmaSE[n - 1];
          brkUpp.BreakString := ',';
          brkUpp.BreakApart;
          if brkUpp.StringList.Count < n then
            for m := 1 to (n - brkUpp.StringList.Count) do
            //Insert('0,', lstMatrixOmegaInit[n - 1], 1);
              lstMatrixSigmaSE[n - 1] := '0,' + lstMatrixSigmaSE[n - 1];
        end;
        for n := 1 to lstMatrixSigmaSE.Count do
          lstMatrixSigmaSE[n - 1] := ' EPS(' + IntToStr(n) + '),' + lstMatrixSigmaSE[n - 1];
        lstMatrixSigmaSE.Insert(0, strT);
        tblRunsSigmaSEMatrix.Value := lstMatrixSigmaSE.Text;

     {dlgLog.Lines.Assign(lstMatrixOmegaInit);
      dlgLog.Execute;   }
        //dlgLog.Lines.Assign(lstCovMatrix);
        //dlgLog.Execute;
        //dlgLog.Lines.Assign(lstCorrMatrix);
        //dlgLog.Execute;
        //dlgLog.Lines.Assign(lstEigen);
        //dlgLog.Execute;
// ********************************************************************
// Covariance, correlation, inv cov matrix
// ********************************************************************
        tblRunsCovMatrix.Value := lstCovMatrix.Text;
        tblRunsCorrMatrix.Value := lstCorrMatrix.Text;
        tblRunsInvCovMatrix.Value := lstInvCovMatrix.Text;
        tblRunsEigenvalues.Value := lstEigen.Text;
      except
// ********************************************************************
// Exception block
// ********************************************************************
        on E: Exception do
        begin
          MessageDlg('An error has occurred while processing results into the RUN table. ' + #10#13#10#13 +
            'Please email Justin Wilkins at justin.wilkins@exprimo.com with ' +
            'a description of the error and a copy of the file you were ' +
            'trying to load (' + nmFile + ').' + #10#13#10#13 + E.ClassName + ': ' + E.Message, mtError, [mbOK], 0);
          dlgLog.Lines.Assign(lstLog);
          dlgLog.Execute;
        end;
      end;
    finally
      try
        tblRuns.Post;
      except
        on E: Exception do
        begin
          MessageDlg('An error has occurred while updating the RUNS table and'
            + ' changes were not saved.' + #10#13#10#13 + E.ClassName + ': ' + E.Message, mtError, [mbOK], 0);
          tblRuns.Cancel;
        end;
      end;
    end;
// ********************************************************************
// Insert into THETAS table
// ********************************************************************
    //ShowMessage(ThValue.Text);
    ThLabel := StripBlanks(ThLabel);
    if blnPriors then
    begin
      if RegIni.ReadBool('Options', 'WarnPriors', True) then
      begin
        if MessageDlg('Use of the PRIOR subroutine has been detected. Since this means ' +
          'that more parameter records will be present than expected, the number of ' +
          'parameter variables captured will be limited to those reported by the NONMEM ' +
          'output file (THETAs: ' + intToStr(ThValue.Count) + ', ETAs: ' +
          intToStr(Eta.Count) + ', EPSILONs: ' + intToStr(Eps.Count) + ').' + #10#13#10#13 +
          'Full PRIOR functionality will follow in a later release.' + #10#13#10#13 +
          'Do you wish to see this warning again?', mtWarning, [mbYes, mbNo], 0) = mrYes then
          RegIni.WriteBool('Options', 'WarnPriors', True)
        else
          RegIni.WriteBool('Options', 'WarnPriors', False);
      end;
      intTheta := ThValue.Count;
    end;
    //ShowMessage(Inttostr(intTheta));
    for m := 1 to intTheta do
    begin
      try
        try
          tblThetas.Insert;
          lstLog.Add('Inserting into Theta table...');
          tblThetasUser.Value := txtUser;
          tblThetasTimestamp.Value := Now;
          tblThetasRunNo.Value := strRun;
          lstLog.Add('RunNo...');
          tblThetasTheta.Value := m;
          lstLog.Add('Theta...' + IntToStr(m));
          // ShowMessage(IntToStr(intTheta));
          // ShowMessage(IntToStr(ThLabel.Count));
          // ShowMessage(ThLabel.Text);
          for n := 0 to ThLabel.Count - 1 do
            if Length(Trim(ThLabel[n])) = 0 then
              ThLabel.Delete(n);
          // ShowMessage(ThLabel.Text);
          if (ThLabel.Count = intTheta) or ((blnPriors = True)
            and (ThLabel.Count >= intTheta)) then
          begin
            tblThetasThetaLabel.Value := ThLabel[m - 1];
            lstLog.Add('  Label...' + ThLabel[m - 1]);
            //showmessage('  Label...' + ThLabel[m - 1]);
          end;
          if ThValue.Count = intTheta then
          begin
            tblThetasThetaValue.Value := StrToFloat(ThValue[m - 1], fs);
            lstLog.Add('  Value...' + ThValue[m - 1]);
            //showmessage('  Value...' + ThValue[m - 1]);
          end;
          if (ThLower.Count = intTheta) or ((blnPriors = True)
            and (ThLower.Count >= intTheta)) then
          begin
            tblThetasLower.Value := StrToFloat(ThLower[m - 1], fs);
            lstLog.Add('  Lower...' + ThLower[m - 1]);
            //showmessage('  Lower...' + ThLower[m - 1]);
          end;
          if (ThInit.Count = intTheta) or ((blnPriors = True)
            and (ThInit.Count >= intTheta)) then
          begin
            tblThetasInitial.Value := StrToFloat(Trim(ThInit[m - 1]), fs);
            lstLog.Add('  InitEst...' + ThInit[m - 1]);
            //showmessage('  InitEst...' + ThInit[m - 1]);
          end;
          if (ThUpper.Count = intTheta) or ((blnPriors = True)
            and (ThUpper.Count >= intTheta)) then
          begin
            tblThetasUpper.Value := StrToFloat(ThUpper[m - 1], fs);
            lstLog.Add('  Upper...' + ThUpper[m - 1]);
            //showmessage('  Upper...' + ThUpper[m - 1]);
          end;
          if (ThSE.Count = intTheta) or ((blnPriors = True)
            and (ThSE.Count >= intTheta)) then
            if Pos('...', ThSE[m - 1]) = 0 then
            begin
              tblThetasThetaSE.Value := StrToFloat(ThSE[m - 1], fs);
              lstLog.Add('  SE...' + ThSE[m - 1]);
              if tblThetasThetaValue.Value <> 0 then
                tblThetasThetaRSE.Value := StrToFloat(FloatToStrF(Abs(tblThetasThetaSE.Value /
                  tblThetasThetaValue.Value) * 100, ffGeneral, 3, 0));
              lstLog.Add('  RSE...' + FloatToStr(tblThetasThetaRSE.Value));
              if (tblThetasThetaValue.Value <> 0) and
                (tblThetasThetaSE.Value <> 0) then
              begin
                tblThetasThetaCIUpper.Value := StrToFloat(FloatToStrF(tblThetasThetaValue.Value +
                  (1.96 * tblThetasThetaSE.Value), ffGeneral, 3, 0));
                tblThetasThetaCILower.Value := StrToFloat(FloatToStrF(tblThetasThetaValue.Value -
                  (1.96 * tblThetasThetaSE.Value), ffGeneral, 3, 0));
                tblThetasThetaCIs.Value := FloatToStr(tblThetasThetaCILower.Value) +
                  ' ... ' + FloatToStr(tblThetasThetaCIUpper.Value);
                lstLog.Add('  95% CI...' + tblThetasThetaCIs.Value);
              end;
            end;
        except
          on E: Exception do
          begin
            MessageDlg('An error has occurred while processing data into the THETA table. ' + #10#13#10#13 +
              'Please email Justin Wilkins at justin.wilkins@exprimo.com with ' +
              'a description of the error and a copy of the file you were ' +
              'trying to load (' + nmFile + ').' + #10#13#10#13 + E.ClassName + ': ' + E.Message, mtError, [mbOK], 0);
            dlgLog.Lines.Assign(lstLog);
            dlgLog.Execute;
          end;
        end;
      finally
        try
          tblThetas.Post;
        except
          on E: Exception do
          begin
            MessageDlg('An error has occurred while updating the THETAS table and'
              + ' changes were not saved.' + #10#13#10#13 + E.ClassName + ': ' + E.Message, mtError, [mbOK], 0);
            tblThetas.Cancel;
          end;
        end;
      end;
    end;
// ********************************************************************
// Insert into ETAS table
// ********************************************************************
    {dlgLog.Lines.Assign(Eta);
    dlgLog.Execute; }
    intOmega := lstMatrixOmega.Count - 1;
    //ShowMessage(EtaLabel.Text);
    EtaLabel := StripBlanks(EtaLabel);
    //ShowMessage(EtaLabel.Text);
    {ShowMessage('intOmega ' + IntToStr(intOmega));
    ShowMessage('OmSE ' + IntToStr(OmSE.Count));
    ShowMessage('Eta ' + IntToStr(Eta.Count));
    ShowMessage(OMSE.Text);
    ShowMessage(Eta.Text);       }
    for m := 0 to EtaLabel.Count - 1 do
    begin
      if (CharIsDigit(EtaLabel[m][2]) = False) and
        (CharIsDigit(EtaLabel[m][1]) = True) and
        (intOmega > 9) then
        EtaLabel[m] := '0' + EtaLabel[m];
      EtaLabel[m] := EtaLabel[m] + '§§';
    end;
    (EtaLabel as TStringList).Sort;
    for m := 1 to intOmega do
    begin
      try
        try
          tblEtas.Insert;
          lstLog.Add('Inserting into OMEGA table...');
          tblEtasUser.Value := txtUser;
          tblEtasTimestamp.Value := Now;
          tblEtasRunNo.Value := strRun;
          lstLog.Add('RunNo...');
          tblEtasEta.Value := m;
          lstLog.Add('Eta...' + IntToStr(m));
          if EtaLabel.Count = intOmega then
          begin
            //Showmessage(EtaLabel[m - 1]);
            tblEtasEtaLabel.Value := Copy(EtaLabel[m - 1],
              0, Pos('§§', EtaLabel[m - 1]) - 1);
            {tblEtasEtaLabel.Value := StringReplace(tblEtasEtaLabel.Value,
              '|', '', [rfReplaceAll]);   }
            tblEtasEtaLabel.Value := Copy(tblEtasEtaLabel.Value,
              Pos('|', tblEtasEtaLabel.Value) + 1, 500);
            lstLog.Add('  Label...' + EtaLabel[m - 1]);
            tblEtasModel.Value := Copy(EtaLabel[m - 1],
              Pos('§§', EtaLabel[m - 1]) + 1, 50);
          end;
          if (Eta.Count = intOmega) and (Eta.Count > 0) then
          begin
            //ShowMessage(IntToStr(Eta.Count));
            tblEtasEtaValue.Value := StrToFloat(Eta[m - 1], fs);
            lstLog.Add('  Value...' + Eta[m - 1]);
          end;
          //showmessage(OmInit.Text);
          //ShowMessage(IntToStr(intOmega));
          if (OmInit.Count = intOmega) and (OmInit.Count > 0) then
          begin
            tblEtasEtaInit.Value := StrToFloat(OmInit[m - 1], fs);
            lstLog.Add('  InitEst...' + OmInit[m - 1]);
          end;
          if EtaBar.Count = intOmega then
          begin
            if Pos('E', EtaBar[m - 1]) > 0 then
            begin
              tblEtasEtaBar.Value := StrToFloat(EtaBar[m - 1], fs);
            end
            else
              tblEtasEtaBar.Value :=
                StrToFloat(StringReplace(EtaBar[m - 1], '-', 'E-',
                [rfIgnoreCase]), fs);
          end;
          lstLog.Add('  EtaBar...' + FloatToStr(tblEtasEtaBar.Value));
          if EtaBarSE.Count = intOmega then
          begin
            if Pos('E', EtaBarSE[m - 1]) > 0 then
            begin
              tblEtasEtaBarSE.Value := StrToFloat(EtaBarSE[m - 1], fs);
            end
            else
              tblEtasEtaBarSE.Value :=
                StrToFloat(StringReplace(EtaBarSE[m - 1], '-', 'E-',
                [rfIgnoreCase]), fs);
          end;
          lstLog.Add('  EtaBarSE...' + FloatToStr(tblEtasEtaBarSE.Value));
          if EtaP.Count = intOmega then
            if Pos('E', EtaP[m - 1]) > 0 then
              tblEtasEtaPVal.Value := StrToFloat(EtaP[m - 1], fs)
            else
              tblEtasEtaPVal.Value :=
                StrToFloat(StringReplace(EtaP[m - 1], '-', 'E-',
                [rfIgnoreCase]), fs);
          lstLog.Add('  EtaBarPVal...' + FloatToStr(tblEtasEtaPVal.Value));
          if EtaShrinkage.Count = intOmega then
          begin
            if Pos('E', EtaShrinkage[m - 1]) > 0 then
            begin
              tblEtasEtaShrinkage.Value := StrToFloat(EtaShrinkage[m - 1], fs);
            end
            else
              tblEtasEtaShrinkage.Value :=
                StrToFloat(StringReplace(EtaShrinkage[m - 1], '-', 'E-',
                [rfIgnoreCase]), fs);
          end;
          lstLog.Add('  Shrinkage...' + FloatToStr(tblEtasEtaShrinkage.Value));

          //ShowMessage(IntToStr(OmSE.Count) + ',' + IntToStr(intOmega));
          if OmSE.Count = intOmega then
          begin
            if (Pos('...', OmSE[m - 1]) = 0) and (OmSE[m - 1] <> '0') then
              tblEtasEtaSE.Value := StrToFloat(OmSE[m - 1], fs);
            {ShowMessage(lstMatrixOmegaSE[m]);
            ShowMessage(brkUp(',', lstMatrixOmegaSE[m], m));
            tblEtasEtaSE.Value := StrToFloat(brkUp(',', lstMatrixOmegaSE[m], m), fs);  }
            lstLog.Add('  SE...' + OmSE[m - 1]);
            if (tblEtasEtaValue.Value <> 0) and
              (tblEtasEtaSE.Value <> 0) then
              tblEtasEtaRSE.Value := StrToFloat(FloatToStrF((tblEtasEtaSE.Value /
                tblEtasEtaValue.Value) * 100, ffGeneral, 3, 0));
            lstLog.Add('  RSE...' + FloatToStr(tblEtasEtaRSE.Value));
            if (tblEtasEtaValue.Value <> 0) and
              (tblEtasEtaSE.Value <> 0) then
            begin
              tblEtasEtaCIUpper.Value := StrToFloat(FloatToStrF(tblEtasEtaValue.Value +
                (1.96 * tblEtasEtaSE.Value), ffGeneral, 3, 0));
              tblEtasEtaCILower.Value := StrToFloat(FloatToStrF(tblEtasEtaValue.Value -
                (1.96 * tblEtasEtaSE.Value), ffGeneral, 3, 0));
              tblEtasEtaCIs.Value := FloatToStr(tblEtasEtaCILower.Value) +
                ' ... ' + FloatToStr(tblEtasEtaCIUpper.Value);
              lstLog.Add('  95% CI...' + tblEtasEtaCIs.Value);
            end;
            tblEtasBlocks.Value := blnEtaBlocks;
          end;
        except
          on E: Exception do
          begin
            MessageDlg('An error has occurred while processing data into the OMEGA table. ' + #10#13#10#13 +
              'Please email Justin Wilkins at justin.wilkins@exprimo.com with ' +
              'a description of the error and a copy of the file you were ' +
              'trying to load (' + nmFile + ').' + #10#13#10#13 + E.ClassName + ': ' + E.Message, mtError, [mbOK], 0);
            dlgLog.Lines.Assign(lstLog);
            dlgLog.Execute;
          end;
        end;
      finally
        try
          tblEtas.Post;
        except
          on E: Exception do
          begin
            MessageDlg('An error has occurred while updating the OMEGA table and'
              + ' changes were not saved.' + #10#13#10#13 + E.ClassName + ': ' + E.Message, mtError, [mbOK], 0);
            tblEtas.Cancel;
          end;
        end;
      end;
    end;
// ********************************************************************
// Insert into SIGMAS table
// ********************************************************************
    // Fix initial estimates
    intSigma := Eps.Count;
    //lstTemp.Clear;
    if Eps.Count > SigInit.Count then
      for m := 0 to Eps.Count - 1 do
      begin
        if m <= SigInit.Count - 1 then
          strTemp := SigInit[m];
        if m = 0 then
          ;
        if (m > 0) then
        begin
          if (Eps[m] = Eps[m - 1]) then
            SigInit.Insert(m, strTemp);
        end;
      end;

    //ShowMessage(Eps.Text);
    //ShowMessage(SigInit.Text);
    //ShowMessage(SigSE.Text);

    for m := 1 to intSigma do
    begin
      try
        try
          tblSigmas.Insert;
          lstLog.Add('Inserting into Sigma table...');
          tblSigmasUser.Value := txtUser;
          tblSigmasTimestamp.Value := Now;
          tblSigmasRunNo.Value := strRun;
          lstLog.Add('RunNo...');
          tblSigmasSigma.Value := m;
          lstLog.Add('Sigma...' + IntToStr(m));
          if Eps.Count = intSigma then
          begin
            tblSigmasSigmaValue.Value := StrToFloat(Eps[m - 1], fs);
            lstLog.Add('Value...' + Eps[m - 1]);
          end;
          if SigInit.Count = intSigma then
          begin
            tblSigmasSigmaInit.Value := StrToFloat(SigInit[m - 1], fs);
            lstLog.Add('Init Est...' + SigInit[m - 1]);
          end;
          if SigSE.Count = intSigma then
            if Pos('...', SigSE[m - 1]) = 0 then
            begin
              tblSigmasSigmaSE.Value := StrToFloat(SigSE[m - 1], fs);
              lstLog.Add('  SE...' + SigSE[m - 1]);
              if (tblSigmasSigmaValue.Value <> 0) and
                (tblSigmasSigmaSE.Value <> 0) then
                tblSigmasSigmaRSE.Value := StrToFloat(FloatToStrF((tblSigmasSigmaSE.Value /
                  tblSigmasSigmaValue.Value) * 100, ffGeneral, 3, 0));
              if (tblSigmasSigmaValue.Value <> 0) and
                (tblSigmasSigmaSE.Value <> 0) then
              begin
                tblSigmasSigmaCIUpper.Value := StrToFloat(FloatToStrF(tblSigmasSigmaValue.Value +
                  (1.96 * tblSigmasSigmaSE.Value), ffGeneral, 3, 0));
                tblSigmasSigmaCILower.Value := StrToFloat(FloatToStrF(tblSigmasSigmaValue.Value -
                  (1.96 * tblSigmasSigmaSE.Value), ffGeneral, 3, 0));
                tblSigmasSigmaCIs.Value := FloatToStr(tblSigmasSigmaCILower.Value) +
                  ' ... ' + FloatToStr(tblSigmasSigmaCIUpper.Value);
                lstLog.Add('  95% CI...' + tblSigmasSigmaCIs.Value);
              end;
              lstLog.Add('  RSE...' + FloatToStr(tblSigmasSigmaRSE.Value));
            end;
          tblSigmasBlocks.Value := blnSigmaBlocks;
          if EpsShrinkage.Count = intSigma then
          begin
            if Pos('E', EpsShrinkage[m - 1]) > 0 then
            begin
              tblSigmasSigmaShrinkage.Value := StrToFloat(EpsShrinkage[m - 1], fs);
            end
            else
              tblSigmasSigmaShrinkage.Value :=
                StrToFloat(StringReplace(EpsShrinkage[m - 1], '-', 'E-',
                [rfIgnoreCase]), fs);
          end;
          lstLog.Add('  Shrinkage...' + FloatToStr(tblSigmasSigmaShrinkage.Value));

        except
          on E: Exception do
          begin
            MessageDlg('An error has occurred while processing the SIGMA table. ' + #10#13#10#13 +
              'Please email Justin Wilkins at justin.wilkins@exprimo.com with ' +
              'a description of the error and a copy of the file you were ' +
              'trying to load (' + nmFile + ').' + #10#13#10#13 + E.ClassName + ': ' + E.Message, mtError, [mbOK], 0);
            dlgLog.Lines.Assign(lstLog);
            dlgLog.Execute;
          end;
        end;
      finally
        try
          tblSigmas.Post;
        except
          on E: Exception do
          begin
            MessageDlg('An error has occurred while updating the SIGMA table and'
              + ' changes were not saved.' + #10#13#10#13 + E.ClassName + ': ' + E.Message, mtError, [mbOK], 0);
            tblSigmas.Cancel;
          end;
        end;
      end;
    end;
  finally
    tblTrans.InsertRecord([Null, 'add', strRun, Now, txtUser]);
    if tblTrans.Active = False then
      tblTrans.Active := True;
    if tblRuns.Active = False then
      tblRuns.Active := True;
    if tblThetas.Active = False then
      tblThetas.Active := True;
    if tblEtas.Active = False then
      tblEtas.Active := True;
    if tblSigmas.Active = False then
      tblSigmas.Active := True;
    if tblPlotData.Active = False then
      tblPlotData.Active := True;

    //if pnlMain.Visible then
    RefreshTree;
    if pnlCompare.Visible then
      RefreshCompare;
    //tblRuns.Filtered := True;
  end;
// ********************************************************************
// Debug info
// ********************************************************************
  if blnDebug then
  begin
    lstLog.Add(#10#13);
    lstLog.Add('Done!');
    dlgLog.Lines.Assign(lstLog);
    dlgLog.Execute;
  end;

  lstLog.SaveToFile(ExtractFilePath(Application.Exename) + 'run' +
    strRun + '_error.log');     }

    finally
    end;

  end;
// ********************************************************************
// Free all variables
// ********************************************************************
  if Assigned(PKParams) then
    PKParams.Free;
  ThLabel.Free;
  ThLower.Free;
  ThInit.Free;
  ThUpper.Free;
  ThValue.Free;
  ThSE.Free;
  SigInit.Free;
  OmInit.Free;
  EtaBar.Free;
  EtaBarSE.Free;
  EtaP.Free;
  Eta.Free;
  Eps.Free;
  OmSE.Free;
  SigSE.Free;
  EtaLabel.Free;
  EtaShrinkage.Free;
  EpsShrinkage.Free;
  lstLog.Free;
  lstCovSum.Free;
  lstMinTerm.Free;
  lstBlockOmega.Free;
  lstOmegaBlkVars.Free;
  lstSigmaBlkVars.Free;
  lstOmegaIndex.Free;
  lstSigmaIndex.Free;
  lstBlockSigma.Free;
  lstMatrixOmega.Free;
  lstMatrixSigma.Free;
  lstMatrixOmegaInit.Free;
  lstMatrixSigmaInit.Free;
  lstMatrixOmegaSE.Free;
  lstMatrixSigmaSE.Free;
  lstCovMatrix.Free;
  lstCorrMatrix.Free;
  lstInvCovMatrix.Free;
  lstScratch.Free;
  lstTemp.Free;
  lstTemp2.Free;
  strOmegaList.Free;
  strSigmaList.Free;
  lstLargeSEs.Free;
  lstZeroCIs.Free;
  lstPsNRunRec.Free;
  lstNotes.Free;
  brkUpp.StringList.Clear;
  brkUpp.AllowEmptyString := False;
  brkUpp.BaseString := '';
  brkUpp.BreakString := '';

end;


procedure TfrmMain.timScreenTimer(Sender: TObject);
begin
  //try
  //if Screen.Width < frmMain.Width then
  //  frmMain.Width := Screen.Width;
  //if Screen.Height < frmMain.Height then
  //  frmMain.Height := Screen.Height;
  //if frmMain.Top < 0 then
  //  frmMain.Top := 0;
  //except
  //  ;
  //end;
end;

procedure TfrmMain.tvRunsSelectionChanged(Sender: TObject);
var
  strTerms: string;
  List: TStringList;
  rNode: TTreeNode;
  n: Integer;
begin
  if tvRuns.SelectionCount > 0 then
  begin
    rNode := tvRuns.Selected;
    if rNode.Text = 'All runs' then
    begin
      strTerms := '';
    end
    else
    begin
      if rNode.HasChildren = False then
        strTerms := 'where RunNo in (' + QuotedStr(rNode.Text) + ')'
      else
      begin
        strTerms := 'where RunNo in (';
        List := TStringList.Create;
        WalkChildren(rNode, List);
        for n := 0 to List.Count - 1 do
          if n < List.Count - 1 then
            strTerms := strTerms + QuotedStr(List[n]) + ','
          else
            strTerms := strTerms + QuotedStr(List[n]) + ')';
        List.Free;
      end;

      //ShowMessage(strTerms);
    end;

    with qryRuns do
    begin
      Active := False;
      Unprepare;
      SQL.Clear;
      SQL.Add('select * from runs');
      if Length(strTerms) > 0 then
        SQL.Add(strTerms);
      SQL.Add('order by iRunNo;');
      Prepare;
      Active := True;
      First;
    end;
  end;
end;

procedure TfrmMain.WalkChildren(Node: TTreeNode; List: TStringList);
var
  i: Integer;
begin
  List.Add(Node.Text);
  for i := 0 to Node.Count-1 do begin
    WalkChildren(Node[i], List);
  end;
end;

procedure TfrmMain.CaptureRunXML(nmFile: string; flgReplace: Boolean);
var
  strLst, strRun, strPrefix, xmlPrefix, strOFV, strComment,
    strObsRecs, strInds, strDataRecs, strDatafile,
    strTemp, strMin, strMinOverall, strSigDigits, strdOFV: string;
  blnDebug, blnARun, blnAsk, blnFlag, blnPrior, blnS, blnT, blnC, blnNC, blnCap,
    blnFZeroGradients, blnZeroGradients: Boolean;
  lstList, lstLog, lstTheta, lstEta, lstEpsilon, lstThetaSE,
    lstThetaInit, lstThetaLowB, lstThetaUppB, lstThetaLabel,
    lstEtaSE, lstEtaBar, lstEtaBarSE, lstEtaBarP, lstEtaInit,
    lstEtaLabel, lstEtaShrinkage, lstEpsilonSE, lstEpsilonInit,
    lstEpsilonShrinkage, lstEpsilonLabel, lstTemp, lstTemp2,
    lstProbInfo, lstControlStream, lstMatrixOmegaInit,
    lstMatrixSigmaInit, lstMatrixOmega, lstMatrixSigma,
    lstMatrixOmegaSE, lstMatrixSigmaSE, lstMatrixOmegaCSE,
    lstMatrixSigmaCSE, lstMatrixOmegaCorr, lstMatrixSigmaCorr,
    lstPsNRunRec, lstTermInfo, lstCovMatrix, lstCoiMatrix,
    lstCorMatrix, lstEigenvalues, lstTermInfoOverall, lstEst: TStrings;
  stmList: TStringStream;
  nmDoc: TXMLDocument;
  nmNode, nmSNode, nmTest: TDOMNode;
  n, m, p, q, r, s, t, u, intEst, intRun, intC, intTheta, intOmega,
    intSigma, intFnEvals, intHessian, intZeroGradients: Integer;
  oldCursor: TCursor;
  fltEstTime, fltCovTime, fltCondNo, fltEigenLower, fltEigenUpper, fltTemp: Real;
  regEx: TRegExpr;
  PsNRunRec: TPsNRunRec;
  txtLabel, txtUpper, txtLower, txtSE, txtRSE, txtInit, txtLowCI,
    txtUppCI, txtCIs, txtUser, txtShrinkage, txtEtaBar, txtEtaBarSE,
    txtEtaPVal, txtEtaPerc, txtWarnings: string;
begin
  // ********************************************************************
  // Go to safe page
  // ********************************************************************

  pgcMain.ActivePageIndex := 0;

  // ********************************************************************
  // Initialize variables
  // ********************************************************************

  blnDebug := True;
  blnARun := False;

  blnZeroGradients := False;
  blnFZeroGradients := False;

  lstList := TStringList.Create;
  lstLog := TStringList.Create;

  //strPrefix := cenOpts.RunPrefix;
  blnAsk := False;

  blnFlag := False;
  blnPrior := False;

  xmlPrefix := 'nm:';

  lstTheta     := TStringList.Create;
  lstThetaSE   := TStringList.Create;
  lstThetaInit := TStringList.Create;
  lstThetaLowB := TStringList.Create;
  lstThetaUppB := TStringList.Create;
  lstThetaLabel := TStringList.Create;

  lstEta          := TStringList.Create;
  lstEtaSE        := TStringList.Create;
  lstEtaBar       := TStringList.Create;
  lstEtaBarP      := TStringList.Create;
  lstEtaBarSE     := TStringList.Create;
  lstEtaInit      := TStringList.Create;
  lstEtaShrinkage := TStringList.Create;
  lstEtaLabel     := TStringList.Create;

  lstMatrixOmegaInit := TStringList.Create;
  lstMatrixSigmaInit := TStringList.Create;

  lstMatrixOmega     := TStringList.Create;
  lstMatrixSigma     := TStringList.Create;

  lstMatrixOmegaSE   := TStringList.Create;
  lstMatrixSigmaSE   := TStringList.Create;

  lstMatrixOmegaCSE   := TStringList.Create;
  lstMatrixSigmaCSE   := TStringList.Create;

  lstMatrixOmegaCorr   := TStringList.Create;
  lstMatrixSigmaCorr   := TStringList.Create;

  lstEpsilon          := TStringList.Create;
  lstEpsilonSE        := TStringList.Create;
  lstEpsilonInit      := TStringList.Create;
  lstEpsilonShrinkage := TStringList.Create;
  lstEpsilonLabel     := TStringList.Create;

  lstTermInfo := TStringList.Create;
  lstTermInfoOverall := TStringList.Create;

  lstCovMatrix   := TStringList.Create;
  lstCoiMatrix   := TStringList.Create;
  lstCorMatrix   := TStringList.Create;
  lstEigenvalues := TStringList.Create;

  lstProbInfo := TStringList.Create;
  lstControlStream := TStringList.Create;

  lstTemp := TStringList.Create;
  lstTemp2 := TStringList.Create;

  lstPsNRunRec := TStringList.Create;

  txtWarnings := '';

  // ********************************************************************
  // Load options
  // ********************************************************************

   // TODO

  // ********************************************************************
  // Load output file into strList
  // ********************************************************************

  strLst := nmFile;

  if FileExists(ChangeFileExt(nmFile, '.xml')) = False then
  begin
    MessageDlg('An XML file is required for parsing of NONMEM 7.2+ runs. The file ''' + #10 + #13 +
      ChangeFileExt(nmFile, '.xml') + '''' + #10 + #13 + ' does not exist.',
      mtError, [mbOK], 0);
    Exit;
  end;
  if FileExists(ChangeFileExt(nmFile, '.xml')) then
  begin
    try
      nmFile := ChangeFileExt(nmFile, '.xml');

      // ********************************************************************
      // Remove ASCII encoding attribute - XML processing routine cannot cope
      // ********************************************************************

      lstList.LoadFromFile(nmFile);
      if Pos('<?xml version="1.0" encoding="ASCII"?>', lstList.Text) > 0 then
        lstList.Text := StringReplace(lstList.Text, '<?xml version="1.0" encoding="ASCII"?>',
          '<?xml version="1.0"?>', []);

      // ********************************************************************
      // Load modified XML into TStringStream
      // ********************************************************************

      stmList := TStringStream.Create(lstList.Text);
      //ShowMessage(stmList.DataString);

      // ********************************************************************
      // XML namespace info?
      // ********************************************************************

      if Pos('xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"', lstList.Text) = 0 then
      begin
        xmlPrefix := '';
      end
      else
        xmlPrefix := 'nm:';

      lstList.Clear;
      //ShowMessage(xmlPrefix);

      {if Pos('xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"', strList.Text) = 0 then
      begin
        MessageDlg('The XML file for this run (' + ExtractFileName(nmFile) + ') is malformed and cannot be ' +
          'read. A common reason for this is that the files output.xsd, output.dtd, tables.xsd and tables.dtd ' +
          'could not be found when the model was run. Please ensure that the contents of the /run subfolder of your NONMEM installation ' +
          'are visible to NONMEM''s execution script.', mtError, [mbOK], 0);
        strList.Clear;
        Exit;
      end
      else
      begin
        strList.Clear;
      end;    }

      // ********************************************************************
      // Load XML into DOM
      // ********************************************************************

      try
        oldCursor := Screen.Cursor;
        Screen.Cursor := crHourglass;
        ReadXMLFile(nmDoc, stmList);
      finally
        Screen.Cursor := oldCursor;
      end;

      // ********************************************************************
      // Confirm run number
      // ********************************************************************

      lstLog.Add('Opened ' + nmFile + '...');
      lstLog.Add('-----------------------------------------');
      strRun := StringReplace(ExtractFileName(nmFile), cenOpts.RunPrefix, '', [rfReplaceAll]);
      strRun := StringReplace(strRun, '.xml', '', [rfReplaceAll]);
      lstLog.Add('Length of filename... ' + IntToStr(Length(strRun)));
      for n := 1 to Length(strRun) do
        if not (strRun[n] in ['0'..'9']) then
          blnARun := True;
      intRun := ExtractNumberInString(ExtractFileName(nmFile));
      if (blnARun) and (blnAsk) {strRun <> IntToStr(intRun)} then
        strRun := InputBox('Please confirm your run number... [' +
          nmFile + ']', 'Run Number', strRun);
      lstLog.Add('Run number... ' + strRun);

      //ShowMessage(strRun);
      // ********************************************************************
      // Does run exist? If so then replace
      // ********************************************************************

      // TBA
      qryGeneral.Active := False;
      qryGeneral.SQL.Clear;
      qryGeneral.SQL.Add('select RunNo');
      qryGeneral.SQL.Add('from runs');
      qryGeneral.SQL.Add('where RunNo = ''' + strRun + ''';');
      qryGeneral.Active := True;

      if qryGeneral.RecordCount > 0 then
      begin
        if flgReplace then
        begin
          if MessageDlg('A run with the same name (' + strRun + ') appears to be in the database already. ' +
            'Do you want to replace it?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
            NukeRun(strRun)
          else
            begin
              MessageDlg('Import cancelled.', mtInformation, [mbOK], 0);
              Exit;
            end;
        end
        else
        begin
          NukeRun(strRun);
        end;
      end;
      qryGeneral.Active := False;
      qryGeneral.SQL.Clear;

      intEst := 0;
      fltEstTime := 0;
      fltCovTime := 0;

      //ShowMessage(IntToStr(nmDoc.ChildNodes.Count));

      try
        oldCursor := Screen.Cursor;
        Screen.Cursor := crHourglass;

        qryAdd.SQL.Clear;
        //qryAdd.SQL.Add('BEGIN TRANSACTION;');
        //ShowMessage('Beginning');

      nmNode := nmDoc.DocumentElement.FindNode(xmlPrefix + 'nonmem').FindNode(xmlPrefix + 'problem');
      if Assigned(nmNode) then
      begin
        //intEst := IntToStr(nmNode.ChildNodes.Count) - 2;
        //ShowMessage(IntToStr(nmNode.ChildNodes.Count));

        // ********************************************************************
        // Initial estimates & bounds of THETA
        // ********************************************************************

        if nmNode.FindNode(xmlPrefix + 'problem_information') <> nil then
        begin
          lstList.Assign(LineBreaks(nmNode.FindNode(xmlPrefix + 'problem_information').TextContent));
          lstProbInfo.Assign(LineBreaks(nmNode.FindNode(xmlPrefix + 'problem_information').TextContent));

          lstTemp.Clear;
          //ShowMessage('lstList - ' + IntToStr(lstList.Count));

          for n := 0 to lstList.Count - 1 do
          begin
            if Pos('0INITIAL ESTIMATE OF OMEGA:', lstList[n]) > 0 then
              blnFlag := False;
            if blnFlag then
              lstTemp.Add(lstList[n]);
            if Pos('0INITIAL ESTIMATE OF THETA:', lstList[n]) > 0 then
              blnFlag := True;
          end;

          //ShowMessage('lstTemp - ' + IntToStr(lstList.Count));
          for n := 1 to lstTemp.Count - 1 do
          begin
            // Handle Initial Estimates Step (12/8/13) ******************************
            brkUpp.BaseString := lstTemp[n];
            brkUpp.BreakString := ' ';
            brkUpp.AllowEmptyString := False;
            brkUpp.BreakApart;
            if brkUpp.StringList.Count = 3 then
            begin
              lstThetaInit.Add(BrkUp(' ', lstTemp[n], 1));
              lstLog.Add('THETA(' + IntToStr(n) + ') Initial Est... ' +
                BrkUp(' ', lstTemp[n], 1));
              lstThetaLowB.Add(BrkUp(' ', lstTemp[n], 0));
              lstLog.Add('THETA(' + IntToStr(n) + ') Lower Bound... ' +
                BrkUp(' ', lstTemp[n], 0));
              lstThetaUppB.Add(BrkUp(' ', lstTemp[n], 2));
              lstLog.Add('THETA(' + IntToStr(n) + ') Upper Bound... ' +
                BrkUp(' ', lstTemp[n], 2));
            end
            else
            begin
              lstLog.Add('Initial Estimates Step requested for THETA(' + IntToStr(n) + ')');
              lstThetaInit.Add('NULL');
              lstLog.Add('THETA(' + IntToStr(n) + ') Initial Est... ' +
                'None');
              lstThetaLowB.Add(BrkUp(' ', lstTemp[n], 0));
              lstLog.Add('THETA(' + IntToStr(n) + ') Lower Bound... ' +
                BrkUp(' ', lstTemp[n], 0));
              lstThetaUppB.Add(BrkUp(' ', lstTemp[n], 1));
              lstLog.Add('THETA(' + IntToStr(n) + ') Upper Bound... ' +
                BrkUp(' ', lstTemp[n], 1));
            end;
          end;

          //ShowMessage(lstThetaInit.Text);
          lstTemp.Clear;

         end;

      // ********************************************************************
      // Collect other bits of output
      // ********************************************************************

        //ShowMessage('lstProbInfo - ' + IntToStr(lstList.Count));
        for n := 0 to lstProbInfo.Count - 1 do
        begin

      // ********************************************************************
      // Read comment
      // ********************************************************************
          if Pos('PROBLEM NO.:', lstProbInfo[n]) > 0 then
          begin
            strComment := Trim(lstProbInfo[n + 1]);
            lstLog.Add('Comment... ' + strComment);
          end;

      // ********************************************************************
      // Read no of records
      // ********************************************************************
          if Pos('NO. OF DATA RECS IN DATA SET:', lstProbInfo[n]) > 0 then
          begin
            strDataRecs := BrkUp(':', lstProbInfo[n], 1);
            lstLog.Add('Data Records... ' + strDataRecs);
          end;

      // ********************************************************************
      // Read no of THETAs
      // ********************************************************************
          if Pos('0LENGTH OF THETA:', lstProbInfo[n]) > 0 then
          begin
            intTheta := StrToInt(BrkUp(':', lstProbInfo[n], 1));
            lstLog.Add('THETAs... ' + BrkUp(':', lstProbInfo[n], 1));
          end;

      // ********************************************************************
      // Read no of observations
      // ********************************************************************
          if Pos('TOT. NO. OF OBS RECS:', lstProbInfo[n]) > 0 then
          begin
            strObsRecs := BrkUp(':', lstProbInfo[n], 1);
            lstLog.Add('Observation Records... ' + strObsRecs);
          end;

      // ********************************************************************
      // Read no of individuals
      // ********************************************************************
          if Pos('TOT. NO. OF INDIVIDUALS:', lstProbInfo[n]) > 0 then
          begin
            strInds := BrkUp(':', lstProbInfo[n], 1);
            lstLog.Add('Individuals... ' + strInds);
          end;

        end;
      end
      else
      begin
        MessageDlg('Unable to locate a NONMEM problem in this file. Import cancelled.',
          mtError, [mbOK], 0);
        Exit;
      end;

      // ********************************************************************
      // Control stream
      // ********************************************************************

      lstControlStream.Assign(LineBreaks(nmDoc.DocumentElement.FindNode(xmlPrefix + 'control_stream').TextContent));
      //ShowMessage(lstControlStream.Text);

      blnFlag := False;

      //ShowMessage('lstControlStream - ' + IntToStr(lstList.Count));
      for n := 0 to lstControlStream.Count - 1 do
      begin

        // ********************************************************************
        // Read PsN header information
        // ********************************************************************

        if ((Pos(';;', lstControlStream[n]) > 0) and (Pos(';;;C', lstControlStream[n]) = 0)) then
          lstPsNRunRec.Add(Trim(lstControlStream[n]));

        // ********************************************************************
        // PRIOR
        // ********************************************************************
        if Pos('$PRIOR', lstControlStream[n]) > 0 then
          blnPrior := True;

        // ********************************************************************
        // Read $DATA block
        // ********************************************************************
          if Pos('$DATA', lstControlStream[n]) > 0 then
          begin
            strDataFile := BrkUp(' ', lstControlStream[n], 1);
            //ShowMessage(strDatafile);
            strDataFile := StringReplace(strDataFile, '"', '', [rfReplaceall]);
            strDataFile := StringReplace(strDataFile, '''', '', [rfReplaceall]);
            //strDataFile := StringReplace(strDataFile, '/', '\', [rfReplaceall]);
            if Pos(':', strDataFile) = 0 then
              strDataFile := ExtractFilePath(nmFile) + strDataFile;
            lstLog.Add('Datafile... ' + strDataFile);
            //ShowMessage(strDatafile);
          end;

          // ********************************************************************
          // Read $THETA labels
          // ********************************************************************
          if (Pos('$THETA', lstControlStream[n]) = 0) and
            (Pos('$', Trim(lstControlStream[n])) = 1) then
              blnFlag := False;

          if Pos('$THETA', lstControlStream[n]) > 0 then
          begin
            blnFlag := True;
            if lstThetaInit.Count <> intTheta then
              AddThetaMSFInits(lstControlStream[n], lstThetaInit, lstThetaLowB, lstThetaUppB);
            if Pos(';', lstControlStream[n]) > 0 then
            begin
              lstThetaLabel.Add(BrkUp(';', lstControlStream[n], 1));
              lstLog.Add('Theta Label... ' + BrkUp(';', lstControlStream[n], 1));
              //ShowMessage(BrkUp(';', lstControlStream[n], 1) + ' one');
            end
            else
            begin
              if (Length(Trim(lstControlStream[n])) > 0) and (Pos('$THETA', Trim(lstControlStream[n])) <> 1) then
              begin
                lstThetaLabel.Add(' ');
                lstLog.Add('Theta Label... None!');
                //ShowMessage('null - ' + Trim(lstControlStream[n]));
              end;
            end;
          end;

          // In a block
          if (blnFlag) and (Pos(';', lstControlStream[n]) > 0) and
            (Pos(';', Trim(lstControlStream[n])) > 1) and (Pos('$THETA', lstControlStream[n]) = 0) then
          begin
            lstThetaLabel.Add(BrkUp(';', lstControlStream[n], 1));
            lstLog.Add('Theta Label... ' + BrkUp(';', lstControlStream[n], 1));
            //ShowMessage(BrkUp(';', strList.Strings[n], 1) + ' two');
          end;

      end;

      nmTest := nmNode.FindNode(xmlPrefix + 'estimation').FindNode(xmlPrefix + 'omega');
      if nmTest <> nil then
      begin
        intOmega := nmNode.FindNode(xmlPrefix + 'estimation').FindNode(xmlPrefix + 'omega').ChildNodes.Count;
        intSigma := nmNode.FindNode(xmlPrefix + 'estimation').FindNode(xmlPrefix + 'sigma').ChildNodes.Count;
      end
      else
      begin
        MessageDlg('Some key elements are missing from this run, and it cannot be imported.', mtWarning, [mbOK], 0);
        NukeRun(strRun);
        Exit;
      end;

      // ********************************************************************
      // Initial estimates of OMEGA
      // ********************************************************************

      lstTemp.Assign(lstControlStream);
      lstTemp2.Clear;

      blnFlag := False;

      for m := 0 to lstTemp.Count - 1 do
      begin
        if (Pos('$OMEGA', lstTemp[m]) > 0) then
          blnFlag := True;

        if (Pos('$OMEGA', lstTemp[m]) = 0) and (Pos('$', lstTemp[m]) > 0) then
          if (Pos(';', lstTemp[m]) = 0) or (Pos(';', lstTemp[m]) > Pos('$', lstTemp[m])) then
            blnFlag := False;

        if blnFlag then
          if (Pos(';', lstTemp[m]) = 0) then
            lstTemp2.Add(lstTemp[m])
          else
          begin
            lstTemp2.Add(Copy(lstTemp[m], 1, Pos(';', lstTemp[m])-1));
            lstEtaLabel.Add(Copy(lstTemp[m], Pos(';', lstTemp[m])+1, 500));
          end;

      end;
      //ShowMessage(lstEtaLabel.Text);

      lstTemp.Clear;
      lstTemp2.Clear;

      regEx := TRegExpr.Create;

      regEx.ModifierM := True;
      regEx.Expression := '0INITIAL ESTIMATE OF OMEGA:.*0INITIAL ESTIMATE OF SIGMA:';
      if regEx.Exec(lstProbInfo.Text) then
        lstTemp.Add(regEx.Match[0]);

      // fix line breaks
      lstTemp.Text := StringReplace(StringReplace(lstTemp.Text, #10, '£', [rfReplaceAll]), #13, 'ç', [rfReplaceAll]);
      lstTemp.Text := StringReplace(lstTemp.Text, '£ç',#13, [rfReplaceAll]);
      lstTemp.Text := StringReplace(lstTemp.Text, 'ç£', #13, [rfReplaceAll]);
      lstTemp.Text := StringReplace(lstTemp.Text, '£', #13, [rfReplaceAll]);
      lstTemp.Text := StringReplace(lstTemp.Text, 'ç', #13, [rfReplaceAll]);

      strTemp := '';
      n := 0;
      s := 0;
      regEx.Expression := '(-)?\d\.\d{4}E[+-]{1}\d{2}';   // scientific notation for init
      for m := 0 to lstTemp.Count - 1 do
      begin
        if regEx.Exec(lstTemp[m]) then
          repeat
            strTemp := strTemp + regEx.Match[0] + ',';
            n := n + 1;
          until not regEx.ExecNext;

        if Length(Trim(strTemp)) > 0 then
        begin
          s := s + 1;
          if n < s then
            for p := 1 to s - n do
              strTemp := '0,' + strTemp;
          lstTemp2.Add(Copy(strTemp, 1, Length(strTemp)-1));
        end;
        strTemp := '';
        n := 0;
      end;

      lstMatrixOmegaInit.Assign(lstTemp2);
      //Showmessage(lstMatrixOmegaInit.Text);

      for m := 0 to lstMatrixOmegaInit.Count - 1 do
      begin
        brkUpp.BaseString := lstMatrixOmegaInit[m];
        brkUpp.BreakString := ',';
        brkUpp.BreakApart;
        lstEtaInit.Add(brkUpp.StringList[brkUpp.StringList.Count-1]);
      end;
      //ShowMessage(lstEtaInit.Text);

      // ********************************************************************
      // Initial estimates of SIGMA
      // ********************************************************************

      lstTemp.Assign(lstControlStream);
      lstTemp2.Clear;

      blnFlag := False;

      for m := 0 to lstTemp.Count - 1 do
      begin
        if (Pos('$SIGMA', lstTemp[m]) > 0) then
          blnFlag := True;

        if (Pos('$SIGMA', lstTemp[m]) = 0) and (Pos('$', lstTemp[m]) > 0) then
          if (Pos(';', lstTemp[m]) = 0) or (Pos(';', lstTemp[m]) > Pos('$', lstTemp[m])) then
            blnFlag := False;

        if blnFlag then
          if (Pos(';', lstTemp[m]) = 0) then
            lstTemp2.Add(lstTemp[m])
          else
          begin
            lstTemp2.Add(Copy(lstTemp[m], 1, Pos(';', lstTemp[m])-1));
            lstEpsilonLabel.Add(Copy(lstTemp[m], Pos(';', lstTemp[m])+1, 500));
          end;

      end;
      //ShowMessage(lstEpsilonLabel.Text);

      lstTemp.Clear;
       lstTemp2.Clear;

       regEx := TRegExpr.Create;

       regEx.ModifierM := True;
       regEx.Expression := '0INITIAL ESTIMATE OF SIGMA:.*^0';
       if regEx.Exec(lstProbInfo.Text) then
         lstTemp.Add(regEx.Match[0]);

       // fix line breaks
       lstTemp.Text := StringReplace(StringReplace(lstTemp.Text, #10, '£', [rfReplaceAll]), #13, 'ç', [rfReplaceAll]);
       lstTemp.Text := StringReplace(lstTemp.Text, '£ç',#13, [rfReplaceAll]);
       lstTemp.Text := StringReplace(lstTemp.Text, 'ç£', #13, [rfReplaceAll]);
       lstTemp.Text := StringReplace(lstTemp.Text, '£', #13, [rfReplaceAll]);
       lstTemp.Text := StringReplace(lstTemp.Text, 'ç', #13, [rfReplaceAll]);

       strTemp := '';
       n := 0;
       s := 0;
       regEx.Expression := '(-)?\d\.\d{4}E[+-]{1}\d{2}';   // scientific notation for init
       for m := 0 to lstTemp.Count - 1 do
       begin
         if regEx.Exec(lstTemp[m]) then
           repeat
             strTemp := strTemp + regEx.Match[0] + ',';
             n := n + 1;
           until not regEx.ExecNext;

         if Length(Trim(strTemp)) > 0 then
         begin
           s := s + 1;
           if n < s then
             for p := 1 to s - n do
               strTemp := '0,' + strTemp;
           lstTemp2.Add(Copy(strTemp, 1, Length(strTemp)-1));
         end;
         strTemp := '';
         n := 0;
       end;

       lstMatrixSigmaInit.Assign(lstTemp2);

       for m := 0 to lstMatrixSigmaInit.Count - 1 do
       begin
         brkUpp.BaseString := lstMatrixSigmaInit[m];
         brkUpp.BreakString := ',';
         brkUpp.BreakApart;
         lstEpsilonInit.Add(brkUpp.StringList[brkUpp.StringList.Count-1]);
       end;

      //ShowMessage(lstEpsilonInit.Text);
      //ShowMessage(lstMatrixSigmaInit.Text);


      //ShowMessage('Check one');
      if nmNode.FindNode(xmlPrefix + 'problem_information') <> nil then
      begin
        lstList.Assign(LineBreaks(nmNode.FindNode(xmlPrefix + 'problem_information').TextContent));
        lstProbInfo.Assign(LineBreaks(nmNode.FindNode(xmlPrefix + 'problem_information').TextContent));

      // ********************************************************************
      // Estimation step loop
      // ********************************************************************

        //ShowMessage('nmNode.ChildNodes - ' + IntToStr(lstList.Count));
        for n := 0 to nmNode.ChildNodes.Count - 1 do
        begin
          //ShowMessage(nmNode.ChildNodes[n].NodeName);
          if nmNode.ChildNodes[n].NodeName = xmlPrefix + 'estimation' then
          begin
            intEst := intEst + 1;
            // iteration number is attribute 1

            //ShowMessage('zap');
            if nmNode.ChildNodes[n].FindNode(xmlPrefix + 'final_objective_function') <> nil then
              strOFV := nmNode.ChildNodes[n].FindNode(xmlPrefix + 'final_objective_function').TextContent
            else
            begin
              MessageDlg('No OFV detected - import cancelled.', mtInformation, [mbOK], 0);
              Exit;
            end;


            // Theta  *********************************************************************
            if nmNode.ChildNodes[n].FindNode(xmlPrefix + 'theta') <> nil then
            begin
              //ShowMessage(IntToStr(nmNode.ChildNodes[n].FindNode(xmlPrefix + 'theta').ChildNodes.Count));
              lstTheta.Clear;

              for m := 0 to nmNode.ChildNodes[n].FindNode(xmlPrefix + 'theta').ChildNodes.Count - 1 do
              begin
                //ShowMessage(nmNode.ChildNodes[n].FindNode(xmlPrefix + 'theta').ChildNodes[m].TextContent);
                lstTheta.Add(nmNode.ChildNodes[n].FindNode(xmlPrefix + 'theta').ChildNodes[m].TextContent);
              end;
              //ShowMessage(lstTheta.Text);
            end;

            // Theta SE  *********************************************************************
            if nmNode.ChildNodes[n].FindNode(xmlPrefix + 'thetase') <> nil then
            begin
              lstThetaSE.Clear;
              for m := 0 to nmNode.ChildNodes[n].FindNode(xmlPrefix + 'thetase').ChildNodes.Count - 1 do
              begin
                lstThetaSE.Add(nmNode.ChildNodes[n].FindNode(xmlPrefix + 'thetase').ChildNodes[m].TextContent);
              end;
            end;

            // Omega  *********************************************************************
            if nmNode.ChildNodes[n].FindNode(xmlPrefix + 'omega') <> nil then
            begin
              lstEta.Clear;
              lstMatrixOmega.Clear;
              for m := 0 to nmNode.ChildNodes[n].FindNode(xmlPrefix + 'omega').ChildNodes.Count - 1 do
              begin
                intC := nmNode.ChildNodes[n].FindNode(xmlPrefix + 'omega').ChildNodes[m].ChildNodes.Count;
                //ShowMessage(IntToStr(nmNode.ChildNodes[n].FindNode(xmlPrefix + 'omega').ChildNodes[m].ChildNodes.Count));
                //ShowMessage(nmNode.ChildNodes[n].FindNode(xmlPrefix + 'omega').ChildNodes[m].ChildNodes[intC - 1].TextContent);
                lstEta.Add(nmNode.ChildNodes[n].FindNode(xmlPrefix + 'omega').ChildNodes[m].ChildNodes[intC - 1].TextContent);
                strTemp := '';
                for p := 0 to nmNode.ChildNodes[n].FindNode(xmlPrefix + 'omega').ChildNodes[m].ChildNodes.Count - 1 do
                begin
                  if p > 0 then
                    strTemp := strTemp + ',' + nmNode.ChildNodes[n].FindNode(xmlPrefix + 'omega').ChildNodes[m].ChildNodes[p].TextContent
                  else
                    strTemp := nmNode.ChildNodes[n].FindNode(xmlPrefix + 'omega').ChildNodes[m].ChildNodes[p].TextContent;
                  if p = nmNode.ChildNodes[n].FindNode(xmlPrefix + 'omega').ChildNodes[m].ChildNodes.Count - 1 then
                  begin
                    lstMatrixOmega.Add(strTemp);
                    strTemp := '';
                  end;
                end;
              end;
            end;

            // Omega SE  *********************************************************************
            if nmNode.ChildNodes[n].FindNode(xmlPrefix + 'omegase') <> nil then
            begin
              lstEtaSE.Clear;
              lstMatrixOmegaSE.Clear;
              for m := 0 to nmNode.ChildNodes[n].FindNode(xmlPrefix + 'omegase').ChildNodes.Count - 1 do
              begin
                intC := nmNode.ChildNodes[n].FindNode(xmlPrefix + 'omegase').ChildNodes[m].ChildNodes.Count;
                //ShowMessage(IntToStr(nmNode.ChildNodes[n].FindNode(xmlPrefix + 'omega').ChildNodes[m].ChildNodes.Count));
                //ShowMessage(nmNode.ChildNodes[n].FindNode(xmlPrefix + 'omega').ChildNodes[m].ChildNodes[intC - 1].TextContent);
                lstEtaSE.Add(nmNode.ChildNodes[n].FindNode(xmlPrefix + 'omegase').ChildNodes[m].ChildNodes[intC - 1].TextContent);
                strTemp := '';
                for p := 0 to nmNode.ChildNodes[n].FindNode(xmlPrefix + 'omegase').ChildNodes[m].ChildNodes.Count - 1 do
                begin
                  if p > 0 then
                    strTemp := strTemp + ',' + nmNode.ChildNodes[n].FindNode(xmlPrefix + 'omegase').ChildNodes[m].ChildNodes[p].TextContent
                  else
                    strTemp := nmNode.ChildNodes[n].FindNode(xmlPrefix + 'omegase').ChildNodes[m].ChildNodes[p].TextContent;
                  if p = nmNode.ChildNodes[n].FindNode(xmlPrefix + 'omegase').ChildNodes[m].ChildNodes.Count - 1 then
                  begin
                    lstMatrixOmegaSE.Add(strTemp);
                    strTemp := '';
                  end;
                end;
              end;
            end;

            // OmegaCorr  *********************************************************************
            if nmNode.ChildNodes[n].FindNode(xmlPrefix + 'omegac') <> nil then
            begin
              lstMatrixOmegaCorr.Clear;
              for m := 0 to nmNode.ChildNodes[n].FindNode(xmlPrefix + 'omegac').ChildNodes.Count - 1 do
              begin
                strTemp := '';
                for p := 0 to nmNode.ChildNodes[n].FindNode(xmlPrefix + 'omegac').ChildNodes[m].ChildNodes.Count - 1 do
                begin
                  if p > 0 then
                    strTemp := strTemp + ',' + nmNode.ChildNodes[n].FindNode(xmlPrefix + 'omegac').ChildNodes[m].ChildNodes[p].TextContent
                  else
                    strTemp := nmNode.ChildNodes[n].FindNode(xmlPrefix + 'omegac').ChildNodes[m].ChildNodes[p].TextContent;
                  if p = nmNode.ChildNodes[n].FindNode(xmlPrefix + 'omegac').ChildNodes[m].ChildNodes.Count - 1 then
                  begin
                    lstMatrixOmegaCorr.Add(strTemp);
                    strTemp := '';
                  end;
                end;
              end;
            end;

            // OmegaCorrSE  *********************************************************************
            if nmNode.ChildNodes[n].FindNode(xmlPrefix + 'omegacse') <> nil then
            begin
              lstMatrixOmegaCSE.Clear;
              for m := 0 to nmNode.ChildNodes[n].FindNode(xmlPrefix + 'omegacse').ChildNodes.Count - 1 do
              begin
                strTemp := '';
                for p := 0 to nmNode.ChildNodes[n].FindNode(xmlPrefix + 'omegacse').ChildNodes[m].ChildNodes.Count - 1 do
                begin
                  if p > 0 then
                    strTemp := strTemp + ',' + nmNode.ChildNodes[n].FindNode(xmlPrefix + 'omegacse').ChildNodes[m].ChildNodes[p].TextContent
                  else
                    strTemp := nmNode.ChildNodes[n].FindNode(xmlPrefix + 'omegacse').ChildNodes[m].ChildNodes[p].TextContent;
                  if p = nmNode.ChildNodes[n].FindNode(xmlPrefix + 'omegacse').ChildNodes[m].ChildNodes.Count - 1 then
                  begin
                    lstMatrixOmegaCSE.Add(strTemp);
                    strTemp := '';
                  end;
                end;
              end;
            end;

            // EtaBar  *********************************************************************
            if nmNode.ChildNodes[n].FindNode(xmlPrefix + 'etabar') <> nil then
            begin
              lstEtaBar.Clear;
              for m := 0 to nmNode.ChildNodes[n].FindNode(xmlPrefix + 'etabar').ChildNodes.Count - 1 do
              begin
                for p := 0 to nmNode.ChildNodes[n].FindNode(xmlPrefix + 'etabar').ChildNodes[m].ChildNodes.Count - 1 do
                  if m = 0 then
                    lstEtaBar.Add(FloatToStr(SigFig(StrToFloat(nmNode.ChildNodes[n].FindNode(xmlPrefix + 'etabar').ChildNodes[m].ChildNodes[p].TextContent), 4)))
                  else
                    lstEtaBar[p] := lstEtaBar[p] + ' ; ' + FloatToStr(SigFig(StrToFloat(nmNode.ChildNodes[n].FindNode(xmlPrefix + 'etabar').ChildNodes[m].ChildNodes[p].TextContent), 4));
              end;
            end;

            // EtaBarSE  *********************************************************************
            if nmNode.ChildNodes[n].FindNode(xmlPrefix + 'etabarse') <> nil then
            begin
              lstEtaBarSE.Clear;
              for m := 0 to nmNode.ChildNodes[n].FindNode(xmlPrefix + 'etabarse').ChildNodes.Count - 1 do
              begin
                for p := 0 to nmNode.ChildNodes[n].FindNode(xmlPrefix + 'etabarse').ChildNodes[m].ChildNodes.Count - 1 do
                  if m = 0 then
                    lstEtaBarSE.Add(FloatToStr(SigFig(StrToFloat(nmNode.ChildNodes[n].FindNode(xmlPrefix + 'etabarse').ChildNodes[m].ChildNodes[p].TextContent), 4)))
                  else
                    lstEtaBarSE[p] := lstEtaBarSE[p] + ' ; ' + FloatToStr(SigFig(StrToFloat(nmNode.ChildNodes[n].FindNode(xmlPrefix + 'etabarse').ChildNodes[m].ChildNodes[p].TextContent), 4));
              end;
            end;

            // EtaBarP  *********************************************************************
            if nmNode.ChildNodes[n].FindNode(xmlPrefix + 'etabarpval') <> nil then
            begin
              lstEtaBarP.Clear;
              for m := 0 to nmNode.ChildNodes[n].FindNode(xmlPrefix + 'etabarpval').ChildNodes.Count - 1 do
              begin
                for p := 0 to nmNode.ChildNodes[n].FindNode(xmlPrefix + 'etabarpval').ChildNodes[m].ChildNodes.Count - 1 do
                  if m = 0 then
                    lstEtaBarP.Add(FloatToStr(SigFig(StrToFloat(nmNode.ChildNodes[n].FindNode(xmlPrefix + 'etabarpval').ChildNodes[m].ChildNodes[p].TextContent), 4)))
                  else
                    lstEtaBarP[p] := lstEtaBarP[p] + ' ; ' + FloatToStr(SigFig(StrToFloat(nmNode.ChildNodes[n].FindNode(xmlPrefix + 'etabarpval').ChildNodes[m].ChildNodes[p].TextContent), 4));
              end;
            end;

            // EtaShrinkage  *********************************************************************
            if nmNode.ChildNodes[n].FindNode(xmlPrefix + 'etashrink') <> nil then
            begin
              lstEtaShrinkage.Clear;
              for m := 0 to nmNode.ChildNodes[n].FindNode(xmlPrefix + 'etashrink').ChildNodes.Count - 1 do
              begin
                for p := 0 to nmNode.ChildNodes[n].FindNode(xmlPrefix + 'etashrink').ChildNodes[m].ChildNodes.Count - 1 do
                  if m = 0 then
                    lstEtaShrinkage.Add(FloatToStr(SigFig(StrToFloat(nmNode.ChildNodes[n].FindNode(xmlPrefix + 'etashrink').ChildNodes[m].ChildNodes[p].TextContent), 4)))
                  else
                    lstEtaShrinkage[p] := lstEtaShrinkage[p] + ' ; ' + FloatToStr(SigFig(StrToFloat(nmNode.ChildNodes[n].FindNode(xmlPrefix + 'etashrink').ChildNodes[m].ChildNodes[p].TextContent), 4));
              end;
            end;

            //ShowMessage(lstEtaBar.Text);
            //ShowMessage(lstEtaBarSE.Text);
            //ShowMessage(lstEtaBarP.Text);
            //ShowMessage(lstEtaShrinkage.Text);

            // Sigma  *********************************************************************
            if nmNode.ChildNodes[n].FindNode(xmlPrefix + 'sigma') <> nil then
            begin
              lstEpsilon.Clear;
              lstMatrixSigma.Clear;
              for m := 0 to nmNode.ChildNodes[n].FindNode(xmlPrefix + 'sigma').ChildNodes.Count - 1 do
              begin
                intC := nmNode.ChildNodes[n].FindNode(xmlPrefix + 'sigma').ChildNodes[m].ChildNodes.Count;
                //ShowMessage(IntToStr(nmNode.ChildNodes[n].FindNode(xmlPrefix + 'sigma').ChildNodes[m].ChildNodes.Count));
                //ShowMessage(nmNode.ChildNodes[n].FindNode(xmlPrefix + 'sigma').ChildNodes[m].ChildNodes[intC - 1].TextContent);
                lstEpsilon.Add(nmNode.ChildNodes[n].FindNode(xmlPrefix + 'sigma').ChildNodes[m].ChildNodes[intC - 1].TextContent);
                strTemp := '';
                for p := 0 to nmNode.ChildNodes[n].FindNode(xmlPrefix + 'sigma').ChildNodes[m].ChildNodes.Count - 1 do
                begin
                  if p > 0 then
                    strTemp := strTemp + ',' + nmNode.ChildNodes[n].FindNode(xmlPrefix + 'sigma').ChildNodes[m].ChildNodes[p].TextContent
                  else
                    strTemp := nmNode.ChildNodes[n].FindNode(xmlPrefix + 'sigma').ChildNodes[m].ChildNodes[p].TextContent;
                  if p = nmNode.ChildNodes[n].FindNode(xmlPrefix + 'sigma').ChildNodes[m].ChildNodes.Count - 1 then
                  begin
                    lstMatrixSigma.Add(strTemp);
                    strTemp := '';
                  end;
                end;
              end;
            end;

            // Sigma SE  *********************************************************************
            if nmNode.ChildNodes[n].FindNode(xmlPrefix + 'sigmase') <> nil then
            begin
              lstEpsilonSE.Clear;
              lstMatrixSigmaSE.Clear;
              for m := 0 to nmNode.ChildNodes[n].FindNode(xmlPrefix + 'sigmase').ChildNodes.Count - 1 do
              begin
                intC := nmNode.ChildNodes[n].FindNode(xmlPrefix + 'sigmase').ChildNodes[m].ChildNodes.Count;
                //ShowMessage(IntToStr(nmNode.ChildNodes[n].FindNode(xmlPrefix + 'sigmase').ChildNodes[m].ChildNodes.Count));
                //ShowMessage(nmNode.ChildNodes[n].FindNode(xmlPrefix + 'sigmase').ChildNodes[m].ChildNodes[intC - 1].TextContent);
                lstEpsilonSE.Add(nmNode.ChildNodes[n].FindNode(xmlPrefix + 'sigmase').ChildNodes[m].ChildNodes[intC - 1].TextContent);
                strTemp := '';
                for p := 0 to nmNode.ChildNodes[n].FindNode(xmlPrefix + 'sigmase').ChildNodes[m].ChildNodes.Count - 1 do
                begin
                  if p > 0 then
                    strTemp := strTemp + ',' + nmNode.ChildNodes[n].FindNode(xmlPrefix + 'sigmase').ChildNodes[m].ChildNodes[p].TextContent
                  else
                    strTemp := nmNode.ChildNodes[n].FindNode(xmlPrefix + 'sigmase').ChildNodes[m].ChildNodes[p].TextContent;
                  if p = nmNode.ChildNodes[n].FindNode(xmlPrefix + 'sigmase').ChildNodes[m].ChildNodes.Count - 1 then
                  begin
                    lstMatrixSigmaSE.Add(strTemp);
                    strTemp := '';
                  end;
                end;
              end;
            end;

            // SigmaCorr  *********************************************************************
            if nmNode.ChildNodes[n].FindNode(xmlPrefix + 'sigmac') <> nil then
            begin
              lstMatrixSigmaCorr.Clear;
              for m := 0 to nmNode.ChildNodes[n].FindNode(xmlPrefix + 'sigmac').ChildNodes.Count - 1 do
              begin
                strTemp := '';
                for p := 0 to nmNode.ChildNodes[n].FindNode(xmlPrefix + 'sigmac').ChildNodes[m].ChildNodes.Count - 1 do
                begin
                  if p > 0 then
                    strTemp := strTemp + ',' + nmNode.ChildNodes[n].FindNode(xmlPrefix + 'sigmac').ChildNodes[m].ChildNodes[p].TextContent
                  else
                    strTemp := nmNode.ChildNodes[n].FindNode(xmlPrefix + 'sigmac').ChildNodes[m].ChildNodes[p].TextContent;
                  if p = nmNode.ChildNodes[n].FindNode(xmlPrefix + 'sigmac').ChildNodes[m].ChildNodes.Count - 1 then
                  begin
                    lstMatrixSigmaCorr.Add(strTemp);
                    strTemp := '';
                  end;
                end;
              end;
            end;

            // SigmaCorrSE  *********************************************************************
            if nmNode.ChildNodes[n].FindNode(xmlPrefix + 'sigmacse') <> nil then
            begin
              lstMatrixSigmaCSE.Clear;
              for m := 0 to nmNode.ChildNodes[n].FindNode(xmlPrefix + 'sigmacse').ChildNodes.Count - 1 do
              begin
                strTemp := '';
                for p := 0 to nmNode.ChildNodes[n].FindNode(xmlPrefix + 'sigmacse').ChildNodes[m].ChildNodes.Count - 1 do
                begin
                  if p > 0 then
                    strTemp := strTemp + ',' + nmNode.ChildNodes[n].FindNode(xmlPrefix + 'sigmacse').ChildNodes[m].ChildNodes[p].TextContent
                  else
                    strTemp := nmNode.ChildNodes[n].FindNode(xmlPrefix + 'sigmacse').ChildNodes[m].ChildNodes[p].TextContent;
                  if p = nmNode.ChildNodes[n].FindNode(xmlPrefix + 'sigmacse').ChildNodes[m].ChildNodes.Count - 1 then
                  begin
                    lstMatrixSigmaCSE.Add(strTemp);
                    strTemp := '';
                  end;
                end;
              end;
            end;

            // EpsilonShrinkage  *********************************************************************
            if nmNode.ChildNodes[n].FindNode(xmlPrefix + 'epsshrink') <> nil then
            begin
              lstEpsilonShrinkage.Clear;
              for m := 0 to nmNode.ChildNodes[n].FindNode(xmlPrefix + 'epsshrink').ChildNodes.Count - 1 do
              begin
                for p := 0 to nmNode.ChildNodes[n].FindNode(xmlPrefix + 'epsshrink').ChildNodes[m].ChildNodes.Count - 1 do
                  if m = 0 then
                    lstEpsilonShrinkage.Add(FloatToStr(SigFig(StrToFloat(nmNode.ChildNodes[n].FindNode(xmlPrefix + 'epsshrink').ChildNodes[m].ChildNodes[p].TextContent), 4)))
                  else
                    lstEpsilonShrinkage[p] := lstEpsilonShrinkage[p] + ' ; ' + FloatToStr(SigFig(StrToFloat(nmNode.ChildNodes[n].FindNode(xmlPrefix + 'epsshrink').ChildNodes[m].ChildNodes[p].TextContent), 4));
              end;
            end;

            //ShowMessage(lstMatrixOmegaCorr.Text);
            //ShowMessage(lstMatrixOmegaCSE.Text);
            //ShowMessage(lstMatrixSigmaCorr.Text);
            //ShowMessage(lstMatrixSigmaCSE.Text);

            //ShowMessage(lstThetaInit.Text);
            //ShowMessage(lstTheta.Text);

            // inject into database: THETAs   ///////////////////////////////

            //if n = 0 then
            //  ShowMessage(lstThetaInit.Text);
            for p := 0 to lstTheta.Count - 1 do
            begin
              txtLabel := 'NULL';
              if lstThetaLabel.Count = lstTheta.Count then
                txtLabel := lstThetaLabel[p];
              txtLower := 'NULL';
              if lstThetaLowB.Count = lstTheta.Count then
                txtLower := lstThetaLowB[p];
              txtUpper := 'NULL';
              if lstThetaUppB.Count = lstTheta.Count then
                txtUpper := lstThetaUppB[p];
              txtInit := 'NULL';
              //ShowMessage(lstThetaInit[p]);
              if lstThetaInit.Count = lstTheta.Count then
              begin
                txtInit := StringReplace(StringReplace(lstThetaInit[p], '$THETA', '', [rfReplaceAll]), ' ', '', [rfReplaceAll]);
                if(Pos(';', txtInit) > 1) then
                  txtInit := Copy(txtInit, 1, Pos(';',txtInit)-1)
              end;
              txtSE := 'NULL';
              txtRSE := 'NULL';
              txtUppCI := 'NULL';
              txtLowCI := 'NULL';
              txtCIs := '';
              if lstThetaSE.Count = lstTheta.Count then
              begin
                txtSE := lstThetaSE[p];
                if Pos('10000000000', txtSE) = 0 then
                begin
                  txtRSE := FloatToStr(Abs((StrToFloat(txtSE)/StrToFloat(lstTheta[p])) * 100));
                  txtUppCI := FloatToStr(StrToFloat(lstTheta[p]) + (1.96 * StrToFloat(txtSE)));
                  txtLowCI := FloatToStr(StrToFloat(lstTheta[p]) - (1.96 * StrToFloat(txtSE)));
                  txtCIs := FloatToStr(SigFig(StrToFloat(lstTheta[p]) - (1.96 * StrToFloat(txtSE)), 4)) + ' ; ' +
                    FloatToStr(SigFig(StrToFloat(lstTheta[p]) + (1.96 * StrToFloat(txtSE)), 4));
                end
                else
                  txtSE := 'NULL';
              end;

              if strOS = 'Linux' then
                txtUser := GetEnvironmentVariable('USER');
              if strOS = 'Windows' then
                txtUser := GetEnvironmentVariable('USERNAME');

              //ShowMessage(lstTheta[p]);
              //ShowMessage(txtInit);

              //ShowMessage('Check four');
              qryAdd.SQL.Clear;
              try
                try
                  with qryAdd do
                  begin
                     SQL.Add('insert into thetas (RunNo, EstNo, Theta, ThetaLabel, ThetaValue, ThetaSE, Lower, Initial, Upper, ThetaRSE, ThetaCIs, ThetaCIUpper, ThetaCILower, Timestamp, User)');
                     SQL.Add('values (' +
                           QuotedStr(strRun) + ',' +
                           nmNode.ChildNodes[n].Attributes[1].TextContent + ',' +
                           IntToStr(p + 1) + ',' +
                           QuotedStr(Trim(txtLabel)) + ',' +
                           lstTheta[p] + ',' +
                           txtSE + ',' +
                           txtLower + ',' +
                           txtInit + ',' +
                           txtUpper + ',' +
                           txtRSE + ',' +
                           QuotedStr(txtCIs) + ',' +
                           txtUppCI + ',' +
                           txtLowCI + ',' +
                           IntToStr(Trunc((Now - EncodeDate(1970, 1 ,1)) * 24 * 60 * 60)) + ',' +
                           QuotedStr(txtUser) + ');');
                     //ShowMessage(SQL.Text);
                     //ShowMessage(txtLower);
                     //ShowMessage(txtInit);
                     //ShowMessage(txtUpper);
                     ExecSQL;
                  end;
                except
                  MessageDlg('An error occurred while adding THETA(' + IntToStr(p + 1) + ') to the database.',
                    mtError, [mbOK], 0);
                end;
              finally
                if p = lstTheta.Count - 1 then
                  lstThetaInit.Assign(lstTheta);  // set initial estimates to final estimates from this estimation step
              end;
            end;

            //ShowMessage(qryAdd.SQL.Text);
            // inject into database: OMEGAs   ///////////////////////////////

            //ShowMessage(lstEta.Text);
            //ShowMessage(lstEtaInit.Text);

            strTemp := '0';
            for p := 0 to lstEta.Count - 1 do
            begin
              txtLabel := 'NULL';
              if lstEtaLabel.Count = lstEta.Count then
                txtLabel := lstEtaLabel[p];
              txtEtaPerc := FloatToStr(SigFig(sqrt(StrToFloat(lstEta[p]))*100, 4));
              txtInit := 'NULL';
              if lstEtaInit.Count = lstEta.Count then
              begin
                txtInit := lstEtaInit[p];
                if txtInit = 'SAME' then
                  txtInit := strTemp;
                strTemp := txtInit;
              end;
              txtEtaBar := 'NULL';
              if lstEtaBar.Count = lstEta.Count then
                txtEtaBar := lstEtaBar[p];
              txtEtaBarSE := 'NULL';
              if lstEtaBarSE.Count = lstEta.Count then
                txtEtaBarSE := lstEtaBarSE[p];
              txtEtaPVal := 'NULL';
              if lstEtaBarP.Count = lstEta.Count then
                txtEtaPVal := lstEtaBarP[p];
              txtShrinkage := 'NULL';
              if lstEtaShrinkage.Count = lstEta.Count then
                txtShrinkage := lstEtaShrinkage[p];

              txtSE := 'NULL';
              txtRSE := 'NULL';
              txtUppCI := 'NULL';
              txtLowCI := 'NULL';
              txtCIs := '';
              if lstEtaSE.Count = lstEta.Count then
              begin
                txtSE := lstEtaSE[p];
                if Pos('10000000000', txtSE) = 0 then
                begin
                  txtRSE := FloatToStr(Abs((StrToFloat(txtSE)/StrToFloat(lstEta[p])) * 100));
                  txtUppCI := FloatToStr(StrToFloat(lstEta[p]) + (1.96 * StrToFloat(txtSE)));
                  txtLowCI := FloatToStr(StrToFloat(lstEta[p]) - (1.96 * StrToFloat(txtSE)));
                  txtCIs := FloatToStr(SigFig(StrToFloat(lstEta[p]) - (1.96 * StrToFloat(txtSE)), 4)) + ' ; ' +
                    FloatToStr(SigFig(StrToFloat(lstEta[p]) + (1.96 * StrToFloat(txtSE)), 4));
                end
                else
                  txtSE := 'NULL';
              end;

              if strOS = 'Linux' then
                txtUser := GetEnvironmentVariable('USER');
              if strOS = 'Windows' then
                txtUser := GetEnvironmentVariable('USERNAME');

              //ShowMessage('Check five');
              qryAdd.SQL.Clear;
              try
                try
                  with qryAdd do
                  begin
                     SQL.Add('insert into omegas (RunNo, EstNo, Omega, OmegaLabel, OmegaValue, OmegaSE, OmegaInit, OmegaRSE, OmegaPerc, OmegaCIs, ' +
                       'OmegaCIUpper, OmegaCILower, EtaShrinkage, EtaBar, EtaBarSE, EtaPVal, Timestamp, User)');
                     SQL.Add('values (' +
                           QuotedStr(strRun) + ',' +
                           nmNode.ChildNodes[n].Attributes[1].TextContent + ',' +
                           IntToStr(p + 1) + ',' +
                           QuotedStr(Trim(txtLabel)) + ',' +
                           lstEta[p] + ',' +
                           txtSE + ',' +
                           txtInit + ',' +
                           txtRSE + ',' +
                           txtEtaPerc + ',' +
                           QuotedStr(txtCIs) + ',' +
                           txtUppCI + ',' +
                           txtLowCI + ',' +
                           QuotedStr(txtShrinkage) + ',' +
                           QuotedStr(txtEtaBar) + ',' +
                           QuotedStr(txtEtaBarSE) + ',' +
                           txtEtaPVal + ',' +
                           IntToStr(Trunc((Now - EncodeDate(1970, 1 ,1)) * 24 * 60 * 60)) + ',' +
                           QuotedStr(txtUser) + ');');
                     //ShowMessage(SQL.Text);
                     ExecSQL;
                  end;
                except
                  MessageDlg('An error occurred while adding OMEGA(' + IntToStr(p + 1) + ') to the database.',
                    mtError, [mbOK], 0);
                end;
              finally
                if p = lstEta.Count - 1 then
                  lstEtaInit.Assign(lstEta);  // set initial estimates to final estimates from this estimation step
              end;
            end;

            // inject into database: SIGMAs

            for p := 0 to lstEpsilon.Count - 1 do
            begin

              txtLabel := 'NULL';
              if lstEpsilonLabel.Count = lstEpsilon.Count then
                txtLabel := lstEpsilonLabel[p];
              txtInit := 'NULL';
              if lstEpsilonInit.Count = lstEpsilon.Count then
                txtInit := lstEpsilonInit[p];

              txtShrinkage := 'NULL';
              if lstEpsilonShrinkage.Count = lstEpsilon.Count then
                txtShrinkage := lstEpsilonShrinkage[p];

              txtSE := 'NULL';
              txtRSE := 'NULL';
              txtUppCI := 'NULL';
              txtLowCI := 'NULL';
              txtCIs := '';
              if lstEpsilonSE.Count = lstEpsilon.Count then
              begin
                txtSE := lstEpsilonSE[p];
                if Pos('10000000000', txtSE) = 0 then
                begin
                  txtRSE := FloatToStr(Abs((StrToFloat(txtSE)/StrToFloat(lstEpsilon[p])) * 100));
                  txtUppCI := FloatToStr(StrToFloat(lstEpsilon[p]) + (1.96 * StrToFloat(txtSE)));
                  txtLowCI := FloatToStr(StrToFloat(lstEpsilon[p]) - (1.96 * StrToFloat(txtSE)));
                  txtCIs := FloatToStr(SigFig(StrToFloat(lstEpsilon[p]) - (1.96 * StrToFloat(txtSE)), 4)) + ' ; ' +
                    FloatToStr(SigFig(StrToFloat(lstEpsilon[p]) + (1.96 * StrToFloat(txtSE)), 4));
                end
                else
                  txtSE := 'NULL';
              end;

              if strOS = 'Linux' then
                txtUser := GetEnvironmentVariable('USER');
              if strOS = 'Windows' then
                txtUser := GetEnvironmentVariable('USERNAME');

              //ShowMessage('Check six');
              qryAdd.SQL.Clear;
              try
                try
                  with qryAdd do
                  begin
                     SQL.Add('insert into sigmas (RunNo, EstNo, Sigma, SigmaLabel, SigmaValue, SigmaSE, SigmaInit, SigmaRSE, SigmaCIs, ' +
                       'SigmaCIUpper, SigmaCILower, EpsilonShrinkage, Timestamp, User)');
                     SQL.Add('values (' +
                           QuotedStr(strRun) + ',' +
                           nmNode.ChildNodes[n].Attributes[1].TextContent + ',' +
                           IntToStr(p + 1) + ',' +
                           QuotedStr(Trim(txtLabel)) + ',' +
                           lstEpsilon[p] + ',' +
                           txtSE + ',' +
                           txtInit + ',' +
                           txtRSE + ',' +
                           QuotedStr(txtCIs) + ',' +
                           txtUppCI + ',' +
                           txtLowCI + ',' +
                           QuotedStr(txtShrinkage) + ',' +
                           IntToStr(Trunc((Now - EncodeDate(1970, 1 ,1)) * 24 * 60 * 60)) + ',' +
                           QuotedStr(txtUser) + ');');
                     ExecSQL;
                  end;
                except
                  MessageDlg('An error occurred while adding SIGMA(' + IntToStr(p + 1) + ') to the database.',
                    mtError, [mbOK], 0);
                end;
              finally
                if p = lstEpsilon.Count - 1 then
                  lstEpsilonInit.Assign(lstEpsilon);  // set initial estimates to final estimates from this estimation step
              end;
            end;

            // last bits

            if nmNode.ChildNodes[n].FindNode(xmlPrefix + 'termination_information') <> nil then
              lstTermInfo.Assign(LineBreaks(nmNode.ChildNodes[n].FindNode(xmlPrefix + 'termination_information').TextContent));

            if nmNode.ChildNodes[n].FindNode(xmlPrefix + 'estimation_title') <> nil then
              lstTermInfoOverall.Add(nmNode.ChildNodes[n].FindNode(xmlPrefix + 'estimation_title').TextContent);
            lstTermInfoOverall.Add('----');
            for p := 0 to lstTermInfo.Count - 1 do
              lstTermInfoOverall.Add(lstTermInfo[p]);
            lstTermInfoOverall.Add(' ');

            if Pos('MINIMIZATION SUCCESSFUL', lstTermInfo.Text) > 0 then
              strMin := 'Successful';
            if Pos('MINIMIZATION TERMINATED', lstTermInfo.Text) > 0 then
            begin
              strMin := 'Terminated';
              if Length(txtWarnings) > 0 then
                txtWarnings := txtWarnings + '; ';
              txtWarnings := txtWarnings + 'Minimization terminated';
            end;
            if Pos('COMPLETED', lstTermInfo.Text) > 0 then
              strMin := 'Completed';
             if Pos('NOT COMPLETED', lstTermInfo.Text) > 0 then
             begin
               strMin := 'Not Completed';
               if Length(txtWarnings) > 0 then
                 txtWarnings := txtWarnings + '; ';
               txtWarnings := txtWarnings + 'Minimization not completed';
             end;

            lstLog.Add('Minimization... ' + strMin);

             if Pos('HOWEVER, PROBLEMS OCCURRED WITH THE MINIMIZATION', lstTermInfo.Text) > 0 then
             begin
               if Length(txtWarnings) > 0 then
                 txtWarnings := txtWarnings + '; ';
               txtWarnings := txtWarnings + 'Minimization problems';
             end;

            if Pos('ROUNDING ERRORS', lstTermInfo.Text) > 0 then
            begin
              if Length(txtWarnings) > 0 then
                txtWarnings := txtWarnings + '; ';
              txtWarnings := txtWarnings + 'Rounding errors';
            end;

            if Pos('R MATRIX ALGORITHMICALLY SINGULAR', lstTermInfo.Text) > 0 then
            begin
              if Length(txtWarnings) > 0 then
                txtWarnings := txtWarnings + '; ';
              txtWarnings := txtWarnings + 'R matrix algorithmically singular';
            end;

            if Pos('S MATRIX ALGORITHMICALLY SINGULAR', lstTermInfo.Text) > 0 then
            begin
              if Length(txtWarnings) > 0 then
                txtWarnings := txtWarnings + '; ';
              txtWarnings := txtWarnings + 'S matrix algorithmically singular';
            end;

            // ********************************************************************
            // Variance-covariance matrix
            // ********************************************************************

            if nmNode.ChildNodes[n].FindNode(xmlPrefix + 'covariance') <> nil then
            begin
              lstCovMatrix.Clear;
              strTemp := '';
              lstTemp.Clear;

              // column names
              for m := 0 to nmNode.ChildNodes[n].FindNode(xmlPrefix + 'covariance').ChildNodes.Count - 1 do
              begin
                strTemp := strTemp + ';' + nmNode.ChildNodes[n].FindNode(xmlPrefix + 'covariance').ChildNodes[m].Attributes[0].TextContent;
                lstTemp.Add(nmNode.ChildNodes[n].FindNode(xmlPrefix + 'covariance').ChildNodes[m].Attributes[0].TextContent);
              end;
              lstCovMatrix.Add(strTemp);

              for m := 0 to nmNode.ChildNodes[n].FindNode(xmlPrefix + 'covariance').ChildNodes.Count - 1 do
              begin
                // row names and values
                strTemp := lstTemp[m];
                for p := 0 to nmNode.ChildNodes[n].FindNode(xmlPrefix + 'covariance').ChildNodes[m].ChildNodes.Count - 1 do
                begin
                  strTemp := strTemp + ';' + nmNode.ChildNodes[n].FindNode(xmlPrefix + 'covariance').ChildNodes[m].ChildNodes[p].TextContent;
                  if p = nmNode.ChildNodes[n].FindNode(xmlPrefix + 'covariance').ChildNodes[m].ChildNodes.Count - 1 then
                  begin
                    lstCovMatrix.Add(strTemp);
                    strTemp := '';
                  end;
                end;
              end;
            end;

            //ShowMessage(lstTemp.Text);
            //ShowMessage(lstCovMatrix.Text);

            // ********************************************************************
            // Inverse covariance matrix
            // ********************************************************************

            if nmNode.ChildNodes[n].FindNode(xmlPrefix + 'invcovariance') <> nil then
            begin
              lstCoiMatrix.Clear;
              strTemp := '';
              lstTemp.Clear;

              // column names
              for m := 0 to nmNode.ChildNodes[n].FindNode(xmlPrefix + 'invcovariance').ChildNodes.Count - 1 do
              begin
                strTemp := strTemp + ';' + nmNode.ChildNodes[n].FindNode(xmlPrefix + 'invcovariance').ChildNodes[m].Attributes[0].TextContent;
                lstTemp.Add(nmNode.ChildNodes[n].FindNode(xmlPrefix + 'invcovariance').ChildNodes[m].Attributes[0].TextContent);
              end;
              lstCoiMatrix.Add(strTemp);

              for m := 0 to nmNode.ChildNodes[n].FindNode(xmlPrefix + 'invcovariance').ChildNodes.Count - 1 do
              begin
                // row names and values
                strTemp := lstTemp[m];
                for p := 0 to nmNode.ChildNodes[n].FindNode(xmlPrefix + 'invcovariance').ChildNodes[m].ChildNodes.Count - 1 do
                begin
                  strTemp := strTemp + ';' + nmNode.ChildNodes[n].FindNode(xmlPrefix + 'invcovariance').ChildNodes[m].ChildNodes[p].TextContent;
                  if p = nmNode.ChildNodes[n].FindNode(xmlPrefix + 'invcovariance').ChildNodes[m].ChildNodes.Count - 1 then
                  begin
                    lstCoiMatrix.Add(strTemp);
                    strTemp := '';
                  end;
                end;
              end;
            end;

            // ********************************************************************
            // Correlation matrix
            // ********************************************************************

            if nmNode.ChildNodes[n].FindNode(xmlPrefix + 'correlation') <> nil then
            begin
              lstCorMatrix.Clear;
              strTemp := '';
              lstTemp.Clear;

              // column names
              for m := 0 to nmNode.ChildNodes[n].FindNode(xmlPrefix + 'correlation').ChildNodes.Count - 1 do
              begin
                strTemp := strTemp + ';' + nmNode.ChildNodes[n].FindNode(xmlPrefix + 'correlation').ChildNodes[m].Attributes[0].TextContent;
                lstTemp.Add(nmNode.ChildNodes[n].FindNode(xmlPrefix + 'correlation').ChildNodes[m].Attributes[0].TextContent);
              end;
              lstCorMatrix.Add(strTemp);

              for m := 0 to nmNode.ChildNodes[n].FindNode(xmlPrefix + 'correlation').ChildNodes.Count - 1 do
              begin
                // row names and values
                strTemp := lstTemp[m];
                for p := 0 to nmNode.ChildNodes[n].FindNode(xmlPrefix + 'correlation').ChildNodes[m].ChildNodes.Count - 1 do
                begin
                  strTemp := strTemp + ';' + nmNode.ChildNodes[n].FindNode(xmlPrefix + 'correlation').ChildNodes[m].ChildNodes[p].TextContent;
                  if p = nmNode.ChildNodes[n].FindNode(xmlPrefix + 'correlation').ChildNodes[m].ChildNodes.Count - 1 then
                  begin
                    lstCorMatrix.Add(strTemp);
                    strTemp := '';
                  end;
                end;
              end;
            end;

            // ********************************************************************
            // Eigenvalues and condition number
            // ********************************************************************

            if nmNode.ChildNodes[n].FindNode(xmlPrefix + 'eigenvalues') <> nil then
            begin
              lstEigenvalues.Clear;
              strTemp := '';
              lstTemp.Clear;

              for m := 0 to nmNode.ChildNodes[n].FindNode(xmlPrefix + 'eigenvalues').ChildNodes.Count - 1 do
                lstEigenvalues.Add(nmNode.ChildNodes[n].FindNode(xmlPrefix + 'eigenvalues').ChildNodes[m].TextContent);

              fltEigenUpper := 0.00000000001;
              fltEigenLower := 100000000000;
              fltCondNo := 0;

              if lstEigenvalues.Count > 0 then
              begin
                for m := 0 to lstEigenvalues.Count - 1 do
                begin
                  if (StrToFloat(lstEigenvalues[m]) > fltEigenUpper) then
                    fltEigenUpper := StrToFloat(lstEigenvalues[m]);
                  if (StrToFloat(lstEigenvalues[m]) < fltEigenLower) then
                    fltEigenLower := StrToFloat(lstEigenvalues[m]);
                end;
                fltCondNo := Abs(fltEigenUpper / fltEigenLower);
              end;

            end
            else
              fltCondNo := 0;

            // load into Est table

            // build SQL string
            lstEst := TStringList.Create;
            lstEst.Add('insert into est (RunNo, EstNo, Method, MethLong, OFV, Minimization, Covariance, EstElapsedTime, CovElapsedTime,' +
                   'OmegaInitMatrix, SigmaInitMatrix, OmegaMatrix, SigmaMatrix, OmegaSEMatrix, SigmaSEMatrix, OmegaCorrMatrix, SigmaCorrMatrix, ' +
                   'OmegaCSEMatrix, SigmaCSEMatrix, CovMatrix, CorrMatrix, InvCovMatrix, Eigenvalues, ConditionNumber, FnEvals, SigDigits, ' +
                   'MinShort, Timestamp, User)');
            lstEst.Add('values (''' + strRun + ''',');                                               // RunNo
            lstEst.Add(nmNode.ChildNodes[n].Attributes[1].TextContent + ',');              // EstNo

            // each field needs to be checked, since it may not exist

            if nmNode.ChildNodes[n].FindNode(xmlPrefix + 'estimation_method') <> nil then
              lstEst.Add(QuotedStr(nmNode.ChildNodes[n].FindNode(xmlPrefix + 'estimation_method').TextContent) + ',')
            else
              lstEst.Add('NULL,');

            if nmNode.ChildNodes[n].FindNode(xmlPrefix + 'estimation_title') <> nil then
              lstEst.Add(QuotedStr(nmNode.ChildNodes[n].FindNode(xmlPrefix + 'estimation_title').TextContent) + ',')
            else
              lstEst.Add('NULL,');

            if nmNode.ChildNodes[n].FindNode(xmlPrefix + 'final_objective_function') <> nil then
              lstEst.Add(nmNode.ChildNodes[n].FindNode(xmlPrefix + 'final_objective_function').TextContent + ',')
            else
              lstEst.Add('NULL,');

            if nmNode.ChildNodes[n].FindNode(xmlPrefix + 'termination_information') <> nil then
              lstEst.Add(QuotedStr(nmNode.ChildNodes[n].FindNode(xmlPrefix + 'termination_information').TextContent) + ',')
            else
              lstEst.Add('NULL,');

            if nmNode.ChildNodes[n].FindNode(xmlPrefix + 'covariance_information') <> nil then
              lstEst.Add(QuotedStr(nmNode.ChildNodes[n].FindNode(xmlPrefix + 'covariance_information').TextContent) + ',')
            else
              lstEst.Add('NULL,');

            if nmNode.ChildNodes[n].FindNode(xmlPrefix + 'estimation_elapsed_time') <> nil then
            begin
              lstEst.Add(nmNode.ChildNodes[n].FindNode(xmlPrefix + 'estimation_elapsed_time').TextContent + ',');
              fltEstTime := fltEstTime + StrToFloat(nmNode.ChildNodes[n].FindNode(xmlPrefix + 'estimation_elapsed_time').TextContent)
            end
            else
              lstEst.Add('NULL,');

            if nmNode.ChildNodes[n].FindNode(xmlPrefix + 'covariance_elapsed_time') <> nil then
            begin
              lstEst.Add(nmNode.ChildNodes[n].FindNode(xmlPrefix + 'covariance_elapsed_time').TextContent + ',');
              fltCovTime := fltCovTime + StrToFloat(nmNode.ChildNodes[n].FindNode(xmlPrefix + 'covariance_elapsed_time').TextContent)
            end
            else
              lstEst.Add('NULL,');

            lstEst.Add(QuotedStr(lstMatrixOmegaInit.Text) + ',');
            lstEst.Add(QuotedStr(lstMatrixSigmaInit.Text) + ',');
            lstEst.Add(QuotedStr(lstMatrixOmega.Text) + ',');
            lstEst.Add(QuotedStr(lstMatrixSigma.Text) + ',');
            lstEst.Add(QuotedStr(lstMatrixOmegaSE.Text) + ',');
            lstEst.Add(QuotedStr(lstMatrixSigmaSE.Text) + ',');
            lstEst.Add(QuotedStr(lstMatrixOmegaCorr.Text) + ',');
            lstEst.Add(QuotedStr(lstMatrixSigmaCorr.Text) + ',');
            lstEst.Add(QuotedStr(lstMatrixOmegaCSE.Text) + ',');
            lstEst.Add(QuotedStr(lstMatrixSigmaCSE.Text) + ',');
            lstEst.Add(QuotedStr(lstCovMatrix.Text) + ',');
            lstEst.Add(QuotedStr(lstCorMatrix.Text) + ',');
            lstEst.Add(QuotedStr(lstCoiMatrix.Text) + ',');
            lstEst.Add(QuotedStr(lstEigenvalues.Text) + ',');
            lstEst.Add(FloatToStr(fltCondNo) + ',');

            intFnEvals := 0;
            strSigDigits := '';
            for p := 0 to lstTermInfo.Count - 1 do
            begin
              if Pos('NO. OF FUNCTION EVALUATIONS USED:', lstTermInfo[p]) > 0 then
              begin
                brkUpp.BaseString := lstTermInfo[p];
                brkUpp.BreakString := ':';
                brkUpp.AllowEmptyString := False;
                brkUpp.BreakApart;
                intFnEvals := StrToInt(brkUpp.StringList[1]);
              end;
              if Pos('NO. OF SIG. DIGITS IN FINAL EST.:', lstTermInfo[p]) > 0 then
              begin
                brkUpp.BaseString := lstTermInfo[p];
                brkUpp.BreakString := ':';
                brkUpp.AllowEmptyString := False;
                brkUpp.BreakApart;
                strSigDigits := brkUpp.StringList[1];
              end;
            end;

            lstEst.Add(IntToStr(intFnEvals) + ',');
            lstEst.Add(QuotedStr(strSigDigits) + ',');
            lstEst.Add(QuotedStr(strMin) + ',');

            if strOS = 'Linux' then
              txtUser := GetEnvironmentVariable('USER');
            if strOS = 'Windows' then
              txtUser := GetEnvironmentVariable('USERNAME');

            lstEst.Add(IntToStr(Trunc((Now - EncodeDate(1970, 1 ,1)) * 24 * 60 * 60)) + ',');
            lstEst.Add(QuotedStr(txtUser) + ');');

            //ShowMessage('Check seven');
            qryAdd.SQL.Clear;
            try
              try
                with qryAdd do
                begin
                   SQL.Assign(lstEst);
                   ExecSQL;
                end;
              except
                MessageDlg('An error occurred while adding estimation step ' + nmNode.ChildNodes[n].Attributes[1].TextContent +
                  ' to the database.', mtError, [mbOK], 0);
              end;
            finally
              ;
            end;
          end;

        end;
      end;

       //ShowMessage('Check two');
        //Showmessage(lstPsnRunRec.Text);
        //ShowMessage('lstPsNRunRec - ' + IntToStr(lstList.Count));
        for n := 0 to lstPsNRunRec.Count - 1 do
        begin

          // 1 based on

          if (Pos('1. Based on:', lstPsnRunRec[n]) > 0) then
          begin
            brkUpp.AllowEmptyString := False;
            brkUpp.BaseString := StringReplace(lstPsnRunRec[n], ';', '', [rfReplaceAll]);
            brkUpp.BreakString := 'Based on:';
            brkUpp.BreakApart;
            PsNRunRec.BasedOn := brkUpp.StringList[brkUpp.StringList.Count - 1];
          end;

          // 2 description
          if (Pos('2. Description:', lstPsnRunRec[n]) > 0) then
          begin
            blnFlag := True;
            for m := n + 1 to lstPsNRunRec.Count -1 do
            begin
              if (Pos('3. Label:', lstPsnRunRec[m]) > 0) then
                blnFlag := False;
              if blnFlag then
                PsnRunRec.Description := PsnRunRec.Description + ' ' + StringReplace(lstPsnRunRec[m], ';', '', [rfReplaceAll]);
            end;
          end;

          // 3 label
          if (Pos('3. Label:', lstPsnRunRec[n]) > 0) then
          begin
            blnFlag := True;
            for m := n + 1 to lstPsNRunRec.Count -1 do
            begin
              if (Pos('4. Structural model:', lstPsnRunRec[m]) > 0) then
                blnFlag := False;
              if blnFlag then
                PsnRunRec.PsNLabel := PsnRunRec.PsNLabel + ' ' + StringReplace(lstPsnRunRec[m], ';', '', [rfReplaceAll]);
            end;
          end;

          // 4 structural model
          if (Pos('4. Structural model:', lstPsnRunRec[n]) > 0) then
          begin
            blnFlag := True;
            for m := n + 1 to lstPsNRunRec.Count -1 do
            begin
              if (Pos('5. Covariate model:', lstPsnRunRec[m]) > 0) then
                blnFlag := False;
              if blnFlag then
                PsnRunRec.StructuralModel := PsnRunRec.StructuralModel + ' ' + StringReplace(lstPsnRunRec[m], ';', '', [rfReplaceAll]);
            end;
          end;

          // 5 covariate model
          if (Pos('5. Covariate model:', lstPsnRunRec[n]) > 0) then
          begin
            blnFlag := True;
            for m := n + 1 to lstPsNRunRec.Count -1 do
            begin
              if (Pos('6. Inter-individual variability:', lstPsnRunRec[m]) > 0) then
                blnFlag := False;
              if blnFlag then
                PsnRunRec.CovariateModel := PsnRunRec.CovariateModel + ' ' + StringReplace(lstPsnRunRec[m], ';', '', [rfReplaceAll]);
            end;
          end;

          // 6 inter-individual variability
          if (Pos('6. Inter-individual variability:', lstPsnRunRec[n]) > 0) then
          begin
            blnFlag := True;
            for m := n + 1 to lstPsNRunRec.Count -1 do
            begin
              if (Pos('7. Inter-occasion variability:', lstPsnRunRec[m]) > 0) then
                blnFlag := False;
              if blnFlag then
                PsnRunRec.InterIndividualVariability := PsnRunRec.InterIndividualVariability + ' ' + StringReplace(lstPsnRunRec[m], ';', '', [rfReplaceAll]);
            end;
          end;

          // 7 inter-occasion variability
          if (Pos('7. Inter-occasion variability:', lstPsnRunRec[n]) > 0) then
          begin
            blnFlag := True;
            for m := n + 1 to lstPsNRunRec.Count -1 do
            begin
              if (Pos('8. Residual variability:', lstPsnRunRec[m]) > 0) then
                blnFlag := False;
              if blnFlag then
                PsnRunRec.InterOccasionVariability := PsnRunRec.InterOccasionVariability + ' ' + StringReplace(lstPsnRunRec[m], ';', '', [rfReplaceAll]);
            end;
          end;

          // 8 residual variability
          if (Pos('8. Residual variability:', lstPsnRunRec[n]) > 0) then
          begin
            blnFlag := True;
            for m := n + 1 to lstPsNRunRec.Count -1 do
            begin
              if (Pos('9. Estimation:', lstPsnRunRec[m]) > 0) then
                blnFlag := False;
              if blnFlag then
                PsnRunRec.ResidualVariability := PsnRunRec.ResidualVariability + ' ' + StringReplace(lstPsnRunRec[m], ';', '', [rfReplaceAll]);
            end;
          end;

          // 9 estimation
          if (Pos('9. Estimation:', lstPsnRunRec[n]) > 0) then
          begin
            blnFlag := True;
            if n < lstPsNRunRec.Count - 1 then
              for m := n + 1 to lstPsNRunRec.Count -1 do
              begin
                if blnFlag then
                  PsnRunRec.Estimation := PsnRunRec.Estimation + ' ' + StringReplace(lstPsnRunRec[m], ';', '', [rfReplaceAll]);
            end;
          end;

        end;

        PsNRunRec.BasedOn := Trim(PsNRunRec.BasedOn);
        PsNRunRec.Description := Trim(PsNRunRec.Description);
        PsNRunRec.PsNLabel := Trim(PsNRunRec.PsNLabel);
        PsNRunRec.StructuralModel := Trim(PsNRunRec.StructuralModel);
        PsNRunRec.CovariateModel := Trim(PsNRunRec.CovariateModel);
        PsNRunRec.InterIndividualVariability := Trim(PsNRunRec.InterIndividualVariability);
        PsNRunRec.InterOccasionVariability := Trim(PsNRunRec.InterOccasionVariability);
        PsNRunRec.ResidualVariability := Trim(PsNRunRec.ResidualVariability);
        PsNRunRec.Estimation := Trim(PsNRunRec.Estimation);

        {ShowMessage(PsNRunRec.BasedOn);
        ShowMessage(PsNRunRec.Description);
        ShowMessage(PsNRunRec.PsNLabel);
        ShowMessage(PsNRunRec.StructuralModel);
        ShowMessage(PsNRunRec.CovariateModel);
        ShowMessage(PsNRunRec.InterIndividualVariability);
        ShowMessage(PsNRunRec.InterOccasionVariability);
        ShowMessage(PsNRunRec.ResidualVariability);
        ShowMessage(PsNRunRec.Estimation);   }

        // final bits of info

        // add data to runs table

        lstEst.Clear;
        qryAdd.SQL.Clear;

        // build SQL string

        lstEst.Add('insert into runs (RunNo, iRunNo, Comment, ObsRecs, Individuals, Minimization, CtlFile, CtlFileMD5,' +
          'OutputFile, OutputFileMD5, DataFile, DataFileMD5, MSF, MSFMD5, XML, XMLMD5, FitFile, FitFileMD5,' +
          'txt, txtMD5, ext, extMD5, cov, covMD5, cor, corMD5, coi, coiMD5, phi, phiMD5, phm, phmMD5, shk, shkMD5,' +
          'grd, grdMD5, cnv, cnvMD5, smt, smtMD5, rmt, rmtMD5, patab, patabMD5, sdtab, sdtabMD5, catab, catabMD5,' +
          'cotab, cotabMD5, mutab, mutabMD5, mytab, mytabMD5, cwtab, cwtabMD5, cwtabEst, cwtabEstMD5, cwtabDeriv,' +
          'cwtabDerivMD5, OFV, dOFV, Label, ParentNo, Description, Data, StructuralModel, CovariateModel, IIV, IOV, RV, Estimation,' +
          'NMTran, ControlStream, ProblemInfo, EstTime, CovTime, Minimization, ConditionNumber, MinShort, SigDigits, StartTime, StopTime,' +
          'Warnings, Timestamp, User)');

        lstEst.Add('values (''' + strRun + ''',');                                               // RunNo
        lstEst.Add(IntToStr(intRun) + ',');

        if Length(PsNRunRec.Description) > 0 then
          lstEst.Add(QuotedStr(PsNRunRec.Description) + ',')
        else
          lstEst.Add(QuotedStr(strComment) + ',') ;

        lstEst.Add(strObsRecs + ',');
        lstEst.Add(strInds + ',');
        lstEst.Add(QuotedStr(lstTermInfoOverall.Text) + ',');

        //ShowMessage(lstEst.Text);
        // CtlFile
        if FileExists(ChangeFileExt(nmFile, cenOpts.CtlSuffix)) then
        begin
          lstEst.Add(QuotedStr(ChangeFileExt(nmFile, cenOpts.CtlSuffix)) + ',');
          if cenOpts.UseMD5 then
            lstEst.Add(QuotedStr(LowerCase(MDPrint(MDFile(ChangeFileExt(nmFile, cenOpts.CtlSuffix), MD_VERSION_5, 1024)))) + ',')
          else
            lstEst.Add('NULL,');
        end
        else
          lstEst.Add('NULL,NULL,');

        // LstFile
        if FileExists(ChangeFileExt(nmFile, cenOpts.LstSuffix)) then
        begin
          lstEst.Add(QuotedStr(ChangeFileExt(nmFile, cenOpts.LstSuffix)) + ',');
          if cenOpts.UseMD5 then
            lstEst.Add(QuotedStr(LowerCase(MDPrint(MDFile(ChangeFileExt(nmFile, cenOpts.LstSuffix), MD_VERSION_5, 1024)))) + ',')
          else
            lstEst.Add('NULL,');
        end
        else
          lstEst.Add('NULL,NULL,');

        // DataFile
        if FileExists(strDataFile) then
        begin
          lstEst.Add(QuotedStr(strDataFile) + ',');
          if cenOpts.UseMD5 then
            lstEst.Add(QuotedStr(LowerCase(MDPrint(MDFile(strDataFile, MD_VERSION_5, 1024)))) + ',')
          else
            lstEst.Add('NULL,');
        end
        else
          lstEst.Add('NULL,NULL,');

        // MSF
        if FileExists(ChangeFileExt(nmFile, cenOpts.MsfSuffix)) then
        begin
          lstEst.Add(QuotedStr(ChangeFileExt(nmFile, cenOpts.MsfSuffix)) + ',');
          if cenOpts.UseMD5 then
            lstEst.Add(QuotedStr(LowerCase(MDPrint(MDFile(ChangeFileExt(nmFile, cenOpts.MsfSuffix), MD_VERSION_5, 1024)))) + ',')
          else
            lstEst.Add('NULL,');
        end
        else
          lstEst.Add('NULL,NULL,');

        // XML
        if FileExists(nmFile) then
        begin
          lstEst.Add(QuotedStr(nmFile) + ',');
          if cenOpts.UseMD5 then
            lstEst.Add(QuotedStr(LowerCase(MDPrint(MDFile(nmFile, MD_VERSION_5, 1024)))) + ',')
          else
            lstEst.Add('NULL,');
        end
        else
          lstEst.Add('NULL,NULL,');

        // Fit
        if FileExists(ChangeFileExt(nmFile, '.fit')) then
        begin
          lstEst.Add(QuotedStr(ChangeFileExt(nmFile, '.fit')) + ',');
          if cenOpts.UseMD5 then
            lstEst.Add(QuotedStr(LowerCase(MDPrint(MDFile(ChangeFileExt(nmFile, '.fit'), MD_VERSION_5, 1024)))) + ',')
          else
            lstEst.Add('NULL,');
        end
        else
          lstEst.Add('NULL,NULL,');

        // txt
        if FileExists(ChangeFileExt(nmFile, '.txt')) then
        begin
          lstEst.Add(QuotedStr(ChangeFileExt(nmFile, '.txt')) + ',');
          if cenOpts.UseMD5 then
            lstEst.Add(QuotedStr(LowerCase(MDPrint(MDFile(ChangeFileExt(nmFile, '.txt'), MD_VERSION_5, 1024)))) + ',')
          else
            lstEst.Add('NULL,');
        end
        else
          lstEst.Add('NULL,NULL,');

        // ext
        if FileExists(ChangeFileExt(nmFile, '.ext')) then
        begin
          lstEst.Add(QuotedStr(ChangeFileExt(nmFile, '.ext')) + ',');
          if cenOpts.UseMD5 then
            lstEst.Add(QuotedStr(LowerCase(MDPrint(MDFile(ChangeFileExt(nmFile, '.ext'), MD_VERSION_5, 1024)))) + ',')
          else
            lstEst.Add('NULL,');
        end
        else
          lstEst.Add('NULL,NULL,');

        // cov
        if FileExists(ChangeFileExt(nmFile, '.cov')) then
        begin
          lstEst.Add(QuotedStr(ChangeFileExt(nmFile, '.cov')) + ',');
          if cenOpts.UseMD5 then
            lstEst.Add(QuotedStr(LowerCase(MDPrint(MDFile(ChangeFileExt(nmFile, '.cov'), MD_VERSION_5, 1024)))) + ',')
          else
            lstEst.Add('NULL,');
        end
        else
          lstEst.Add('NULL,NULL,');

        // cor
        if FileExists(ChangeFileExt(nmFile, '.cor')) then
        begin
          lstEst.Add(QuotedStr(ChangeFileExt(nmFile, '.cor')) + ',');
          if cenOpts.UseMD5 then
            lstEst.Add(QuotedStr(LowerCase(MDPrint(MDFile(ChangeFileExt(nmFile, '.cor'), MD_VERSION_5, 1024)))) + ',')
          else
            lstEst.Add('NULL,');
        end
        else
          lstEst.Add('NULL,NULL,');

        // coi
        if FileExists(ChangeFileExt(nmFile, '.coi')) then
        begin
          lstEst.Add(QuotedStr(ChangeFileExt(nmFile, '.coi')) + ',');
          if cenOpts.UseMD5 then
            lstEst.Add(QuotedStr(LowerCase(MDPrint(MDFile(ChangeFileExt(nmFile, '.coi'), MD_VERSION_5, 1024)))) + ',')
          else
            lstEst.Add('NULL,');
        end
        else
          lstEst.Add('NULL,NULL,');

        // phi
        if FileExists(ChangeFileExt(nmFile, '.phi')) then
        begin
          lstEst.Add(QuotedStr(ChangeFileExt(nmFile, '.phi')) + ',');
          if cenOpts.UseMD5 then
            lstEst.Add(QuotedStr(LowerCase(MDPrint(MDFile(ChangeFileExt(nmFile, '.phi'), MD_VERSION_5, 1024)))) + ',')
          else
            lstEst.Add('NULL,');
        end
        else
          lstEst.Add('NULL,NULL,');

        // phm
        if FileExists(ChangeFileExt(nmFile, '.phm')) then
        begin
          lstEst.Add(QuotedStr(ChangeFileExt(nmFile, '.phm')) + ',');
          if cenOpts.UseMD5 then
            lstEst.Add(QuotedStr(LowerCase(MDPrint(MDFile(ChangeFileExt(nmFile, '.phm'), MD_VERSION_5, 1024)))) + ',')
          else
            lstEst.Add('NULL,');
        end
        else
          lstEst.Add('NULL,NULL,');

        // shk
        if FileExists(ChangeFileExt(nmFile, '.shk')) then
        begin
          lstEst.Add(QuotedStr(ChangeFileExt(nmFile, '.shk')) + ',');
          if cenOpts.UseMD5 then
            lstEst.Add(QuotedStr(LowerCase(MDPrint(MDFile(ChangeFileExt(nmFile, '.shk'), MD_VERSION_5, 1024)))) + ',')
          else
            lstEst.Add('NULL,');
        end
        else
          lstEst.Add('NULL,NULL,');

        // grd
        if FileExists(ChangeFileExt(nmFile, '.grd')) then
        begin
          lstEst.Add(QuotedStr(ChangeFileExt(nmFile, '.grd')) + ',');
          if cenOpts.UseMD5 then
            lstEst.Add(QuotedStr(LowerCase(MDPrint(MDFile(ChangeFileExt(nmFile, '.grd'), MD_VERSION_5, 1024)))) + ',')
          else
            lstEst.Add('NULL,');
        end
        else
          lstEst.Add('NULL,NULL,');

        // cnv
        if FileExists(ChangeFileExt(nmFile, '.cnv')) then
        begin
          lstEst.Add(QuotedStr(ChangeFileExt(nmFile, '.cnv')) + ',');
          if cenOpts.UseMD5 then
            lstEst.Add(QuotedStr(LowerCase(MDPrint(MDFile(ChangeFileExt(nmFile, '.cnv'), MD_VERSION_5, 1024)))) + ',')
          else
            lstEst.Add('NULL,');
        end
        else
          lstEst.Add('NULL,NULL,');

        // smt
        if FileExists(ChangeFileExt(nmFile, '.smt')) then
        begin
          lstEst.Add(QuotedStr(ChangeFileExt(nmFile, '.smt')) + ',');
          if cenOpts.UseMD5 then
            lstEst.Add(QuotedStr(LowerCase(MDPrint(MDFile(ChangeFileExt(nmFile, '.smt'), MD_VERSION_5, 1024)))) + ',')
          else
            lstEst.Add('NULL,');
        end
        else
          lstEst.Add('NULL,NULL,');

        // rmt
        if FileExists(ChangeFileExt(nmFile, '.rmt')) then
        begin
          lstEst.Add(QuotedStr(ChangeFileExt(nmFile, '.rmt')) + ',');
          if cenOpts.UseMD5 then
            lstEst.Add(QuotedStr(LowerCase(MDPrint(MDFile(ChangeFileExt(nmFile, '.rmt'), MD_VERSION_5, 1024)))) + ',')
          else
            lstEst.Add('NULL,');
        end
        else
          lstEst.Add('NULL,NULL,');

        // patab
        if FileExists(ExtractFilePath(nmFile) + 'patab' + strRun + cenOpts.TabSuffix) then
        begin
          lstEst.Add(QuotedStr(ExtractFilePath(nmFile) + 'patab' + strRun + cenOpts.TabSuffix) + ',');
          if cenOpts.UseMD5 then
            lstEst.Add(QuotedStr(LowerCase(MDPrint(MDFile(ExtractFilePath(nmFile) + 'patab' + strRun + cenOpts.TabSuffix, MD_VERSION_5, 1024)))) + ',')
          else
            lstEst.Add('NULL,');
        end
        else
          lstEst.Add('NULL,NULL,');

        //ShowMessage('Checking ' + ExtractFilePath(nmFile) + 'sdtab' + strRun + cenOpts.TabSuffix);
        // sdtab
        if FileExists(ExtractFilePath(nmFile) + 'sdtab' + strRun + cenOpts.TabSuffix) then
        begin
          //ShowMessage('sdtab found');
          lstEst.Add(QuotedStr(ExtractFilePath(nmFile) + 'sdtab' + strRun + cenOpts.TabSuffix) + ',');
          if cenOpts.UseMD5 then
            lstEst.Add(QuotedStr(LowerCase(MDPrint(MDFile(ExtractFilePath(nmFile) + 'sdtab' + strRun + cenOpts.TabSuffix, MD_VERSION_5, 1024)))) + ',')
          else
            lstEst.Add('NULL,');
        end
        else
          lstEst.Add('NULL,NULL,');

        // catab
        if FileExists(ExtractFilePath(nmFile) + 'catab' + strRun + cenOpts.TabSuffix) then
        begin
          lstEst.Add(QuotedStr(ExtractFilePath(nmFile) + 'catab' + strRun + cenOpts.TabSuffix) + ',');
          if cenOpts.UseMD5 then
            lstEst.Add(QuotedStr(LowerCase(MDPrint(MDFile(ExtractFilePath(nmFile) + 'catab' + strRun + cenOpts.TabSuffix, MD_VERSION_5, 1024)))) + ',')
          else
            lstEst.Add('NULL,');
        end
        else
          lstEst.Add('NULL,NULL,');

        // cotab
        if FileExists(ExtractFilePath(nmFile) + 'cotab' + strRun + cenOpts.TabSuffix) then
        begin
          lstEst.Add(QuotedStr(ExtractFilePath(nmFile) + 'cotab' + strRun + cenOpts.TabSuffix) + ',');
          if cenOpts.UseMD5 then
            lstEst.Add(QuotedStr(LowerCase(MDPrint(MDFile(ExtractFilePath(nmFile) + 'cotab' + strRun + cenOpts.TabSuffix, MD_VERSION_5, 1024)))) + ',')
          else
            lstEst.Add('NULL,');
        end
        else
          lstEst.Add('NULL,NULL,');

        // mutab
        if FileExists(ExtractFilePath(nmFile) + 'mutab' + strRun + cenOpts.TabSuffix) then
        begin
          lstEst.Add(QuotedStr(ExtractFilePath(nmFile) + 'mutab' + strRun + cenOpts.TabSuffix) + ',');
          if cenOpts.UseMD5 then
            lstEst.Add(QuotedStr(LowerCase(MDPrint(MDFile(ExtractFilePath(nmFile) + 'mutab' + strRun + cenOpts.TabSuffix, MD_VERSION_5, 1024)))) + ',')
          else
            lstEst.Add('NULL,');
        end
        else
          lstEst.Add('NULL,NULL,');

        // mytab
        if FileExists(ExtractFilePath(nmFile) + 'mytab' + strRun + cenOpts.TabSuffix) then
        begin
          lstEst.Add(QuotedStr(ExtractFilePath(nmFile) + 'mytab' + strRun + cenOpts.TabSuffix) + ',');
          if cenOpts.UseMD5 then
            lstEst.Add(QuotedStr(LowerCase(MDPrint(MDFile(ExtractFilePath(nmFile) + 'mytab' + strRun + cenOpts.TabSuffix, MD_VERSION_5, 1024)))) + ',')
          else
            lstEst.Add('NULL,');
        end
        else
          lstEst.Add('NULL,NULL,');

        // cwtab
        if FileExists(ExtractFilePath(nmFile) + 'cwtab' + strRun + cenOpts.TabSuffix) then
        begin
          lstEst.Add(QuotedStr(ExtractFilePath(nmFile) + 'cwtab' + strRun + cenOpts.TabSuffix) + ',');
          if cenOpts.UseMD5 then
            lstEst.Add(QuotedStr(LowerCase(MDPrint(MDFile(ExtractFilePath(nmFile) + 'cwtab' + strRun + cenOpts.TabSuffix, MD_VERSION_5, 1024)))) + ',')
          else
            lstEst.Add('NULL,');
        end
        else
          lstEst.Add('NULL,NULL,');

        // cwtabEst
        if FileExists(ExtractFilePath(nmFile) + 'cwtabEst' + strRun + cenOpts.TabSuffix) then
        begin
          lstEst.Add(QuotedStr(ExtractFilePath(nmFile) + 'cwtabEst' + strRun + cenOpts.TabSuffix) + ',');
          if cenOpts.UseMD5 then
            lstEst.Add(QuotedStr(LowerCase(MDPrint(MDFile(ExtractFilePath(nmFile) + 'cwtabEst' + strRun + cenOpts.TabSuffix, MD_VERSION_5, 1024)))) + ',')
          else
            lstEst.Add('NULL,');
        end
        else
          lstEst.Add('NULL,NULL,');

        // cwtabDeriv
        if FileExists(ExtractFilePath(nmFile) + 'cwtabDeriv' + strRun + cenOpts.TabSuffix) then
        begin
          lstEst.Add(QuotedStr(ExtractFilePath(nmFile) + 'cwtabDeriv' + strRun + cenOpts.TabSuffix) + ',');
          if cenOpts.UseMD5 then
            lstEst.Add(QuotedStr(LowerCase(MDPrint(MDFile(ExtractFilePath(nmFile) + 'cwtabDeriv' + strRun + cenOpts.TabSuffix, MD_VERSION_5, 1024)))) + ',')
          else
            lstEst.Add('NULL,');
        end
        else
          lstEst.Add('NULL,NULL,');

        lstEst.Add(strOFV + ',');

        //ShowMessage('Before adding dOFV');
        // get dOFV
        strdOFV := 'NULL';
        if Length(Trim(PsNRunRec.BasedOn)) > 0 then
        begin
          with qryGeneral do
          begin
            Active := False;
            SQL.Clear;
            SQL.Add('select OFV from runs');
            SQL.Add('where RunNo = ' + QuotedStr(PsNRunRec.BasedOn) + ';');
            Active := True;
          end;
          strdOFV := FloatToStr(SigFig(StrToFloat(strOFV) - qryGeneral.Fields[0].AsFloat, 4));
        end;

        lstEst.Add(strdOFV + ',');
        lstEst.Add(QuotedStr(PsNRunRec.PsNLabel) + ',');
        lstEst.Add(QuotedStr(PsNRunRec.BasedOn) + ',');
        lstEst.Add(QuotedStr(PsNRunRec.Description) + ',');
        lstEst.Add(QuotedStr(strDataFile) + ',');
        lstEst.Add(QuotedStr(PsNRunRec.StructuralModel) + ',');
        lstEst.Add(QuotedStr(PsNRunRec.CovariateModel) + ',');
        lstEst.Add(QuotedStr(PsNRunRec.InterIndividualVariability) + ',');
        lstEst.Add(QuotedStr(PsNRunRec.InterOccasionVariability) + ',');
        lstEst.Add(QuotedStr(PsNRunRec.ResidualVariability) + ',');
        lstEst.Add(QuotedStr(PsNRunRec.Estimation) + ',');
        lstEst.Add(QuotedStr(LineBreaks(nmDoc.DocumentElement.FindNode(xmlPrefix + 'nmtran').TextContent).Text) + ',');
        lstEst.Add(QuotedStr(lstControlStream.Text) + ',');
        lstEst.Add(QuotedStr(lstProbInfo.Text) + ',');
        lstEst.Add(FloatToStr(fltEstTime) + ',');
        lstEst.Add(FloatToStr(fltCovTime) + ',');
        lstEst.Add(QuotedStr(lstTermInfoOverall.Text) + ',');
        lstEst.Add(FloatToStr(fltCondNo) + ',');

        blnS := False;
        blnT := False;
        blnNC := False;
        blnC := False;

        strMinOverall := 'Successful';
        for p := 0 to lstTermInfoOverall.Count - 1 do
        begin
          if Pos('SUCCESSFUL', lstTermInfoOverall[p]) > 0 then
          begin
            blnS := True;
            if blnT or blnNC then
              strMinOverall := 'Partial'
            else
              strMinOverall := 'Successful';
          end;
          if Pos('TERMINATED', lstTermInfoOverall[p]) > 0 then
          begin
            blnT := True;
            if blnS or blnC then
              strMinOverall := 'Partial'
            else
              strMinOverall := 'Unsuccessful';
          end;
          if (Pos('COMPLETED', lstTermInfoOverall[p]) > 0) and (Pos('NOT COMPLETED', lstTermInfoOverall[p]) = 0) then
          begin
            blnC := True;
            if blnT or blnNC then
              strMinOverall := 'Partial'
            else
              strMinOverall := 'Successful';
          end;
          if Pos('NOT COMPLETED', lstTermInfoOverall[p]) > 0 then
          begin
            blnNC := True;
            if blnS or blnC then
              strMinOverall := 'Partial'
            else
              strMinOverall := 'Unsuccessful';
          end;
        end;

        lstEst.Add(QuotedStr(strMinOverall) + ',');
        lstEst.Add(QuotedStr(strSigDigits) + ',');    // value from last est
        lstEst.Add(QuotedStr(nmDoc.DocumentElement.FindNode(xmlPrefix + 'start_datetime').TextContent) + ',');
        lstEst.Add(QuotedStr(nmDoc.DocumentElement.FindNode(xmlPrefix + 'stop_datetime').TextContent) + ',');

        //ShowMessage(strMinOverall);
        // warnings // load .lst file, if it exists
        if FileExists(ChangeFileExt(nmFile, cenOpts.LstSuffix)) then
        begin
          lstList.Clear;
          lstList.LoadFromFile(ChangeFileExt(nmFile, '.lst'));

          //ShowMessage(ChangeFileExt(nmFile, '.lst'));

          // ********************************************************************
          // Check zero gradients and hessian resets
          // ********************************************************************
          lstTemp.Clear;
          lstTemp2.Clear;

          intZeroGradients := 0;
          intHessian := 0;

          strTemp := '';
          for m := 0 to lstList.Count - 1 do
          begin
            if Pos('GRADIENT', lstList[m]) > 0 then
              blnCap := True;
            if Pos('ITERATION NO.', lstList[m]) > 0 then
            begin
              blnCap := False;
              if Length(strTemp) > 0 then
                lstTemp2.Add(strTemp);
              strTemp := '';
            end;
            if blnCap then
              strTemp := strTemp + lstList[m];
          end;
          if Length(strTemp) > 0 then
            lstTemp2.Add(strTemp);

          //ShowMessage(strTemp);
          if Pos('0.0000E+00', strTemp) > 0 then
          begin
            blnFZeroGradients := True;
            lstLog.Add('Zero gradients detected in final iteration...');
          end;

          //ShowMessage('Starting regex');
          regEx := TRegExpr.Create;
          //ShowMessage('Created regex');

          // count zero gradients
          //ShowMessage(lstTemp2.Text);
          regEx.Expression := '0.0000E+00';
          //ShowMessage('Start loop');
          if regEx.Exec(lstTemp2.Text) then
          repeat
            //ShowMessage('found');
            intZeroGradients := intZeroGradients + 1;
            blnZeroGradients := True;
          until not regEx.ExecNext;
          //ShowMessage('Count zero gradients done');

          //ShowMessage(IntToStr(intZeroGradients));

          if (blnFZeroGradients) then
          begin
            if (Length(txtWarnings) > 0) then
              txtWarnings := txtWarnings + '; ';
            txtWarnings := txtWarnings + 'Final zero gradients';
          end;

          if (intZeroGradients > 0) and (blnFZeroGradients = False) then
          begin
            if (Length(txtWarnings) > 0) then
              txtWarnings := txtWarnings + '; ';
            txtWarnings := txtWarnings + 'Zero gradients';
          end;
          //ShowMessage('Finished zero gradients');

          lstLog.Add(IntToStr(intZeroGradients) + ' zero gradients detected...');

          //ShowMessage();
          // count Hessian resets;
          regEx.Expression := 'RESET HESSIAN';
          if regEx.Exec(lstList.Text) then
          repeat
            intHessian := intHessian + 1;
          until not regEx.ExecNext;

          //ShowMessage(IntToStr(intHessian));

          lstLog.Add(IntToStr(intHessian) + ' Hessian resets detected...');

          if (intHessian > 0) then
          begin
            if (Length(txtWarnings) > 0) then
              txtWarnings := txtWarnings + '; ';
            txtWarnings := txtWarnings + IntToStr(intHessian) + ' Hessian resets';
          end;

          regEx.Free;
          //ShowMessage('End regex');

        end;

        lstEst.Add(QuotedStr(txtWarnings) + ',');
        //ShowMessage(txtWarnings);

        if strOS = 'Linux' then
          txtUser := GetEnvironmentVariable('USER');
        if strOS = 'Windows' then
          txtUser := GetEnvironmentVariable('USERNAME');

        lstEst.Add(IntToStr(Trunc((Now - EncodeDate(1970, 1 ,1)) * 24 * 60 * 60)) + ',');
        lstEst.Add(QuotedStr(txtUser) + ');');

        //ShowMessage('Check three (before SQL add)');
        //lstEst.SaveToFile('/Exprimo/Clients/NovImmune/runs.sql');
        try
          try
            with qryAdd do
            begin
               SQL.Assign(lstEst);
               //SQL.Add('COMMIT;');
               ExecSQL;
            end;
          except
            MessageDlg('An error occurred while adding the main run record to the database.',
              mtError, [mbOK], 0);
          end;
        finally
          ;
        end;

        lstLog.Add('Estimation steps... ' + IntToStr(intEst));
        lstLog.Add('Final OFV... ' + strOFV);

      except
        on E: Exception do
        begin
          MessageDlg('An error has occurred while processing this NONMEM run. ' + #10#13#10#13 +
            'Please email Justin Wilkins at justin.wilkins@exprimo.com with ' +
            'a description of the error and a copy of the XML file you were ' +
            'trying to load (' + nmFile + ').' + #10#13#10#13 + E.ClassName + ': ' + E.Message, mtError, [mbOK], 0);
          NukeRun(strRun);
          lstLog.SaveToFile(ExtractFileDir(nmFile) + '/' + strRun + '.error.log');
          Exit;
        end;
      end;

    finally
      Screen.Cursor := oldCursor;
      //ShowMessage('end');

    end;
      grdRuns.DataSource := nil;
      grdEst.DataSource := nil;
      grdTheta.DataSource := nil;
      grdOmega.DataSource := nil;
      grdSigma.DataSource := nil;
      grdPsN.DataSource := nil;

      {grdRuns.BeginUpdate;
      grdEst.BeginUpdate;
      grdTheta.BeginUpdate;
      grdOmega.BeginUpdate;
      grdSigma.BeginUpdate;
      grdPsN.BeginUpdate;   }

      qryRuns.Refresh;
      FindNewRec(strRun);

     { grdRuns.EndUpdate;
      grdEst.EndUpdate;
      grdTheta.EndUpdate;
      grdOmega.EndUpdate;
      grdSigma.EndUpdate;
      grdPsN.EndUpdate;    }

      qryRunsAfterScroll(qryRuns);

      grdRuns.DataSource := dsRuns;
      grdEst.DataSource := dsEst;
      grdTheta.DataSource := dsTheta;
      grdOmega.DataSource := dsOmega;
      grdSigma.DataSource := dsSigma;
      grdPsN.DataSource := dsPsN;
      BuildTree;

    if qryRuns.RecordCount > 0 then
    begin
      mnuArchive.Enabled := True;
      mnuArchiveAll.Enabled := True;
      mnuExportLatex.Enabled := True;
      mnuExportRunRec.Enabled := True;
      btnDelete.Enabled := True;
      mnuDelete.Enabled := True;
      btnReport.Enabled := True;
      btnRunRec.Enabled := True;
      btnCompare.Enabled := True;
    end
    else
    begin
      mnuArchive.Enabled := False;
      mnuArchiveAll.Enabled := False;
      mnuExportLatex.Enabled := False;
      mnuExportRunRec.Enabled := False;
      btnDelete.Enabled := False;
      mnuDelete.Enabled := False;
      btnReport.Enabled := False;
      btnRunRec.Enabled := False;
      btnCompare.Enabled := False;
    end;

  end;
  // ********************************************************************
  // Free variables
  // ********************************************************************


  lstList.Free;
  lstLog.Free;
  stmList.Free;
  nmDoc.Free;
  lstEst.Free;

  lstTheta.Free;
  lstThetaSE.Free;
  lstThetaInit.Free;
  lstThetaLowB.Free;
  lstThetaUppB.Free;
  lstThetaLabel.Free;

  lstEta.Free;
  lstEtaSE.Free;
  lstEtaBar.Free;
  lstEtaBarP.Free;
  lstEtaBarSE.Free;
  lstEtaInit.Free;
  lstEtaShrinkage.Free;
  lstEtaLabel.Free;

  lstEpsilon.Free;
  lstEpsilonSE.Free;
  lstEpsilonInit.Free;
  lstEpsilonShrinkage.Free;
  lstEpsilonLabel.Free;

  lstCovMatrix.Free;
  lstCoiMatrix.Free;
  lstCorMatrix.Free;
  lstEigenvalues.Free;

  lstMatrixSigmaInit.Free;
  lstMatrixOmegaInit.Free;

  lstMatrixOmega.Free;
  lstMatrixSigma.Free;

  lstMatrixOmegaSE.Free;
  lstMatrixSigmaSE.Free;

  lstMatrixOmegaCSE.Free;
  lstMatrixSigmaCSE.Free;

  lstMatrixOmegaCorr.Free;
  lstMatrixSigmaCorr.Free;

  lstControlStream.Free;
  lstProbInfo.Free;

  lstTermInfo.Free;

  lstTemp.Free;
  lstTemp2.Free;
  lstPsNRunRec.Free;
  //nmNode.Free;

end;

procedure TfrmMain.FindNewRec(strRun: string);
var
  CurrentPos: TBookmark;
  Found: Boolean;
begin
  Found := False;

  CurrentPos := qryRuns.GetBookmark;
  qryRuns.DisableControls;
  Found := False;
  qryRuns.First;

  qryRuns.Filter := 'RunNo=' + QuotedStr(strRun);
  qryRuns.Filtered := True;
  if qryRuns.RecordCount > 0 then
  begin
    Found := True;
    qryRuns.FindFirst;
  end;
  qryRuns.Filtered := False;
  qryRuns.Filter := '';

  {while (not qryRuns.EOF) and (not Found) do
  begin
    if qryRunsRunNo.AsString = strRun then
      Found := True;
    if not Found then
      qryRuns.Next;
  end;         }
  if not Found then
  begin
    qryRuns.GotoBookmark(CurrentPos);
  end;
  qryRuns.EnableControls;
  qryRuns.FreeBookmark(CurrentPos);

end;


// ********************************************************************
// Find initial estimates if we used an MSF
// ********************************************************************

procedure TfrmMain.AddThetaMSFInits(str: string; lstInit,
  lstLower, lstUpper: TStrings);
var
  strTemp: string;
begin
  // kill comment
  if Pos(';', str) > 0 then
    strTemp := Copy(str, 1, Pos(';', str));
  // lose $THETA
  StringReplace(strTemp, '$THETA', '', [rfReplaceAll]);
  if Pos('(', strTemp) > 0 then
    strTemp := Copy(strTemp, Pos('(', strTemp),
      Pos(')', strTemp) - Pos('(', strTemp));
  strTemp := StringReplace(strTemp, '(', '', [rfReplaceAll]);
  if Pos(',', strTemp) > 0 then
  begin
    lstInit.Add(StringReplace(BrkUp(',', strTemp, 1), '(', '',
      [rfReplaceAll]));
    lstLower.Add(StringReplace(BrkUp(',', strTemp, 0), '(', '',
      [rfReplaceAll]));
    try
      lstUpper.Add(StringReplace(BrkUp(',', strTemp, 2), '(', '',
        [rfReplaceAll]));
    except
      lstUpper.Add('1000000');
    end;
  end
  else
  begin
    lstInit.Add(Trim(StringReplace(strTemp, '(', '', [rfReplaceAll])));
    lstLower.Add('-1000000');
    lstUpper.Add('1000000');
  end;
end;

procedure TfrmMain.XMLToTree(tree: TTreeView; XMLDoc: TXMLDocument);
var
  iNode: TDOMNode;

  procedure ProcessNode(Node: TDOMNode; TreeNode: TTreeNode);
  var
    cNode: TDOMNode;
    s: string;
  begin
    if Node = nil then Exit; // Stops if reached a leaf

    // Adds a node to the tree
    if Node.HasAttributes and (Node.Attributes.Length>0) then
      s := Node.NodeName + ' ' + Node.Attributes[0].NodeValue
    else
      //s := '';
      s := Node.NodeName + ' - ' + Node.NodeValue;
    TreeNode := tree.Items.AddChild(TreeNode, s);

    if Node.NodeName = 'nm:estimation' then
      ShowMessage(Node.FirstChild.NodeValue);

    // Goes to the child node
    cNode := Node.FirstChild;

    // Processes all child nodes
    while cNode <> nil do
    begin
      ProcessNode(cNode, TreeNode);
      cNode := cNode.NextSibling;
    end;
  end;

begin
  iNode := XMLDoc.DocumentElement.FirstChild;
  while iNode <> nil do
  begin
    ProcessNode(iNode, nil); // Recursive
    iNode := iNode.NextSibling;
  end;
  tree.Visible := True;
end;

procedure TfrmMain.mnuExitClick(Sender: TObject);
begin
  if zConn.Connected then
    mnuCloseClick(Sender);
  frmMain := nil;
  Close;
end;

procedure TfrmMain.qryRunsDataGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := ExtractFileName(qryRunsDataFile.AsString);
end;

procedure TfrmMain.qryRunsDescriptionGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunsDescription.AsString, 1, 250);
end;

procedure TfrmMain.qryRunsdOFVGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := FloatToStrF(qryRunsdOFV.Value, ffGeneral, 8, 4);
end;

procedure TfrmMain.qryRunsEstimationGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunsEstimation.AsString, 1, 250);
end;

procedure TfrmMain.qryRunsEstTimeGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := FloatToStrF(qryRunsEstTime.Value, ffGeneral, 8, 4);
end;

procedure TfrmMain.qryRunsextGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunsext.AsString, 1, 5000);
end;

procedure TfrmMain.qryRunsextMD5GetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunsextMD5.AsString, 1, 5000);
end;

procedure TfrmMain.qryRunsgrdGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunsgrd.AsString, 1, 5000);
end;

procedure TfrmMain.qryRunsgrdMD5GetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunsgrdMD5.AsString, 1, 5000);
end;

procedure TfrmMain.qryRunsIIVGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunsIIV.AsString, 1, 250);
end;

procedure TfrmMain.qryRunsIndividualsGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := IntToStr(qryRunsIndividuals.Value);
end;

procedure TfrmMain.qryRunsIOVGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunsIOV.AsString, 1, 250);
end;

procedure TfrmMain.qryRunsKeyRunGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := '';
end;

procedure TfrmMain.qryRunsLabelGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunsLabel.AsString, 1, 250);
end;

procedure TfrmMain.qryRunsMinShortGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunsMinShort.AsString, 1, 50);
end;

procedure TfrmMain.qryRunsMSFGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunsMSF.AsString, 1, 5000);
end;

procedure TfrmMain.qryRunsMSFMD5GetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunsMSFMD5.AsString, 1, 5000);
end;

procedure TfrmMain.qryRunsmutabGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunsmutab.AsString, 1, 5000);
end;

procedure TfrmMain.qryRunsmutabMD5GetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunsmutabMD5.AsString, 1, 5000);
end;

procedure TfrmMain.qryRunsmytabGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunsmytab.AsString, 1, 5000);
end;

procedure TfrmMain.qryRunsmytabMD5GetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunsmytabMD5.AsString, 1, 5000);
end;

procedure TfrmMain.qryRunsObsRecsGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := IntToStr(qryRunsObsRecs.Value);
end;

procedure TfrmMain.qryRunsOFVGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := FloatToStrF(qryRunsOFV.Value, ffGeneral, 8, 4);
end;

procedure TfrmMain.qryRunsOutputFileGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunsOutputFile.AsString, 1, 5000);
end;

procedure TfrmMain.qryRunsOutputFileMD5GetText(Sender: TField;
  var aText: string; DisplayText: Boolean);
begin
  aText := Copy(qryRunsOutputFileMD5.AsString, 1, 5000);
end;

procedure TfrmMain.qryRunsParentNoGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunsParentNo.AsString, 1, 50);
end;

procedure TfrmMain.qryRunspatabGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunspatab.AsString, 1, 5000);
end;

procedure TfrmMain.qryRunspatabMD5GetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunspatabMD5.AsString, 1, 5000);
end;

procedure TfrmMain.qryRunsphiGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunsphi.AsString, 1, 5000);
end;

procedure TfrmMain.qryRunsphiMD5GetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunsphiMD5.AsString, 1, 5000);
end;

procedure TfrmMain.qryRunsphmGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunsphm.AsString, 1, 5000);
end;

procedure TfrmMain.qryRunsphmMD5GetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunsphmMD5.AsString, 1, 5000);
end;

procedure TfrmMain.qryRunsrmtGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunsrmt.AsString, 1, 5000);
end;

procedure TfrmMain.qryRunsrmtMD5GetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunsrmtMD5.AsString, 1, 5000);
end;

procedure TfrmMain.qryRunsRunNoGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunsRunNo.AsString, 1, 50);
end;

procedure TfrmMain.qryRunsRVGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunsRV.AsString, 1, 250);
end;

procedure TfrmMain.qryRunssdtabGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunssdtab.AsString, 1, 5000);
end;

procedure TfrmMain.qryRunssdtabMD5GetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunssdtabMD5.AsString, 1, 5000);
end;

procedure TfrmMain.qryRunsshkGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunsshk.AsString, 1, 5000);
end;

procedure TfrmMain.qryRunsshkMD5GetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunsshkMD5.AsString, 1, 5000);
end;

procedure TfrmMain.qryRunssmtGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunssmt.AsString, 1, 5000);
end;

procedure TfrmMain.qryRunssmtMD5GetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunssmtMD5.AsString, 1, 5000);
end;

procedure TfrmMain.qryRunsStartTimeGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunsStartTime.AsString, 1, 50);
end;

procedure TfrmMain.qryRunsStopTimeGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunsStopTime.AsString, 1, 250);
end;

procedure TfrmMain.qryRunsStructuralModelGetText(Sender: TField;
  var aText: string; DisplayText: Boolean);
begin
  aText := Copy(qryRunsStructuralModel.AsString, 1, 250);
end;

procedure TfrmMain.qryRunsWarningsGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunsWarnings.AsString, 1, 250);
end;

procedure TfrmMain.qryRunsXMLGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunsXML.AsString, 1, 5000);
end;

procedure TfrmMain.qryRunsXMLMD5GetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryRunsXMLMD5.AsString, 1, 5000);
end;

procedure TfrmMain.qrySigmaEpsilonShrinkageGetText(Sender: TField;
  var aText: string; DisplayText: Boolean);
begin
  aText := Copy(qrySigmaEpsilonShrinkage.AsString, 1, 50);
end;

procedure TfrmMain.qrySigmaSigmaCIsGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qrySigmaSigmaCIs.AsString, 1, 50);
end;

procedure TfrmMain.qrySigmaSigmaInitGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := FloatToStr(SigFig(qrySigmaSigmaInit.Value, 4));
end;

procedure TfrmMain.qrySigmaSigmaLabelGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qrySigmaSigmaLabel.AsString, 1, 50);
end;

procedure TfrmMain.qrySigmaSigmaRSEGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := FloatToStr(SigFig(qrySigmaSigmaRSE.Value, 4));
end;

procedure TfrmMain.qrySigmaSigmaSEGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := FloatToStr(SigFig(qrySigmaSigmaSE.Value, 4));
end;

procedure TfrmMain.qrySigmaSigmaValueGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := FloatToStr(SigFig(qrySigmaSigmaValue.Value, 4));
end;

procedure TfrmMain.qryThetaInitialGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := FloatToStr(SigFig(qryThetaInitial.Value, 4));
end;

procedure TfrmMain.qryThetaLowerGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := FloatToStr(SigFig(qryThetaLower.Value, 4));
end;


procedure TfrmMain.qryThetaThetaCIsGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryThetaThetaCIs.AsString, 1, 50);
end;


procedure TfrmMain.qryThetaThetaLabelGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(qryThetaThetaLabel.AsString, 1, 50);
end;

procedure TfrmMain.qryThetaThetaRSEGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := FloatToStr(SigFig(qryThetaThetaRSE.Value, 4));
end;

procedure TfrmMain.qryThetaThetaSEGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := FloatToStr(SigFig(qryThetaThetaSE.Value, 4));
end;

procedure TfrmMain.qryThetaThetaValueGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := FloatToStr(SigFig(qryThetaThetaValue.Value, 4));
end;

procedure TfrmMain.qryThetaUpperGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := FloatToStr(SigFig(qryThetaUpper.Value, 4));
end;


function TfrmMain.Pad(RunNo: string): WideString;
var
  strResult: WideString;
  intLength, n: Integer;
begin
  strResult := RunNo;
  intLength := Length(strResult);
  //ShowMessage('intLength - ' + IntToStr(lstList.Count));
  for n := 1 to (15 - intLength) do
    strResult := '0' + strResult;
  Result := strResult;
end;


function TfrmMain.LineBreaks(inTxt: WideString): TStringList;
begin
  brkUpp.BaseString := inTxt;
  brkUpp.BaseString := StringReplace(StringReplace(brkUpp.BaseString, #10, 'ÁÁÁ', [rfReplaceAll]), #13, 'ÁÁÁ', [rfReplaceAll]);
  brkUpp.BreakString := 'ÁÁÁ';
  brkUpp.AllowEmptyString := False;
  brkUpp.BreakApart;
  Result := brkUpp.StringList;
end;

// ********************************************************************
// BrkUpp function
// ********************************************************************

function TfrmMain.BrkUp(brkStr: string; brkBase: string;
  brkInt: Integer): string;
begin
  brkUpp.StringList.Clear;
  brkUpp.BaseString := brkBase;
  brkUpp.BreakString := brkStr;
  brkUpp.BreakApart;
  //ShowMessage(Trim(brkUpp.StringList[brkInt]));
  Result := Trim(brkUpp.StringList[brkInt]);
end;

// ********************************************************************
// significant figures function
// ********************************************************************

function TfrmMain.SigFig(fltIn: Double; intPrec: Integer): Double;
var
  intDP: extended;
begin
  if fltIn = 0 then
    Result := 0
  else
  begin
    intDP := Int(intPrec - log10(Abs(fltIn)));
    Result := RoundTo(fltIn, Round(intDP));
  end;
end;

// ********************************************************************
// power function
// ********************************************************************

function TfrmMain.PowerFn (number, exponent: Double): Double;
begin
  Result := Exp(exponent * Ln(number));
end;

function TfrmMain.StripSpaces(st: string): string;
var
  p: Integer;
begin
  p := pos('  ', st);
  while p <> 0 do begin
    st := StringReplace(st, '  ', ' ', [rfReplaceAll]);
    p := pos('  ', st);
  end;
  Result := st;
end;

function TfrmMain.RoundTo(const AValue : extended ; const ADigit : Integer) :
  extended ;
var X : extended ; i : integer ;
begin
  X := 1.0 ;
  for i := 1 to Abs(ADigit) do X := X * 10 ;
  if ADigit<0
    then Result := Round(AValue / X) * X
    else Result := Round(AValue * X) / X ;
  end {R2} ;

procedure TfrmMain.CreateRunsTable;
begin

  sqlCreate.SQL.Clear;
  sqlCreate.SQL.Text := 'CREATE TABLE runs (' +
    'ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,' +
    'RunNo TEXT NOT NULL,' +
    'iRunNo INTEGER NOT NULL, ' +
    'Comment TEXT,' +
    'ObsRecs INTEGER,' +
    'Individuals INTEGER,' +
    'Model TEXT,' +
    'ModelMD5 TEXT,' +
    'CtlFile TEXT,' +
    'CtlFileMD5 TEXT,' +
    'DataFile TEXT,' +
    'DataFileMD5 TEXT,' +
    'OutputFile TEXT,' +
    'OutputFileMD5 TEXT,' +
    'MSF TEXT,' +
    'MSFMD5 TEXT,' +
    'FitFile TEXT,' +
    'FitFileMD5 TEXT,' +
    'patab TEXT,' +
    'patabMD5 TEXT,' +
    'sdtab TEXT,' +
    'sdtabMD5 TEXT,' +
    'catab TEXT,' +
    'catabMD5 TEXT, ' +
    'cotab TEXT,' +
    'cotabMD5 TEXT,' +
    'mutab TEXT,' +
    'mutabMD5 TEXT,' +
    'mytab TEXT,' +
    'mytabMD5 TEXT,' +
    'txt TEXT,' +
    'txtMD5 TEXT,' +
    'ext TEXT,' +
    'extMD5 TEXT,' +
    'cov TEXT,' +
    'covMD5 TEXT,' +
    'cor TEXT,' +
    'corMD5 TEXT,' +
    'coi TEXT,' +
    'coiMD5 TEXT,' +
    'phi TEXT,' +
    'phiMD5 TEXT,' +
    'XML TEXT,' +
    'XMLMD5 TEXT,' +
    'phm TEXT,' +
    'phmMD5 TEXT,' +
    'shk TEXT,' +
    'shkMD5 TEXT,' +
    'grd TEXT,' +
    'grdMD5 TEXT,' +
    'cnv TEXT,' +
    'cnvMD5 TEXT,' +
    'smt TEXT,' +
    'smtMD5 TEXT, ' +
    'rmt TEXT,' +
    'rmtMD5 TEXT,' +
    'cwtab TEXT,' +
    'cwtabMD5 TEXT,' +
    'cwtabEst TEXT,' +
    'cwtabEstMD5 TEXT, ' +
    'cwtabDeriv TEXT,' +
    'cwtabDerivMD5 TEXT, ' +
    'Comments TEXT,' +
    'OFV REAL, ' +
    'dOFV REAL,' +
    'Label TEXT, ' +
    'ConditionNumber REAL,' +
    'MinShort TEXT,' +
    'Minimization TEXT,' +
    'FnEvals INTEGER,' +
    'SigDigits REAL,' +
    'Description TEXT,' +
    'Warnings TEXT, ' +
    'Data TEXT, ' +
    'EstTime REAL,' +
    'CovTime REAL, ' +
    'StructuralModel TEXT,' +
    'CovariateModel TEXT,' +
    'IIV TEXT,' +
    'IOV TEXT,' +
    'RV TEXT,' +
    'Estimation TEXT,' +
    'ParentNo TEXT,' +
    'KeyRun INTEGER,' +
    'NMTran TEXT,' +
    'ControlStream TEXT,' +
    'ProblemInfo TEXT,' +
    'StartTime TEXT, ' +
    'StopTime TEXT,' +
    'Timestamp INTEGER,' +
    'User TEXT ' +
');';
  sqlCreate.ExecSQL;
  zConn.Connected := False;

  sqlCreate.SQL.Clear;
  sqlCreate.SQL.Text := 'CREATE INDEX runno on runs (RunNo ASC, iRunNo ASC);';
  sqlCreate.ExecSQL;

  sqlCreate.SQL.Clear;
  sqlCreate.SQL.Text := 'CREATE INDEX irunno on runs (iRunNo ASC);';
  sqlCreate.ExecSQL;

  sqlCreate.SQL.Clear;
  sqlCreate.SQL.Text := 'CREATE INDEX runno2 on runs (RunNo ASC);';
  sqlCreate.ExecSQL;

  ShowMessage('Runs done');

end;

procedure TfrmMain.CreateThetaTable;
begin

  sqlCreate.SQL.Clear;
  sqlCreate.SQL.Text := 'CREATE TABLE thetas (' +
    'ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,' +
    'RunNo TEXT NOT NULL,' +
    'EstNo INTEGER NOT NULL,' +
    'Theta INTEGER,' +
    'ThetaLabel TEXT,' +
    'ThetaValue REAL,' +
    'ThetaSE REAL,' +
    'Lower REAL,' +
    'Initial REAL,' +
    'Upper REAL,' +
    'ThetaRSE REAL, ' +
    'Model TEXT, ' +
    'ThetaMatrix TEXT, ' +
    'ThetaSigDig REAL,' +
    'ThetaCIs TEXT, ' +
    'ThetaCIUpper REAL, ' +
    'ThetaCILower REAL, ' +
    'Timestamp INTEGER, ' +
    'User TEXT' +
');';
  sqlCreate.ExecSQL;

  sqlCreate.SQL.Clear;
  sqlCreate.SQL.Text := 'CREATE INDEX thetaID on thetas (ID ASC);';
  sqlCreate.ExecSQL;

  sqlCreate.SQL.Clear;
  sqlCreate.SQL.Text := 'CREATE INDEX theta on thetas (Theta ASC);';
  sqlCreate.ExecSQL;

  sqlCreate.SQL.Clear;
  sqlCreate.SQL.Text := 'CREATE INDEX runno.theta on thetas (RunNo ASC, EstNo ASC);';
  sqlCreate.ExecSQL;

  ShowMessage('Thetas done');

end;

procedure TfrmMain.CreateOmegaTable;
begin

  sqlCreate.SQL.Clear;
  sqlCreate.SQL.Text := 'CREATE TABLE omegas (' +
    'ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,' +
    'RunNo TEXT NOT NULL,' +
    'EstNo INTEGER NOT NULL,' +
    'Omega INTEGER,' +
    'OmegaValue REAL,' +
    'EtaBar TEXT, ' +
    'EtaBarSE TEXT,' +
    'EtaPVal TEXT,' +
    'OmegaInit REAL,' +
    'OmegaSE REAL,' +
    'OmegaRSE REAL,' +
    'OmegaLabel TEXT,' +
    'OmegaModel TEXT,' +
    'OmegaSigDig REAL,' +
    'Blocks INTEGER,' +
    'OmegaCIs TEXT,' +
    'OmegaCIUpper REAL,' +
    'OmegaCILower REAL,' +
    'OmegaPerc REAL,' +
    'EtaShrinkage TEXT,' +
    'OmegaCSE REAL,' +
    'OmegaCRSE REAL,' +
    'Timestamp INTEGER,' +
    'User TEXT' +
');';
  sqlCreate.ExecSQL;

  sqlCreate.SQL.Clear;
  sqlCreate.SQL.Text := 'CREATE INDEX omega on omegas (Omega ASC);';
  sqlCreate.ExecSQL;

  sqlCreate.SQL.Clear;
  sqlCreate.SQL.Text := 'CREATE INDEX runno.omega on omegas (RunNo ASC, EstNo ASC);';
  sqlCreate.ExecSQL;

  sqlCreate.SQL.Clear;
  sqlCreate.SQL.Text := 'CREATE INDEX omegaID on omegas (ID ASC);';
  sqlCreate.ExecSQL;

  ShowMessage('Omegas done');

end;

procedure TfrmMain.CreateSigmaTable;
begin
  sqlCreate.SQL.Clear;
  sqlCreate.SQL.Text := 'CREATE TABLE sigmas (' +
    'ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,' +
    'RunNo TEXT NOT NULL,' +
    'EstNo INTEGER NOT NULL,' +
    'Sigma INTEGER NOT NULL,' +
    'SigmaValue REAL,' +
    'SigmaInit REAL,' +
    'SigmaSE REAL,' +
    'SigmaRSE REAL,' +
    'SigmaLabel TEXT,' +
    'SigmaModel TEXT,' +
    'SigmaSigDig REAL,' +
    'Blocks INTEGER,' +
    'SigmaCIs TEXT,' +
    'SigmaCIUpper REAL,' +
    'SigmaCILower REAL,' +
    'EpsilonShrinkage TEXT,' +
    'SigmaCSE REAL,' +
    'SigmaCRSE REAL,' +
    'Timestamp INTEGER,' +
    'User TEXT' +
');';
  sqlCreate.ExecSQL;

  sqlCreate.SQL.Clear;
  sqlCreate.SQL.Text := 'CREATE INDEX sigmaID on sigmas (ID ASC);';
  sqlCreate.ExecSQL;

  sqlCreate.SQL.Clear;
  sqlCreate.SQL.Text := 'CREATE INDEX sigma on sigmas (Sigma ASC);';
  sqlCreate.ExecSQL;

  sqlCreate.SQL.Clear;
  sqlCreate.SQL.Text := 'CREATE INDEX runno.sigma on sigmas (RunNo ASC, EstNo ASC);';
  sqlCreate.ExecSQL;

  ShowMessage('Sigmas done');

end;

procedure TfrmMain.CreateTransTable;
begin

  sqlCreate.SQL.Clear;
  sqlCreate.SQL.Text := 'CREATE TABLE trans (' +
    'ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,' +
    'Action TEXT,' +
    'RunNo TEXT,' +
    'Timestamp INTEGER,' +
    'User TEXT ' +
');';
  sqlCreate.ExecSQL;

  sqlCreate.SQL.Clear;
  sqlCreate.SQL.Text := 'CREATE INDEX transID on trans (ID ASC);';
  sqlCreate.ExecSQL;

  sqlCreate.SQL.Clear;
  sqlCreate.SQL.Text := 'CREATE INDEX main on trans (Timestamp ASC, RunNo ASC);';
  sqlCreate.ExecSQL;

    ShowMessage('Trans done');

end;

procedure TfrmMain.CreateEstTable;
begin

  sqlCreate.SQL.Clear;
  sqlCreate.SQL.Text := 'CREATE TABLE est (' +
    'ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,' +
    'RunNo TEXT NOT NULL,' +
    'EstNo INTEGER NOT NULL,' +
    'Method TEXT,' +
    'MethLong TEXT,' +
    'GoalFunction TEXT,' +
    'OFV REAL,' +
    'dOFV REAL,' +
    'OFVType TEXT,' +
    'ParentNo TEXT,' +
    'EstElapsedTime REAL,' +
    'CovElapsedTime REAL,' +
    'KeyEst INTEGER,' +
    'MinShort TEXT,' +
    'Minimization TEXT,' +
    'Covariance TEXT,' +
    'FnEvals INTEGER,' +
    'SigDigits TEXT,' +
    'SIGL INTEGER,' +
    'TOL INTEGER,' +
    'NSIG INTEGER,' +
    'NIter INTEGER,' +
    'ISample INTEGER,' +
    'ISampleM1 INTEGER,' +
    'ISampleM2 INTEGER,' +
    'ISampleM3 INTEGER,' +
    'IAccept REAL,' +
    'PSampleM1 INTEGER,' +
    'PSampleM2 INTEGER,' +
    'PSampleM3 INTEGER,' +
    'PAccept REAL,' +
    'OSampleM1 INTEGER,' +
    'OSampleM2 INTEGER,' +
    'OAccept REAL,' +
    'DF REAL,' +
    'Seed INTEGER,' +
    'NBurn REAL,' +
    'CovStep TEXT,' +
    'CovShort TEXT,' +
    'CondEst INTEGER,' +
    'CenteredEta INTEGER,' +
    'Interaction INTEGER,' +
    'Laplacian INTEGER,' +
    'Comments TEXT,' +
    'OmegaInitMatrix TEXT,' +
    'SigmaInitMatrix TEXT,' +
    'OmegaMatrix TEXT,' +
    'SigmaMatrix TEXT,' +
    'OmegaSEMatrix TEXT,' +
    'SigmaSEMatrix TEXT,' +
    'OmegaCorrMatrix TEXT,' +
    'SigmaCorrMatrix TEXT,' +
    'OmegaCSEMatrix TEXT,' +
    'SigmaCSEMatrix TEXT,' +
    'CovMatrix TEXT,' +
    'CorrMatrix TEXT,' +
    'InvCovMatrix TEXT,' +
    'Eigenvalues TEXT,' +
    'ConditionNumber REAL,' +
    'Warnings TEXT,' +
    'Timestamp INTEGER,' +
    'User TEXT' +
');';
  sqlCreate.ExecSQL;

  sqlCreate.SQL.Clear;
  sqlCreate.SQL.Text := 'CREATE INDEX estID on est (ID ASC);';
  sqlCreate.ExecSQL;

  sqlCreate.SQL.Clear;
  sqlCreate.SQL.Text := 'CREATE INDEX runno.est on est (RunNo ASC, EstNo ASC);';
  sqlCreate.ExecSQL;

    ShowMessage('Est done');

end;

procedure TfrmMain.CreatePsNTable;
begin

  sqlCreate.SQL.Clear;
  sqlCreate.SQL.Text := 'CREATE TABLE psn (' +
    'ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,' +
    'RunNo TEXT NOT NULL,' +
    'iRunNo INTEGER NOT NULL,' +
    'Tool TEXT,' +
    'ResultsFile TEXT,' +
    'RawFile TEXT,' +
    'Directory TEXT,' +
    'Command TEXT,' +
    'PsNVersion TEXT,' +
    'PDF TEXT,' +
    'Timestamp INTEGER,' +
    'User TEXT' +
');';
  sqlCreate.ExecSQL;

  sqlCreate.SQL.Clear;
  sqlCreate.SQL.Text := 'CREATE INDEX psnID on psn (ID ASC);';
  sqlCreate.ExecSQL;

  sqlCreate.SQL.Clear;
  sqlCreate.SQL.Text := 'CREATE INDEX runno.psn on psn (RunNo ASC);';
  sqlCreate.ExecSQL;

    ShowMessage('PsN done');

end;

initialization
  {$I emptydb.lrs}

end.

