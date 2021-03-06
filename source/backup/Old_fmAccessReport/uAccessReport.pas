﻿unit uAccessReport;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, W7Classes, W7Panels, AdvOfficeTabSet,
  AdvOfficeTabSetStylers, AdvSmoothPanel, Vcl.ExtCtrls, AdvSmoothLabel,
  Vcl.StdCtrls, AdvEdit, Vcl.Buttons, Vcl.Grids, AdvObj, BaseGrid, AdvGrid,
  AdvToolBtn,ADODB,ActiveX, uSubForm, CommandArray, AdvCombo, AdvGroupBox,
  Vcl.Mask, AdvSpin, AdvOfficeButtons, AdvPanel, Vcl.ComCtrls, AdvListV,
  Vcl.ImgList, Vcl.Menus, AdvMenus, AdvExplorerTreeview, paramtreeview,
  System.iniFiles, Vcl.Samples.Gauges, tmsAdvGridExcel;


type
  TfmAccessReport = class(TfmASubForm)
    AdvOfficeTabSetOfficeStyler1: TAdvOfficeTabSetOfficeStyler;
    Image1: TImage;
    BodyPanel: TW7Panel;
    menuTab: TAdvOfficeTabSet;
    pan_DoorList: TAdvPanel;
    pan_CardListHeader: TAdvSmoothPanel;
    lb_Date: TAdvSmoothLabel;
    lb_name: TAdvSmoothLabel;
    cmb_ListDongCode: TComboBox;
    ImageList1: TImageList;
    pop_PermitAdd: TAdvPopupMenu;
    mn_addpermitListDelete: TMenuItem;
    toolslist: TImageList;
    ed_name: TAdvEdit;
    lb_Door: TAdvSmoothLabel;
    dt_StartDate: TDateTimePicker;
    dt_endDate: TDateTimePicker;
    AdvSmoothLabel2: TAdvSmoothLabel;
    btn_Search: TSpeedButton;
    btn_Excel: TSpeedButton;
    btn_Print: TSpeedButton;
    sg_report: TAdvStringGrid;
    SaveDialog1: TSaveDialog;
    pan_gauge: TPanel;
    lb_Message: TLabel;
    Gauge1: TGauge;
    AdvGridExcelIO1: TAdvGridExcelIO;
    procedure menuTabChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ed_AddNameKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure AdvSmoothPanel8Resize(Sender: TObject);
    procedure btn_SearchClick(Sender: TObject);
    procedure cmb_ListDongCodeChange(Sender: TObject);
    procedure ed_nameKeyPress(Sender: TObject; var Key: Char);
    procedure btn_ExcelClick(Sender: TObject);
    procedure btn_PrintClick(Sender: TObject);
    procedure sg_reportResize(Sender: TObject);
  private
    ListDoorCodeList : TStringList;
    { Private declarations }
  private
    procedure LoadDeviceCode(cmbBox:TComboBox;aList:TStringList;aAll:Boolean);

    procedure AdvStrinGridSetAllCheck(Sender: TObject;bchkState:Boolean);

    function GetstChangeStateName(aInputType:string):string;
    procedure FormNameSetting;
  private
    procedure SearchAccessReport;
  public
    { Public declarations }
    procedure Form_Close;
  end;

var
  fmAccessReport: TfmAccessReport;

implementation
uses
  uCommonVariable,
  uDataBase,
  uDBFormName,
  uFormUtil,
  uFunction,
  uMessage,
  udmCardPermit,
  uExcelSave;

{$R *.dfm}


procedure TfmAccessReport.AdvSmoothPanel8Resize(Sender: TObject);
var
  nWidth : integer;
begin
  inherited;
end;

procedure TfmAccessReport.AdvStrinGridSetAllCheck(Sender: TObject;
  bchkState: Boolean);
var
  i : integer;
begin
    for i:= 1 to (Sender as TAdvStringGrid).RowCount - 1  do
    begin
      (Sender as TAdvStringGrid).SetCheckBoxState(0,i,bchkState);
    end;
