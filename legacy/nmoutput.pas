{***************************************************************************************}
{                                                                                       }
{                                   XML Data Binding                                    }
{                                                                                       }
{         Generated on: 7/21/2011 2:31:44 PM                                            }
{       Generated from: Z:\opt\nonmem\7.2.0\big\runfiles\output.xsd                     }
{   Settings stored in: C:\Users\Administrator\Documents\Delphi\Census\svn\output.xdb   }
{                                                                                       }
{***************************************************************************************}

unit nmoutput;

interface

uses DOM, XMLRead, XMLWrite, XMLCfg, XMLUtils, XMLStreaming; //xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLOutput = interface;
  IXMLNonmem = interface;
  IXMLProblem = interface;
  IXMLProblemList = interface;
  IXMLEstimation = interface;
  IXMLEstimationList = interface;
  IXMLParallel_est = interface;
  IXMLMonitor = interface;
  IXMLObj = interface;
  IXMLTable = interface;
  IXMLTableList = interface;
  IXMLRow = interface;
  IXMLRowList = interface;
  IXMLCol = interface;
  IXMLParallel_cov = interface;
  IXMLCovariance_status = interface;
  IXMLVector = interface;
  IXMLVal = interface;
  IXMLValList = interface;
  IXMLScatter = interface;
  IXMLScatterList = interface;

{ IXMLOutput }

  IXMLOutput = interface(IXMLNode)
    ['{62B485FC-E1AD-4C78-9363-1F73BB59CD41}']
    { Property Accessors }
    function Get_Start_datetime: WideString;
    function Get_Control_stream: WideString;
    function Get_Nmtran: WideString;
    function Get_Nonmem: IXMLNonmem;
    function Get_Stop_datetime: WideString;
    procedure Set_Start_datetime(Value: WideString);
    procedure Set_Control_stream(Value: WideString);
    procedure Set_Nmtran(Value: WideString);
    procedure Set_Stop_datetime(Value: WideString);
    { Methods & Properties }
    property Start_datetime: WideString read Get_Start_datetime write Set_Start_datetime;
    property Control_stream: WideString read Get_Control_stream write Set_Control_stream;
    property Nmtran: WideString read Get_Nmtran write Set_Nmtran;
    property Nonmem: IXMLNonmem read Get_Nonmem;
    property Stop_datetime: WideString read Get_Stop_datetime write Set_Stop_datetime;
  end;

{ IXMLNonmem }

  IXMLNonmem = interface(IXMLNode)
    ['{6B1531FE-33DA-44D0-AADB-4C09CD5B336A}']
    { Property Accessors }
    function Get_Version: WideString;
    function Get_License_information: WideString;
    function Get_Program_information: WideString;
    function Get_Problem: IXMLProblemList;
    procedure Set_Version(Value: WideString);
    procedure Set_License_information(Value: WideString);
    procedure Set_Program_information(Value: WideString);
    { Methods & Properties }
    property Version: WideString read Get_Version write Set_Version;
    property License_information: WideString read Get_License_information write Set_License_information;
    property Program_information: WideString read Get_Program_information write Set_Program_information;
    property Problem: IXMLProblemList read Get_Problem;
  end;

{ IXMLProblem }

  IXMLProblem = interface(IXMLNode)
    ['{A868F676-E854-4844-9C96-C10596F3FB2B}']
    { Property Accessors }
    function Get_Number: Integer;
    function Get_Subproblem: Integer;
    function Get_Superproblem1: Integer;
    function Get_Iteration1: Integer;
    function Get_Superproblem2: Integer;
    function Get_Iteration2: Integer;
    function Get_Problem_title: WideString;
    function Get_Problem_information: WideString;
    function Get_Simulation_information: WideString;
    function Get_Estimation: IXMLEstimationList;
    function Get_Table: IXMLTableList;
    function Get_Scatter: IXMLScatterList;
    procedure Set_Number(Value: Integer);
    procedure Set_Subproblem(Value: Integer);
    procedure Set_Superproblem1(Value: Integer);
    procedure Set_Iteration1(Value: Integer);
    procedure Set_Superproblem2(Value: Integer);
    procedure Set_Iteration2(Value: Integer);
    procedure Set_Problem_title(Value: WideString);
    procedure Set_Problem_information(Value: WideString);
    procedure Set_Simulation_information(Value: WideString);
    { Methods & Properties }
    property Number: Integer read Get_Number write Set_Number;
    property Subproblem: Integer read Get_Subproblem write Set_Subproblem;
    property Superproblem1: Integer read Get_Superproblem1 write Set_Superproblem1;
    property Iteration1: Integer read Get_Iteration1 write Set_Iteration1;
    property Superproblem2: Integer read Get_Superproblem2 write Set_Superproblem2;
    property Iteration2: Integer read Get_Iteration2 write Set_Iteration2;
    property Problem_title: WideString read Get_Problem_title write Set_Problem_title;
    property Problem_information: WideString read Get_Problem_information write Set_Problem_information;
    property Simulation_information: WideString read Get_Simulation_information write Set_Simulation_information;
    property Estimation: IXMLEstimationList read Get_Estimation;
    property Table: IXMLTableList read Get_Table;
    property Scatter: IXMLScatterList read Get_Scatter;
  end;

{ IXMLProblemList }

  IXMLProblemList = interface(IXMLNodeCollection)
    ['{2B9BE40A-54C0-4B27-AD2C-6F52F20DB45D}']
    { Methods & Properties }
    function Add: IXMLProblem;
    function Insert(const Index: Integer): IXMLProblem;
    function Get_Item(Index: Integer): IXMLProblem;
    property Items[Index: Integer]: IXMLProblem read Get_Item; default;
  end;

