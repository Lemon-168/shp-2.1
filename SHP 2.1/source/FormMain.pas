unit FormMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Menus, Buttons,shp_file,shp_engine,palette,
  Shp_Engine_Image, Spin, math, ComCtrls,clipbrd, ImgList, ToolWin,Mouse,
  ExtDlgs;

Const
SHP_BUILDER_VER = '2.1';
SHP_BUILDER_TITLE = ' BS SHP Builder';
SHP_BUILDER_BY = 'Banshee & Stucuk';
CONFIG_KEY = '2.0';

type
TPoint2D = record
        X,Y : Integer;
end;
TDrawMode = (dmDraw,dmLine,dmFlood,dmDropper,dmRectangle,dmRectangle_Fill,dmErase,dmdarkenlighten,dmselect,dmselectmove);
TTempView = array of record
        X : integer;
        Y : integer;
        colour : tcolor;
        colour_used:boolean;
end;

TPaletteSchemes = array of packed record
        Filename : string;
        ImageIndex : byte;
end;

TPalettePrefrenceData_T = record
        Filename : string[255];
end;

TPalettePrefrenceData = record
        GameSpecific : boolean;
        UnitPalette : TPalettePrefrenceData_T;
        BuildingPalette : TPalettePrefrenceData_T;
        AnimationPalette : TPalettePrefrenceData_T;
        CameoPalette : TPalettePrefrenceData_T;
end;

TFileAssosiationsPreferenceData = record
        Assosiate : boolean;
        ImageIndex : byte;
end;

TColourMatch = record
        Original : TColor;
        Match : Byte;
end;

TSelectData = record
  SourceData,DestData : TSelectArea;
  HasSource : boolean;
  MouseClicked : TPoint2D;
end;

