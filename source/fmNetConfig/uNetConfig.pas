unit uNetConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons,   Mask,
  Grids, WinSpool,ComCtrls,IdGlobal,
  DB, ADODB,    IdBaseComponent, IdComponent,
  IdUDPBase, IdUDPServer, IdUDPClient,IdSocketHandle, AdvEdit;

type
  TfmNetConfig = class(TForm)
    pan_header: TPanel;
    Notebook1: TNotebook;
    pan_Lan: TPanel;
    Panel1: TPanel;
    sg_WiznetList: TStringGrid;
    Panel3: TPanel;
    btn_LClose: TSpeedButton;
    btn_LSetting: TSpeedButton;
    StatusBar1: TStatusBar;
    Label5: TLabel;
    ed_LMCUID: TEdit;
    ADOTmpQuery: TADOQuery;
    IdUDPServer1: TIdUDPServer;
    IdUDPClient1: TIdUDPClient;
    WiznetTimer: TTimer;
    Panel6: TPanel;
    pan_LanDetail: TPanel;
    Label3: TLabel;
    chk_ZeronType: TCheckBox;
    chk_MCUChange: TCheckBox;
    cmb_MCU: TComboBox;
    btn_BroadSearch: TSpeedButton;
    GroupBox3: TGroupBox;
    ed_LMAC1: TAdvEdit;
    ed_LMAC2: TAdvEdit;
    ed_LMAC3: TAdvEdit;
    ed_LMAC4: TAdvEdit;
    ed_LMAC5: TAdvEdit;
    ed_LMAC6: TAdvEdit;
    rg_McSetting: TGroupBox;
    Label1: TLabel;
    ed_LLocalIP: TAdvEdit;
    ed_LSunnet: TAdvEdit;
    Label2: TLabel;
    ed_LGateway: TAdvEdit;
    Label4: TLabel;
    ed_LLocalPort: TAdvEdit;
    Label6: TLabel;
    RadioModeClient: TRadioButton;
    RadioModeServer: TRadioButton;
    RadioModeMixed: TRadioButton;
    Checkbox_DHCP: TCheckBox;
    Checkbox_Debugmode: TCheckBox;
    Label7: TLabel;
    Edit_ServerIp: TAdvEdit;
    Label8: TLabel;
    Edit_Serverport: TAdvEdit;
    GroupBox1: TGroupBox;
    Label9: TLabel;
    Edit_Time: TAdvEdit;
    Label10: TLabel;
    Edit_Size: TAdvEdit;
    Label11: TLabel;
    Edit_Char: TAdvEdit;
    Label12: TLabel;
    Edit_Idle: TAdvEdit;
    GroupBox2: TGroupBox;
    Label13: TLabel;
    ComboBox_Boad: TComboBox;
    Label14: TLabel;
    ComboBox_Databit: TComboBox;
    ComboBox_Parity: TComboBox;
    Label15: TLabel;
    ComboBox_Stopbit: TComboBox;
    Label16: TLabel;
    Label17: TLabel;
    ComboBox_Flow: TComboBox;
    procedure rd_rs232Click(Sender: TObject);
    procedure rd_lanClick(Sender: TObject);
    procedure Notebook1PageChanged(Sender: TObject);
    procedure btn_LCloseClick(Sender: TObject);
    procedure btn_RCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_RSettingClick(Sender: TObject);
    procedure btn_BroadSearchClick(Sender: TObject);
//    procedure IdUDPServer1UDPRead(Sender: TObject; AData: TStream;
//      ABinding: TIdSocketHandle);
    procedure sg_WiznetListClick(Sender: TObject);
    procedure btn_LSettingClick(Sender: TObject);
    procedure chk_MCUChangeClick(Sender: TObject);
    procedure IdUDPServer1UDPRead(AThread: TIdUDPListenerThread;
      AData: TIdBytes; ABinding: TIdSocketHandle);
  private
    SelectMAC :string;
    bNetConfigSet : Boolean;
    NETTYPE : string;
    { Private declarations }
    procedure PrintLog(aMesg:string);

    Procedure ClearWiznetInfo;
    Procedure ClearLanInfo;
    procedure DetailWizNetList(aWiznetData:string);

    procedure RegLanWiznet;  //UDP�� LAN ��� ����


  public
    { Public declarations }
  end;

var
  fmNetConfig: TfmNetConfig;
  ComPortList : TStringList;
  MCUIDList : TStringList;
  bWizeNetLanRecv : Boolean; //����� �б� ���� ����
  bCheckID : Boolean; //ID üũ ���� ����
  DoCloseWinsock : Boolean;
  StopConnection : Boolean; //���� ���� ��ư�� True
  L_bConnected : Boolean;
  wiznetData : String;
  Sent_Ver : string;
  ComBuff : string;  //���ŵ� �޽��� ����
  Rcv_MsgNo     : Char;
  Send_MsgNo    : Integer;
  MACADDR :string;
  NodeNo : string;
  MCUID : string;
  OffTimerCount : integer;

