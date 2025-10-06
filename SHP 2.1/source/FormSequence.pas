unit FormSequence;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Menus, Spin, shp_file,Shp_Engine,Shp_Engine_Image, palette,
  ExtDlgs;

type
Tanimtype = record
        StartFrame, Count,Count2 : cardinal;
        special : string;
end;

Tanims = record
        Ready,Guard,Walk,Idle1,Idle2,Prone,Crawl,Die1,Die2,Die3,Die4,Die5,
        FireUp,FireProne,Down,Up,Deploy,Deployed,DeployedFire,Undeploy,
        Cheer,Panic,Paradrop,Fly,Hover,Tumble,FireFly : Tanimtype;
end;

type
PAnimType = ^Tanimtype;
  TFrmSequence = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    ScrollBox1: TScrollBox;
    Frame_Image_List: TImage;
    ScrollBox2: TScrollBox;
    Sequence_Image: TImage;
    Panel4: TPanel;
    Panel5: TPanel;
    SaveSequence1: TMenuItem;
    SaveSequencePictureDialog: TSavePictureDialog;
    SaveFrameListAsBMP1: TMenuItem;
    N1: TMenuItem;
    StatusBar1: TStatusBar;
    Panel6: TPanel;
    lblTools: TLabel;
    Panel7: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    ComboBoxEx1: TComboBoxEx;
    From_Frame: TSpinEdit;
    To_Frame: TSpinEdit;
    Button1: TButton;
    INI_Code: TRichEdit;
    Reset1: TMenuItem;
    N2: TMenuItem;
    Refresh_Timer: TTimer;
    PopupMenu1: TPopupMenu;
    Copy1: TMenuItem;
    Sequence1: TMenuItem;
    FrameList1: TMenuItem;
    Preview1: TMenuItem;
    SequenceTimer: TTimer;
    procedure ComboBoxEx1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure From_FrameChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SaveSequence1Click(Sender: TObject);
    procedure SaveFrameListAsBMP1Click(Sender: TObject);
    procedure Reset1Click(Sender: TObject);
    procedure Refresh_TimerTimer(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure Preview1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SequenceTimerTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Animations : Tanims;
    Current_Animation :PAnimType;
    SequenceFrame : integer;
    procedure BuildINI_Code;
    procedure BuildINI_Code_addLine(Name : string; StartFrame,Count,Count2 : integer; Special : String);
    procedure checkforanim(var anim : tanimtype; const num : integer);
    procedure setanim(var anim : tanimtype; const start,count,count2 : integer; special : string);
    procedure setanim2(start,count,count2 : integer);
    procedure GetSequence(Var Image : TImage; Const SHP:TSHP; StartFrame,EndFrame : Integer);
    function WorkOutEndFrame : integer;

  end;

var
  FrmSequence: TFrmSequence;

implementation

uses FormMain;

{$R *.dfm}

procedure TFrmSequence.checkforanim(var anim : tanimtype; const num : integer);
var
faces : cardinal;
begin

if ComboBoxEx1.ItemIndex = num then
begin
From_Frame.Value := anim.StartFrame;

if (anim.count2 = 0) or (anim.count2 = 1) then
faces := 1
else
if anim.count2 = 6 then
faces := anim.count2 + 2
else
faces := anim.count2;
To_Frame.Value := From_Frame.Value+((anim.Count)*faces)-1;

Current_Animation := @Anim;
end;

end;

procedure TFrmSequence.setanim(var anim : tanimtype; const start,count,count2 : integer; special : string);
begin
anim.StartFrame := start;
anim.count := count;
anim.count2 := count2;
anim.special := special;
end;

procedure TFrmSequence.setanim2(start,count,count2 : integer);
begin
Current_Animation.StartFrame := start;
Current_Animation.count := count;
Current_Animation.count2 := count2;
end;

procedure TFrmSequence.ComboBoxEx1Change(Sender: TObject);
begin
SequenceFrame := 0;

checkforanim(Animations.Ready,0);
checkforanim(Animations.Guard,1);
checkforanim(Animations.Prone,2);
checkforanim(Animations.Down,3);
checkforanim(Animations.Crawl,4);
checkforanim(Animations.Walk,5);
checkforanim(Animations.Up,6);
checkforanim(Animations.Idle1,7);
checkforanim(Animations.Idle2,8);
checkforanim(Animations.Die1,9);
checkforanim(Animations.Die2,10);
checkforanim(Animations.Die3,11);
checkforanim(Animations.Die4,12);
checkforanim(Animations.Die5,13);
checkforanim(Animations.FireUp,14);
checkforanim(Animations.FireProne,15);
checkforanim(Animations.Paradrop,16);
checkforanim(Animations.Cheer,17);
checkforanim(Animations.Panic,18);
checkforanim(Animations.Deployed,19);
checkforanim(Animations.DeployedFire,20);
checkforanim(Animations.Undeploy,21);

checkforanim(Animations.Fly,22);
checkforanim(Animations.Hover,23);
checkforanim(Animations.Tumble,24);
checkforanim(Animations.FireFly,25);


if NOT FrmMain.isEditable then exit;
if WorkOutEndFrame > FrmMain.SHP.Header.NumImages-1 then
messagebox(0,'Error: Not enough frames for sequence','Frame Error',0)
else
if not Preview1.Checked then
GetSequence(Sequence_Image,FrmMain.SHP,Current_Animation.StartFrame,WorkOutEndFrame);

SequenceFrame := Current_Animation.StartFrame;
end;

function TFrmSequence.WorkOutEndFrame : integer;
var
faces : cardinal;
begin

if (Current_Animation.count2 = 0) or (Current_Animation.count2 = 1) then
faces := 1
else
if Current_Animation.count2 = 6 then
faces := Current_Animation.count2 + 2
else
faces := Current_Animation.count2;

result := Current_Animation.StartFrame+((Current_Animation.Count)*faces)-1;
end;

procedure TFrmSequence.FormCreate(Sender: TObject);
begin
// Defult Count2 and special came from [CIvanSequence] in RA2's art.ini
setanim(Animations.Ready,0,1,1,'');
setanim(Animations.Guard,0,1,1,'');
setanim(Animations.Prone,0,1,6,'');
setanim(Animations.Down,0,1,2,'');
setanim(Animations.Crawl,0,1,6,'');
setanim(Animations.Walk,0,1,6,'');
setanim(Animations.Up,0,1,2,'');
setanim(Animations.Idle1,0,1,0,',W');
setanim(Animations.Idle2,0,1,0,',E');
setanim(Animations.Die1,0,1,0,'');
setanim(Animations.Die2,0,1,0,'');
setanim(Animations.Die3,0,1,0,'');
setanim(Animations.Die4,0,1,0,'');
setanim(Animations.Die5,0,1,0,'');
setanim(Animations.FireUp,0,1,6,'');
setanim(Animations.FireProne,0,1,6,'');
setanim(Animations.Paradrop,0,1,1,'');
setanim(Animations.Cheer,0,1,0,',SE');
setanim(Animations.Panic,0,1,6,'');
setanim(Animations.Deployed,0,1,0,'');
setanim(Animations.DeployedFire,0,1,0,'');
setanim(Animations.Undeploy,0,1,0,'');

setanim(Animations.Fly,0,1,6,'');
setanim(Animations.Hover,0,1,6,'');
setanim(Animations.Tumble,0,1,0,'');
setanim(Animations.FireFly,0,1,6,'');

ComboBoxEx1.ItemIndex := 0;

ScrollBox1.DoubleBuffered := true;
ScrollBox2.DoubleBuffered := true;
end;

procedure TFrmSequence.Button1Click(Sender: TObject);
var
frames: cardinal;
begin

if (Current_Animation.Count2 = 1) or (Current_Animation.Count2 = 0) then
frames := 1
else
if Current_Animation.Count2 = 6 then
frames := Current_Animation.Count2+2
else
frames := Current_Animation.Count2;

setanim2(From_Frame.Value,((To_Frame.Value-From_Frame.Value+1) div frames),Current_Animation.Count2);
ComboBoxEx1Change(Sender); // Make it update
BuildINI_Code; // Update INI Code
end;

procedure TFrmSequence.From_FrameChange(Sender: TObject);
begin
To_Frame.MinValue := From_Frame.Value;
To_Frame.Value := To_Frame.Value; // Makes it update its self and check the value is in the range.
end;

procedure TFrmSequence.FormShow(Sender: TObject);
begin
// Set max values
To_Frame.MaxValue := FrmMain.SHP.Header.NumImages-1;
From_Frame.MaxValue := To_Frame.MaxValue;

Refresh_Timer.Enabled := true;

if Preview1.Checked then
SequenceTimer.Enabled := true;
SequenceFrame := 0;
end;

procedure TFrmSequence.GetSequence(Var Image : TImage; Const SHP:TSHP; StartFrame,EndFrame : Integer);
var
c,cc,x,y,cw,TextHeight : integer;
Line : PRGB32Array;
begin

Image.Picture.Bitmap.PixelFormat := pf32bit;

TextHeight := 10 + Image.Picture.Bitmap.Canvas.TextHeight('TEST'); // note this means it works with any font the user uses as the defult system font
Image.Picture.Bitmap.Canvas.Font.Color := clDefault; // Defult colour....


Image.Picture.Bitmap.Canvas.Brush.Color := clBtnFace;
Image.Picture.Bitmap.Width := 0;
Image.Picture.Bitmap.Height := 0; // When we reset the height and width, technicaly the backgrounf should b in clbtnface....
Image.Picture.Bitmap.Width := 3; // Starting Width
Image.Picture.Bitmap.Height := SHP.Header.Height+TextHeight;  // Set Height

CompressFrameImages(FrmMain.SHP); // Data gets compressed, should speed this up using the compressed data


for c := StartFrame+1 to EndFrame +1 do
begin
StatusBar1.Panels[0].Text := 'Drawing '+inttostr(c-1) +' Of ' + inttostr(EndFrame);
StatusBar1.Refresh;

Image.Picture.Bitmap.Canvas.Brush.Color := clBtnFace;

cw := Image.Picture.Bitmap.Width;
Image.Picture.Bitmap.Width := Image.Picture.Bitmap.Width + SHP.Header.Width+3;
Image.Picture.Bitmap.Canvas.TextOut(CW+(SHP.Header.Width div 2)-(Image.Picture.Bitmap.Canvas.TextWidth(Inttostr(C-1)) div 2),5,inttostr(c-1));

Image.Picture.Bitmap.Canvas.Brush.Color := SHPPalette[0];
Image.Picture.Bitmap.Canvas.FillRect(rect(cw,TextHeight,cw+SHP.Header.Width-1,TextHeight +SHP.Header.Height-1));

cc := -1;
for y := 0 to SHP.Data[c].Header_Image.cy-1 do
begin
Line := Image.Picture.Bitmap.Scanline[TextHeight+SHP.Data[c].Header_Image.y+y];
for x := 0 to SHP.Data[c].Header_Image.cx-1 do
begin
inc(cc);
if SHP.Data[c].Databuffer[cc] <> 0 then //Image.Picture.Bitmap.Canvas.Pixels[cw+SHP.Data[c].Header_Image.x+x,TextHeight+SHP.Data[c].Header_Image.y+y] := SHPPalette[SHP.Data[c].Databuffer[cc]];
Line[cw+SHP.Data[c].Header_Image.x+x] := ColourToTRGB32(SHPPalette[SHP.Data[c].Databuffer[cc]])
end;
end;

end;

StatusBar1.Panels[0].Text := '';

end;

procedure TFrmSequence.SaveSequence1Click(Sender: TObject);
begin
if SaveSequencePictureDialog.Execute then
SaveImageFileFromBMP(SaveSequencePictureDialog.FileName,Sequence_Image.Picture.Bitmap);
end;

procedure TFrmSequence.SaveFrameListAsBMP1Click(Sender: TObject);
begin
if SaveSequencePictureDialog.Execute then
SaveImageFileFromBMP(SaveSequencePictureDialog.FileName,Frame_Image_List.Picture.Bitmap);

end;

procedure TFrmSequence.BuildINI_Code_addLine(Name : string; StartFrame,Count,Count2 : integer; Special : String);
begin
INI_Code.lines.Add(Name + ' ' + inttostr(StartFrame)+ ',' +inttostr(Count)+ ',' +inttostr(Count2) + Special);
end;

procedure TFrmSequence.BuildINI_Code;
begin
INI_Code.lines.clear;

BuildINI_Code_addLine('Ready',Animations.Ready.StartFrame,Animations.Ready.Count,Animations.Ready.Count2,Animations.Ready.special);
BuildINI_Code_addLine('Guard',Animations.Guard.StartFrame,Animations.Guard.Count,Animations.Guard.Count2,Animations.Guard.special);
BuildINI_Code_addLine('Prone',Animations.Prone.StartFrame,Animations.Prone.Count,Animations.Prone.Count2,Animations.Prone.special);
BuildINI_Code_addLine('Down',Animations.Down.StartFrame,Animations.Down.Count,Animations.Down.Count2,Animations.Down.special);
BuildINI_Code_addLine('Crawl',Animations.Crawl.StartFrame,Animations.Crawl.Count,Animations.Crawl.Count2,Animations.Crawl.special);
BuildINI_Code_addLine('Walk',Animations.Walk.StartFrame,Animations.Walk.Count,Animations.Walk.Count2,Animations.Walk.special);
BuildINI_Code_addLine('Up',Animations.Up.StartFrame,Animations.Up.Count,Animations.Up.Count2,Animations.Up.special);
BuildINI_Code_addLine('Idle1',Animations.Idle1.StartFrame,Animations.Idle1.Count,Animations.Idle1.Count2,Animations.Idle1.special);
BuildINI_Code_addLine('Idle2',Animations.Idle2.StartFrame,Animations.Idle2.Count,Animations.Idle2.Count2,Animations.Idle2.special);
BuildINI_Code_addLine('Die1',Animations.Die1.StartFrame,Animations.Die1.Count,Animations.Die1.Count2,Animations.Die1.special);
BuildINI_Code_addLine('Die2',Animations.Die2.StartFrame,Animations.Die2.Count,Animations.Die2.Count2,Animations.Die2.special);
BuildINI_Code_addLine('Die3',Animations.Die3.StartFrame,Animations.Die3.Count,Animations.Die3.Count2,Animations.Die3.special);
BuildINI_Code_addLine('Die4',Animations.Die4.StartFrame,Animations.Die4.Count,Animations.Die4.Count2,Animations.Die4.special);
BuildINI_Code_addLine('Die5',Animations.Die5.StartFrame,Animations.Die5.Count,Animations.Die5.Count2,Animations.Die5.special);
BuildINI_Code_addLine('FireUp',Animations.FireUp.StartFrame,Animations.FireUp.Count,Animations.FireUp.Count2,Animations.FireUp.special);
BuildINI_Code_addLine('FireProne',Animations.FireProne.StartFrame,Animations.FireProne.Count,Animations.FireProne.Count2,Animations.FireProne.special);
BuildINI_Code_addLine('Paradrop',Animations.Paradrop.StartFrame,Animations.Paradrop.Count,Animations.Paradrop.Count2,Animations.Paradrop.special);
BuildINI_Code_addLine('Cheer',Animations.Cheer.StartFrame,Animations.Cheer.Count,Animations.Cheer.Count2,Animations.Cheer.special);
BuildINI_Code_addLine('Panic',Animations.Panic.StartFrame,Animations.Panic.Count,Animations.Panic.Count2,Animations.Panic.special);
BuildINI_Code_addLine('Deployed',Animations.Deployed.StartFrame,Animations.Deployed.Count,Animations.Deployed.Count2,Animations.Deployed.special);
BuildINI_Code_addLine('DeployedFire',Animations.DeployedFire.StartFrame,Animations.DeployedFire.Count,Animations.DeployedFire.Count2,Animations.DeployedFire.special);
BuildINI_Code_addLine('Undeploy',Animations.Undeploy.StartFrame,Animations.Undeploy.Count,Animations.Undeploy.Count2,Animations.Undeploy.special);


BuildINI_Code_addLine('Fly',Animations.Fly.StartFrame,Animations.Fly.Count,Animations.Fly.Count2,Animations.Fly.special);
BuildINI_Code_addLine('Hover',Animations.Hover.StartFrame,Animations.Hover.Count,Animations.Hover.Count2,Animations.Hover.special);
BuildINI_Code_addLine('Tumble',Animations.Tumble.StartFrame,Animations.Tumble.Count,Animations.Tumble.Count2,Animations.Tumble.special);
BuildINI_Code_addLine('Undeploy',Animations.FireFly.StartFrame,Animations.FireFly.Count,Animations.FireFly.Count2,Animations.FireFly.special);
end;

procedure TFrmSequence.Reset1Click(Sender: TObject);
begin
FormCreate(Sender);
FormShow(Sender);
end;

procedure TFrmSequence.Refresh_TimerTimer(Sender: TObject);
begin
Refresh_Timer.Enabled := false;

ComboBoxEx1Change(Sender); // Update image

GetSequence(Frame_Image_List,FrmMain.SHP,0,FrmMain.SHP.Header.NumImages-1); // Update Frame List
BuildINI_Code; // Update INI Code
end;

procedure TFrmSequence.Exit1Click(Sender: TObject);
begin
close;
end;

procedure TFrmSequence.Copy1Click(Sender: TObject);
begin
INI_Code.CopyToClipboard;
end;

procedure TFrmSequence.Preview1Click(Sender: TObject);
begin
Preview1.Checked := not Preview1.checked;
FrameList1.Checked := not Preview1.checked;

SequenceTimer.Enabled := Preview1.Checked;

if FrameList1.Checked then
GetSequence(Sequence_Image,FrmMain.SHP,Current_Animation.StartFrame,WorkOutEndFrame);
end;

procedure TFrmSequence.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
SequenceTimer.Enabled := false;
end;

procedure TFrmSequence.SequenceTimerTimer(Sender: TObject);
begin
DrawFrameImage(FrmMain.SHP,SequenceFrame+1,1,true,false,SHPPalette,Sequence_Image);
inc(SequenceFrame);

if SequenceFrame > WorkOutEndFrame then
SequenceFrame := Current_Animation.StartFrame;
end;

end.
