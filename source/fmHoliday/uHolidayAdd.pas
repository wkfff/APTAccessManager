﻿unit uHolidayAdd;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,uSubForm, AdvOfficeTabSet,
  AdvOfficeTabSetStylers, CommandArray, Vcl.Grids, AdvObj, BaseGrid, AdvGrid,
  Vcl.StdCtrls, AdvEdit, Vcl.Buttons, AdvSmoothLabel, AdvSmoothPanel, W7Classes,
  W7Panels, AdvGlassButton,ADODB,ActiveX, frmshape, Vcl.Mask, AdvSpin,
  Vcl.ComCtrls, AdvDateTimePicker, AdvOfficeButtons, AdvToolBar,
  AdvToolBarStylers;

type
  TfmHolidayAdd = class(TfmASubForm)
    AdvOfficeTabSetOfficeStyler1: TAdvOfficeTabSetOfficeStyler;
    W7Panel1: TW7Panel;
    BodyPanel: TW7Panel;
    menuTab: TAdvOfficeTabSet;
    List: TAdvSmoothPanel;
    lb_SearchName: TAdvSmoothLabel;
    sg_List: TAdvStringGrid;
    btn_Add: TAdvGlassButton;
    btn_Delete: TAdvGlassButton;
    Add: TAdvSmoothPanel;
    lb_AddName: TAdvSmoothLabel;
    ed_InsertName: TAdvEdit;
    btn_Save: TAdvGlassButton;
    se_Year: TAdvSpinEdit;
    dt_AddDate: TAdvDateTimePicker;
    lb_AddDate: TAdvSmoothLabel;
    btn_BasicHoliday: TAdvGlassButton;
    chk_ACAdd: TAdvOfficeCheckBox;
    chk_ATAdd: TAdvOfficeCheckBox;
    AdvToolBarOfficeStyler1: TAdvToolBarOfficeStyler;
    procedure menuTabChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_SaveClick(Sender: TObject);
    procedure btn_AddClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btn_SearchClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sg_ListCheckBoxClick(Sender: TObject; ACol, ARow: Integer;
      State: Boolean);
    procedure sg_ListDblClick(Sender: TObject);
    procedure ed_SearchNameChange(Sender: TObject);
    procedure btn_DeleteClick(Sender: TObject);
    procedure CommandArrayCommandsTGRADEREFRESHExecute(Command: TCommand;
      Params: TStringList);
    procedure ed_InsertNameKeyPress(Sender: TObject; var Key: Char);
    procedure se_YearChange(Sender: TObject);
    procedure btn_BasicHolidayClick(Sender: TObject);
    procedure CommandArrayCommandsTMENUIDExecute(Command: TCommand;
      Params: TStringList);
  private
    L_nPageListMaxCount : integer;
    L_nCheckCount : integer;
    L_stButtonCloseCaption : string;
    L_stButtonPrevCaption : string;
    L_stDeleteCaption : string;
    L_stMenuID : string;
    { Private declarations }
    Function FormNameSetting:Boolean;
    procedure FontSetting;
    Function SearchList(aCurrentCode:string;aTopRow:integer = 0):Boolean;
    function InsertBascicHoliday(aDate,aName:string):Boolean;
  private
    procedure AdvStrinGridSetAllCheck(Sender: TObject;bchkState:Boolean);

  public
    { Public declarations }
    procedure FormChangeEvent(aFormName:integer);
  end;

var
  fmHolidayAdd: TfmHolidayAdd;

implementation
uses
  uFunction,
  uCommonVariable,
  uDataBase,
  uDBDelete,
  uDBFormName,
  uDBFunction,
  uDBInsert,
  uDBSelect,
  uDBUpdate,
  uSolarLunar,
  uFormFontUtil,
  uFormUtil;
{$R *.dfm}

procedure TfmHolidayAdd.AdvStrinGridSetAllCheck(Sender: TObject;
  bchkState: Boolean);
var
  i : integer;
begin
    for i:= 1 to (Sender as TAdvStringGrid).RowCount - 1  do
    begin
      (Sender as TAdvStringGrid).SetCheckBoxState(0,i,bchkState);
    end;

end;

