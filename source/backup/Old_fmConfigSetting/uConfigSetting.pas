﻿unit uConfigSetting;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, W7Classes, W7Panels, AdvOfficeTabSet,
  AdvOfficeTabSetStylers, AdvSmoothPanel, Vcl.ExtCtrls, AdvSmoothLabel,
  Vcl.StdCtrls, AdvEdit, Vcl.Buttons, Vcl.Grids, AdvObj, BaseGrid, AdvGrid,
  AdvToolBtn,ADODB,ActiveX, uSubForm, CommandArray,Winapi.WinSpool,System.iniFiles;

type
  TfmConfigSetting = class(TfmASubForm)
    AdvOfficeTabSetOfficeStyler1: TAdvOfficeTabSetOfficeStyler;
    Image1: TImage;
    BodyPanel: TW7Panel;
    menuTab: TAdvOfficeTabSet;
    dongCodeList: TAdvSmoothPanel;
    lb_RegPort: TAdvSmoothLabel;
    cmb_ComPort: TComboBox;
    btn_CardRegistportSave: TSpeedButton;
    procedure menuTabChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btn_addClick(Sender: TObject);
    procedure btn_CardRegistportSaveClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    procedure ComportRefresh;
    procedure FormNameSetting;
  private
    EmpTypeCodeList : TStringList;
    ComPortList : TStringList;
    { Private declarations }
    function GetSerialPortList(List : TStringList; const doOpenTest : Boolean = True) : LongWord;
    function EncodeCommportName(PortNum : WORD) : String;
    function DecodeCommportName(PortName : String) : WORD;
  public
    { Public declarations }
    procedure Form_Close;
  end;

var
  fmConfigSetting: TfmConfigSetting;

implementation
uses
  uCommonVariable,
  uDataBase,
  uDBFormName,
  uFormUtil,
  uFunction,
  uMessage;

{$R *.dfm}


procedure TfmConfigSetting.btn_CardRegistportSaveClick(Sender: TObject);
var
  ini_fun : TiniFile;
begin
  inherited;
  Try
    ini_fun := TiniFile.Create(G_stExeFolder + '\Config.ini');
    if cmb_ComPort.ItemIndex = 0 then G_nCardRegisterPort := 0
    else
      G_nCardRegisterPort := Integer(ComPortList.Objects[cmb_ComPort.ItemIndex - 1]);
    ini_fun.WriteInteger('FORM','CardRegisterPort',G_nCardRegisterPort);
  Finally
    ini_fun.Free;
  End;
  self.FindSubForm('Main').FindCommand('ACTION').Params.Values['VALUE'] := 'CRADREGISTERPORTREFRESH';
  self.FindSubForm('Main').FindCommand('ACTION').Execute;
  showmessage('설정되었습니다.');
end;

procedure TfmConfigSetting.ComportRefresh;
var
  nCount : integer;
  i : integer;
begin
  nCount := GetSerialPortList(ComPortList,False);
  cmb_ComPort.Clear;
  cmb_ComPort.Items.add('사용안함');
  cmb_ComPort.ItemIndex := -1;
  if nCount = 0 then
  begin
    Exit;
  end;

  for i:= 0 to nCount - 1 do
  begin
    cmb_ComPort.items.Add(ComPortList.Strings[i])
  end;
  cmb_ComPort.ItemIndex := 0;

end;

function TfmConfigSetting.DecodeCommportName(PortName: String): WORD;
var
 Pt : Integer;
begin
 PortName := UpperCase(PortName);
 if (Copy(PortName, 1, 3) = 'COM') then begin
    Delete(PortName, 1, 3);
    Pt := Pos(':', PortName);
    if Pt = 0 then Result := 0
       else Result := StrToInt(Copy(PortName, 1, Pt-1));
 end
 else if (Copy(PortName, 1, 7) = '\\.\COM') then begin
    Delete(PortName, 1, 7);
    Result := StrToInt(PortName);
 end
 else Result := 0;

end;

function TfmConfigSetting.EncodeCommportName(PortNum: WORD): String;
begin
 if PortNum < 10
    then Result := 'COM' + IntToStr(PortNum) + ':'
    else Result := '\\.\COM'+IntToStr(PortNum);

end;

procedure TfmConfigSetting.FormActivate(Sender: TObject);
begin
  inherited;
  FormNameSetting;
end;

procedure TfmConfigSetting.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  self.FindSubForm('Main').FindCommand('FORMENABLE').Params.Values['NAME'] := inttostr(FORMCONFIGSETTING);
  self.FindSubForm('Main').FindCommand('FORMENABLE').Params.Values['VALUE'] := 'FALSE';
  self.FindSubForm('Main').FindCommand('FORMENABLE').Execute;

  EmpTypeCodeList.Free;
  ComPortList.Free;
  Action := caFree;
end;

procedure TfmConfigSetting.FormCreate(Sender: TObject);
begin
  Height := G_nChildFormDefaultHeight;
  EmpTypeCodeList := TStringList.Create;
  ComPortList := TStringList.Create;

  menuTab.ActiveTabIndex := 1;
  menuTabChange(self);

  ComportRefresh;
