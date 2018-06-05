﻿unit uDoorCardPermit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, W7Classes, W7Panels, AdvOfficeTabSet,
  AdvOfficeTabSetStylers, AdvSmoothPanel, Vcl.ExtCtrls, AdvSmoothLabel,
  Vcl.StdCtrls, AdvEdit, Vcl.Buttons, Vcl.Grids, AdvObj, BaseGrid, AdvGrid,
  AdvToolBtn,ADODB,ActiveX, uSubForm, CommandArray, AdvCombo, AdvGroupBox,
  Vcl.Mask, AdvSpin, AdvOfficeButtons, AdvPanel, Vcl.ComCtrls, AdvListV,
  Vcl.ImgList, Vcl.Menus, AdvMenus, Vcl.Samples.Gauges, AdvToolBar,
  AdvToolBarStylers;

type
  TfmDoorCardPermit = class(TfmASubForm)
    Image1: TImage;
    BodyPanel: TW7Panel;
    menuTab: TAdvOfficeTabSet;
    pan_DoorList: TAdvPanel;
    pan_CardListHeader: TAdvSmoothPanel;
    lb_Door: TAdvSmoothLabel;
    btn_Search: TSpeedButton;
    lb_Company: TAdvSmoothLabel;
    lb_Depart: TAdvSmoothLabel;
    ed_name: TAdvEdit;
    cmb_ListDongCode: TComboBox;
    cmb_ListAreaCode: TComboBox;
    AdvSmoothPanel1: TAdvSmoothPanel;
    btn_PackagePermitAdd: TSpeedButton;
    btn_PackagePermitDelete: TSpeedButton;
    sg_DoorList: TAdvStringGrid;
    pan_PackagePermitAdd: TAdvPanel;
    pan_AddGradeDoor: TAdvSmoothPanel;
    lv_packagePermitDoorCardList: TAdvListView;
    btn_CardPermitAddPerson: TSpeedButton;
    ImageList1: TImageList;
    pan_addSearch: TAdvSmoothPanel;
    sg_addDoorList: TAdvStringGrid;
    ed_addSearchName: TAdvEdit;
    btn_addCancel: TSpeedButton;
    pop_PermitAdd: TAdvPopupMenu;
    mn_addpermitListDelete: TMenuItem;
    pan_EmInfo: TAdvSmoothPanel;
    lb_Company4: TAdvSmoothLabel;
    cmb_addPermitDongCode: TComboBox;
    cmb_addPermitAreaCode: TComboBox;
    lb_Depart4: TAdvSmoothLabel;
    sg_addPermitCardList: TAdvStringGrid;
    btn_DoorToCardPermitAdd: TSpeedButton;
    pan_PackagePermitDelete: TAdvPanel;
    pan_DelGradeDoor: TAdvSmoothPanel;
    btn_CardPermitDeletePerson: TSpeedButton;
    lv_packagePermitDeleteDoorList: TAdvListView;
    pan_deleteSearch: TAdvSmoothPanel;
    btn_deleteCancel: TSpeedButton;
    sg_deleteDoorList: TAdvStringGrid;
    ed_deleteSearchName: TAdvEdit;
    pan_CardInfo: TAdvSmoothPanel;
    lb_Company3: TAdvSmoothLabel;
    lb_Depart3: TAdvSmoothLabel;
    btn_DoorPermitDelete: TSpeedButton;
    cmb_deletePermitDongCode: TComboBox;
    cmb_deletePermitAreaCode: TComboBox;
    sg_deletePermitCardList: TAdvStringGrid;
    pan_DoorPermit: TAdvPanel;
    pan_DoorInfo: TAdvSmoothPanel;
    pan_AccessGrade: TAdvSmoothPanel;
    lb_company2: TAdvSmoothLabel;
    lb_Depart2: TAdvSmoothLabel;
    cmb_PersonDongCode: TComboBox;
    cmb_PersonAreaCode: TComboBox;
    gb_DoorInfo: TAdvGroupBox;
    gb_DeviceInfo: TAdvGroupBox;
    lb_Company1: TAdvSmoothLabel;
    lb_Depart1: TAdvSmoothLabel;
    lb_Door1: TAdvSmoothLabel;
    lb_dong: TAdvSmoothLabel;
    lb_area: TAdvSmoothLabel;
    lb_DoorName: TAdvSmoothLabel;
    lb_node1: TAdvSmoothLabel;
    lb_NodeNo: TAdvSmoothLabel;
    lb_device1: TAdvSmoothLabel;
    lb_DeviceID: TAdvSmoothLabel;
    lb_DoorNo1: TAdvSmoothLabel;
    lb_DoorNo: TAdvSmoothLabel;
    pan_PersonDoor: TAdvPanel;
    pan_NotPermitDoor: TAdvSmoothPanel;
    pan_PermitDoor: TAdvSmoothPanel;
    AdvSmoothPanel10: TAdvSmoothPanel;
    btn_CardPermitAdd: TSpeedButton;
    btn_CardPermitDelete: TSpeedButton;
    sg_NotPermitCardList: TAdvStringGrid;
    sg_PermitCardList: TAdvStringGrid;
    Gauge_Add: TGauge;
    AdvToolBarOfficeStyler1: TAdvToolBarOfficeStyler;
    AdvOfficeTabSetOfficeStyler1: TAdvOfficeTabSetOfficeStyler;
    PopupMenu1: TPopupMenu;
    pm_update: TMenuItem;
    Gauge1: TGauge;
    procedure menuTabChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ed_AddNameKeyPress(Sender: TObject; var Key: Char);
    procedure sg_DoorListCheckBoxClick(Sender: TObject; ACol, ARow: Integer;
      State: Boolean);
    procedure FormActivate(Sender: TObject);
    procedure sg_DoorListResize(Sender: TObject);
    procedure cmb_ListDongCodeChange(Sender: TObject);
    procedure btn_SearchClick(Sender: TObject);
    procedure cmb_ListAreaCodeChange(Sender: TObject);
    procedure pan_AddGradeDoorResize(Sender: TObject);
    procedure btn_CardPermitAddPersonClick(Sender: TObject);
    procedure btn_addCancelClick(Sender: TObject);
    procedure ed_addSearchNameChange(Sender: TObject);
    procedure sg_addDoorListDblClick(Sender: TObject);
    procedure mn_addpermitListDeleteClick(Sender: TObject);
    procedure pan_EmInfoResize(Sender: TObject);
    procedure cmb_addPermitDongCodeChange(Sender: TObject);
    procedure cmb_addPermitAreaCodeChange(Sender: TObject);
    procedure sg_addPermitCardListCheckBoxClick(Sender: TObject; ACol,
      ARow: Integer; State: Boolean);
    procedure btn_DoorToCardPermitAddClick(Sender: TObject);
    procedure pan_DelGradeDoorResize(Sender: TObject);
    procedure btn_deleteCancelClick(Sender: TObject);
    procedure ed_deleteSearchNameChange(Sender: TObject);
    procedure sg_deleteDoorListDblClick(Sender: TObject);
    procedure btn_CardPermitDeletePersonClick(Sender: TObject);
    procedure cmb_deletePermitDongCodeChange(Sender: TObject);
    procedure cmb_deletePermitAreaCodeChange(Sender: TObject);
    procedure pan_CardInfoResize(Sender: TObject);
    procedure btn_DoorPermitDeleteClick(Sender: TObject);
    procedure sg_deletePermitCardListCheckBoxClick(Sender: TObject; ACol,
      ARow: Integer; State: Boolean);
    procedure btn_PackagePermitAddClick(Sender: TObject);
    procedure btn_PackagePermitDeleteClick(Sender: TObject);
    procedure sg_DoorListDblClick(Sender: TObject);
    procedure pan_AccessGradeResize(Sender: TObject);
    procedure pan_PersonDoorResize(Sender: TObject);
    procedure AdvSmoothPanel10Resize(Sender: TObject);
    procedure pan_NotPermitDoorResize(Sender: TObject);
    procedure pan_PermitDoorResize(Sender: TObject);
    procedure cmb_PersonDongCodeChange(Sender: TObject);
    procedure cmb_PersonAreaCodeChange(Sender: TObject);
    procedure sg_NotPermitCardListResize(Sender: TObject);
    procedure sg_PermitCardListResize(Sender: TObject);
    procedure sg_NotPermitCardListCheckBoxClick(Sender: TObject; ACol,
      ARow: Integer; State: Boolean);
    procedure sg_PermitCardListCheckBoxClick(Sender: TObject; ACol,
      ARow: Integer; State: Boolean);
    procedure btn_CardPermitAddClick(Sender: TObject);
    procedure btn_CardPermitDeleteClick(Sender: TObject);
    procedure sg_addPermitCardListResize(Sender: TObject);
    procedure sg_deletePermitCardListResize(Sender: TObject);
    procedure pm_updateClick(Sender: TObject);
  private
    ListDongCodeList : TStringList;
    ListAreaCodeList : TStringList;
    AddPermitDongCodeList : TStringList;
    AddPermitAreaCodeList : TStringList;
    DeletePermitDongCodeList : TStringList;
    DeletePermitAreaCodeList : TStringList;
    PersonDongCodeList : TStringList;
    PersonAreaCodeList : TStringList;

    L_nPageListMaxCount : integer;
    L_nCheckCount : integer;        //체크 된 카운트
    L_nAddCardCheckCount : integer;  //등록 카드 선택 카운트
    L_nDeleteCardCheckCount : integer;  //등록 출입문 선택 카운트
    L_nNotPermitCardCheckCount : integer;        //체크 된 카운트
    L_nPermitDoorCheckCount : integer;        //체크 된 카운트
    { Private declarations }
  private
    procedure LoadChildCode(aParentCode:string;aPosition:integer;cmbBox:TComboBox;aList:TStringList;aAll:Boolean);
    procedure ShowDoorList(aCurrentCode:string;aTopRow:integer = 0);
    procedure SearchAddList;
    procedure SearchDeleteList;

    procedure SearchAddPermitCard;
    procedure SearchDeletePermitCard;
    procedure SearchCardPermit(aNodeNo,aDeviceID,aDoorNo:string);
    procedure SearchNotCardPermit(aNodeNo,aDeviceID,aDoorNo:string);

    procedure AdvStrinGridSetAllCheck(Sender: TObject;bchkState:Boolean);
    procedure PackagePermitCardListInitialize(aDoorListView:TAdvListView);
    procedure PackagePermitDoorListAdd(aNodeNo,aDeviceID,aDoorNO,aDoorName:string;aDoorListView:TAdvListView);
  public
    { Public declarations }
    procedure FormNameSetting;
    procedure FontSetting;
    procedure Form_Close;
  end;

