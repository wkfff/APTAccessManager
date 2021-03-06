﻿unit uNodeAdmin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, W7Classes, W7Panels, AdvOfficeTabSet,
  AdvOfficeTabSetStylers, AdvSmoothPanel, Vcl.ExtCtrls, AdvSmoothLabel,
  Vcl.StdCtrls, AdvEdit, Vcl.Buttons, Vcl.Grids, AdvObj, BaseGrid, AdvGrid,
  AdvToolBtn,ADODB,ActiveX, uSubForm, CommandArray, AdvCombo, AdvGroupBox,
  AdvToolBar, AdvToolBarStylers, AdvAppStyler;

type
  TfmNodeAdmin = class(TfmASubForm)
    AdvOfficeTabSetOfficeStyler1: TAdvOfficeTabSetOfficeStyler;
    Image1: TImage;
    BodyPanel: TW7Panel;
    menuTab: TAdvOfficeTabSet;
    dongCodeList: TAdvSmoothPanel;
    NodeAdd: TAdvSmoothPanel;
    lb_Nodename: TAdvSmoothLabel;
    ed_Nodename: TAdvEdit;
    btn_Search: TSpeedButton;
    sg_NodeList: TAdvStringGrid;
    btn_Delete: TSpeedButton;
    lb_NodeAdd: TAdvSmoothLabel;
    ed_InsertName: TAdvEdit;
    btn_InsertSave: TSpeedButton;
    btn_add: TSpeedButton;
    dongCodeUpdate: TAdvSmoothPanel;
    lb_NodeUpdate: TAdvSmoothLabel;
    btn_UpdateSave: TSpeedButton;
    ed_UpdateName: TAdvEdit;
    ed_UpdateNodeNo: TAdvEdit;
    lb_NodeTypeAdd: TAdvSmoothLabel;
    cmb_InsertNodeType: TAdvComboBox;
    gb_RS232Config: TAdvGroupBox;
    gb_TCPIPConfig: TAdvGroupBox;
    lb_rs232PortAdd: TAdvSmoothLabel;
    cmb_InsertComPort: TAdvComboBox;
    lb_NodeIPAdd: TAdvSmoothLabel;
    ed_InsertNodeIP: TAdvEdit;
    lb_NodePortAdd: TAdvSmoothLabel;
    ed_InsertNodePort: TAdvEdit;
    lb_NodeTypeUpdate: TAdvSmoothLabel;
    cmb_UpdateNodeType: TAdvComboBox;
    gb_UpdateRS232Config: TAdvGroupBox;
    lb_rs232PortUpdate: TAdvSmoothLabel;
    cmb_UpdateComPort: TAdvComboBox;
    gb_UpdateTCPIPConfig: TAdvGroupBox;
    lb_NodeIPUpdate: TAdvSmoothLabel;
    lb_NodePortUpdate: TAdvSmoothLabel;
    ed_UpdateNodeIP: TAdvEdit;
    ed_UpdateNodePort: TAdvEdit;
    AdvToolBarOfficeStyler1: TAdvToolBarOfficeStyler;
    AdvFormStyler1: TAdvFormStyler;
    procedure menuTabChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btn_SearchClick(Sender: TObject);
    procedure lb_page1Click(Sender: TObject);
    procedure ed_NodenameChange(Sender: TObject);
    procedure sg_NodeListKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure sg_NodeListKeyPress(Sender: TObject; var Key: Char);
    procedure btn_SaveClick(Sender: TObject);
    procedure btn_InsertSaveClick(Sender: TObject);
    procedure ed_InsertNameKeyPress(Sender: TObject; var Key: Char);
    procedure sg_NodeListCheckBoxClick(Sender: TObject; ACol, ARow: Integer;
      State: Boolean);
    procedure btn_DeleteClick(Sender: TObject);
    procedure btn_addClick(Sender: TObject);
    procedure sg_dongCodeColChanging(Sender: TObject; OldCol, NewCol: Integer;
      var Allow: Boolean);
    procedure sg_NodeListDblClick(Sender: TObject);
    procedure btn_UpdateSaveClick(Sender: TObject);
    procedure cmb_InsertNodeTypeChange(Sender: TObject);
    procedure cmb_UpdateNodeTypeChange(Sender: TObject);
    procedure ed_UpdateNameKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
  private
    L_nPageGroupMaxCount : integer ; //한페이지 그룹에 해당하는 페이지수
    L_nPageListMaxCount : integer; //한페이지에 출력되는 리스트 갯수
    L_nCurrentPageGroup : integer;   //지금 속한 페이지 그룹
    L_nCurrentPageList : integer;    //지금 조회 하고 있는 페이지
    L_CurrentSaveRow : integer;

    L_bNodeChange : Boolean;

    L_nCheckCount : integer;        //체크 된 카운트
    { Private declarations }
    procedure PageTabCreate(aPageGroup,aCurrentPage:integer);
    procedure ShowNodeList(aCurrentCode:string;aTopRow:integer = 0);
    procedure UpdateCell;
    procedure SaveUpdateCell;
    function DeleteTB_NODE(aNodeNo:string):Boolean;

    function GetNextNodeNo:string;
    function DupCheckSerialPort(aNodeNo:string;aComport:integer;var aDupName:string):Boolean;
    function DupCheckTCPIPPort(aNodeNo,aNodeIP,aNodePort:string;var aDupName:string):Boolean;
  private
    procedure AdvStrinGridSetAllCheck(Sender: TObject;bchkState:Boolean);
    procedure ComPortCreate(cmbBox:TComboBox);
  public
    { Public declarations }
    procedure FormNameSetting;
    procedure FontSetting;
    procedure Form_Close;
  end;