{ IXMLEstimation }

  IXMLEstimation = interface(IXMLNode)
    ['{C93B1AF3-AEA8-46C2-8C34-E7D7EF813D25}']
    { Property Accessors }
    function Get_Number: Integer;
    function Get_Type_: Integer;
    function Get_Parallel_est: IXMLParallel_est;
    function Get_Table_series: Integer;
    function Get_Estimation_method: WideString;
    function Get_Estimation_title: WideString;
    function Get_Monitor: IXMLMonitor;
    function Get_Termination_status: Integer;
    function Get_Termination_information: WideString;
    function Get_Etabar: IXMLTable;
    function Get_Etabarse: IXMLTable;
    function Get_Etabarpval: IXMLTable;
    function Get_Etashrink: IXMLTable;
    function Get_Epsshrink: IXMLTable;
    function Get_Estimation_elapsed_time: Double;
    function Get_Parallel_cov: IXMLParallel_cov;
    function Get_Covariance_information: WideString;
    function Get_Covariance_status: IXMLCovariance_status;
    function Get_Covariance_elapsed_time: Double;
    function Get_Final_objective_function_text: WideString;
    function Get_Final_objective_function: Double;
    function Get_Final_objective_function_std: Double;
    function Get_Theta: IXMLVector;
    function Get_Omega: IXMLTable;
    function Get_Sigma: IXMLTable;
    function Get_Omegac: IXMLTable;
    function Get_Sigmac: IXMLTable;
    function Get_Thetase: IXMLVector;
    function Get_Omegase: IXMLTable;
    function Get_Sigmase: IXMLTable;
    function Get_Omegacse: IXMLTable;
    function Get_Sigmacse: IXMLTable;
    function Get_Covariance: IXMLTable;
    function Get_Correlation: IXMLTable;
    function Get_Invcovariance: IXMLTable;
    function Get_Rmatrix: IXMLTable;
    function Get_Smatrix: IXMLTable;
    function Get_Eigenvalues: IXMLVector;
    function Get_Thetanp: IXMLVector;
    function Get_Exnpeta: IXMLVector;
    function Get_Covnpeta: IXMLTable;
    function Get_Omeganp: IXMLTable;
    function Get_Covnpetac: IXMLTable;
    function Get_Omeganpc: IXMLTable;
    procedure Set_Number(Value: Integer);
    procedure Set_Type_(Value: Integer);
    procedure Set_Table_series(Value: Integer);
    procedure Set_Estimation_method(Value: WideString);
    procedure Set_Estimation_title(Value: WideString);
    procedure Set_Termination_status(Value: Integer);
    procedure Set_Termination_information(Value: WideString);
    procedure Set_Estimation_elapsed_time(Value: Double);
    procedure Set_Covariance_information(Value: WideString);
    procedure Set_Covariance_elapsed_time(Value: Double);
    procedure Set_Final_objective_function_text(Value: WideString);
    procedure Set_Final_objective_function(Value: Double);
    procedure Set_Final_objective_function_std(Value: Double);
    { Methods & Properties }
    property Number: Integer read Get_Number write Set_Number;
    property Type_: Integer read Get_Type_ write Set_Type_;
    property Parallel_est: IXMLParallel_est read Get_Parallel_est;
    property Table_series: Integer read Get_Table_series write Set_Table_series;
    property Estimation_method: WideString read Get_Estimation_method write Set_Estimation_method;
    property Estimation_title: WideString read Get_Estimation_title write Set_Estimation_title;
    property Monitor: IXMLMonitor read Get_Monitor;
    property Termination_status: Integer read Get_Termination_status write Set_Termination_status;
    property Termination_information: WideString read Get_Termination_information write Set_Termination_information;
    property Etabar: IXMLTable read Get_Etabar;
    property Etabarse: IXMLTable read Get_Etabarse;
    property Etabarpval: IXMLTable read Get_Etabarpval;
    property Etashrink: IXMLTable read Get_Etashrink;
    property Epsshrink: IXMLTable read Get_Epsshrink;
    property Estimation_elapsed_time: Double read Get_Estimation_elapsed_time write Set_Estimation_elapsed_time;
    property Parallel_cov: IXMLParallel_cov read Get_Parallel_cov;
    property Covariance_information: WideString read Get_Covariance_information write Set_Covariance_information;
    property Covariance_status: IXMLCovariance_status read Get_Covariance_status;
    property Covariance_elapsed_time: Double read Get_Covariance_elapsed_time write Set_Covariance_elapsed_time;
    property Final_objective_function_text: WideString read Get_Final_objective_function_text write Set_Final_objective_function_text;
    property Final_objective_function: Double read Get_Final_objective_function write Set_Final_objective_function;
    property Final_objective_function_std: Double read Get_Final_objective_function_std write Set_Final_objective_function_std;
    property Theta: IXMLVector read Get_Theta;
    property Omega: IXMLTable read Get_Omega;
    property Sigma: IXMLTable read Get_Sigma;
    property Omegac: IXMLTable read Get_Omegac;
    property Sigmac: IXMLTable read Get_Sigmac;
    property Thetase: IXMLVector read Get_Thetase;
    property Omegase: IXMLTable read Get_Omegase;
    property Sigmase: IXMLTable read Get_Sigmase;
    property Omegacse: IXMLTable read Get_Omegacse;
    property Sigmacse: IXMLTable read Get_Sigmacse;
    property Covariance: IXMLTable read Get_Covariance;
    property Correlation: IXMLTable read Get_Correlation;
    property Invcovariance: IXMLTable read Get_Invcovariance;
    property Rmatrix: IXMLTable read Get_Rmatrix;
    property Smatrix: IXMLTable read Get_Smatrix;
    property Eigenvalues: IXMLVector read Get_Eigenvalues;
    property Thetanp: IXMLVector read Get_Thetanp;
    property Exnpeta: IXMLVector read Get_Exnpeta;
    property Covnpeta: IXMLTable read Get_Covnpeta;
    property Omeganp: IXMLTable read Get_Omeganp;
    property Covnpetac: IXMLTable read Get_Covnpetac;
    property Omeganpc: IXMLTable read Get_Omeganpc;
  end;

{ IXMLEstimationList }

  IXMLEstimationList = interface(IXMLNodeCollection)
    ['{B4F969E4-001D-4E16-AD0A-DF57D7FD89B8}']
    { Methods & Properties }
    function Add: IXMLEstimation;
    function Insert(const Index: Integer): IXMLEstimation;
    function Get_Item(Index: Integer): IXMLEstimation;
    property Items[Index: Integer]: IXMLEstimation read Get_Item; default;
  end;

{ IXMLParallel_est }

  IXMLParallel_est = interface(IXMLNode)
    ['{4C45E5BA-8456-4DD9-80A8-068E6F88DAE3}']
    { Property Accessors }
    function Get_Parafile: WideString;
    function Get_Protocol: WideString;
    function Get_Nodes: Integer;
    procedure Set_Parafile(Value: WideString);
    procedure Set_Protocol(Value: WideString);
    procedure Set_Nodes(Value: Integer);
    { Methods & Properties }
    property Parafile: WideString read Get_Parafile write Set_Parafile;
    property Protocol: WideString read Get_Protocol write Set_Protocol;
    property Nodes: Integer read Get_Nodes write Set_Nodes;
  end;

{ IXMLMonitor }

  IXMLMonitor = interface(IXMLNodeCollection)
    ['{5E06E7E6-9CB0-420B-95B1-063DB8F93FE9}']
    { Property Accessors }
    function Get_Obj(Index: Integer): IXMLObj;
    { Methods & Properties }
    function Add: IXMLObj;
    function Insert(const Index: Integer): IXMLObj;
    property Obj[Index: Integer]: IXMLObj read Get_Obj; default;
  end;

{ IXMLObj }

  IXMLObj = interface(IXMLNode)
    ['{2A045255-2AB0-4DAB-BE6B-ABAE29C2EAE6}']
    { Property Accessors }
    function Get_Iteration: Integer;
    function Get_Sample: Double;
    function Get_Effective: Double;
    function Get_Fitness: Double;
    procedure Set_Iteration(Value: Integer);
    procedure Set_Sample(Value: Double);
    procedure Set_Effective(Value: Double);
    procedure Set_Fitness(Value: Double);
    { Methods & Properties }
    property Iteration: Integer read Get_Iteration write Set_Iteration;
    property Sample: Double read Get_Sample write Set_Sample;
    property Effective: Double read Get_Effective write Set_Effective;
    property Fitness: Double read Get_Fitness write Set_Fitness;
  end;

{ IXMLTable }

  IXMLTable = interface(IXMLNode)
    ['{939B2598-B537-4428-BAB0-8047E90EF3C3}']
    { Property Accessors }
    function Get_Number: Integer;
    function Get_Title: WideString;
    function Get_Row: IXMLRowList;
    procedure Set_Number(Value: Integer);
    procedure Set_Title(Value: WideString);
    { Methods & Properties }
    property Number: Integer read Get_Number write Set_Number;
    property Title: WideString read Get_Title write Set_Title;
    property Row: IXMLRowList read Get_Row;
  end;

{ IXMLTableList }

  IXMLTableList = interface(IXMLNodeCollection)
    ['{68E82028-7BE2-4C4C-A7EC-27679FBF84CC}']
    { Methods & Properties }
    function Add: IXMLTable;
    function Insert(const Index: Integer): IXMLTable;
    function Get_Item(Index: Integer): IXMLTable;
    property Items[Index: Integer]: IXMLTable read Get_Item; default;
  end;

