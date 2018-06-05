﻿unit uMonitoring;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, W7Classes, W7Panels, AdvOfficeTabSet,
  AdvOfficeTabSetStylers, AdvSmoothPanel, Vcl.ExtCtrls, AdvSmoothLabel,
  Vcl.StdCtrls, AdvEdit, Vcl.Buttons, Vcl.Grids, AdvObj, BaseGrid, AdvGrid,
  AdvToolBtn,ADODB,ActiveX, uSubForm, CommandArray, AdvCombo, AdvGroupBox,
  Vcl.Mask, AdvSpin, AdvOfficeButtons, AdvPanel, Vcl.ComCtrls, AdvListV,
  Vcl.ImgList, Vcl.Menus, AdvMenus, AdvExplorerTreeview, paramtreeview,
  Vcl.Clipbrd, AdvToolBar, AdvToolBarStylers;

const
  con_DOORLOCKCLOSE = 3;
  con_DOORLOCKOPEN = 4;
  con_DOORFREECLOSE = 5;
  con_DOORFREEOPEN = 6;
  con_DOORNOTSTATE = 7;

type
  TfmMonitoring = class(TfmASubForm)
    Image1: TImage;
    BodyPanel: TW7Panel;
    menuTab: TAdvOfficeTabSet;
    pan_DoorList: TAdvPanel;
    pan_CardListHeader: TAdvSmoothPanel;
    lb_Door: TAdvSmoothLabel;
    cmb_ListDoorCode: TComboBox;
    ImageList1: TImageList;
    pan_DoorState: TAdvSmoothPanel;
    TreeView_DoorList: TTreeView;
    toolslist: TImageList;
    TreeView_LocationCode: TTreeView;
    sg_AccessEvent: TAdvStringGrid;
    SearchTimer: TTimer;
    PopupMenu: TPopupMenu;
    mn_DoorClose: TMenuItem;
    mn_DoorOpenMode: TMenuItem;
    N11: TMenuItem;
    mn_DeviceChange: TMenuItem;
    N13: TMenuItem;
    mn_AllCardDelete: TMenuItem;
    mn_PasswordAllDelete: TMenuItem;
    N16: TMenuItem;
    mn_DeviceInitialize: TMenuItem;
    StateAsyncTimer1: TTimer;
    N1: TMenuItem;
    mn_NodeIP: TMenuItem;
    AdvToolBarOfficeStyler1: TAdvToolBarOfficeStyler;
    AdvOfficeTabSetOfficeStyler1: TAdvOfficeTabSetOfficeStyler;
    procedure menuTabChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ed_AddNameKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure AdvSmoothPanel8Resize(Sender: TObject);
    procedure sg_PasswordListCheckBoxClick(Sender: TObject; ACol, ARow: Integer;
      State: Boolean);
    procedure sg_doorListCheckBoxClick(Sender: TObject; ACol, ARow: Integer;
      State: Boolean);
    procedure sg_doorPasswordListCheckBoxClick(Sender: TObject; ACol,
      ARow: Integer; State: Boolean);
    procedure pan_DoorStateResize(Sender: TObject);
    procedure SearchTimerTimer(Sender: TObject);
    procedure sg_AccessEventResize(Sender: TObject);
    procedure TreeView_DoorListClick(Sender: TObject);
    procedure mn_DoorCloseClick(Sender: TObject);
    procedure mn_DoorOpenModeClick(Sender: TObject);
    procedure mn_DeviceChangeClick(Sender: TObject);
    procedure sg_AccessEventKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure StateAsyncTimer1Timer(Sender: TObject);
    procedure mn_AllCardDeleteClick(Sender: TObject);
    procedure mn_PasswordAllDeleteClick(Sender: TObject);
    procedure mn_DeviceInitializeClick(Sender: TObject);
  private
    L_bClear : Boolean;
    ListDoorCodeList : TStringList;
    ListDongCodeList : TStringList;
    ListAreaCodeList : TStringList;
    SearchPasswordCodeList : TStringList;
    SearchDoorCodeList : TStringList;
    DisplayList : TStringList;

    L_nPasswordListMaxCount : integer;
    L_nPasswordCheckCount : integer;        //체크 된 비밀번호 카운트
    L_nAddDoorCheckCount : integer;  //등록 출입문 선택 카운트
    L_nDeletePasswordCheckCount : integer;  //등록 출입문 선택 카운트

    procedure LoadChildCode(aParentCode:string;aPosition:integer;cmbBox:TComboBox;aList:TStringList;aAll:Boolean);
    procedure LoadListView;
    procedure LoadDeviceCode(cmbBox:TComboBox;aList:TStringList;aAll:Boolean);

    { Private declarations }
  private
    procedure AdvStrinGridSetAllCheck(Sender: TObject;bchkState:Boolean);
    procedure DoorStateChange(aNodeNo,aECUID,aDoorNo:string;aDoorState:integer);
  private
    function GetAccessResultName(aAccessResultCode:string):string;
    function GetstChangeStateName(aChangeStateCode:string):string;
    function GetLocationName(aNodeNo,aECUID,aDoorNo:string;var aDongName,aAreaName,aDoorName:string):Boolean;
    function GetEmployeeInfo(aCardNo:string; var aCompanyName,aDepartName,aEmCode,aUserName:string):Boolean;
    function GetNodeIP(aNodeNo:string):string;
    function GetPasswordCount:integer;
    function GetUserNameFromCardNO(aCardNo:string):string;
  public
    { Public declarations }
    procedure FormNameSetting;
    procedure FontSetting;
    procedure Form_Close;
    procedure DeviceReload;

    procedure RcvCardAccessEvent(aNodeNo, aECUID, aDoorNo,aReaderNo, aInOut, aTime, aCardMode, aDoorMode, aChangeState, aAccessResult,aDoorState, aATButton, aCardNo:string);
    procedure ReceiveDeviceInitialize(aNodeNo, aECUID, aResult:string);
    procedure RcvDoorModeChange(aNodeNo, aECUID, aResult,aMode,aDoorState:string);
    procedure BatchDisplay(aData:string);

  end;

var
  fmMonitoring: TfmMonitoring;

implementation
uses
  uCommonVariable,
  uDataBase,
  uDBFunction,
  uDBFormName,
  uFormUtil,
  uFunction,
  udmCardPermit,
  uControler,
  uFormFontUtil;

{$R *.dfm}


procedure TfmMonitoring.pan_DoorStateResize(Sender: TObject);
begin
  inherited;
  TreeView_DoorList.Height := pan_DoorState.Height - 60;
end;

procedure TfmMonitoring.AdvSmoothPanel8Resize(Sender: TObject);
var
  nWidth : integer;
begin
  inherited;
end;

