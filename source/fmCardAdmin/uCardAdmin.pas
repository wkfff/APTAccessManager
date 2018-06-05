﻿unit uCardAdmin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, W7Classes, W7Panels, AdvOfficeTabSet,
  AdvOfficeTabSetStylers, AdvSmoothPanel, Vcl.ExtCtrls, AdvSmoothLabel,
  Vcl.StdCtrls, AdvEdit, Vcl.Buttons, Vcl.Grids, AdvObj, BaseGrid, AdvGrid,
  AdvToolBtn,ADODB,ActiveX, uSubForm, CommandArray, AdvCombo, AdvGroupBox,
  Vcl.Mask, AdvSpin, AdvOfficeButtons, AdvToolBar, AdvToolBarStylers, Vcl.Menus;

type
  TfmCardAdmin = class(TfmASubForm)
    Image1: TImage;
    BodyPanel: TW7Panel;
    menuTab: TAdvOfficeTabSet;
    pan_CardList: TAdvSmoothPanel;
    pan_CardAdd: TAdvSmoothPanel;
    ed_name: TAdvEdit;
    btn_Search: TSpeedButton;
    sg_CardList: TAdvStringGrid;
    btn_Delete: TSpeedButton;
    btn_InsertSave: TSpeedButton;
    btn_add: TSpeedButton;
    pan_CardUpdate: TAdvSmoothPanel;
    lb_Company: TAdvSmoothLabel;
    cmb_ListDongCode: TComboBox;
    lb_Depart: TAdvSmoothLabel;
    cmb_ListAreaCode: TComboBox;
    gb_CardInfoAdd: TAdvGroupBox;
    lb_CardnoAdd: TAdvSmoothLabel;
    ed_AddCardNo: TAdvEdit;
    lb_nameAdd: TAdvSmoothLabel;
    ed_AddName: TAdvEdit;
    lb_CompanyAdd: TAdvSmoothLabel;
    cmb_InsertDongCode: TComboBox;
    lb_DepartAdd: TAdvSmoothLabel;
    cmb_InsertAreaCode: TComboBox;
    lb_EmCodeAdd: TAdvSmoothLabel;
    ed_AddPosition: TAdvEdit;
    lb_PhoneAdd: TAdvSmoothLabel;
    ed_AddTelNo: TAdvEdit;
    chk_AccPermit: TAdvOfficeCheckBox;
    ed_OldCardNo: TAdvEdit;
    ed_UpdateCardNo: TAdvEdit;
    lb_CardnoUpdate: TAdvSmoothLabel;
    btn_UpdateSave: TSpeedButton;
    gb_CardInfoUpdate: TAdvGroupBox;
    lb_nameUpdate: TAdvSmoothLabel;
    lb_CompanyUpdate: TAdvSmoothLabel;
    lb_DepartUpdate: TAdvSmoothLabel;
    lb_EmCodeUpdate: TAdvSmoothLabel;
    lb_PhoneUpdate: TAdvSmoothLabel;
    ed_UpdateName: TAdvEdit;
    cmb_UpdateDongCode: TComboBox;
    cmb_UpdateAreaCode: TComboBox;
    ed_UpdatePosition: TAdvEdit;
    ed_UpdateTelNo: TAdvEdit;
    chk_UpdateAccPermit: TAdvOfficeCheckBox;
    ed_UpdateEmCode: TAdvEdit;
    lb_PosiNameUpdate: TAdvSmoothLabel;
    lb_PosiNameAdd: TAdvSmoothLabel;
    ed_AddEmCode: TAdvEdit;
    AdvToolBarOfficeStyler1: TAdvToolBarOfficeStyler;
    AdvOfficeTabSetOfficeStyler1: TAdvOfficeTabSetOfficeStyler;
    PopupMenu1: TPopupMenu;
    pm_update: TMenuItem;
    btn_Excel: TSpeedButton;
    SaveDialog1: TSaveDialog;
    cmb_EtcSearch2: TComboBox;
    ed_EtcSearch: TAdvEdit;
    cmb_EtcSearch1: TComboBox;
    cmb_Condition1: TAdvComboBox;
    cmb_Condition2: TAdvComboBox;
    procedure menuTabChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btn_SearchClick(Sender: TObject);
    procedure lb_page1Click(Sender: TObject);
    procedure lb_NextpageClick(Sender: TObject);
    procedure ed_nameChange(Sender: TObject);
    procedure sg_CardListKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure sg_CardListKeyPress(Sender: TObject; var Key: Char);
    procedure btn_InsertSaveClick(Sender: TObject);
    procedure ed_AddNameKeyPress(Sender: TObject; var Key: Char);
    procedure sg_CardListCheckBoxClick(Sender: TObject; ACol, ARow: Integer;
      State: Boolean);
    procedure btn_DeleteClick(Sender: TObject);
    procedure btn_addClick(Sender: TObject);
    procedure sg_dongCodeColChanging(Sender: TObject; OldCol, NewCol: Integer;
      var Allow: Boolean);
    procedure sg_CardListDblClick(Sender: TObject);
    procedure btn_UpdateSaveClick(Sender: TObject);
    procedure ed_UpdateNameKeyPress(Sender: TObject; var Key: Char);
    procedure cmb_ListDongCodeChange(Sender: TObject);
    procedure cmb_InsertDongCodeChange(Sender: TObject);
    procedure cmb_ListAreaCodeChange(Sender: TObject);
    procedure cmb_UpdateDongCodeChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure pm_updateClick(Sender: TObject);
    procedure btn_ExcelClick(Sender: TObject);
    procedure pan_CardListResize(Sender: TObject);
  private
    ListDongCodeList : TStringList;
    AddDongCodeList : TStringList;
    UpdateDongCodeList : TStringList;
    ListAreaCodeList : TStringList;
    AddAreaCodeList : TStringList;
    UpdateAreaCodeList : TStringList;
    AddNodeCodeList : TStringList;
    UpdateNodeCodeList : TStringList;

    L_nPageGroupMaxCount : integer ; //한페이지 그룹에 해당하는 페이지수
    L_nPageListMaxCount : integer; //한페이지에 출력되는 리스트 갯수
    L_nCurrentPageGroup : integer;   //지금 속한 페이지 그룹
    L_nCurrentPageList : integer;    //지금 조회 하고 있는 페이지
    L_CurrentSaveRow : integer;

    L_nCheckCount : integer;        //체크 된 카운트
    { Private declarations }
    procedure PageTabCreate(aPageGroup,aCurrentPage:integer);
    procedure ShowCardList(aGotoPage,aPageSize:integer;aCurrentCode,aCardNo:string;aTopRow:integer = 0);
    procedure UpdateCell;
    function DeleteCardTable(aCardNo:string):Boolean;
    function InsertTB_CARDNO(aCardNo,aName,aParentCode,aChildCode,aPosition,aEmCode,aTelNo,aAccPermit,aAsync:string):Boolean;

    function GetMaxDeviceNo(aNodeNo:string):integer;
    Function DupCheckCardNo(aCardNo:string;var aDupName:string):Boolean;
    Function CardPermitCopy(aOldCardNo,aNewCardNo:string):Boolean;
    Function CardPermitStop(aOldCardNo:string):Boolean;
  private
    procedure LoadChildCode(aParentCode:string;aPosition:integer;cmbBox:TComboBox;aList:TStringList;aAll:Boolean);

    procedure AdvStrinGridSetAllCheck(Sender: TObject;bchkState:Boolean);
    procedure FormNameSetting;
    procedure FontSetting;
  public
    { Public declarations }
    procedure CardRegisterReadingProcess(aData:string);
    procedure Form_Close;
  end;