var
  fmDoorCardPermit: TfmDoorCardPermit;

implementation
uses
  uCommonVariable,
  uDataBase,
  uDBFormName,
  uFormUtil,
  uFunction,
  udmCardPermit,
  uFormFontUtil;

{$R *.dfm}


procedure TfmDoorCardPermit.AdvSmoothPanel10Resize(Sender: TObject);
begin
  inherited;
  btn_CardPermitAdd.Top := (AdvSmoothPanel10.Height div 2) - btn_CardPermitAdd.Height - 20;
  btn_CardPermitAdd.Left := (AdvSmoothPanel10.Width div 2) - (btn_CardPermitAdd.Width div 2);
  btn_CardPermitDelete.Top := (AdvSmoothPanel10.Height div 2) + 20;
  btn_CardPermitDelete.Left := (AdvSmoothPanel10.Width div 2) - (btn_CardPermitDelete.Width div 2);

  Gauge1.Top := btn_CardPermitDelete.Top + btn_CardPermitDelete.Height + 20;
  Gauge1.Left := (AdvSmoothPanel10.Width div 2) - (Gauge1.Width div 2);

end;

procedure TfmDoorCardPermit.pan_AddGradeDoorResize(Sender: TObject);
begin
  inherited;
  lv_packagePermitDoorCardList.Width := pan_AddGradeDoor.Width - 200;

  pan_addSearch.Left := btn_CardPermitAddPerson.Left - pan_addSearch.Width;
  //pan_addSearch.Left := lv_packagePermitAddCardList.Width - pan_addSearch.Width;
end;

procedure TfmDoorCardPermit.pan_EmInfoResize(Sender: TObject);
begin
  inherited;
  sg_addPermitCardList.Height := pan_EmInfo.Height - sg_addPermitCardList.Top;
  sg_addPermitCardList.Width := pan_EmInfo.Width - 20;
end;

procedure TfmDoorCardPermit.pan_DelGradeDoorResize(Sender: TObject);
begin
  inherited;
  lv_packagePermitDeleteDoorList.Width := pan_DelGradeDoor.Width - 200;

  pan_deleteSearch.Left := btn_CardPermitDeletePerson.Left - pan_deleteSearch.Width;

end;

procedure TfmDoorCardPermit.pan_CardInfoResize(Sender: TObject);
begin
  inherited;
  sg_deletePermitCardList.Height := pan_CardInfo.Height - sg_deletePermitCardList.Top;
  sg_deletePermitCardList.Width := pan_CardInfo.Width - 20;

end;

procedure TfmDoorCardPermit.pan_AccessGradeResize(Sender: TObject);
begin
  inherited;
  pan_PersonDoor.Height := pan_AccessGrade.Height - pan_PersonDoor.Top - 20;
  pan_PersonDoor.Width := pan_AccessGrade.Width - 40;
end;

procedure TfmDoorCardPermit.AdvStrinGridSetAllCheck(Sender: TObject;
  bchkState: Boolean);
var
  i : integer;
begin
    for i:= 1 to (Sender as TAdvStringGrid).RowCount - 1  do
    begin
      (Sender as TAdvStringGrid).SetCheckBoxState(0,i,bchkState);
    end;
end;

procedure TfmDoorCardPermit.btn_addCancelClick(Sender: TObject);
begin
  inherited;
  pan_addSearch.Visible := False;
  ed_addSearchName.Text := '';
  SearchAddList;
end;

procedure TfmDoorCardPermit.btn_CardPermitAddClick(Sender: TObject);
var
  i : integer;
  stCardNo : string;
  bChkState : Boolean;
  stNodeNo : string;
  stDeviceID : string;
  stDoorNo : string;
begin
  inherited;
  stNodeNo := lb_NodeNo.Caption.Text;
  stDeviceID := lb_DeviceID.Caption.Text;
  stDoorNo := lb_DoorNo.Caption.Text;

  if L_nNotPermitCardCheckCount < 1 then
  begin
    showmessage(dmFormName.GetFormMessage('2','M00030'));
    Exit;
  end;

  with sg_NotPermitCardList do
  begin
    Gauge1.Visible := True;
    Gauge1.Progress := 0;
    Gauge1.MaxValue := RowCount;
    for i := 1 to RowCount - 1 do
    begin
      Gauge1.Progress := i;
      GetCheckBoxState(0,i, bchkState);
      if bchkState then
      begin
        stCardNo := Cells[2,i];
        dmCardPermit.CardPermitRegist(stCardNo,stNodeNo,stDeviceID,stDoorNo,'L');
        Application.ProcessMessages;
      end;
    end;
    Gauge1.Visible := False;
  end;
  SearchNotCardPermit(stNodeNo,stDeviceID,stDoorNo);
  SearchCardPermit(stNodeNo,stDeviceID,stDoorNo);
