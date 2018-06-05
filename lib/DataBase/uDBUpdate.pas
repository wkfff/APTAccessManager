unit uDBUpdate;

interface

uses
  System.SysUtils, System.Classes;

type
  TdmDBUpdate = class(TDataModule)
  private
    { Private declarations }
  public
    { Public declarations }
    Function UpdateTB_CONFIG_Value(aCONFIGGROUP,aCONFIGCODE,aCONFIGVALUE:string;aDetail:string=''):Boolean;
    function UpdateTB_DOORSCHEDULE_All(aNodeNo,aECUID,aDOORNO,aDayCode,a1Time,a2Time,a3Time,a4Time,a5Time,a1Mode,a2Mode,a3Mode,a4Mode,a5Mode,aRcvAck:string):Boolean;
    function UpdateTB_FORMNAME_Field_StringValue(aGubun,aCode,aFieldName,aData:string):Boolean;
    Function UpdateTB_HOLIDAY_Value(aDate,aName,aACType,aATType:string):Boolean;
  end;

var
  dmDBUpdate: TdmDBUpdate;

implementation
uses
  uDataBase,
  uCommonVariable;

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

{ TdmDBUpdate }

function TdmDBUpdate.UpdateTB_CONFIG_Value(aCONFIGGROUP, aCONFIGCODE,
  aCONFIGVALUE, aDetail: string): Boolean;
var
  stSql : string;
begin
  stSql := 'Update TB_CONFIG Set ';
  stSql := stSql + ' CO_CONFIGVALUE = ''' + aCONFIGVALUE + ''' ';
  if aDetail <> '' then stSql := stSql + ' ,CO_CONFIGDETAIL = ''' + aDetail + ''' ';
  stSql := stSql + ' Where GROUP_CODE = ''' + G_stGroupCode + ''' ';
  stSql := stSql + ' AND CO_CONFIGGROUP = ''' + aCONFIGGROUP + ''' ';
  stSql := stSql + ' AND CO_CONFIGCODE = ''' + aCONFIGCODE + ''' ';

  result := dmDataBase.ProcessExecSQL(stSql);
end;

function TdmDBUpdate.UpdateTB_DOORSCHEDULE_All(aNodeNo, aECUID, aDOORNO,
  aDayCode, a1Time, a2Time, a3Time, a4Time, a5Time, a1Mode, a2Mode, a3Mode,
  a4Mode, a5Mode, aRcvAck: string): Boolean;
var
  stSql : string;
begin
  stSql := ' Update TB_DOORSCHEDULE set ';
  stSql := stSql + ' DS_TIME1 = ''' + a1Time + ''',';
  stSql := stSql + ' DS_TIME2 = ''' + a2Time + ''',';
  stSql := stSql + ' DS_TIME3 = ''' + a3Time + ''',';
  stSql := stSql + ' DS_TIME4 = ''' + a4Time + ''',';
  stSql := stSql + ' DS_TIME5 = ''' + a5Time + ''',';
  stSql := stSql + ' DS_TIMEMODE1 = ''' + a1Mode + ''',';
  stSql := stSql + ' DS_TIMEMODE2 = ''' + a2Mode + ''',';
  stSql := stSql + ' DS_TIMEMODE3 = ''' + a3Mode + ''',';
  stSql := stSql + ' DS_TIMEMODE4 = ''' + a4Mode + ''',';
  stSql := stSql + ' DS_TIMEMODE5 = ''' + a5Mode + ''',';
  stSql := stSql + ' DS_UPDATETIME = ''' + FormatDateTime('yyyymmddhhnnss',Now) + ''',';
  stSql := stSql + ' DS_DEVICESYNC = ''' + aRcvAck + ''' ';
  stSql := stSql + ' Where GROUP_CODE = ''' + G_stGroupCode + ''' ';
  stSql := stSql + ' AND ND_NODENO = ' + aNodeNo + ' ';
  stSql := stSql + ' AND DE_ECUID = ''' + aEcuID + ''' ';
  stSql := stSql + ' AND DO_DOORNO = ' + aDoorNo + ' ';
  stSql := stSql + ' AND DS_DAYCODE = ''' + aDayCode + ''' ';

  result := dmDataBase.ProcessExecSQL(stSql);
end;

function TdmDBUpdate.UpdateTB_FORMNAME_Field_StringValue(aGubun, aCode,
  aFieldName, aData: string): Boolean;
var
  stSql : string;
begin
  stSql := 'Update TB_FORMNAME set ' + aFieldName + ' = ''' + aData + ''' ';
  stSql := stSql + ' Where FM_GUBUN = ''' + aGubun + ''' ';
  stSql := stSql + ' AND FM_CODE = ''' + aCode + ''' ';

  result := dmDataBase.ProcessExecSQL(stSql);

end;

function TdmDBUpdate.UpdateTB_HOLIDAY_Value(aDate, aName, aACType,
  aATType: string): Boolean;
var
  stSql : string;
begin
  stSql := 'Update TB_HOLIDAY set HO_NAME' + inttostr(G_nLangeType) + ' = ''' + aName + ''', ';
  stSql := stSql + ' HO_ACUSE = ''' + aACType + ''',';
  stSql := stSql + ' HO_ATUSE = ''' + aATType + '''';
  stSql := stSql + ' Where GROUP_CODE = ''' + G_stGroupCode + ''' ';
  stSql := stSql + ' AND HO_DAY = ''' + aDate + ''' ';

  result := dmDataBase.ProcessExecSQL(stSql);
end;

end.
