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
  FORMACCESSREPORT = 0;    //�ⱸ�ڵ����
  FORMAREACODE = 1;    //�ⱸ�ڵ����
  FORMBUILDINGCODE = 2; //�����ڵ����
  FORMCARDADMIN = 3;    //ī�����
  FORMCONFIGSETTING = 4;  //ȯ�漳��
  FORMDEVICECOMMONITORING = 5;  //�����Ÿ���͸�
  FORMDEVICEPWADMIN = 6;  //��й�ȣ����
  FORMDOORADMIN = 7;      //���Թ�����
  FORMDOORCARDPERMIT = 8;      //���Թ��� ī����Ѱ���
  FormDOORSCHEDULEADMIN = 9;   //������
  FormHOLIDAYADMIN =10;        //Ư����
  FORMMONITORING = 11;      //����͸�
  FORMNODEADMIN = 12;      //������
  FORMPERMITCODE = 13;     //���Խ����ڵ����
  FORMPERSONCARDPERMIT = 14; //���κ�ī����Ѱ���
  FORMREMOTECONTROL = 15; //������������

const
  NODESOCKETDELAYTIME = 60;

  //DataBase Type
  MSSQL = 0;
  POSTGRESQL = 1;
  MDB = 2;
  FIREBIRD = 3;
  //��� Ÿ�� (SocketType)
  RS232 = 0;
  TCPIP = 1;

  //��� ���� ��� �ð�
  REPLYDelayTime = 5000;
  ENQDelayTime = 100;
  LASTPACKETRETRYCOUNT = 3; //���� ��Ŷ�� �ݺ������� �ö� �� Ƚ��
  DEVICECONNECTERRORMAXCOUNT = 100; //ENQ�� ���� ������ ���� ��� ��Ž��з� �Ǵ�

//************ Event Type �����
Type
  TAdoConnectedEvent = procedure(Sender: TObject;  Connected:Boolean) of object;

var
//********************************
//  ���� ��񼱾�κ�
//********************************
  NodeList : TStringList;  //��� ����Ʈ
  DeviceList : TStringList;  //��� ����Ʈ

//********************************
//  ��Ű��� ����κ�
//********************************
  G_bIsNumericCardNO : Boolean = False;   //ī���ȣ ����Ÿ�� ��ȯ����

  G_nIDLength : integer = 7;
  G_nProgramType : integer = 0;
  G_nCardLengType : integer = 1; //0:4����Ʈ�ø���,1:Length Type,2:KT���
  G_nCardFixedLength : integer = 8;  //�ش� ���� �����͸� �ٿ�ε� ����...
  G_nPasswordFixedLength : integer = 4;  //�ش� ���� �����͸� �ٿ�ε� ����...
  G_nComDelayTime : integer = 20;   //���� ��Ŷ�� ������ ���� ����ϴ� �ð�.
  G_nLangeType : integer = 1;  //1.KOR,2.JAPAN,3.ENG

  G_stMasterNo : string;            //�α��κ�й�ȣ�� ������ ��ȣ
  G_stDeviceVer : string = 'K1';
//********************************
// ���� ���� ó�� �κ�
//********************************
  G_bApplicationTerminate : Boolean; //�� ����� True

  G_stExeFolder : string;   // ���� ����ǰ� �ִ� Application Path ����
  // ���� �����ͺ��̽� ȯ��
  G_nDBType : integer;

  G_stGroupCode : string;   // ���α׷� ���� �׷�

  G_nMaxComPort : integer;

//***************************
//�� ���� ����
//***************************
  G_bFormEnabled: Array [0..MAXFORMCOUNT] of Boolean;     //�� Ȱ��ȭ ����
  G_nBuildingCodeLength : integer;
  G_nNodeCodeLength : integer=3;
  G_nDeviceCodeLength : integer=2;
  G_nDoorCodeLength : integer=1;
  G_nChildFormDefaultHeight : integer = 620 ;
  //��ϱ� ��Ʈ��ȣ
  G_nCardRegisterPort : integer = 0;

//��Ʈ
  G_stFormStyle : string;
  G_stFontName : string = '���� ����';
  G_nFontSize : integer = 9;
  G_stMenuCaption : string;

implementation

end.