end;

procedure TfmDoorCardPermit.btn_CardPermitAddPersonClick(Sender: TObject);
begin
  inherited;
  ed_addSearchName.Text := '';
  pan_addSearch.Visible := True;
  SearchAddList;
end;

procedure TfmDoorCardPermit.btn_CardPermitDeleteClick(Sender: TObject);
var
  i : integer;
  stCardNo : string;
  bChkState : Boolean;
  stNodeNo : string;
  stDeviceID : string;
  stDoorNo : string;
begin
  inherited;
  stNodeNo := lb_NodeNo.Caption.Text;
  stDeviceID := lb_DeviceID.Caption.Text;
  stDoorNo := lb_DoorNo.Caption.Text;

  if L_nPermitDoorCheckCount < 1 then
  begin
    showmessage(dmFormName.GetFormMessage('2','M00031'));
    Exit;
  end;

  with sg_PermitCardList do
  begin
    Gauge1.Visible := True;
    Gauge1.Progress := 0;
    Gauge1.MaxValue := RowCount;
    for i := 1 to RowCount - 1 do
    begin
      Gauge1.Progress :=i;
      GetCheckBoxState(0,i, bchkState);
      if bchkState then
      begin
        stCardNo := Cells[3,i];
        dmCardPermit.CardPermitRegist(stCardNo,stNodeNo,stDeviceID,stDoorNo,'N');
        Application.ProcessMessages;
      end;
    end;
    Gauge1.Visible := False;
  end;
  SearchNotCardPermit(stNodeNo,stDeviceID,stDoorNo);
  SearchCardPermit(stNodeNo,stDeviceID,stDoorNo);
end;

procedure TfmDoorCardPermit.btn_CardPermitDeletePersonClick(Sender: TObject);
begin
  inherited;
  ed_DeleteSearchName.Text := '';
  pan_DeleteSearch.Visible := True;
  SearchDeleteList;

end;

procedure TfmDoorCardPermit.btn_deleteCancelClick(Sender: TObject);
begin
  inherited;
  pan_deleteSearch.Visible := False;
end;

procedure TfmDoorCardPermit.btn_DoorToCardPermitAddClick(Sender: TObject);
var
  i,j : integer;
  bChkState : Boolean;
  stCardNo : string;
  stNodeNo : string;
  stDeviceID : string;
  stDoorNo : string;
begin
  inherited;
  if lv_packagePermitDoorCardList.Items.Count < 1 then
  begin
    showmessage(dmFormName.GetFormMessage('2','M00032'));
    Exit;
  end;
  if L_nAddCardCheckCount < 1 then
  begin
    showmessage(dmFormName.GetFormMessage('2','M00033'));
    Exit;
  end;
  btn_DoorToCardPermitAdd.Enabled := False;
  Gauge_Add.Visible := True;
  Gauge_Add.MaxValue := (sg_addPermitCardList.RowCount - 1) * (lv_packagePermitDoorCardList.Items.Count);
  Gauge_Add.Progress := 0;
  for i := 0 to lv_packagePermitDoorCardList.Items.Count - 1 do
  begin
    stNodeNo := lv_packagePermitDoorCardList.Items[i].SubItems.Strings[0];
    stDeviceID := lv_packagePermitDoorCardList.Items[i].SubItems.Strings[1];
    stDoorNo := lv_packagePermitDoorCardList.Items[i].SubItems.Strings[2];
    With sg_addPermitCardList do
    begin
      for j := 1 to RowCount - 1 do
      begin
        Gauge_Add.Progress := Gauge_Add.Progress + 1;
        GetCheckBoxState(0,j, bChkState);
        if bChkState then
        begin
          stCardNo := cells[5,j];
          dmCardPermit.CardPermitRegist(stCardNo,stNodeNo,stDeviceID,stDoorNo,'L');
        end;
        Application.ProcessMessages;
      end;
    end;
  end;
  Gauge_Add.Visible := False;
  btn_DoorToCardPermitAdd.Enabled := True;
  showmessage(dmFormName.GetFormMessage('2','M00034'));
end;

procedure TfmDoorCardPermit.btn_DoorPermitDeleteClick(Sender: TObject);
var
  i,j : integer;
  bChkState : Boolean;
  stCardNo : string;
  stNodeNo : string;
  stDeviceID : string;
  stDoorNo : string;
begin
  inherited;
  if lv_packagePermitDeleteDoorList.Items.Count < 1 then
  begin
    showmessage(dmFormName.GetFormMessage('2','M00035'));
    Exit;
  end;
  if L_nDeleteCardCheckCount < 1 then
  begin
    showmessage(dmFormName.GetFormMessage('2','M00036'));
    Exit;
  end;

  for i := 0 to lv_packagePermitDeleteDoorList.Items.Count - 1 do
  begin
    stNodeNo := lv_packagePermitDeleteDoorList.Items[i].SubItems.Strings[0];
    stDeviceID := lv_packagePermitDeleteDoorList.Items[i].SubItems.Strings[1];
    stDoorNo := lv_packagePermitDeleteDoorList.Items[i].SubItems.Strings[2];
    With sg_deletePermitCardList do
    begin
      for j := 1 to RowCount - 1 do
      begin
        GetCheckBoxState(0,j, bChkState);
        if bChkState then
        begin
          stCardNo := cells[5,j];
          dmCardPermit.CardPermitRegist(stCardNo,stNodeNo,stDeviceID,stDoorNo,'N');
        end;
        Application.ProcessMessages;
      end;
    end;
  end;
  showmessage(dmFormName.GetFormMessage('2','M00037'));
end;

procedure TfmDoorCardPermit.btn_SearchClick(Sender: TObject);
begin
  inherited;
  ShowDoorList('');

end;

procedure TfmDoorCardPermit.cmb_addPermitAreaCodeChange(Sender: TObject);
begin
  inherited;
  SearchAddPermitCard;
end;

procedure TfmDoorCardPermit.cmb_addPermitDongCodeChange(Sender: TObject);
var
  stParentCode : string;
begin
  inherited;
  stParentCode := AddPermitDongCodeList.Strings[cmb_addPermitDongCode.ItemIndex];
  LoadChildCode(stParentCode,2,cmb_addPermitAreaCode,AddPermitAreaCodeList,True);
  SearchAddPermitCard;
end;

procedure TfmDoorCardPermit.cmb_deletePermitAreaCodeChange(Sender: TObject);
begin
  inherited;
  SearchDeletePermitCard;

end;

procedure TfmDoorCardPermit.cmb_deletePermitDongCodeChange(Sender: TObject);
var
  stParentCode : string;
begin
  inherited;
  stParentCode := DeletePermitDongCodeList.Strings[cmb_DeletePermitDongCode.ItemIndex];
  LoadChildCode(stParentCode,2,cmb_DeletePermitAreaCode,DeletePermitAreaCodeList,True);
  SearchDeletePermitCard;

end;

procedure TfmDoorCardPermit.cmb_ListAreaCodeChange(Sender: TObject);
begin
  inherited;
  btn_SearchClick(self);

end;

procedure TfmDoorCardPermit.cmb_ListDongCodeChange(Sender: TObject);
var
  stParentCode : string;
begin
  inherited;
  stParentCode := ListDongCodeList.Strings[cmb_ListDongCode.ItemIndex];
  LoadChildCode(stParentCode,2,cmb_ListAreaCode,ListAreaCodeList,True);
  btn_SearchClick(self);

end;

procedure TfmDoorCardPermit.cmb_PersonAreaCodeChange(Sender: TObject);
var
  stNodeNo : string;
  stDeviceID : string;
  stDoorNo : string;
