unit uDataBaseConfig;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, AdvPanel,
  W7Classes, W7Buttons, Vcl.ImgList,System.iniFiles,Data.DB,Data.Win.ADODB;

type
  TDataBaseConfig = class(TComponent)
  private
    FCancel: Boolean;
    FDBConnected: Boolean;
    class function FindSelf:TComponent;
    procedure SetCancel(const Value: Boolean);
    procedure SetDBConnected(const Value: Boolean);
    procedure TableVersionCheck;
    function GetVersion:integer;
  private
    function Table001VersionMake: Boolean;
    function Table002VersionMake: Boolean;
    function Table003VersionMake: Boolean;

  public
    { Public declarations }
    Procedure ShowDataBaseConfig;
    Function DataBaseConnect(aMessage:Boolean=True):Boolean;
  public
    class Function GetObject:TDataBaseConfig;   //자기자신을 찾는것  class 는 폼생성전에도 사용가능
  Published
    { Published declarations }
    Property Cancel:Boolean read FCancel write SetCancel;
    Property DBConnected : Boolean read FDBConnected write SetDBConnected;
  end;

  TfmDataBaseConfig = class(TForm)
    rg_DBType: TRadioGroup;
    AdvPanel1: TAdvPanel;
    edPasswd: TEdit;
    edDataBaseName: TEdit;
    Label5: TLabel;
    Label4: TLabel;
    edUserid: TEdit;
    Label3: TLabel;
    Label2: TLabel;
    edServerPort: TEdit;
    edServerIP: TEdit;
    Label1: TLabel;
    btn_Save: TW7SpeedButton;
    btn_Close: TW7SpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure btn_SaveClick(Sender: TObject);
    procedure btn_CloseClick(Sender: TObject);
    procedure rg_DBTypeClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmDataBaseConfig: TfmDataBaseConfig;

implementation
uses
  DIMime,
  uCommonVariable,
  uDataBase,
  uDBCreate,
  uDBInsert,
  uDBUpdate;

{$R *.dfm}

{ TDataBaseConfig }

function TDataBaseConfig.DataBaseConnect(aMessage: Boolean): Boolean;
var
  ini_fun : TiniFile;
  stDBHost : string;
  stDBPort : string;
  stDBUserID : string;
  stDBUserPw : string;
  stDBName : string;
  stConnectString : string;
  stConnectString1 : string;