{ IXMLRow }

  IXMLRow = interface(IXMLNodeCollection)
    ['{CDA285BB-CFEF-48D1-9027-17C55938A2BB}']
    { Property Accessors }
    function Get_Rname: WideString;
    function Get_Col(Index: Integer): IXMLCol;
    procedure Set_Rname(Value: WideString);
    { Methods & Properties }
    function Add: IXMLCol;
    function Insert(const Index: Integer): IXMLCol;
    property Rname: WideString read Get_Rname write Set_Rname;
    property Col[Index: Integer]: IXMLCol read Get_Col; default;
  end;

{ IXMLRowList }

  IXMLRowList = interface(IXMLNodeCollection)
    ['{C61333BD-9E30-468E-B31F-08D2044FB1B2}']
    { Methods & Properties }
    function Add: IXMLRow;
    function Insert(const Index: Integer): IXMLRow;
    function Get_Item(Index: Integer): IXMLRow;
    property Items[Index: Integer]: IXMLRow read Get_Item; default;
  end;

{ IXMLCol }

  IXMLCol = interface(IXMLNode)
    ['{099EE63C-AB81-40B9-A605-FDC41048ED86}']
    { Property Accessors }
    function Get_Cname: WideString;
    procedure Set_Cname(Value: WideString);
    { Methods & Properties }
    property Cname: WideString read Get_Cname write Set_Cname;
  end;

{ IXMLParallel_cov }

  IXMLParallel_cov = interface(IXMLNode)
    ['{3726D1E4-CACE-48A2-8237-2C038C2A022D}']
    { Property Accessors }
    function Get_Parafile: WideString;
    function Get_Protocol: WideString;
    function Get_Nodes: Integer;
    procedure Set_Parafile(Value: WideString);
    procedure Set_Protocol(Value: WideString);
    procedure Set_Nodes(Value: Integer);
    { Methods & Properties }
    property Parafile: WideString read Get_Parafile write Set_Parafile;
    property Protocol: WideString read Get_Protocol write Set_Protocol;
    property Nodes: Integer read Get_Nodes write Set_Nodes;
  end;

{ IXMLCovariance_status }

  IXMLCovariance_status = interface(IXMLNode)
    ['{B357B24D-893D-4DAB-BC09-C21499D1CF01}']
    { Property Accessors }
    function Get_Error: Integer;
    function Get_Numnegeigenvalues: Integer;
    function Get_Mineigenvalue: Double;
    function Get_Maxeigenvalue: Double;
    function Get_Rms: Double;
    procedure Set_Error(Value: Integer);
    procedure Set_Numnegeigenvalues(Value: Integer);
    procedure Set_Mineigenvalue(Value: Double);
    procedure Set_Maxeigenvalue(Value: Double);
    procedure Set_Rms(Value: Double);
    { Methods & Properties }
    property Error: Integer read Get_Error write Set_Error;
    property Numnegeigenvalues: Integer read Get_Numnegeigenvalues write Set_Numnegeigenvalues;
    property Mineigenvalue: Double read Get_Mineigenvalue write Set_Mineigenvalue;
    property Maxeigenvalue: Double read Get_Maxeigenvalue write Set_Maxeigenvalue;
    property Rms: Double read Get_Rms write Set_Rms;
  end;

{ IXMLVector }

  IXMLVector = interface(IXMLNode)
    ['{CFBAEA20-6571-42E0-8219-1341E50A3711}']
    { Property Accessors }
    function Get_Number: Integer;
    function Get_Title: WideString;
    function Get_Val: IXMLValList;
    procedure Set_Number(Value: Integer);
    procedure Set_Title(Value: WideString);
    { Methods & Properties }
    property Number: Integer read Get_Number write Set_Number;
    property Title: WideString read Get_Title write Set_Title;
    property Val: IXMLValList read Get_Val;
  end;

{ IXMLVal }

  IXMLVal = interface(IXMLNode)
    ['{C93064B3-C7B3-445D-84B6-C9BCB006118F}']
    { Property Accessors }
    function Get_Name: WideString;
    procedure Set_Name(Value: WideString);
    { Methods & Properties }
    property Name: WideString read Get_Name write Set_Name;
  end;

{ IXMLValList }

  IXMLValList = interface(IXMLNodeCollection)
    ['{19655EC6-B4F2-4EEA-ADB1-1EC714DE20B0}']
    { Methods & Properties }
    function Add: IXMLVal;
    function Insert(const Index: Integer): IXMLVal;
    function Get_Item(Index: Integer): IXMLVal;
    property Items[Index: Integer]: IXMLVal read Get_Item; default;
  end;

{ IXMLScatter }

  IXMLScatter = interface(IXMLNode)
    ['{CF52FD74-ED42-406B-80B5-D24CABA45C64}']
    { Property Accessors }
    function Get_Number: Integer;
    function Get_Ord: WideString;
    function Get_Abs: WideString;
    procedure Set_Number(Value: Integer);
    procedure Set_Ord(Value: WideString);
    procedure Set_Abs(Value: WideString);
    { Methods & Properties }
    property Number: Integer read Get_Number write Set_Number;
    property Ord: WideString read Get_Ord write Set_Ord;
    property Abs: WideString read Get_Abs write Set_Abs;
  end;

{ IXMLScatterList }

  IXMLScatterList = interface(IXMLNodeCollection)
    ['{A4E57631-3C65-429F-9599-97C3EE155503}']
    { Methods & Properties }
    function Add: IXMLScatter;
    function Insert(const Index: Integer): IXMLScatter;
    function Get_Item(Index: Integer): IXMLScatter;
    property Items[Index: Integer]: IXMLScatter read Get_Item; default;
  end;

{ Forward Decls }

  TXMLOutput = class;
  TXMLNonmem = class;
  TXMLProblem = class;
  TXMLProblemList = class;
  TXMLEstimation = class;
  TXMLEstimationList = class;
  TXMLParallel_est = class;
  TXMLMonitor = class;
  TXMLObj = class;
  TXMLTable = class;
  TXMLTableList = class;
  TXMLRow = class;
  TXMLRowList = class;
  TXMLCol = class;
  TXMLParallel_cov = class;
  TXMLCovariance_status = class;
  TXMLVector = class;
  TXMLVal = class;
  TXMLValList = class;
  TXMLScatter = class;
  TXMLScatterList = class;