procedure TfmHolidayAdd.btn_AddClick(Sender: TObject);
begin
  inherited;
  menuTab.ActiveTabIndex := 2;
  menuTabChange(self);
end;

procedure TfmHolidayAdd.btn_SaveClick(Sender: TObject);
var
  stDate : string;
  stMessage : string;
  nResult : integer;
  stACType : string;
  stATType : string;
begin
  inherited;
  Try
    btn_Add.Enabled := False;
    stDate := FormatDateTime('yyyymmdd',dt_AddDate.Date) ;

    if chk_ACAdd.Checked then stACType := '1'
    else stACType := '0';
    if chk_ATAdd.Checked then stATType := '1'
    else stATType := '0';

    nResult := dmDBFunction.CheckTB_HOLIDAY_Date(stDate);
    if nResult = 1 then
    begin
      if Not dmDBUpdate.updateTB_HOLIDAY_Value(stDate,ed_InsertName.Text,stACType,stATType) then
      begin
        stMessage := dmFormName.GetFormMessage('2','M00018');
        Application.MessageBox(PChar(stMessage),'Error',MB_OK);
        Exit;
      end;
    end else
    begin
      if Not dmDBInsert.InsertIntoTB_HOLIDAY_Value(stDate,ed_InsertName.Text,stACType,stATType) then
      begin
        stMessage := dmFormName.GetFormMessage('2','M00018');
        Application.MessageBox(PChar(stMessage),'Error',MB_OK);
        Exit;
      end;
    end;

    menuTab.ActiveTabIndex := 1;
    menuTabChange(self);
    SearchList(stDate);

    self.FindSubForm('Main').FindCommand('CHANGE').Params.Values['NAME'] := inttostr(FormHOLIDAYADMIN);
    self.FindSubForm('Main').FindCommand('CHANGE').Execute;
  Finally
    btn_Add.Enabled := True;
  End;

end;

procedure TfmHolidayAdd.btn_BasicHolidayClick(Sender: TObject);
var
  stYear : string;
  stDate : string;
  nYear,nMonth,nDay : Word;
begin
  inherited;
  stYear := inttostr(se_Year.Value);
  stDate := stYear + '0101';   //신정
  InsertBascicHoliday(stDate,'신정');
  stDate := stYear + '0301';   //삼일절
  InsertBascicHoliday(stDate,'삼일절');
  stDate := stYear + '0505';   //어린이날
  InsertBascicHoliday(stDate,'어린이날');
  stDate := stYear + '0606';   //현충일
  InsertBascicHoliday(stDate,'현충일');
  stDate := stYear + '0815';   //광복절
  InsertBascicHoliday(stDate,'광복절');
  stDate := stYear + '1009';   //한글날
  InsertBascicHoliday(stDate,'한글날');
  stDate := stYear + '1013';   //개천절
  InsertBascicHoliday(stDate,'개천절');
  stDate := stYear + '1225';   //성탄절
  InsertBascicHoliday(stDate,'성탄절');

  Lunar_To_Solar(se_Year.Value - 1,12,29,nYear,nMonth,nDay);
  stDate := FillZeroNumber(nYear,4) + FillZeroNumber(nMonth,2) + FillZeroNumber(nDay,2); //구정연휴
  InsertBascicHoliday(stDate,'구정연휴');
  Lunar_To_Solar(se_Year.Value,1,1,nYear,nMonth,nDay);
  stDate := FillZeroNumber(nYear,4) + FillZeroNumber(nMonth,2) + FillZeroNumber(nDay,2); //구정연휴
  InsertBascicHoliday(stDate,'구정연휴');
  Lunar_To_Solar(se_Year.Value,1,2,nYear,nMonth,nDay);
  stDate := FillZeroNumber(nYear,4) + FillZeroNumber(nMonth,2) + FillZeroNumber(nDay,2); //구정연휴
  InsertBascicHoliday(stDate,'구정연휴');
  Lunar_To_Solar(se_Year.Value,4,8,nYear,nMonth,nDay);
  stDate := FillZeroNumber(nYear,4) + FillZeroNumber(nMonth,2) + FillZeroNumber(nDay,2); //석가탄신일
  InsertBascicHoliday(stDate,'부처님오신날');
  Lunar_To_Solar(se_Year.Value,8,14,nYear,nMonth,nDay);
  stDate := FillZeroNumber(nYear,4) + FillZeroNumber(nMonth,2) + FillZeroNumber(nDay,2); //추석연휴
  InsertBascicHoliday(stDate,'추석연휴');
  Lunar_To_Solar(se_Year.Value,8,15,nYear,nMonth,nDay);
  stDate := FillZeroNumber(nYear,4) + FillZeroNumber(nMonth,2) + FillZeroNumber(nDay,2); //추석연휴
  InsertBascicHoliday(stDate,'추석연휴');
  Lunar_To_Solar(se_Year.Value,8,16,nYear,nMonth,nDay);
  stDate := FillZeroNumber(nYear,4) + FillZeroNumber(nMonth,2) + FillZeroNumber(nDay,2); //추석연휴
  InsertBascicHoliday(stDate,'추석연휴');
  //InsertBascicHoliday(stYear + '0101','신정')
  SearchList('');