end;

procedure TfmAccessReport.btn_ExcelClick(Sender: TObject);
var
  stRefFileName,stSaveFileName:String;
  stPrintRefPath : string;
  nExcelRowStart:integer;
  ini_fun : TiniFile;
  aFileName : string;
  stTitle : string;
begin
  btn_Excel.Enabled := False;
  aFileName:='출입보고서';
  SaveDialog1.FileName := aFileName;
  if SaveDialog1.Execute then
  begin
    stSaveFileName := SaveDialog1.FileName;

    if SaveDialog1.FileName <> '' then
    begin
      //sg_Report.SaveToXLS(stSaveFileName,True);
      if fileexists(stSaveFileName) then
        deletefile(stSaveFileName);
      advgridexcelio1.XLSExport(stSaveFileName);
    end;
  end;
  btn_Excel.Enabled := True;
  Exit;
  btn_Excel.Enabled := False;
  Screen.Cursor:= crHourGlass;
  stTitle := '출입이력보고서';
  ini_fun := TiniFile.Create(G_stExeFolder + '\print.ini');
  stPrintRefPath := G_stExeFolder + '\..\print\' ;
  stPrintRefPath := ini_fun.ReadString('환경설정','PrintRefPath',stPrintRefPath);
  stRefFileName  := ini_fun.ReadString('출입보고서','참조파일','ACReport.xls');
  stRefFileName := stPrintRefPath + stRefFileName;
  nExcelRowStart := ini_fun.ReadInteger('출입보고서','시작위치',6);
  ini_fun.Free;

  aFileName:='출입보고서';
  SaveDialog1.FileName := aFileName;
  if SaveDialog1.Execute then
  begin
    stSaveFileName := SaveDialog1.FileName;

    if SaveDialog1.FileName <> '' then
    begin
      pan_gauge.Visible := True;
      Screen.Cursor:= crHourGlass;
      dmExcelSave.ExcelPrintOut(sg_Report,stRefFileName,stSaveFileName,True,nExcelRowStart,stTitle,False,False,Gauge1);
    end;
  end;
  pan_gauge.Visible := False;
  Screen.Cursor:= crDefault;
  btn_Excel.Enabled := True;
end;

procedure TfmAccessReport.btn_PrintClick(Sender: TObject);
var
  stRefFileName,stSaveFileName:String;
  stPrintRefPath : string;
  nExcelRowStart:integer;
  ini_fun : TiniFile;
  stTitle : string;
begin
  sg_Report.Print;
  Exit;
  btn_Print.Enabled := False;
  Screen.Cursor:= crHourGlass;
  stTitle := '출입이력보고서';
  ini_fun := TiniFile.Create(G_stExeFolder + '\print.ini');
  stPrintRefPath := G_stExeFolder + '\..\print\' ;
  stPrintRefPath := ini_fun.ReadString('환경설정','PrintRefPath',stPrintRefPath);
  stRefFileName  := ini_fun.ReadString('출입보고서','참조파일','ACReport.xls');
  stRefFileName := stPrintRefPath + stRefFileName;
  nExcelRowStart := ini_fun.ReadInteger('출입보고서','시작위치',6);
  ini_fun.Free;

  dmExcelSave.ExcelPrintOut(sg_Report,stRefFileName,stSaveFileName,False,nExcelRowStart,stTitle,False,False,Gauge1);

  btn_Print.Enabled := True;
  Screen.Cursor:= crDefault;

end;

procedure TfmAccessReport.btn_SearchClick(Sender: TObject);
begin
  inherited;
  SearchAccessReport;
end;

procedure TfmAccessReport.cmb_ListDongCodeChange(Sender: TObject);
begin
  inherited;
  SearchAccessReport;
end;

procedure TfmAccessReport.ed_AddNameKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  if Key = #13 then
  begin
    Perform(WM_NEXTDLGCTL,0,0);
  end;
end;

procedure TfmAccessReport.ed_nameKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if Key = #13 then
  begin
    Key := #0;
    SearchAccessReport;
  end;