{ TXMLOutput }

  TXMLOutput = class(TXMLNode, IXMLOutput)
  protected
    { IXMLOutput }
    function Get_Start_datetime: WideString;
    function Get_Control_stream: WideString;
    function Get_Nmtran: WideString;
    function Get_Nonmem: IXMLNonmem;
    function Get_Stop_datetime: WideString;
    procedure Set_Start_datetime(Value: WideString);
    procedure Set_Control_stream(Value: WideString);
    procedure Set_Nmtran(Value: WideString);
    procedure Set_Stop_datetime(Value: WideString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLNonmem }

  TXMLNonmem = class(TXMLNode, IXMLNonmem)
  private
    FProblem: IXMLProblemList;
  protected
    { IXMLNonmem }
    function Get_Version: WideString;
    function Get_License_information: WideString;
    function Get_Program_information: WideString;
    function Get_Problem: IXMLProblemList;
    procedure Set_Version(Value: WideString);
    procedure Set_License_information(Value: WideString);
    procedure Set_Program_information(Value: WideString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLProblem }

  TXMLProblem = class(TXMLNode, IXMLProblem)
  private
    FEstimation: IXMLEstimationList;
    FTable: IXMLTableList;
    FScatter: IXMLScatterList;
  protected
    { IXMLProblem }
    function Get_Number: Integer;
    function Get_Subproblem: Integer;
    function Get_Superproblem1: Integer;
    function Get_Iteration1: Integer;
    function Get_Superproblem2: Integer;
    function Get_Iteration2: Integer;
    function Get_Problem_title: WideString;
    function Get_Problem_information: WideString;
    function Get_Simulation_information: WideString;
    function Get_Estimation: IXMLEstimationList;
    function Get_Table: IXMLTableList;
    function Get_Scatter: IXMLScatterList;
    procedure Set_Number(Value: Integer);
    procedure Set_Subproblem(Value: Integer);
    procedure Set_Superproblem1(Value: Integer);
    procedure Set_Iteration1(Value: Integer);
    procedure Set_Superproblem2(Value: Integer);
    procedure Set_Iteration2(Value: Integer);
    procedure Set_Problem_title(Value: WideString);
    procedure Set_Problem_information(Value: WideString);
    procedure Set_Simulation_information(Value: WideString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLProblemList }

  TXMLProblemList = class(TXMLNodeCollection, IXMLProblemList)
  protected
    { IXMLProblemList }
    function Add: IXMLProblem;
    function Insert(const Index: Integer): IXMLProblem;
    function Get_Item(Index: Integer): IXMLProblem;
  end;

{ TXMLEstimation }

  TXMLEstimation = class(TXMLNode, IXMLEstimation)
  protected
    { IXMLEstimation }
    function Get_Number: Integer;
    function Get_Type_: Integer;
    function Get_Parallel_est: IXMLParallel_est;
    function Get_Table_series: Integer;
    function Get_Estimation_method: WideString;
    function Get_Estimation_title: WideString;
    function Get_Monitor: IXMLMonitor;
    function Get_Termination_status: Integer;
    function Get_Termination_information: WideString;
    function Get_Etabar: IXMLTable;
    function Get_Etabarse: IXMLTable;
    function Get_Etabarpval: IXMLTable;
    function Get_Etashrink: IXMLTable;
    function Get_Epsshrink: IXMLTable;
    function Get_Estimation_elapsed_time: Double;
    function Get_Parallel_cov: IXMLParallel_cov;
    function Get_Covariance_information: WideString;
    function Get_Covariance_status: IXMLCovariance_status;
    function Get_Covariance_elapsed_time: Double;
    function Get_Final_objective_function_text: WideString;
    function Get_Final_objective_function: Double;
    function Get_Final_objective_function_std: Double;
    function Get_Theta: IXMLVector;
    function Get_Omega: IXMLTable;
    function Get_Sigma: IXMLTable;
    function Get_Omegac: IXMLTable;
    function Get_Sigmac: IXMLTable;
    function Get_Thetase: IXMLVector;
    function Get_Omegase: IXMLTable;
    function Get_Sigmase: IXMLTable;
    function Get_Omegacse: IXMLTable;
    function Get_Sigmacse: IXMLTable;
    function Get_Covariance: IXMLTable;
    function Get_Correlation: IXMLTable;
    function Get_Invcovariance: IXMLTable;
    function Get_Rmatrix: IXMLTable;
    function Get_Smatrix: IXMLTable;
    function Get_Eigenvalues: IXMLVector;
    function Get_Thetanp: IXMLVector;
    function Get_Exnpeta: IXMLVector;
    function Get_Covnpeta: IXMLTable;
    function Get_Omeganp: IXMLTable;
    function Get_Covnpetac: IXMLTable;
    function Get_Omeganpc: IXMLTable;
    procedure Set_Number(Value: Integer);
    procedure Set_Type_(Value: Integer);
    procedure Set_Table_series(Value: Integer);
    procedure Set_Estimation_method(Value: WideString);
    procedure Set_Estimation_title(Value: WideString);
    procedure Set_Termination_status(Value: Integer);
    procedure Set_Termination_information(Value: WideString);
    procedure Set_Estimation_elapsed_time(Value: Double);
    procedure Set_Covariance_information(Value: WideString);
    procedure Set_Covariance_elapsed_time(Value: Double);
    procedure Set_Final_objective_function_text(Value: WideString);
    procedure Set_Final_objective_function(Value: Double);
    procedure Set_Final_objective_function_std(Value: Double);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLEstimationList }

  TXMLEstimationList = class(TXMLNodeCollection, IXMLEstimationList)
  protected
    { IXMLEstimationList }
    function Add: IXMLEstimation;
    function Insert(const Index: Integer): IXMLEstimation;
    function Get_Item(Index: Integer): IXMLEstimation;
  end;

{ TXMLParallel_est }

  TXMLParallel_est = class(TXMLNode, IXMLParallel_est)
  protected
    { IXMLParallel_est }
    function Get_Parafile: WideString;
    function Get_Protocol: WideString;
    function Get_Nodes: Integer;
    procedure Set_Parafile(Value: WideString);
    procedure Set_Protocol(Value: WideString);
    procedure Set_Nodes(Value: Integer);
  end;

{ TXMLMonitor }

  TXMLMonitor = class(TXMLNodeCollection, IXMLMonitor)
  protected
    { IXMLMonitor }
    function Get_Obj(Index: Integer): IXMLObj;
    function Add: IXMLObj;
    function Insert(const Index: Integer): IXMLObj;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLObj }

  TXMLObj = class(TXMLNode, IXMLObj)
  protected
    { IXMLObj }
    function Get_Iteration: Integer;
    function Get_Sample: Double;
    function Get_Effective: Double;
    function Get_Fitness: Double;
    procedure Set_Iteration(Value: Integer);
    procedure Set_Sample(Value: Double);
    procedure Set_Effective(Value: Double);
    procedure Set_Fitness(Value: Double);
  end;

{ TXMLTable }

  TXMLTable = class(TXMLNode, IXMLTable)
  private
    FRow: IXMLRowList;
  protected
    { IXMLTable }
    function Get_Number: Integer;
    function Get_Title: WideString;
    function Get_Row: IXMLRowList;
    procedure Set_Number(Value: Integer);
    procedure Set_Title(Value: WideString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLTableList }

  TXMLTableList = class(TXMLNodeCollection, IXMLTableList)
  protected
    { IXMLTableList }
    function Add: IXMLTable;
    function Insert(const Index: Integer): IXMLTable;
    function Get_Item(Index: Integer): IXMLTable;
  end;

{ TXMLRow }

  TXMLRow = class(TXMLNodeCollection, IXMLRow)
  protected
    { IXMLRow }
    function Get_Rname: WideString;
    function Get_Col(Index: Integer): IXMLCol;
    procedure Set_Rname(Value: WideString);
    function Add: IXMLCol;
    function Insert(const Index: Integer): IXMLCol;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLRowList }

  TXMLRowList = class(TXMLNodeCollection, IXMLRowList)
  protected
    { IXMLRowList }
    function Add: IXMLRow;
    function Insert(const Index: Integer): IXMLRow;
    function Get_Item(Index: Integer): IXMLRow;
  end;

{ TXMLCol }

  TXMLCol = class(TXMLNode, IXMLCol)
  protected
    { IXMLCol }
    function Get_Cname: WideString;
    procedure Set_Cname(Value: WideString);
  end;

{ TXMLParallel_cov }

  TXMLParallel_cov = class(TXMLNode, IXMLParallel_cov)
  protected
    { IXMLParallel_cov }
    function Get_Parafile: WideString;
    function Get_Protocol: WideString;
    function Get_Nodes: Integer;
    procedure Set_Parafile(Value: WideString);
    procedure Set_Protocol(Value: WideString);
    procedure Set_Nodes(Value: Integer);
  end;