var
  fmNodeAdmin: TfmNodeAdmin;

implementation
uses
  uCommonVariable,
  uDataBase,
  uDBFormName,
  uFormFontUtil,
  uFormUtil,
  uFunction,
  uMessage;

{$R *.dfm}


procedure TfmNodeAdmin.AdvStrinGridSetAllCheck(Sender: TObject;
  bchkState: Boolean);
var
  i : integer;
begin
    for i:= 1 to (Sender as TAdvStringGrid).RowCount - 1  do
    begin
      (Sender as TAdvStringGrid).SetCheckBoxState(0,i,bchkState);
    end;
end;

procedure TfmNodeAdmin.btn_InsertSaveClick(Sender: TObject);
var
  stNodeNo : string;
  stChildCode : string;
  stName : string;
  stSql : string;
  bResult : Boolean;
  stDupName : string;
  nComPort : integer;
  nTCPIPPort : integer;
  stMessage : string;
begin
  inherited;
  stName := ed_InsertName.Text;
  stNodeNo := GetNextNodeNo;
  nComPort := 0;
  nTCPIPPort := 0;
  if stName = '' then
  begin
    showmessage(stringReplace(dmFormName.GetFormMessage('2','M00015'),'$NAME',lb_NodeAdd.Caption.Text,[rfReplaceAll]));
    Exit;
  end;
  if cmb_InsertNodeType.ItemIndex = 0 then
  begin
    if DupCheckSerialPort(stNodeNo,cmb_InsertComPort.ItemIndex + 1, stDupName) then
    begin
      stMessage := dmFormName.GetFormMessage('2','M00063');
      stMessage := stringReplace(stMessage,'$NUM ',inttostr(cmb_InsertComPort.ItemIndex + 1),[rfReplaceAll]);
      stMessage := stringReplace(stMessage,'$NAME',stDupName,[rfReplaceAll]);
      showmessage(stMessage);
      Exit;
    end;
    nComPort := cmb_InsertComPort.ItemIndex + 1;
  end else
  begin
    if ed_InsertNodeIP.Text = '' then
    begin
      showmessage(stringReplace(dmFormName.GetFormMessage('2','M00015'),'$NAME','IP',[rfReplaceAll]));
      Exit;
    end;
    if Not isDigit(ed_InsertNodePort.Text) then
    begin
      showmessage(stringReplace(dmFormName.GetFormMessage('2','M00015'),'$NAME','Port',[rfReplaceAll]));
      Exit;
    end;
    if DupCheckTCPIPPort(stNodeNo,ed_InsertNodeIP.Text,ed_InsertNodePort.Text, stDupName) then
    begin
      stMessage := dmFormName.GetFormMessage('2','M00046');
      stMessage := stringReplace(stMessage,'$NAME',stDupName,[rfReplaceAll]);
      showmessage(stMessage);
      Exit;
    end;
    nTCPIPPort := strtoint(ed_InsertNodePort.Text);
  end;

  stSql := ' Insert Into TB_NODE ( ';
  stSql := stSql + 'GROUP_CODE,';
  stSql := stSql + 'ND_NODENO,';
  stSql := stSql + 'ND_TYPE,';
  stSql := stSql + 'ND_COMPORT,';
  stSql := stSql + 'ND_NODEIP,';
  stSql := stSql + 'ND_NODEPORT,';
  stSql := stSql + 'ND_NAME ) ';
  stSql := stSql + 'Values( ';
  stSql := stSql + '''' + G_stGroupCode + ''',';
  stSql := stSql + '' + stNodeNo + ',';
  stSql := stSql + '' + inttostr(cmb_InsertNodeType.ItemIndex) + ',';
  stSql := stSql + '' + inttostr(nComPort) + ',';
  stSql := stSql + '''' + ed_InsertNodeIP.Text + ''', ';
  stSql := stSql + '' + inttostr(nTCPIPPort) + ', ';
  stSql := stSql + '''' + stName + ''') ';

  bResult := dmDataBase.ProcessExecSQL(stSql);
  if bResult then
  begin
    menuTab.ActiveTabIndex := 1;
    menuTabChange(self);
    PageTabCreate(L_nCurrentPageGroup,L_nCurrentPageList);
    ShowNodeList('');
    if (Application.MessageBox(PChar(dmFormName.GetFormMessage('2','M00064')),'Information',MB_YESNO) = IDNO)  then Exit;
    self.FindSubForm('Main').FindCommand('FORMEXEC').Params.Values['FORMNAME'] := inttostr(FORMDOORADMIN);
    self.FindSubForm('Main').FindCommand('FORMEXEC').Params.Values['ACTION'] := 'ADD';
    self.FindSubForm('Main').FindCommand('FORMEXEC').Params.Values['DATA'] := stNodeNo;
    self.FindSubForm('Main').FindCommand('FORMEXEC').Params.Values['NODENAME'] := stName;
    self.FindSubForm('Main').FindCommand('FORMEXEC').Execute;
    L_bNodeChange := True;
  end else
  begin
    showmessage(dmFormName.GetFormMessage('2','M00018'));
  end;



