unit FormReplaceColour;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls,math, StdCtrls,shp_file,shp_engine,palette,
  Shp_Engine_Image, ComCtrls;

type
  TfrmReplaceColour = class(TForm)
    Panel1: TPanel;
    cnvPalette: TPaintBox;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Panel3: TPanel;
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    Bevel1: TBevel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    Label3: TLabel;
    Label4: TLabel;
    Panel4: TPanel;
    Panel5: TPanel;
    Label5: TLabel;
    Label6: TLabel;
    Panel6: TPanel;
    Panel7: TPanel;
    Label7: TLabel;
    Label8: TLabel;
    Panel8: TPanel;
    Panel9: TPanel;
    Label9: TLabel;
    Label10: TLabel;
    Panel10: TPanel;
    Panel11: TPanel;
    Label11: TLabel;
    Label12: TLabel;
    ApplyToAll: TCheckBox;
    ProgressBar1: TProgressBar;
    procedure cnvPalettePaint(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cnvPaletteMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button2Click(Sender: TObject);
    procedure lowerpannels;
    procedure Panel3Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure CheckBox5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    replacecolour : byte;
    PaletteMax : word;
  end;

var
  frmReplaceColour: TfrmReplaceColour;

implementation

uses FormMain;

{$R *.dfm}

procedure TfrmReplaceColour.lowerpannels;
begin
Panel2.BevelOuter := bvLowered;
Panel3.BevelOuter := bvLowered;
Panel4.BevelOuter := bvLowered;
Panel5.BevelOuter := bvLowered;
Panel6.BevelOuter := bvLowered;
Panel7.BevelOuter := bvLowered;
Panel8.BevelOuter := bvLowered;
Panel9.BevelOuter := bvLowered;
Panel10.BevelOuter := bvLowered;
Panel11.BevelOuter := bvLowered;
end;

procedure SplitColour(raw: TColor; var red, green, blue: Byte);
begin
     red := (raw and $00FF0000) shr 16;
     green := (raw and $0000FF00) shr 8;
     blue := raw and $000000FF;
end;

procedure TfrmReplaceColour.cnvPalettePaint(Sender: TObject);
var colwidth, rowheight: Real;
    i, j, idx: Integer;
    r: TRect;
begin
     colwidth := cnvPalette.Width / 8;
     rowheight := cnvPalette.Height / 32;
     idx := 0;
     PaletteMax := 256;

     if IsShadow(FrmMain.SHP,FrmMain.Current_Frame.Value) then
     PaletteMax := 2;


     for i := 0 to 8 do begin
         r.Left := Trunc(i * colwidth);
         r.Right := Ceil(r.Left + colwidth);
         for j := 0 to 31 do begin
             r.Top := Trunc(j * rowheight);
             r.Bottom := Ceil(r.Top + rowheight);
             if Idx < PaletteMax then
             with cnvPalette.Canvas do begin

                  Brush.Color := SHPPalette[idx];
                  FillRect(r);
             end;
             Inc(Idx);
         end;
     end;
end;

procedure TfrmReplaceColour.Button1Click(Sender: TObject);
var
x,y,Frame,FS,FE : integer;
begin

if ApplyToAll.Checked then
begin
FS := 1;
FE := FrmMain.SHP.Header.NumImages;
ProgressBar1.Position := 1;
ProgressBar1.MAX := FE;
ProgressBar1.Visible := true;
end
else
begin
FS := FrmMain.Current_Frame.value;
FE := FS;
end;

for Frame := FS to FE do
for x := 0 to FrmMain.SHP.Header.Width -1 do
for y := 0 to FrmMain.SHP.Header.Height-1 do
begin

if ProgressBar1.Visible then
begin
ProgressBar1.Position := Frame;
//ProgressBar1.Refresh;
end;

if CheckBox1.Checked then
if FrmMain.SHP.Data[Frame].FrameImage[x,y] = strtoint(Label3.caption) then
FrmMain.SHP.Data[Frame].FrameImage[x,y] := strtoint(Label4.caption);

if CheckBox2.Checked then
if FrmMain.SHP.Data[Frame].FrameImage[x,y] = strtoint(Label5.caption) then
FrmMain.SHP.Data[Frame].FrameImage[x,y] := strtoint(Label6.caption);


if CheckBox3.Checked then
if FrmMain.SHP.Data[Frame].FrameImage[x,y] = strtoint(Label7.caption) then
FrmMain.SHP.Data[Frame].FrameImage[x,y] := strtoint(Label8.caption);


if CheckBox4.Checked then
if FrmMain.SHP.Data[Frame].FrameImage[x,y] = strtoint(Label9.caption) then
FrmMain.SHP.Data[Frame].FrameImage[x,y] := strtoint(Label10.caption);


if CheckBox5.Checked then
if FrmMain.SHP.Data[Frame].FrameImage[x,y] = strtoint(Label11.caption) then
FrmMain.SHP.Data[Frame].FrameImage[x,y] := strtoint(Label12.caption);
end;
FrmMain.Current_FrameChange(Sender);

Close;
end;

procedure TfrmReplaceColour.FormShow(Sender: TObject);
begin
     begin
     panel2.Color := SHPPalette[frmmain.ActiveColour];
     replacecolour := frmmain.ActiveColour;
     Label3.caption := ''+inttostr(frmmain.ActiveColour);
     panel3.Color := SHPPalette[0];
     Label4.caption := ''+inttostr(0);
     ApplyToAll.Checked := false;
     end;
end;

procedure TfrmReplaceColour.cnvPaletteMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var colwidth, rowheight: Real;
    i, j, idx: Integer;
begin

     colwidth := cnvPalette.Width / 8;
     rowheight := cnvPalette.Height / 32;
     i := Trunc(X / colwidth);
     j := Trunc(Y / rowheight);
     idx := (i * 32) + j;
     if idx < PaletteMax then
     begin
     if panel2.BevelOuter = bvRaised then
     panel2.Color := SHPPalette[idx];
     if panel3.BevelOuter = bvRaised then
     panel3.Color := SHPPalette[idx];
     if panel4.BevelOuter = bvRaised then
     panel4.Color := SHPPalette[idx];
     if panel5.BevelOuter = bvRaised then
     panel5.Color := SHPPalette[idx];
     if panel6.BevelOuter = bvRaised then
     panel6.Color := SHPPalette[idx];
     if panel7.BevelOuter = bvRaised then
     panel7.Color := SHPPalette[idx];
     if panel8.BevelOuter = bvRaised then
     panel8.Color := SHPPalette[idx];
     if panel9.BevelOuter = bvRaised then
     panel9.Color := SHPPalette[idx];
     if panel10.BevelOuter = bvRaised then
     panel10.Color := SHPPalette[idx];
     if panel11.BevelOuter = bvRaised then
     panel11.Color := SHPPalette[idx];
     replacecolour := idx;
     end;

     if panel2.BevelOuter = bvRaised then
     Label3.caption := ''+inttostr(replacecolour);
     if panel3.BevelOuter = bvRaised then
     Label4.caption := ''+inttostr(replacecolour);
     if panel4.BevelOuter = bvRaised then
     Label5.caption := ''+inttostr(replacecolour);
     if panel5.BevelOuter = bvRaised then
     Label6.caption := ''+inttostr(replacecolour);
     if panel6.BevelOuter = bvRaised then
     Label7.caption := ''+inttostr(replacecolour);
     if panel7.BevelOuter = bvRaised then
     Label8.caption := ''+inttostr(replacecolour);
     if panel8.BevelOuter = bvRaised then
     Label9.caption := ''+inttostr(replacecolour);
     if panel9.BevelOuter = bvRaised then
     Label10.caption := ''+inttostr(replacecolour);
     if panel10.BevelOuter = bvRaised then
     Label11.caption := ''+inttostr(replacecolour);
     if panel11.BevelOuter = bvRaised then
     Label12.caption := ''+inttostr(replacecolour);
end;

procedure TfrmReplaceColour.Button2Click(Sender: TObject);
begin
close;
end;

procedure TfrmReplaceColour.Panel3Click(Sender: TObject);
begin
lowerpannels;
tpanel(sender).BevelOuter := bvRaised;
end;

procedure TfrmReplaceColour.CheckBox2Click(Sender: TObject);
begin
if (Label5.caption = '') or (Label6.caption = '') then
CheckBox2.Checked := false;
end;

procedure TfrmReplaceColour.CheckBox3Click(Sender: TObject);
begin
if (Label7.caption = '') or (Label8.caption = '') then
CheckBox3.Checked := false;
end;

procedure TfrmReplaceColour.CheckBox4Click(Sender: TObject);
begin
if (Label9.caption = '') or (Label10.caption = '') then
CheckBox4.Checked := false;
end;

procedure TfrmReplaceColour.CheckBox5Click(Sender: TObject);
begin
if (Label11.caption = '') or (Label12.caption = '') then
CheckBox5.Checked := false;
end;

end.