{ TXMLCovariance_status }

  TXMLCovariance_status = class(TXMLNode, IXMLCovariance_status)
  protected
    { IXMLCovariance_status }
    function Get_Error: Integer;
    function Get_Numnegeigenvalues: Integer;
    function Get_Mineigenvalue: Double;
    function Get_Maxeigenvalue: Double;
    function Get_Rms: Double;
    procedure Set_Error(Value: Integer);
    procedure Set_Numnegeigenvalues(Value: Integer);
    procedure Set_Mineigenvalue(Value: Double);
    procedure Set_Maxeigenvalue(Value: Double);
    procedure Set_Rms(Value: Double);
  end;

{ TXMLVector }

  TXMLVector = class(TXMLNode, IXMLVector)
  private
    FVal: IXMLValList;
  protected
    { IXMLVector }
    function Get_Number: Integer;
    function Get_Title: WideString;
    function Get_Val: IXMLValList;
    procedure Set_Number(Value: Integer);
    procedure Set_Title(Value: WideString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLVal }

  TXMLVal = class(TXMLNode, IXMLVal)
  protected
    { IXMLVal }
    function Get_Name: WideString;
    procedure Set_Name(Value: WideString);
  end;

{ TXMLValList }

  TXMLValList = class(TXMLNodeCollection, IXMLValList)
  protected
    { IXMLValList }
    function Add: IXMLVal;
    function Insert(const Index: Integer): IXMLVal;
    function Get_Item(Index: Integer): IXMLVal;
  end;

{ TXMLScatter }

  TXMLScatter = class(TXMLNode, IXMLScatter)
  protected
    { IXMLScatter }
    function Get_Number: Integer;
    function Get_Ord: WideString;
    function Get_Abs: WideString;
    procedure Set_Number(Value: Integer);
    procedure Set_Ord(Value: WideString);
    procedure Set_Abs(Value: WideString);
  end;

{ TXMLScatterList }

  TXMLScatterList = class(TXMLNodeCollection, IXMLScatterList)
  protected
    { IXMLScatterList }
    function Add: IXMLScatter;
    function Insert(const Index: Integer): IXMLScatter;
    function Get_Item(Index: Integer): IXMLScatter;
  end;

{ Global Functions }

function Getoutput(Doc: IXMLDocument): IXMLOutput;
function Loadoutput(const FileName: WideString): IXMLOutput;
function Newoutput: IXMLOutput;

const
  TargetNamespace = 'http://namespaces.oreilly.com/xmlnut/address';

implementation

{ Global Functions }

function Getoutput(Doc: IXMLDocument): IXMLOutput;
begin
  Result := Doc.GetDocBinding('output', TXMLOutput, TargetNamespace) as IXMLOutput;
end;

function Loadoutput(const FileName: WideString): IXMLOutput;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('output', TXMLOutput, TargetNamespace) as IXMLOutput;
end;

function Newoutput: IXMLOutput;
begin
  Result := NewXMLDocument.GetDocBinding('output', TXMLOutput, TargetNamespace) as IXMLOutput;
end;

{ TXMLOutput }

procedure TXMLOutput.AfterConstruction;
begin
  RegisterChildNode('nonmem', TXMLNonmem);
  inherited;
end;

function TXMLOutput.Get_Start_datetime: WideString;
begin
  Result := ChildNodes['start_datetime'].Text;
end;

procedure TXMLOutput.Set_Start_datetime(Value: WideString);
begin
  ChildNodes['start_datetime'].NodeValue := Value;
end;

function TXMLOutput.Get_Control_stream: WideString;
begin
  Result := ChildNodes['control_stream'].Text;
end;

procedure TXMLOutput.Set_Control_stream(Value: WideString);
begin
  ChildNodes['control_stream'].NodeValue := Value;
end;

function TXMLOutput.Get_Nmtran: WideString;
begin
  Result := ChildNodes['nmtran'].Text;
end;

procedure TXMLOutput.Set_Nmtran(Value: WideString);
begin
  ChildNodes['nmtran'].NodeValue := Value;
end;

function TXMLOutput.Get_Nonmem: IXMLNonmem;
begin
  Result := ChildNodes['nonmem'] as IXMLNonmem;
end;

function TXMLOutput.Get_Stop_datetime: WideString;
begin
  Result := ChildNodes['stop_datetime'].Text;
end;

procedure TXMLOutput.Set_Stop_datetime(Value: WideString);
begin
  ChildNodes['stop_datetime'].NodeValue := Value;
end;

{ TXMLNonmem }

procedure TXMLNonmem.AfterConstruction;
begin
  RegisterChildNode('problem', TXMLProblem);
  FProblem := CreateCollection(TXMLProblemList, IXMLProblem, 'problem') as IXMLProblemList;
  inherited;
end;

function TXMLNonmem.Get_Version: WideString;
begin
  Result := AttributeNodes['version'].Text;
end;

procedure TXMLNonmem.Set_Version(Value: WideString);
begin
  SetAttribute('version', Value);
end;

function TXMLNonmem.Get_License_information: WideString;
begin
  Result := ChildNodes['license_information'].Text;
end;

procedure TXMLNonmem.Set_License_information(Value: WideString);
begin
  ChildNodes['license_information'].NodeValue := Value;
end;

function TXMLNonmem.Get_Program_information: WideString;
begin
  Result := ChildNodes['program_information'].Text;
end;

procedure TXMLNonmem.Set_Program_information(Value: WideString);
begin
  ChildNodes['program_information'].NodeValue := Value;
end;

function TXMLNonmem.Get_Problem: IXMLProblemList;
begin
  Result := FProblem;
end;

{ TXMLProblem }

procedure TXMLProblem.AfterConstruction;
begin
  RegisterChildNode('estimation', TXMLEstimation);
  RegisterChildNode('table', TXMLTable);
  RegisterChildNode('scatter', TXMLScatter);
  FEstimation := CreateCollection(TXMLEstimationList, IXMLEstimation, 'estimation') as IXMLEstimationList;
  FTable := CreateCollection(TXMLTableList, IXMLTable, 'table') as IXMLTableList;
  FScatter := CreateCollection(TXMLScatterList, IXMLScatter, 'scatter') as IXMLScatterList;
  inherited;
end;

function TXMLProblem.Get_Number: Integer;
begin
  Result := AttributeNodes['number'].NodeValue;
end;

procedure TXMLProblem.Set_Number(Value: Integer);
begin
  SetAttribute('number', Value);
end;

function TXMLProblem.Get_Subproblem: Integer;
begin
  Result := AttributeNodes['subproblem'].NodeValue;
end;

procedure TXMLProblem.Set_Subproblem(Value: Integer);
begin
  SetAttribute('subproblem', Value);
end;

function TXMLProblem.Get_Superproblem1: Integer;
begin
  Result := AttributeNodes['superproblem1'].NodeValue;
end;

procedure TXMLProblem.Set_Superproblem1(Value: Integer);
begin
  SetAttribute('superproblem1', Value);
end;

function TXMLProblem.Get_Iteration1: Integer;
begin
  Result := AttributeNodes['iteration1'].NodeValue;
end;

procedure TXMLProblem.Set_Iteration1(Value: Integer);
begin
  SetAttribute('iteration1', Value);
end;

function TXMLProblem.Get_Superproblem2: Integer;
begin
  Result := AttributeNodes['superproblem2'].NodeValue;
end;

procedure TXMLProblem.Set_Superproblem2(Value: Integer);
begin
  SetAttribute('superproblem2', Value);
