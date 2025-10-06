unit FormImportImageAsSHP;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ExtDlgs, FileCtrl,shp_file,shp_engine,palette,
  Shp_Engine_Image, ComCtrls, math, Spin;

type
  TFrmImportImageAsSHP = class(TForm)
    Label1: TLabel;
    Image_Location: TEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Bevel1: TBevel;
    OpenPictureDialog: TOpenPictureDialog;
    FileListBox: TFileListBox;
    ProgressBar: TProgressBar;
    ccmStu: TRadioButton;
    ccmBanshee: TRadioButton;
    OpenPictureDialog1: TOpenPictureDialog;
    bcDefault: TRadioButton;
    bcCustom: TRadioButton;
    bcAutoSelect: TRadioButton;
    ColourConversionBox: TGroupBox;
    BackgroundOverrideBox: TGroupBox;
    bcNone: TRadioButton;
    ConversionOptimizeBox: TGroupBox;
    ocfTS: TRadioButton;
    ocfRA2: TRadioButton;
    ocfComboOptions: TComboBox;
    ocfNone: TRadioButton;
    ConversionRangeBox: TGroupBox;
    crAllFrames: TRadioButton;
    crCustomFrames: TRadioButton;
    Label2: TLabel;
    crFrom: TSpinEdit;
    crTo: TSpinEdit;
    Label3: TLabel;
    ColorDialog1: TColorDialog;
    ccmStu2: TRadioButton;
    ccmBanshee2: TRadioButton;
    SplitShadowBox: TGroupBox;
    ssShadow: TCheckBox;
    bcColourEdit: TPanel;
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SingleLoadImage;
    procedure MassLoadImage;
    procedure bcColourEditChange(Sender: TObject);
    procedure bcAutoSelectClick(Sender: TObject);
    procedure bcDefaultClick(Sender: TObject);
    procedure bcCustomClick(Sender: TObject);
    procedure bcNoneClick(Sender: TObject);
    procedure crFromChange(Sender: TObject);
    procedure crToChange(Sender: TObject);
    procedure AutoSelectBackground;
    procedure ocfTSClick(Sender: TObject);
    procedure ocfRA2Click(Sender: TObject);
    procedure ocfNoneClick(Sender: TObject);
    procedure ocfComboOptionsChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    bgcolour : Tcolor;
    mode : integer;
    maxframes : integer;
    CustomPalette : TPalette;
  end;

var
  FrmImportImageAsSHP: TFrmImportImageAsSHP;

implementation

uses FormMain, FormPreview{, FormManualColourMatch};

{$R *.dfm}

procedure TFrmImportImageAsSHP.Button3Click(Sender: TObject);
begin
Close;
end;

procedure TFrmImportImageAsSHP.Button1Click(Sender: TObject);
var
   x:integer;
   temp,filename : string;
   ImageList : TStringList;
begin
if mode = 1 then
if OpenPictureDialog.Execute then
begin
   Image_Location.Text := OpenPictureDialog.FileName;