begin
  inherited;
  stNodeNo := lb_NodeNo.Caption.Text;
  stDeviceID := lb_DeviceID.Caption.Text;
  stDoorNo := lb_DoorNo.Caption.Text;

  SearchNotCardPermit(stNodeNo,stDeviceID,stDoorNo);
  SearchCardPermit(stNodeNo,stDeviceID,stDoorNo);

end;

procedure TfmDoorCardPermit.cmb_PersonDongCodeChange(Sender: TObject);
var
  stParentCode : string;
  stNodeNo : string;
  stDeviceID : string;
  stDoorNo : string;
begin
  inherited;
  stParentCode := PersonDongCodeList.Strings[cmb_PersonDongCode.ItemIndex];
  LoadChildCode(stParentCode,2,cmb_PersonAreaCode,PersonAreaCodeList,True);

  stNodeNo := lb_NodeNo.Caption.Text;
  stDeviceID := lb_DeviceID.Caption.Text;
  stDoorNo := lb_DoorNo.Caption.Text;

  SearchNotCardPermit(stNodeNo,stDeviceID,stDoorNo);
  SearchCardPermit(stNodeNo,stDeviceID,stDoorNo);

end;

procedure TfmDoorCardPermit.ed_AddNameKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  if Key = #13 then
  begin
    Perform(WM_NEXTDLGCTL,0,0);
  end;
end;

procedure TfmDoorCardPermit.ed_addSearchNameChange(Sender: TObject);
begin
  inherited;
  SearchAddList;
end;

procedure TfmDoorCardPermit.ed_deleteSearchNameChange(Sender: TObject);
begin
  inherited;
  SearchDeleteList;

end;

procedure TfmDoorCardPermit.FontSetting;
begin
  dmFormFontUtil.TravelFormFontSetting(self,G_stFontName,inttostr(G_nFontSize));
  dmFormFontUtil.TravelAdvOfficeTabSetOfficeStylerFontSetting(AdvOfficeTabSetOfficeStyler1, G_stFontName,inttostr(G_nFontSize));
  dmFormFontUtil.FormAdvOfficeTabSetOfficeStylerSetting(AdvOfficeTabSetOfficeStyler1,G_stFormStyle);
  dmFormFontUtil.FormAdvToolBarOfficeStylerSetting(AdvToolBarOfficeStyler1,G_stFormStyle);
  dmFormFontUtil.FormStyleSetting(self,AdvToolBarOfficeStyler1);

end;

procedure TfmDoorCardPermit.FormActivate(Sender: TObject);
begin
  inherited;
  WindowState := wsMaximized;
end;

procedure TfmDoorCardPermit.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  self.FindSubForm('Main').FindCommand('FORMENABLE').Params.Values['NAME'] := inttostr(FORMDOORCARDPERMIT);
  self.FindSubForm('Main').FindCommand('FORMENABLE').Params.Values['VALUE'] := 'FALSE';
  self.FindSubForm('Main').FindCommand('FORMENABLE').Execute;

  ListDongCodeList.Free;
  ListAreaCodeList.Free;
  AddPermitDongCodeList.Free;
  AddPermitAreaCodeList.Free;
  DeletePermitDongCodeList.Free;
  DeletePermitAreaCodeList.Free;
  PersonDongCodeList.Free;
  PersonAreaCodeList.Free;

  Action := caFree;
end;

procedure TfmDoorCardPermit.FormCreate(Sender: TObject);
begin

  ListDongCodeList := TStringList.Create;
  ListAreaCodeList := TStringList.Create;
  AddPermitDongCodeList := TStringList.Create;
  AddPermitAreaCodeList := TStringList.Create;
  DeletePermitDongCodeList := TStringList.Create;
  DeletePermitAreaCodeList := TStringList.Create;
  PersonDongCodeList := TStringList.Create;
  PersonAreaCodeList := TStringList.Create;

  menuTab.ActiveTabIndex := 1;
  menuTabChange(self);

  LoadChildCode(FillZeroNumber(0,G_nBuildingCodeLength),1,cmb_ListDongCode,ListDongCodeList,True);
  LoadChildCode('',2,cmb_ListAreaCode,ListAreaCodeList,True);

  pan_EmInfo.Align := alClient;
  pan_CardInfo.Align := alClient;
  pan_AccessGrade.Align := alClient;
  FontSetting;
end;