procedure TfmMonitoring.sg_AccessEventKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  st: string;
begin
  if key = 17 then Exit;
  if (Key = 67) and (Shift = [ssCtrl]) 	then
  begin
    with sg_AccessEvent do
    begin
      st:= Cells[6,Row];
      if st <> '' then ClipBoard.SetTextBuf(PChar(st));
    end;
  end;

end;

procedure TfmMonitoring.sg_AccessEventResize(Sender: TObject);
begin
  inherited;
//  sg_AccessEvent.DefaultColWidth := (sg_AccessEvent.Width - 180) div (sg_AccessEvent.ColCount - 1);
//  sg_AccessEvent.ColWidths[0] := 160;
end;

procedure TfmMonitoring.AdvStrinGridSetAllCheck(Sender: TObject;
  bchkState: Boolean);
var
  i : integer;
begin
    for i:= 1 to (Sender as TAdvStringGrid).RowCount - 1  do
    begin
      (Sender as TAdvStringGrid).SetCheckBoxState(0,i,bchkState);
    end;
end;

procedure TfmMonitoring.BatchDisplay(aData: string);
var
  stNodeNo : string;
  stECUID : string;
  stDoorNo : string;
  stReaderNo : string;
  stInOut : string;
  stTime : string;
  stCardMode : string;
  stDoorMode : string;
  stChangeStateCode : string;
  stAccessResultCode : string;
  stDoorState : string;
  stATButton : string;
  stCardNo : string;
  nPos : integer;
  stCompanyName : string;
  stDepartName : string;
  stEmCode : string;
  stDoorName : string;
  stUserName : string;
  stAccessResultName : string;
  stChangeStateName : string;
  stTemp1,stTemp2 : string;
begin
  nPos := PosIndex(';',aData,1);
  stNodeNo := copy(aData,1,nPos - 1);
  Delete(aData,1,nPos);
  nPos := PosIndex(';',aData,1);
  stECUID := copy(aData,1,nPos - 1);
  Delete(aData,1,nPos);
  nPos := PosIndex(';',aData,1);
  stDoorNo := copy(aData,1,nPos - 1);
  Delete(aData,1,nPos);
  nPos := PosIndex(';',aData,1);
  stReaderNo := copy(aData,1,nPos - 1);
  Delete(aData,1,nPos);
  nPos := PosIndex(';',aData,1);
  stInOut := copy(aData,1,nPos - 1);
  Delete(aData,1,nPos);
  nPos := PosIndex(';',aData,1);
  stTime := copy(aData,1,nPos - 1);
  Delete(aData,1,nPos);
  nPos := PosIndex(';',aData,1);
  stCardMode := copy(aData,1,nPos - 1);
  Delete(aData,1,nPos);
  nPos := PosIndex(';',aData,1);
  stDoorMode := copy(aData,1,nPos - 1);
  Delete(aData,1,nPos);
  nPos := PosIndex(';',aData,1);
  stChangeStateCode := copy(aData,1,nPos - 1);
  Delete(aData,1,nPos);
  nPos := PosIndex(';',aData,1);
  stAccessResultCode := copy(aData,1,nPos - 1);
  Delete(aData,1,nPos);
  nPos := PosIndex(';',aData,1);
  stDoorState := copy(aData,1,nPos - 1);
  Delete(aData,1,nPos);
  nPos := PosIndex(';',aData,1);
  stATButton := copy(aData,1,nPos - 1);
  Delete(aData,1,nPos);
  stCardNo := aData;

  //여기에서 화면에 뿌려주자.
  with sg_AccessEvent do
  begin
    if RowCount >= 1000 then  rowCount := 999;

    if Not L_bClear then InsertRows(1,1);
    L_bClear := False;
    GetEmployeeInfo(stCardNo,stCompanyName,stDepartName,stEmCode,stUserName);
    stAccessResultName := GetAccessResultName(stAccessResultCode);
    stChangeStateName := GetstChangeStateName(stChangeStateCode);
    GetLocationName(stNodeNo,stECUID,stDoorNo,stTemp1,stTemp2,stDoorName);

    Cells[0,1] := MakeDatetimeStr(stTime);
    Cells[1,1] := stDoorName;
    Cells[2,1] := stCompanyName;
    Cells[3,1] := stDepartName;
    Cells[4,1] := stEmCode;
    Cells[5,1] := stUserName;
    Cells[6,1] := stCardNo;
    Cells[7,1] := stChangeStateName;
    Cells[8,1] := stAccessResultName;

    if Not isDigit(stAccessResultCode) then
    begin
      RowColor[1] := $00EACAB6;
    end;
  end;
end;

procedure TfmMonitoring.DeviceReload;
begin
  LoadListView;
end;

procedure TfmMonitoring.DoorStateChange(aNodeNo, aECUID, aDoorNo: string;
  aDoorState: integer);
var
  obTreeView   : TTreeview;
  obCodeTreeView : TTreeview;
  obNode1   : TTreeNode;
  obCodeNode1: TTreeNode;
  stCode : string;
begin
  obTreeView := TreeView_DoorList;
  obCodeTreeView := TreeView_LocationCode;   //위치 코드 등록으로 현재 상태를 파악하기 위함
  stCode := 'D' + FillZeroNumber(strtoint(aNodeNo),G_nNodeCodeLength) + FillZeroNumber(strtoint(aECUID),G_nDeviceCodeLength) + FillZeroNumber(strtoint(aDoorNo),G_nDoorCodeLength);
  obCodeNode1:= GetNodeByText(obCodeTreeView,stCode,True);
  if obCodeNode1 <> nil then
  begin
    obNode1 := obTreeView.Items.Item[obCodeNode1.AbsoluteIndex];
    if obNode1 <> nil then
    begin
      obNode1.ImageIndex:=aDoorState;
      obNode1.SelectedIndex:=aDoorState;
    end;
  end;
end;

procedure TfmMonitoring.ed_AddNameKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  if Key = #13 then
  begin
    Perform(WM_NEXTDLGCTL,0,0);
  end;
end;

procedure TfmMonitoring.FontSetting;
begin
  dmFormFontUtil.TravelFormFontSetting(self,G_stFontName,inttostr(G_nFontSize));
  dmFormFontUtil.TravelAdvOfficeTabSetOfficeStylerFontSetting(AdvOfficeTabSetOfficeStyler1, G_stFontName,inttostr(G_nFontSize));
  dmFormFontUtil.FormAdvOfficeTabSetOfficeStylerSetting(AdvOfficeTabSetOfficeStyler1,G_stFormStyle);
  dmFormFontUtil.FormAdvToolBarOfficeStylerSetting(AdvToolBarOfficeStyler1,G_stFormStyle);
  dmFormFontUtil.FormStyleSetting(self,AdvToolBarOfficeStyler1);

end;