implementation

uses
  uCommonVariable,
  uDBFormName,
  uFunction;

{$R *.dfm}

procedure TfmNetConfig.rd_rs232Click(Sender: TObject);
begin
  NoteBook1.PageIndex := 0;
end;

procedure TfmNetConfig.rd_lanClick(Sender: TObject);
begin
  NoteBook1.PageIndex := 1;
end;

procedure TfmNetConfig.Notebook1PageChanged(Sender: TObject);
begin
  pan_header.Caption := Notebook1.ActivePage;
end;

procedure TfmNetConfig.btn_LCloseClick(Sender: TObject);
var
  nServerMode : integer;
begin
  Close;
end;

procedure TfmNetConfig.btn_RCloseClick(Sender: TObject);
begin
  if Not bNetConfigSet then
  begin
    if Application.MessageBox(Pchar('���ȯ���� �������� ���� ������ �ֽ��ϴ�.' + #13 +
                       '���ȯ�� ����â�� �����Ͻðڽ��ϱ�?'),'���',MB_OKCANCEL)= ID_CANCEL then Exit;
  end;
  Close;
end;

procedure TfmNetConfig.FormCreate(Sender: TObject);
var
  nCount : integer;
  i : integer;
begin
  bNetConfigSet := True;

  NETTYPE := 'TCPIP';
  Notebook1.PageIndex := 1;
  Notebook1PageChanged(self);

  MCUIDList := TStringList.Create;
  MCUIDList.Clear;
  ComPortList := TStringList.Create;
  ComPortList.Clear;
  Sent_Ver := 'K1';
  DoCloseWinsock := False;
  L_bConnected := False;
  StopConnection := False;
  ComBuff := '';
  MCUID := '';

  IdUDPServer1.OnUDPRead := IdUDPServer1UDPRead;
end;


procedure TfmNetConfig.IdUDPServer1UDPRead(AThread: TIdUDPListenerThread;
  AData: TIdBytes; ABinding: TIdSocketHandle);
(*   // Sample
type
  TMan = record
    Name: String[7];
    Age: Integer;
  end;
var
  Stream: TMemoryStream;
  Jpg: TJpegImage;
  Man: TMan;
begin
  Caption := DateTimeToStr(Now);
  case FRadioButtonTag of
    0: EditMsg.Text := BytesToString(AData);

    1: begin
      Stream := TMemoryStream.Create;
      try
        //Stream.SetSize(Length(AData));
        //CopyMemory(Stream.Memory, AData, Length(AData));
        // or
        Stream.Write(AData[0], Length(AData));
        //
        Jpg := TJPEGImage.Create;
        Stream.Position := 0;
        Jpg.LoadFromStream(Stream);
        Image.Picture.Bitmap.Assign(Jpg);
      finally
        FreeAndNil(Jpg);
        FreeAndNil(Stream);
      end;
    end;

    2: begin
      BytesToRaw(AData, Man, Length(AData));
      LabelRecord.Caption := Format('%s, %d', [Man.Name, Man.Age]);
    end;
  end;

*)
type
  TData = record
    cData: String[60];
  end;
var
  DataStringStream: TStringStream;
  Stream: TMemoryStream;
  RecvData : String;
  S,st : string;
  MAcStr : string;
  nRow : integer;
  bSearch : Boolean;
  nLen : integer;
  aTemp : TData;
  B: Byte;
  i : integer;
  stTemp : string;
begin
  DataStringStream := TStringStream.Create('');
  Stream := TMemoryStream.Create;
  nLen := Length(AData);
  try
    {DataStringStream.Write(AData[0], Length(AData));
    stTemp:=DataStringStream.DataString;
    RecvData := BytesToString(AData);  //Text
    BytesToRaw(AData, aTemp, Length(AData));
    RecvData := aTemp.cData;
    Stream.Write(AData[0], Length(AData));
    Stream.Position := 0;
    RecvData := '';
    for i := 0 to Stream.Size - 1 do
    begin
      Stream.ReadBuffer(B,1);
      RecvData := RecvData + IntToHex(Trunc(B),2);
    end;
    RecvData := Hex2Ascii(RecvData); }
    RecvData := BytesToStringRaw(AData);