procedure TfmDoorCardPermit.FormNameSetting;
begin
  Caption := dmFormName.GetFormMessage('1','M00019');
  menuTab.AdvOfficeTabs[0].Caption := dmFormName.GetFormMessage('1','M00035');
  menuTab.AdvOfficeTabs[1].Caption := dmFormName.GetFormMessage('1','M00019');
  menuTab.AdvOfficeTabs[2].Caption := dmFormName.GetFormMessage('1','M00051');
  menuTab.AdvOfficeTabs[3].Caption := dmFormName.GetFormMessage('1','M00052');
  pan_CardListHeader.Caption.Text := dmFormName.GetFormMessage('1','M00019');
  pm_update.Caption := dmFormName.GetFormMessage('1','M00019');
  lb_Company.Caption.Text := dmFormName.GetFormMessage('4','M00004');
  lb_Depart.Caption.Text := dmFormName.GetFormMessage('4','M00005');
  lb_Door.Caption.Text :=  dmFormName.GetFormMessage('4','M00002');
  btn_Search.Caption := dmFormName.GetFormMessage('4','M00007');
  with sg_doorList do
  begin
    cells[1,0] := dmFormName.GetFormMessage('4','M00004');
    cells[2,0] := dmFormName.GetFormMessage('4','M00005');
    cells[3,0] := dmFormName.GetFormMessage('4','M00002');
    cells[4,0] := dmFormName.GetFormMessage('4','M00036');
    cells[5,0] := dmFormName.GetFormMessage('4','M00037');
    cells[5,0] := dmFormName.GetFormMessage('4','M00038');
    hint := dmFormName.GetFormMessage('2','M00012');
  end;
  pan_DoorInfo.Caption.Text := dmFormName.GetFormMessage('4','M00044');
  gb_DoorInfo.Caption := dmFormName.GetFormMessage('4','M00044');
  gb_DeviceInfo.Caption := dmFormName.GetFormMessage('4','M00045');
  lb_Company1.Caption.Text := dmFormName.GetFormMessage('4','M00004');
  lb_Depart1.Caption.Text := dmFormName.GetFormMessage('4','M00005');
  lb_Door1.Caption.Text := dmFormName.GetFormMessage('4','M00002');
  lb_node1.Caption.Text := dmFormName.GetFormMessage('4','M00036');
  lb_device1.Caption.Text := dmFormName.GetFormMessage('4','M00037');
  lb_DoorNo1.Caption.Text := dmFormName.GetFormMessage('4','M00038');
  pan_AccessGrade.Caption.Text := dmFormName.GetFormMessage('4','M00046');
  lb_company2.Caption.Text := dmFormName.GetFormMessage('4','M00004');
  lb_Depart2.Caption.Text := dmFormName.GetFormMessage('4','M00005');
  pan_NotPermitDoor.Caption.Text := dmFormName.GetFormMessage('4','M00047');
  pan_PermitDoor.Caption.Text := dmFormName.GetFormMessage('4','M00048');
  with sg_NotPermitCardList do
  begin
    cells[1,0] := dmFormName.GetFormMessage('4','M00006');
    cells[2,0] := dmFormName.GetFormMessage('4','M00012');
  end;
  with sg_PermitCardList do
  begin
    cells[1,0] := dmFormName.GetFormMessage('4','M00006');
    cells[2,0] := dmFormName.GetFormMessage('4','M00022');
    cells[3,0] := dmFormName.GetFormMessage('4','M00012');
  end;
  pan_DelGradeDoor.Caption.Text := dmFormName.GetFormMessage('4','M00049');
  pan_deleteSearch.Caption.Text := dmFormName.GetFormMessage('4','M00050');
  btn_deleteCancel.Caption := dmFormName.GetFormMessage('4','M00051');
  with sg_deleteDoorList do
  begin
    cells[0,0] := dmFormName.GetFormMessage('4','M00004');
    cells[1,0] := dmFormName.GetFormMessage('4','M00005');
    cells[2,0] := dmFormName.GetFormMessage('4','M00002');
    cells[3,0] := dmFormName.GetFormMessage('4','M00036');
    cells[4,0] := dmFormName.GetFormMessage('4','M00037');
    cells[5,0] := dmFormName.GetFormMessage('4','M00038');
    hint := dmFormName.GetFormMessage('2','M00029');
  end;
  btn_CardPermitDeletePerson.Caption := dmFormName.GetFormMessage('4','M00052');
  pan_CardInfo.Caption.Text := dmFormName.GetFormMessage('4','M00020');
  lb_Company3.Caption.Text := dmFormName.GetFormMessage('4','M00004');
  lb_Depart3.Caption.Text := dmFormName.GetFormMessage('4','M00005');
  btn_DoorPermitDelete.Caption := dmFormName.GetFormMessage('4','M00053');
  with sg_deletePermitCardList do
  begin
    cells[1,0] := dmFormName.GetFormMessage('4','M00004');
    cells[2,0] := dmFormName.GetFormMessage('4','M00005');
    cells[3,0] := dmFormName.GetFormMessage('4','M00018');
    cells[4,0] := dmFormName.GetFormMessage('4','M00006');
    cells[5,0] := dmFormName.GetFormMessage('4','M00012');
  end;
  pan_AddGradeDoor.Caption.Text := dmFormName.GetFormMessage('4','M00054');
  pan_addSearch.Caption.Text := dmFormName.GetFormMessage('4','M00050');
  btn_addCancel.Caption := dmFormName.GetFormMessage('4','M00051');
  with sg_addDoorList do
  begin
    cells[0,0] := dmFormName.GetFormMessage('4','M00004');
    cells[1,0] := dmFormName.GetFormMessage('4','M00005');
    cells[2,0] := dmFormName.GetFormMessage('4','M00002');
    cells[3,0] := dmFormName.GetFormMessage('4','M00036');
    cells[4,0] := dmFormName.GetFormMessage('4','M00037');
    cells[5,0] := dmFormName.GetFormMessage('4','M00038');
    hint := dmFormName.GetFormMessage('2','M00029');
  end;
  pan_EmInfo.Caption.Text := dmFormName.GetFormMessage('4','M00055');
  lb_company4.Caption.Text := dmFormName.GetFormMessage('4','M00004');
  lb_Depart4.Caption.Text := dmFormName.GetFormMessage('4','M00005');
  btn_DoorToCardPermitAdd.Caption := dmFormName.GetFormMessage('4','M00056');
  btn_CardPermitAddPerson.Caption := dmFormName.GetFormMessage('4','M00052');
  with sg_addPermitCardList do
  begin
    cells[1,0] := dmFormName.GetFormMessage('4','M00004');
    cells[2,0] := dmFormName.GetFormMessage('4','M00005');
    cells[3,0] := dmFormName.GetFormMessage('4','M00018');
    cells[4,0] := dmFormName.GetFormMessage('4','M00006');
    cells[5,0] := dmFormName.GetFormMessage('4','M00012');
  end;
  btn_PackagePermitAdd.Caption := dmFormName.GetFormMessage('1','M00051');
  btn_PackagePermitDelete.Caption := dmFormName.GetFormMessage('1','M00052');
  mn_addpermitListDelete.Caption := dmFormName.GetFormMessage('4','M00065');
  btn_CardPermitAdd.Hint := dmFormName.GetFormMessage('4','M00101');
  btn_CardPermitDelete.Hint := dmFormName.GetFormMessage('4','M00102');
end;

procedure TfmDoorCardPermit.FormShow(Sender: TObject);
begin
  self.FindSubForm('Main').FindCommand('FORMENABLE').Params.Values['NAME'] := inttostr(FORMDOORCARDPERMIT);
  self.FindSubForm('Main').FindCommand('FORMENABLE').Params.Values['VALUE'] := 'TRUE';
  self.FindSubForm('Main').FindCommand('FORMENABLE').Execute;
  FormNameSetting;
  btn_SearchClick(self);
end;

procedure TfmDoorCardPermit.Form_Close;
begin
  Close;
end;