begin
  if DBConnected then Exit;
  result := False;
  CanCel := False;
  G_stExeFolder  := ExtractFileDir(Application.ExeName);
  Try
    ini_fun := TiniFile.Create(G_stExeFolder + '\Config.ini');

    G_nDBType := ini_fun.ReadInteger('DBConfig','TYPE',MDB);

    stDBHost  := ini_fun.ReadString('DBConfig','Host','127.0.0.1');
    stDBPort := ini_fun.ReadString('DBConfig','Port','1433');
    stDBUserID := ini_fun.ReadString('DBConfig','UserID','sa');
    stDBUserPw := MimeDecodeString(ini_fun.ReadString('DBConfig','UserPW',''));  //saPasswd
    stDBName := lowerCase(ini_fun.ReadString('DBConfig','DBNAME',''));
    G_stGroupCode := ini_fun.ReadString('COMPANY','GROUPCODE','1234567890');
    G_nBuildingCodeLength := ini_fun.ReadInteger('COMPANY','BUILDINGCODELENGTH',5);
    G_nMaxComPort := ini_fun.ReadInteger('RS232','MAXPORT',40);
    G_nCardRegisterPort := ini_fun.ReadInteger('FORM','CardRegisterPort',0);
    G_nComDelayTime := ini_fun.ReadInteger('COMConfig','ComDelay',80);
    G_nLangeType := ini_fun.ReadInteger('Config','LangType',1);


    stConnectString := '';
    if G_nDBType = MSSQL then
    begin
      stConnectString := stConnectString + 'Provider=SQLOLEDB.1;';
      stConnectString := stConnectString + 'Password=' + stDBUserPw + ';';
      stConnectString := stConnectString + 'Persist Security Info=True;';
      stConnectString := stConnectString + 'User ID=' + stDBUserID + ';';
      stConnectString := stConnectString + 'Initial Catalog=' + stDBName + ';';
      stConnectString := stConnectString + 'Data Source=' + stDBHost  + ',' + stDBPort;
    end else if G_nDBType = POSTGRESQL then
    begin
      stConnectString := 'Provider=PostgreSQL OLE DB Provider;';
      stConnectString := stConnectString + 'Data Source=' + stDBHost + ';'   ;
      stConnectString := stConnectString + 'location=' + stDBName + ';';
      stConnectString := stConnectString + 'User Id='+ stDBUserID + ';';
      stConnectString := stConnectString + 'password=' + stDBUserPw;
    end else if G_nDBType = FIREBIRD then
    begin
      stConnectString := 'Provider=MSDASQL;';
      stConnectString := stConnectString + 'DRIVER=Firebird/InterBase(r) driver;';
      stConnectString := stConnectString + 'UID=' + stDBUserID + ';';
      stConnectString := stConnectString + 'PWD=' + stDBUserPw + ';';
      stConnectString := stConnectString + 'Auto Commit=true;';
      stConnectString := stConnectString + 'DBNAME=' + stDBHost + ':' + stDBName;
    end else //디폴트로 MDB로 인식하자
    begin
      stConnectString := 'Provider=Microsoft.Jet.OLEDB.4.0;';
      stConnectString := stConnectString + 'Data Source=' + G_stExeFolder + '\..\DB\ACCINFO.mdb' + ';';
      stConnectString := stConnectString + 'Persist Security Info=True;';
      stConnectString := stConnectString + 'Jet OLEDB:Database ';
    end;

    if G_nDBType <> MDB then
    begin
      stConnectString1 := stConnectString;
    end else
    begin
      //MDB 에서는 이벤트 DB 와 정보 DB를 구분하기 위함
      stConnectString1 := 'Provider=Microsoft.Jet.OLEDB.4.0;';
      stConnectString1 := stConnectString1 + 'Data Source=' + G_stExeFolder + '\..\DB\ACCEVENT.mdb' + ';';
      stConnectString1 := stConnectString1 + 'Persist Security Info=True;';
      stConnectString1 := stConnectString1 + 'Jet OLEDB:Database ';
    end;

//showmessage(stConnectString);

    with dmDataBase.ADOConnection do
    begin
      Connected := False;
      Try
        ConnectionString := stConnectString;
        LoginPrompt:= false ;
        Connected := True;
      Except
        on E : EDatabaseError do
          begin
            // ERROR MESSAGE-BOX DISPLAY
            if aMessage then
              ShowMessage(E.Message );
            Exit;
          end;
        else
          begin
            if aMessage then
              ShowMessage('데이터베이스 접속 에러' );
            Exit;
          end;
      End;
      CursorLocation := clUseServer;
      //CursorLocation := clUseClient;
    end;

    with dmDataBase.ADOEventConnection do
    begin
      Connected := False;
      Try
        ConnectionString := stConnectString1;
        LoginPrompt:= false ;
        Connected := True;
      Except
        on E : EDatabaseError do
          begin
            // ERROR MESSAGE-BOX DISPLAY
            if aMessage then
              ShowMessage(E.Message );
            Exit;
          end;
        else
          begin
            if aMessage then
              ShowMessage('데이터베이스 접속 에러' );
            Exit;
          end;
      End;
      CursorLocation := clUseServer;
      //CursorLocation := clUseClient;
    end;
    DBConnected := True;
    TableVersionCheck;
    result := True;
  Finally
    ini_fun.Free;
  End;

end;

class function TDataBaseConfig.FindSelf: TComponent;
var
  Loop:Integer;
begin
  Result:=Nil;
  for Loop:=0 to Application.ComponentCount-1 do begin
      if Application.Components[Loop] is TDataBaseConfig then begin
          Result:= Application.Components[Loop];
          Break;
      end;
  end;
end;

class function TDataBaseConfig.GetObject: TDataBaseConfig;
begin
   If FindSelf = Nil then TDataBaseConfig.Create(Application);
   Result := TDataBaseConfig(FindSelf);
end;

function TDataBaseConfig.GetVersion: integer;
var
  stSql : string;
begin
  result := 0;
  stSql := 'select * from TB_CONFIG ';
  stSql := stSql + ' where CO_CONFIGGROUP = ''COMMON'' ';
  stSql := stSql + ' AND CO_CONFIGCODE = ''TABLE_VER'' ';
  with dmDataBase.ADOTmpQuery do
  begin
    Close;
    Sql.Clear;
    Sql.Text := stSql;
    Try
      Open;
    Except
      Exit;
    End;
    if recordCount < 1 then Exit;
    Try
      result := strtoint(FindField('CO_CONFIGVALUE').AsString);
    Except
      Exit;
    End;
  end;