var
  fmCardAdmin: TfmCardAdmin;

implementation
uses
  uCommonVariable,
  uDataBase,
  uDBFormName,
  uFormUtil,
  uFunction,
  uFormFontUtil;

{$R *.dfm}


procedure TfmCardAdmin.AdvStrinGridSetAllCheck(Sender: TObject;
  bchkState: Boolean);
var
  i : integer;
begin
    for i:= 1 to (Sender as TAdvStringGrid).RowCount - 1  do
    begin
      (Sender as TAdvStringGrid).SetCheckBoxState(0,i,bchkState);
    end;
end;

procedure TfmCardAdmin.btn_InsertSaveClick(Sender: TObject);
var
  stNodeNo : string;
  stParentCode : string;
  stChildCode : string;
  stName : string;
  stSql : string;
  bResult : Boolean;
  stDupName : string;
  stDeviceID : string;
  stAccPermit : string;
  stMessage : string;
begin
  inherited;
  stName := ed_AddName.Text;
  if stName = '' then
  begin
    showmessage(stringReplace(dmFormName.GetFormMessage('2','M00015'),'$NAME',lb_nameAdd.Caption.Text,[rfReplaceAll]));
    Exit;
  end;

  if ed_AddCardNo.Text = '' then
  begin
    showmessage(stringReplace(dmFormName.GetFormMessage('2','M00015'),'$NAME',lb_CardnoAdd.Caption.Text,[rfReplaceAll]));
    Exit;
  end;
  if Not IsAlphaNumeric(ed_AddCardNo.Text) then
  begin
    showmessage(stringReplace(dmFormName.GetFormMessage('2','M00015'),'$NAME',lb_CardnoAdd.Caption.Text,[rfReplaceAll]));
    Exit;
  end;

  if DupCheckCardNo(ed_AddCardNo.Text,stDupName) then
  begin
    stMessage := dmFormName.GetFormMessage('2','M00022');
    stMessage := stringReplace(stMessage,'$NAME ',stDupName,[rfReplaceAll]);
    showmessage(stMessage);
    Exit;
  end;

  stParentCode := FillZeroNumber(0,G_nBuildingCodeLength);
  stChildCode := FillZeroNumber(0,G_nBuildingCodeLength);
  if cmb_InsertDongCode.itemIndex > -1 then
  begin
    stParentCode := AddDongCodeList.Strings[cmb_InsertDongCode.itemIndex];
  end;
  if cmb_InsertAreaCode.itemIndex > -1 then
  begin
    stChildCode := AddAreaCodeList.Strings[cmb_InsertAreaCode.itemIndex];
  end;
  stAccPermit := 'N';
  if chk_AccPermit.Checked then stAccPermit := 'Y';

  bResult := InsertTB_CARDNO(ed_AddCardNo.Text,stName,stParentCode,stChildCode,ed_AddPosition.Text,ed_AddEmCode.Text,ed_AddTelNo.Text,stAccPermit,'N');

  if bResult then
  begin
    menuTab.ActiveTabIndex := 1;
    menuTabChange(self);
    //PageTabCreate(L_nCurrentPageGroup,L_nCurrentPageList);
    ShowCardList(L_nCurrentPageList,L_nPageListMaxCount,'','');
  end else
  begin
    showmessage(dmFormName.GetFormMessage('2','M00018'));
  end;

end;

procedure TfmCardAdmin.btn_SearchClick(Sender: TObject);
begin
  L_nCurrentPageList := 1;
  //PageTabCreate(0,L_nCurrentPageList);
  ShowCardList(1,L_nPageListMaxCount,'','');
end;

procedure TfmCardAdmin.btn_UpdateSaveClick(Sender: TObject);
var
  stName : string;
  stSql : string;
  bResult : Boolean;
  stDupName : string;
  stParentCode : string;
  stChildCode : string;
  stCardNo : string;
  stAccPermit : string;
  stMessage : string;