procedure TfmDoorCardPermit.LoadChildCode(aParentCode: string; aPosition: integer;
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


procedure TfmDoorCardPermit.menuTabChange(Sender: TObject);
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
    pan_PackagePermitAdd.Visible := False;
    pan_PackagePermitDelete.Visible := False;
    pan_DoorPermit.Visible := False;
    pan_DoorList.Visible := True;
    pan_DoorList.Align := alClient;
  end else if menuTab.ActiveTabIndex = 2 then
  begin
    if L_nCheckCount < 1 then
    begin
      showmessage(dmFormName.GetFormMessage('2','M00016'));
      menuTab.ActiveTabIndex := 1;
      menuTabChange(self);
      Exit;
    end;
    menuTab.AdvOfficeTabs.Items[0].Caption := dmFormName.GetFormMessage('1','M00040');
    pan_DoorList.Visible := False;
    pan_PackagePermitDelete.Visible := False;
    pan_DoorPermit.Visible := False;
    pan_PackagePermitAdd.Visible := True;
    pan_PackagePermitAdd.Align := alClient;
    PackagePermitCardListInitialize(lv_packagePermitDoorCardList);
    LoadChildCode(FillZeroNumber(0,G_nBuildingCodeLength),1,cmb_addPermitDongCode,AddPermitDongCodeList,True);
    LoadChildCode('',2,cmb_addPermitAreaCode,AddPermitAreaCodeList,True);
    SearchAddPermitCard;
  end else if menuTab.ActiveTabIndex = 3 then
  begin
    if L_nCheckCount < 1 then
    begin
      showmessage(dmFormName.GetFormMessage('2','M00016'));
      menuTab.ActiveTabIndex := 1;
      menuTabChange(self);
      Exit;
    end;
    menuTab.AdvOfficeTabs.Items[0].Caption := dmFormName.GetFormMessage('1','M00040');
    pan_PackagePermitAdd.Visible := False;
    pan_DoorList.Visible := False;
    pan_DoorPermit.Visible := False;
    pan_PackagePermitDelete.Visible := True;
    pan_PackagePermitDelete.Align := alClient;
    PackagePermitCardListInitialize(lv_packagePermitDeleteDoorList);
    LoadChildCode(FillZeroNumber(0,G_nBuildingCodeLength),1,cmb_deletePermitDongCode,DeletePermitDongCodeList,True);
    LoadChildCode('',2,cmb_deletePermitAreaCode,DeletePermitAreaCodeList,True);
    SearchDeletePermitCard;
  end;
end;

procedure TfmDoorCardPermit.mn_addpermitListDeleteClick(Sender: TObject);
var
  stCardNo : string;
  i : integer;
begin
  Try
    if lv_packagePermitDoorCardList.SelCount < 1 then Exit;
    for i := lv_packagePermitDoorCardList.Items.Count - 1 downto 0 do
    begin
      if lv_packagePermitDoorCardList.Items[i].Selected then
      begin
        stCardNo:= lv_packagePermitDoorCardList.Items[i].SubItems.Strings[0];
        lv_packagePermitDoorCardList.Items[i].Delete;
      end;
      Application.ProcessMessages;
    end;
  Except
    Exit;
  End;

end;

procedure TfmDoorCardPermit.PackagePermitDoorListAdd(aNodeNo,aDeviceID,aDoorNO,aDoorName:string;
  aDoorListView:TAdvListView);
begin
  aDoorListView.Items.Add.Caption := aDoorName ;
  aDoorListView.Items[aDoorListView.Items.Count - 1].SubItems.Add(aNodeNo);
  aDoorListView.Items[aDoorListView.Items.Count - 1].SubItems.Add(aDeviceID);
  aDoorListView.Items[aDoorListView.Items.Count - 1].SubItems.Add(aDoorNO);
  aDoorListView.Items[aDoorListView.Items.Count - 1].ImageIndex := 0;
  aDoorListView.ViewStyle := vsList;
  aDoorListView.Refresh;
  aDoorListView.ViewStyle := vsIcon ;
end;

procedure TfmDoorCardPermit.PackagePermitCardListInitialize(
  aDoorListView: TAdvListView);
var
  i : integer;
  bChkState : Boolean;
  stNodeNo : string;
  stDeviceID : string;
  stDoorNo : string;
  stName : string;
begin

  aDoorListView.Clear;
  with sg_DoorList do
  begin
    for i := 1 to RowCount - 1 do
    begin
      GetCheckBoxState(0,i, bChkState);
      if bChkState then
      begin
        stName := Cells[3,i];
        stNodeNo := Cells[4,i];
        stDeviceID := Cells[5,i];
        stDoorNo := Cells[6,i];
        PackagePermitDoorListAdd(stNodeNo,stDeviceID,stDoorNo,stName,aDoorListView);
      end;
      Application.ProcessMessages;
    end;
  end;
end;

procedure TfmDoorCardPermit.pan_NotPermitDoorResize(Sender: TObject);
begin
  inherited;
  sg_NotPermitCardList.Width := pan_NotPermitDoor.Width - 20;
  sg_NotPermitCardList.Height := pan_NotPermitDoor.Height - sg_NotPermitCardList.Top - 20;
end;

procedure TfmDoorCardPermit.pan_PermitDoorResize(Sender: TObject);
begin
  inherited;
  sg_PermitCardList.Width := pan_PermitDoor.Width - 20;
  sg_PermitCardList.Height := pan_PermitDoor.Height - sg_PermitCardList.Top - 20;

end;

procedure TfmDoorCardPermit.pan_PersonDoorResize(Sender: TObject);
begin
  inherited;
  pan_NotPermitDoor.Width := (pan_PersonDoor.Width div 2) - 75;
  pan_PermitDoor.Width := (pan_PersonDoor.Width div 2) - 75;

end;

procedure TfmDoorCardPermit.pm_updateClick(Sender: TObject);
begin
  inherited;
  sg_DoorListDblClick(sg_DoorList);
end;

procedure TfmDoorCardPermit.SearchAddList;
var
  stSql : string;
  TempAdoQuery : TADOQuery;
  nRow : integer;
begin
  GridInit(sg_addDoorList,3,2,False);
  if Trim( ed_addSearchName.Text ) = '' then Exit;

  stSql := 'SELECT a.*,b.BC_NAME as DONGNAME,c.BC_NAME as AREANAME FROM ';
  stSql := stSql + ' (  ';
  stSql := stSql + ' (  ';
  stSql := stSql + ' TB_DOOR a ';
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
  if ed_addSearchName.Text <> '' then
  begin
    stSql := stSql + ' AND a.DO_NAME Like ''%' + ed_addSearchName.Text + '%'' ';
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
      with sg_addDoorList do
      begin
        nRow := 1;
        RowCount := RecordCount + 1;
        while Not Eof do
        begin
          cells[0,nRow] := FindField('DONGNAME').AsString;
          cells[1,nRow] := FindField('AREANAME').AsString;
          cells[2,nRow] := FindField('DO_NAME').AsString;
          cells[3,nRow] := FindField('ND_NODENO').AsString;
          cells[4,nRow] := FindField('DE_DEVICEID').AsString;
          cells[5,nRow] := FindField('DO_DOORNO').AsString;

          nRow := nRow + 1;
          Next;
        end;
      end;

    end;
  Finally
    TempAdoQuery.Free;
    CoUninitialize;
  End;

end;

procedure TfmDoorCardPermit.SearchAddPermitCard;
var
  stSql : string;
  TempAdoQuery : TADOQuery;
  nRow : integer;
begin
  GridInit(sg_addPermitCardList,6,2,true);
  L_nAddCardCheckCount := 0;

  stSql := 'SELECT a.*,b.BC_NAME as DONGNAME,c.BC_NAME as AREANAME FROM ';
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
  if cmb_addPermitDongCode.ItemIndex > 0 then
  begin
    stSql := stSql + ' AND a.BC_PARENTCODE = ''' + AddPermitDongCodeList.Strings[cmb_addPermitDongCode.ItemIndex] + ''' ';
  end;
  if cmb_addPermitAreaCode.ItemIndex > 0 then
  begin
    stSql := stSql + ' AND a.BC_CHILDCODE = ''' + AddPermitAreaCodeList.Strings[cmb_addPermitAreaCode.ItemIndex] + ''' ';
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
      with sg_addPermitCardList do
      begin
        nRow := 1;
        RowCount := RecordCount + 1;
        while Not Eof do
        begin
          AddCheckBox(0,nRow,False,False);
          cells[1,nRow] := FindField('DONGNAME').AsString;
          cells[2,nRow] := FindField('AREANAME').AsString;
          cells[3,nRow] := FindField('CA_POSITION').AsString;
          cells[4,nRow] := FindField('CA_NAME').AsString;
          cells[5,nRow] := FindField('CA_CARDNO').AsString;

          nRow := nRow + 1;
          Next;
        end;
      end;

    end;
  Finally
    TempAdoQuery.Free;
    CoUninitialize;
  End;


end;

procedure TfmDoorCardPermit.SearchDeleteList;
var
  stSql : string;
  TempAdoQuery : TADOQuery;
  nRow : integer;
begin
  GridInit(sg_deleteDoorList,3,2,False);
  if Trim( ed_deleteSearchName.Text ) = '' then Exit;

  stSql := 'SELECT a.*,b.BC_NAME as DONGNAME,c.BC_NAME as AREANAME FROM ';
  stSql := stSql + ' (  ';
  stSql := stSql + ' (  ';
  stSql := stSql + ' TB_DOOR a ';
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
  if ed_deleteSearchName.Text <> '' then
  begin
    stSql := stSql + ' AND a.DO_NAME Like ''%' + ed_deleteSearchName.Text + '%'' ';
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
      with sg_deleteDoorList do
      begin
        nRow := 1;
        RowCount := RecordCount + 1;
        while Not Eof do
        begin
          cells[0,nRow] := FindField('DONGNAME').AsString;
          cells[1,nRow] := FindField('AREANAME').AsString;
          cells[2,nRow] := FindField('DO_NAME').AsString;
          cells[3,nRow] := FindField('ND_NODENO').AsString;
          cells[4,nRow] := FindField('DE_DEVICEID').AsString;
          cells[5,nRow] := FindField('DO_DOORNO').AsString;

          nRow := nRow + 1;
          Next;
        end;
      end;

    end;
  Finally
    TempAdoQuery.Free;
    CoUninitialize;
  End;
end;

procedure TfmDoorCardPermit.SearchDeletePermitCard;
var
  stSql : string;
  TempAdoQuery : TADOQuery;
  nRow : integer;
begin
  GridInit(sg_deletePermitCardList,6,2,true);
  L_nDeleteCardCheckCount := 0;

  stSql := 'SELECT a.*,b.BC_NAME as DONGNAME,c.BC_NAME as AREANAME FROM ';
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
  if cmb_DeletePermitDongCode.ItemIndex > 0 then
  begin
    stSql := stSql + ' AND a.BC_PARENTCODE = ''' + DeletePermitDongCodeList.Strings[cmb_DeletePermitDongCode.ItemIndex] + ''' ';
  end;
  if cmb_DeletePermitAreaCode.ItemIndex > 0 then
  begin
    stSql := stSql + ' AND a.BC_CHILDCODE = ''' + DeletePermitAreaCodeList.Strings[cmb_DeletePermitAreaCode.ItemIndex] + ''' ';
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
      with sg_deletePermitCardList do
      begin
        nRow := 1;
        RowCount := RecordCount + 1;
        while Not Eof do
        begin
          AddCheckBox(0,nRow,False,False);
          cells[1,nRow] := FindField('DONGNAME').AsString;
          cells[2,nRow] := FindField('AREANAME').AsString;
          cells[3,nRow] := FindField('CA_POSITION').AsString;
          cells[4,nRow] := FindField('CA_NAME').AsString;
          cells[5,nRow] := FindField('CA_CARDNO').AsString;
          nRow := nRow + 1;
          Next;
        end;
      end;

    end;
  Finally
    TempAdoQuery.Free;
    CoUninitialize;
  End;

end;

procedure TfmDoorCardPermit.SearchCardPermit(aNodeNo,aDeviceID,aDoorNo: string);
var
  stSql : string;
  TempAdoQuery : TADOQuery;
  nRow : integer;
begin
  GridInit(sg_PermitCardList,3,2,true);
  L_nPermitDoorCheckCount := 0;

  stSql := ' Select a.*,b.DE_RCVACK from TB_CARD a ';
  stSql := stSql + ' Inner Join (select * from TB_DEVICECARDNO ';
  stSql := stSql + ' Where DE_PERMIT = ''L'' ';
  stSql := stSql + ' AND ND_NODENO = ' + aNodeNo +' ';
  stSql := stSql + ' AND DE_DEVICEID  = ''' + aDeviceID + ''' ';
  stSql := stSql + ' AND DE_DOOR' + aDoorNo + '  = ''Y'') b ';
  stSql := stSql + ' ON(a.GROUP_CODE = b.GROUP_CODE ';
  stSql := stSql + ' AND a.CA_CARDNO = b.CA_CARDNO ) ';
  stSql := stSql + ' Where a.GROUP_CODE = ''' + G_stGroupCode + ''' ';
  if cmb_PersonDongCode.ItemIndex > 0 then
  begin
    stSql := stSql + ' AND a.BC_PARENTCODE = ''' + PersonDongCodeList.Strings[cmb_PersonDongCode.ItemIndex] + ''' ';
  end;
  if cmb_PersonAreaCode.ItemIndex > 0 then
  begin
    stSql := stSql + ' AND a.BC_CHILDCODE = ''' + PersonAreaCodeList.Strings[cmb_PersonAreaCode.ItemIndex] + ''' ';
  end;

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
      with sg_PermitCardList do
      begin
        nRow := 1;
        RowCount := RecordCount + 1;
        while Not Eof do
        begin
          AddCheckBox(0,nRow,False,False);
          cells[1,nRow] := FindField('CA_NAME').AsString;
          cells[2,nRow] := FindField('DE_RCVACK').AsString;
          cells[3,nRow] := FindField('CA_CARDNO').AsString;

          nRow := nRow + 1;
          Next;
        end;
      end;
    end;
  Finally
    TempAdoQuery.Free;
    CoUninitialize;
  End;
end;

procedure TfmDoorCardPermit.SearchNotCardPermit(aNodeNo,aDeviceID,aDoorNo:string);
var
  stSql : string;
  TempAdoQuery : TADOQuery;
  nRow : integer;
begin
  GridInit(sg_NotPermitCardList,2,2,true);
  L_nNotPermitCardCheckCount := 0;

  stSql := ' Select * from TB_CARD ';
  stSql := stSql + ' Where GROUP_CODE = ''' + G_stGroupCode + ''' ';
  if cmb_PersonDongCode.ItemIndex > 0 then
  begin
    stSql := stSql + ' AND BC_PARENTCODE = ''' + PersonDongCodeList.Strings[cmb_PersonDongCode.ItemIndex] + ''' ';
  end;
  if cmb_PersonAreaCode.ItemIndex > 0 then
  begin
    stSql := stSql + ' AND BC_CHILDCODE = ''' + PersonAreaCodeList.Strings[cmb_PersonAreaCode.ItemIndex] + ''' ';
  end;
  stSql := stSql + ' AND CA_CARDNO not in ' ;
  stSql := stSql + ' ( select CA_CARDNO from TB_DEVICECARDNO ';
  stSql := stSql + ' Where GROUP_CODE = ''' + G_stGroupCode + ''' ';
  stSql := stSql + ' AND DE_PERMIT = ''L'' ';
  stSql := stSql + ' AND ND_NODENO = ' + aNodeNo + ' ';
  stSql := stSql + ' AND DE_DEVICEID = ''' + aDeviceID + ''' ';
  stSql := stSql + ' AND DE_DOOR' + aDoorNo + ' = ''Y'') ';
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
      with sg_NotPermitCardList do
      begin
        nRow := 1;
        RowCount := RecordCount + 1;
        while Not Eof do
        begin
          AddCheckBox(0,nRow,False,False);
          cells[1,nRow] := FindField('CA_NAME').AsString;
          cells[2,nRow] := FindField('CA_CARDNO').AsString;

          nRow := nRow + 1;
          Next;
        end;
      end;
    end;
  Finally
    TempAdoQuery.Free;
    CoUninitialize;
  End;
end;

procedure TfmDoorCardPermit.sg_addDoorListDblClick(Sender: TObject);
var
  stNodeNo : string;
  stDeviceID : string;
  stDoorNo : string;
  stName : string;
begin
  inherited;
  with sg_addDoorList do
  begin
    stNodeNo := Cells[3,row];
    stDeviceID := Cells[4,row];
    stDoorNo := Cells[5,row];
    stName := Cells[2,row];
    PackagePermitDoorListAdd(stNodeNo,stDeviceID,stDoorNo,stName,lv_packagePermitDoorCardList);
    pan_addSearch.Visible := False;
  end;

end;

procedure TfmDoorCardPermit.sg_addPermitCardListCheckBoxClick(Sender: TObject;
  ACol, ARow: Integer; State: Boolean);
begin
  if ARow = 0 then //전체선택 또는 해제
  begin
    if State then L_nAddCardCheckCount := (Sender as TAdvStringGrid).RowCount - 1
    else L_nAddCardCheckCount := 0;
    AdvStrinGridSetAllCheck(Sender,State);
  end else
  begin
    if State then L_nAddCardCheckCount := L_nAddCardCheckCount + 1
    else L_nAddCardCheckCount := L_nAddCardCheckCount - 1 ;
  end;

end;

procedure TfmDoorCardPermit.sg_addPermitCardListResize(Sender: TObject);
var
  i : integer;
  nColWidth : integer;
begin
  inherited;
  with sg_addPermitCardList do
  begin
    nColWidth := (width - 50) div 5;
    ColWidths[0] := 30;
    for i := 1 to ColCount - 1 do
    begin
      if ColWidths[i] <> 0 then ColWidths[i] := nColWidth;
    end;

    L_nPageListMaxCount := Height div DefaultRowHeight;
  end;

end;

procedure TfmDoorCardPermit.sg_DoorListCheckBoxClick(Sender: TObject; ACol,
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

procedure TfmDoorCardPermit.sg_DoorListDblClick(Sender: TObject);
var
  nIndex : integer;
  stNodeNo : string;
  stDeviceID : string;
  stDoorNo : string;
begin
  inherited;

  with sg_DoorList do
  begin
    if cells[5,Row] = '' then Exit;
    lb_dong.Caption.Text := cells[1,Row];
    lb_Area.Caption.Text := cells[2,Row];
    lb_DoorName.Caption.Text := cells[3,Row];
    lb_NodeNo.Caption.Text := cells[4,Row];
    lb_DeviceID.Caption.Text := cells[5,Row];
    lb_DoorNo.Caption.Text := cells[6,Row];
  end;
  menuTab.AdvOfficeTabs.Items[0].Caption := dmFormName.GetFormMessage('1','M00040');
  pan_PackagePermitAdd.Visible := False;
  pan_DoorList.Visible := False;
  pan_PackagePermitDelete.Visible := False;
  pan_DoorPermit.Visible := True;
  pan_DoorPermit.Align := alClient;
  LoadChildCode(FillZeroNumber(0,G_nBuildingCodeLength),1,cmb_PersonDongCode,PersonDongCodeList,True);
  LoadChildCode('',2,cmb_PersonAreaCode,PersonAreaCodeList,True);

  stNodeNo := lb_NodeNo.Caption.Text;
  stDeviceID := lb_DeviceID.Caption.Text;
  stDoorNo := lb_DoorNo.Caption.Text;
  SearchNotCardPermit(stNodeNo,stDeviceID,stDoorNo);
  SearchCardPermit(stNodeNo,stDeviceID,stDoorNo);
end;

procedure TfmDoorCardPermit.sg_DoorListResize(Sender: TObject);
var
  i : integer;
  nColWidth : integer;
begin
  inherited;
  with sg_DoorList do
  begin
    nColWidth := (width - 50) div 3;
    ColWidths[0] := 30;
    for i := 1 to ColCount - 1 do
    begin
      if ColWidths[i] <> 0 then ColWidths[i] := nColWidth;
    end;

    L_nPageListMaxCount := Height div DefaultRowHeight;
  end;
end;

procedure TfmDoorCardPermit.sg_deleteDoorListDblClick(Sender: TObject);
var
  stNodeNo : string;
  stDeviceID : string;
  stDoorNo : string;
  stName : string;
begin
  inherited;
  with sg_deleteDoorList do
  begin
    stNodeNo := Cells[3,row];
    stDeviceID := Cells[4,row];
    stDoorNo := Cells[5,row];
    stName := Cells[2,row];
    PackagePermitDoorListAdd(stNodeNo,stDeviceID,stDoorNo,stName,lv_packagePermitDeleteDoorList);
    pan_addSearch.Visible := False;
  end;

end;

procedure TfmDoorCardPermit.sg_deletePermitCardListCheckBoxClick(
  Sender: TObject; ACol, ARow: Integer; State: Boolean);
begin
  inherited;
  if ARow = 0 then //전체선택 또는 해제
  begin
    if State then L_nDeleteCardCheckCount := (Sender as TAdvStringGrid).RowCount - 1
    else L_nDeleteCardCheckCount := 0;
    AdvStrinGridSetAllCheck(Sender,State);
  end else
  begin
    if State then L_nDeleteCardCheckCount := L_nDeleteCardCheckCount + 1
    else L_nDeleteCardCheckCount := L_nDeleteCardCheckCount - 1 ;
  end;

end;

procedure TfmDoorCardPermit.sg_deletePermitCardListResize(Sender: TObject);
var
  i : integer;
  nColWidth : integer;
begin
  inherited;
  with sg_deletePermitCardList do
  begin
    nColWidth := (width - 50) div 5;
    ColWidths[0] := 30;
    for i := 1 to ColCount - 1 do
    begin
      if ColWidths[i] <> 0 then ColWidths[i] := nColWidth;
    end;
  end;
end;

procedure TfmDoorCardPermit.sg_NotPermitCardListCheckBoxClick(Sender: TObject;
  ACol, ARow: Integer; State: Boolean);
begin
  inherited;
  if ARow = 0 then //전체선택 또는 해제
  begin
    if State then L_nNotPermitCardCheckCount := (Sender as TAdvStringGrid).RowCount - 1
    else L_nNotPermitCardCheckCount := 0;
    AdvStrinGridSetAllCheck(Sender,State);
  end else
  begin
    if State then L_nNotPermitCardCheckCount := L_nNotPermitCardCheckCount + 1
    else L_nNotPermitCardCheckCount := L_nNotPermitCardCheckCount - 1 ;
  end;

end;

procedure TfmDoorCardPermit.sg_NotPermitCardListResize(Sender: TObject);
begin
  inherited;
  TAdvStringGrid(Sender).ColWidths[1] := TAdvStringGrid(Sender).Width - 55;
end;

procedure TfmDoorCardPermit.sg_PermitCardListCheckBoxClick(Sender: TObject;
  ACol, ARow: Integer; State: Boolean);
begin
  inherited;
  if ARow = 0 then //전체선택 또는 해제
  begin
    if State then L_nPermitDoorCheckCount := (Sender as TAdvStringGrid).RowCount - 1
    else L_nPermitDoorCheckCount := 0;
    AdvStrinGridSetAllCheck(Sender,State);
  end else
  begin
    if State then L_nPermitDoorCheckCount := L_nPermitDoorCheckCount + 1
    else L_nPermitDoorCheckCount := L_nPermitDoorCheckCount - 1 ;
  end;

end;

procedure TfmDoorCardPermit.sg_PermitCardListResize(Sender: TObject);
begin
  inherited;
  TAdvStringGrid(Sender).ColWidths[2] := 35;
  TAdvStringGrid(Sender).ColWidths[1] := TAdvStringGrid(Sender).Width - 55 - TAdvStringGrid(Sender).ColWidths[2];

end;

procedure TfmDoorCardPermit.ShowDoorList(aCurrentCode: string;
  aTopRow: integer);
var
  stSql : string;
  TempAdoQuery : TADOQuery;
  nRow : integer;
begin
  GridInit(sg_DoorList,4,2,true);
  L_nCheckCount := 0;

  stSql := 'SELECT a.*,b.BC_NAME as DONGNAME,c.BC_NAME as AREANAME FROM ';
  stSql := stSql + ' (  ';
  stSql := stSql + ' (  ';
  stSql := stSql + ' TB_DOOR a ';
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
    stSql := stSql + ' AND a.DO_NAME Like ''%' + ed_name.Text + '%'' ';
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
      with sg_DoorList do
      begin
        nRow := 1;
        RowCount := RecordCount + 1;
        while Not Eof do
        begin
          AddCheckBox(0,nRow,False,False);
          cells[1,nRow] := FindField('DONGNAME').AsString;
          cells[2,nRow] := FindField('AREANAME').AsString;
          cells[3,nRow] := FindField('DO_NAME').AsString;
          cells[4,nRow] := FindField('ND_NODENO').AsString;
          cells[5,nRow] := FindField('DE_DEVICEID').AsString;
          cells[6,nRow] := FindField('DO_DOORNO').AsString;
          if (FindField('DO_DOORNO').AsString )  = aCurrentCode then
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

    end;
  Finally
    TempAdoQuery.Free;
    CoUninitialize;
  End;

end;

procedure TfmDoorCardPermit.btn_PackagePermitAddClick(Sender: TObject);
begin
  inherited;
  menutab.ActiveTabIndex := 2;
  menutabChange(self);

end;

procedure TfmDoorCardPermit.btn_PackagePermitDeleteClick(Sender: TObject);
begin
  inherited;
  menutab.ActiveTabIndex := 3;
  menutabChange(self);

end;

initialization
  RegisterClass(TfmDoorCardPermit);
Finalization
  UnRegisterClass(TfmDoorCardPermit);

end.