end;


procedure TfmConfigSetting.FormNameSetting;
begin
  Caption := dmFormName.GetFormMessage('1','M00025');
  menuTab.AdvOfficeTabs[0].Caption := dmFormName.GetFormMessage('1','M00035');
  menuTab.AdvOfficeTabs[1].Caption := dmFormName.GetFormMessage('1','M00047');
  dongCodeList.Caption.Text := dmFormName.GetFormMessage('1','M00047');

  lb_RegPort.Caption.Text := dmFormName.GetFormMessage('4','M00023');
  btn_CardRegistportSave.Caption :=  dmFormName.GetFormMessage('4','M00014');

end;

procedure TfmConfigSetting.FormResize(Sender: TObject);
begin
  BodyPanel.Left := 0;
  BodyPanel.Top := 0;
  BodyPanel.Height := Height - menuTab.Height;

end;

procedure TfmConfigSetting.FormShow(Sender: TObject);
var
  stComPort : string;
  nIndex : integer;
begin
  top := 0;
  Left := 0;
  Width := BodyPanel.Width;

  if G_nCardRegisterPort > 0 then
  begin
    stComPort := EncodeCommportName(G_nCardRegisterPort);
    nIndex := cmb_ComPort.Items.IndexOf(stComPort);
    if nIndex > -1 then cmb_ComPort.ItemIndex := nIndex;
  end else
    cmb_ComPort.ItemIndex := 0;

  self.FindSubForm('Main').FindCommand('FORMENABLE').Params.Values['NAME'] := inttostr(FORMCONFIGSETTING);
  self.FindSubForm('Main').FindCommand('FORMENABLE').Params.Values['VALUE'] := 'TRUE';
  self.FindSubForm('Main').FindCommand('FORMENABLE').Execute;

end;

procedure TfmConfigSetting.Form_Close;
begin
  Close;
end;

function TfmConfigSetting.GetSerialPortList(List: TStringList;
  const doOpenTest: Boolean): LongWord;
type
 TArrayPORT_INFO_1 = array[0..0] Of PORT_INFO_1;
 PArrayPORT_INFO_1 = ^TArrayPORT_INFO_1;
var
{$IF USE_ENUMPORTS_API}
 PL : PArrayPORT_INFO_1;
 TotalSize, ReturnCount : LongWord;
 Buf : String;
 CommNum : WORD;
{$IFEND}
 I : LongWord;
 CHandle : THandle;
begin
 List.Clear;
{$IF USE_ENUMPORTS_API}
 EnumPorts(nil, 1, nil, 0, TotalSize, ReturnCount);
 if TotalSize < 1 then begin
    Result := 0;
    Exit;
    end;
 GetMem(PL, TotalSize);
 EnumPorts(nil, 1, PL, TotalSize, TotalSize, Result);

 if Result < 1 then begin
    FreeMem(PL);
    Exit;
    end;

 for I:=0 to Result-1 do begin
    Buf := UpperCase(PL^[I].pName);
    CommNum := DecodeCommportName(PL^[I].pName);
    if CommNum = 0 then Continue;
    List.AddObject(EncodeCommportName(CommNum), Pointer(CommNum));
    end;
{$ELSE}
 for I:=1 to G_nMaxComPort do List.AddObject(EncodeCommportName(I), Pointer(I));
{$IFEND}
 // Open Test
 if List.Count > 0 then
   for I := List.Count-1 downto 0 do
   begin
      CHandle := CreateFile(PChar(List[I]), GENERIC_WRITE or GENERIC_READ,
        0, nil, OPEN_EXISTING,
        FILE_ATTRIBUTE_NORMAL,
        0);
      if CHandle = INVALID_HANDLE_VALUE then
      begin
        if doOpenTest or (GetLastError() <> ERROR_ACCESS_DENIED) then
            List.Delete(I);
        Continue;
      end;
      CloseHandle(CHandle);
   end;

 Result := List.Count;
{$IF USE_ENUMPORTS_API}
 if Assigned(PL) then FreeMem(PL);
{$IFEND}

end;

procedure TfmConfigSetting.menuTabChange(Sender: TObject);
begin
  if menuTab.ActiveTabIndex = 0 then //Ȩ
  begin
    if menuTab.AdvOfficeTabs.Items[0].Caption = '닫기' then Close
    else
    begin
      menuTab.ActiveTabIndex := 1;
      menuTabChange(self);
    end;
  end else if menuTab.ActiveTabIndex = 1 then
  begin
    menuTab.AdvOfficeTabs.Items[0].Caption := '닫기';
    dongCodeList.Visible := True;
    dongCodeList.Align := alClient;
  end;
end;


procedure TfmConfigSetting.btn_addClick(Sender: TObject);
begin
  inherited;
  menutab.ActiveTabIndex := 2;
  menutabChange(self);
end;


initialization
  RegisterClass(TfmConfigSetting);
Finalization
  UnRegisterClass(TfmConfigSetting);

end.