type
  TFrmMain = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    New1: TMenuItem;
    Open1: TMenuItem;
    Save1: TMenuItem;
    SaveAs1: TMenuItem;
    Exit1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    MainPanel: TPanel;
    LeftPanel: TPanel;
    lblPalette: TLabel;
    ToolPanel: TPanel;
    lblTools: TLabel;
    FramePanel: TPanel;
    lblFrameControls: TLabel;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    SpeedButton10: TSpeedButton;
    OpenSHPDialog: TOpenDialog;
    SaveSHPDialog: TSaveDialog;
    Current_Frame: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    lbl_total_frames: TLabel;
    pnlPalette: TPanel;
    lblActiveColour: TLabel;
    pnlActiveColour: TPanel;
    Palette1: TMenuItem;
    Load1: TMenuItem;
    OpenPaletteDialog: TOpenDialog;
    StatusBar1: TStatusBar;
    Help1: TMenuItem;
    About1: TMenuItem;
    lblZoom: TLabel;
    ZoomPanel: TPanel;
    Label3: TLabel;
    Zoom_Factor: TSpinEdit;
    PalettePanel: TPanel;
    cnvPalette: TPaintBox;
    ools1: TMenuItem;
    Preview1: TMenuItem;
    urnToCameoMode1: TMenuItem;
    N3: TMenuItem;
    PaintPanel: TPanel;
    AutoShadows1: TMenuItem;
    Edit1: TMenuItem;
    Copy1: TMenuItem;
    PasteFrame1: TMenuItem;
    Undo1: TMenuItem;
    Redo1: TMenuItem;
    N5: TMenuItem;
    iberianSun1: TMenuItem;
    RedAlert21: TMenuItem;
    LoadPaletteScheme: TMenuItem;
    Blank2: TMenuItem;
    N6: TMenuItem;
    Preferences1: TMenuItem;
    pnlbump: TPanel;
    SpeedButton11: TSpeedButton;
    SpeedButton12: TSpeedButton;
    SpeedButton13: TSpeedButton;
    ImageList: TImageList;
    Panel1: TPanel;
    ToolBar1: TToolBar;
    ToolButton2: TToolButton;
    ToolButton1: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    Options1: TMenuItem;
    N8: TMenuItem;
    Help2: TMenuItem;
    N4: TMenuItem;
    InsertFrame1: TMenuItem;
    DeleteFrame1: TMenuItem;
    N7: TMenuItem;
    ScrollBox1: TScrollBox;
    PaintAreaPanel: TPanel;
    Image1: TImage;
    N9: TMenuItem;
    Resize1: TMenuItem;
    lblBrush: TLabel;
    BrushPanel: TPanel;
    Brush_1: TSpeedButton;
    Brush_2: TSpeedButton;
    Brush_3: TSpeedButton;
    Brush_4: TSpeedButton;
    Brush_5: TSpeedButton;
    Import1: TMenuItem;
    ImportBMPs1: TMenuItem;
    test1: TMenuItem;
    Export1: TMenuItem;
    N10: TMenuItem;
    SHPBMPs1: TMenuItem;
    SavePictureDialog: TSavePictureDialog;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    FixShadows1: TMenuItem;
    FrameImage1: TMenuItem;
    ImageFrame1: TMenuItem;
    ImageSHP1: TMenuItem;
    Copy2: TMenuItem;
    Cut1: TMenuItem;
    Sequence1: TMenuItem;
    function OpositeColour(color : TColor) : tcolor;
    procedure AddTocolourList(colour:byte);
    procedure SetShadowMode(Value : boolean);
    Procedure SetPalette(Filename:string);
    Procedure SaveConfig(filename:string);
    Procedure LoadConfig(filename:string);
    Procedure LoadASHP(file_name :string);
    procedure hidepanels;
    procedure BrushToolDarkenLighten(Xc,Yc: Integer; BrushMode: Integer);
    procedure BrushTool(Xc,Yc,BrushMode,Colour: Integer);
    Procedure PaletteLoaded(filename: string);
    function LoadPalettesMenu : integer;
    procedure FloodFillTool(Frame,Xpos,Ypos: Integer; Colour : byte);
    procedure Rectangle(Xpos,Ypos,Xpos2,Ypos2:Integer; Fill: Boolean);
    procedure Rectangle_dotted(Xpos,Ypos,Xpos2,Ypos2:Integer);
    procedure drawstraightline_temp(var tempview : Ttempview; var last,first : TPoint2D);
    procedure SetShadowColour(Col: Integer);
    Procedure WorkOutImageClick(var X,Y : integer; var OutOfRange : boolean);
    procedure SetIsEditable(Value : boolean);
    procedure SetActiveColour(Col: Integer);
    procedure Exit1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure SaveAs1Click(Sender: TObject);
    procedure cnvPalettePaint(Sender: TObject);
    procedure cnvPaletteMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Current_FrameChange(Sender: TObject);
    procedure Load1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Zoom_FactorChange(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SpeedButton6Click(Sender: TObject);
    procedure Preview1Click(Sender: TObject);
    procedure urnToCameoMode1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure PasteFrame1Click(Sender: TObject);
    procedure SpeedButton9Click(Sender: TObject);
    procedure LoadPaletteSchemeClick(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton11Click(Sender: TObject);
    procedure SpeedButton12Click(Sender: TObject);
    procedure SpeedButton13Click(Sender: TObject);
    procedure Preferences1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure InsertFrame1Click(Sender: TObject);
    procedure DeleteFrame1Click(Sender: TObject);
    procedure AutoShadows1Click(Sender: TObject);
    procedure Resize1Click(Sender: TObject);
    procedure Brush_1Click(Sender: TObject);
    procedure Brush_2Click(Sender: TObject);
    procedure Brush_3Click(Sender: TObject);
    procedure Brush_4Click(Sender: TObject);
    procedure Brush_5Click(Sender: TObject);
    procedure ImportBMPs1Click(Sender: TObject);
    procedure test1Click(Sender: TObject);
    procedure SHPBMPs1Click(Sender: TObject);
    procedure ToolButton12Click(Sender: TObject);
    procedure FixShadows1Click(Sender: TObject);
    procedure FrameImage1Click(Sender: TObject);
    procedure SpeedButton10Click(Sender: TObject);
    procedure ImageSHP1Click(Sender: TObject);
    procedure Copy2Click(Sender: TObject);
    procedure Cut1Click(Sender: TObject);
    procedure Sequence1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    SHP : TSHP;
    isEditable,IsLeftMouse : boolean;
    ActiveColour,ShadowColour : byte;
    PaletteMax : integer;
    Filename : string;
    DrawMode : TDrawMode;
    Zoom : integer;
    TempView : TTempView;
    TempView_no : integer;
    First,Last : TPoint2D;
    PaletteSchemes : TPaletteSchemes;
    PaletteSchemes_No : Integer;
    DarkenLighten_B : boolean;
    DarkenLighten_N : byte;
    Brush_Type : integer;
    PalettePrefrenceData : TPalettePrefrenceData;
    FileAssosiationsPreferenceData : TFileAssosiationsPreferenceData;
    ShadowMode : boolean;
    Colour_list: array of record
        colour : byte;
        count : byte;
    end;
    Colour_list_no : byte;
    ColourMatch : array of TColourMatch;
    ColourMatch_no : integer;
    show_center : boolean;
    SelectData : TSelectData;
    DefultCursor : integer;
    alg : byte;
    function GetCaption : string;
  end;

var
  FrmMain: TFrmMain;

implementation

uses FormAbout, FormNew, FormPreview, FormReplaceColour,
  FormDarkenLightenTool, FormPreferences, FormAutoShadows, FormResize,
  FormImportImageAsSHP, FormSequence;

{$R *.dfm}

function TFrmMain.GetCaption : string;
begin
Result := SHP_BUILDER_TITLE + ' ' + SHP_BUILDER_VER;
end;

procedure TFrmMain.SetActiveColour(Col: Integer);
begin
     ActiveColour := Col;
     if isEditable then
     pnlActiveColour.Color := SHPPalette[ActiveColour]
     else
     pnlActiveColour.Color := colourtogray(SHPPalette[ActiveColour]);
     lblActiveColour.Caption := IntToStr(ActiveColour) + ' (0x' + IntToHex(ActiveColour,3) + ')';
     cnvPalette.Repaint;
end;

procedure TFrmMain.SetShadowColour(Col: Integer);
begin
     ShadowColour := Col;
     if isEditable then
     pnlActiveColour.Color := SHPPalette[ShadowColour]
     else
     pnlActiveColour.Color := colourtogray(SHPPalette[ShadowColour]);
     lblActiveColour.Caption := IntToStr(ShadowColour) + ' (0x' + IntToHex(ShadowColour,3) + ')';
     cnvPalette.Repaint;
end;

procedure TFrmMain.Exit1Click(Sender: TObject);
begin
Close;
end;

procedure TFrmMain.FormShow(Sender: TObject);
var
temp : string;
x : integer;
begin
SetisEditable(False);

if fileexists(extractfiledir(ParamStr(0))+'\palettes\ts\unittem.pal') then
SetPalette(extractfiledir(ParamStr(0))+'\palettes\ts\unittem.pal')
else
begin
messagebox(0,pchar('Error Palette: < '+extractfiledir(ParamStr (0))+'\palettes\ts\unittem.pal > Not Found'),'Palette Error',0);
Close;
end;

PaletteSchemes_No := LoadPalettesMenu;

alg := 1; // Defult alg to 1

if fileexists(extractfiledir(ParamStr(0))+'\SHP_BUILDER.dat') then
LoadConfig(extractfiledir(ParamStr(0))+'\SHP_BUILDER.dat');

if Not LoadMouseCursors  then close;
// LoadMouseCursors; // Loads Cursors
Image1.Cursor := MouseDraw; // Set Defult cursor

ColourMatch_no := 0;

PaintAreaPanel.Width := 0;
PaintAreaPanel.Height := 0;
// Stops cursor changing to drawign tool when no SHP is open

ActiveColour := 16;
ShadowColour := 1;
SetActiveColour(ActiveColour);

FrmAbout.Label1.Caption := SHP_BUILDER_TITLE;
FrmAbout.Label4.Caption := FrmAbout.Label4.Caption + SHP_BUILDER_VER;
FrmAbout.Label6.Caption := FrmAbout.Label6.Caption + SHP_BUILDER_BY;

FrmAbout.Label2.Caption := FrmAbout.Label2.Caption + SHP_ENGINE_VER;
FrmAbout.Label3.Caption := FrmAbout.Label3.Caption + SHP_ENGINE_BY;
Caption := SHP_BUILDER_TITLE + ' ' + SHP_BUILDER_VER;

DrawMode := dmdraw;
Zoom := 2;
Zoom_Factor.value := Zoom;
TempView_no := 0;
DarkenLighten_N := 1;
Brush_Type := 0;

temp := '';

if ParamCount > 0 then
for x := 1 to ParamCount do
if temp = '' then
temp := ParamStr(x)
else
temp := temp + ' ' + ParamStr(x);


if fileexists(temp) then
LoadASHP(temp);

end;

procedure TFrmMain.Open1Click(Sender: TObject);
begin
if OpenSHPDialog.Execute then
LoadASHP(OpenSHPDialog.FileName);
end;

procedure TFrmMain.SaveAs1Click(Sender: TObject);
begin
if SaveSHPDialog.Execute then
begin

Filename := SaveSHPDialog.FileName;

Save1Click(Sender);

Caption := SHP_BUILDER_TITLE + ' ' + SHP_BUILDER_VER +  ' - ['+extractfilename(Filename)+']';

end;
end;

procedure SplitColour(raw: TColor; var red, green, blue: Byte);
begin
     red := (raw and $00FF0000) shr 16;
     green := (raw and $0000FF00) shr 8;
     blue := raw and $000000FF;
end;

procedure TFrmMain.cnvPalettePaint(Sender: TObject);
var colwidth, rowheight: Real;
    i, j, idx: Integer;
    r: TRect;
    red, green, blue, mixcol,SColour: Byte;
begin
     colwidth := cnvPalette.Width / 8;
     rowheight := cnvPalette.Height / 32;
     idx := 0;
     PaletteMax := 256;
     SColour := ActiveColour;

     if iseditable then
     if IsShadow(SHP,Current_Frame.Value) and (ShadowMode) then
     begin
     SColour := ShadowColour;
     PaletteMax := 2;
     end;

     for i := 0 to 8 do begin
         r.Left := Trunc(i * colwidth);
         r.Right := Ceil(r.Left + colwidth);
         for j := 0 to 31 do begin
             r.Top := Trunc(j * rowheight);
             r.Bottom := Ceil(r.Top + rowheight);
             if Idx < PaletteMax then
             with cnvPalette.Canvas do begin

                  if isEditable then
                  Brush.Color := SHPPalette[idx]
                  else
                  Brush.Color := colourtogray(SHPPalette[idx]);
                  if (Idx = SColour) then begin // the current pen

                     SplitColour(SHPPalette[idx],red,green,blue);
                     mixcol := (red + green + blue);
                     Pen.Color := RGB(128 + mixcol,255 - mixcol, mixcol);
                     //Pen.Mode := pmNotXOR;
                     Rectangle(r.Left,r.Top,r.Right,r.Bottom);
                     MoveTo(r.Left,r.Top);
                     LineTo(r.Right,r.Bottom);
                     MoveTo(r.Right,r.Top);
                     LineTo(r.Left,r.Bottom);
                  end else
                      FillRect(r);
             end;
             Inc(Idx);
         end;
     end;
end;

procedure TFrmMain.cnvPaletteMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var colwidth, rowheight: Real;
    i, j, idx: Integer;
begin
If not isEditable then exit;
     colwidth := cnvPalette.Width / 8;
     rowheight := cnvPalette.Height / 32;
     i := Trunc(X / colwidth);
     j := Trunc(Y / rowheight);
     idx := (i * 32) + j;
     if idx < PaletteMax then
     if IsShadow(SHP,Current_Frame.Value) and (ShadowMode) then
     SetShadowColour(idx)
     else
     SetActiveColour(idx);
end;

procedure TFrmMain.SetIsEditable(Value : boolean);
begin
isEditable := Value;

cnvPalette.Repaint;
SetActiveColour(ActiveColour);

Save1.enabled := isEditable;
SaveAs1.enabled := isEditable;
Zoom_Factor.enabled := isEditable;
Current_Frame.enabled := isEditable;
SpeedButton1.enabled := isEditable;
SpeedButton2.enabled := isEditable;
SpeedButton3.enabled := isEditable;
SpeedButton4.enabled := isEditable;
SpeedButton5.enabled := isEditable;
SpeedButton6.enabled := isEditable;
SpeedButton7.enabled := isEditable;
SpeedButton8.enabled := isEditable;
SpeedButton9.enabled := isEditable;
SpeedButton10.enabled := isEditable;
Brush_1.enabled := isEditable;
Brush_2.enabled := isEditable;
Brush_3.enabled := isEditable;
Brush_4.enabled := isEditable;
Brush_5.enabled := isEditable;

ToolButton1.enabled := isEditable;
ToolButton3.enabled := isEditable;
ToolButton4.enabled := isEditable;
ToolButton9.enabled := isEditable;
ToolButton12.enabled := isEditable;


ools1.Visible := isEditable;
Edit1.Visible := isEditable;
Options1.Visible := isEditable;

Export1.enabled := isEditable;

if iseditable then
PaintAreaPanel.Color := SHPPalette[0]
else
PaintAreaPanel.Color := clbtnface;

SelectData.HasSource := false; // Stops select tool showing the move thing
end;

procedure TFrmMain.Current_FrameChange(Sender: TObject);
var
x,y : integer;
begin
if not iseditable then exit;

if Current_Frame.value > SHP.Header.NumImages then
   Current_Frame.value := 1;

if Current_Frame.value < 1 then
   Current_Frame.Value := SHP.Header.NumImages;

if IsShadow(SHP,Current_Frame.Value) and (ShadowMode) then
StatusBar1.Panels[0].Text := 'Shadow Frame'
else
StatusBar1.Panels[0].Text := 'Owner Frame';

// Paintpanel is resized to the images width, image is on the panel, and panel is coloured the same colour as transparent
// The result is less flicker, there is still some, but its greatly reduced.
PaintAreaPanel.Width :=  SHP.Header.Width*Zoom-1;
PaintAreaPanel.Height := SHP.Header.Height*Zoom-1;

if IsShadow(SHP,Current_Frame.Value) and (ShadowMode) then
DrawShadowWithFrameImage(SHP,Current_Frame.Value,Zoom,true,SHPPalette,image1)
else
DrawFrameImage(SHP,Current_Frame.Value,Zoom,true,false,SHPPalette,image1);

if show_center then // Create Cross
for x := 0 to SHP.Header.Width -1 do
for y := 0 to SHP.Header.Height-1 do
if (x = (SHP.Header.Width-1) div 2) or (y = (SHP.Header.Height-1) div 2) then
begin
image1.Picture.Bitmap.Canvas.Brush.Color := OpositeColour(image1.Picture.Bitmap.Canvas.Pixels[x*Zoom,y*Zoom]);
image1.Picture.Bitmap.Canvas.FillRect(Rect((x*Zoom),(y*Zoom),(x*Zoom)+Zoom,(y*Zoom)+Zoom));
end;

if TempView_no > 0 then
for x := 1 to TempView_no do
begin
if TempView[x].colour_used then
image1.Picture.Bitmap.Canvas.Brush.Color := TempView[x].colour
else
if IsShadow(SHP,Current_Frame.Value) and (ShadowMode) then
image1.Picture.Bitmap.Canvas.Brush.Color := SHPPalette[ShadowColour]
else
image1.Picture.Bitmap.Canvas.Brush.Color := SHPPalette[ActiveColour];

if DrawMode = dmerase then
image1.Picture.Bitmap.Canvas.Brush.Color := SHPPalette[0];

image1.Picture.Bitmap.Canvas.FillRect(Rect((TempView[x].X*Zoom),(TempView[x].Y*Zoom),(TempView[x].X*Zoom)+Zoom,(TempView[x].Y*Zoom)+Zoom));
end;

image1.Refresh;

if (IsShadow(SHP,Current_Frame.value)) and (PaletteMax <> 2) then
begin
SetShadowColour(ShadowColour);
cnvPalette.Repaint;
end;

if Not(IsShadow(SHP,Current_Frame.value)) and (PaletteMax <> 256) then
begin
SetActiveColour(ActiveColour);
cnvPalette.Repaint;
end;

end;

Procedure TFrmMain.PaletteLoaded(filename: string);
var
Sender : tobject;
begin

lblPalette.caption := ' Palette - '+extractfilename(filename);
Current_FrameChange(Sender);

if iseditable then
begin
PaintAreaPanel.Color := SHPPalette[0];
FrmPreview.TrackBar1Change(Sender);
end;

if iseditable then
if IsShadow(SHP,Current_Frame.Value) then
SetShadowColour(ShadowColour)
else
SetActiveColour(ActiveColour);

if not iseditable then
cnvPalette.Repaint;

end;

procedure TFrmMain.Load1Click(Sender: TObject);
begin
if OpenPaletteDialog.Execute then
SetPalette(OpenPaletteDialog.FileName);
end;

procedure TFrmMain.About1Click(Sender: TObject);
begin
FrmAbout.showmodal;
end;

procedure TFrmMain.New1Click(Sender: TObject);
var
TotalFrames,SHP_Width, SHP_Height : integer;
Editable : boolean;
begin
Editable := isEditable;
SetIsEditable(False);

FrmNew.txtFrames.text := '100';
FrmNew.txtwidth.text := '100';
FrmNew.txtheight.text := '100';
FrmNew.showmodal;

if FrmNew.changed then
begin
try
TotalFrames := strtoint(FrmNew.txtFrames.text);
SHP_Width := strtoint(FrmNew.txtwidth.text);
SHP_Height := strtoint(FrmNew.txtheight.text);

NewSHP(SHP,TotalFrames,SHP_Width,SHP_Height);
except
Showmessage('Error: Invalid Dimentions'); // Will catch non numeric numbers in the boxes
end;

Filename := ''; // New file must have blank filename to be recognised as a new file

Caption := SHP_BUILDER_TITLE + ' ' + SHP_BUILDER_VER +  ' - [Untitled.shp]';

StatusBar1.Panels[3].Text := 'Width: ' + inttostr(SHP.Header.Width) + ' Height: ' + inttostr(SHP.Header.Height);

SetShadowMode(HasShadows(SHP));

if PalettePrefrenceData.GameSpecific then
if SHP.SHPType = stCameo then
SetPalette(PalettePrefrenceData.CameoPalette.Filename)
else
if SHP.SHPType = stUnit then
SetPalette(PalettePrefrenceData.UnitPalette.Filename)
else
if SHP.SHPType = stBuilding then
SetPalette(PalettePrefrenceData.BuildingPalette.Filename)
else
if SHP.SHPType = stAnimation then
SetPalette(PalettePrefrenceData.AnimationPalette.Filename);

lbl_total_frames.Caption := inttostr(SHP.Header.NumImages);
FrmPreview.TrackBar1.Position := 1;

if Shadowmode then
FrmPreview.TrackBar1.Max := SHP.Header.NumImages div 2
else
FrmPreview.TrackBar1.Max := SHP.Header.NumImages;

StatusBar1.Panels[1].Text := 'SHP Type: ' + GetSHPType(SHP);

SetIsEditable(True);

Current_Frame.value := 1;
Current_FrameChange(Sender);
FrmPreview.TrackBar1Change(Sender);
end
else
SetIsEditable(Editable);

end;

procedure TFrmMain.Save1Click(Sender: TObject);
begin

if Filename = '' then
SaveAs1Click(Sender)
else
begin
CompressFrameImages(SHP);
SaveSHP(Filename,SHP);
end;

end;

procedure TFrmMain.SpeedButton1Click(Sender: TObject);
begin
DrawMode := dmdraw;
TempView_no := 0; // Clear Temp view;
Current_FrameChange(Sender);

if Brush_Type = 0 then
Image1.Cursor := MouseDraw
else
if Brush_Type = 4 then
Image1.Cursor := MouseSpray
else
Image1.Cursor := MouseBrush;

SelectData.HasSource := false;

end;

procedure TFrmMain.Zoom_FactorChange(Sender: TObject);
begin
if not iseditable then exit;

Zoom := Zoom_Factor.Value;
Current_FrameChange(Sender);
end;

Procedure TFrmMain.WorkOutImageClick(var X,Y : integer; var OutOfRange : boolean);
begin
OutOfRange := true; // Assume True

x := (x div zoom);
y := (y div zoom);

if (x > shp.Header.Width-1) or (y > shp.Header.Height-1) or (x < 0) or (y < 0) then
OutOfRange := true
else
OutOfRange := false;
end;

procedure TFrmMain.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
xx,yy : integer;
OutOfRange : boolean;
begin
if not iseditable then Exit;
XX := X;
YY := Y;

WorkOutImageClick(XX,YY,OutOfRange);

IsLeftMouse := false;

if (Button = mbLeft) and not (DrawMode = dmflood) and (not OutOfRange) then
begin

first.X := XX;
first.Y := YY;

if (drawmode = dmselect) and (SelectData.HasSource) then
if (XX >= SelectData.SourceData.X1) and (XX <= SelectData.SourceData.X2) and (YY >= SelectData.SourceData.Y1) and (YY <= SelectData.SourceData.Y2) then
begin
SelectData.DestData.X1 := SelectData.SourceData.X1;
SelectData.DestData.X2 := SelectData.SourceData.X2;
SelectData.DestData.Y1 := SelectData.SourceData.Y1;
SelectData.DestData.Y2 := SelectData.SourceData.Y2;
SelectData.MouseClicked.X := XX;
SelectData.MouseClicked.Y := YY;
Last.X := XX;
Last.Y := YY;

drawmode := dmselectmove;
end
else
begin
drawmode := dmselect;
SelectData.HasSource := false;
end;

IsLeftMouse := true;
Image1MouseMove(Sender,Shift,X,Y);
end;

if not OutOfRange then
if DrawMode = dmflood then
begin
IsLeftMouse := false;

TempView_no := 0;

if IsShadow(SHP,Current_Frame.Value) and (ShadowMode) then
FloodFillTool(Current_Frame.Value,XX,YY,ShadowColour)
else
FloodFillTool(Current_Frame.Value,XX,YY,ActiveColour);

Current_FrameChange(Sender);
end;

end;

procedure TFrmMain.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
OutOfRange : boolean;
XX,YY,XDifference,YDifference : integer;
Colour : byte;
begin
if not iseditable then Exit;
// Basic drawing
XX := X;
YY := Y;
WorkOutImageClick(XX,YY,OutOfRange);

if not OutOfRange then
StatusBar1.Panels[2].Text := 'X: ' + inttostr(XX) + ' Y: ' + inttostr(YY);

if IsShadow(SHP,Current_Frame.Value) and (ShadowMode) then
Colour := ShadowColour
else
Colour := ActiveColour;

if not IsLeftMouse then
begin
TempView_no := 0; // Empty the temp view (well its still got the previous data, but it saves emptying it.)
SetLength(TempView,0);
// In here are tools that show a preview when the mouse is moved and isn't clicked.

if not OutOfRange then
case DrawMode of


        dmDraw: begin
        BrushTool(XX,YY,Brush_Type,Colour);
        Current_FrameChange(Sender);
        end;

        dmErase: begin // Erase is the same as draw but it is always the transparent colour...
        BrushTool(XX,YY,Brush_Type,0);
        Current_FrameChange(Sender);
        end;

        dmselect: begin
        if (Image1.Cursor <> MouseMoveC) and (Image1.Cursor <> DefultCursor) then
        DefultCursor := Image1.Cursor;

        if SelectData.HasSource then
        if (XX >= SelectData.SourceData.X1) and (XX <= SelectData.SourceData.X2) and (YY >= SelectData.SourceData.Y1) and (YY <= SelectData.SourceData.Y2) then
        Image1.Cursor := MouseMoveC
        else
        Image1.Cursor := DefultCursor;
        end;
end;

Exit;
end;

if IsLeftMouse then
if not OutOfRange then
case DrawMode of
        dmDraw: begin
        //if SHP.Data[Current_Frame.Value].FrameImage[XX,YY] <> Colour then // Reduces flickering
        //begin
        //SHP.Data[Current_Frame.Value].FrameImage[XX,YY] := Colour;

        BrushTool(XX,YY,Brush_Type,Colour);

        Current_FrameChange(Sender);
        //end;
        end;

        dmErase: begin // Erase is the same as draw but it is always the transparent colour...
        {if SHP.Data[Current_Frame.Value].FrameImage[XX,YY] <> 0 then // Reduces flickering
        begin
        SHP.Data[Current_Frame.Value].FrameImage[XX,YY] := 0;
        Current_FrameChange(Sender);
        end;  }

        BrushTool(XX,YY,Brush_Type,0);

        Current_FrameChange(Sender);

        end;

        dmdropper: begin
        if IsShadow(SHP,Current_Frame.Value) and (shadowmode) then
        SetShadowColour(SHP.Data[Current_Frame.Value].FrameImage[XX,YY])
        else
        SetActiveColour(SHP.Data[Current_Frame.Value].FrameImage[XX,YY]);
        end;

        dmline: begin
        if (Last.X <> XX) or (Last.Y <> YY) then // Only if the last value has changed then refresh
        begin
        Last.X := XX;
        Last.Y := YY;
        drawstraightline_temp(TempView,last,first);
        Current_FrameChange(Sender);
        end;
        end;

        dmRectangle: begin
        if (Last.X <> XX) or (Last.Y <> YY) then // Only if the last value has changed then refresh
        begin
        Last.X := XX;
        Last.Y := YY;
        Rectangle(First.X,First.Y,Last.X,Last.Y,False);
        Current_FrameChange(Sender);
        end;
        end;

        dmRectangle_Fill: begin
        if (Last.X <> XX) or (Last.Y <> YY) then // Only if the last value has changed then refresh
        begin
        Last.X := XX;
        Last.Y := YY;
        Rectangle(First.X,First.Y,Last.X,Last.Y,True);
        Current_FrameChange(Sender);
        end;
        end;

        dmselect: begin
        if (Last.X <> XX) or (Last.Y <> YY) then // Only if the last value has changed then refresh
        begin
        Last.X := XX;
        Last.Y := YY;
        Rectangle_dotted(First.X,First.Y,Last.X,Last.Y);
        Current_FrameChange(Sender);
        end;
        end;

        dmselectmove: begin
        //if (Last.X <> XX) or (Last.Y <> YY) then // Only if the last value has changed then refresh
        begin

        Last.X := XX;
        Last.Y := YY;

        XDifference := XX-SelectData.MouseClicked.X;
        YDifference := YY-SelectData.MouseClicked.Y;

        SelectData.DestData.X1 := SelectData.SourceData.X1 + XDifference;
        SelectData.DestData.X2 := SelectData.SourceData.X2 + XDifference;
        SelectData.DestData.Y1 := SelectData.SourceData.Y1 + YDifference;
        SelectData.DestData.Y2 := SelectData.SourceData.Y2 + YDifference;

        Rectangle_dotted(SelectData.DestData.X1,SelectData.DestData.Y1,SelectData.DestData.X2,SelectData.DestData.Y2);
        Current_FrameChange(Sender);
        end;
        end;
end;

end;

procedure TFrmMain.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var xx,yy : integer;
OutOfRange : boolean;
begin
if Not isEditable then Exit;
if Not IsLeftMouse then Exit;

IsLeftMouse := false;

//if (DrawMode = dmline) or (DrawMode = dmRectangle) or (DrawMode = dmRectangle_Fill) then

if (drawmode <> dmselect) and (drawmode <> dmselectmove) then
if TempView_no > 0 then
for xx := 1 to TempView_no do
if DrawMode= dmerase then
SHP.Data[Current_Frame.Value].FrameImage[TempView[xx].X,TempView[xx].Y] := 0
else
if IsShadow(SHP,Current_Frame.Value) and (ShadowMode) then
SHP.Data[Current_Frame.Value].FrameImage[TempView[xx].X,TempView[xx].Y] := ShadowColour
else
SHP.Data[Current_Frame.Value].FrameImage[TempView[xx].X,TempView[xx].Y] := ActiveColour;

if (drawmode <> dmselect) and (drawmode <> dmselectmove) then
if TempView_no > 0 then
TempView_no := 0;

if drawmode = dmselect then
if SelectData.HasSource = false then
if (first.x = last.x) and (first.y = last.y) then
TempView_no := 0
else
begin
SelectData.HasSource := true;
SelectData.SourceData.X1 := min(first.x,last.x);
SelectData.SourceData.X2 := max(first.x,last.x);
SelectData.SourceData.Y1 := min(first.y,last.y);
SelectData.SourceData.Y2 := max(first.y,last.y);
//DrawMode := dmselectmove;
end;

if DrawMode = dmselectmove then
begin

FrameImage_Section_Move(SHP,Current_Frame.Value,SelectData.SourceData,SelectData.DestData);

DrawMode := dmselect;
SelectData.SourceData.X1 := SelectData.DestData.X1;
SelectData.SourceData.X2 := SelectData.DestData.X2;
SelectData.SourceData.Y1 := SelectData.DestData.Y1;
SelectData.SourceData.Y2 := SelectData.DestData.Y2;
end;

XX := X;
YY := Y;

WorkOutImageClick(XX,YY,OutOfRange);

if not OutOfRange then
if DrawMode = dmdarkenlighten then
BrushToolDarkenLighten(XX,YY,Brush_Type);

Current_FrameChange(Sender);


end;

procedure TFrmMain.SpeedButton6Click(Sender: TObject);
begin
SelectData.HasSource := false;
DrawMode := dmdropper;
TempView_no := 0; // Clear Temp view;
Current_FrameChange(Sender);
Image1.Cursor := MouseDropper;
end;

procedure TFrmMain.Preview1Click(Sender: TObject);
begin
FrmPreview.show;
end;

procedure TFrmMain.urnToCameoMode1Click(Sender: TObject);
begin
SetShadowMode(not urnToCameoMode1.Checked);
{if SHP.SHPType = stCameo then Exit; // ITs already a cameo, it can't be an animation with 1 frame...

SHP.SHPType := stCameo; // Fake Cameo, only one without shadows

FrmPreview.TrackBar1.Max := SHP.Header.NumImages;
FrmPreview.TrackBar1Change(Sender); // Update Preview

StatusBar1.Panels[1].Text := 'SHP Type: Animation(no Shadows)';   }
end;

procedure TFrmMain.SpeedButton2Click(Sender: TObject);
begin
DrawMode := dmLine;
TempView_no := 0; // Clear Temp view;
Current_FrameChange(Sender);
Image1.Cursor := MouseLine;

SelectData.HasSource := false;
end;

function getgradient(last,first : TPoint2D) : single;
begin
if (first.X = last.X) or (first.Y = last.Y) then
   result := 0
else
   result := (first.Y-last.Y) / (first.X-last.X);
end;


procedure TFrmMain.drawstraightline_temp(var tempview : Ttempview; var last,first : TPoint2D);
var
x,y : integer;
gradient,c : single;
begin
// Straight Line Equation : Y=MX+C

//memo1.lines.add('First Click:');
//memo1.lines.add('X:' +inttostr(first.X)+' Y:' +inttostr(first.Y)+' Z:' +inttostr(first.Z));
//memo1.lines.add('Last Click:');
//memo1.lines.add('X:' +inttostr(last.X)+' Y:' +inttostr(last.Y)+' Z:' +inttostr(last.Z));

gradient := getgradient(last,first);

c := last.Y-(last.X * gradient);

//memo1.lines.add(#13'Starting X:'+inttostr(first.X) + ' Starting Y:'+inttostr(first.Y));
//memo1.lines.add('Ending X:'+inttostr(last.X) + ' Ending Y:'+inttostr(last.Y));

//memo1.lines.add(#13'Gradient:'+floattostr(gradient));
//memo1.lines.add('C:'+floattostr(c));

//memo1.lines.add(#13'Using X constantly changing by 1 to get Y:');

//showmessage(inttostr(gradient));

TempView_no := 0;
setlength(tempview,0);

if (gradient=0) and (first.X = last.X) then
for y := min(first.Y,last.y) to max(first.Y,last.y) do
begin
TempView_no := TempView_no +1;
setlength(tempview,TempView_no+1);

tempview[TempView_no].X := first.X;
tempview[TempView_no].Y := y;

end
else
if (gradient=0) and (first.Y = last.Y) then
for x := min(first.x,last.x) to max(first.x,last.x) do
begin
TempView_no := TempView_no +1;
setlength(tempview,TempView_no+1);

tempview[TempView_no].X := x;
tempview[TempView_no].Y := first.Y;

end
else
begin

for x := min(first.X,last.X) to max(first.X,last.X) do
begin
//memo1.lines.add('Y:' +inttostr(round((gradient*x)+c)) + ' X:' + inttostr(x));
TempView_no := TempView_no +1;
setlength(tempview,TempView_no+1);

tempview[TempView_no].X := x;
tempview[TempView_no].Y := round((gradient*x)+c);


end;

//memo1.lines.add(#13'Using Y constantly changing by 1 to get X:');

for y := min(first.Y,last.Y) to max(first.Y,last.Y) do
begin
//memo1.lines.add('Y:' +inttostr(y) + ' X:' + inttostr(round((y-c)/ gradient)));

TempView_no := TempView_no +1;
setlength(tempview,TempView_no+1);

tempview[TempView_no].X := round((y-c)/ gradient);
tempview[TempView_no].Y := y;
end;

end;

end;

// File: Voxel.pas
// Original Procedure Name: procedure TVoxelSection.FloodFillTool(Xpos,Ypos,Zpos: Integer; v: TVoxelUnpacked; EditView: EVoxelViewOrient);
// Flood Fill Code Taken From Voxel Section Editor and adapted to this program

procedure TFrmMain.FloodFillTool(Frame,Xpos,Ypos: Integer; Colour : byte);
type
  FloodSet = (Left,Right,Up,Down);
  Flood2DPoint = record
    X,Y: Integer;
  end;
  StackType = record
    Dir: set of FloodSet;
    p: Flood2DPoint;
  end;
  function PointOK(l: Flood2DPoint): Boolean;
  begin
    PointOK:=False;
    if (l.X<0) or (l.Y<0) then Exit;
    if (l.X>=SHP.Header.Width) or (l.Y>=SHP.Header.Height) then Exit;
    PointOK:=True;
  end;
var
  z1,z2: byte;
  i,j,k: Integer;         //this isn't 100% FloodFill, but function is very handy for user;
  Stack: Array of StackType; //this is the floodfill stack for my code
  SC,Sp: Integer; //stack counter and stack pointer
  po: Flood2DPoint;
  Full: set of FloodSet;
  Done: Array of Array of Boolean;
begin
  SetLength(Done,SHP.Header.Width,SHP.Header.Height);
  SetLength(Stack,SHP.Header.Width*SHP.Header.Height);
  //this array avoids creation of extra stack objects when it isn't needed.
  for i:=0 to SHP.Header.Width - 1 do
    for j:=0 to SHP.Header.Height - 1 do
        Done[i,j]:=False;

  z1 := SHP.Data[Frame].FrameImage[Xpos,Ypos];
  SHP.Data[Frame].FrameImage[Xpos,Ypos] := Colour;


    Full:=[Left,Right,Up,Down];
    Sp:=0;
    Stack[Sp].Dir:=Full;
    Stack[Sp].p.X:=Xpos; Stack[Sp].p.Y:=Ypos;
    SC:=1;
    while (SC>0) do begin
      if Left in Stack[Sp].Dir then begin //it's in there - check left
        //not in there anymore! we're going to do that one now.
        Stack[Sp].Dir:=Stack[Sp].Dir - [Left];
        po:=Stack[Sp].p;
        Dec(po.X);

        //now check this point - only if it's within range, check it.
        if PointOK(po) then begin
        z2 := SHP.Data[Frame].FrameImage[po.X,po.Y];
          if z2=z1 then begin
            SHP.Data[Frame].FrameImage[po.X,po.Y] := Colour;
            if not Done[po.X,po.Y] then begin
              Stack[SC].Dir:=Full-[Right]; //Don't go back
              Stack[SC].p:=po;
              Inc(SC);
              Inc(Sp); //increase stack pointer
            end;
            Done[po.X,po.Y]:=True;
          end;
        end;
      end;
      if Right in Stack[Sp].Dir then begin //it's in there - check left
        //not in there anymore! we're going to do that one now.
        Stack[Sp].Dir:=Stack[Sp].Dir - [Right];
        po:=Stack[Sp].p;
        Inc(po.X);
        //now check this point - only if it's within range, check it.
        if PointOK(po) then begin
          z2 := SHP.Data[Frame].FrameImage[po.X,po.Y];
          if z2=z1 then begin
            SHP.Data[Frame].FrameImage[po.X,po.Y] := Colour;
            if not Done[po.X,po.Y] then begin
              Stack[SC].Dir:=Full-[Left]; //Don't go back
              Stack[SC].p:=po;
              Inc(SC);
              Inc(Sp); //increase stack pointer
            end;
            Done[po.X,po.Y]:=True;
          end;
        end;
      end;
      if Up in Stack[Sp].Dir then begin //it's in there - check left
        //not in there anymore! we're going to do that one now.
        Stack[Sp].Dir:=Stack[Sp].Dir - [Up];
        po:=Stack[Sp].p;
        Dec(po.Y);

        //now check this point - only if it's within range, check it.
        if PointOK(po) then begin
          z2 := SHP.Data[Frame].FrameImage[po.X,po.Y];
          if z2=z1 then begin
            SHP.Data[Frame].FrameImage[po.X,po.Y] := Colour;
            if not Done[po.X,po.Y] then begin
              Stack[SC].Dir:=Full-[Down]; //Don't go back
              Stack[SC].p:=po;
              Inc(SC);
              Inc(Sp); //increase stack pointer
            end;
            Done[po.X,po.Y]:=True;
          end;
        end;
      end;
      if Down in Stack[Sp].Dir then begin //it's in there - check left
        //not in there anymore! we're going to do that one now.
        Stack[Sp].Dir:=Stack[Sp].Dir - [Down];
        po:=Stack[Sp].p;
        Inc(po.Y);

        //now check this point - only if it's within range, check it.
        if PointOK(po) then begin
          z2 := SHP.Data[Frame].FrameImage[po.X,po.Y];
          if z2=z1 then begin
            SHP.Data[Frame].FrameImage[po.X,po.Y] := Colour;
            if not Done[po.X,po.Y] then begin
              Stack[SC].Dir:=Full-[Up]; //Don't go back
              Stack[SC].p:=po;
              Inc(SC);
              Inc(Sp); //increase stack pointer
            end;
            Done[po.X,po.Y]:=True;
          end;
        end;
      end;
      if (Stack[Sp].Dir = []) then begin
        Dec(Sp);
        Dec(SC);
        //decrease stack pointer and stack count
      end;
    end;
SetLength(Stack,0); // Free Up Memory
SetLength(Done,0); // Free Up Memory
end;

// File: FormMain.pas
// Original Procedure Name: procedure TFrmMain.Rectangle(Xpos,Ypos,Zpos,Xpos2,Ypos2,Zpos2:Integer; Fill: Boolean);
// Flood Fill Code Taken From Voxel Section Editor and adapted to this program

procedure TFrmMain.Rectangle(Xpos,Ypos,Xpos2,Ypos2:Integer; Fill: Boolean);
var
  i,j: Integer;
  Inside,Exact: Integer;
begin

  tempview_no := 0;
  setlength(tempview,0);

  for i:=Min(Xpos,Xpos2) to Max(Xpos,Xpos2) do begin
    for j:=Min(Ypos,Ypos2) to Max(Ypos,Ypos2) do begin
        Inside:=0; Exact:=0;

              if (i>Min(Xpos,Xpos2)) and (i<Max(Xpos,Xpos2)) then Inc(Inside);
              if (j>Min(Ypos,Ypos2)) and (j<Max(Ypos,Ypos2)) then Inc(Inside);
              if (i=Min(Xpos,Xpos2)) or (i=Max(Xpos,Xpos2)) then Inc(Exact);
              if (j=Min(Ypos,Ypos2)) or (j=Max(Ypos,Ypos2)) then Inc(Exact);

        if Fill then begin
          if Inside+Exact=2 then begin
           tempview_no := tempview_no +1;
           setlength(tempview,tempview_no +1);
           tempview[tempview_no].X := i;
           tempview[tempview_no].Y := j;
          end;
        end else begin
          if (Exact>=1) and (Inside+Exact=2) then begin
          tempview_no := tempview_no +1;
           setlength(tempview,tempview_no +1);
           tempview[tempview_no].X := i;
           tempview[tempview_no].Y := j;
        end;
      end;
    end;
  end;
end;

function TFrmMain.OpositeColour(color : TColor) : tcolor;
var
r,rr,g,b,mixcol : byte;
begin

  r := GetRValue(color);
  rr := 255-r;

  g := 255-GetGValue(color);
  b := 255-GetBValue(color);
  mixcol := (r + g + b);

  result := RGB(rr,g,b);
end;

function InImageBounds(x,y : integer; SHP:TSHP) : boolean;
begin
result := true; // Assume its in the image

// Check minimum
if (x < 0) or (y < 0) then
result := false;

// Check Max
if (x > SHP.Header.Width-1) or (y > SHP.Header.Height-1) then
result := false;

end;

// File: FormMain.pas
// Original Procedure Name: procedure TFrmMain.Rectangle(Xpos,Ypos,Zpos,Xpos2,Ypos2,Zpos2:Integer; Fill: Boolean);

procedure TFrmMain.Rectangle_dotted(Xpos,Ypos,Xpos2,Ypos2:Integer);
var
  x,y,c: Integer;
begin

  tempview_no := 0;
  setlength(tempview,0);

  c := 0;
  for x := Max(Min(Xpos,Xpos2),0) to Min(SHP.Header.Width-1,Max(Xpos,Xpos2)) do
  begin
  inc(c);
  if (c <4) and (InImageBounds(x,Min(Ypos,Ypos2),SHP)) then
  begin
  tempview_no := tempview_no +1;
  setlength(tempview,tempview_no +1);
  tempview[tempview_no].X := x;
  tempview[tempview_no].Y := Min(Ypos,Ypos2);
  tempview[tempview_no].colour_used := true;
  tempview[tempview_no].colour := OpositeColour(SHPPalette[SHP.Data[Current_Frame.Value].FrameImage[x,Min(Ypos,Ypos2)]]);

  end
  else
  c := 0;
  end;

  c := 0;
  for x := Max(Min(Xpos,Xpos2),0) to Min(SHP.Header.Width-1,Max(Xpos,Xpos2)) do
  begin
  inc(c);
  if (c <4) and (InImageBounds(x,Max(Ypos,Ypos2),SHP)) then
  begin
  tempview_no := tempview_no +1;
  setlength(tempview,tempview_no +1);
  tempview[tempview_no].X := x;
  tempview[tempview_no].Y := Max(Ypos,Ypos2);
  tempview[tempview_no].colour_used := true;
  tempview[tempview_no].colour := OpositeColour(SHPPalette[SHP.Data[Current_Frame.Value].FrameImage[x,Max(Ypos,Ypos2)]]);
  end
  else
  c := 0;
  end;

  c := 0;
  for y := Max(Min(Ypos,Ypos2),0) to Min(SHP.Header.Height-1,Max(Ypos,Ypos2)) do
  begin
  inc(c);
  if (c <4) and (InImageBounds(Min(Xpos,Xpos2),y,SHP)) then
  begin
  tempview_no := tempview_no +1;
  setlength(tempview,tempview_no +1);
  tempview[tempview_no].X := Min(Xpos,Xpos2);
  tempview[tempview_no].Y := y;
  tempview[tempview_no].colour_used := true;
  tempview[tempview_no].colour := OpositeColour(SHPPalette[SHP.Data[Current_Frame.Value].FrameImage[Min(Xpos,Xpos2),y]]);
  end
  else
  c := 0;
  end;

  c := 0;
  for y := Max(Min(Ypos,Ypos2),0) to Min(SHP.Header.Height-1,Max(Ypos,Ypos2)) do
  begin
  inc(c);
  if (c < 4) and (InImageBounds(Max(Xpos,Xpos2),y,SHP)) then
  begin
  tempview_no := tempview_no +1;
  setlength(tempview,tempview_no +1);
  tempview[tempview_no].X := Max(Xpos,Xpos2);
  tempview[tempview_no].Y := y;
  tempview[tempview_no].colour_used := true;
  tempview[tempview_no].colour := OpositeColour(SHPPalette[SHP.Data[Current_Frame.Value].FrameImage[Max(Xpos,Xpos2),y]]);
  end
  else
  c := 0;
  end;
end;

function darkenlightenv(Darken:boolean; Current_Value,Value : byte) : byte;
var temp : word;
begin

if darken then
temp := Current_Value - Value
else
temp := Current_Value + Value;

if temp < 1 then
temp := 0-temp;

if temp > 255 then
temp := temp - 255;

Result := temp;

end;

// File: FormMain.pas
// Original Procedure Name: procedure TFrmMain.BrushToolDarkenLighten(Xc,Yc,Zc: Integer; V: TVoxelUnpacked; BrushMode: Integer; BrushView: EVoxelViewOrient);
// BrushToolDarkenLighten Code Taken From Voxel Section Editor and adapted to this program

// BrushToolDarkenLighten modifyed by Stucuk from TVoxelSection.BrushTool
procedure TFrmMain.BrushToolDarkenLighten(Xc,Yc: Integer; BrushMode: Integer);
var
  Shape: Array[-5..5,-5..5] of 0..1;
  i,j,r1,r2: Integer;
  t : byte;
begin
Randomize;
  for i:=-5 to 5 do
    for j:=-5 to 5 do
      Shape[i,j]:=0;
  Shape[0,0]:=1;
  if BrushMode>=1 then begin
    Shape[0,1]:=1; Shape[0,-1]:=1; Shape[1,0]:=1; Shape[-1,0]:=1;
  end;
  if BrushMode>=2 then begin
    Shape[1,1]:=1; Shape[1,-1]:=1; Shape[-1,-1]:=1; Shape[-1,1]:=1;
  end;
  if BrushMode>=3 then begin
    Shape[0,2]:=1; Shape[0,-2]:=1; Shape[2,0]:=1; Shape[-2,0]:=1;
  end;

  if BrushMode =4 then begin
  for i:=-5 to 5 do
    for j:=-5 to 5 do
      Shape[i,j]:=0;

  for i:=1 to 4 do
  begin
  r1 := random(7)-3; r2 := random(7)-3;
  Shape[r1,r2]:=1;
  end;
  end;
  //Brush completed, now actually use it!
  //for every pixel of the brush, check if we need to draw it (Shape),
  for i:=-5 to 5 do begin
    for j:=-5 to 5 do begin
      if Shape[i,j]=1 then begin
        t := SHP.Data[Current_Frame.Value].FrameImage[Max(Min(Xc+i,SHP.Header.Width-1),0),Max(Min(Yc+j,SHP.Header.Height-1),0)];
        SHP.Data[Current_Frame.Value].FrameImage[Max(Min(Xc+i,SHP.Header.Width-1),0),Max(Min(Yc+j,SHP.Header.Height-1),0)] := darkenlightenv(DarkenLighten_B,t,DarkenLighten_N);
      end;
    end;
  end;
end;

// File: FormMain.pas
// Original Procedure Name: procedure TFrmMain.BrushToolDarkenLighten(Xc,Yc,Zc: Integer; V: TVoxelUnpacked; BrushMode: Integer; BrushView: EVoxelViewOrient);
// BrushToolDarkenLighten Code Taken From Voxel Section Editor and adapted to this program

// BrushTool modifyed by Stucuk from TVoxelSection.BrushToolDarkenLighten
procedure TFrmMain.BrushTool(Xc,Yc,BrushMode,Colour: Integer);
var
  Shape: Array[-5..5,-5..5] of 0..1;
  i,j,r1,r2: Integer;
begin
Randomize;
//SetLength(TempView,0);
//TempView_no := 0;

  for i:=-5 to 5 do
    for j:=-5 to 5 do
      Shape[i,j]:=0;
  Shape[0,0]:=1;
  if BrushMode>=1 then begin
    Shape[0,1]:=1; Shape[0,-1]:=1; Shape[1,0]:=1; Shape[-1,0]:=1;
  end;
  if BrushMode>=2 then begin
    Shape[1,1]:=1; Shape[1,-1]:=1; Shape[-1,-1]:=1; Shape[-1,1]:=1;
  end;
  if BrushMode>=3 then begin
    Shape[0,2]:=1; Shape[0,-2]:=1; Shape[2,0]:=1; Shape[-2,0]:=1;
  end;

  if BrushMode =4 then begin
  for i:=-5 to 5 do
    for j:=-5 to 5 do
      Shape[i,j]:=0;

  for i:=1 to 4 do
  begin
  r1 := random(7)-3; r2 := random(7)-3;
  Shape[r1,r2]:=1;
  end;
  end;
  //Brush completed, now actually use it!
  //for every pixel of the brush, check if we need to draw it (Shape),
  for i:=-5 to 5 do begin
    for j:=-5 to 5 do begin
      if Shape[i,j]=1 then begin
      inc(TempView_no);
       SetLength(TempView,TempView_no+1);
       TempView[TempView_no].X := Max(Min(Xc+i,SHP.Header.Width-1),0);
       TempView[TempView_no].Y := Max(Min(Yc+j,SHP.Header.Height-1),0);
      // SHP.Data[Current_Frame.Value].FrameImage[,] := Colour;
      end;
    end;
  end;
end;

procedure TFrmMain.SpeedButton7Click(Sender: TObject);
begin
SelectData.HasSource := false;
DrawMode := dmflood;
TempView_no := 0; // Clear Temp view;
Current_FrameChange(Sender);
Image1.Cursor := MouseFill;
end;

procedure TFrmMain.PaintBox1Paint(Sender: TObject);
begin
Current_FrameChange(Sender);
end;

procedure TFrmMain.SpeedButton3Click(Sender: TObject);
begin
Drawmode := dmRectangle;
TempView_no := 0; // Clear Temp view;
Current_FrameChange(Sender);
Image1.Cursor := MouseLine;

SelectData.HasSource := false;
end;

procedure TFrmMain.SpeedButton8Click(Sender: TObject);
begin
SelectData.HasSource := false;
Drawmode := dmRectangle_Fill;
TempView_no := 0; // Clear Temp view;
Current_FrameChange(Sender);
Image1.Cursor := MouseLine;
end;

procedure TFrmMain.SpeedButton4Click(Sender: TObject);
begin
DrawMode := dmErase;
TempView_no := 0; // Clear Temp view;
Current_FrameChange(Sender);
Image1.Cursor := MouseLine;

SelectData.HasSource := false;
end;

procedure TFrmMain.Copy1Click(Sender: TObject);
begin
Clipboard.Clear;
Clipboard.Assign(GetBMPOfFrameImage(SHP,Current_Frame.Value,SHPPalette));
//image1.Picture.Bitmap := GetBMPOfFrameImage(SHP,Current_Frame.Value,SHPPalette);
end;

procedure TFrmMain.PasteFrame1Click(Sender: TObject);
var
Bitmap : TBitmap;
x,y : integer;
begin
if not iseditable then Exit;
if Not Clipboard.HasFormat(CF_BITMAP) then Exit; // No Bitmaps In Clipboard...

Bitmap := TBitmap.Create;

Bitmap.Assign(Clipboard);

For x := 0 to min(Bitmap.Width-1,SHP.Header.Width-1) do
For y := 0 to min(Bitmap.Height-1,SHP.Header.Height-1) do
SHP.Data[Current_Frame.Value].FrameImage[x,y] := getpalettecolour2(SHPPalette,Bitmap.Canvas.Pixels[x,y],SHPPalette[0],alg,false,false);

// Setup Selection Tool
SelectData.HasSource := true;
SelectData.SourceData.X1 := 0;
SelectData.SourceData.Y1 := 0;
SelectData.SourceData.X2 := bitmap.Width-1;
SelectData.SourceData.Y2 := bitmap.Height-1;

DrawMode := dmselect; // Set Select mode;
SpeedButton10.Down := true; // make select button down.

Rectangle_dotted(SelectData.SourceData.X1,SelectData.SourceData.Y1,SelectData.SourceData.X2,SelectData.SourceData.Y2);

Bitmap.Free;
Current_FrameChange(Sender);
end;

procedure TFrmMain.SpeedButton9Click(Sender: TObject);
var
  frmReplaceColou: TfrmReplaceColour;
begin
if not isEditable then exit;

  frmReplaceColou:=TfrmReplaceColour.Create(Self);
  with frmReplaceColou do begin
    ShowModal;
    Free;
  end;
end;

function TFrmMain.LoadPalettesMenu : integer;
var     f: TSearchRec;
        path: String;
    //i,count: Integer;
    Filename : string;
    item: TMenuItem;
    c,t : integer;
begin
        // prepare
        c := 0;
// Now Load TS Palettes

        SetLength(PaletteSchemes,c);
        iberianSun1.Visible := false;

        path := Concat(ExtractFilePath(ParamStr(0))+'\Palettes\TS\','*.pal');

        // find files
        if FindFirst(path,faAnyFile,f) = 0 then repeat

Filename := Concat(ExtractFilePath(ParamStr(0))+'\Palettes\TS\',f.Name);


inc(c);
SetLength(PaletteSchemes,c+1);

PaletteSchemes[c].FileName := Filename;
PaletteSchemes[c].ImageIndex := 0;

     item := TMenuItem.Create(Owner);
     item.Caption := extractfilename(PaletteSchemes[c].FileName);
     item.Tag := c; // so we know which it is
     item.OnClick := LoadPaletteSchemeClick;

     iberianSun1.Insert(c,item);
     iberianSun1.visible := true;

     until FindNext(f) <> 0;
        FindClose(f);

t := c;

// Now Load RA2 Palettes

        SetLength(PaletteSchemes,c+1);
        RedAlert21.Visible := false;

        path := Concat(ExtractFilePath(ParamStr(0))+'\Palettes\RA2\','*.pal');

        // find files
        if FindFirst(path,faAnyFile,f) = 0 then repeat

Filename := Concat(ExtractFilePath(ParamStr(0))+'\Palettes\RA2\',f.Name);


inc(c);
SetLength(PaletteSchemes,c+1);

PaletteSchemes[c].FileName := Filename;
PaletteSchemes[c].ImageIndex := 2;

     item := TMenuItem.Create(Owner);
     item.Caption := extractfilename(PaletteSchemes[c].FileName);
     item.Tag := c; // so we know which it is
     item.OnClick := LoadPaletteSchemeClick;

     RedAlert21.Insert(c-t,item);
     RedAlert21.visible := true;

     until FindNext(f) <> 0;
        FindClose(f);

Result := c; // Add TS Palette numebr to RA2's
end;

procedure TFrmMain.LoadPaletteSchemeClick(Sender: TObject);
begin
LoadPaletteFromFile(PaletteSchemes[TMenuItem(Sender).Tag].FileName);
PaletteLoaded(PaletteSchemes[TMenuItem(Sender).Tag].FileName);
end;

procedure TFrmMain.SpeedButton5Click(Sender: TObject);
begin
SelectData.HasSource := false;

  if pnlbump.visible = true then
  begin
  HidePanels;
  pnlbump.visible := false;
  exit;
  end;

HidePanels;
pnlbump.visible := true;

DrawMode := dmdarkenlighten;
DarkenLighten_B := false;
TempView_no := 0; // Clear Temp view;
Current_FrameChange(Sender);
Image1.Cursor := MouseBrush;
end;

procedure TFrmMain.SpeedButton11Click(Sender: TObject);
begin
DrawMode := dmdarkenlighten;
DarkenLighten_B := false;
hidepanels;
end;

procedure TFrmMain.SpeedButton12Click(Sender: TObject);
begin
DrawMode := dmdarkenlighten;
DarkenLighten_B := true;
hidepanels;
end;

procedure TFrmMain.hidepanels;
begin
pnlbump.visible := false;
end;

procedure TFrmMain.SpeedButton13Click(Sender: TObject);
begin
hidepanels;
frmdarkenlightentool.showmodal;
end;

procedure TFrmMain.Preferences1Click(Sender: TObject);
begin
FrmPreferences.showmodal;
end;

Procedure TFrmMain.LoadASHP(file_name :string);
var
Sender : tobject; //Fake Sender Varible
begin

LoadSHP(file_name,SHP);
CreateFrameImages(SHP);

Filename := file_name;
Caption := SHP_BUILDER_TITLE + ' ' + SHP_BUILDER_VER +  ' - ['+extractfilename(Filename)+']';

StatusBar1.Panels[3].Text := 'Width: ' + inttostr(SHP.Header.Width) + ' Height: ' + inttostr(SHP.Header.Height);

FrmPreview.TrackBar1.Position := 1;

SetShadowMode(HasShadows(SHP));

if Shadowmode then
FrmPreview.TrackBar1.Max := SHP.Header.NumImages div 2
else
FrmPreview.TrackBar1.Max := SHP.Header.NumImages;

StatusBar1.Panels[1].Text := 'SHP Type: ' + GetSHPType(SHP);

if PalettePrefrenceData.GameSpecific then
if SHP.SHPType = stCameo then
SetPalette(PalettePrefrenceData.CameoPalette.Filename)
else
if SHP.SHPType = stUnit then
SetPalette(PalettePrefrenceData.UnitPalette.Filename)
else
if SHP.SHPType = stBuilding then
SetPalette(PalettePrefrenceData.BuildingPalette.Filename)
else
if SHP.SHPType = stAnimation then
SetPalette(PalettePrefrenceData.AnimationPalette.Filename);

SetIsEditable(True);

Current_Frame.value := 1;
Current_FrameChange(Sender);
FrmPreview.TrackBar1Change(Sender);
end;

Procedure TFrmMain.LoadConfig(filename:string);
var
f : file;
key : string[10];
begin

     AssignFile(F,Filename);  // Open file
     Reset(F,1); // Goto first byte?

     Key := CONFIG_KEY;

     BlockRead(F,Key,SizeOf(Key));

     if Key = '1.0' then
     begin
     BlockRead(F,FileAssosiationsPreferenceData,Sizeof(FileAssosiationsPreferenceData));
     BlockRead(F,PalettePrefrenceData,Sizeof(PalettePrefrenceData));
     BlockRead(F,alg,Sizeof(alg));
     end;
     
     CloseFile(F);

end;

Procedure TFrmMain.SaveConfig(filename:string);
var
f : file;
key : string[10];
begin

     AssignFile(F,Filename);  // Open file
     Rewrite(F,1); // Goto first byte?

     Key := CONFIG_KEY;
     Blockwrite(F,Key,SizeOf(Key));
     Blockwrite(F,FileAssosiationsPreferenceData,Sizeof(FileAssosiationsPreferenceData));
     Blockwrite(F,PalettePrefrenceData,Sizeof(PalettePrefrenceData));
     Blockwrite(F,alg,Sizeof(alg));
     CloseFile(F);

end;

procedure TFrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
SaveConfig(extractfiledir(ParamStr(0))+'\SHP_BUILDER.dat');
end;

Procedure TFrmMain.SetPalette(Filename:string);
begin
LoadPaletteFromFile(filename);
PaletteLoaded(filename);
end;

procedure TFrmMain.SetShadowMode(Value : boolean);
var
Sender : tobject; // fake sender
begin
Shadowmode := value;
urnToCameoMode1.Checked := value;
AutoShadows1.Enabled := value;

if Shadowmode = false then
begin
FrmPreview.TrackBar1.Max := SHP.Header.NumImages;
FrmPreview.TrackBar1Change(Sender); // Update Preview
StatusBar1.Panels[4].Text := 'Shadows Off';
lbl_total_frames.Caption := inttostr(SHP.Header.NumImages);
end
else
begin
FrmPreview.TrackBar1.Max := SHP.Header.NumImages div 2;
FrmPreview.TrackBar1Change(Sender); // Update Preview
StatusBar1.Panels[4].Text := 'Shadows On';
lbl_total_frames.Caption := inttostr(SHP.Header.NumImages); // Show all
end;

cnvPalette.Refresh;
Current_FrameChange(Sender);

end;

procedure TFrmMain.InsertFrame1Click(Sender: TObject);
begin
if ShadowMode then
Insertblankframe_shadow(SHP,Current_Frame.Value)
else
Insertblankframe(SHP,Current_Frame.Value);

SetShadowMode(ShadowMode); // Fakes a shadow change so frame lengths are set

end;

procedure TFrmMain.DeleteFrame1Click(Sender: TObject);
begin
if ShadowMode then
deleteframe_shadow(SHP,Current_Frame.Value)
else
deleteframe(SHP,Current_Frame.Value);

SetShadowMode(ShadowMode); // Fakes a shadow change so frame lengths are set
end;

procedure TFrmMain.AutoShadows1Click(Sender: TObject);
begin
FrmAutoShadows.ShowModal;
end;

procedure TFrmMain.Resize1Click(Sender: TObject);
begin
FrmResize.speWidth.text := inttostr(SHP.Header.Width);
FrmResize.speHeight.text := inttostr(SHP.Header.Height);
FrmResize.showmodal;
if FrmResize.changed then
begin
try
Resize_Frames_Blocky(SHP,strtoint(FrmResize.speWidth.text),strtoint(FrmResize.speHeight.text));
except
MessageBox(0,'Error: Only numbers may be entered','Resize Error',0);
end;

StatusBar1.Panels[3].Text := 'Width: ' + inttostr(SHP.Header.Width) + ' Height: ' + inttostr(SHP.Header.Height);

Current_FrameChange(Sender);
FrmPreview.TrackBar1Change(Sender);
end;

end;

procedure TFrmMain.Brush_1Click(Sender: TObject);
begin
Brush_Type := 0;

if DrawMode = dmdraw then
Image1.Cursor := MouseDraw;
end;

procedure TFrmMain.Brush_2Click(Sender: TObject);
begin
Brush_Type := 1;

if DrawMode = dmdraw then
Image1.Cursor := MouseBrush;
end;

procedure TFrmMain.Brush_3Click(Sender: TObject);
begin
Brush_Type := 2;

if DrawMode = dmdraw then
Image1.Cursor := MouseBrush;
end;

procedure TFrmMain.Brush_4Click(Sender: TObject);
begin
Brush_Type := 3;

if DrawMode = dmdraw then
Image1.Cursor := MouseBrush;
end;

procedure TFrmMain.Brush_5Click(Sender: TObject);
begin
Brush_Type := 4;

if DrawMode = dmdraw then
Image1.Cursor := MouseSpray;
end;

procedure TFrmMain.ImportBMPs1Click(Sender: TObject);
begin
FrmImportImageAsSHP.mode := 1;
FrmImportImageAsSHP.showmodal;
end;

procedure TFrmMain.AddTocolourList(colour:byte);
var
x : byte;
begin

if Colour_list_no > 0 then
for x := 1 to Colour_list_no do
if colour = Colour_list[x].colour then
begin
Colour_list[x].count := Colour_list[x].count+1;
exit;
end;

Colour_list_no := Colour_list_no+1;
SetLength(Colour_list,Colour_list_no+1);
Colour_list[Colour_list_no].colour := colour;
Colour_list[Colour_list_no].count := 1;

end;

procedure TFrmMain.test1Click(Sender: TObject);
var
x,y,z : integer;
max,maxc,p : integer;
FrameImage : array of array of Byte;
begin
Setlength(FrameImage,SHP.Header.Width,SHP.Header.Height);

for x := 0 to SHP.Header.Width-1 do
for y := 0 to SHP.Header.Height-1 do
if SHP.Data[Current_Frame.Value].FrameImage[x,y] > 0 then
begin

Colour_list_no := 0;
SetLength(Colour_list,0);

AddTocolourList(SHP.Data[Current_Frame.Value].FrameImage[x,y]);
AddTocolourList(SHP.Data[Current_Frame.Value].FrameImage[x-1,y-1]);
AddTocolourList(SHP.Data[Current_Frame.Value].FrameImage[x,y-1]);
AddTocolourList(SHP.Data[Current_Frame.Value].FrameImage[x+1,y-1]);
AddTocolourList(SHP.Data[Current_Frame.Value].FrameImage[x-1,y]);
AddTocolourList(SHP.Data[Current_Frame.Value].FrameImage[x-1,y+1]);
AddTocolourList(SHP.Data[Current_Frame.Value].FrameImage[x,y+1]);
AddTocolourList(SHP.Data[Current_Frame.Value].FrameImage[x+1,y+1]);
AddTocolourList(SHP.Data[Current_Frame.Value].FrameImage[x+1,y]);

max := -1;
maxc := -1;
p := 0;

if Colour_list_no > 0 then
for z := 1 to Colour_list_no do
if Colour_list[z].count > max then
begin
max := Colour_list[z].count;
maxc := z;
if Colour_list[z].colour = 0 then
p := Colour_list[z].count;
end;

if p > 2 then
FrameImage[x,y] := Colour_list[maxc].colour
else
FrameImage[x,y] := SHP.Data[Current_Frame.Value].FrameImage[x,y];
end
else
FrameImage[x,y] := SHP.Data[Current_Frame.Value].FrameImage[x,y];

for x := 0 to SHP.Header.Width-1 do
for y := 0 to SHP.Header.Height-1 do
SHP.Data[Current_Frame.Value].FrameImage[x,y] := FrameImage[x,y];


Current_FrameChange(Sender);
end;

procedure TFrmMain.SHPBMPs1Click(Sender: TObject);
var
Bitmap : TBitmap;
x : integer;
filename,dir,ext,temp : string;
begin
if SavePictureDialog.Execute then
begin
Bitmap := TBitmap.Create;

dir := ExtractFileDir(SavePictureDialog.FileName);
filename := copy(extractfilename(SavePictureDialog.FileName),0,length(extractfilename(SavePictureDialog.FileName))-length(ExtractFileExt(SavePictureDialog.FileName)));
ext := extractfileext(SavePictureDialog.FileName);

if not (copy(dir,length(dir),1) = '\') then
filename := '\' + filename + ' ';

for x := 1 to SHP.Header.NumImages do
begin
Bitmap := GetBMPOfFrameImage(SHP,X,SHPPalette);

temp := inttostr(x-1);

if length(temp) < 4 then
repeat
temp := '0' + temp;
until length(temp) = 4;

SaveImageFileFromBMP(Dir+filename+temp+ext,Bitmap);
end;

Bitmap.Free;
Messagebox(0,'Operation Compleate','SHP -> Image`s',0);
end;
end;

procedure TFrmMain.ToolButton12Click(Sender: TObject);
begin
show_center := not show_center;
ToolButton12.Down := show_center;

Current_FrameChange(Sender);
end;

procedure TFrmMain.FixShadows1Click(Sender: TObject);
var
bgcolour : byte;
x,xx,yy : integer;
begin
if not ShadowMode then
begin
MessageBox(0,'Error Shadows are OFF','Fix Shadow Error',0);
exit;
end;

BGColour := SHP.Data[(SHP.Header.NumImages div 2)+1].FrameImage[0,0];

for x := (SHP.Header.NumImages div 2)+1 to SHP.Header.NumImages do
begin
for xx := 0 to SHP.Header.Width-1 do
for yy := 0 to SHP.Header.Height-1 do
if SHP.Data[x].FrameImage[xx,yy] = BGColour then
SHP.Data[x].FrameImage[xx,yy] := 0
else
SHP.Data[x].FrameImage[xx,yy] := 1;
end;

Current_FrameChange(Sender);
Messagebox(0,'Shadows Fixed','Fix Shadow',0);
end;

procedure TFrmMain.FrameImage1Click(Sender: TObject);
var
Bitmap : TBitmap;
filename,dir,ext,temp : string;
begin
if SavePictureDialog.Execute then
begin
Bitmap := TBitmap.Create;

dir := ExtractFileDir(SavePictureDialog.FileName);
filename := copy(extractfilename(SavePictureDialog.FileName),0,length(extractfilename(SavePictureDialog.FileName))-length(ExtractFileExt(SavePictureDialog.FileName)));
ext := extractfileext(SavePictureDialog.FileName);

if not (copy(dir,length(dir),1) = '\') then
filename := '\' + filename + ' ';

Bitmap := GetBMPOfFrameImage(SHP,Current_Frame.Value,SHPPalette);

temp := inttostr(Current_Frame.Value-1);

if length(temp) < 4 then
repeat
temp := '0' + temp;
until length(temp) = 4;

SaveImageFileFromBMP(Dir+filename+temp+ext,Bitmap);


Bitmap.Free;
Messagebox(0,'Operation Compleate','Frame -> Image',0);
end;
end;

procedure TFrmMain.SpeedButton10Click(Sender: TObject);
begin
DrawMode := dmselect;
TempView_no := 0; // Clear Temp view;
Current_FrameChange(Sender);

Image1.Cursor := CrArrow;
SelectData.HasSource := false;

end;

procedure TFrmMain.ImageSHP1Click(Sender: TObject);
begin
FrmImportImageAsSHP.mode := 0;
FrmImportImageAsSHP.ShowModal;
end;

procedure TFrmMain.Copy2Click(Sender: TObject);
var
x,y,XMin,XMax,YMin,YMax : integer;
Bitmap : TBitmap;
begin
if not iseditable then Exit;

if not SelectData.HasSource then
begin
Copy1Click(sender); // No Selection made, copy entire frame
exit;
end;

Bitmap := TBitmap.Create;

XMin := Min(SelectData.SourceData.X1,SelectData.SourceData.X2);
XMax := Max(SelectData.SourceData.X1,SelectData.SourceData.X2);

YMin := Min(SelectData.SourceData.Y1,SelectData.SourceData.Y2);
YMax := Max(SelectData.SourceData.Y1,SelectData.SourceData.Y2);

Bitmap.Width := XMax-XMin;
Bitmap.Height := YMax-YMin;

for x := XMin to XMax do
for y := YMin to YMax do
Bitmap.Canvas.Pixels[x-XMin,y-YMin] := SHPPalette[SHP.Data[Current_Frame.Value].FrameImage[x,y]];

Clipboard.Clear;
Clipboard.Assign(Bitmap);

Bitmap.Free;
end;

procedure TFrmMain.Cut1Click(Sender: TObject);
var
x,y,XMin,XMax,YMin,YMax : integer;
begin
if not iseditable then Exit;


if not SelectData.HasSource then
begin
Copy1Click(sender); // No Selection made, copy entire frame
exit;
end;

Copy2Click(Sender); // Copy Selection To Clipboard...

XMin := Min(SelectData.SourceData.X1,SelectData.SourceData.X2);
XMax := Max(SelectData.SourceData.X1,SelectData.SourceData.X2);

YMin := Min(SelectData.SourceData.Y1,SelectData.SourceData.Y2);
YMax := Max(SelectData.SourceData.Y1,SelectData.SourceData.Y2);

for x := XMin to XMax do
for y := YMin to YMax do
SHP.Data[Current_Frame.Value].FrameImage[x,y] := 0;

SelectData.HasSource := false; // Area cut, clear selection

Current_FrameChange(Sender);
end;

procedure TFrmMain.Sequence1Click(Sender: TObject);
begin
FrmSequence.showmodal;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
PaintAreaPanel.DoubleBuffered := true;
end;

end.