//    Stream.Position := 0;
//    Stream.ReadBuffer(RecvData,Stream.Size);
    //DataStringStream.LoadFromStream(Stream);
    //RecvData := DataStringStream.DataString;
    //Stream.SetSize(Length(AData));
        //CopyMemory(Stream.Memory, AData, Length(AData));
        // or
  finally
    DataStringStream.Free;
    Stream.Free;
  end;

  WiznetTimer.Enabled:= False;

  S:= RecvData;

  if  nLen < 47 then Exit;

  {MAC Address}

  if (copy(S,1,4) <> 'IMIN') and (copy(S,1,4) <> 'SETC')
     and (copy(S,1,4) <> 'LNDT') and (copy(S,1,4) <> 'LNSD')
  then Exit;

  WiznetData:= S;
  bWizeNetLanRecv := True; //��ȸ ��忡����

  if bNetConfigSet then Exit;

  if (copy(S,1,4) = 'IMIN') or (copy(S,1,4) <> 'SETC') then chk_ZeronType.Checked := False
  else chk_ZeronType.Checked := True;

  st:= copy(S,5,6);
  MAcStr:= ToHexStrNoSpace(st);
  MAcStr:=  Copy(MAcStr,1,2) + ':' +
            Copy(MAcStr,3,2) + ':' +
            Copy(MAcStr,5,2) + ':' +
            Copy(MAcStr,7,2) + ':' +
            Copy(MAcStr,9,2) + ':' +
            Copy(MAcStr,11,2);
  with sg_WiznetList do
  begin
    bSearch := False;
    for nRow := 1 to RowCount - 1 do
    begin
      if cells[0,nRow] = MAcStr then
      begin
        cells[0,nRow] := MAcStr ;
        cells[1,nRow] := WiznetData;
        sg_WiznetList.Row := nRow;
        DetailWizNetList(WiznetData);
        bSearch := True;
        bWizeNetLanRecv := True; //���� �� ����
      end;
    end;
    if Not bSearch then
    begin
      if Cells[0,1] <> '' then rowCount := RowCount + 1;
      cells[0,RowCount - 1] := MAcStr ;
      cells[1,RowCount - 1] := WiznetData;
      if RowCount = 2 then   DetailWizNetList(WiznetData);
      if selectMAC = MAcStr then
      begin
        sg_WiznetList.Row := RowCount - 1;
        DetailWizNetList(WiznetData);
      end;
    end;
  end;

end;

procedure TfmNetConfig.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  WiznetTimer.Enabled := False;

  IdUDPClient1.Active := False;
  IdUDPServer1.Active := False;

  ComPortList.Destroy;
  WiznetTimer.Destroy;

  IdUDPClient1.Destroy;
  IdUDPServer1.Destroy;

end;

procedure TfmNetConfig.PrintLog(aMesg: string);
begin
  StatusBar1.Panels[0].Text := aMesg;
end;



procedure TfmNetConfig.ClearWiznetInfo;
begin

  ed_LLocalIP.Text:= '';
  //IP_LLocalIP.Text := '0.0.0.0';
  ed_LSunnet.Text:= '';
  //IP_LSunnet.Text := '0.0.0.0';
  ed_LGateway.Text:= '';
  //IP_LGateway.Text:= '0.0.0.0';
  //ed_LLocalPort.Text:= '';
  ed_LMAC1.Text:= '00';
  ed_LMAC2.Text:= '00';
  ed_LMAC3.Text:= '00';
  ed_LMAC4.Text:= '00';
  ed_LMAC5.Text:= '00';
  ed_LMAC6.Text:= '00';

  rg_McSetting.Color := clBtnShadow;
  ed_LLocalIP.Color:= clWhite;
  //IP_LLocalIP.Color := clWhite;
  ed_LSunnet.Color:= clWhite;
  //IP_LSunnet.Color := clWhite;
  ed_LGateway.Color:= clWhite;
  //IP_LGateway.Color:= clWhite;
  ed_LLocalPort.Color:= clWhite;
  Edit_ServerIp.Color:= clWhite;
  Edit_Serverport.Color:= clWhite;
  ed_LMAC1.Color:= clWhite;
  ed_LMAC2.Color:= clWhite;
  ed_LMAC3.Color:= clWhite;
  ed_LMAC4.Color:= clWhite;
  ed_LMAC5.Color:= clWhite;
  ed_LMAC6.Color:= clWhite;

end;


procedure TfmNetConfig.btn_RSettingClick(Sender: TObject);
var
  FirstTickCount: Longint;
begin
end;


procedure TfmNetConfig.btn_BroadSearchClick(Sender: TObject);
var
  nRow : integer;
  nCol : integer;