end;

procedure TfmAccessReport.FormActivate(Sender: TObject);
begin
  inherited;
  FormNameSetting;
  WindowState := wsMaximized;
end;

procedure TfmAccessReport.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  self.FindSubForm('Main').FindCommand('FORMENABLE').Params.Values['NAME'] := inttostr(FORMACCESSREPORT);
  self.FindSubForm('Main').FindCommand('FORMENABLE').Params.Values['VALUE'] := 'FALSE';
  self.FindSubForm('Main').FindCommand('FORMENABLE').Execute;

  Action := caFree;
end;

procedure TfmAccessReport.FormCreate(Sender: TObject);
begin

  ListDoorCodeList := TStringList.Create;

  menuTab.ActiveTabIndex := 1;
  menuTabChange(self);

  LoadDeviceCode(cmb_ListDongCode,ListDoorCodeList,True);
  dt_StartDate.Date := Now;
  dt_endDate.Date := now;

end;


procedure TfmAccessReport.FormNameSetting;
begin
  Caption := dmFormName.GetFormMessage('1','M00023');
  menuTab.AdvOfficeTabs[0].Caption := dmFormName.GetFormMessage('1','M00035');
  menuTab.AdvOfficeTabs[1].Caption := dmFormName.GetFormMessage('1','M00036');
  pan_CardListHeader.Caption.Text := dmFormName.GetFormMessage('1','M00023');
  lb_Date.Caption.Text := dmFormName.GetFormMessage('4','M00001');
  lb_Door.Caption.Text := dmFormName.GetFormMessage('4','M00002');
  //lb_Gubun.Caption.Text := dmFormName.GetFormMessage('4','M00003');
  //lb_Company.Caption.Text := dmFormName.GetFormMessage('4','M00004');
  //lb_Depart.Caption.Text := dmFormName.GetFormMessage('4','M00005');
  lb_name.Caption.Text := dmFormName.GetFormMessage('4','M00006');
  btn_Search.Caption :=  dmFormName.GetFormMessage('4','M00007');
  btn_Excel.Caption :=  dmFormName.GetFormMessage('4','M00008');
  btn_Print.Caption :=  dmFormName.GetFormMessage('4','M00009');

  with sg_report do
  begin
    cells[0,0] := dmFormName.GetFormMessage('4','M00010');
    cells[1,0] := dmFormName.GetFormMessage('4','M00002');
    cells[2,0] := dmFormName.GetFormMessage('4','M00004');
    cells[3,0] := dmFormName.GetFormMessage('4','M00005');
    cells[4,0] := dmFormName.GetFormMessage('4','M00011');
    cells[5,0] := dmFormName.GetFormMessage('4','M00006');
    cells[6,0] := dmFormName.GetFormMessage('4','M00012');
    cells[7,0] := dmFormName.GetFormMessage('4','M00003');
    cells[8,0] := dmFormName.GetFormMessage('4','M00013');
  end;
  lb_Message.Caption := dmFormName.GetFormMessage('2','M00011');
end;

procedure TfmAccessReport.FormShow(Sender: TObject);
begin
  self.FindSubForm('Main').FindCommand('FORMENABLE').Params.Values['NAME'] := inttostr(FORMACCESSREPORT);
  self.FindSubForm('Main').FindCommand('FORMENABLE').Params.Values['VALUE'] := 'TRUE';
  self.FindSubForm('Main').FindCommand('FORMENABLE').Execute;
  SearchAccessReport;
end;

procedure TfmAccessReport.Form_Close;
begin
  Close;
end;




function TfmAccessReport.GetstChangeStateName(aInputType: string): string;
begin
  case aInputType[1] of
    'c' : begin
      result := '카드';
    end;
    'p' : begin
      result := '비밀번호';
    end;
    'm' : begin
      result := '마스터번호';
    end;
    else begin
      result := aInputType;
    end;
  end;
end;