end;

procedure TfmHolidayAdd.btn_DeleteClick(Sender: TObject);
var
  i : integer;
  bChkState : Boolean;
  stMessage : string;
  stDate : string;
begin
  inherited;
  stMessage := dmFormName.GetFormMessage('2','M00016');
  if L_nCheckCount = 0 then
  begin
    Application.MessageBox(PChar(stMessage),'Information',MB_OK);
    Exit;
  end;
  stMessage := dmFormName.GetFormMessage('2','M00020');
  stMessage := stringReplace(stMessage,'$COUNT',inttostr(L_nCheckCount),[rfReplaceAll]);
  if (Application.MessageBox(PChar(stMessage),'Information',MB_OKCANCEL) = IDCANCEL)  then Exit;
  With sg_List do
  begin
    for i := 1 to RowCount - 1 do
    begin
      GetCheckBoxState(0,i, bChkState);
      if bChkState then
      begin
        stDate := cells[1,i];
        stDate := stringReplace(stDate,'-','',[rfReplaceAll]);
        dmDBDelete.DeleteTB_HOLIDAY_DayAll(stDate);
      end;
    end;
  end;
  SearchList('');
  self.FindSubForm('Main').FindCommand('CHANGE').Params.Values['NAME'] := inttostr(FormHOLIDAYADMIN);
  self.FindSubForm('Main').FindCommand('CHANGE').Execute;
end;

procedure TfmHolidayAdd.btn_SearchClick(Sender: TObject);
begin
  inherited;
  SearchList('');
end;

procedure TfmHolidayAdd.CommandArrayCommandsTGRADEREFRESHExecute(
  Command: TCommand; Params: TStringList);
begin
  inherited;
  menuTab.AdvOfficeTabs.Items[1].Enabled := IsInsertGrade;
  btn_Add.Enabled := IsInsertGrade;
  btn_Delete.Enabled := IsDeleteGrade;
end;

procedure TfmHolidayAdd.CommandArrayCommandsTMENUIDExecute(Command: TCommand;
  Params: TStringList);
begin
  inherited;
  L_stMenuID := Params.Values['ID'];
end;

procedure TfmHolidayAdd.ed_InsertNameKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if key = #13 then
  begin
    key := #0;
    btn_SaveClick(self);
  end;

end;

procedure TfmHolidayAdd.ed_SearchNameChange(Sender: TObject);
begin
  inherited;
  SearchList('');
end;

procedure TfmHolidayAdd.FontSetting;
begin
  dmFormFontUtil.TravelFormFontSetting(self,G_stFontName,inttostr(G_nFontSize));
  dmFormFontUtil.TravelAdvOfficeTabSetOfficeStylerFontSetting(AdvOfficeTabSetOfficeStyler1, G_stFontName,inttostr(G_nFontSize));
  dmFormFontUtil.FormAdvOfficeTabSetOfficeStylerSetting(AdvOfficeTabSetOfficeStyler1,G_stFormStyle);
  dmFormFontUtil.FormAdvToolBarOfficeStylerSetting(AdvToolBarOfficeStyler1,G_stFormStyle);
  dmFormFontUtil.FormStyleSetting(self,AdvToolBarOfficeStyler1);