begin
  bNetConfigSet := False;
  with sg_WiznetList do
  begin
    for nRow := 1 to RowCount - 1 do
    begin
      for nCol := 0 to ColCount - 1 do
      begin
        Cells[nCol,nRow] := '';
      end;
    end;
    RowCount := 2;
  end;
  wiznetData:= '';
  ClearWiznetInfo;

  IdUDPServer1.Active := False;
  IdUDPServer1.DefaultPort := BROADSERVERPORT;
  IdUDPServer1.Active := True;

  IdUDPClient1.Broadcast('FIND',BROADCLIENTPORT);
  bNetConfigSet := False;
end;

procedure TfmNetConfig.ClearLanInfo;
begin
  ed_LMAC1.Text := '00';
  ed_LMAC2.Text := '00';
  ed_LMAC3.Text := '00';
  ed_LMAC4.Text := '00';
  ed_LMAC5.Text := '00';
  ed_LMAC6.Text := '00';

  ed_LLocalIP.Text:= '';
  //IP_LLocalIP.Text := '0.0.0.0';
  ed_LSunnet.Text:= '';
  //IP_LSunnet.Text := '0.0.0.0';
  ed_LGateway.Text:= '';
  //IP_LGateway.Text:= '0.0.0.0';
  //ed_LLocalPort.Text:= '';
  ComboBox_Boad.Text:= '';
  ComboBox_Databit.Text:= '';
  ComboBox_Parity.Text:= '';
  ComboBox_Stopbit.Text:= '';
  ComboBox_Flow.Text:= '';
  Edit_Time.Text:= '';
  Edit_Size.Text:= '';
  Edit_Char.Text:= '';
  Edit_Idle.Text:= '';
  Edit_ServerIp.Text:= '';
  //IP_ServerIp.Text:= '0.0.0.0';
  Edit_Serverport.Text:= '';
  Checkbox_Debugmode.Checked:= False;
  Checkbox_DHCP.Checked:= False;
  RadioModeMixed.Checked:= True;
  pan_LanDetail.Enabled := False;
end;

(*
procedure TfmNetConfig.IdUDPServer1UDPRead(Sender: TObject; AData: TStream;
  ABinding: TIdSocketHandle);
var
  DataStringStream: TStringStream;
  RecvData : String;
  S,st : string;
  MAcStr : string;
  nRow : integer;
  bSearch : Boolean;
begin
  DataStringStream := TStringStream.Create('');
  try
    DataStringStream.CopyFrom(AData, AData.Size);
    RecvData:=DataStringStream.DataString;
  finally
    DataStringStream.Free;
  end;

  WiznetTimer.Enabled:= False;

  S:= RecvData;

  if  Length(S) < 47 then Exit;

  {MAC Address}

  if (copy(S,1,4) <> 'IMIN') and (copy(S,1,4) <> 'SETC')
     and (copy(S,1,4) <> 'LNDT') and (copy(S,1,4) <> 'LNSD')
  then Exit;

  WiznetData:= S;
  bWizeNetLanRecv := True; //��ȸ ��忡����

  if bNetConfigSet then Exit;

  if (copy(S,1,4) = 'IMIN') or (copy(S,1,4) <> 'SETC') then chk_ZeronType.Checked := False
  else chk_ZeronType.Checked := True;

  st:= copy(S,5,6);
  MAcStr:= ToHexStrNoSpace(st);
  MAcStr:=  Copy(MAcStr,1,2) + ':' +
            Copy(MAcStr,3,2) + ':' +
            Copy(MAcStr,5,2) + ':' +
            Copy(MAcStr,7,2) + ':' +
            Copy(MAcStr,9,2) + ':' +
            Copy(MAcStr,11,2);
  with sg_WiznetList do
  begin
    bSearch := False;
    for nRow := 1 to RowCount - 1 do
    begin
      if cells[0,nRow] = MAcStr then
      begin
        cells[0,nRow] := MAcStr ;
        cells[1,nRow] := WiznetData;
        sg_WiznetList.Row := nRow;
        DetailWizNetList(WiznetData);
        bSearch := True;
        bWizeNetLanRecv := True; //���� �� ����
      end;
    end;
    if Not bSearch then
    begin
      if Cells[0,1] <> '' then rowCount := RowCount + 1;
      cells[0,RowCount - 1] := MAcStr ;
      cells[1,RowCount - 1] := WiznetData;
      if RowCount = 2 then   DetailWizNetList(WiznetData);
      if selectMAC = MAcStr then
      begin
        sg_WiznetList.Row := RowCount - 1;
        DetailWizNetList(WiznetData);
      end;
    end;
  end;
  //sg_WiznetListClick(self);
end;

*)

procedure TfmNetConfig.sg_WiznetListClick(Sender: TObject);
var
  FirstTickCount: Longint;
  i : integer;