begin
  inherited;
  stCardNo := ed_UpdateCardNo.Text;
  if stCardNo = '' then
  begin
    showmessage(stringReplace(dmFormName.GetFormMessage('2','M00015'),'$NAME',lb_CardnoUpdate.Caption.Text,[rfReplaceAll]));
    Exit;
  end;
  if Not IsAlphaNumeric(stCardNo) then
  begin
    showmessage(stringReplace(dmFormName.GetFormMessage('2','M00015'),'$NAME',lb_CardnoAdd.Caption.Text,[rfReplaceAll]));
    Exit;
  end;

  if stCardNo <> ed_OldCardNo.Text then
  begin
    stMessage := dmFormName.GetFormMessage('2','M00023');
    stMessage := stringReplace(stMessage,'$OLD',ed_OldCardNo.Text,[rfReplaceAll]);
    stMessage := stringReplace(stMessage,'$NEW',stCardNo,[rfReplaceAll]);
    if (Application.MessageBox(PChar(stMessage),PChar(dmFormName.GetFormMessage('3','M00008')),MB_OKCANCEL) = IDCANCEL)  then Exit;
    if DupCheckCardNo(stCardNo,stDupName) then
    begin
      stMessage := dmFormName.GetFormMessage('2','M00022');
      stMessage := stringReplace(stMessage,'$NAME ',stDupName,[rfReplaceAll]);
      showmessage(stMessage);
      Exit;
    end;
    CardPermitCopy(ed_OldCardNo.Text,stCardNo); //카드권한 복사
    CardPermitStop(ed_OldCardNo.Text);          //기존카드권한 삭제
  end;

  stName := ed_UpdateName.Text;
  if stName = '' then
  begin
    showmessage(stringReplace(dmFormName.GetFormMessage('2','M00015'),'$NAME',lb_nameUpdate.Caption.Text,[rfReplaceAll]));
    Exit;
  end;

  stParentCode := '';
  stChildCode := '';

  if cmb_UpdateDongCode.itemIndex > -1 then
  begin
    stParentCode := UpdateDongCodeList.strings[cmb_UpdateDongCode.itemIndex];
  end;
  if cmb_UpdateAreaCode.itemIndex > -1 then
  begin
    stChildCode := UpdateAreaCodeList.strings[cmb_UpdateAreaCode.itemIndex];
  end;

  stAccPermit := 'N';
  if chk_UpdateAccPermit.Checked then stAccPermit := 'Y';

  stSql := ' Update TB_CARD set ';
  stSql := stSql + ' CA_CARDNO = ''' + stCardNo + ''',';
  stSql := stSql + ' CA_CODE = ''' + ed_UpdateEmCode.Text + ''',';
  stSql := stSql + ' CA_NAME = ''' + stName + ''',';
  stSql := stSql + ' BC_PARENTCODE = ''' + stParentCode + ''',';
  stSql := stSql + ' BC_CHILDCODE = ''' + stChildCode + ''',';
  stSql := stSql + ' CA_POSITION = ''' + ed_UpdatePosition.Text + ''',';
  stSql := stSql + ' CA_TELNUM = ''' + ed_UpdateTelNo.Text + ''',';
  stSql := stSql + ' CA_ACCPERMIT = ''' + stAccPermit + ''',';
  stSql := stSql + ' CA_ASYNC = ''N'' ';
  stSql := stSql + ' Where GROUP_CODE = ''' + G_stGroupCode + ''' ';
  stSql := stSql + ' AND CA_CARDNO = ''' + ed_OldCardNo.Text + ''' ';

  bResult := dmDatabase.ProcessExecSQL(stSql);

  if bResult then
  begin
    menuTab.ActiveTabIndex := 1;
    menuTabChange(self);
    //PageTabCreate(L_nCurrentPageGroup,L_nCurrentPageList);
    ShowCardList(L_nCurrentPageList,L_nPageListMaxCount,'','');
  end else
  begin
    showmessage(dmFormName.GetFormMessage('2','M00018'));
  end;

end;

function TfmCardAdmin.CardPermitCopy(aOldCardNo, aNewCardNo: string): Boolean;
var
  stSql : string;
begin
  stSql := ' Delete from tb_devicecardno ';
  stSql := stSql + ' Where GROUP_CODE = ''' + G_stGroupCode + ''' ';
  stSql := stSql + ' AND CA_CARDNO = ''' + aNewCardNo + ''' ';

  result := dmDataBase.ProcessExecSQL(stSql);

//여기서 기존 카드 권한을 신규 카드권한으로 복사 하자.
  stSql := 'Insert into tb_devicecardno (  ';
  stSql := stSql + ' GROUP_CODE,ND_NODENO,DE_DEVICEID,CA_CARDNO,DE_DOOR1,DE_DOOR2,DE_USEACCESS,DE_USEALARM,';
  stSql := stSql + ' DE_TIMECODE,DE_PERMIT,DE_RCVACK,DE_UPDATETIME,DE_UPDATEOPERATOR)';
  stSql := stSql + ' select  GROUP_CODE,ND_NODENO,DE_DEVICEID,''' + aNewCardNo + ''',DE_DOOR1,DE_DOOR2,DE_USEACCESS,DE_USEALARM,';
  stSql := stSql + ' DE_TIMECODE,DE_PERMIT,''N'',DE_UPDATETIME,DE_UPDATEOPERATOR ';
  stSql := stSql + ' from tb_devicecardno ';
  stSql := stSql + ' Where GROUP_CODE = ''' + G_stGroupCode + ''' ';
  stSql := stSql + ' AND CA_CARDNO = ''' + aOldCardNo + ''' ';

  result := dmDataBase.ProcessExecSQL(stSql);
end;

function TfmCardAdmin.CardPermitStop(aOldCardNo: string): Boolean;
var
  stSql : string;
begin
  stSql := ' Update tb_devicecardno Set DE_RCVACK = ''N'',DE_PERMIT=''N'' ';
  stSql := stSql + ' Where GROUP_CODE = ''' + G_stGroupCode + ''' ';
  stSql := stSql + ' AND CA_CARDNO = ''' + aOldCardNo + ''' ';

  result := dmDataBase.ProcessExecSQL(stSql);
end;

procedure TfmCardAdmin.CardRegisterReadingProcess(aData: string);
begin
  if pan_CardList.Visible then
  begin
    ShowCardList(1,L_nPageListMaxCount,'',aData);
  end else if pan_CardAdd.Visible then
  begin
    ed_AddCardNo.Text := aData;
    ed_AddName.SetFocus;
  end else if pan_CardUpdate.Visible then
  begin
    ed_UpdateCardNo.Text := aData;
  end;
end;

procedure TfmCardAdmin.cmb_InsertDongCodeChange(Sender: TObject);
var
  stParentCode : string;
begin
  inherited;
  if cmb_InsertDongCode.ItemIndex < 0 then Exit;

  stParentCode := AddDongCodeList.Strings[cmb_InsertDongCode.ItemIndex];
  LoadChildCode(stParentCode,2,cmb_InsertAreaCode,AddAreaCodeList,False);

end;

procedure TfmCardAdmin.cmb_ListAreaCodeChange(Sender: TObject);
begin
  inherited;
//  btn_SearchClick(self);
end;

procedure TfmCardAdmin.cmb_ListDongCodeChange(Sender: TObject);
var
  stParentCode : string;
begin
  inherited;
  stParentCode := ListDongCodeList.Strings[cmb_ListDongCode.ItemIndex];
  LoadChildCode(stParentCode,2,cmb_ListAreaCode,ListAreaCodeList,True);
//  btn_SearchClick(self);
end;

procedure TfmCardAdmin.cmb_UpdateDongCodeChange(Sender: TObject);
var
  stNodeNo : string;
begin
  inherited;
  if cmb_UpdateDongCode.itemIndex < 0 then Exit;
  stNodeNo := UpdateDongCodeList.strings[cmb_UpdateDongCode.itemIndex];
  LoadChildCode(stNodeNo,2,cmb_UpdateAreaCode,UpdateAreaCodeList,False);

end;


function TfmCardAdmin.DeleteCardTable(aCardNo: string): Boolean;
var
  stSql : string;
begin
  stSql := ' Delete From TB_CARD ';
  stSql := stSql + ' Where GROUP_CODE = ''' + G_stGroupCode + ''' ';
  stSql := stSql + ' AND CA_CARDNO = ''' + aCardNo + ''' ';

  result := dmDataBase.ProcessExecSQL(stSql);

end;

function TfmCardAdmin.DupCheckCardNo(aCardNo: string;
  var aDupName: string): Boolean;
var
  stSql : string;
  TempAdoQuery : TADOQuery;
begin
  result := False;
  Try
    CoInitialize(nil);
    TempAdoQuery := TADOQuery.Create(nil);
    TempAdoQuery.Connection := dmDataBase.ADOConnection;

    stSql := 'Select * from TB_CARD ';
    stSql := stSql + ' Where GROUP_CODE = ''' + G_stGroupCode + ''' ';
    stSql := stSql + ' AND CA_CARDNO = ''' + aCardNo + ''' ' ;

    with TempAdoQuery do
    begin
      Close;
      Sql.Text := stSql;
      Try
        Open;
      Except
        Exit;
      End;
      if recordCount < 1 then Exit;

      First;
      aDupName := FindField('CA_NAME').AsString;
      result := True;
    end;
  Finally
    TempAdoQuery.Free;
    CoUninitialize;
  End;
end;

procedure TfmCardAdmin.ed_nameChange(Sender: TObject);
begin
  inherited;
  L_nCurrentPageList := 1;
  //PageTabCreate(0,L_nCurrentPageList);
//  ShowCardList(1,L_nPageListMaxCount,'','');
end;

procedure TfmCardAdmin.ed_UpdateNameKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if Key = #13 then
  begin
    btn_UpdateSaveClick(self);
  end;

end;

procedure TfmCardAdmin.ed_AddNameKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  if Key = #13 then
  begin
    Perform(WM_NEXTDLGCTL,0,0);
  end;
end;

procedure TfmCardAdmin.FontSetting;
begin
  dmFormFontUtil.TravelFormFontSetting(self,G_stFontName,inttostr(G_nFontSize));
  dmFormFontUtil.TravelAdvOfficeTabSetOfficeStylerFontSetting(AdvOfficeTabSetOfficeStyler1, G_stFontName,inttostr(G_nFontSize));
  dmFormFontUtil.FormAdvOfficeTabSetOfficeStylerSetting(AdvOfficeTabSetOfficeStyler1,G_stFormStyle);
  dmFormFontUtil.FormAdvToolBarOfficeStylerSetting(AdvToolBarOfficeStyler1,G_stFormStyle);
  dmFormFontUtil.FormStyleSetting(self,AdvToolBarOfficeStyler1);

end;

procedure TfmCardAdmin.FormActivate(Sender: TObject);
begin
  inherited;
  WindowState := wsMaximized;
end;

procedure TfmCardAdmin.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  self.FindSubForm('Main').FindCommand('FORMENABLE').Params.Values['NAME'] := inttostr(FORMCARDADMIN);
  self.FindSubForm('Main').FindCommand('FORMENABLE').Params.Values['VALUE'] := 'FALSE';
  self.FindSubForm('Main').FindCommand('FORMENABLE').Execute;

  ListDongCodeList.Free;
  AddDongCodeList.Free;
  UpdateDongCodeList.Free;
  ListAreaCodeList.Free;
  AddAreaCodeList.Free;
  UpdateAreaCodeList.Free;
  AddNodeCodeList.Free;
  UpdateNodeCodeList.Free;

  Action := caFree;
end;

procedure TfmCardAdmin.FormCreate(Sender: TObject);
begin
  Height := G_nChildFormDefaultHeight;

  ListDongCodeList := TStringList.Create;
  AddDongCodeList := TStringList.Create;
  UpdateDongCodeList := TStringList.Create;
  ListAreaCodeList := TStringList.Create;
  AddAreaCodeList := TStringList.Create;
  UpdateAreaCodeList := TStringList.Create;
  AddNodeCodeList := TStringList.Create;
  UpdateNodeCodeList := TStringList.Create;

  L_nPageGroupMaxCount :=5 ; //한페이지 그룹에 해당하는 페이지수
  L_nPageListMaxCount :=16; //한페이지에 출력되는 리스트 갯수
  //L_nPageListMaxCount :=2; //한페이지에 출력되는 리스트 갯수

  menuTab.ActiveTabIndex := 1;
  menuTabChange(self);

  LoadChildCode(FillZeroNumber(0,G_nBuildingCodeLength),1,cmb_ListDongCode,ListDongCodeList,True);
  LoadChildCode(FillZeroNumber(0,G_nBuildingCodeLength),1,cmb_InsertDongCode,AddDongCodeList,False);
  LoadChildCode(FillZeroNumber(0,G_nBuildingCodeLength),1,cmb_UpdateDongCode,UpdateDongCodeList,False);
  LoadChildCode('',2,cmb_ListAreaCode,ListAreaCodeList,True);
  LoadChildCode('',2,cmb_InsertAreaCode,AddAreaCodeList,False);
  LoadChildCode('',2,cmb_UpdateAreaCode,UpdateAreaCodeList,False);
  FontSetting;
end;


procedure TfmCardAdmin.FormNameSetting;
begin
  Caption := dmFormName.GetFormMessage('1','M00017');
  menuTab.AdvOfficeTabs[0].Caption := dmFormName.GetFormMessage('1','M00035');
  menuTab.AdvOfficeTabs[1].Caption := dmFormName.GetFormMessage('1','M00044');
  menuTab.AdvOfficeTabs[2].Caption := dmFormName.GetFormMessage('1','M00045');
  pan_CardList.Caption.Text := dmFormName.GetFormMessage('1','M00044');
  pan_CardAdd.Caption.Text := dmFormName.GetFormMessage('1','M00045');
  pan_CardUpdate.Caption.Text := dmFormName.GetFormMessage('1','M00046');
  lb_Company.Caption.Text := dmFormName.GetFormMessage('4','M00004');
  lb_CompanyAdd.Caption.Text := dmFormName.GetFormMessage('4','M00004');
  lb_CompanyUpdate.Caption.Text := dmFormName.GetFormMessage('4','M00004');
  lb_Depart.Caption.Text := dmFormName.GetFormMessage('4','M00005');
  lb_DepartAdd.Caption.Text := dmFormName.GetFormMessage('4','M00005');
  lb_DepartUpdate.Caption.Text := dmFormName.GetFormMessage('4','M00005');
  lb_nameAdd.Caption.Text := dmFormName.GetFormMessage('4','M00006');
  lb_nameUpdate.Caption.Text := dmFormName.GetFormMessage('4','M00006');
  lb_PosiNameAdd.Caption.Text := dmFormName.GetFormMessage('4','M00018');
  lb_PosiNameUpdate.Caption.Text := dmFormName.GetFormMessage('4','M00018');
  lb_EmCodeAdd.Caption.Text := dmFormName.GetFormMessage('4','M00011');
  lb_EmCodeUpdate.Caption.Text := dmFormName.GetFormMessage('4','M00011');
  lb_PhoneAdd.Caption.Text := dmFormName.GetFormMessage('4','M00019');
  lb_PhoneUpdate.Caption.Text := dmFormName.GetFormMessage('4','M00019');
  lb_CardnoAdd.Caption.Text := dmFormName.GetFormMessage('4','M00012');
  lb_CardnoUpdate.Caption.Text := dmFormName.GetFormMessage('4','M00012');
  gb_CardInfoAdd.Caption := dmFormName.GetFormMessage('4','M00020');
  gb_CardInfoUpdate.Caption := dmFormName.GetFormMessage('4','M00020');
  chk_AccPermit.Caption := dmFormName.GetFormMessage('4','M00021');
  chk_UpdateAccPermit.Caption := dmFormName.GetFormMessage('4','M00021');

  btn_Search.Caption :=  dmFormName.GetFormMessage('4','M00007');
  btn_InsertSave.Caption :=  dmFormName.GetFormMessage('4','M00014');
  btn_UpdateSave.Caption :=  dmFormName.GetFormMessage('4','M00014');
  btn_add.Caption :=  dmFormName.GetFormMessage('4','M00077');
  btn_Delete.Caption :=  dmFormName.GetFormMessage('4','M00078');
  pm_update.Caption := dmFormName.GetFormMessage('4','M00098');

  with sg_CardList do
  begin
    cells[1,0] := dmFormName.GetFormMessage('4','M00004');
    cells[2,0] := dmFormName.GetFormMessage('4','M00005');
    cells[3,0] := dmFormName.GetFormMessage('4','M00018');
    cells[4,0] := dmFormName.GetFormMessage('4','M00011');
    cells[5,0] := dmFormName.GetFormMessage('4','M00006');
    cells[6,0] := dmFormName.GetFormMessage('4','M00012');
    cells[7,0] := dmFormName.GetFormMessage('4','M00019');
    cells[8,0] := dmFormName.GetFormMessage('4','M00022');
    cells[9,0] := dmFormName.GetFormMessage('4','M00097');
    cells[10,0] := dmFormName.GetFormMessage('4','M00103');
    Hint := dmFormName.GetFormMessage('2','M00012');
  end;

  cmb_EtcSearch1.Clear;
  cmb_EtcSearch1.Items.Add(dmFormName.GetFormMessage('4','M00006'));
  cmb_EtcSearch1.Items.Add(dmFormName.GetFormMessage('4','M00018'));
  cmb_EtcSearch1.Items.Add(dmFormName.GetFormMessage('4','M00011'));
  cmb_EtcSearch1.Items.Add(dmFormName.GetFormMessage('4','M00019'));
  cmb_EtcSearch1.ItemIndex := 0;

  cmb_EtcSearch2.Clear;
  cmb_EtcSearch2.Items.Add(dmFormName.GetFormMessage('4','M00006'));
  cmb_EtcSearch2.Items.Add(dmFormName.GetFormMessage('4','M00018'));
  cmb_EtcSearch2.Items.Add(dmFormName.GetFormMessage('4','M00011'));
  cmb_EtcSearch2.Items.Add(dmFormName.GetFormMessage('4','M00019'));
  cmb_EtcSearch2.ItemIndex := 1;

  cmb_Condition1.Clear;
  cmb_Condition1.Items.Add(dmFormName.GetFormMessage('4','M00137'));
  cmb_Condition1.Items.Add(dmFormName.GetFormMessage('4','M00138'));
  cmb_Condition1.Items.Add(dmFormName.GetFormMessage('4','M00139'));
  cmb_Condition1.ItemIndex := 0;
  cmb_Condition2.Clear;
  cmb_Condition2.Items.Add(dmFormName.GetFormMessage('4','M00137'));
  cmb_Condition2.Items.Add(dmFormName.GetFormMessage('4','M00138'));
  cmb_Condition2.Items.Add(dmFormName.GetFormMessage('4','M00139'));
  cmb_Condition2.ItemIndex := 0;
end;

procedure TfmCardAdmin.FormResize(Sender: TObject);
begin
  BodyPanel.Left := 0;
  BodyPanel.Top := 0;
  BodyPanel.Height := Height - menuTab.Height;

end;

procedure TfmCardAdmin.FormShow(Sender: TObject);
begin
  top := 0;
  Left := 0;
  Width := BodyPanel.Width;

  L_nCurrentPageGroup := 0;
  //PageTabCreate(L_nCurrentPageGroup,1);
  ShowCardList(1,L_nPageListMaxCount,'','');

  self.FindSubForm('Main').FindCommand('FORMENABLE').Params.Values['NAME'] := inttostr(FORMCARDADMIN);
  self.FindSubForm('Main').FindCommand('FORMENABLE').Params.Values['VALUE'] := 'TRUE';
  self.FindSubForm('Main').FindCommand('FORMENABLE').Execute;
  FormNameSetting;
end;

procedure TfmCardAdmin.Form_Close;
begin
  Close;
end;

function TfmCardAdmin.GetMaxDeviceNo(aNodeNo: string): integer;
var
  nDeviceNo : integer;
  stSql : string;
  TempAdoQuery : TADOQuery;
begin
  nDeviceNo := 0;
  Try
    CoInitialize(nil);
    TempAdoQuery := TADOQuery.Create(nil);
    TempAdoQuery.Connection := dmDataBase.ADOConnection;

    stSql := 'Select Max(DE_DEVICEID) as DE_DEVICEID from TB_DOOR ';
    stSql := stSql + ' Where GROUP_CODE = ''' + G_stGroupCode + ''' ';
    stSql := stSql + ' AND ND_NODENO = ' + aNodeNo ;

    with TempAdoQuery do
    begin
      Close;
      Sql.Text := stSql;
      Try
        Open;
      Except
        Exit;
      End;
      if recordCount < 1 then Exit;

      if Not isDigit(FindField('DE_DEVICEID').asstring) then Exit;

      nDeviceNo := strtoint(FindField('DE_DEVICEID').asstring) + 1;

    end;
  Finally
    result := nDeviceNo;
    TempAdoQuery.Free;
    CoUninitialize;
  End;
end;



function TfmCardAdmin.InsertTB_CARDNO(aCardNo, aName, aParentCode, aChildCode,
  aPosition,aEmCode, aTelNo, aAccPermit, aAsync: string): Boolean;
var
  stSql : string;
begin
  stSql := ' Insert Into TB_CARD (';
  stSql := stSql + ' GROUP_CODE,';
  stSql := stSql + ' CA_CARDNO,';
  stSql := stSql + ' CA_CODE,';
  stSql := stSql + ' CA_NAME,';
  stSql := stSql + ' BC_PARENTCODE,';
  stSql := stSql + ' BC_CHILDCODE,';
  stSql := stSql + ' CA_POSITION,';
  stSql := stSql + ' CA_TELNUM,';
  stSql := stSql + ' CA_ACCPERMIT,';
  stSql := stSql + ' CA_ASYNC) ';
  stSql := stSql + ' VALUES( ';
  stSql := stSql + '''' + G_stGroupCode + ''',';
  stSql := stSql + '''' + aCardNo + ''',';
  stSql := stSql + '''' + aEmCode + ''',';
  stSql := stSql + '''' + aName + ''',';
  stSql := stSql + '''' + aParentCode + ''',';
  stSql := stSql + '''' + aChildCode + ''',';
  stSql := stSql + '''' + aPosition + ''',';
  stSql := stSql + '''' + aTelNo + ''',';
  stSql := stSql + '''' + aAccPermit + ''',';
  stSql := stSql + '''' + aAsync + ''') ';

  result := dmDataBase.ProcessExecSQL(stSql);