procedure TfmMonitoring.FormActivate(Sender: TObject);
begin
  inherited;
  WindowState := wsMaximized;
end;

procedure TfmMonitoring.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  StateAsyncTimer1.Enabled := False;
  SearchTimer.Enabled := False;

  self.FindSubForm('Main').FindCommand('FORMENABLE').Params.Values['NAME'] := inttostr(FORMMONITORING);
  self.FindSubForm('Main').FindCommand('FORMENABLE').Params.Values['VALUE'] := 'FALSE';
  self.FindSubForm('Main').FindCommand('FORMENABLE').Execute;

  ListDongCodeList.Free;
  ListAreaCodeList.Free;
  ListDoorCodeList.Free;
  SearchPasswordCodeList.Free;
  SearchDoorCodeList.Free;
  DisplayList.Free;

  Action := caFree;
end;

procedure TfmMonitoring.FormCreate(Sender: TObject);
begin

  L_bClear := True;

  ListDongCodeList := TStringList.Create;
  ListAreaCodeList := TStringList.Create;
  ListDoorCodeList := TStringList.Create;
  SearchPasswordCodeList := TStringList.Create;
  SearchDoorCodeList := TStringList.Create;
  DisplayList := TStringList.Create;

  menuTab.ActiveTabIndex := 1;
  menuTabChange(self);

  LoadDeviceCode(cmb_ListDoorCode,ListDoorCodeList,True);

  StateAsyncTimer1.Enabled := True;
  SearchTimer.Enabled := True;
  FontSetting;
end;


procedure TfmMonitoring.FormNameSetting;
begin
  Caption := dmFormName.GetFormMessage('1','M00021');
  menuTab.AdvOfficeTabs[0].Caption := dmFormName.GetFormMessage('1','M00035');
  menuTab.AdvOfficeTabs[1].Caption := dmFormName.GetFormMessage('1','M00021');

  pan_DoorState.Caption.Text := dmFormName.GetFormMessage('4','M00060');
  pan_CardListHeader.Caption.Text := dmFormName.GetFormMessage('4','M00062');
  lb_Door.Caption.Text := dmFormName.GetFormMessage('4','M00002');
  with sg_AccessEvent do
  begin
    cells[0,0] := WideString(dmFormName.GetFormMessage('4','M00010'));
    cells[1,0] := WideString(dmFormName.GetFormMessage('4','M00002'));
    cells[2,0] := WideString(dmFormName.GetFormMessage('4','M00004'));
    cells[3,0] := WideString(dmFormName.GetFormMessage('4','M00005'));
    cells[4,0] := WideString(dmFormName.GetFormMessage('4','M00011'));
    cells[5,0] := WideString(dmFormName.GetFormMessage('4','M00006'));
    cells[6,0] := WideString(dmFormName.GetFormMessage('4','M00012'));
    cells[7,0] := WideString(dmFormName.GetFormMessage('4','M00003'));
    cells[8,0] := WideString(dmFormName.GetFormMessage('4','M00013'));
  end;
  mn_DoorClose.Caption := dmFormName.GetFormMessage('4','M00091');
  mn_DoorOpenMode.Caption := dmFormName.GetFormMessage('4','M00092');
  mn_DeviceChange.Caption := dmFormName.GetFormMessage('4','M00093');
  mn_AllCardDelete.Caption := dmFormName.GetFormMessage('4','M00094');
  mn_PasswordAllDelete.Caption := dmFormName.GetFormMessage('4','M00095');
  mn_DeviceInitialize.Caption := dmFormName.GetFormMessage('4','M00096');
end;

procedure TfmMonitoring.FormShow(Sender: TObject);
begin
  self.FindSubForm('Main').FindCommand('FORMENABLE').Params.Values['NAME'] := inttostr(FORMMONITORING);
  self.FindSubForm('Main').FindCommand('FORMENABLE').Params.Values['VALUE'] := 'TRUE';
  self.FindSubForm('Main').FindCommand('FORMENABLE').Execute;

  FormNameSetting;
  LoadListView;
end;

procedure TfmMonitoring.Form_Close;
begin
  Close;
end;


function TfmMonitoring.GetAccessResultName(aAccessResultCode: string): string;
var
  stSql : string;
  TempAdoQuery : TADOQuery;
