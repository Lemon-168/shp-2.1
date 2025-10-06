unit FormPreview;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Buttons, StdCtrls, ComCtrls, shp_file,shp_engine,palette,Shp_Engine_Image;

type
  TFrmPreview = class(TForm)
    ControlPanel: TPanel;
    ImagePanel: TPanel;
    Image1: TImage;
    TrackBar1: TTrackBar;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    AnimationTimer: TTimer;
    Loop: TCheckBox;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TrackBar1Change(Sender: TObject);
    procedure AnimationTimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPreview: TFrmPreview;

implementation

uses FormMain;

{$R *.dfm}

procedure TFrmPreview.SpeedButton1Click(Sender: TObject);
begin
AnimationTimer.Enabled := true;
end;

procedure TFrmPreview.SpeedButton3Click(Sender: TObject);
begin
AnimationTimer.Enabled := not AnimationTimer.Enabled;
end;

procedure TFrmPreview.SpeedButton2Click(Sender: TObject);
begin
AnimationTimer.Enabled := false;
TrackBar1.Position := 1;
TrackBar1Change(Sender);
end;

procedure TFrmPreview.FormClose(Sender: TObject; var Action: TCloseAction);
begin
SpeedButton2Click(Sender);
end;

procedure TFrmPreview.TrackBar1Change(Sender: TObject);
begin
if not FrmMain.isEditable then exit;
if TrackBar1.Position < FrmMain.SHP.Header.NumImages then
begin
if FrmMain.Shadowmode then
DrawFrameImageWithShadow(FrmMain.SHP,TrackBar1.Position,1,false,SHPPalette,Image1)
else
DrawFrameImage(FrmMain.SHP,TrackBar1.Position,1,true,false,SHPPalette,image1);

ImagePanel.Color := SHPPalette[0];
Label1.Caption := 'Frame: ' + inttostr(TrackBar1.Position);
Label2.Caption := 'Total Frames: ' + inttostr(TrackBar1.Max);
Label3.Caption := 'Compression: ' + inttostr(FrmMain.SHP.Data[TrackBar1.Position].Header_Image.compression);

end;
end;

procedure TFrmPreview.AnimationTimerTimer(Sender: TObject);
var
Max : integer;
begin

if FrmMain.Shadowmode then
Max := FrmMain.SHP.Header.NumImages div 2
else
Max := FrmMain.SHP.Header.NumImages;

if TrackBar1.Position +1 <= Max then
TrackBar1.Position := TrackBar1.Position +1
else
if Loop.Checked then
begin
SpeedButton2Click(Sender);
SpeedButton1Click(Sender);
end
else
SpeedButton2Click(Sender);
end;

procedure TFrmPreview.FormCreate(Sender: TObject);
begin
ImagePanel.DoubleBuffered := true;
end;

end.