procedure TfmAccessReport.LoadDeviceCode(cmbBox: TComboBox; aList: TStringList; aAll: Boolean);
var
  stSql : string;
  TempAdoQuery : TADOQuery;
begin
  cmbBox.Items.Clear;
  aList.Clear;
  if aAll then
  begin
    cmbBox.Items.Add('전체');
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



procedure TfmAccessReport.menuTabChange(Sender: TObject);
var
  stBuildingCode : string;
  stAreaCode : string;
  nIndex : integer;
begin
  if menuTab.ActiveTabIndex = 0 then //Ȩ
  begin
    if menuTab.AdvOfficeTabs.Items[0].Caption = '닫기' then Close
    else
    begin
      menuTab.ActiveTabIndex := 1;
      menuTabChange(self);
    end;
  end;
end;


procedure TfmAccessReport.SearchAccessReport;
var
  stSql : string;
  TempAdoQuery : TADOQuery;
  nRow : integer;
  stStartDate : string;
  stEndDate : string;
  stNodeNo : string;
  stDeviceID : string;
  stDoorNo : string;
  stChangeStateName : string;
  stCompanyCode : string;
  stDepartCode : string;
begin
  btn_Excel.Enabled := False;
  btn_Print.Enabled := False;
  stStartDate := FormatDateTime('yyyymmdd',dt_StartDate.DateTime);
  stEndDate := FormatDateTime('yyyymmdd',dt_endDate.DateTime);
  if cmb_ListDongCode.ItemIndex > 0 then
  begin
    stNodeNo := copy(ListDoorCodeList.strings[cmb_ListDongCode.ItemIndex],1,G_nNodeCodeLength);
    stDeviceID := copy(ListDoorCodeList.strings[cmb_ListDongCode.ItemIndex],G_nNodeCodeLength + 1,G_nDeviceCodeLength);
    stDoorNo := copy(ListDoorCodeList.strings[cmb_ListDongCode.ItemIndex],G_nNodeCodeLength + G_nDeviceCodeLength + 1,G_nDoorCodeLength);
  end;

  stCompanyCode := '';
  stDepartCode := '';

  GridInit(sg_report,8);
  Try
    CoInitialize(nil);
    TempAdoQuery := TADOQuery.Create(nil);
    TempAdoQuery.Connection := dmDataBase.ADOConnection;
    stSql := 'SELECT a.*,b.DO_NAME,c.BC_NAME as DONGNAME,d.BC_NAME as AREANAME,e.CA_NAME,e.CA_CODE,f.PE_PERMITNAME FROM ';
    stSql := stSql + ' ( ';
    stSql := stSql + ' ( ';
    stSql := stSql + ' ( ';
    stSql := stSql + ' ( ';
    stSql := stSql + ' ( ';
    stSql := stSql + ' (select * from TB_ACCESSEVENT IN ''';
    stSql := stSql + G_stExeFolder + '\..\..\..\DB\ACCEVENT.mdb'') a ';
    stSql := stSql + ' Left Join TB_DOOR b ';
    stSql := stSql + ' ON (a.GROUP_CODE = b.GROUP_CODE ) ';
    stSql := stSql + ' AND (a.ND_NODENO = b.ND_NODENO ) ';
    stSql := stSql + ' AND (a.DE_DEVICEID = b.DE_DEVICEID ) ';
    stSql := stSql + ' AND (a.DO_DOORNO = b.DO_DOORNO ) ';
    stSql := stSql + ' ) ';
    stSql := stSql + ' Left Join (select * from TB_BUILDINGCODE where BC_POSITION = 1) c ';
    stSql := stSql + ' ON(b.GROUP_CODE = c.GROUP_CODE) ';
    stSql := stSql + ' AND(b.BC_PARENTCODE =c.BC_CHILDCODE) ';
    stSql := stSql + ' ) ';
    stSql := stSql + ' Left Join (select * from TB_BUILDINGCODE where BC_POSITION = 2) d ';
    stSql := stSql + ' ON(b.GROUP_CODE = d.GROUP_CODE) ';
    stSql := stSql + ' AND(b.BC_PARENTCODE =d.BC_PARENTCODE) ';
    stSql := stSql + ' AND(b.BC_CHILDCODE =d.BC_CHILDCODE) ';
    stSql := stSql + ' ) ';
    if (ed_name.Text <> '') or (stCompanyCode <> '') then
    begin
      stSql := stSql + ' Inner Join ( select * from TB_CARD ';
      if ed_name.Text <> '' then
      begin
         stSql := stSql + ' Where CA_NAME Like ''%' + ed_name.Text + '%'' ';
      end else
      begin
         stSql := stSql + ' Where BC_PARENTCODE = ''' + stCompanyCode + ''' ';
         if stDepartCode <> '' then stSql := stSql + ' AND BC_CHILDCODE = ''' + stCompanyCode + ''' ';
      end;
      stSql := stSql + ' )e ';
    end else
    begin
      stSql := stSql + ' Left Join TB_CARD e ';
    end;
    stSql := stSql + ' ON(a.GROUP_CODE = e.GROUP_CODE) ';
    stSql := stSql + ' AND(a.CA_CARDNO =e.CA_CARDNO) ';
    stSql := stSql + ' ) ';
    stSql := stSql + ' Left Join TB_PERMITCODE f ';
    stSql := stSql + ' ON(a.GROUP_CODE = f.GROUP_CODE) ';
    stSql := stSql + ' AND(a.PE_PERMITCODE =f.PE_PERMITCODE) ';
    stSql := stSql + ' ) ';
    stSql := stSql + ' Where a.GROUP_CODE = ''' + G_stGroupCode + ''' ';
    stSql := stSql + ' AND a.AC_DATE BETWEEN ''' + stStartDate + ''' AND ''' + stEndDate + ''' ';
    if cmb_ListDongCode.ItemIndex > 0 then
    begin
      if isDigit(stNodeNo) then
        stSql := stSql + ' AND a.ND_NODENO = ' + inttostr(strtoint(stNodeNo));
      stSql := stSql + ' AND a.DE_DEVICEID = ''' + stDeviceID + ''' ';
      if isDigit(stNodeNo) then
        stSql := stSql + ' AND a.DO_DOORNO = ' + inttostr(strtoint(stDoorNo));
    end;

    with TempAdoQuery do
    begin
      Close;
      sql.Text := stSql;
      Try
        Open;
      Except
        Exit;
      End;
      if recordcount < 1 then
      begin
        showmessage(dmFormName.GetFormMessage('2','M00021'));
        Exit;
      end;
      with sg_report do
      begin
        nRow := 1;
        RowCount := RecordCount + 1;
        while Not Eof do
        begin
          stChangeStateName := GetstChangeStateName(FindField('AC_INPUTTYPE').AsString);
          cells[0,nRow] := MakeDatetimeStr(FindField('AC_DATE').AsString + FindField('AC_TIME').AsString);
          cells[1,nRow] := FindField('DO_NAME').AsString;
          cells[2,nRow] := FindField('DONGNAME').AsString;
          cells[3,nRow] := FindField('AREANAME').AsString;
          cells[4,nRow] := FindField('CA_CODE').AsString;
          cells[5,nRow] := FindField('CA_NAME').AsString;
          cells[6,nRow] := FindField('CA_CARDNO').AsString;
          cells[7,nRow] := stChangeStateName;
          cells[8,nRow] := FindField('PE_PERMITNAME').AsString;

          nRow := nRow + 1;
          Next;
        end;
      end;
      btn_Excel.Enabled := True;
      btn_Print.Enabled := True;
    end;
  Finally
    TempAdoQuery.Free;
    CoUninitialize;
  End;
end;

procedure TfmAccessReport.sg_reportResize(Sender: TObject);
begin
  inherited;
  sg_report.DefaultColWidth := (sg_report.Width - 20) div sg_report.ColCount;
end;

initialization
  RegisterClass(TfmAccessReport);
Finalization
  UnRegisterClass(TfmAccessReport);

end.