begin
  result := aAccessResultCode;
  stSql := ' Select * from TB_PERMITCODE';
  stSql := stSql + ' Where GROUP_CODE = ''' + G_stGroupCode + ''' ';
  stSql := stSql + ' AND PE_PERMITCODE = ''' + aAccessResultCode + ''' ';

  Try
    CoInitialize(nil);
    TempAdoQuery := TADOQuery.Create(nil);
    TempAdoQuery.Connection := dmDataBase.ADOConnection;

    with TempAdoQuery do
    begin
      Close;
      Sql.Text := stSql;
      Try
        Open;
      Except
        Exit;
      End;
      if recordcount < 1 then Exit;
      result := FindField('PE_PERMITNAME').AsString;

    end;
  Finally
    TempAdoQuery.Free;
    CoUninitialize;
  End;
end;

function TfmMonitoring.GetEmployeeInfo(aCardNo: string; var aCompanyName,
  aDepartName, aEmCode, aUserName: string): Boolean;
var
  stSql : string;
  TempAdoQuery : TADOQuery;
begin
  aCompanyName := '';
  aDepartName := '';
  aEmCode := '';
  aUserName := '';

  result := False;
  stSql := ' Select a.*,b.BC_NAME as DEPARTNAME,c.BC_NAME as COMPANYNAME from ';
  stSql := stSql + '(' ;
  stSql := stSql + '(' ;
  stSql := stSql + 'TB_CARD a ';
  stSql := stSql + ' Left Join ( select * from tb_buildingCode where bc_position = 2 ) b ';
  stSql := stSql + ' ON (a.GROUP_CODE = b.GROUP_CODE) ';
  stSql := stSql + ' AND (a.BC_PARENTCODE = b.BC_PARENTCODE ) ';
  stSql := stSql + ' AND (a.BC_CHILDCODE = b.BC_CHILDCODE ) ';
  stSql := stSql + ')';
  stSql := stSql + ' Left Join ( select * from tb_buildingCode where bc_position = 1 ) c ';
  stSql := stSql + ' ON (a.GROUP_CODE = c.GROUP_CODE) ';
  stSql := stSql + ' AND (a.BC_PARENTCODE = c.BC_CHILDCODE ) ';
  stSql := stSql + ')';
  stSql := stSql + ' Where a.GROUP_CODE = ''' + G_stGroupCode + ''' ';
  stSql := stSql + ' AND a.CA_CARDNO = ''' + aCardNo + ''' ';

  Try
    CoInitialize(nil);
    TempAdoQuery := TADOQuery.Create(nil);
    TempAdoQuery.Connection := dmDataBase.ADOConnection;

    with TempAdoQuery do
    begin
      Close;
      Sql.Text := stSql;
      Try
        Open;
      Except
        Exit;
      End;
      if recordcount < 1 then Exit;
      result := True;
      aCompanyName := FindField('COMPANYNAME').AsString;
      aDepartName := FindField('DEPARTNAME').AsString;
      aEmCode := FindField('CA_CODE').AsString;
      aUserName := FindField('CA_NAME').AsString;
    end;
  Finally
    TempAdoQuery.Free;
    CoUninitialize;
  End;
end;

function TfmMonitoring.GetLocationName(aNodeNo, aECUID, aDoorNo: string;
  var aDongName, aAreaName, aDoorName: string): Boolean;
var
  stSql : string;
  TempAdoQuery : TADOQuery;
begin
  aDongName := '';
  aAreaName := '';
  aDoorName := '';

  result := False;
  stSql := ' Select a.*,b.BC_NAME as AREANAME,c.BC_NAME as DONGNAME from ';
  stSql := stSql + '(' ;
  stSql := stSql + '(' ;
  stSql := stSql + 'TB_DOOR a ';
  stSql := stSql + ' Left Join ( select * from tb_buildingCode where bc_position = 2 ) b ';
  stSql := stSql + ' ON (a.GROUP_CODE = b.GROUP_CODE) ';
  stSql := stSql + ' AND (a.BC_PARENTCODE = b.BC_PARENTCODE ) ';
  stSql := stSql + ' AND (a.BC_CHILDCODE = b.BC_CHILDCODE ) ';
  stSql := stSql + ')';
  stSql := stSql + ' Left Join ( select * from tb_buildingCode where bc_position = 1 ) c ';
  stSql := stSql + ' ON (a.GROUP_CODE = c.GROUP_CODE) ';
  stSql := stSql + ' AND (a.BC_PARENTCODE = c.BC_CHILDCODE ) ';
  stSql := stSql + ')';
  stSql := stSql + ' Where a.GROUP_CODE = ''' + G_stGroupCode + ''' ';
  stSql := stSql + ' AND a.ND_NODENO = ' + aNodeNo + ' ';
  stSql := stSql + ' AND a.DE_DEVICEID = ''' + aEcuID + ''' ';
  stSql := stSql + ' AND a.DO_DOORNO = ' + aDoorNo + ' ';

  Try
    CoInitialize(nil);
    TempAdoQuery := TADOQuery.Create(nil);
    TempAdoQuery.Connection := dmDataBase.ADOConnection;

    with TempAdoQuery do
    begin
      Close;
      Sql.Text := stSql;
      Try
        Open;
      Except
        Exit;
      End;
      if recordcount < 1 then Exit;
      result := True;
      aDongName := FindField('DONGNAME').AsString;
      aAreaName := FindField('AREANAME').AsString;
      aDoorName := FindField('DO_NAME').AsString;
    end;
  Finally
    TempAdoQuery.Free;
    CoUninitialize;
  End;
end;

function TfmMonitoring.GetNodeIP(aNodeNo: string): string;
var
  stSql : string;
  TempAdoQuery : TADOQuery;
begin
  result := '';
  stSql := ' Select * from TB_NODE';
  stSql := stSql + ' Where GROUP_CODE = ''' + G_stGroupCode + ''' ';
  stSql := stSql + ' AND ND_NODENO = ' + aNodeNo + ' ';

  Try
    CoInitialize(nil);
    TempAdoQuery := TADOQuery.Create(nil);
    TempAdoQuery.Connection := dmDataBase.ADOConnection;

    with TempAdoQuery do
    begin
      Close;
      Sql.Text := stSql;
      Try
        Open;
      Except
        Exit;
      End;
      if recordcount < 1 then Exit;
      result := FindField('ND_NODEIP').AsString;
    end;
  Finally
    TempAdoQuery.Free;
    CoUninitialize;
  End;
end;

function TfmMonitoring.GetPasswordCount: integer;
var
  stSql : string;
  TempAdoQuery : TADOQuery;
begin
  result := 0;
  stSql := 'Select * from TB_PASSWORD ';
  stSql := stSql + ' Where GROUP_CODE = ''' + G_stGroupCode + ''' ';

  Try
    CoInitialize(nil);
    TempAdoQuery := TADOQuery.Create(nil);
    TempAdoQuery.Connection := dmDataBase.ADOConnection;

    with TempAdoQuery do
    begin
      Close;
      Sql.Text := stSql;
      Try
        Open;
      Except
        Exit;
      End;
      if recordcount < 1 then Exit;
      result := recordcount;
    end;
  Finally
    TempAdoQuery.Free;
    CoUninitialize;
  End;
end;

function TfmMonitoring.GetstChangeStateName(aChangeStateCode: string): string;
begin
  result := dmFormName.GetFormMessage('3','M00010');
  if aChangeStateCode = '' then Exit;

  case aChangeStateCode[1] of
    'c' : begin  
      result := dmFormName.GetFormMessage('3','M00004');
    end;
    'p' : begin  
      result := dmFormName.GetFormMessage('3','M00005');
    end;
    'm' : begin  
      result := dmFormName.GetFormMessage('3','M00006');
    end;
    else begin
      result := aChangeStateCode;
    end;
  end;
end;

function TfmMonitoring.GetUserNameFromCardNO(aCardNo: string): string;
var
  stSql : string;
  TempAdoQuery : TADOQuery;
begin
  result := '';
  stSql := 'Select * from TB_CARD ';
  stSql := stSql + ' Where GROUP_CODE = ''' + G_stGroupCode + ''' ';
  stSql := stSql + ' AND CA_CARDNO = ''' + aCardNo + ''' ';

  Try
    CoInitialize(nil);
    TempAdoQuery := TADOQuery.Create(nil);
    TempAdoQuery.Connection := dmDataBase.ADOConnection;

    with TempAdoQuery do
    begin
      Close;
      Sql.Text := stSql;
      Try
        Open;
      Except
        Exit;
      End;
      if recordcount < 1 then Exit;
      result := FindField('CA_NAME').AsString;
    end;
  Finally
    TempAdoQuery.Free;
    CoUninitialize;
  End;
end;

procedure TfmMonitoring.LoadChildCode(aParentCode: string; aPosition: integer;
  cmbBox: TComboBox; aList: TStringList; aAll: Boolean);
var
  stSql : string;
  TempAdoQuery : TADOQuery;
begin
  cmbBox.Items.Clear;
  aList.Clear;
  if aAll then
  begin
    cmbBox.Items.Add(dmFormName.GetFormMessage('3','M00007'));
    aList.Add('');
    cmbBox.ItemIndex := 0;
  end;
  if aParentCode = '' then Exit;
  Try
    CoInitialize(nil);
    TempAdoQuery := TADOQuery.Create(nil);
    TempAdoQuery.Connection := dmDataBase.ADOConnection;
    stSql := 'SELECT * FROM TB_BUILDINGCODE ';
    stSql := stSql + '  Where BC_POSITION = ' + inttostr(aPosition);
    stSql := stSql + '  AND BC_PARENTCODE = ''' + aParentCode + ''' ';
    stSql := stSql + '  ORDER BY idx  ';
    with TempAdoQuery do
    begin
      Close;
      sql.Text := stSql;
      Try
        Open;
      Except
        Exit;
      End;
      if recordcount < 1 then Exit;
      while Not Eof do
      begin
        cmbBox.Items.Add(FindField('BC_NAME').AsString);
        aList.Add(FindField('BC_CHILDCODE').AsString);
        Next;
      end;
      if cmbBox.Items.Count > 0 then cmbBox.ItemIndex := 0;
    end;
  Finally
    TempAdoQuery.Free;
    CoUninitialize;
  End;
end;


procedure TfmMonitoring.LoadDeviceCode(cmbBox: TComboBox; aList: TStringList;
  aAll: Boolean);
var
  stSql : string;
  TempAdoQuery : TADOQuery;
begin
  cmbBox.Items.Clear;
  aList.Clear;
  if aAll then
  begin
    cmbBox.Items.Add(dmFormName.GetFormMessage('3','M00007'));
    aList.Add('');
    cmbBox.ItemIndex := 0;
  end;

  Try
    CoInitialize(nil);
    TempAdoQuery := TADOQuery.Create(nil);
    TempAdoQuery.Connection := dmDataBase.ADOConnection;
    stSql := 'SELECT * FROM TB_DOOR ';
    stSql := stSql + '  ORDER BY idx  ';
    with TempAdoQuery do
    begin
      Close;
      sql.Text := stSql;
      Try
        Open;
      Except
        Exit;
      End;
      if recordcount < 1 then Exit;
      while Not Eof do
      begin
        cmbBox.Items.Add(FindField('DO_NAME').AsString);
        aList.Add(FillZeroNumber(FindField('ND_NODENO').AsInteger,G_nNodeCodeLength) + FillZeroNumber(strtoint(FindField('DE_DEVICEID').AsString),G_nDeviceCodeLength) + FillZeroNumber(FindField('DO_DOORNO').AsInteger,G_nDoorCodeLength));
        Next;
      end;
      if cmbBox.Items.Count > 0 then cmbBox.ItemIndex := 0;
    end;
  Finally
    TempAdoQuery.Free;
    CoUninitialize;
  End;
end;

procedure TfmMonitoring.LoadListView;
var
  obTreeView   : TTreeview;
  obCodeTreeView : TTreeview;
  obNode1   : TTreeNode;
  obNode2   : TTreeNode;
  obNode3   : TTreeNode;
  obCodeNode1: TTreeNode;
  obCodeNode2: TTreeNode;
  obCodeNode3: TTreeNode;
  stSql : string;
  TempAdoQuery : TADOQuery;
  stCode : string;
  stName : string;
  nDoorImageIndex : integer;
  nIndex : integer;
  stTempCode : string;
begin
  if G_bApplicationTerminate then Exit;
  obTreeView := TreeView_DoorList;
  obTreeView.ReadOnly:= True;
  obTreeView.Items.Clear;
  obCodeTreeView := TreeView_LocationCode;   //위치 코드 등록으로 현재 상태를 파악하기 위함
  obCodeTreeView.ReadOnly := True;
  obCodeTreeView.Items.Clear;

  obNode1:= obTreeView.Items.Add(nil,dmFormName.GetFormMessage('4','M00061'));
  obNode1.ImageIndex:=0;
  obNode1.SelectedIndex:=0;
  obNode1.StateIndex:= -1;
  obCodeNode1 := obCodeTreeView.Items.Add(nil,'B' + FillZeroNumber(0,G_nBuildingCodeLength) + FillZeroNumber(0,G_nBuildingCodeLength));

  Try
    CoInitialize(nil);
    TempAdoQuery := TADOQuery.Create(nil);
    TempAdoQuery.Connection := dmDataBase.ADOConnection;

    with TempAdoQuery do
    begin
      Close;
      //Sql.Clear;
      stSql := 'Select * from TB_BUILDINGCODE where BC_POSITION = 1 ';
      stSql := stSql + '  ORDER BY idx  ';
      Sql.Text := stSql;
      Try
        Open;
      Except
        Exit;
      End;
      if RecordCount > 0 then
      begin
        First;
        While Not Eof do
        begin
          if G_bApplicationTerminate then Exit;
          stCode := 'B' + FindField('BC_PARENTCODE').AsString + FillZeroStrNum(FindField('BC_CHILDCODE').AsString,G_nBuildingCodeLength);
          stName := FindField('BC_NAME').AsString;

          obNode2:= obTreeView.Items.AddChild(obNode1,stName);
          obNode2.ImageIndex:=1;
          obNode2.SelectedIndex:=1;
          obNode2.StateIndex:= -1;
          obCodeNode2 := obCodeTreeView.Items.AddChild(obCodeNode1,stCode);
          Application.ProcessMessages;
          Next;
        end;
        obNode1.Expanded := True;
      end;
      Close;
      //Sql.Clear;
      stSql := 'Select * from TB_BUILDINGCODE where BC_POSITION = 2 ';
      stSql := stSql + '  ORDER BY idx  ';
      Sql.Text := stSql;
      Try
        Open;
      Except
        Exit;
      End;
      if RecordCount > 0 then
      begin
        First;
        While Not Eof do
        begin
          if G_bApplicationTerminate then Exit;
          stCode := 'B' + FindField('BC_PARENTCODE').AsString + FillZeroStrNum(FindField('BC_CHILDCODE').AsString,G_nBuildingCodeLength);
          stName := FindField('BC_NAME').AsString;
          obCodeNode1:= GetNodeByText(obCodeTreeView,'B' + FillZeroNumber(0,G_nBuildingCodeLength) + FindField('BC_PARENTCODE').AsString,True);
          if obCodeNode1 <> nil then
          begin
            obNode1 := obTreeView.Items.Item[obCodeNode1.AbsoluteIndex];
            if obNode1 <> nil then
            begin
              obNode2:= obTreeView.Items.AddChild(obNode1,stName);
              obNode2.ImageIndex:=2;
              obNode2.SelectedIndex:=2;
              obNode2.StateIndex:= -1;
            end;
            obCodeNode2:= obCodeTreeView.Items.Item[obCodeNode1.AbsoluteIndex];
            if obCodeNode2 <> nil then
            begin
              obCodeNode3:= obCodeTreeView.Items.AddChild(obCodeNode2,stCode);
            end;
            obNode1.Expanded := True;
          end;
          Next;
        end;
      end;
      Close;
      //Sql.Clear;
      stSql := 'Select * from TB_DOOR ';
      stSql := stSql + '  ORDER BY idx  ';
      Sql.Text := stSql;
      Try
        Open;
      Except
        Exit;
      End;
      if RecordCount > 0 then
      begin
        First;
        While Not Eof do
        begin
          if G_bApplicationTerminate then Exit;
          stCode := 'D' + FillZeroNumber(FindField('ND_NODENO').AsInteger,G_nNodeCodeLength) + FillZeroNumber(strtoint(FindField('DE_DEVICEID').AsString),G_nDeviceCodeLength) + FillZeroNumber(FindField('DO_DOORNO').AsInteger,G_nDoorCodeLength);
          stName := FindField('DO_NAME').AsString;
          if (FindField('BC_CHILDCODE').AsString = '') or
             (FindField('BC_CHILDCODE').AsString = FillZeroNumber(0,G_nBuildingCodeLength))
          then stTempCode := 'B' + FillZeroNumber(0,G_nBuildingCodeLength) + FindField('BC_PARENTCODE').AsString
          else stTempCode := 'B' +FindField('BC_PARENTCODE').AsString + FindField('BC_CHILDCODE').AsString;

          obCodeNode1:= GetNodeByText(obCodeTreeView,stTempCode,True);
          if obCodeNode1 <> nil then
          begin
            obNode1 := obTreeView.Items.Item[obCodeNode1.AbsoluteIndex];
            if obNode1 <> nil then
            begin
              obNode2:= obTreeView.Items.AddChild(obNode1,stName);
              nDoorImageIndex := con_DOORNOTSTATE;
              nIndex := DeviceList.IndexOf(FillZeroNumber(FindField('ND_NODENO').AsInteger,G_nNodeCodeLength) + FillZeroNumber(strtoint(FindField('DE_DEVICEID').AsString),G_nDeviceCodeLength));
              if nIndex > -1 then
              begin
                if TDevice(DeviceList.Objects[nIndex]).DoorMode = '' then
                begin
                  nDoorImageIndex := con_DOORNOTSTATE;
                end else
                begin
                  case UpperCase(TDevice(DeviceList.Objects[nIndex]).DoorMode)[1] of
                    'C' :
                    begin
                      if UpperCase(TDevice(DeviceList.Objects[nIndex]).DoorState) = 'O' then nDoorImageIndex := con_DOORLOCKOPEN
                      else if UpperCase(TDevice(DeviceList.Objects[nIndex]).DoorState) = 'C' then nDoorImageIndex := con_DOORLOCKCLOSE
                      else nDoorImageIndex := con_DOORLOCKCLOSE;
                    end;
                    'O' :
                    begin
                      if UpperCase(TDevice(DeviceList.Objects[nIndex]).DoorState) = 'O' then nDoorImageIndex := con_DOORFREEOPEN
                      else if UpperCase(TDevice(DeviceList.Objects[nIndex]).DoorState) = 'C' then nDoorImageIndex := con_DOORFREECLOSE
                      else nDoorImageIndex := con_DOORFREEOPEN;
                    end;
                  end;
                end;
              end;
              obNode2.ImageIndex:=nDoorImageIndex;
              obNode2.SelectedIndex:=nDoorImageIndex;
              obNode2.StateIndex:= -1;
            end;
            obCodeNode2:= obCodeTreeView.Items.Item[obCodeNode1.AbsoluteIndex];
            if obCodeNode2 <> nil then
            begin
              obCodeNode3:= obCodeTreeView.Items.AddChild(obCodeNode2,stCode);
            end;
            obNode1.Expanded := True;
          end;
          Next;
        end;
      end;
    end;
  Finally
    TempAdoQuery.Free;
    CoUninitialize;
  End;

end;

procedure TfmMonitoring.menuTabChange(Sender: TObject);
var
  stBuildingCode : string;
  stAreaCode : string;
  nIndex : integer;
begin
  if menuTab.ActiveTabIndex = 0 then //Ȩ
  begin
    if menuTab.AdvOfficeTabs.Items[0].Caption = dmFormName.GetFormMessage('1','M00035') then Close
    else
    begin
      menuTab.ActiveTabIndex := 1;
      menuTabChange(self);
    end;
  end;
end;


procedure TfmMonitoring.mn_DeviceChangeClick(Sender: TObject);
var
  stDoorID : string;
  stNodeNo : string;
  stEcuID : string;
  nIndex : integer;
  stSelectName : string;
begin
  stSelectName := TreeView_DoorList.Selected.Text;
  stDoorID := TreeView_LocationCode.Items.Item[TreeView_DoorList.Selected.AbsoluteIndex].Text;
  if stDoorID[1] <> 'D' then Exit;
  stNodeNo := inttostr(strtoint(copy(stDoorID,2,G_nNodeCodeLength)));
  stEcuID := copy(stDoorID,2 + G_nNodeCodeLength,G_nDeviceCodeLength);

  //기기락타임정보 재전송
  dmDBFunction.UpdateTB_DOORDeviceAsync(stNodeNo,stEcuID,'1','N');
  //마스터번호 재전송
  dmDBFunction.UpdateTB_DOORMasterRcv(stNodeNo,stEcuID,'1','N');
  //카드데이터 재전송
  dmDBFunction.UpdateTB_DEVICECARDNO_DeviceState(stNodeNo,stEcuID,'N');
  //비밀번호 재전송
  dmDBFunction.UpdateTB_DEVICEPASSWD_DeviceState(stNodeNo,stEcuID,'N');
  showmessage(stSelectName + ':' + dmFormName.GetFormMessage('2','M00040'));
  PopupMenu.CloseMenu;
end;

procedure TfmMonitoring.mn_DeviceInitializeClick(Sender: TObject);
var
  stDoorID : string;
  stNodeNo : string;
  stEcuID : string;
  nIndex : integer;
  stSelectName : string;
begin
  stSelectName := TreeView_DoorList.Selected.Text;
  stDoorID := TreeView_LocationCode.Items.Item[TreeView_DoorList.Selected.AbsoluteIndex].Text;
  if stDoorID[1] <> 'D' then Exit;
  stNodeNo := copy(stDoorID,2,G_nNodeCodeLength);
  stEcuID := copy(stDoorID,2 + G_nNodeCodeLength,G_nDeviceCodeLength);
  nIndex := DeviceList.IndexOf(stNodeNo + stEcuID);
  if nIndex > -1 then
  begin
    TDevice(DeviceList.Objects[nIndex]).DeviceInitialize;
    showmessage(stSelectName + ':' + dmFormName.GetFormMessage('2','M00041'));
  end;
  PopupMenu.CloseMenu;
end;

procedure TfmMonitoring.mn_DoorCloseClick(Sender: TObject);
var
  stDoorID : string;
  stNodeNo : string;
  stEcuID : string;
  nIndex : integer;
begin
  stDoorID := TreeView_LocationCode.Items.Item[TreeView_DoorList.Selected.AbsoluteIndex].Text;
  if stDoorID[1] <> 'D' then Exit;
  stNodeNo := copy(stDoorID,2,G_nNodeCodeLength);
  stEcuID := copy(stDoorID,2 + G_nNodeCodeLength,G_nDeviceCodeLength);
  nIndex := DeviceList.IndexOf(stNodeNo + stEcuID);
  if nIndex > -1 then
  begin
    TDevice(DeviceList.Objects[nIndex]).ModeChange('c');
  end;
  PopupMenu.CloseMenu;
end;

procedure TfmMonitoring.mn_DoorOpenModeClick(Sender: TObject);
var
  stDoorID : string;
  stNodeNo : string;
  stEcuID : string;
  nIndex : integer;
begin
  stDoorID := TreeView_LocationCode.Items.Item[TreeView_DoorList.Selected.AbsoluteIndex].Text;
  if stDoorID[1] <> 'D' then Exit;
  stNodeNo := copy(stDoorID,2,G_nNodeCodeLength);
  stEcuID := copy(stDoorID,2 + G_nNodeCodeLength,G_nDeviceCodeLength);
  nIndex := DeviceList.IndexOf(stNodeNo + stEcuID);
  if nIndex > -1 then
  begin
    TDevice(DeviceList.Objects[nIndex]).ModeChange('o');
  end;
  PopupMenu.CloseMenu;
end;

procedure TfmMonitoring.mn_PasswordAllDeleteClick(Sender: TObject);
var
  stDoorID : string;
  stNodeNo : string;
  stEcuID : string;
  nIndex : integer;
  stSelectName : string;
begin
  stSelectName := TreeView_DoorList.Selected.Text;
  stDoorID := TreeView_LocationCode.Items.Item[TreeView_DoorList.Selected.AbsoluteIndex].Text;
  if stDoorID[1] <> 'D' then Exit;
  stNodeNo := copy(stDoorID,2,G_nNodeCodeLength);
  stEcuID := copy(stDoorID,2 + G_nNodeCodeLength,G_nDeviceCodeLength);
  nIndex := DeviceList.IndexOf(stNodeNo + stEcuID);
  if nIndex > -1 then
  begin
    TDevice(DeviceList.Objects[nIndex]).PasswordAllDelete(False);
    showmessage(stSelectName + ':' + dmFormName.GetFormMessage('2','M00042'));
  end;
  PopupMenu.CloseMenu;
end;

procedure TfmMonitoring.mn_AllCardDeleteClick(Sender: TObject);
var
  stDoorID : string;
  stNodeNo : string;
  stEcuID : string;
  nIndex : integer;
  stSelectName : string;
begin
  stSelectName := TreeView_DoorList.Selected.Text;
  stDoorID := TreeView_LocationCode.Items.Item[TreeView_DoorList.Selected.AbsoluteIndex].Text;
  if stDoorID[1] <> 'D' then Exit;
  stNodeNo := copy(stDoorID,2,G_nNodeCodeLength);
  stEcuID := copy(stDoorID,2 + G_nNodeCodeLength,G_nDeviceCodeLength);
  nIndex := DeviceList.IndexOf(stNodeNo + stEcuID);
  if nIndex > -1 then
  begin
    TDevice(DeviceList.Objects[nIndex]).CardAllDelete(False);
    showmessage(stSelectName + ':' + dmFormName.GetFormMessage('2','M00043'));
  end;
  PopupMenu.CloseMenu;
end;

procedure TfmMonitoring.RcvCardAccessEvent(aNodeNo, aECUID, aDoorNo, aReaderNo,
  aInOut, aTime, aCardMode, aDoorMode, aChangeState, aAccessResult, aDoorState,
  aATButton, aCardNo: string);
var
  stDisplay : string;
  stNodeNo : string;
  stEcuID : string;
  stDoorNo : string;
  stTemp1,stTemp2 : string;
begin
  if cmb_ListDoorCode.ItemIndex > 0 then
  begin
    stTemp1 := ListDoorCodeList.Strings[cmb_ListDoorCode.ItemIndex];
    stTemp2 := FillZeroStrNum(aNodeNo,G_nNodeCodeLength) + FillZeroStrNum(aECUID,G_nDeviceCodeLength) + FillZeroStrNum(aDoorNo,G_nDoorCodeLength);
    if stTemp1 <> stTemp2 then Exit;    //선택된 출입문이 아니면
  end;

{  case aDoorMode[1] of
    'o' : begin //운영
      DoorStateChange(aNodeNo,aECUID,aDoorNo,con_DOORLOCKSTATE);
    end;
    'c' : begin //개방
      DoorStateChange(aNodeNo,aECUID,aDoorNo,con_DOOROPENSTATE);
    end;
    else begin //모름
      DoorStateChange(aNodeNo,aECUID,aDoorNo,con_DOORNOTSTATE);
    end;
  end; }

  stDisplay := aNodeNo + ';';
  stDisplay := stDisplay + aECUID + ';';
  stDisplay := stDisplay + aDoorNo + ';';
  stDisplay := stDisplay + aReaderNo + ';';
  stDisplay := stDisplay + aInOut + ';';
  stDisplay := stDisplay + aTime + ';';
  stDisplay := stDisplay + aCardMode + ';';
  stDisplay := stDisplay + aDoorMode + ';';
  stDisplay := stDisplay + aChangeState + ';';
  stDisplay := stDisplay + aAccessResult + ';';
  stDisplay := stDisplay + aDoorState + ';';
  stDisplay := stDisplay + aATButton + ';';
  stDisplay := stDisplay + aCardNo;
  DisplayList.Add(stDisplay);
end;

procedure TfmMonitoring.RcvDoorModeChange(aNodeNo, aECUID, aResult,
  aMode,aDoorState: string);
begin
  if aResult <> '1' then Exit;
  if aMode = '' then
  begin
    DoorStateChange(aNodeNo,aECUID,'1',con_DOORNOTSTATE);
    Exit;
  end;
  case UpperCase(aMode)[1] of
    'O' : begin //개방
      if aDoorState = 'O' then DoorStateChange(aNodeNo,aECUID,'1',con_DOORFREEOPEN)
      else if aDoorState = 'C' then DoorStateChange(aNodeNo,aECUID,'1',con_DOORFREECLOSE)
      else DoorStateChange(aNodeNo,aECUID,'1',con_DOORFREEOPEN);
    end;
    'C' : begin //운영
      if aDoorState = 'O' then DoorStateChange(aNodeNo,aECUID,'1',con_DOORLOCKOPEN)
      else if aDoorState = 'C' then DoorStateChange(aNodeNo,aECUID,'1',con_DOORLOCKCLOSE)
      else DoorStateChange(aNodeNo,aECUID,'1',con_DOORLOCKCLOSE);
    end;
    else begin //모름
      DoorStateChange(aNodeNo,aECUID,'1',con_DOORNOTSTATE);
    end;
  end;
end;

procedure TfmMonitoring.ReceiveDeviceInitialize(aNodeNo, aECUID,
  aResult: string);
var
  stDongName,stAreaName,stDoorName : string;
begin
  if aResult <> '1' then Exit;
  if GetLocationName(aNodeNo,aECUID,'1',stDongName,stAreaName,stDoorName) then
  begin
    showmessage(stDoorName + ':' + dmFormName.GetFormMessage('2','M00044'));
  end else
  begin
    showmessage(aNodeNo + aECUID + ':' + dmFormName.GetFormMessage('2','M00044'));
  end;
end;

procedure TfmMonitoring.SearchTimerTimer(Sender: TObject);
begin
  inherited;
  SearchTimer.Enabled := False;
  if G_bApplicationTerminate then Exit;

  if DisplayList.Count > 0 then
  begin
    BatchDisplay(DisplayList.Strings[0]);
    DisplayList.Delete(0);
  end;
  SearchTimer.Enabled := True;

end;

procedure TfmMonitoring.sg_doorListCheckBoxClick(Sender: TObject; ACol,
  ARow: Integer; State: Boolean);
var
  nIndex : integer;
  i : integer;
begin
  inherited;
  if ARow = 0 then //전체선택 또는 해제
  begin
    SearchDoorCodeList.Clear;
    if State then
    begin
      L_nAddDoorCheckCount := (Sender as TAdvStringGrid).RowCount - 1;
      for i := 1 to (Sender as TAdvStringGrid).RowCount do
      begin
        SearchDoorCodeList.Add((Sender as TAdvStringGrid).Cells[2,i] + (Sender as TAdvStringGrid).Cells[3,i] + (Sender as TAdvStringGrid).Cells[4,i]);
      end;
    end else L_nAddDoorCheckCount := 0;
    AdvStrinGridSetAllCheck(Sender,State);
  end else
  begin
    if State then
    begin
      L_nAddDoorCheckCount := L_nAddDoorCheckCount + 1;
      nIndex := SearchDoorCodeList.IndexOf((Sender as TAdvStringGrid).Cells[2,ARow] + (Sender as TAdvStringGrid).Cells[3,ARow] + (Sender as TAdvStringGrid).Cells[4,ARow]);
      if nIndex < 0 then SearchDoorCodeList.Add((Sender as TAdvStringGrid).Cells[2,ARow] + (Sender as TAdvStringGrid).Cells[3,ARow] + (Sender as TAdvStringGrid).Cells[4,ARow]);
    end else
    begin
      L_nAddDoorCheckCount := L_nAddDoorCheckCount - 1 ;
      nIndex := SearchDoorCodeList.IndexOf((Sender as TAdvStringGrid).Cells[2,ARow] + (Sender as TAdvStringGrid).Cells[3,ARow] + (Sender as TAdvStringGrid).Cells[4,ARow]);
      if nIndex > -1 then SearchDoorCodeList.Delete(nIndex);
    end;
  end;

end;

procedure TfmMonitoring.sg_doorPasswordListCheckBoxClick(Sender: TObject;
  ACol, ARow: Integer; State: Boolean);
begin
  inherited;
  if ARow = 0 then //전체선택 또는 해제
  begin
    if State then
    begin
      L_nDeletePasswordCheckCount := (Sender as TAdvStringGrid).RowCount - 1;
    end else L_nDeletePasswordCheckCount := 0;
    AdvStrinGridSetAllCheck(Sender,State);
  end else
  begin
    if State then
    begin
      L_nDeletePasswordCheckCount := L_nDeletePasswordCheckCount + 1;
    end else
    begin
      L_nDeletePasswordCheckCount := L_nDeletePasswordCheckCount - 1 ;
    end;
  end;

end;

procedure TfmMonitoring.sg_PasswordListCheckBoxClick(Sender: TObject; ACol,
  ARow: Integer; State: Boolean);
var
  nIndex : integer;
  i : integer;
begin
  inherited;
  if ARow = 0 then //전체선택 또는 해제
  begin
    SearchPasswordCodeList.Clear;
    if State then
    begin
      L_nPasswordCheckCount := (Sender as TAdvStringGrid).RowCount - 1;
      for i := 1 to (Sender as TAdvStringGrid).RowCount do
      begin
        SearchPasswordCodeList.Add((Sender as TAdvStringGrid).Cells[1,i]);
      end;
    end else L_nPasswordCheckCount := 0;
    AdvStrinGridSetAllCheck(Sender,State);
  end else
  begin
    if State then
    begin
      L_nPasswordCheckCount := L_nPasswordCheckCount + 1;
    end else
    begin
      L_nPasswordCheckCount := L_nPasswordCheckCount - 1 ;
    end;
  end;

end;

procedure TfmMonitoring.StateAsyncTimer1Timer(Sender: TObject);
var
  i : integer;
begin
  inherited;

  for i := 0 to DeviceList.Count - 1 do
  begin
    if G_bApplicationTerminate then Exit;
    RcvDoorModeChange(inttostr(TDevice(DeviceList.Objects[i]).NodeNo),TDevice(DeviceList.Objects[i]).DeviceID,'1',TDevice(DeviceList.Objects[i]).DoorMode,TDevice(DeviceList.Objects[i]).DoorSTATE);
  end;


end;

procedure TfmMonitoring.TreeView_DoorListClick(Sender: TObject);
var
  stLocateID : string;
  stNodeNo : string;
  stNodeIp : string;
begin
  //TreeView_DoorList.ShowHint := False;
  stLocateID := TreeView_LocationCode.Items.Item[TreeView_DoorList.Selected.AbsoluteIndex].Text;
  if stLocateID[1] <> 'D' then TreeView_DoorList.PopupMenu:= nil
  else
  begin
    TreeView_DoorList.PopupMenu:= PopupMenu;
    stNodeNo := copy(stLocateID,2,G_nNodeCodeLength);
    stNodeIp := GetNodeIP(stNodeNo);
    mn_NodeIP.Caption := 'IP:' + stNodeIp;
    //TreeView_DoorList.Hint := stNodeIp;
    //TreeView_DoorList.ShowHint := True;
  end;

end;

initialization
  RegisterClass(TfmMonitoring);
Finalization
  UnRegisterClass(TfmMonitoring);

end.