end;

function TXMLProblem.Get_Iteration2: Integer;
begin
  Result := AttributeNodes['iteration2'].NodeValue;
end;

procedure TXMLProblem.Set_Iteration2(Value: Integer);
begin
  SetAttribute('iteration2', Value);
end;

function TXMLProblem.Get_Problem_title: WideString;
begin
  Result := ChildNodes['problem_title'].Text;
end;

procedure TXMLProblem.Set_Problem_title(Value: WideString);
begin
  ChildNodes['problem_title'].NodeValue := Value;
end;

function TXMLProblem.Get_Problem_information: WideString;
begin
  Result := ChildNodes['problem_information'].Text;
end;

procedure TXMLProblem.Set_Problem_information(Value: WideString);
begin
  ChildNodes['problem_information'].NodeValue := Value;
end;

function TXMLProblem.Get_Simulation_information: WideString;
begin
  Result := ChildNodes['simulation_information'].Text;
end;

procedure TXMLProblem.Set_Simulation_information(Value: WideString);
begin
  ChildNodes['simulation_information'].NodeValue := Value;
end;

function TXMLProblem.Get_Estimation: IXMLEstimationList;
begin
  Result := FEstimation;
end;

function TXMLProblem.Get_Table: IXMLTableList;
begin
  Result := FTable;
end;

function TXMLProblem.Get_Scatter: IXMLScatterList;
begin
  Result := FScatter;
end;

{ TXMLProblemList }

function TXMLProblemList.Add: IXMLProblem;
begin
  Result := AddItem(-1) as IXMLProblem;
end;

function TXMLProblemList.Insert(const Index: Integer): IXMLProblem;
begin
  Result := AddItem(Index) as IXMLProblem;
end;
function TXMLProblemList.Get_Item(Index: Integer): IXMLProblem;
begin
  Result := List[Index] as IXMLProblem;
end;

{ TXMLEstimation }

procedure TXMLEstimation.AfterConstruction;
begin
  RegisterChildNode('parallel_est', TXMLParallel_est);
  RegisterChildNode('monitor', TXMLMonitor);
  RegisterChildNode('etabar', TXMLTable);
  RegisterChildNode('etabarse', TXMLTable);
  RegisterChildNode('etabarpval', TXMLTable);
  RegisterChildNode('etashrink', TXMLTable);
  RegisterChildNode('epsshrink', TXMLTable);
  RegisterChildNode('parallel_cov', TXMLParallel_cov);
  RegisterChildNode('covariance_status', TXMLCovariance_status);
  RegisterChildNode('theta', TXMLVector);
  RegisterChildNode('omega', TXMLTable);
  RegisterChildNode('sigma', TXMLTable);
  RegisterChildNode('omegac', TXMLTable);
  RegisterChildNode('sigmac', TXMLTable);
  RegisterChildNode('thetase', TXMLVector);
  RegisterChildNode('omegase', TXMLTable);
  RegisterChildNode('sigmase', TXMLTable);
  RegisterChildNode('omegacse', TXMLTable);
  RegisterChildNode('sigmacse', TXMLTable);
  RegisterChildNode('covariance', TXMLTable);
  RegisterChildNode('correlation', TXMLTable);
  RegisterChildNode('invcovariance', TXMLTable);
  RegisterChildNode('rmatrix', TXMLTable);
  RegisterChildNode('smatrix', TXMLTable);
  RegisterChildNode('eigenvalues', TXMLVector);
  RegisterChildNode('thetanp', TXMLVector);
  RegisterChildNode('exnpeta', TXMLVector);
  RegisterChildNode('covnpeta', TXMLTable);
  RegisterChildNode('omeganp', TXMLTable);
  RegisterChildNode('covnpetac', TXMLTable);
  RegisterChildNode('omeganpc', TXMLTable);
  inherited;
end;

function TXMLEstimation.Get_Number: Integer;
begin
  Result := AttributeNodes['number'].NodeValue;
end;

procedure TXMLEstimation.Set_Number(Value: Integer);
begin
  SetAttribute('number', Value);
end;

function TXMLEstimation.Get_Type_: Integer;
begin
  Result := AttributeNodes['type'].NodeValue;
end;

procedure TXMLEstimation.Set_Type_(Value: Integer);
begin
  SetAttribute('type', Value);
end;

function TXMLEstimation.Get_Parallel_est: IXMLParallel_est;
begin
  Result := ChildNodes['parallel_est'] as IXMLParallel_est;
end;

function TXMLEstimation.Get_Table_series: Integer;
begin
  Result := ChildNodes['table_series'].NodeValue;
end;

procedure TXMLEstimation.Set_Table_series(Value: Integer);
begin
  ChildNodes['table_series'].NodeValue := Value;
end;

function TXMLEstimation.Get_Estimation_method: WideString;
begin
  Result := ChildNodes['estimation_method'].Text;
end;

procedure TXMLEstimation.Set_Estimation_method(Value: WideString);
begin
  ChildNodes['estimation_method'].NodeValue := Value;
end;

function TXMLEstimation.Get_Estimation_title: WideString;
begin
  Result := ChildNodes['estimation_title'].Text;
end;

procedure TXMLEstimation.Set_Estimation_title(Value: WideString);
begin
  ChildNodes['estimation_title'].NodeValue := Value;
end;

function TXMLEstimation.Get_Monitor: IXMLMonitor;
begin
  Result := ChildNodes['monitor'] as IXMLMonitor;
end;

function TXMLEstimation.Get_Termination_status: Integer;
begin
  Result := ChildNodes['termination_status'].NodeValue;
end;

procedure TXMLEstimation.Set_Termination_status(Value: Integer);
begin
  ChildNodes['termination_status'].NodeValue := Value;
end;

function TXMLEstimation.Get_Termination_information: WideString;
begin
  Result := ChildNodes['termination_information'].Text;
end;

procedure TXMLEstimation.Set_Termination_information(Value: WideString);
begin
  ChildNodes['termination_information'].NodeValue := Value;
end;

function TXMLEstimation.Get_Etabar: IXMLTable;
begin
  Result := ChildNodes['etabar'] as IXMLTable;
end;

function TXMLEstimation.Get_Etabarse: IXMLTable;
begin
  Result := ChildNodes['etabarse'] as IXMLTable;
end;

function TXMLEstimation.Get_Etabarpval: IXMLTable;
begin
  Result := ChildNodes['etabarpval'] as IXMLTable;
end;

function TXMLEstimation.Get_Etashrink: IXMLTable;
begin
  Result := ChildNodes['etashrink'] as IXMLTable;
end;

function TXMLEstimation.Get_Epsshrink: IXMLTable;
begin
  Result := ChildNodes['epsshrink'] as IXMLTable;
end;

function TXMLEstimation.Get_Estimation_elapsed_time: Double;
begin
  Result := ChildNodes['estimation_elapsed_time'].NodeValue;
end;

procedure TXMLEstimation.Set_Estimation_elapsed_time(Value: Double);
begin
  ChildNodes['estimation_elapsed_time'].NodeValue := Value;
end;

function TXMLEstimation.Get_Parallel_cov: IXMLParallel_cov;
begin
  Result := ChildNodes['parallel_cov'] as IXMLParallel_cov;
end;

function TXMLEstimation.Get_Covariance_information: WideString;
begin
  Result := ChildNodes['covariance_information'].Text;
end;

procedure TXMLEstimation.Set_Covariance_information(Value: WideString);
begin
  ChildNodes['covariance_information'].NodeValue := Value;
end;