end;

procedure TDataBaseConfig.SetCancel(const Value: Boolean);
begin
  FCancel := Value;
end;

procedure TDataBaseConfig.SetDBConnected(const Value: Boolean);
begin
  FDBConnected := Value;
end;

procedure TDataBaseConfig.ShowDataBaseConfig;
begin
  FDBConnected := False;

  fmDataBaseConfig:=TfmDataBaseConfig.Create(Nil);
  Try
    fmDataBaseConfig.ShowModal;
  Finally
    fmDataBaseConfig.Free;
  End;
end;

function TDataBaseConfig.Table001VersionMake: Boolean;
begin
  dmDBCreate.CreateTB_CONFIG;
  dmDBInsert.InsertIntoTB_CONFIG_All('COMMON','TABLE_VER','1','테이블 버젼정보');
  dmDBCreate.CreateTB_FORMNAME;
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00001','출입관리시스템','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00002','기본설정','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00003','운영관리','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00004','기타','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00005','코드관리','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00006','기기관리','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00007','출입코드관리','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00008','권한관리','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00009','모니터링','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00010','보고서','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00011','지원','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00012','회사코드관리','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00013','부서코드관리','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00014','노드관리','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00015','출입문관리','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00016','출입승인코드','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00017','카드관리','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00018','카드권한관리','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00019','출입문별권한관리','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00020','비밀번호관리','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00021','출입모니터링','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00022','통신모니터링','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00023','출입보고서','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00024','근태보고서','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00025','환경설정','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00026','DB백업','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00027','원격지원','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00028','업그레이드','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00029','프로그램정보','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00030','프로그램','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00031','로그인','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00032','로그아웃','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00033','비밀번호변경','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00034','종료','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00035','닫기','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00036','보고서','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00037','부서코드관리','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00038','부서코드추가','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00039','부서코드수정','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00040','이전','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00041','회사코드관리','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00042','회사코드추가','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00043','회사코드수정','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00044','카드관리','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00045','카드추가','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00046','카드수정','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00047','등록기관리','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00048','출입문관리','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00049','출입문추가','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00050','출입문수정','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00051','일괄권한등록','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00052','일괄권한삭제','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00053','노드관리','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00054','노드추가','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00055','노드수정','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00056','출입상태코드관리','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00057','출입상태코드추가','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00058','출입상태코드수정','','');
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00059','노드관리','','');
  dmDBInsert.InsertIntoTB_FormName_Value('2','M00001','기존 사원정보를 모두 삭제하시겠습니까?','','');
  dmDBInsert.InsertIntoTB_FormName_Value('2','M00002','카드백업 완료','','');
  dmDBInsert.InsertIntoTB_FormName_Value('2','M00003','카드백업 실패','','');
  dmDBInsert.InsertIntoTB_FormName_Value('2','M00004','카드등록 완료','','');
  dmDBInsert.InsertIntoTB_FormName_Value('2','M00005','카드등록 실패','','');
  dmDBInsert.InsertIntoTB_FormName_Value('2','M00006','START 버튼을 클릭하여 로그인 후 작업하세요.','','');
  dmDBInsert.InsertIntoTB_FormName_Value('2','M00007','해당 작업을 선택 하시면 작업창이 활성화 됩니다.','','');
  dmDBInsert.InsertIntoTB_FormName_Value('2','M00008','작업을 수행합니다.','','');
  dmDBInsert.InsertIntoTB_FormName_Value('2','M00009','기기정보 설정시 통신 장애가 발생 할 수 있습니다. 계속하시겠습니까?','','');
  dmDBInsert.InsertIntoTB_FormName_Value('2','M00010','업데이트 도구가 설치되어 있지 않습니다.','','');
  dmDBInsert.InsertIntoTB_FormName_Value('2','M00011','데이터 전송 중입니다.','','');
  dmDBInsert.InsertIntoTB_FormName_Value('2','M00012','수정시에는 해당셀을 더블클릭 하세요.','','');
  dmDBInsert.InsertIntoTB_FormName_Value('2','M00013','프로그램에 문제가 있습니다. 개발실에 문의하여 주세요.','','');
  dmDBInsert.InsertIntoTB_FormName_Value('2','M00014','코드가 존재하지 않습니다.','','');
  dmDBInsert.InsertIntoTB_FormName_Value('2','M00015','$NAME가(이) 존재하지 않습니다.','','');
  dmDBInsert.InsertIntoTB_FormName_Value('2','M00016','작업할 데이터를 선택하지 않았습니다.','','');
  dmDBInsert.InsertIntoTB_FormName_Value('2','M00017','중복 코드 입니다.','','');
  dmDBInsert.InsertIntoTB_FormName_Value('2','M00018','데이터 저장에 실패하였습니다.','','');
  dmDBInsert.InsertIntoTB_FormName_Value('2','M00019','삭제 할 데이터를 선택 하세요.','','');
  dmDBInsert.InsertIntoTB_FormName_Value('2','M00020','건의 데이터가 삭제 됩니다. 정말 삭제 하시겠습니까?','','');
  dmDBInsert.InsertIntoTB_FormName_Value('2','M00021','조회할 데이터가 없습니다.','','');
  dmDBInsert.InsertIntoTB_FormName_Value('2','M00022','에서 이미 사용중인 카드입니다.','','');
  dmDBInsert.InsertIntoTB_FormName_Value('2','M00023','$OLD를 $NEW(으)로 변경하시겠습니까?','','');
  dmDBInsert.InsertIntoTB_FormName_Value('2','M00024','설정되었습니다.','','');
  dmDBInsert.InsertIntoTB_FormName_Value('2','M00025','비밀번호는 1000개 까지만 등록 가능 합니다.','','');
  dmDBInsert.InsertIntoTB_FormName_Value('2','M00026','등록할 비밀번호를 선택하여 주세요.','','');
  dmDBInsert.InsertIntoTB_FormName_Value('2','M00027','등록할 출입문을 선택하여 주세요.','','');
  dmDBInsert.InsertIntoTB_FormName_Value('2','M00028','삭제할 비밀번호를 선택하여 주세요.','','');
  dmDBInsert.InsertIntoTB_FormName_Value('2','M00029','추가시에는 해당셀을 더블클릭하세요.','','');
  dmDBInsert.InsertIntoTB_FormName_Value('2','M00030','권한 등록할 사원을 선택하여 주세요.','','');
  dmDBInsert.InsertIntoTB_FormName_Value('2','M00031','삭제할 출입문을 선택하여 주세요.','','');
  dmDBInsert.InsertIntoTB_FormName_Value('2','M00032','권한을 등록 하려면 출입문을 선택 해 주셔야 합니다.','','');
  dmDBInsert.InsertIntoTB_FormName_Value('2','M00033','권한을 등록 하려면 사원를 선택 해 주셔야 합니다.','','');
  dmDBInsert.InsertIntoTB_FormName_Value('2','M00034','선택 사원의 권한 등록이 완료 되었습니다.','','');
  dmDBInsert.InsertIntoTB_FormName_Value('2','M00035','권한을 삭제 하려면 출입문을 선택 해 주셔야 합니다.','','');
  dmDBInsert.InsertIntoTB_FormName_Value('2','M00036','권한을 삭제 하려면 사원를 선택 해 주셔야 합니다.','','');
  dmDBInsert.InsertIntoTB_FormName_Value('2','M00037','선택 출입문에 권한 삭제가 완료 되었습니다.','','');
  dmDBInsert.InsertIntoTB_FormName_Value('2','M00038','데이터베이스 오픈 실패','','');
  dmDBInsert.InsertIntoTB_FormName_Value('2','M00039','패스워드가 맞지 않습니다.','','');
  dmDBInsert.InsertIntoTB_FormName_Value('2','M00040','기기교체 설정 정보 다운로드 완료','','');
  dmDBInsert.InsertIntoTB_FormName_Value('2','M00041','설정초기화데이터 전송','','');
  dmDBInsert.InsertIntoTB_FormName_Value('2','M00042','비밀번호데이터 삭제 전송','','');
  dmDBInsert.InsertIntoTB_FormName_Value('2','M00043','카드데이터 삭제 전송','','');
  dmDBInsert.InsertIntoTB_FormName_Value('2','M00044','기기초기화 성공','','');
  dmDBInsert.InsertIntoTB_FormName_Value('2','M00045','$NUM포트는 $NAME에서 이미 사용중입니다.','','');
  dmDBInsert.InsertIntoTB_FormName_Value('2','M00046','해당 IP는 $NAME에서 이미 사용중입니다.','','');
  dmDBInsert.InsertIntoTB_FormName_Value('2','M00047','해당 노드에 출입문 추가화면으로 이동하시겠습니까?','','');
  dmDBInsert.InsertIntoTB_FormName_Value('2','M00048','$NAME에서 이미 사용중인 코드입니다.','','');
  dmDBInsert.InsertIntoTB_FormName_Value('2','M00049','권한등록이 완료되었습니다.','','');
  dmDBInsert.InsertIntoTB_FormName_Value('2','M00050','권한삭제가 완료되었습니다.','','');
  dmDBInsert.InsertIntoTB_FormName_Value('2','M00051','기존 사용 비밀번호가 틀립니다.','','');
  dmDBInsert.InsertIntoTB_FormName_Value('2','M00052','신규 패스워드가 올바르지 않습니다.','','');
  dmDBInsert.InsertIntoTB_FormName_Value('2','M00053','패스워드 자릿수는 4자리 입니다.','','');
  dmDBInsert.InsertIntoTB_FormName_Value('2','M00054','패스워드는 숫자입니다.','','');
  dmDBInsert.InsertIntoTB_FormName_Value('3','M00001','경고','','');
  dmDBInsert.InsertIntoTB_FormName_Value('3','M00002','출입이력보고서','','');
  dmDBInsert.InsertIntoTB_FormName_Value('3','M00003','출입보고서','','');
  dmDBInsert.InsertIntoTB_FormName_Value('3','M00004','카드','','');
  dmDBInsert.InsertIntoTB_FormName_Value('3','M00005','비밀번호','','');
  dmDBInsert.InsertIntoTB_FormName_Value('3','M00006','마스터번호','','');
  dmDBInsert.InsertIntoTB_FormName_Value('3','M00007','전체','','');
  dmDBInsert.InsertIntoTB_FormName_Value('3','M00008','정보','','');
  dmDBInsert.InsertIntoTB_FormName_Value('3','M00009','사용안함','','');
  dmDBInsert.InsertIntoTB_FormName_Value('3','M00010','알수 없음','','');
  dmDBInsert.InsertIntoTB_FormName_Value('3','M00011','근태보고서','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00001','조회기간','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00002','출입문','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00003','조작구분','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00004','회사명','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00005','부서명','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00006','이름','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00007','조회','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00008','엑셀','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00009','출력','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00010','출입시간','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00011','사번','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00012','카드번호','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00013','승인결과','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00014','저장','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00015','근태날짜','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00016','출근시간','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00017','퇴근시간','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00018','직위명','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00019','전화번호','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00020','카드정보','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00021','같은위치의 출입문에 권한부여','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00022','전송상태','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00023','등록기포트','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00024','카드및설정백업','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00025','출입이력백업','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00026','시간','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00027','명령어','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00028','화면지움','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00029','비밀번호리스트','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00030','비밀번호권한관리','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00031','비밀번호추가','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00032','비밀번호','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00033','비밀번호삭제','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00034','출입문현황','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00035','비밀번호등록현황','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00036','노드번호','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00037','기기번호','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00038','출입문번호','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00039','출입문명칭','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00040','기기정보','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00041','소속정보','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00042','락제어시간','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00043','노드명칭','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00044','출입문정보','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00045','기기정보','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00046','출입권한','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00047','미등록카드','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00048','등록카드','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00049','권한 삭제할 출입문','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00050','출입문조회','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00051','취소','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00052','출입문추가','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00053','선택권한삭제','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00054','권한 등록할 출입문','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00055','사원정보','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00056','선택권한등록','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00057','로그인','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00058','패스워드','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00059','확인','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00060','출입문상태','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00061','소속','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00062','출입현황','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00063','카드백업','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00064','카드등록','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00065','리스트삭제','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00066','노드타입','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00067','아이피','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00068','포트','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00069','시리얼포트','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00070','노드타입','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00071','RS232설정','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00072','TCP/IP설정','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00073','노드아이피','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00074','노드포트','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00075','출입승인코드','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00076','출입승인명칭','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00077','추가','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00078','삭제','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00079','개인별카드권한관리','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00080','위치권한','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00081','미등록출입문','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00082','등록출입문','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00083','권한 삭제할 사원','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00084','사원조회','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00085','사원추가','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00086','권한 등록할 사원','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00087','기존패스워드','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00088','신규패스워드','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00089','신규패스워드(재입력)','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00090','적용','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00091','운영모드','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00092','개방모드','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00093','기기교체다운로드','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00094','카드전체삭제','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00095','비밀번호전체삭제','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00096','설정초기화','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00097','회사코드','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00098','수정','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00099','비밀번호권한 등록','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00100','비밀번호권한 삭제','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00101','출입권한 등록','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00102','출입권한 삭제','','');
  dmDBInsert.InsertIntoTB_FormName_Value('4','M00103','부서코드','','');
  dmDBCreate.CreateTB_DOORSCHEDULE;
  dmDBCreate.AlterTB_DOOR_SCHEDULEAdd;
  dmDBCreate.CreateTB_HOLIDAY;

