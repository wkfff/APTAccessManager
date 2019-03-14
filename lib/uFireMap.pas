unit uFireMap;

interface
uses
  System.Classes,System.SysUtils,Vcl.Controls,Vcl.StdCtrls,Vcl.Graphics,Winapi.Windows,
  Vcl.ExtCtrls,Vcl.Imaging.GIFImg,Vcl.Menus,Vcl.Forms,AdvSmoothLabel;

type
  TDblClick = procedure(Sender:TObject;Code,Name:string) of object;
  TMouseInOutEvent = procedure(Sender:TObject;Code,Name:string) of object;

  TMapFire = Class(TComponent)
  private
    MouseDowning : Boolean;
    DragOrigin : TPoint;
    procedure ImageDblClick(Sender: TObject);
    procedure ImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImageMouseEnter(Sender: TObject);
    procedure ImageMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ImageMouseLeave(Sender: TObject);
    procedure ImageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    FireImage : TImage;
    FireText: TEdit;
    FireLabel: TAdvSmoothLabel;
    FParent: TWinControl;
    FImageFile: string;
    FLeft: integer;
    FTop: integer;
    FStretch: Boolean;
    FMapVisible: Boolean;
    FCurX: integer;
    FCurY: integer;
    FTotW: integer;
    FTotH: integer;
    FParentImageHeight: integer;
    FParentImageWidth: integer;
    FDragOn: Boolean;
    FDblClickOn: Boolean;
    FOnMouseEnter: TMouseInOutEvent;
    FOnDblClick: TDblClick;
    FOnMouseLeave: TMouseInOutEvent;
    FName: string;
    FCode: string;
    FNameFontColor: TColor;
    FEnterOnText: Boolean;
    FHeight: integer;
    FWidth: integer;
    FNameVisible: Boolean;
    FNameEditWidth: integer;
    FNameFontSize: integer;
    FNameEditHeight: integer;
    procedure SetParent(const Value: TWinControl);
    procedure SetImageFile(const Value: string);
    procedure SetLeft(const Value: integer);
    procedure SetTop(const Value: integer);
    procedure SetStretch(const Value: Boolean);
    procedure SetMapVisible(const Value: Boolean);
    procedure SetNameFontColor(const Value: TColor);
    procedure SetName(const Value: string);
    procedure SetHeight(const Value: integer);
    procedure SetWidth(const Value: integer);
    procedure SetNameVisible(const Value: Boolean);
    procedure SetNameEditHeight(const Value: integer);
    procedure SetNameEditWidth(const Value: integer);
    procedure SetNameFontSize(const Value: integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  public
    property Code : string read FCode write FCode;
    property Name : string read FName write SetName;
  public
    property CurX: integer read FCurX write FCurX;
    property CurY: integer read FCurY write FCurY;
    property DragOn : Boolean read FDragOn write FDragOn;
    property DblClickOn : Boolean read FDblClickOn write FDblClickOn;
    property EnterOnText : Boolean read FEnterOnText write FEnterOnText;
    property Height: integer read FHeight write SetHeight;
    property ImageFile : string read FImageFile write SetImageFile;
    property Left: integer read FLeft write SetLeft;
    property MapVisible : Boolean read FMapVisible write SetMapVisible;
    property NameEditHeight : integer read FNameEditHeight write SetNameEditHeight;
    property NameEditWidth : integer read FNameEditWidth write SetNameEditWidth;
    property NameFontColor : TColor read FNameFontColor write SetNameFontColor;
    property NameFontSize : integer read FNameFontSize write SetNameFontSize;
    property NameVisible : Boolean read FNameVisible write SetNameVisible;
    property Parent: TWinControl read FParent write SetParent;
    property ParentImageHeight: integer read FParentImageHeight write FParentImageHeight;
    property ParentImageWidth: integer read FParentImageWidth write FParentImageWidth;
    property Stretch:Boolean read FStretch write SetStretch;
    property Top: integer read FTop write SetTop;
    property TotH: integer read FTotH write FTotH;
    property TotW: integer read FTotW write FTotW;
    property Width: integer read FWidth write SetWidth;
  public
    property OnDblClick : TDblClick read FOnDblClick write FOnDblClick;
    property OnMouseEnter : TMouseInOutEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave : TMouseInOutEvent read FOnMouseLeave write FOnMouseLeave;
  End;
implementation

{ TMapBuilding }

constructor TMapFire.Create(AOwner: TComponent);
begin
  inherited;
  DblClickOn := True;
  DragOn := True;
  FireImage := TImage.Create(nil);
  FireImage.Visible := True;
  FireImage.Width := 25;
  FireImage.Height := 25;
  FireImage.ShowHint := True;
  FireImage.OnDblClick := ImageDblClick;
  FireImage.OnMouseDown := ImageMouseDown;
  FireImage.OnMouseEnter := ImageMouseEnter;
  FireImage.OnMouseMove := ImageMouseMove;
  FireImage.OnMouseLeave := ImageMouseLeave;
  FireImage.OnMouseUp := ImageMouseUp;
  FireText:= TEdit.Create(nil);
  FireText.Alignment := taCenter;
  FireText.AutoSize := False;
  FireText.Width := 100;
  FireText.Height := 25;
  FireText.BevelKind := bkFlat;
  FireText.BevelInner := bvNone;
  FireText.BevelOuter := bvNone;
  FireText.BorderStyle := bsNone;
  //FireText.Color := clYellow;
  FireText.Visible := False;
  FireText.ReadOnly := True;
  FireText.Enabled := True;
  FireText.Font.Size := 9;
  FireText.Font.Style := FireText.Font.Style + [fsBold];
  FireText.Font.Name := '���� ����';
  NameFontColor := clBlack;

  FireLabel:= TAdvSmoothLabel.Create(nil);
  FireLabel.Align := alNone;
  FireLabel.AutoSize := False;
  FireLabel.Width := 200;
  FireLabel.Height := 25;
  FireLabel.Visible := True;
  FireLabel.Caption.ColorStart := clBlack;
  FireLabel.Caption.ColorEnd := clBlack;
  FireLabel.Caption.Font.Color := clBlack;
  FireLabel.Caption.Font.Size := 9;
  FireLabel.Caption.Font.Style := FireLabel.Caption.Font.Style + [fsBold];
  FireLabel.Caption.Font.Name := '���� ����';
  //MapVisible := True;
  EnterOnText := False;

  Left := 0;
  Top := 0;
end;

destructor TMapFire.Destroy;
begin
  FireImage.Free;
  FireText.Free;
  FireLabel.Free;
  inherited;
end;

procedure TMapFire.ImageDblClick(Sender: TObject);
begin
  if Not DblClickOn then Exit;
  if Assigned(FOnDblClick) then
  begin
    OnDblClick(self,Code,Name);
  end;

end;

procedure TMapFire.ImageMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Not DragOn then Exit;
  if (Button = mbLeft) and (MouseDowning = False) then
  begin
    //DRAG Point ����
    DragOrigin := Point(X,Y);
    // Mouse Down = True ����
    MouseDowning := True;
  end;

end;

procedure TMapFire.ImageMouseEnter(Sender: TObject);
begin

  if Assigned(FOnMouseEnter) then
  begin
    OnMouseEnter(self,Code,Name);
  end;

end;

procedure TMapFire.ImageMouseLeave(Sender: TObject);
begin
  if Assigned(FOnMouseLeave) then
  begin
    OnMouseLeave(self,Code,Name);
  end;

end;

procedure TMapFire.ImageMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if Not DragOn then Exit;
  // MOUSE DOWN = TRUE CHECK
  if (MouseDowning = True) then
  begin
    if ((Sender as TImage).Top + (Sender as TImage).Height) >= ParentImageHeight then
    begin
      self.Top := ParentImageHeight - (Sender as TImage).Height - 1;
    end
    else if ((Sender as TImage).Left + (Sender as TImage).Width) >= ParentImageWidth then
    begin
      self.Left := ParentImageWidth - (Sender as TImage).Width - 1;
    end
    else
    begin
      // IMAGE TOP ��ġ ����
      self.Top := (Sender as TImage).Top + Y - DragOrigin.Y;
      // IMAGE LEFT ��ġ ����
      self.Left := (Sender as TImage).Left + X - DragOrigin.X;
    end;
    Left := self.Left;
    Top := self.Top;
  end;

end;

procedure TMapFire.ImageMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Not DragOn then Exit;
    // MOUSE DOWN = FALSE ����
    MouseDowning := False;

end;

procedure TMapFire.SetHeight(const Value: integer);
begin
  FHeight := Value;
  FireImage.Height := Value;
  FireText.Top := FireImage.Top + Value + 2;
  FireLabel.Top := FireImage.Top + Value + 2;
end;

procedure TMapFire.SetImageFile(const Value: string);
begin
  FImageFile := Value;
  if Not FileExists(Value) then FireImage.Picture := nil
  else
    FireImage.Picture.LoadFromFile(Value);
end;

procedure TMapFire.SetLeft(const Value: integer);
begin
  FLeft := Value;
  FireImage.Left := Value;
  FireText.Left := Value - ((FireText.Width - FireImage.Width) div 2)  ;
  FireLabel.Left := Value - ((FireLabel.Width - FireImage.Width) div 2)  ;
end;

procedure TMapFire.SetMapVisible(const Value: Boolean);
begin
  FMapVisible := Value;
  FireImage.Visible := Value;
  FireLabel.Visible := Value;
end;

procedure TMapFire.SetName(const Value: string);
begin
  FName := Value;
  FireImage.Hint := Value;
  FireText.Text := Value;
  FireLabel.Caption.Text := Value;
end;

procedure TMapFire.SetNameEditHeight(const Value: integer);
begin
  FNameEditHeight := Value;
  FireText.Height := Value;
  FireLabel.Height := Value;
end;

procedure TMapFire.SetNameEditWidth(const Value: integer);
begin
  FNameEditWidth := Value;
  FireText.Width := Value;
  FireLabel.Width := Value;
end;

procedure TMapFire.SetNameFontColor(const Value: TColor);
begin
  FNameFontColor := Value;
  FireText.Font.Color := Value;
//  FireLabel.Font.Color := Value;
end;

procedure TMapFire.SetNameFontSize(const Value: integer);
begin
  FNameFontSize := Value;
  FireText.Font.Size := Value;
  FireLabel.Caption.Font.Size := Value;
end;

procedure TMapFire.SetNameVisible(const Value: Boolean);
begin
  FNameVisible := Value;
  //FireText.Visible := Value;
  FireLabel.Visible := Value;
end;

procedure TMapFire.SetParent(const Value: TWinControl);
begin
  if FParent = Value then Exit;
  FParent := Value;
  FireImage.Parent := Value;
  FireText.Parent := Value;
  FireLabel.Parent := Value;
end;

procedure TMapFire.SetStretch(const Value: Boolean);
begin
  FStretch := Value;
  FireImage.Stretch := Value;
end;

procedure TMapFire.SetTop(const Value: integer);
begin
  FTop := Value;
  FireImage.Top := Value;
  FireText.Top := Value + FireImage.Height + 5;
  FireLabel.Top := Value + FireImage.Height + 5;
end;

procedure TMapFire.SetWidth(const Value: integer);
begin
  FWidth := Value;
  FireImage.Width := Value;
  FireText.Left := FireImage.Left - ((FireText.Width - FireImage.Width) div 2)  ;
  FireLabel.Left := FireImage.Left - ((FireText.Width - FireImage.Width) div 2)  ;
end;

end.