function TXMLEstimation.Get_Covariance_status: IXMLCovariance_status;
begin
  Result := ChildNodes['covariance_status'] as IXMLCovariance_status;
end;

function TXMLEstimation.Get_Covariance_elapsed_time: Double;
begin
  Result := ChildNodes['covariance_elapsed_time'].NodeValue;
end;

procedure TXMLEstimation.Set_Covariance_elapsed_time(Value: Double);
begin
  ChildNodes['covariance_elapsed_time'].NodeValue := Value;
end;

function TXMLEstimation.Get_Final_objective_function_text: WideString;
begin
  Result := ChildNodes['final_objective_function_text'].Text;
end;

procedure TXMLEstimation.Set_Final_objective_function_text(Value: WideString);
begin
  ChildNodes['final_objective_function_text'].NodeValue := Value;
end;

function TXMLEstimation.Get_Final_objective_function: Double;
begin
  Result := ChildNodes['final_objective_function'].NodeValue;
end;

procedure TXMLEstimation.Set_Final_objective_function(Value: Double);
begin
  ChildNodes['final_objective_function'].NodeValue := Value;
end;

function TXMLEstimation.Get_Final_objective_function_std: Double;
begin
  Result := ChildNodes['final_objective_function_std'].NodeValue;
end;

procedure TXMLEstimation.Set_Final_objective_function_std(Value: Double);
begin
  ChildNodes['final_objective_function_std'].NodeValue := Value;
end;

function TXMLEstimation.Get_Theta: IXMLVector;
begin
  Result := ChildNodes['theta'] as IXMLVector;
end;

function TXMLEstimation.Get_Omega: IXMLTable;
begin
  Result := ChildNodes['omega'] as IXMLTable;
end;

function TXMLEstimation.Get_Sigma: IXMLTable;
begin
  Result := ChildNodes['sigma'] as IXMLTable;
end;

function TXMLEstimation.Get_Omegac: IXMLTable;
begin
  Result := ChildNodes['omegac'] as IXMLTable;
end;

function TXMLEstimation.Get_Sigmac: IXMLTable;
begin
  Result := ChildNodes['sigmac'] as IXMLTable;
end;

function TXMLEstimation.Get_Thetase: IXMLVector;
begin
  Result := ChildNodes['thetase'] as IXMLVector;
end;

function TXMLEstimation.Get_Omegase: IXMLTable;
begin
  Result := ChildNodes['omegase'] as IXMLTable;
end;

function TXMLEstimation.Get_Sigmase: IXMLTable;
begin
  Result := ChildNodes['sigmase'] as IXMLTable;
end;

function TXMLEstimation.Get_Omegacse: IXMLTable;
begin
  Result := ChildNodes['omegacse'] as IXMLTable;
end;

function TXMLEstimation.Get_Sigmacse: IXMLTable;
begin
  Result := ChildNodes['sigmacse'] as IXMLTable;
end;

function TXMLEstimation.Get_Covariance: IXMLTable;
begin
  Result := ChildNodes['covariance'] as IXMLTable;
end;

function TXMLEstimation.Get_Correlation: IXMLTable;
begin
  Result := ChildNodes['correlation'] as IXMLTable;
end;

function TXMLEstimation.Get_Invcovariance: IXMLTable;
begin
  Result := ChildNodes['invcovariance'] as IXMLTable;
end;

function TXMLEstimation.Get_Rmatrix: IXMLTable;
begin
  Result := ChildNodes['rmatrix'] as IXMLTable;
end;

function TXMLEstimation.Get_Smatrix: IXMLTable;
begin
  Result := ChildNodes['smatrix'] as IXMLTable;
end;

function TXMLEstimation.Get_Eigenvalues: IXMLVector;
begin
  Result := ChildNodes['eigenvalues'] as IXMLVector;
end;

function TXMLEstimation.Get_Thetanp: IXMLVector;
begin
  Result := ChildNodes['thetanp'] as IXMLVector;
end;

function TXMLEstimation.Get_Exnpeta: IXMLVector;
begin
  Result := ChildNodes['exnpeta'] as IXMLVector;
end;

function TXMLEstimation.Get_Covnpeta: IXMLTable;
begin
  Result := ChildNodes['covnpeta'] as IXMLTable;
end;

function TXMLEstimation.Get_Omeganp: IXMLTable;
begin
  Result := ChildNodes['omeganp'] as IXMLTable;
end;

function TXMLEstimation.Get_Covnpetac: IXMLTable;
begin
  Result := ChildNodes['covnpetac'] as IXMLTable;
end;

function TXMLEstimation.Get_Omeganpc: IXMLTable;
begin
  Result := ChildNodes['omeganpc'] as IXMLTable;
end;

{ TXMLEstimationList }

function TXMLEstimationList.Add: IXMLEstimation;
begin
  Result := AddItem(-1) as IXMLEstimation;
end;

function TXMLEstimationList.Insert(const Index: Integer): IXMLEstimation;
begin
  Result := AddItem(Index) as IXMLEstimation;
end;
function TXMLEstimationList.Get_Item(Index: Integer): IXMLEstimation;
begin
  Result := List[Index] as IXMLEstimation;
end;

{ TXMLParallel_est }

function TXMLParallel_est.Get_Parafile: WideString;
begin
  Result := AttributeNodes['parafile'].Text;
end;

procedure TXMLParallel_est.Set_Parafile(Value: WideString);
begin
  SetAttribute('parafile', Value);
end;

function TXMLParallel_est.Get_Protocol: WideString;
begin
  Result := AttributeNodes['protocol'].Text;
end;

procedure TXMLParallel_est.Set_Protocol(Value: WideString);
begin
  SetAttribute('protocol', Value);
end;

function TXMLParallel_est.Get_Nodes: Integer;
begin
  Result := AttributeNodes['nodes'].NodeValue;
end;

procedure TXMLParallel_est.Set_Nodes(Value: Integer);
begin
  SetAttribute('nodes', Value);
end;

{ TXMLMonitor }

procedure TXMLMonitor.AfterConstruction;
begin
  RegisterChildNode('obj', TXMLObj);
  ItemTag := 'obj';
  ItemInterface := IXMLObj;
  inherited;
end;

function TXMLMonitor.Get_Obj(Index: Integer): IXMLObj;
begin
  Result := List[Index] as IXMLObj;
end;

function TXMLMonitor.Add: IXMLObj;
begin
  Result := AddItem(-1) as IXMLObj;
end;

function TXMLMonitor.Insert(const Index: Integer): IXMLObj;
begin
  Result := AddItem(Index) as IXMLObj;
end;

{ TXMLObj }

function TXMLObj.Get_Iteration: Integer;
begin
  Result := AttributeNodes['iteration'].NodeValue;
end;

procedure TXMLObj.Set_Iteration(Value: Integer);
begin
  SetAttribute('iteration', Value);
end;

function TXMLObj.Get_Sample: Double;
begin
  Result := AttributeNodes['sample'].NodeValue;
end;

procedure TXMLObj.Set_Sample(Value: Double);
begin
  SetAttribute('sample', Value);
end;

function TXMLObj.Get_Effective: Double;
begin
  Result := AttributeNodes['effective'].NodeValue;
end;

procedure TXMLObj.Set_Effective(Value: Double);
begin
  SetAttribute('effective', Value);
end;

function TXMLObj.Get_Fitness: Double;
begin
  Result := AttributeNodes['fitness'].NodeValue;
end;

procedure TXMLObj.Set_Fitness(Value: Double);
begin
  SetAttribute('fitness', Value);
end;

{ TXMLTable }