end;

function TDataBaseConfig.Table002VersionMake: Boolean;
begin
  dmDBCreate.AlterTB_CARD_CARDCodeADD;

  dmDBUpdate.UpdateTB_CONFIG_Value('COMMON','TABLE_VER','2');
end;

function TDataBaseConfig.Table003VersionMake: Boolean;
begin
  dmDBInsert.InsertIntoTB_FormName_Value('1','M00060','출입문스케줄','','');

  dmDBUpdate.UpdateTB_CONFIG_Value('COMMON','TABLE_VER','3');
end;

procedure TDataBaseConfig.TableVersionCheck;
var
  nTableVersion : integer;
begin
  nTableVersion := GetVersion;
  if nTableVersion < 1 then Table001VersionMake;
  if nTableVersion < 2 then Table002VersionMake;
  if nTableVersion < 3 then Table003VersionMake;

end;

procedure TfmDataBaseConfig.FormCreate(Sender: TObject);
var
  ini_fun : TiniFile;
begin
  Try
    if G_stExeFolder = '' then G_stExeFolder := ExtractFileDir(Application.ExeName);
    ini_fun := TiniFile.Create(G_stExeFolder + '\Config.ini');

    rg_DBType.ItemIndex := ini_fun.ReadInteger('DBConfig','TYPE',MDB);

    edServerIP.Text  := ini_fun.ReadString('DBConfig','Host','127.0.0.1');
    edServerPort.Text := ini_fun.ReadString('DBConfig','Port','1433');
    edUserid.Text := ini_fun.ReadString('DBConfig','UserID','sa');
    edPasswd.Text := MimeDecodeString(ini_fun.ReadString('DBConfig','UserPW',''));  //saPasswd
    edDataBaseName.Text := lowerCase(ini_fun.ReadString('DBConfig','DBNAME',''));
  Finally
    ini_fun.Free;
  End;
  rg_DBTypeClick(sender);