end;

procedure TfmNodeAdmin.btn_SaveClick(Sender: TObject);
begin
  inherited;
  SaveUpdateCell;
end;

procedure TfmNodeAdmin.btn_SearchClick(Sender: TObject);
begin
  L_nCurrentPageList := 1;
  PageTabCreate(0,L_nCurrentPageList);
  ShowNodeList('');
end;

procedure TfmNodeAdmin.btn_UpdateSaveClick(Sender: TObject);
var
  stNodeNo : string;
  stName : string;
  stSql : string;
  bResult : Boolean;
  stDupName : string;
  nComPort : integer;
  nTCPIPPort : integer;
  stMessage : string;
begin
  inherited;
  stName := ed_UpdateName.Text;
  stNodeNo := ed_UpdateNodeNo.Text;
  nComPort := 0;
  nTCPIPPort := 0;

  if stName = '' then
  begin
    showmessage(stringReplace(dmFormName.GetFormMessage('2','M00015'),'$NAME',lb_NodeAdd.Caption.Text,[rfReplaceAll]));
    Exit;
  end;
  if cmb_UpdateNodeType.ItemIndex = 0 then
  begin
    if DupCheckSerialPort(stNodeNo,cmb_UpdateComPort.ItemIndex + 1, stDupName) then
    begin
      stMessage := dmFormName.GetFormMessage('2','M00063');
      stMessage := stringReplace(stMessage,'$NUM ',inttostr(cmb_InsertComPort.ItemIndex + 1),[rfReplaceAll]);
      stMessage := stringReplace(stMessage,'$NAME',stDupName,[rfReplaceAll]);
      showmessage(stMessage);
      Exit;
    end;
    nComPort := cmb_UpdateComPort.ItemIndex + 1;
  end else
  begin
    if ed_UpdateNodeIP.Text = '' then
    begin
      showmessage(stringReplace(dmFormName.GetFormMessage('2','M00015'),'$NAME','IP',[rfReplaceAll]));
      Exit;
    end;
    if Not isDigit(ed_UpdateNodePort.Text) then
    begin
      showmessage(stringReplace(dmFormName.GetFormMessage('2','M00015'),'$NAME','Port',[rfReplaceAll]));
      Exit;
    end;
    if DupCheckTCPIPPort(stNodeNo,ed_UpdateNodeIP.Text,ed_UpdateNodePort.Text, stDupName) then
    begin
      showmessage('해당 IP는 ' + stDupName + '에서 이미 사용중입니다.');
      Exit;
    end;
    nTCPIPPort := strtoint(ed_UpdateNodePort.Text);
  end;


  stSql := ' Update TB_NODE set ';
  stSql := stSql + 'ND_TYPE = ' + inttostr(cmb_UpdateNodeType.ItemIndex) + ',';
  stSql := stSql + 'ND_COMPORT = ' + inttostr(nComPort) + ',';
  stSql := stSql + 'ND_NODEIP = ''' + ed_UpdateNodeIP.Text + ''',';
  stSql := stSql + 'ND_NODEPORT = ' + inttostr(nTCPIPPort) + ',';
  stSql := stSql + 'ND_NAME  = ''' + stName + ''' ';
  stSql := stSql + ' Where GROUP_CODE = ''' + G_stGroupCode + ''' ';
  stSql := stSql + ' AND ND_NODENO = ' + stNodeNo + ' ';

  bResult := dmDataBase.ProcessExecSQL(stSql);
  if bResult then
  begin
    menuTab.ActiveTabIndex := 1;
    menuTabChange(self);
    PageTabCreate(L_nCurrentPageGroup,L_nCurrentPageList);
    ShowNodeList('');
    L_bNodeChange := True;
  end else
  begin
    showmessage(dmFormName.GetFormMessage('2','M00018'));
  end;

end;

procedure TfmNodeAdmin.cmb_InsertNodeTypeChange(Sender: TObject);
begin
  inherited;
  if cmb_InsertNodeType.ItemIndex = 0 then
  begin
    gb_RS232Config.Top := 115;
    gb_RS232Config.Visible := True;
    gb_TCPIPConfig.Visible := False;
  end else
  begin
    gb_TCPIPConfig.Top := 115;
    gb_TCPIPConfig.Visible := True;
    gb_RS232Config.Visible := False;
  end;

end;

procedure TfmNodeAdmin.cmb_UpdateNodeTypeChange(Sender: TObject);
begin
  inherited;
  if cmb_UpdateNodeType.ItemIndex = 0 then
  begin
    gb_UpdateRS232Config.Top := 115;
    gb_UpdateRS232Config.Visible := True;
    gb_UpdateTCPIPConfig.Visible := False;
  end else
  begin
    gb_UpdateTCPIPConfig.Top := 115;
    gb_UpdateTCPIPConfig.Visible := True;
    gb_UpdateRS232Config.Visible := False;
  end;

end;

procedure TfmNodeAdmin.ComPortCreate(cmbBox: TComboBox);
var
  i : integer;
begin
  cmbBox.Items.Clear;
  for i := 1 to G_nMaxComPort do
  begin
    cmbBox.Items.Add('COM' + inttostr(i));
  end;
  cmbBox.ItemIndex := 0;
end;

function TfmNodeAdmin.DeleteTB_NODE(aNodeNo: string):Boolean;
var
  stSql : string;
begin
  stSql := ' Delete from TB_DOOR ';
  stSql := stSql + ' Where GROUP_CODE = ''' + G_stGroupCode + ''' ';
  stSql := stSql + ' AND ND_NODENO = ' + aNodeNo;

  result := dmDataBase.ProcessExecSQL(stSql);

  stSql := ' Delete from TB_DEVICE ';
  stSql := stSql + ' Where GROUP_CODE = ''' + G_stGroupCode + ''' ';
  stSql := stSql + ' AND ND_NODENO = ' + aNodeNo;

  result := dmDataBase.ProcessExecSQL(stSql);

  stSql := ' Delete from TB_NODE ';
  stSql := stSql + ' Where GROUP_CODE = ''' + G_stGroupCode + ''' ';
  stSql := stSql + ' AND ND_NODENO = ' + aNodeNo;

  result := dmDataBase.ProcessExecSQL(stSql);
end;

function TfmNodeAdmin.DupCheckSerialPort(aNodeNo:string;aComport: integer;
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

    stSql := 'Select * from TB_NODE ';
    stSql := stSql + ' Where GROUP_CODE = ''' + G_stGroupCode + ''' ';
    stSql := stSql + ' AND ND_TYPE = 0 ';
    stSql := stSql + ' AND ND_COMPORT = ' + inttostr(aComport) ;
    stSql := stSql + ' AND ND_NODENO <> ' + aNodeNo ;

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
      aDupName := FindField('ND_NAME').AsString;
      result := True;
    end;
  Finally
    TempAdoQuery.Free;
    CoUninitialize;
  End;
end;

function TfmNodeAdmin.DupCheckTCPIPPort(aNodeNo,aNodeIP, aNodePort: string;
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

    stSql := 'Select * from TB_NODE ';
    stSql := stSql + ' Where GROUP_CODE = ''' + G_stGroupCode + ''' ';
    stSql := stSql + ' AND ND_TYPE = 1 ';
    stSql := stSql + ' AND ND_NODEIP = ''' + aNodeIP + ''' ' ;
    stSql := stSql + ' AND ND_NODEPORT = ' + aNodePort + ' ' ;
    stSql := stSql + ' AND ND_NODENO <> ' + aNodeNo ;

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
      aDupName := FindField('ND_NAME').AsString;
      result := True;
    end;
  Finally
    TempAdoQuery.Free;
    CoUninitialize;
  End;
end;

procedure TfmNodeAdmin.ed_NodenameChange(Sender: TObject);
begin
  inherited;
  L_nCurrentPageList := 1;
  PageTabCreate(0,L_nCurrentPageList);
  ShowNodeList('');
end;

procedure TfmNodeAdmin.ed_UpdateNameKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if Key = #13 then
  begin
    btn_UpdateSaveClick(self);
  end;

end;

procedure TfmNodeAdmin.ed_InsertNameKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  if Key = #13 then
  begin
    btn_InsertSaveClick(self);
  end;

end;

procedure TfmNodeAdmin.FontSetting;
begin
  dmFormFontUtil.TravelFormFontSetting(self,G_stFontName,inttostr(G_nFontSize));
  dmFormFontUtil.TravelAdvOfficeTabSetOfficeStylerFontSetting(AdvOfficeTabSetOfficeStyler1, G_stFontName,inttostr(G_nFontSize));
  dmFormFontUtil.FormAdvOfficeTabSetOfficeStylerSetting(AdvOfficeTabSetOfficeStyler1,G_stFormStyle);
  dmFormFontUtil.FormAdvToolBarOfficeStylerSetting(AdvToolBarOfficeStyler1,G_stFormStyle);
  dmFormFontUtil.FormStyleSetting(self,AdvToolBarOfficeStyler1);

end;

procedure TfmNodeAdmin.FormActivate(Sender: TObject);
begin
  inherited;
  FormNameSetting;
end;

procedure TfmNodeAdmin.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if L_bNodeChange then
    self.FindSubForm('Main').FindCommand('DEVICERELOAD').Execute;

  self.FindSubForm('Main').FindCommand('FORMENABLE').Params.Values['NAME'] := inttostr(FORMNODEADMIN);
  self.FindSubForm('Main').FindCommand('FORMENABLE').Params.Values['VALUE'] := 'FALSE';
  self.FindSubForm('Main').FindCommand('FORMENABLE').Execute;

  Action := caFree;
end;

procedure TfmNodeAdmin.FormCreate(Sender: TObject);
begin
  Height := G_nChildFormDefaultHeight;

  L_nPageGroupMaxCount :=5 ; //한페이지 그룹에 해당하는 페이지수
  L_nPageListMaxCount :=16; //한페이지에 출력되는 리스트 갯수
  //L_nPageListMaxCount :=2; //한페이지에 출력되는 리스트 갯수

  menuTab.ActiveTabIndex := 1;
  menuTabChange(self);

  ComPortCreate(TComboBox(cmb_InsertComPort));
  ComPortCreate(TComboBox(cmb_UpdateComPort));
  FontSetting;
end;


procedure TfmNodeAdmin.FormNameSetting;
begin
  Caption := dmFormName.GetFormMessage('1','M00014');
  menuTab.AdvOfficeTabs[0].Caption := dmFormName.GetFormMessage('1','M00035');
  menuTab.AdvOfficeTabs[1].Caption := dmFormName.GetFormMessage('1','M00053');
  menuTab.AdvOfficeTabs[2].Caption := dmFormName.GetFormMessage('1','M00054');
  dongCodeList.Caption.Text := dmFormName.GetFormMessage('1','M00053');
  NodeAdd.Caption.Text := dmFormName.GetFormMessage('1','M00054');
  dongCodeUpdate.Caption.Text := dmFormName.GetFormMessage('1','M00055');
  lb_Nodename.Caption.Text := dmFormName.GetFormMessage('4','M00043');
  btn_Search.Caption := dmFormName.GetFormMessage('4','M00007');
  btn_add.Caption :=  dmFormName.GetFormMessage('4','M00077');
  btn_Delete.Caption :=  dmFormName.GetFormMessage('4','M00078');
  with sg_NodeList do
  begin
    cells[1,0] := dmFormName.GetFormMessage('4','M00043');
    cells[2,0] := dmFormName.GetFormMessage('4','M00066');
    cells[3,0] := dmFormName.GetFormMessage('4','M00067');
    cells[4,0] := dmFormName.GetFormMessage('4','M00068');
    cells[5,0] := dmFormName.GetFormMessage('4','M00069');
    cells[6,0] := dmFormName.GetFormMessage('4','M00036');
    cells[7,0] := dmFormName.GetFormMessage('4','M00070');
    Hint := dmFormName.GetFormMessage('2','M00012');
  end;
  lb_NodeAdd.Caption.Text := dmFormName.GetFormMessage('4','M00043');
  lb_NodeTypeAdd.Caption.Text := dmFormName.GetFormMessage('4','M00070');
  gb_RS232Config.Caption  := dmFormName.GetFormMessage('4','M00071');
  gb_TCPIPConfig.Caption  := dmFormName.GetFormMessage('4','M00072');
  lb_rs232PortAdd.Caption.Text := dmFormName.GetFormMessage('4','M00069');
  lb_NodeIPAdd.Caption.Text := dmFormName.GetFormMessage('4','M00073');
  lb_NodePortAdd.Caption.Text := dmFormName.GetFormMessage('4','M00074');
  btn_InsertSave.Caption := dmFormName.GetFormMessage('4','M00014');
  lb_NodeUpdate.Caption.Text := dmFormName.GetFormMessage('4','M00043');
  lb_NodeTypeUpdate.Caption.Text := dmFormName.GetFormMessage('4','M00070');
  gb_UpdateRS232Config.Caption  := dmFormName.GetFormMessage('4','M00071');
  gb_UpdateTCPIPConfig.Caption  := dmFormName.GetFormMessage('4','M00072');
  lb_rs232PortUpdate.Caption.Text := dmFormName.GetFormMessage('4','M00069');
  lb_NodeIPUpdate.Caption.Text := dmFormName.GetFormMessage('4','M00073');
  lb_NodePortUpdate.Caption.Text := dmFormName.GetFormMessage('4','M00074');
  btn_UpdateSave.Caption := dmFormName.GetFormMessage('4','M00014');
end;

procedure TfmNodeAdmin.FormResize(Sender: TObject);
begin
  BodyPanel.Left := 0;
  BodyPanel.Top := 0;
  BodyPanel.Height := Height - menuTab.Height;

end;

procedure TfmNodeAdmin.FormShow(Sender: TObject);
begin
  top := 0;
  Left := 0;
  Width := BodyPanel.Width;

  L_nCurrentPageGroup := 0;
  PageTabCreate(L_nCurrentPageGroup,1);
  ShowNodeList('');

  self.FindSubForm('Main').FindCommand('FORMENABLE').Params.Values['NAME'] := inttostr(FORMNODEADMIN);
  self.FindSubForm('Main').FindCommand('FORMENABLE').Params.Values['VALUE'] := 'TRUE';
  self.FindSubForm('Main').FindCommand('FORMENABLE').Execute;
end;

procedure TfmNodeAdmin.Form_Close;
begin
  Close;
end;

function TfmNodeAdmin.GetNextNodeNo: string;
var
  nNodeNo : integer;
  stSql : string;
  TempAdoQuery : TADOQuery;
begin
  nNodeNo := 1;
  Try
    CoInitialize(nil);
    TempAdoQuery := TADOQuery.Create(nil);
    TempAdoQuery.Connection := dmDataBase.ADOConnection;

    stSql := 'Select Max(ND_NODENO) as ND_NODENO from TB_NODE ';

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

      nNodeNo := FindField('ND_NODENO').AsInteger + 1;

    end;
  Finally
    result := inttostr(nNodeNo);
    TempAdoQuery.Free;
    CoUninitialize;
  End;
end;

procedure TfmNodeAdmin.lb_page1Click(Sender: TObject);
begin
  inherited;
  Try
    L_nCurrentPageList := TLabel(Sender).tag;
    PageTabCreate(L_nCurrentPageGroup,L_nCurrentPageList);
    ShowNodeList('');
  Except
    Exit;
  End;

end;

procedure TfmNodeAdmin.menuTabChange(Sender: TObject);
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
    dongCodeList.Visible := True;
    NodeAdd.Visible := False;
    dongCodeList.Align := alClient;
    dongCodeUpdate.Visible := False;
  end else if menuTab.ActiveTabIndex = 2 then
  begin
    menuTab.AdvOfficeTabs.Items[0].Caption := dmFormName.GetFormMessage('1','M00040');
    dongCodeList.Visible := False;
    NodeAdd.Visible := True;
    NodeAdd.Align := alClient;
    ed_InsertName.Text := '';
    cmb_InsertNodeTypeChange(self);
    cmb_InsertComPort.ItemIndex := 0;
    ed_InsertNodeIP.Text := '';
    ed_InsertNodePort.Text := '3000';
    dongCodeUpdate.Visible := False;
  end;
end;

procedure TfmNodeAdmin.PageTabCreate(aPageGroup,aCurrentPage: integer);
var
  stSql : string;
  TempAdoQuery : TADOQuery;
  i : integer;
  oLabel : TLabel;
  nCurrentPageStart : integer;
  nCurrentPageNo : integer;
begin

end;

procedure TfmNodeAdmin.SaveUpdateCell;
var
  stParentCode : string;
  stChildCode : string;
  stName : string;
  stSql : string;
  bResult : Boolean;
begin

  with sg_NodeList do
  begin
    stParentCode := cells[3,L_CurrentSaveRow];
    stChildCode := cells[4,L_CurrentSaveRow];
    stName := cells[1,L_CurrentSaveRow];

    if stParentCode = '' then stParentCode := FillZeroNumber(0,G_nBuildingCodeLength);
    if stChildCode = '' then Exit;

    stSql := ' Update TB_BUILDINGCODE set BC_NAME = ''' + stName + ''' ';
    stSql := stSql + ' Where GROUP_CODE = ''' + G_stGroupCode + ''' ';
    stSql := stSql + ' AND BC_PARENTCODE = ''' + stParentCode + ''' ';
    stSql := stSql + ' AND BC_CHILDCODE = ''' + stChildCode + ''' ';

    bResult := dmDataBase.ProcessExecSQL(stSql);

  end;

end;

procedure TfmNodeAdmin.sg_NodeListCheckBoxClick(Sender: TObject; ACol,
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

procedure TfmNodeAdmin.sg_dongCodeColChanging(Sender: TObject; OldCol,
  NewCol: Integer; var Allow: Boolean);
begin
  inherited;
  with sg_NodeList do
  begin
    if NewCol = 0 then Options := Options + [goEditing]
    else Options := Options - [goEditing];
  end;

end;

procedure TfmNodeAdmin.sg_NodeListDblClick(Sender: TObject);
var
  nComPort : integer;
begin
  inherited;
  with sg_NodeList do
  begin
    if  Not isDigit(cells[6,Row]) then Exit;
    ed_UpdateNodeNo.Text := cells[6,Row];
    ed_UpdateName.Text := cells[1,Row];
    if isDigit(cells[7,Row]) then
      cmb_UpdateNodeType.ItemIndex := strtoint(cells[7,Row]);
    cmb_UpdateNodeTypeChange(self);
    cmb_UpdateComPort.ItemIndex := 0;
    if isDigit(cells[5,Row]) then
    begin
      nComPort := strtoint(cells[5,Row]) - 1;
    end;
    if nComPort > 0 then cmb_UpdateComPort.ItemIndex := nComPort;
    ed_UpdateNodeIP.Text := cells[3,Row];
    ed_UpdateNodePort.Text := cells[4,Row];
  end;
  menuTab.AdvOfficeTabs.Items[0].Caption := dmFormName.GetFormMessage('1','M00040');
  dongCodeUpdate.Visible := True;
  dongCodeUpdate.Align := alClient;
  dongCodeList.Visible := False;
  NodeAdd.Visible := False;

  ed_UpdateName.SelectAll;
  ed_UpdateName.SetFocus;

end;

procedure TfmNodeAdmin.sg_NodeListKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  if Key = #13 then
  begin
    L_CurrentSaveRow := sg_NodeList.Row;
    //SaveUpdateCell;
  end;

end;

procedure TfmNodeAdmin.sg_NodeListKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  L_CurrentSaveRow := sg_NodeList.Row;
  if (Key <> VK_RETURN) and
     (Key <> VK_UP) and
     (Key <> VK_DOWN) then UpdateCell;

end;

procedure TfmNodeAdmin.ShowNodeList(aCurrentCode: string; aTopRow: integer);
var
  stSql : string;
  TempAdoQuery : TADOQuery;
  nRow : integer;
begin
  GridInit(sg_NodeList,6,2,true);
  L_nCheckCount := 0;

  stSql := 'SELECT * FROM TB_NODE ';
  stSql := stSql + '  Where GROUP_CODE = ''' + G_stGroupCode + ''' ';
  if ed_Nodename.Text <> '' then
  begin
    stSql := stSql + ' AND ND_NAME Like ''%' + ed_Nodename.Text + '%'' ';
  end;
  stSql := stSql + ' ORDER BY idx  ';

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
      with sg_NodeList do
      begin
        nRow := 1;
        RowCount := RecordCount + 1;
        while Not Eof do
        begin
          AddCheckBox(0,nRow,False,False);
          cells[1,nRow] := FindField('ND_NAME').AsString;
          if FindField('ND_TYPE').AsInteger = 0 then cells[2,nRow] := 'RS232'
          else if FindField('ND_TYPE').AsInteger = 1 then cells[2,nRow] := 'TCPIP';
          cells[3,nRow] := FindField('ND_NODEIP').AsString;
          cells[4,nRow] := FindField('ND_NODEPORT').AsString;
          cells[5,nRow] := FindField('ND_COMPORT').AsString;
          cells[6,nRow] := FindField('ND_NODENO').AsString;
          cells[7,nRow] := FindField('ND_TYPE').AsString;
          if (FindField('ND_NODENO').AsString )  = aCurrentCode then
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

procedure TfmNodeAdmin.btn_addClick(Sender: TObject);
begin
  inherited;
  menutab.ActiveTabIndex := 2;
  menutabChange(self);
end;

procedure TfmNodeAdmin.btn_DeleteClick(Sender: TObject);
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
  if (Application.MessageBox(PChar(stMessage),'Information',MB_OKCANCEL) = IDCANCEL)  then Exit;
  With sg_NodeList do
  begin
    for i := 1 to RowCount - 1 do
    begin
      GetCheckBoxState(0,i, bChkState);
      if bChkState then
      begin
        DeleteTB_NODE(cells[6,i]);
      end;
    end;
  end;
  PageTabCreate(L_nCurrentPageGroup,L_nCurrentPageList);
  ShowNodeList('');
  L_bNodeChange :=True;
end;

procedure TfmNodeAdmin.UpdateCell;
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
  RegisterClass(TfmNodeAdmin);
Finalization
  UnRegisterClass(TfmNodeAdmin);

end.