procedure TXMLTable.AfterConstruction;
begin
  RegisterChildNode('row', TXMLRow);
  FRow := CreateCollection(TXMLRowList, IXMLRow, 'row') as IXMLRowList;
  inherited;
end;

function TXMLTable.Get_Number: Integer;
begin
  Result := AttributeNodes['number'].NodeValue;
end;

procedure TXMLTable.Set_Number(Value: Integer);
begin
  SetAttribute('number', Value);
end;

function TXMLTable.Get_Title: WideString;
begin
  Result := ChildNodes['title'].Text;
end;

procedure TXMLTable.Set_Title(Value: WideString);
begin
  ChildNodes['title'].NodeValue := Value;
end;

function TXMLTable.Get_Row: IXMLRowList;
begin
  Result := FRow;
end;

{ TXMLTableList }

function TXMLTableList.Add: IXMLTable;
begin
  Result := AddItem(-1) as IXMLTable;
end;

function TXMLTableList.Insert(const Index: Integer): IXMLTable;
begin
  Result := AddItem(Index) as IXMLTable;
end;
function TXMLTableList.Get_Item(Index: Integer): IXMLTable;
begin
  Result := List[Index] as IXMLTable;
end;

{ TXMLRow }

procedure TXMLRow.AfterConstruction;
begin
  RegisterChildNode('col', TXMLCol);
  ItemTag := 'col';
  ItemInterface := IXMLCol;
  inherited;
end;

function TXMLRow.Get_Rname: WideString;
begin
  Result := AttributeNodes['rname'].Text;
end;

procedure TXMLRow.Set_Rname(Value: WideString);
begin
  SetAttribute('rname', Value);
end;

function TXMLRow.Get_Col(Index: Integer): IXMLCol;
begin
  Result := List[Index] as IXMLCol;
end;

function TXMLRow.Add: IXMLCol;
begin
  Result := AddItem(-1) as IXMLCol;
end;

function TXMLRow.Insert(const Index: Integer): IXMLCol;
begin
  Result := AddItem(Index) as IXMLCol;
end;

{ TXMLRowList }

function TXMLRowList.Add: IXMLRow;
begin
  Result := AddItem(-1) as IXMLRow;
end;

function TXMLRowList.Insert(const Index: Integer): IXMLRow;
begin
  Result := AddItem(Index) as IXMLRow;
end;
function TXMLRowList.Get_Item(Index: Integer): IXMLRow;
begin
  Result := List[Index] as IXMLRow;
end;

{ TXMLCol }

function TXMLCol.Get_Cname: WideString;
begin
  Result := AttributeNodes['cname'].Text;
end;

procedure TXMLCol.Set_Cname(Value: WideString);
begin
  SetAttribute('cname', Value);
end;

{ TXMLParallel_cov }

function TXMLParallel_cov.Get_Parafile: WideString;
begin
  Result := AttributeNodes['parafile'].Text;
end;

procedure TXMLParallel_cov.Set_Parafile(Value: WideString);
begin
  SetAttribute('parafile', Value);
end;

function TXMLParallel_cov.Get_Protocol: WideString;
begin
  Result := AttributeNodes['protocol'].Text;
end;

procedure TXMLParallel_cov.Set_Protocol(Value: WideString);
begin
  SetAttribute('protocol', Value);
end;

function TXMLParallel_cov.Get_Nodes: Integer;
begin
  Result := AttributeNodes['nodes'].NodeValue;
end;

procedure TXMLParallel_cov.Set_Nodes(Value: Integer);
begin
  SetAttribute('nodes', Value);
end;

{ TXMLCovariance_status }

function TXMLCovariance_status.Get_Error: Integer;
begin
  Result := AttributeNodes['error'].NodeValue;
end;

procedure TXMLCovariance_status.Set_Error(Value: Integer);
begin
  SetAttribute('error', Value);
end;

function TXMLCovariance_status.Get_Numnegeigenvalues: Integer;
begin
  Result := AttributeNodes['numnegeigenvalues'].NodeValue;
end;

procedure TXMLCovariance_status.Set_Numnegeigenvalues(Value: Integer);
begin
  SetAttribute('numnegeigenvalues', Value);
end;

function TXMLCovariance_status.Get_Mineigenvalue: Double;
begin
  Result := AttributeNodes['mineigenvalue'].NodeValue;
end;

procedure TXMLCovariance_status.Set_Mineigenvalue(Value: Double);
begin
  SetAttribute('mineigenvalue', Value);
end;

function TXMLCovariance_status.Get_Maxeigenvalue: Double;
begin
  Result := AttributeNodes['maxeigenvalue'].NodeValue;
end;

procedure TXMLCovariance_status.Set_Maxeigenvalue(Value: Double);
begin
  SetAttribute('maxeigenvalue', Value);
end;

function TXMLCovariance_status.Get_Rms: Double;
begin
  Result := AttributeNodes['rms'].NodeValue;
end;

procedure TXMLCovariance_status.Set_Rms(Value: Double);
begin
  SetAttribute('rms', Value);
end;

{ TXMLVector }

procedure TXMLVector.AfterConstruction;
begin
  RegisterChildNode('val', TXMLVal);
  FVal := CreateCollection(TXMLValList, IXMLVal, 'val') as IXMLValList;
  inherited;
end;

function TXMLVector.Get_Number: Integer;
begin
  Result := AttributeNodes['number'].NodeValue;
end;

procedure TXMLVector.Set_Number(Value: Integer);
begin
  SetAttribute('number', Value);
end;

function TXMLVector.Get_Title: WideString;
begin
  Result := ChildNodes['title'].Text;
end;

procedure TXMLVector.Set_Title(Value: WideString);
begin
  ChildNodes['title'].NodeValue := Value;
end;

function TXMLVector.Get_Val: IXMLValList;
begin
  Result := FVal;
end;

{ TXMLVal }

function TXMLVal.Get_Name: WideString;
begin
  Result := AttributeNodes['name'].Text;
end;

procedure TXMLVal.Set_Name(Value: WideString);
begin
  SetAttribute('name', Value);
end;

{ TXMLValList }

function TXMLValList.Add: IXMLVal;
begin
  Result := AddItem(-1) as IXMLVal;
end;

function TXMLValList.Insert(const Index: Integer): IXMLVal;
begin
  Result := AddItem(Index) as IXMLVal;
end;
function TXMLValList.Get_Item(Index: Integer): IXMLVal;
begin
  Result := List[Index] as IXMLVal;
end;

{ TXMLScatter }

function TXMLScatter.Get_Number: Integer;
begin
  Result := AttributeNodes['number'].NodeValue;
end;

procedure TXMLScatter.Set_Number(Value: Integer);
begin
  SetAttribute('number', Value);
end;

function TXMLScatter.Get_Ord: WideString;
begin
  Result := AttributeNodes['ord'].Text;
end;

procedure TXMLScatter.Set_Ord(Value: WideString);
begin
  SetAttribute('ord', Value);
end;

function TXMLScatter.Get_Abs: WideString;
begin
  Result := AttributeNodes['abs'].Text;
end;

procedure TXMLScatter.Set_Abs(Value: WideString);
begin
  SetAttribute('abs', Value);
end;

{ TXMLScatterList }

function TXMLScatterList.Add: IXMLScatter;
begin
  Result := AddItem(-1) as IXMLScatter;
end;

function TXMLScatterList.Insert(const Index: Integer): IXMLScatter;
begin
  Result := AddItem(Index) as IXMLScatter;
end;
function TXMLScatterList.Get_Item(Index: Integer): IXMLScatter;
begin
  Result := List[Index] as IXMLScatter;
end;

end.