if fileexists(Image_Location.Text) then
begin
   // First Part:
   // The following code detects the max ammount of frames

   // Creates the string list
   ImageList := TStringList.Create;

   // these files all files in the dir image*.bmp (so, it gets 0000, to XXXX)
   FileListBox.Directory := ExtractFileDir(Image_Location.Text);
   FileListBox.mask := copy(Image_Location.Text,0,length(Image_Location.Text)- length('0000' +ExtractFileExt(Image_Location.Text)))+'*' + ExtractFileExt(Image_Location.Text);

   // removes the 0000 and extension from filename, so, you can load 0000 to XXXX (check below)
   filename := copy(extractfilename(Image_Location.Text),0,length(extractfilename(Image_Location.Text))-length('0000'+ExtractFileExt(Image_Location.Text)));

   // this is probably a hack to avoid problems on loading
   // on root like C:\image 0000.bmp, D:\image 0000.bmp, etc...
   if not (copy(FileListBox.Directory,length(FileListBox.Directory),1) = '\') then
      filename := '\' + filename;

   ImageList.Clear;

   // Fixes prob with mask system finding wrong files.
   For x := 0 to FileListBox.Items.Count-1 do
   begin
      temp := inttostr(x);
      if length(temp) < 4 then
      repeat
         Temp := '0' + Temp;
      until length(temp) = 4;

      if fileexists(FileListBox.Directory+filename+temp+ExtractFileExt(Image_Location.Text)) then
         ImageList.Add(FileListBox.Directory+filename+temp+ExtractFileExt(Image_Location.Text));
   end;
   maxframes := ImageList.Count;

   // Second Part: Interface
   // Enable Options
   ConversionOptimizeBox.Enabled := true;
   ConversionRangeBox.Enabled := true;
   ColourConversionBox.Enabled := true;
   ConversionOptimizeBox.Enabled := true;
   BackgroundOverrideBox.Enabled := true;
   bcColourEdit.Enabled := true;
   Button2.Enabled := true;
   ssShadow.Enabled := true;

   // Code below selects all frames and adds the max frame
   // in the Conversion Range settings
   crTo.Value := maxframes - 1;
   crAllFrames.Checked := true;

   // Code below selects 'Auto Select' options as default
   AutoSelectBackground;
   bcAutoSelect.Checked := true;

   // Code below selects 'None" option for optimize
   ocfNone.Checked := true;

   // Code below selects 'R+G+B Full Difference' for method
   ccmBanshee2.Checked := true;
end;
end;


if mode = 0 then
if OpenPictureDialog1.Execute then
begin
   Image_Location.Text := OpenPictureDialog1.FileName;

   // Interface Stuff
   // Enable Options
   ConversionOptimizeBox.Enabled := true;
   ConversionRangeBox.Enabled := false;
   ColourConversionBox.Enabled := true;
   ConversionOptimizeBox.Enabled := true;
   BackgroundOverrideBox.Enabled := true;
   bcColourEdit.Enabled := true;
   Button2.Enabled := true;
   ssShadow.Checked := false;

   // Code below selects all frames and adds the max frame
   // in the Conversion Range settings
   crTo.Value := 0;
   crAllFrames.Checked := true;

   // Code below selects 'Auto Select' options as default
   AutoSelectBackground;
   bcAutoSelect.Checked := true;

   // Code below selects 'None" option for optimize
   ocfNone.Checked := true;

   // Code below selects 'R+G+B Full Difference' for method
   ccmBanshee2.Checked := true;

end;
end;

function colourtogray(colour : cardinal): cardinal;
var
temp : char;
begin
  temp := char((GetBValue(colour)*29 + GetGValue(colour)*150 + GetRValue(colour)*77) DIV 256);
  Result := RGB(ord(temp),ord(temp),ord(temp));
end;

Function GrayBitmap(var Bitmap:TBitmap; const x,y : integer) : Tbitmap;
var
Temp : Tbitmap;
xx,yy : integer;
begin
Temp := TBitmap.Create;

Temp.Width := Bitmap.Width;
Temp.Height := Bitmap.Height;

for xx := 0 to Bitmap.Width-1 do
for yy := 0 to Bitmap.Height-1 do
if ((xx <> x) and (yy <> y)) or ((xx = x) and (yy = y)) then
Temp.Canvas.Pixels[xx,yy] := Bitmap.Canvas.Pixels[xx,yy]
else
Temp.Canvas.Pixels[xx,yy] := colourtogray(Bitmap.Canvas.Pixels[xx,yy]);


Result := Temp;
end;


procedure TFrmImportImageAsSHP.Button2Click(Sender: TObject);
begin
//FrmManualColourMatch.backdoor := false;

        // If file doesnt exist, it gives an error message.
        if not fileexists(Image_Location.Text) then
        begin
        MessageBox(0,'Error: No Image Location Specified','Import Error',0);
        Exit;
        end;

        // this will convert the image.
        if (mode = 1) then
            MassLoadImage
        else
            SingleLoadImage;

        // Below is code copyed from FrmMain, File -> New

// Locks FormMain until it's set to the new file
FrmMain.SetIsEditable(False);
FrmMain.Filename := ''; // New file must have blank filename to be recognised as a new file

FrmMain.Caption := FrmMain.GetCaption  +  ' - [Untitled.shp]';


FrmMain.StatusBar1.Panels[3].Text := 'Width: ' + inttostr(FrmMain.SHP.Header.Width) + ' Height: ' + inttostr(FrmMain.SHP.Header.Height);

FrmMain.SetShadowMode(HasShadows(FrmMain.SHP));

FrmMain.lbl_total_frames.Caption := inttostr(FrmMain.SHP.Header.NumImages);
FrmPreview.TrackBar1.Position := 1;

if FrmMain.Shadowmode then
FrmPreview.TrackBar1.Max := FrmMain.SHP.Header.NumImages div 2
else
FrmPreview.TrackBar1.Max := FrmMain.SHP.Header.NumImages;

FrmMain.StatusBar1.Panels[1].Text := 'SHP Type: ' + GetSHPType(FrmMain.SHP);

FrmMain.SetIsEditable(True);

FrmMain.Current_Frame.value := 1;
FrmMain.Current_FrameChange(Sender);
FrmPreview.TrackBar1Change(Sender);

// if ProgressBar.Visible = true then
           ProgressBar.Visible := false;
        Close;

// This fix palette name in case it was changed
if not ocfNone.Checked then
   if (ocfTS.Checked and (ocfComboOptions.ItemIndex in [0,1])) or (ocfRA2.Checked and (ocfComboOptions.ItemIndex in [0,1,5])) then
      FrmMain.lblPalette.Caption := ' Palette - unittem.pal'
   else if ocfComboOptions.ItemIndex = 2 then
      FrmMain.lblPalette.Caption := ' Palette - unitsno.pal'
   else if ocfRA2.Checked and (ocfComboOptions.ItemIndex = 3) then
      FrmMain.lblPalette.Caption := ' Palette - uniturb.pal'
   else if (ocfTS.Checked and (ocfComboOptions.ItemIndex = 3)) or (ocfRA2.Checked and (ocfComboOptions.ItemIndex  = 4)) then
      FrmMain.lblPalette.Caption := ' Palette - isotem.pal'
   else if (ocfTS.Checked and (ocfComboOptions.ItemIndex = 4)) or (ocfRA2.Checked and (ocfComboOptions.ItemIndex = 6)) then
      FrmMain.lblPalette.Caption := ' Palette - anim.pal'
   else if (ocfTS.Checked and (ocfComboOptions.ItemIndex = 5)) or (ocfRA2.Checked and (ocfComboOptions.ItemIndex = 7)) then
      FrmMain.lblPalette.Caption := ' Palette - cameo.pal';
end;

procedure TFrmImportImageAsSHP.MassLoadImage;
var
   start,final,x: integer;
   ImageList : TStringList;
   temp,filename : string;
   Bitmap : TBitmap;
   IgnoreBackground:Boolean;
   alg:byte;
begin
   // Creates the string list
   ImageList := TStringList.Create;

   // these files all files in the dir image*.bmp (so, it gets 0000, to XXXX)
   FileListBox.Directory := ExtractFileDir(Image_Location.Text);
   FileListBox.mask := copy(Image_Location.Text,0,length(Image_Location.Text)- length('0000' +ExtractFileExt(Image_Location.Text)))+'*' + ExtractFileExt(Image_Location.Text);

   // removes the 0000 and extension from filename, so, you can load 0000 to XXXX (check below)
   filename := copy(extractfilename(Image_Location.Text),0,length(extractfilename(Image_Location.Text))-length('0000'+ExtractFileExt(Image_Location.Text)));

   // this is probably a hack to avoid problems on loading
   // on root like C:\image 0000.bmp, D:\image 0000.bmp, etc...
   if not (copy(FileListBox.Directory,length(FileListBox.Directory),1) = '\') then
      filename := '\' + filename;

   // create bitmap part...
   Bitmap := TBitmap.Create;
   Bitmap := GetBMPFromImageFile(Image_Location.Text); // Load first Frame so we can get width and height

   // initialize a new SHP file.
   NewSHP(FrmMain.SHP,maxframes,Bitmap.Width,Bitmap.Height);

   // Check if Background will be ignored
   IgnoreBackground := bcNone.Checked;

   // Clear ImageList to start re-check
   ImageList.Clear;

   // Fixes prob with mask system finding wrong files.
   For x := 0 to FileListBox.Items.Count-1 do
   begin
      temp := inttostr(x);
      if length(temp) < 4 then
      repeat
         Temp := '0' + Temp;
      until length(temp) = 4;

      if fileexists(FileListBox.Directory+filename+temp+ExtractFileExt(Image_Location.Text)) then
         ImageList.Add(FileListBox.Directory+filename+temp+ExtractFileExt(Image_Location.Text));
   end;

   // Incase they were set wrong, reset them.
   FrmMain.SHP.Header.NumImages := maxframes;
   SetLength(FrmMain.SHP.Data,FrmMain.SHP.Header.NumImages+1);

   // Set algorithm to be used
   if ccmStu.Checked then
       alg := 1
   else if ccmStu2.Checked then
       alg := 2
   else if ccmBanshee.Checked then
       alg := 3
   else if ccmBanshee2.Checked then
       alg := 4;

   // Check the conversion range
   if crCustomFrames.Checked then
   begin
      start := crFrom.Value;
      final := crTo.Value;
   end
   else
   begin
      start := 0;
      final := maxframes-1;
   end;

   // shows and set Progress bar to user
   ProgressBar.Visible := true;
   ProgressBar.Max := final;
   ProgressBar.Position := 0;

   // Incase they were set wrong, reset them.
   FrmMain.SHP.Header.NumImages := (final - start) + 1;
   SetLength(FrmMain.SHP.Data,FrmMain.SHP.Header.NumImages+1);

   // Set palette
   if not ocfNone.Checked then
      SHPPalette := CustomPalette;

   // This is where we start loading frame by frame. First, non frames
   For x := start to ((final - start) div 2) do
   begin
      ProgressBar.Position := x - start;

      Bitmap := GetBMPFromImageFile(ImageList.Strings[x]);

        // Checks for Hybrid palettes from Tech Buildings
       if ocfRA2.Checked and (ocfComboOptions.ItemIndex = 5) then
          if (x = 3) then
             GetPaletteFromFile(SHPPalette, extractfiledir(ParamStr(0))+'\palettes\ra2\isotem.pal')
          else
             GetPaletteFromFile(SHPPalette, extractfiledir(ParamStr(0))+'\palettes\ra2\unittem.pal');

      // Load frame
       SetFrameImageFrmBMP2(FrmMain.SHP,(x - start) +1,SHPPalette,Bitmap,BGColour,alg,IgnoreBackground,ssShadow.Checked);
   end;
   For x := ((final - start) div 2) + 1 to final do
   begin
      ProgressBar.Position := x - start;

      Bitmap := GetBMPFromImageFile(ImageList.Strings[x]);

        // Checks for Hybrid palettes from Tech Buildings
       if ocfRA2.Checked and (ocfComboOptions.ItemIndex = 5) then
          if (x = 7) then
             GetPaletteFromFile(SHPPalette, extractfiledir(ParamStr(0))+'\palettes\ra2\isotem.pal')
          else
             GetPaletteFromFile(SHPPalette, extractfiledir(ParamStr(0))+'\palettes\ra2\unittem.pal');

      // Load frame
       if not ssShadow.Checked then
          SetFrameImageFrmBMP2(FrmMain.SHP,(x - start) +1,SHPPalette,Bitmap,BGColour,alg,IgnoreBackground,ssShadow.Checked)
       else
          SetFrameImageFrmBMP2WithShadows(FrmMain.SHP,(x - start) + 1,Bitmap,BGColour);
   end;

       // If it's optimized as cameo, the program will resize
       // the picture to its proper size.

       // TS Cameo check: Cameos have only one frame
       if (((start = final) and (ocfTS.Checked)) and (ocfComboOptions.ItemIndex = 5)) then
          // If size is 64x48 for TS cameos
          if (FrmMain.SHP.Header.Width <> 64) or (FrmMain.SHP.Header.Height <> 48) then
          begin
             Resize_Frames_Blocky(FrmMain.SHP,64,48);
             FrmMain.StatusBar1.Panels[3].Text := 'Width: ' + '64' + ' Height: ' + '48';
          end;
       // RA2 Cameo check: Cameos have only one frame
       if (((start = final) and (ocfRA2.Checked)) and (ocfComboOptions.ItemIndex = 7)) then
          // If size is 60x48 for RA2 cameos
          if (FrmMain.SHP.Header.Width <> 60) or (FrmMain.SHP.Header.Height <> 48) then
          begin
             Resize_Frames_Blocky(FrmMain.SHP,60,48);
             FrmMain.StatusBar1.Panels[3].Text := 'Width: ' + '60' + ' Height: ' + '48';
          end;

   // Hybrid palettes always loads unittem.pal as default
   if ocfRA2.Checked and (ocfComboOptions.ItemIndex = 5) then
      GetPaletteFromFile(SHPPalette, extractfiledir(ParamStr(0))+'\palettes\ra2\unittem.pal');
   // Free Btimap
   Bitmap.Free;
end;

procedure TFrmImportImageAsSHP.SingleLoadImage;
var
IgnoreBackground:boolean;
Bitmap :TBitmap;
begin
   // create bitmap part...
   Bitmap := TBitmap.Create;
   Bitmap := GetBMPFromImageFile(Image_Location.Text); // Load first Frame so we can get width and height

   // Set SHP file and avoid access violations
   NewSHP(FrmMain.SHP,1,Bitmap.Width,Bitmap.Height);
   SetLength(FrmMain.SHP.Data,FrmMain.SHP.Header.NumImages+1);

   // Check if Background will be ignored
   IgnoreBackground := bcNone.Checked;

   // Set algorithm to be used and load frame
   if ccmStu.Checked then
       SetFrameImageFrmBMP2(FrmMain.SHP,1,SHPPalette,Bitmap,BGColour,1,IgnoreBackground,ssShadow.Checked)
   else if ccmStu2.Checked then
       SetFrameImageFrmBMP2(FrmMain.SHP,1,SHPPalette,Bitmap,BGColour,2,IgnoreBackground,ssShadow.Checked)
   else if ccmBanshee.Checked then
       SetFrameImageFrmBMP2(FrmMain.SHP,1,SHPPalette,Bitmap,BGColour,3,IgnoreBackground,ssShadow.Checked)
   else if ccmBanshee2.Checked then
       SetFrameImageFrmBMP2(FrmMain.SHP,1,SHPPalette,Bitmap,BGColour,4,IgnoreBackground,ssShadow.Checked);

  // If it's optimized as cameo, the program will resize
  // the picture to its proper size.

  // TS Cameo check: Cameos have only one frame
  if ((ocfTS.Checked) and (ocfComboOptions.ItemIndex = 5)) then
    // If size is 64x48 for TS cameos
    if (FrmMain.SHP.Header.Width <> 64) or (FrmMain.SHP.Header.Height <> 48) then
    begin
       Resize_Frames_Blocky(FrmMain.SHP,64,48);
       FrmMain.StatusBar1.Panels[3].Text := 'Width: ' + '64' + ' Height: ' + '48';
    end;
  // RA2 Cameo check: Cameos have only one frame
  if ((ocfRA2.Checked) and (ocfComboOptions.ItemIndex = 7)) then
     // If size is 60x48 for RA2 cameos
     if (FrmMain.SHP.Header.Width <> 60) or (FrmMain.SHP.Header.Height <> 48) then
     begin
        Resize_Frames_Blocky(FrmMain.SHP,60,48);
        FrmMain.StatusBar1.Panels[3].Text := 'Width: ' + '60' + ' Height: ' + '48';
     end;
  Bitmap.Free;
end;

procedure TFrmImportImageAsSHP.FormShow(Sender: TObject);
begin
//Manual_Colour_Match.Checked := false;
Image_Location.Text := '';
maxframes := 0;

// Disable Options
ConversionOptimizeBox.Enabled := false;
ConversionRangeBox.Enabled := false;
ColourConversionBox.Enabled := false;
ConversionOptimizeBox.Enabled := false;
BackgroundOverrideBox.Enabled := false;
bcColourEdit.Enabled := false;
Button2.Enabled := false;
ssShadow.Enabled := false;
end;

procedure TFrmImportImageAsSHP.bcColourEditChange(Sender: TObject);
begin
   if ColorDialog1.Execute then
   begin
      bcColourEdit.Color := ColorDialog1.Color;
      // If you click at the colour, it auto-sets to custom
      // Leave it in that way.
      bcCustom.Checked := true;
      bgcolour := ColorDialog1.Color;
   end;
end;

procedure TFrmImportImageAsSHP.bcAutoSelectClick(Sender: TObject);
begin
   AutoSelectBackground;
end;

procedure TFrmImportImageAsSHP.bcDefaultClick(Sender: TObject);
begin
   if not ocfNone.Checked then
      bgcolour := CustomPalette[0]
   else
      bgcolour := SHPPalette[0];
   bcColourEdit.Color := bgcolour;
end;

procedure TFrmImportImageAsSHP.bcCustomClick(Sender: TObject);
begin
   bgcolour := ColorDialog1.Color;
   bcColourEdit.Color := bgcolour;
end;

procedure TFrmImportImageAsSHP.bcNoneClick(Sender: TObject);
begin
  bcColourEdit.Color := clSilver;
end;

procedure TFrmImportImageAsSHP.crFromChange(Sender: TObject);
begin
   if crFrom.Text = '' then
      crFrom.Text := '0';
   if crFrom.Value < 0 then
      crFrom.Value := 0
   else if crFrom.Value > crTo.Value then
      crFrom.Value := crTo.Value;
   crCustomFrames.Checked := true;
end;

procedure TFrmImportImageAsSHP.crToChange(Sender: TObject);
begin
   if crTo.Text = '' then
   begin
      crFrom.Text := '0';
      crTo.Text := '0';
   end;
   if crTo.Value < crFrom.Value then
      crTo.Value := crFrom.Value
   else if crTo.Value < 0 then
      crTo.Value := 0;
   if crTo.Value >= maxframes then
      crTo.Value := maxframes - 1;
   crCustomFrames.Checked := true;
end;

procedure TFrmImportImageAsSHP.AutoSelectBackground;
var
   Bitmap: TBitmap;
begin
   // create bitmap part...
   Bitmap := TBitmap.Create;
   Bitmap := GetBMPFromImageFile(Image_Location.Text); // Load first Frame so we can get width and height

   // auto gets background colour, by checking first element.
   bgcolour := Bitmap.Canvas.Pixels[0,0];
   bcColourEdit.Color := bgcolour;
   Bitmap.Free;
end;

procedure TFrmImportImageAsSHP.ocfTSClick(Sender: TObject);
begin
   // When selected, this adds the TS options to the combo box

   // First of all, enable and clean combo box.
   ocfComboOptions.Enabled := true;
   ocfComboOptions.Clear;

   // Add the options.
   ocfComboOptions.Items.Add('Infantry');
   ocfComboOptions.Items.Add('Temperate Buildings');
   ocfComboOptions.Items.Add('Snow Buildings');
   ocfComboOptions.Items.Add('Isometric Buildings, Overlay');
   ocfComboOptions.Items.Add('Animations');
   ocfComboOptions.Items.Add('Cameos');

   ocfComboOptions.Show;
   ocfComboOptions.SetFocus;
   ocfComboOptions.ItemIndex := 0;

   // Adds TS Infantry settings:
   if fileexists(extractfiledir(ParamStr(0))+'\palettes\ts\unittem.pal') then
      GetPaletteFromFile(CustomPalette, extractfiledir(ParamStr(0))+'\palettes\ts\unittem.pal');
   bcAutoSelect.Checked := true;
   crFrom.Value := 0;
   crTo.Value := maxframes - 1;
   ssShadow.Checked := true;
   ocfComboOptions.Hint := 'This optimizes the import for infantry units by loading unittem.pal and optimized settings for it.';
end;

procedure TFrmImportImageAsSHP.ocfRA2Click(Sender: TObject);
begin
   // When selected, this adds the RA2 options to the combo box

   // First of all, enable and clean combo box.
   ocfComboOptions.Enabled := true;
   ocfComboOptions.Clear;

   // Add the options.
   ocfComboOptions.Items.Add('Infantry');
   ocfComboOptions.Items.Add('Temperate Buildings');
   ocfComboOptions.Items.Add('Snow Buildings');
   ocfComboOptions.Items.Add('Urban Buildings');
   ocfComboOptions.Items.Add('Isometric Buildings, Overlay');
   ocfComboOptions.Items.Add('Tech Buildings w/ Wreckage');
   ocfComboOptions.Items.Add('Animations');
   ocfComboOptions.Items.Add('Cameos');

   ocfComboOptions.Show;
   ocfComboOptions.SetFocus;
   ocfComboOptions.ItemIndex := 0;

   // Adds RA2 Infantry settings
   if fileexists(extractfiledir(ParamStr(0))+'\palettes\ra2\unittem.pal') then
      GetPaletteFromFile(CustomPalette, extractfiledir(ParamStr(0))+'\palettes\ra2\unittem.pal');
   bcAutoSelect.Checked := true;
   crFrom.Value := 0;
   crTo.Value := maxframes - 1;
   ssShadow.Checked := true;
   ocfComboOptions.Hint := 'This optimizes the import for infantry units by loading unittem.pal and optimized settings for it.';
end;

procedure TFrmImportImageAsSHP.ocfNoneClick(Sender: TObject);
begin
   // Disabled and Clear combo box.
   ocfComboOptions.Enabled := false;
   ocfComboOptions.Clear;
   ocfComboOptions.Text := '';
end;

procedure TFrmImportImageAsSHP.ocfComboOptionsChange(Sender: TObject);
begin
   // This will load a pre-defined setting selected by the user.
   // Note: Some might look the same, but they can be customized
   // later, so leave it as it is.

   if (ocfComboOptions.ItemIndex = -1) then
     ocfComboOptions.Hint := 'Nothing selected.';

   // TS?
   if ocfTS.Checked then
   begin
      // Infantry?
      if (ocfComboOptions.ItemIndex = 0) then
      begin
         if fileexists(extractfiledir(ParamStr(0))+'\palettes\ts\unittem.pal') then
            GetPaletteFromFile(CustomPalette, extractfiledir(ParamStr(0))+'\palettes\ts\unittem.pal');
         bcAutoSelect.Checked := true;
         crFrom.Value := 0;
         crTo.Value := maxframes - 1;
         ssShadow.Checked := true;
         ocfComboOptions.Hint := 'This optimizes the import for infantry units by loading unittem.pal and optimized settings for it.';
      end;
      // Temperate Buildings?
      if (ocfComboOptions.ItemIndex = 1) then
      begin
         if fileexists(extractfiledir(ParamStr(0))+'\palettes\ts\unittem.pal') then
            GetPaletteFromFile(CustomPalette, extractfiledir(ParamStr(0))+'\palettes\ts\unittem.pal');
         bcAutoSelect.Checked := true;
         crFrom.Value := 0;
         crTo.Value := maxframes - 1;
         ssShadow.Checked := true;
         ocfComboOptions.Hint := 'This optimizes the import for temperate buildings by loading unittem.pal and optimized settings for it.';
      end;
      // Snow Buildings?
      if (ocfComboOptions.ItemIndex = 2) then
      begin
         if fileexists(extractfiledir(ParamStr(0))+'\palettes\ts\unitsno.pal') then
            GetPaletteFromFile(CustomPalette, extractfiledir(ParamStr(0))+'\palettes\ts\unitsno.pal');
         bcAutoSelect.Checked := true;
         crFrom.Value := 0;
         crTo.Value := maxframes - 1;
         ssShadow.Checked := true;
         ocfComboOptions.Hint := 'This optimizes the import for snow buildings by loading unitsno.pal and optimized settings for it.';
      end;
      // Isometric Buildings? Overlay?
      if (ocfComboOptions.ItemIndex = 3) then
      begin
         if fileexists(extractfiledir(ParamStr(0))+'\palettes\ts\isotem.pal') then
            GetPaletteFromFile(CustomPalette, extractfiledir(ParamStr(0))+'\palettes\ts\isotem.pal');
         bcAutoSelect.Checked := true;
         crFrom.Value := 0;
         crTo.Value := maxframes - 1;
         ssShadow.Checked := true;
         ocfComboOptions.Hint := 'This optimizes the import for isometric buildings by loading isotem.pal and optimized settings for it.';
      end;
      // Animations?
      if (ocfComboOptions.ItemIndex = 4) then
      begin
         if fileexists(extractfiledir(ParamStr(0))+'\palettes\ts\anim.pal') then
            GetPaletteFromFile(CustomPalette, extractfiledir(ParamStr(0))+'\palettes\ts\anim.pal');
         bcAutoSelect.Checked := true;
         crFrom.Value := 0;
         crTo.Value := maxframes - 1;
         ssShadow.Checked := false;
         ocfComboOptions.Hint := 'This optimizes the import for animations by loading anim.pal and optimized settings for it.';
      end;
      // Cameos?
      if (ocfComboOptions.ItemIndex = 5) then
         begin
         if fileexists(extractfiledir(ParamStr(0))+'\palettes\ts\cameo.pal') then
            GetPaletteFromFile(CustomPalette, extractfiledir(ParamStr(0))+'\palettes\ts\cameo.pal');
         bcNone.Checked := true;
         crFrom.Value := 0;
         crTo.Value := 0;
         ssShadow.Checked := false;
         ocfComboOptions.Hint := 'This optimizes the import for cameos by getting only 1 frame, removing background colour that damages the cameo in game, loading cameo.pal and resizing it to 64x48 in case they are not at this size.';
         end;
   end
   else if ocfRA2.Checked then
   begin
      // Infantry?
      if (ocfComboOptions.ItemIndex = 0) then
      begin
         if fileexists(extractfiledir(ParamStr(0))+'\palettes\ra2\unittem.pal') then
            GetPaletteFromFile(CustomPalette, extractfiledir(ParamStr(0))+'\palettes\ra2\unittem.pal');
         bcAutoSelect.Checked := true;
         crFrom.Value := 0;
         crTo.Value := maxframes - 1;
         ssShadow.Checked := true;
         ocfComboOptions.Hint := 'This optimizes the import for infantry units by loading unittem.pal and optimized settings for it.';
      end;
      // Temperate Buildings?
      if (ocfComboOptions.ItemIndex = 1) then
      begin
         if fileexists(extractfiledir(ParamStr(0))+'\palettes\ra2\unittem.pal') then
            GetPaletteFromFile(CustomPalette, extractfiledir(ParamStr(0))+'\palettes\ra2\unittem.pal');
         bcAutoSelect.Checked := true;
         crFrom.Value := 0;
         crTo.Value := maxframes - 1;
         ssShadow.Checked := true;
         ocfComboOptions.Hint := 'This optimizes the import for temperate buildings units by loading unittem.pal and optimized settings for it.';
      end;
      // Snow Buildings?
      if (ocfComboOptions.ItemIndex = 2) then
      begin
         if fileexists(extractfiledir(ParamStr(0))+'\palettes\ra2\unitsno.pal') then
            GetPaletteFromFile(CustomPalette, extractfiledir(ParamStr(0))+'\palettes\ra2\unitsno.pal');
         bcAutoSelect.Checked := true;
         crFrom.Value := 0;
         crTo.Value := maxframes - 1;
         ssShadow.Checked := true;
         ocfComboOptions.Hint := 'This optimizes the import for snow buildings by loading unitsno.pal and optimized settings for it.';
      end;
      // Urban Buildings?
      if (ocfComboOptions.ItemIndex = 3) then
      begin
         if fileexists(extractfiledir(ParamStr(0))+'\palettes\ra2\uniturb.pal') then
            GetPaletteFromFile(CustomPalette, extractfiledir(ParamStr(0))+'\palettes\ra2\uniturb.pal');
         bcAutoSelect.Checked := true;
         crFrom.Value := 0;
         crTo.Value := maxframes - 1;
         ssShadow.Checked := true;
         ocfComboOptions.Hint := 'This optimizes the import for urban buildings by loading uniturb.pal and optimized settings for it.';
      end;
      // Isometric Buildings? Overlay?
      if (ocfComboOptions.ItemIndex = 4) then
      begin
         if fileexists(extractfiledir(ParamStr(0))+'\palettes\ra2\isotem.pal') then
            GetPaletteFromFile(CustomPalette, extractfiledir(ParamStr(0))+'\palettes\ra2\isotem.pal');
         bcAutoSelect.Checked := true;
         crFrom.Value := 0;
         crTo.Value := maxframes - 1;
         ssShadow.Checked := true;
         ocfComboOptions.Hint := 'This optimizes the import for isometric buildings and overlays by loading isotem.pal and optimized settings for it.';
      end;
      // Tech Buildings with Wreckage?
      if (ocfComboOptions.ItemIndex = 5) then
      begin
         if maxframes >= 8 then
         begin
            crFrom.Value := 0;
            crTo.Value := 7;
         end;
         bcAutoSelect.Checked := true;
         bcDefault.Enabled := false;
         ssShadow.Checked := true;
         ocfComboOptions.Hint := 'It loads the first 3 frames and first 3 shadows of the tech building w/ isotem.pal and the 4th and 8th frame which is the wreckage w/ isotem.pal. Use this for 8 frames buildings only.';
      end;
      // Animations?
      if (ocfComboOptions.ItemIndex = 6) then
      begin
         if fileexists(extractfiledir(ParamStr(0))+'\palettes\ra2\anim.pal') then
            GetPaletteFromFile(CustomPalette, extractfiledir(ParamStr(0))+'\palettes\ra2\anim.pal');
         bcAutoSelect.Checked := true;
         crFrom.Value := 0;
         crTo.Value := maxframes - 1;
         ssShadow.Checked := false;
         ocfComboOptions.Hint := 'This optimizes the import for animations by loading anim.pal and optimized settings for it.';
      end;
      // Cameos?
      if (ocfComboOptions.ItemIndex = 7) then
         begin
         if fileexists(extractfiledir(ParamStr(0))+'\palettes\ra2\cameo.pal') then
            GetPaletteFromFile(CustomPalette, extractfiledir(ParamStr(0))+'\palettes\ra2\cameo.pal');
         bcNone.Checked := true;
         crFrom.Value := 0;
         crTo.Value := 0;
         ssShadow.Checked := false;
         ocfComboOptions.Hint := 'This optimizes the import for cameos by getting only 1 frame, removing background colour that damages the cameo in game, loading cameo.pal and resizing it to 60x48 in case they are not at this size.';
         end;
   end;
   if not ((ocfComboOptions.ItemIndex = 5) and ocfRA2.Checked) then
      bcDefault.Enabled := true;
end;
end.