end;

procedure TfmHolidayAdd.FormChangeEvent(aFormName: integer);
begin

end;

procedure TfmHolidayAdd.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  self.FindSubForm('Main').FindCommand('FORMENABLE').Params.Values['NAME'] := inttostr(FormHOLIDAYADMIN);
  self.FindSubForm('Main').FindCommand('FORMENABLE').Params.Values['VALUE'] := 'FALSE';
  self.FindSubForm('Main').FindCommand('FORMENABLE').Execute;

  Action := caFree;
end;

procedure TfmHolidayAdd.FormCreate(Sender: TObject);
var
  stYear : string;
begin
  inherited;
  L_nPageListMaxCount := 17;
  stYear := FormatDateTime('YYYY',Now);
  se_Year.Value := strtoint(stYear);
  dt_AddDate.Date := Now;
  FontSetting;
  if G_nLangeType <> 1 then btn_BasicHoliday.Visible := False;
end;

function TfmHolidayAdd.FormNameSetting: Boolean;
var
  stSql : string;
  nCommonLength : integer;
  nButtonLength : integer;
  nMenuLength : integer;
  TempAdoQuery : TADOQuery;
begin
  Caption := dmFormName.GetFormMessage('1','M00061');
  menuTab.AdvOfficeTabs[0].Caption := dmFormName.GetFormMessage('1','M00035');
  menuTab.AdvOfficeTabs[1].Caption := dmFormName.GetFormMessage('1','M00061');
  menuTab.AdvOfficeTabs[2].Caption := dmFormName.GetFormMessage('4','M00125');
  btn_Add.Caption := dmFormName.GetFormMessage('4','M00125');
  btn_Delete.Caption := dmFormName.GetFormMessage('4','M00126');
  lb_SearchName.Caption.Text := dmFormName.GetFormMessage('4','M00127');
  lb_AddDate.Caption.Text := dmFormName.GetFormMessage('4','M00128');
  lb_AddName.Caption.Text := dmFormName.GetFormMessage('4','M00113');
  chk_ACAdd.Caption := dmFormName.GetFormMessage('4','M00129');
  chk_ATAdd.Caption := dmFormName.GetFormMessage('4','M00130');
  btn_Save.Caption := dmFormName.GetFormMessage('4','M00014');
  btn_BasicHoliday.Caption := dmFormName.GetFormMessage('4','M00131');

  L_stButtonCloseCaption := dmFormName.GetFormMessage('1','M00035');
  L_stButtonPrevCaption := dmFormName.GetFormMessage('1','M00040');
  L_stDeleteCaption := dmFormName.GetFormMessage('4','M00078');

  with sg_List do
  begin
    hint := dmFormName.GetFormMessage('2','M00012');
    Cells[1,0] := dmFormName.GetFormMessage('4','M00128');
    Cells[2,0] := dmFormName.GetFormMessage('4','M00113');
  end;

end;

procedure TfmHolidayAdd.FormResize(Sender: TObject);
begin
  inherited;
  BodyPanel.Left := 0;
  BodyPanel.Top := 0;
  BodyPanel.Height := Height - menuTab.Height;

end;

procedure TfmHolidayAdd.FormShow(Sender: TObject);
begin
  inherited;
  WindowState := wsMaximized;

  FormNameSetting;
  self.FindSubForm('Main').FindCommand('FORMENABLE').Params.Values['NAME'] := inttostr(FormHOLIDAYADMIN);
  self.FindSubForm('Main').FindCommand('FORMENABLE').Params.Values['VALUE'] := 'TRUE';
  self.FindSubForm('Main').FindCommand('FORMENABLE').Execute;

  menuTab.ActiveTabIndex := 1;
  menuTabChange(self);
  SearchList('');

end;

function TfmHolidayAdd.InsertBascicHoliday(aDate, aName: string): Boolean;
var
  nResult : integer;
begin
  result := False;
  nResult := dmDBFunction.CheckTB_HOLIDAY_Date(aDate);
  if nResult = 2 then
  begin
    Exit;
  end;
  if nResult <> 1 then
  begin
    if Not dmDBInsert.InsertIntoTB_HOLIDAY_Value(aDate,aName,'1','1') then
    begin
      Exit;
    end;
  end;
  result := True;