begin
  if sg_WiznetList.Cells[0,sg_WiznetList.Row] = '' then Exit;

  WiznetData := sg_WiznetList.Cells[1,sg_WiznetList.Row];
  DetailWizNetList(WiznetData);
  SelectMAC := sg_WiznetList.Cells[0,sg_WiznetList.Row]

end;

procedure TfmNetConfig.DetailWizNetList(aWiznetData: string);
var
  I: Integer;
  S: string;
  st: String;
  st2: String;
  n: Integer;
  MAcStr:String;
begin
  ClearWiznetInfo;

  S:= aWiznetData;

  //if  Length(S) < 47 then Exit;

  {MAC Address}

  if (copy(S,1,4) <> 'IMIN') and (copy(S,1,4) <> 'SETC')
     and (copy(S,1,4) <> 'LNDT') and (copy(S,1,4) <> 'LNSD')
  then Exit;

  if (copy(S,1,4) = 'IMIN') or (copy(S,1,4) <> 'SETC') then chk_ZeronType.Checked := False
  else chk_ZeronType.Checked := True;


  st:= copy(S,5,6);

  MACADDR:= ToHexStrNoSpace(st);

  ed_LMAC1.Color:= clYellow;
  ed_LMAC2.Color:= clYellow;
  ed_LMAC3.Color:= clYellow;
  ed_LMAC4.Color:= clYellow;
  ed_LMAC5.Color:= clYellow;
  ed_LMAC6.Color:= clYellow;

  ed_LMAC1.Text:= Copy(MACADDR,1,2);
  ed_LMAC2.Text:= Copy(MACADDR,3,2);
  ed_LMAC3.Text:= Copy(MACADDR,5,2);
  ed_LMAC4.Text:= Copy(MACADDR,7,2);
  ed_LMAC5.Text:= Copy(MACADDR,9,2);
  ed_LMAC6.Text:= Copy(MACADDR,11,2);

  {Mode}
  //if S[11] = #$00 then Checkbox_Client.Checked:= True
  //else                 Checkbox_Client.Checked:= False;

  if S[11] = #$00 then RadioModeClient.Checked:= True
  else if S[11] = #$02 then RadioModeServer.Checked:= True
  else if S[11] = #$01 then RadioModeMixed.Checked:= True;


  {IP Address}
  st:= Copy(S,12,4);
  st2:='';
  for I:= 1 to 4 do
  begin
    if I < 4 then st2:= st2 + InttoStr(Ord(st[I]))+'.'
    else          st2:= st2 + InttoStr(Ord(st[I]));
  end;
  ed_LLocalIP.Text:= st2;
  ed_LLocalIP.Color:= clYellow;
  //IP_LLocalIP.Text := st2;
  //IP_LLocalIP.Color := clYellow;

  {Subnet Mask}
  st:= Copy(S,16,4);
  st2:='';
  for I:= 1 to 4 do
  begin
    if I < 4 then st2:= st2 + InttoStr(Ord(st[I]))+'.'
    else          st2:= st2 + InttoStr(Ord(st[I]));
  end;
  ed_LSunnet.Text:= st2;
  ed_LSunnet.Color:= clYellow;
  //IP_LSunnet.Text := st2;
  //IP_LSunnet.Color := clYellow;

  {GateWay}
  st:= Copy(S,20,4);
  st2:='';
  for I:= 1 to 4 do
  begin
    if I < 4 then st2:= st2 + InttoStr(Ord(st[I]))+'.'
    else          st2:= st2 + InttoStr(Ord(st[I]));
  end;
  ed_LGateway.Text:= st2;
  ed_LGateway.Color:= clYellow;
  //IP_LGateway.Text:= st2;
  //IP_LGateway.Color:= clYellow;

  {Port Number- Client}
  st:= copy(S,24,2);
  st2:= Hex2DecStr(ToHexStrNoSpace(st));
  ed_LLocalPort.Text:= st2;
  ed_LLocalPort.Color:= clYellow;

  {Server IP}
  st:= copy(s,26,4);
  st2:='';
  for I:= 1 to 4 do
  begin
    if I < 4 then st2:= st2 + InttoStr(Ord(st[I]))+'.'
    else          st2:= st2 + InttoStr(Ord(st[I]));
  end;
  Edit_ServerIp.Text:= st2;
  Edit_ServerIp.Color := clYellow;
  //IP_ServerIp.Text:= st2;

  {Server Port}
  st:= copy(S,30,2);
  st2:= Hex2DecStr(ToHexStrNoSpace(st));
  Edit_Serverport.Text:= st2;
  Edit_Serverport.Color := clYellow;

  {Serial Baudrate}
  case ord(S[32]) of
     ord(#$BB): begin
        ComboBox_Boad.ItemIndex:= 8;
     end;
     ord(#$FF): begin
        ComboBox_Boad.ItemIndex:= 7;
     end;
     ord(#$FE): begin
        ComboBox_Boad.ItemIndex:= 6;
     end;
     ord(#$FD): begin
        ComboBox_Boad.ItemIndex:= 5;
     end;
     ord(#$FA): begin
        ComboBox_Boad.ItemIndex:= 4;
     end;
     ord(#$F4): begin
        ComboBox_Boad.ItemIndex:= 3;
     end;
     ord(#$E8): begin
        ComboBox_Boad.ItemIndex:= 2;
     end;
     ord(#$D0): begin
        ComboBox_Boad.ItemIndex:= 1;
     end;
     ord(#$A0): begin
        ComboBox_Boad.ItemIndex:= 0;
     end;
  end;
  ComboBox_Boad.Text:= ComboBox_Boad.Items[ComboBox_Boad.ItemIndex];
  {Data Bit}
  st:= copy(s,33,1);
  n:= Ord(st[1]);
  if n = 7 then ComboBox_Databit.ItemIndex:= 0
  else if n =8 then ComboBox_Databit.ItemIndex:= 1
  else ComboBox_Databit.Text:= InttoStr(n);
  ComboBox_Databit.Text:= ComboBox_Databit.Items[ComboBox_Databit.ItemIndex];

  {Parity}
  case S[34] of
    #$00: ComboBox_Parity.ItemIndex:= 0;
    #$01: ComboBox_Parity.ItemIndex:= 1;
    #$02: ComboBox_Parity.ItemIndex:= 2;
  end;
  ComboBox_Parity.Text:= ComboBox_Parity.Items[ComboBox_Parity.ItemIndex];
  {Stop Bit}
  st:= copy(s,35,1);
  ComboBox_Stopbit.Text:= InttoStr(Ord(st[1]));

  {Flow Control}
  case S[36] of
    #$00: ComboBox_Flow.ItemIndex:= 0;
    #$01: ComboBox_Flow.ItemIndex:= 1;
    #$02: ComboBox_Flow.ItemIndex:= 2;
  end;
  ComboBox_Flow.Text:= ComboBox_Flow.Items[ComboBox_Flow.ItemIndex];
  {DelimiterChar}
  Edit_Char.Text:= ToHexStrNoSpace(s[37]);
  {FDelimiterSize}
  st:= Copy(S,38,2);
  st2:= Hex2DecStr(ToHexStrNoSpace(st));
  Edit_Size.Text:= st2;
  {Delimitertime}
  st:= Copy(S,40,2);
  st2:= Hex2DecStr(ToHexStrNoSpace(st));
  Edit_Time.Text:= st2;

  {FDelimiterIdle}
  st:= Copy(S,42,2);
  st2:= Hex2DecStr(ToHexStrNoSpace(st));
  Edit_Idle.Text:= st2;

  {Debug Mode}
  if S[44] = #$0 then Checkbox_Debugmode.Checked:= True //IIM7100.FDebugMode:='0' //ON
  else                Checkbox_Debugmode.Checked:= False;// IIM7100.FDebugMode:='1';//OFF

  {Major Version}
{  RzEdit1.Text:= InttoStr(Ord(s[45]))+'.'+InttoStr(Ord(s[46]));
  if Not chk_ZeronType.Checked then RzEdit1.Color := $0080FFFF
  else RzEdit1.Color := clSkyBlue; }

  {DHCP MODE}
  if S[47] = #$0 then Checkbox_DHCP.Checked:= False//IIM7100.FOnDHCP:= '0'//OFF
  else                Checkbox_DHCP.Checked:= True;//IIM7100.FOnDHCP:= '1'; //ON

  pan_LanDetail.Enabled := True;

  //rg_McSetting.Color := clYellow;
  rg_McSetting.Color := clMoneyGreen;

end;

procedure TfmNetConfig.btn_LSettingClick(Sender: TObject);
var
  FirstTickCount : double;
  i : integer;
  nNodeNo : integer;
  stMac : string;
begin
  //rg_McSetting.FlatColor := clBtnShadow;

  bNetConfigSet := True;
  NETTYPE := 'TCPIP';

  Screen.Cursor:= crHourGlass;
  btn_LSetting.Enabled := False;
  btn_LClose.Enabled := False;
  bWizeNetLanRecv := False;


  RegLanWiznet;

  FirstTickCount := GetTickCount + 5000; //5�� ���
  While Not bWizeNetLanRecv do
  begin
    Application.ProcessMessages;
    if GetTickCount > FirstTickCount then Break;
  end;

  if Not bWizeNetLanRecv then
  begin
    btn_LSetting.Enabled := True;
    btn_LClose.Enabled := True;
    Screen.Cursor:= crDefault;
    showmessage('LAN ������ ���� �߽��ϴ�.');
    Exit;
  end;

  Screen.Cursor:= crDefault;

  btn_LSetting.Enabled := True;
  btn_LClose.Enabled := True;
  bNetConfigSet := True;
end;

procedure TfmNetConfig.RegLanWiznet;
type
  TSendData = record
    Data: String[50];
  end;
var
  st,st2 : string;
  I : integer;
  No : integer;
  buf: TBytes;
//  Buffer: TIdBytes;
begin
    WiznetData := sg_WiznetList.Cells[1,sg_WiznetList.Row];

    wiznetData[1]:='L';
    wiznetData[2]:='N';
    wiznetData[3]:='S';
    wiznetData[4]:='V';

    {LocalIP}
    st2:='';
    for I:= 0 to 3 do
    begin
      st:= FindCharCopy(ed_LLocalIP.Text,I,'.');
      //st:= FindCharCopy(IP_LLocalIP.Text,I,'.');

      No:= StrToInt(st);
      st2:= st2 + Char(No);
    end;
    for I:= 1 to 4 do
    begin
      wiznetData[11+I]:= st2[I];
    end;

   {Local subnet}
   st2:='';
    for I:= 0 to 3 do
    begin
      st:= FindCharCopy(ed_LSunnet.Text,I,'.');
      //st:= FindCharCopy(IP_LSunnet.Text,I,'.');
      No:= StrToInt(st);
      st2:= st2 + Char(No);
    end;
    for I:= 1 to 4 do
    begin
      wiznetData[15+I]:= st2[I];
    end;

   {Local Gateway}
   st2:='';
    for I:= 0 to 3 do
    begin
      st:= FindCharCopy(ed_LGateway.Text,I,'.');
      //st:= FindCharCopy(IP_LGateway.Text,I,'.');
      No:= StrToInt(st);
      st2:= st2 + Char(No);
    end;
    for I:= 1 to 4 do
    begin
      wiznetData[19+I]:= st2[I];
    end;

    {Local Port}
    st2:='';
    st:= Dec2Hex(StrtoInt(ed_LLocalPort.Text),2);
    //st:= Dec2Hex(3000,2);
    if Length(st) < 4 then st:= '0'+st;
    st2:= Chr(Hex2Dec(Copy(st,1,2)))+ Char(Hex2Dec(Copy(st,3,2)));
    wiznetData[24]:= st2[1];
    wiznetData[25]:= st2[2];

    {Server IP}
    st2:='';
    if Edit_ServerIp.Text = '' then Edit_ServerIp.Text := '127.0.0.1';
    for I:= 0 to 3 do
    begin
      st:= FindCharCopy(Edit_ServerIp.Text,I,'.');
      //st:= FindCharCopy(IP_ServerIp.Text,I,'.');
      No:= StrToInt(st);
      st2:= st2 + Char(No);
    end;
    for I:= 1 to 4 do
    begin
      wiznetData[25+I]:= st2[I];
    end;

    {Server Port}
    st2:='';
    st:= Dec2Hex(StrtoInt(Edit_Serverport.Text),2);
    if Length(st) < 4 then st:= '0'+st;
    st2:= Chr(Hex2Dec(Copy(st,1,2)))+ Char(Hex2Dec(Copy(st,3,2)));
    wiznetData[30]:= st2[1];
    wiznetData[31]:= st2[2];

    {Mode}
    //if Checkbox_Client.Checked then wiznetData[11] := #$00
    //else                            wiznetData[11] := #$01;

    if RadioModeClient.Checked then wiznetData[11] := #$00
    else if RadioModeServer.Checked then wiznetData[11] := #$02
    else if RadioModeMixed.Checked then  wiznetData[11] := #$01;//}
    wiznetData[11] := #$02; //���� ���


    {Board}
    {case ComboBox_Boad.ItemIndex of
      3: wiznetData[32]:= #$F4; //9600
      4: wiznetData[32]:= #$FA; //19200
      5: wiznetData[32]:= #$FD; //38400
      6: wiznetData[32]:= #$FE; //57600
      7: wiznetData[32]:= #$FF; //115200
    else wiznetData[32]:= #$FD; //38400
    end;}
    wiznetData[32]:= #$FD; //38400

    {DataBit}
    {case ComboBox_Databit.ItemIndex of
      0: wiznetData[33]:= #$07;
      1: wiznetData[33]:= #$08;
    end;}
    wiznetData[33]:= #$08; //8Bit
    {Parity}
    {case ComboBox_Parity.ItemIndex of
      0: wiznetData[34]:= #$00;
      1: wiznetData[34]:= #$01;
      2: wiznetData[34]:= #$02;
    end; }
    wiznetData[34]:= #$00; // None Parity
    {Stop Bit}
    wiznetData[35]:= #$01;

    {Flow}
    {case ComboBox_Flow.ItemIndex of
      0: wiznetData[36]:= #$00;
      1: wiznetData[36]:= #$01;
      2: wiznetData[36]:= #$02;
    end;}
    wiznetData[36]:= #$00; //None Flow
    {Delimeter Time}
    st2:='';
    st:= Dec2Hex(StrtoInt(Edit_Time.Text),2);
    //if Length(st) < 4 then st:= '0'+st;
    st:=FillZeroStrNum(st,4);
    st2:= Chr(Hex2Dec(Copy(st,1,2)))+ Char(Hex2Dec(Copy(st,3,2)));
    wiznetData[40]:= st2[1];
    wiznetData[41]:= st2[2];

    {Delimeter Size}
    st2:='';
    st:= Dec2Hex(StrtoInt(Edit_Size.Text),2);
    if Length(st) < 4 then st:= '0'+st;
    st2:= Chr(Hex2Dec(Copy(st,1,2)))+ Char(Hex2Dec(Copy(st,3,2)));
    wiznetData[38]:= st2[1];
    wiznetData[39]:= st2[2];

    {Delimeter Char}
    st:= Edit_Char.Text;
    wiznetData[37]:= Char(Hex2Dec(st));

    {Delimeter IdleTIme}
    st2:='';
    st:= Dec2Hex(StrtoInt(Edit_Idle.Text),2);
    if Length(st) < 4 then st:= '0'+st;
    st2:= Chr(Hex2Dec(Copy(st,1,2)))+ Char(Hex2Dec(Copy(st,3,2)));
    wiznetData[42]:= st2[1];
    wiznetData[43]:= st2[2];
    {Debug Mode}
    if Checkbox_Debugmode.Checked then  wiznetData[44]:= #$00
    else                                wiznetData[44] := #$01;

    if Checkbox_DHCP.Checked then wiznetData[47]:= #$01
    else                          wiznetData[47]:= #$00;

//    SetLength(buf, Length(wiznetData) * SizeOf(Char));
//    if wiznetData <> '' then Move(AnsiString(wiznetData)[1], buf[0], Length(buf));
//    stTemp2 := Ascii2Hex( BytesToStringRaw(Buf));

{    stTemp2 := Ascii2Hex( AnsiString(wiznetData));
    Buffer:=RawToBytes(wiznetData[1], Length(wiznetData));
    stTemp2 := Ascii2Hex( BytesToStringRaw(Buffer));
    arrSendData.Data := wiznetData;
    Buffer:=RawToBytes(arrSendData, SizeOf(arrSendData));
    stTemp2 := Ascii2Hex(AnsiString(Buffer));
}

    IdUDPServer1.Active := False;
    IdUDPServer1.DefaultPort := BROADSERVERPORT;
    IdUDPServer1.Active := True;
//    IdUDPClient1.Broadcast(Buffer,BROADCLIENTPORT);

    //wiznetData := '7A7B7C7D7E7F808182838485868788898A8B8C8D8E8F909192939495969798999A9B9C9D9E9FA0A1A2A3A4A5A6A7A8A9AAABACADAEAFB0';
    Try
      Ascii2Bytes(wiznetData,buf);
      IdUDPClient1.Broadcast(buf,BROADCLIENTPORT);
    Finally
      buf := nil;
      Finalize(buf);
    End;
    {SetLength(buf, Length(wiznetData));
    wiznetData := Ascii2Hex(wiznetData);
    for i := 1 to (Length(wiznetData) div 2) do
    begin
      buf[i-1] := Hex2Dec(copy(wiznetData,(i*2)-1,2));
    end; }
    //arrSendData.Data := AnsiString(Hex2Ascii(wiznetData));
//    IdUDPClient1.Broadcast(wiznetData,BROADCLIENTPORT,'',enUTF8);
//    IdUDPClient1.Broadcast();
//    Buf := RawToBytes(wiznetData,SizeOf(wiznetData));
//    Buf := ToBytes(wiznetData,SizeOf(wiznetData));
    //IdUDPClient1.SendBuffer('255.255.255.255',BROADCLIENTPORT,Buf);
//    IdUDPClient1.Broadcast(RawToBytes(buf,SizeOf(buf)),BROADCLIENTPORT);
    //ClearWiznetInfo;

end;


procedure TfmNetConfig.chk_MCUChangeClick(Sender: TObject);
begin
  if chk_MCUChange.Checked then
  begin
    cmb_MCU.Visible := True;
  end else
  begin
    cmb_MCU.Visible := False;
  end;
end;



end.