end;

procedure TfmCardAdmin.lb_NextpageClick(Sender: TObject);
begin
  inherited;
  L_nCurrentPageGroup := TLabel(Sender).Tag;
  //PageTabCreate(L_nCurrentPageGroup,L_nCurrentPageList);
  ShowCardList(L_nCurrentPageList,L_nPageListMaxCount,'','');

end;

procedure TfmCardAdmin.lb_page1Click(Sender: TObject);
begin
  inherited;
  Try
    L_nCurrentPageList := TLabel(Sender).tag;
    //PageTabCreate(L_nCurrentPageGroup,L_nCurrentPageList);
    ShowCardList(L_nCurrentPageList,L_nPageListMaxCount,'','');
  Except
    Exit;
  End;

end;

procedure TfmCardAdmin.LoadChildCode(aParentCode: string; aPosition: integer;
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


procedure TfmCardAdmin.menuTabChange(Sender: TObject);
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
  end else if menuTab.ActiveTabIndex = 1 then
  begin
    menuTab.AdvOfficeTabs.Items[0].Caption := dmFormName.GetFormMessage('1','M00035');
    pan_CardList.Visible := True;
    pan_CardAdd.Visible := False;
    pan_CardList.Align := alClient;
    pan_CardUpdate.Visible := False;
  end else if menuTab.ActiveTabIndex = 2 then
  begin
    LoadChildCode(FillZeroNumber(0,G_nBuildingCodeLength),1,cmb_InsertDongCode,AddDongCodeList,False);
    cmb_InsertdongCodeChange(self);

    if cmb_ListDongCode.ItemIndex > 0 then
    begin
      stBuildingCode := ListDongCodeList.Strings[cmb_ListDongCode.ItemIndex];
      cmb_InsertDongCode.ItemIndex := AddDongCodeList.IndexOf(stBuildingCode);
      cmb_InsertdongCodeChange(self);
      if cmb_ListAreaCode.ItemIndex > 0 then
      begin
        stAreaCode := ListAreaCodeList.Strings[cmb_ListAreaCode.ItemIndex];
        cmb_InsertAreaCode.ItemIndex := AddAreaCodeList.IndexOf(stAreaCode);
      end;
    end;
    menuTab.AdvOfficeTabs.Items[0].Caption := dmFormName.GetFormMessage('1','M00040');
    pan_CardList.Visible := False;
    pan_CardAdd.Visible := True;
    pan_CardAdd.Align := alClient;
    ed_AddCardNo.Text := '';
    ed_AddName.Text := '';
    ed_AddPosition.Text := '';
    ed_AddTelNo.Text := '';
    chk_AccPermit.Checked := True;
    pan_CardUpdate.Visible := False;
  end;
end;

procedure TfmCardAdmin.PageTabCreate(aPageGroup,aCurrentPage: integer);
var
  stSql : string;
  TempAdoQuery : TADOQuery;
  i : integer;
  oLabel : TLabel;
  nCurrentPageStart : integer;
  nCurrentPageNo : integer;
begin

  for i := 1 to L_nPageGroupMaxCount do
  begin
    oLabel := TravelPanelLabelItem(TPanel(pan_CardList),'lb_page',i);
    if oLabel <> nil then oLabel.Visible := False;
  end;

  nCurrentPageStart := (aPageGroup * L_nPageGroupMaxCount) + 1;

  Try
    CoInitialize(nil);
    TempAdoQuery := TADOQuery.Create(nil);
    TempAdoQuery.Connection := dmDataBase.ADOConnection;

    with TempAdoQuery do
    begin
      stSql := ' Select count(*) as cnt from TB_DOOR ';
      stSql := stSql + ' Where GROUP_CODE = ''' + G_stGroupCode+ ''' ';
      if cmb_ListDongCode.ItemIndex > 0 then
      begin
        stSql := stSql + ' AND BC_PARENTCODE = ''' + ListDongCodeList.Strings[cmb_ListDongCode.ItemIndex] + ''' ';
      end;
      if cmb_ListAreaCode.ItemIndex > 0 then
      begin
        stSql := stSql + ' AND BC_CHILDCODE = ''' + ListAreaCodeList.Strings[cmb_ListAreaCode.ItemIndex] + ''' ';
      end;
      if ed_name.Text <> '' then
      begin
        stSql := stSql + ' AND DO_NAME Like ''%' + ed_name.Text + '%'' ';
      end;

      Close;
      Sql.Clear;
      Sql.Text := stSql;
      Try
        Open;
      Except
        Exit;
      End;

      if RecordCount < 1 then Exit;
      if FindField('cnt').AsInteger > ((nCurrentPageStart - 1) * L_nPageListMaxCount)   then  //현재 페이지에 데이터가 있으면
      begin
        //for i := nCurrentPageStart + 1 to (nCurrentPageStart + L_nPageGroupMaxCount) do
        for i := 1 to L_nPageGroupMaxCount do
        begin
          oLabel := TravelPanelLabelItem(TPanel(pan_CardList),'lb_page',i);
          if oLabel <> nil then
          begin
            TAdvSmoothLabel(oLabel).Visible := true;
            TAdvSmoothLabel(oLabel).Caption.Text := '[' + inttostr((nCurrentPageStart + i -1)) + ']';
            TAdvSmoothLabel(oLabel).Tag := i + nCurrentPageStart -1;
            if aCurrentPage = (nCurrentPageStart + i -1) then
            begin
              //여기서 색깔 넣자
              TAdvSmoothLabel(oLabel).Caption.ColorStart := clRed;
            end else
            begin
              TAdvSmoothLabel(oLabel).Caption.ColorStart := clBlue;
            end;
          end;
          if ((nCurrentPageStart + i -1) * L_nPageListMaxCount) >= FindField('cnt').AsInteger then break; //마지막 페이지 이면 빠져 나가자.
        end;
        if ((nCurrentPageStart + L_nPageGroupMaxCount) * L_nPageListMaxCount) < FindField('cnt').AsInteger then
        begin
          //[다음] 페이지가 존재 하면
        end;
      end;

    end;
  Finally
    TempAdoQuery.Free;
    CoUninitialize;
  End;
end;


procedure TfmCardAdmin.pan_CardListResize(Sender: TObject);
begin
  inherited;
  sg_CardList.Width := pan_CardList.Width - (sg_CardList.Left * 2);
  sg_CardList.Height := pan_CardList.Height - sg_CardList.Top - btn_add.Height - 60;
  btn_add.Top := pan_CardList.Height - 50 - btn_add.Height;
  btn_Delete.Top := pan_CardList.Height - 50 - btn_Delete.Height;
  btn_add.Left := sg_CardList.Left + sg_CardList.Width - btn_add.Width - btn_Delete.Width - 20;
  btn_Delete.Left := sg_CardList.Left + sg_CardList.Width - btn_Delete.Width;

end;

procedure TfmCardAdmin.pm_updateClick(Sender: TObject);
begin
  inherited;
  sg_CardListDblClick(sg_CardList);
end;

procedure TfmCardAdmin.sg_CardListCheckBoxClick(Sender: TObject; ACol,
  ARow: Integer; State: Boolean);
begin
  if ARow = 0 then //전체선택 또는 해제
  begin
    if State then L_nCheckCount := (Sender as TAdvStringGrid).RowCount - 1
    else L_nCheckCount := 0;
    AdvStrinGridSetAllCheck(Sender,State);
  end else
  begin
    if State then L_nCheckCount := L_nCheckCount + 1
    else L_nCheckCount := L_nCheckCount - 1 ;
  end;

end;

procedure TfmCardAdmin.sg_dongCodeColChanging(Sender: TObject; OldCol,
  NewCol: Integer; var Allow: Boolean);
begin
  inherited;
  with sg_CardList do
  begin
    if NewCol = 0 then Options := Options + [goEditing]
    else Options := Options - [goEditing];
  end;

end;

procedure TfmCardAdmin.sg_CardListDblClick(Sender: TObject);
var
  nIndex : integer;
begin
  inherited;

  with sg_CardList do
  begin
    if cells[6,Row] = '' then Exit;
    ed_UpdateEmCode.Text := cells[4,Row];
    ed_UpdateName.Text := cells[5,Row];
    ed_OldCardNo.Text := cells[6,Row];
    ed_UpdateCardNo.Text := cells[6,Row];

    LoadChildCode(FillZeroNumber(0,G_nBuildingCodeLength),1,cmb_UpdateDongCode,UpdateDongCodeList,False);
    nIndex := UpdateDongCodeList.IndexOf(cells[9,Row]);
    cmb_UpdateDongCode.itemIndex := nIndex;
    cmb_UpdateDongCodeChange(self);
    nIndex := UpdateAreaCodeList.IndexOf(cells[10,Row]);
    cmb_UpdateAreaCode.itemIndex := nIndex;
    if cells[8,Row] = 'Y' then chk_UpdateAccPermit.Checked := True
    else chk_UpdateAccPermit.Checked := False;

    ed_UpdatePosition.text :=cells[3,Row];
    ed_UpdateTelNo.Text := cells[7,Row];
  end;

  menuTab.AdvOfficeTabs.Items[0].Caption := dmFormName.GetFormMessage('1','M00040');
  pan_CardUpdate.Visible := True;
  pan_CardUpdate.Align := alClient;
  pan_CardList.Visible := False;
  pan_CardAdd.Visible := False;

  ed_UpdateName.SelectAll;
  ed_UpdateName.SetFocus;

end;

procedure TfmCardAdmin.sg_CardListKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  if Key = #13 then
  begin
    L_CurrentSaveRow := sg_CardList.Row;
    //SaveUpdateCell;
  end;

end;

procedure TfmCardAdmin.sg_CardListKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  L_CurrentSaveRow := sg_CardList.Row;
  if (Key <> VK_RETURN) and
     (Key <> VK_UP) and
     (Key <> VK_DOWN) then UpdateCell;

end;

procedure TfmCardAdmin.ShowCardList(aGotoPage, aPageSize: integer;
  aCurrentCode,aCardNo: string; aTopRow: integer);
var
  stSql : string;
  TempAdoQuery : TADOQuery;
  nRow : integer;
begin
  btn_Excel.Enabled := False;
  GridInit(sg_CardList,8,2,true);
  L_nCheckCount := 0;

  //stSql := 'SELECT TOP ' + inttostr(aPageSize) + ' a.*,b.BC_NAME as DONGNAME,c.BC_NAME as AREANAME FROM ';
  stSql := 'SELECT a.*,b.BC_NAME as COMPANYNAME,c.BC_NAME as DEPARTNAME FROM ';
  stSql := stSql + ' (  ';
  stSql := stSql + ' (  ';
  stSql := stSql + ' TB_CARD a ';
  stSql := stSql + ' Left Join (select * from TB_BUILDINGCODE where BC_POSITION = 1) b';
  stSql := stsql + ' ON (a.GROUP_CODE = b.GROUP_CODE )';
  stSql := stSql + ' AND (a.BC_PARENTCODE = b.BC_CHILDCODE) ';
  stSql := stSql + ' ) ';
  stSql := stSql + ' Left Join (select * from TB_BUILDINGCODE where BC_POSITION = 2) c ';
  stSql := stsql + ' ON (a.GROUP_CODE = c.GROUP_CODE )';
  stSql := stSql + ' AND (a.BC_PARENTCODE = c.BC_PARENTCODE) ';
  stSql := stSql + ' AND (a.BC_CHILDCODE = c.BC_CHILDCODE) ';
  stSql := stSql + ' ) ';
  stSql := stSql + '  Where a.GROUP_CODE = ''' + G_stGroupCode + ''' ';
  {if (aGotoPage > 1) then
  begin
    stSql := stSql + ' AND a.idx not in ';
    stSql := stSql + ' (SELECT TOP ' + inttostr((aGotoPage - 1) * aPageSize) + ' idx FROM TB_DOOR ';
    stSql := stSql + '  Where GROUP_CODE = ''' + G_stGroupCode + ''' ';
    if cmb_ListDongCode.ItemIndex > 0 then
    begin
      stSql := stSql + ' AND BC_PARENTCODE = ''' + ListDongCodeList.Strings[cmb_ListDongCode.ItemIndex] + ''' ';
    end;
    if cmb_ListAreaCode.ItemIndex > 0 then
    begin
      stSql := stSql + ' AND BC_CHILDCODE = ''' + ListAreaCodeList.Strings[cmb_ListAreaCode.ItemIndex] + ''' ';
    end;
    if ed_name.Text <> '' then
    begin
      stSql := stSql + ' AND CA_NAME Like ''%' + ed_name.Text + '%'' ';
    end;
    if aCardNo <> '' then stSql := stSql + ' AND CA_CARDNO = ''' + aCardNo + ''' ';
    stSql := stSql + '  ORDER BY idx ) ';
  end; }
  if cmb_ListDongCode.ItemIndex > 0 then
  begin
    stSql := stSql + ' AND a.BC_PARENTCODE = ''' + ListDongCodeList.Strings[cmb_ListDongCode.ItemIndex] + ''' ';
  end;
  if cmb_ListAreaCode.ItemIndex > 0 then
  begin
    stSql := stSql + ' AND a.BC_CHILDCODE = ''' + ListAreaCodeList.Strings[cmb_ListAreaCode.ItemIndex] + ''' ';
  end;
  if ed_name.Text <> '' then
  begin
    if cmb_EtcSearch1.ItemIndex = 0 then
    begin
      if cmb_Condition1.ItemIndex = 0 then stSql := stSql + ' AND a.CA_NAME = ''' + ed_name.Text + ''' '
      else if cmb_Condition1.ItemIndex = 1 then stSql := stSql + ' AND a.CA_NAME Like ''%' + ed_name.Text + '%'' '
      else if cmb_Condition1.ItemIndex = 2 then stSql := stSql + ' AND a.CA_NAME Like ''' + ed_name.Text + '%'' '
      ;
    end else if cmb_EtcSearch1.ItemIndex = 1 then
    begin
      if cmb_Condition1.ItemIndex = 0 then stSql := stSql + ' AND a.CA_POSITION = ''' + ed_name.Text + ''' '
      else if cmb_Condition1.ItemIndex = 1 then stSql := stSql + ' AND a.CA_POSITION Like ''%' + ed_name.Text + '%'' '
      else if cmb_Condition1.ItemIndex = 2 then stSql := stSql + ' AND a.CA_POSITION Like ''' + ed_name.Text + '%'' '
      ;
    end else if cmb_EtcSearch1.ItemIndex = 2 then
    begin
      if cmb_Condition1.ItemIndex = 0 then stSql := stSql + ' AND a.CA_CODE = ''' + ed_name.Text + ''' '
      else if cmb_Condition1.ItemIndex = 1 then stSql := stSql + ' AND a.CA_CODE Like ''%' + ed_name.Text + '%'' '
      else if cmb_Condition1.ItemIndex = 2 then stSql := stSql + ' AND a.CA_CODE Like ''' + ed_name.Text + '%'' '
      ;
    end else if cmb_EtcSearch1.ItemIndex = 3 then
    begin
      if cmb_Condition1.ItemIndex = 0 then stSql := stSql + ' AND a.CA_TELNUM = ''' + ed_name.Text + ''' '
      else if cmb_Condition1.ItemIndex = 1 then stSql := stSql + ' AND a.CA_TELNUM Like ''%' + ed_name.Text + '%'' '
      else if cmb_Condition1.ItemIndex = 2 then stSql := stSql + ' AND a.CA_TELNUM Like ''' + ed_name.Text + '%'' '
      ;
    end;
  end;
  if aCardNo <> '' then stSql := stSql + ' AND a.CA_CARDNO = ''' + aCardNo + ''' ';
  if ed_EtcSearch.Text <> '' then
  begin
    if cmb_EtcSearch2.ItemIndex = 0 then
    begin
      if cmb_Condition2.ItemIndex = 0 then stSql := stSql + ' AND a.CA_NAME = ''' + ed_EtcSearch.Text + ''' '
      else if cmb_Condition2.ItemIndex = 1 then stSql := stSql + ' AND a.CA_NAME Like ''%' + ed_EtcSearch.Text + '%'' '
      else if cmb_Condition2.ItemIndex = 2 then stSql := stSql + ' AND a.CA_NAME Like ''' + ed_EtcSearch.Text + '%'' '
      ;
    end else if cmb_EtcSearch2.ItemIndex = 1 then
    begin
      if cmb_Condition2.ItemIndex = 0 then stSql := stSql + ' AND a.CA_POSITION = ''' + ed_EtcSearch.Text + ''' '
      else if cmb_Condition2.ItemIndex = 1 then stSql := stSql + ' AND a.CA_POSITION Like ''%' + ed_EtcSearch.Text + '%'' '
      else if cmb_Condition2.ItemIndex = 2 then stSql := stSql + ' AND a.CA_POSITION Like ''' + ed_EtcSearch.Text + '%'' '
      ;
    end else if cmb_EtcSearch2.ItemIndex = 2 then
    begin
      if cmb_Condition2.ItemIndex = 0 then stSql := stSql + ' AND a.CA_CODE = ''' + ed_EtcSearch.Text + ''' '
      else if cmb_Condition2.ItemIndex = 1 then stSql := stSql + ' AND a.CA_CODE Like ''%' + ed_EtcSearch.Text + '%'' '
      else if cmb_Condition2.ItemIndex = 2 then stSql := stSql + ' AND a.CA_CODE Like ''' + ed_EtcSearch.Text + '%'' ';
    end else if cmb_EtcSearch2.ItemIndex = 3 then
    begin
      if cmb_Condition2.ItemIndex = 0 then stSql := stSql + ' AND a.CA_TELNUM = ''' + ed_EtcSearch.Text + ''' '
      else if cmb_Condition2.ItemIndex = 1 then stSql := stSql + ' AND a.CA_TELNUM Like ''%' + ed_EtcSearch.Text + '%'' '
      else if cmb_Condition2.ItemIndex = 2 then stSql := stSql + ' AND a.CA_TELNUM Like ''' + ed_EtcSearch.Text + '%'' ';
    end;
  end;
  stSql := stSql + ' ORDER BY a.idx  ';

  Try
    CoInitialize(nil);
    TempAdoQuery := TADOQuery.Create(nil);
    TempAdoQuery.Connection := dmDataBase.ADOConnection;

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
      with sg_CardList do
      begin
        nRow := 1;
        RowCount := RecordCount + 1;
        while Not Eof do
        begin
          AddCheckBox(0,nRow,False,False);
          cells[1,nRow] := FindField('COMPANYNAME').AsString;
          cells[2,nRow] := FindField('DEPARTNAME').AsString;
          cells[3,nRow] := FindField('CA_POSITION').AsString;
          cells[4,nRow] := FindField('CA_CODE').AsString;
          cells[5,nRow] := FindField('CA_NAME').AsString;
          cells[6,nRow] := FindField('CA_CARDNO').AsString;
          cells[7,nRow] := FindField('CA_TELNUM').AsString;
          cells[8,nRow] := FindField('CA_ACCPERMIT').AsString;
          cells[9,nRow] := FindField('BC_PARENTCODE').AsString;
          cells[10,nRow] := FindField('BC_CHILDCODE').AsString;
          if (FindField('CA_CARDNO').AsString )  = aCurrentCode then
          begin
            SelectRows(nRow,1);
          end;

          nRow := nRow + 1;
          Next;
        end;
        if aTopRow = 0 then
        begin
          if Row > (L_nPageListMaxCount - 1) then TopRow := Row - L_nPageListMaxCount;
        end else
        begin
          TopRow := aTopRow;
        end;
      end;
      btn_Excel.Enabled := True;
    end;
  Finally
    TempAdoQuery.Free;
    CoUninitialize;
  End;

end;

procedure TfmCardAdmin.btn_addClick(Sender: TObject);
begin
  inherited;
  menutab.ActiveTabIndex := 2;
  menutabChange(self);
end;

procedure TfmCardAdmin.btn_DeleteClick(Sender: TObject);
var
  i : integer;
  bChkState : Boolean;
  stMessage : string;
begin
  inherited;
  if L_nCheckCount = 0 then
  begin
    showmessage(dmFormName.GetFormMessage('2','M00019'));
    Exit;
  end;
  stMessage := dmFormName.GetFormMessage('2','M00020');
  stMessage := stringReplace(stMessage,'$Count',inttostr(L_nCheckCount),[rfReplaceAll]);
  if (Application.MessageBox(PChar(stMessage),pchar(dmFormName.GetFormMessage('3','M00008')),MB_OKCANCEL) = IDCANCEL)  then Exit;
  With sg_CardList do
  begin
    for i := 1 to RowCount - 1 do
    begin
      GetCheckBoxState(0,i, bChkState);
      if bChkState then
      begin
        CardPermitStop(cells[6,i]);
        DeleteCardTable(cells[6,i]);
      end;
    end;
  end;
  //PageTabCreate(L_nCurrentPageGroup,L_nCurrentPageList);
  ShowCardList(L_nCurrentPageList,L_nPageListMaxCount,'','');

end;

procedure TfmCardAdmin.btn_ExcelClick(Sender: TObject);
var
  stRefFileName,stSaveFileName:String;
  stPrintRefPath : string;
  nExcelRowStart:integer;
  aFileName : string;
  stTitle : string;
begin
  btn_Excel.Enabled := False;
  aFileName:=dmFormName.GetFormMessage('1','M00044');
  SaveDialog1.FileName := aFileName;
  SaveDialog1.DefaultExt := 'CSV';
  SaveDialog1.Filter := 'CSV Files (*.CSV)|*.CSV|All Files (*.*)|*.*';
  if SaveDialog1.Execute then
  begin
    stSaveFileName := SaveDialog1.FileName;

    if SaveDialog1.FileName <> '' then
    begin
      //sg_Report.SaveToXLS(stSaveFileName,True);
      if fileexists(stSaveFileName) then
        deletefile(stSaveFileName);
      if G_nLangeType =  1 then sg_CardList.SaveToCSV(stSaveFileName,False)
      else sg_CardList.SaveToCSV(stSaveFileName,True);
      //advgridexcelio1.XLSExport(stSaveFileName);
    end;
  end;
  btn_Excel.Enabled := True;
end;

procedure TfmCardAdmin.UpdateCell;
var
  Rect: TRect;
begin
{  with sg_dongCode do
  begin
    Rect := CellRect(2, L_CurrentSaveRow);
    btn_Save.Left := Rect.Left ;
    btn_Save.Top :=  Rect.Top ;
    btn_Save.Width := Rect.Right - Rect.Left;
    btn_Save.Height := (Rect.Bottom - Rect.Top);
    btn_Save.BringToFront;   // comboBox1을 최상위로 옮기기 <> SendToBack
    btn_Save.Visible := True;
  end;  }
end;

initialization
  RegisterClass(TfmCardAdmin);
Finalization
  UnRegisterClass(TfmCardAdmin);

end.