end;

procedure TfmHolidayAdd.menuTabChange(Sender: TObject);
begin
  inherited;
  if menuTab.ActiveTabIndex = 0 then //Ȩ
  begin
    if menuTab.AdvOfficeTabs.Items[0].Caption = L_stButtonCloseCaption then Close
    else
    begin
      menuTab.ActiveTabIndex := 1;
      menuTabChange(self);
    end;
  end else if menuTab.ActiveTabIndex = 1 then
  begin
    menuTab.AdvOfficeTabs.Items[0].Caption := L_stButtonCloseCaption;
    List.Visible := True;
    Add.Visible := False;
    List.Align := alClient;
  end else if menuTab.ActiveTabIndex = 2 then
  begin
    menuTab.AdvOfficeTabs.Items[0].Caption := L_stButtonPrevCaption;
    List.Visible := False;
    Add.Visible := True;
    Add.Align := alClient;
    dt_AddDate.Date := now;
    dt_AddDate.Enabled := True;
    ed_InsertName.Text := '';
    chk_ACAdd.Checked := True;
    chk_ATAdd.Checked := True;
  end;
end;

function TfmHolidayAdd.SearchList(aCurrentCode:string;aTopRow:integer = 0): Boolean;
var
  stSql : string;
  TempAdoQuery : TADOQuery;
  nRow : integer;
  stYear : string;
begin
  GridInit(sg_List,3,2,true);

  stYear := inttostr(se_Year.Value);
  stSql := dmDBSelect.SelectTB_Holiday_Year(stYear);
  L_nCheckCount := 0;

  Try
    CoInitialize(nil);
    TempAdoQuery := TADOQuery.Create(nil);
    TempAdoQuery.Connection := dmDataBase.ADOConnection;
    TempAdoQuery.DisableControls;

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
      with sg_List do
      begin
        nRow := 1;
        RowCount := RecordCount + 1;
        while Not Eof do
        begin
          AddCheckBox(0,nRow,False,False);
          cells[1,nRow] := MakeDatetimeStr(FindField('HO_DAY').AsString);
          cells[2,nRow] := FindField('NAME').AsString;
          if FindField('HO_ACUSE').AsString = '1' then AddCheckBox(3,nRow,True,False)
          else AddCheckBox(3,nRow,False,False);
          if FindField('HO_ATUSE').AsString = '1' then AddCheckBox(4,nRow,True,False)
          else AddCheckBox(4,nRow,False,False);

          if (FindField('HO_DAY').AsString )  = aCurrentCode then
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
    TempAdoQuery.EnableControls;
    TempAdoQuery.Free;
    CoUninitialize;
  End;
end;


procedure TfmHolidayAdd.se_YearChange(Sender: TObject);
begin
  inherited;
  SearchList('');
end;

procedure TfmHolidayAdd.sg_ListCheckBoxClick(Sender: TObject; ACol,
  ARow: Integer; State: Boolean);
begin
  inherited;
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

procedure TfmHolidayAdd.sg_ListDblClick(Sender: TObject);
var
  bChecked : Boolean;
  stDate : string;
begin
  inherited;
  with sg_List do
  begin
    if cells[1,Row] = '' then Exit;
    stDate := stringReplace(cells[1,Row],'-','',[rfReplaceAll]);
    stDate := copy(stDate,1,4) + '-' + copy(stDate,5,2) + '-' + copy(stDate,7,2);
    Try
      dt_AddDate.Date := strtoDate(stDate);
    Except
      Exit;
    End;
    dt_AddDate.Enabled := False;
    ed_InsertName.Text := cells[2,Row];
    GetCheckBoxState(3,Row, bChecked);
    chk_ACAdd.Checked := bChecked;
    GetCheckBoxState(4,Row, bChecked);
    chk_ATAdd.Checked := bChecked;
  end;
  menuTab.AdvOfficeTabs.Items[0].Caption := L_stButtonPrevCaption;
  List.Visible := False;
  Add.Visible := True;
  Add.Align := alClient;

end;

initialization
  RegisterClass(TfmHolidayAdd);
Finalization
  UnRegisterClass(TfmHolidayAdd);

end.
