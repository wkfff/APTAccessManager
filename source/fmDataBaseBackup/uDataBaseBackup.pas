unit uDataBaseBackup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, StdCtrls,ADODB,ActiveX;

type
  TfmDataBaseBackup = class(TForm)
    Bevel1: TBevel;
    sbSave: TSpeedButton;
    btn_CardBackup: TSpeedButton;
    btn_AccessEventBackup: TSpeedButton;
    SaveDialog1: TSaveDialog;
    procedure sbSaveClick(Sender: TObject);
    procedure btn_CardBackupClick(Sender: TObject);
    procedure btn_AccessEventBackupClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmDataBaseBackup: TfmDataBaseBackup;

implementation

uses
  uDataBase,
  uDBFormName,
  uDBFunction,
  DiMime,
  uCommonVariable,
  uFunction;

{$R *.dfm}

procedure TfmDataBaseBackup.btn_AccessEventBackupClick(Sender: TObject);
begin
  SaveDialog1.FileName := FormatDateTime('yyyymmdd',Now) + '_ACCEVENT.mdb';
  if SaveDialog1.Execute then
  begin
    if FileExists(G_stExeFolder + '/../DB/ACCEVENT.mdb') then
    begin
      CopyFile(pchar(G_stExeFolder + '/../DB/ACCEVENT.mdb'),pchar(SaveDialog1.FileName),True);
      showmessage(btn_AccessEventBackup.Caption + ' Complete');
    end;
  end;
end;

procedure TfmDataBaseBackup.btn_CardBackupClick(Sender: TObject);
begin
  SaveDialog1.FileName := FormatDateTime('yyyymmdd',Now) + '_ACCINFO.mdb';
  if SaveDialog1.Execute then
  begin
    if FileExists(G_stExeFolder + '/../DB/ACCINFO.mdb') then
    begin
      CopyFile(pchar(G_stExeFolder + '/../DB/ACCINFO.mdb'),pchar(SaveDialog1.FileName),True);
      showmessage(btn_CardBackup.Caption + ' Complete');
    end;
  end;
end;

procedure TfmDataBaseBackup.FormCreate(Sender: TObject);
begin
  Caption := dmFormName.GetFormMessage('1','M00026');
  btn_CardBackup.Caption := dmFormName.GetFormMessage('4','M00140');
  btn_AccessEventBackup.Caption := dmFormName.GetFormMessage('4','M00141');
  sbSave.Caption := dmFormName.GetFormMessage('1','M00035');
end;

procedure TfmDataBaseBackup.sbSaveClick(Sender: TObject);
begin
  Close;
end;

end.
