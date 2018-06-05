unit uCommonVariable;

interface
uses
  System.Classes;

const
  STX = #$2;
  ETX = #$3;
  ENQ = #$5;
  ACK = #$6;
  NAK = #$15;
  EOT = #$04;
  CR  = #13;
  BROADSERVERPORT = 5001;
  BROADCLIENTPORT = 1460;
  TCPCLIENTPORT = 1461;

const
  MAXFORMCOUNT  = 100;
  FORMACCESSREPORT = 0;    //출구코드관리
  FORMAREACODE = 1;    //출구코드관리
  FORMBUILDINGCODE = 2; //빌딩코드관리
  FORMCARDADMIN = 3;    //카드관리
  FORMCONFIGSETTING = 4;  //환경설정
  FORMDEVICECOMMONITORING = 5;  //기기통신모니터링
  FORMDEVICEPWADMIN = 6;  //비밀번호관리
  FORMDOORADMIN = 7;      //출입문관리
  FORMDOORCARDPERMIT = 8;      //출입문별 카드권한관리
  FormDOORSCHEDULEADMIN = 9;   //스케줄
  FormHOLIDAYADMIN =10;        //특정일
  FORMMONITORING = 11;      //모니터링
  FORMNODEADMIN = 12;      //노드관리
  FORMPERMITCODE = 13;     //출입승인코드관리
  FORMPERSONCARDPERMIT = 14; //개인별카드권한관리
  FORMREMOTECONTROL = 15; //원격지원서비스

const
  NODESOCKETDELAYTIME = 60;

  //DataBase Type
  MSSQL = 0;
  POSTGRESQL = 1;
  MDB = 2;
  FIREBIRD = 3;
  //통신 타입 (SocketType)
  RS232 = 0;
  TCPIP = 1;

  //통신 응답 대기 시간
  REPLYDelayTime = 5000;
  ENQDelayTime = 100;
  LASTPACKETRETRYCOUNT = 3; //최종 패킷이 반복적으로 올라 온 횟수
  DEVICECONNECTERRORMAXCOUNT = 100; //ENQ에 의한 응답이 없는 경우 통신실패로 판단

//************ Event Type 선언부
Type
  TAdoConnectedEvent = procedure(Sender: TObject;  Connected:Boolean) of object;

var
//********************************
//  공통 장비선언부분
//********************************
  NodeList : TStringList;  //노드 리스트
  DeviceList : TStringList;  //기기 리스트

//********************************
//  통신관련 선언부분
//********************************
  G_bIsNumericCardNO : Boolean = False;   //카드번호 숫자타입 변환유무

  G_nIDLength : integer = 7;
  G_nProgramType : integer = 0;
  G_nCardLengType : integer = 1; //0:4바이트시리얼,1:Length Type,2:KT사옥
  G_nCardFixedLength : integer = 8;  //해당 길이 데이터만 다운로드 하자...
  G_nPasswordFixedLength : integer = 4;  //해당 길이 데이터만 다운로드 하자...
  G_nComDelayTime : integer = 20;   //다음 패킷을 보내기 위해 대기하는 시간.
  G_nLangeType : integer = 1;  //1.KOR,2.JAPAN,3.ENG

  G_stMasterNo : string;            //로그인비밀번호와 동일한 번호
  G_stDeviceVer : string = 'K1';
//********************************
// 공통 변수 처리 부분
//********************************
  G_bApplicationTerminate : Boolean; //폼 종료시 True

  G_stExeFolder : string;   // 현재 실행되고 있는 Application Path 저장
  // 접속 데이터베이스 환경
  G_nDBType : integer;

  G_stGroupCode : string;   // 프로그램 실행 그룹

  G_nMaxComPort : integer;

//***************************
//폼 관련 변수
//***************************
  G_bFormEnabled: Array [0..MAXFORMCOUNT] of Boolean;     //폼 활성화 여부
  G_nBuildingCodeLength : integer;
  G_nNodeCodeLength : integer=3;
  G_nDeviceCodeLength : integer=2;
  G_nDoorCodeLength : integer=1;
  G_nChildFormDefaultHeight : integer = 620 ;
  //등록기 포트번호
  G_nCardRegisterPort : integer = 0;

//폰트
  G_stFormStyle : string;
  G_stFontName : string = '맑은 고딕';
  G_nFontSize : integer = 9;
  G_stMenuCaption : string;

implementation

end.