end;

procedure TfmDataBaseConfig.rg_DBTypeClick(Sender: TObject);
begin
  if rg_DBType.ItemIndex = MDB then AdvPanel1.Visible := False
  else AdvPanel1.Visible := True;

end;

procedure TfmDataBaseConfig.btn_CloseClick(Sender: TObject);
begin
  TDataBaseConfig.GetObject.Cancel := True;
  Close;
end;

procedure TfmDataBaseConfig.btn_SaveClick(Sender: TObject);
var
  ini_fun : TiniFile;
begin
  Try
    if G_stExeFolder = '' then G_stExeFolder := ExtractFileDir(Application.ExeName);
    ini_fun := TiniFile.Create(G_stExeFolder + '\Config.ini');

    ini_fun.WriteInteger('DBConfig','TYPE',rg_DBType.ItemIndex);

    ini_fun.WriteString('DBConfig','Host',edServerIP.Text);
    ini_fun.WriteString('DBConfig','Port',edServerPort.Text);
    ini_fun.WriteString('DBConfig','UserID',edUserid.Text);
    ini_fun.WriteString('DBConfig','UserPW',MimeEncodeString(Trim(edPasswd.Text)));  //saPasswd
    ini_fun.WriteString('DBConfig','DBNAME',edDataBaseName.Text);
  Finally
    ini_fun.Free;
  End;

  TDataBaseConfig.GetObject.DataBaseConnect;
  Close;

end;

end.
