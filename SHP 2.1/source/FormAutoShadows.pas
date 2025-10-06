unit FormAutoShadows;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtDlgs, StdCtrls, ExtCtrls, Spin,shp_file,shp_engine,palette,
  Shp_Engine_Image, ComCtrls;

  CONST
    MaxPixelCount   =  32768;

  TYPE
    pRGBArray  =  ^TRGBArray;    
    TRGBArray  =  ARRAY[0..MaxPixelCount-1] OF TRGBTriple;

type
  TFrmAutoShadows = class(TForm)
    ImageOriginal: TImage;
    ImageRotated: TImage;
    SpinEditThetaDegrees: TSpinEdit;
    LabelRotationAngle: TLabel;
    Bevel1: TBevel;
    Bevel3: TBevel;
    Button1: TButton;
    Button2: TButton;
    Bevel2: TBevel;
    ProgressBar1: TProgressBar;
    procedure LoadPreviewFrameData;
    procedure SpinEditRotate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);

  private
    { Private declarations }
    BitmapOriginal:  TBitmap;
    BitmapRotated :  TBitmap;
  public
    Ox,Oy : integer;
    PROCEDURE RotateBitmap;
    PROCEDURE RotateBitmap_frameimage(frame:integer);
  end;

var
  FrmAutoShadows: TFrmAutoShadows;

implementation
{$R *.DFM}

USES
 FormMain;


// Rotate image by angle[degrees] specified in spinbox
procedure TFrmAutoShadows.SpinEditRotate(Sender: TObject);
begin
  RotateBitmap
end;


procedure TFrmAutoShadows.FormCreate(Sender: TObject);
begin
  BitmapOriginal := TBitmap.Create;
  BitmapRotated  := TBitmap.Create;
end;


procedure TFrmAutoShadows.FormDestroy(Sender: TObject);
begin
  BitmapOriginal.Free;
  BitmapRotated.Free
end;

//Procedure By Thomas Kowalski
procedure SpiegelnHorizontal(Bitmap:TBitmap);
var i,j,w :  INTEGER;
    RowIn :  pRGBArray;
    RowOut:  pRGBArray;

begin
    w := bitmap.width*sizeof(TRGBTriple);
    Getmem(rowin,w);
    for j := 0 to Bitmap.Height-1 do begin
      move(Bitmap.Scanline[j]^,rowin^,w);
      rowout := Bitmap.Scanline[j];
      for i := 0 to Bitmap.Width-1 do rowout[i] := rowin[Bitmap.Width-1-i];
    end;
    bitmap.Assign(bitmap);
    Freemem(rowin);
end;

// Procedure by Earl F. Glynn and Optimized by John O'Harrow
PROCEDURE TFrmAutoShadows.RotateBitmap;
const
  Black : RGBTriple = (rgbtBlue:0; rgbtGreen:0; rgbtRed:0);
VAR
  i, j           :  Word;
  BW, BH         :  Word;
  iOriginal      :  Integer;
  iPrime         :  Integer;
  iPrimeRotated  :  Integer;
  jOriginal      :  Integer;
  jPrime         :  Integer;
  jPrimeRotated  :  Integer;
  RowOriginal    :  pRGBArray;
  RowRotated     :  pRGBArray;
  sinTheta       :  Double;
  cosTheta       :  Double;
  Theta          :  Double; // radians
  POriginalStart :  Pointer;
  POriginal      :  Pointer;
  ScanlineBytes  :  Integer;
  iRot, jRot     :  Integer;
  jPrimeSinTheta :  Double;
  jPrimeCosTheta :  Double;
begin
  // The size of BitmapRotated is the same as BitmapOriginal.  PixelFormat
  // must also match since 24-bit GBR triplets are assumed in ScanLine.

//  BitmapOriginal := GetBMPOfFrameImage_ShadowColour(FrmMain.SHP,1,SHPPalette);

  BitmapRotated.Width  := BitmapOriginal.Width;
  BitmapRotated.Height := BitmapOriginal.Height;
  BitmapRotated.PixelFormat := BitmapOriginal.PixelFormat; //Copy PixelFormat

  BitmapRotated.Canvas.Brush.Color := SHPPalette[0];
  BitmapRotated.Canvas.FillRect(Rect(0,0,BitmapRotated.Width,BitmapRotated.Height));
  // Convert degrees to radians.  Use minus sign to force clockwise rotation.
  Theta := -(SpinEditThetaDegrees.Value) * PI / 180;
  sinTheta := SIN(Theta);
  cosTheta := COS(Theta);

  //Get Size of each ScanLine (Allow for DWORD Alignment and DIB Orientation)
  ScanlineBytes := Integer(BitmapOriginal.Scanline[1])
                 - Integer(BitmapOriginal.Scanline[0]);

  BW := BitmapOriginal.Width  - 1; //Prevent Repeated Calls to TBitMap.Width
  BH := BitmapOriginal.Height - 1; //Prevent Repeated Calls to TBitMap.Height
  iRot := (2 * Ox) + 1; //Simplify Calculation within Inner Loop
  jRot := (2 * Oy) + 1; //Simplify Calculation within Outer Loop

  //Remove all calls to Scanline method from within loops by using local pointers

  RowRotated     := BitmapRotated.ScanLine[BH]; //Last BitmapRotated Scanline
  POriginalStart := BitmapOriginal.ScanLine[0]; //First BitmapOriginal Scanline
  // Step through each row of rotated image.
  for j := BH downto 0 do
    begin
      // Assume the bitmap has an even number of pixels in both dimensions and
      // the axis of rotation is to be the exact middle of the image -- so this
      // axis of rotation is not at the middle of any pixel.

      // The transformation (i,j) to (iPrime, jPrime) puts the center of each
      // pixel at odd-numbered coordinates.  The left and right sides of each
      // pixel (as well as the top and bottom) then have even-numbered coordinates.

      // The point (Ox, Oy) identifies the axis of rotation.

      // For a 640 x 480 pixel image, the center point is (320, 240).  Pixels
      // numbered (index i) 0..319 are left of this point along the "X" axis and
      // pixels numbered 320..639 are right of this point.  Likewise, vertically
      // pixels are numbered (index j) 0..239 above the axis of rotation and
      // 240..479 below the axis of rotation.

      // The subtraction (i, j) - (Ox, Oy) moves the axis of
      // rotation from (i, j) to (Ox, Oy), which is the
      // center of the bitmap in this implementation.
      jPrime := (2 * j) - jRot;
      jPrimeSinTheta := jPrime * sinTheta; //Simplify Calculation within Loop
      jPrimeCosTheta := jPrime * cosTheta; //Simplify Calculation within Loop
      POriginal := POriginalStart; //Pointer to First BitmapOriginal Scanline
      for i := BW downto 0 do
        begin
          // Rotate (iPrime, jPrime) to location of desired pixel
          // Transform back to pixel coordinates of image, including translation
          // of origin from axis of rotation to origin of image.
          // Make sure (iOriginal, jOriginal) is in BitmapOriginal.  If not,
          // assign blue color to corner points.
          iPrime := (2 * i) - iRot;
          iPrimeRotated := ROUND(iPrime * cosTheta - jPrimeSinTheta);
          iOriginal := (iPrimeRotated - 1) div 2 + Ox;
          if (iOriginal >= 0) and (iOriginal <= BW) then
            begin //Only Calaculate jPrimeRotated and jOriginal if Necessary
              jPrimeRotated := ROUND(iPrime * sinTheta + jPrimeCosTheta);
              jOriginal := (jPrimeRotated - 1) div 2 + Oy;
              if (jOriginal >= 0) and (jOriginal <= BH) then
                begin
                  // Assign pixel from rotated space to current pixel in BitmapRotated
                  RowOriginal   := Pointer(Integer(POriginal) + (jOriginal * ScanLineBytes));
                  RowRotated[i] := RowOriginal[iOriginal];
                end;
              end;
        end;
      Dec(Integer(RowRotated), ScanLineBytes); //Move Pointer to Previous BitmapRotated Scanline
    end;
  ImageRotated.Picture.Graphic := BitmapRotated;
  DrawFrameImage(FrmMain.SHP,1,1,false,false,SHPPalette,ImageRotated);
end; {RotateBitmap}

// Procedure by Earl F. Glynn and Optimized by John O'Harrow, Modifyed for FrameImage
PROCEDURE TFrmAutoShadows.RotateBitmap_frameimage(frame:integer);
const
  Black : RGBTriple = (rgbtBlue:0; rgbtGreen:0; rgbtRed:0);
VAR
  i, j           :  Word;
  BW, BH         :  Word;
  iOriginal      :  Integer;
  iPrime         :  Integer;
  iPrimeRotated  :  Integer;
  jOriginal      :  Integer;
  jPrime         :  Integer;
  jPrimeRotated  :  Integer;
  RowOriginal    :  pRGBArray;
  RowRotated     :  pRGBArray;
  sinTheta       :  Double;
  cosTheta       :  Double;
  Theta          :  Double; // radians
  POriginalStart :  Pointer;
  POriginal      :  Pointer;
  ScanlineBytes  :  Integer;
  iRot, jRot     :  Integer;
  jPrimeSinTheta :  Double;
  jPrimeCosTheta :  Double;
begin
  // The size of BitmapRotated is the same as BitmapOriginal.  PixelFormat
  // must also match since 24-bit GBR triplets are assumed in ScanLine.

  BitmapOriginal := GetBMPOfFrameImage_ShadowColour(FrmMain.SHP,Frame,SHPPalette);
  BitmapOriginal.PixelFormat := pf24bit;   // force to 24 bits
  SpiegelnHorizontal(BitmapOriginal);
  BitmapRotated.Width  := BitmapOriginal.Width;
  BitmapRotated.Height := BitmapOriginal.Height;
  BitmapRotated.PixelFormat := BitmapOriginal.PixelFormat; //Copy PixelFormat

  BitmapRotated.Canvas.Brush.Color := SHPPalette[0];
  BitmapRotated.Canvas.FillRect(Rect(0,0,BitmapRotated.Width,BitmapRotated.Height));
  // Convert degrees to radians.  Use minus sign to force clockwise rotation.
  Theta := -(SpinEditThetaDegrees.Value) * PI / 180;
  sinTheta := SIN(Theta);
  cosTheta := COS(Theta);

  //Get Size of each ScanLine (Allow for DWORD Alignment and DIB Orientation)
  ScanlineBytes := Integer(BitmapOriginal.Scanline[1])
                 - Integer(BitmapOriginal.Scanline[0]);

  BW := BitmapOriginal.Width  - 1; //Prevent Repeated Calls to TBitMap.Width
  BH := BitmapOriginal.Height - 1; //Prevent Repeated Calls to TBitMap.Height
  iRot := (2 * Ox) + 1; //Simplify Calculation within Inner Loop
  jRot := (2 * Oy) + 1; //Simplify Calculation within Outer Loop

  //Remove all calls to Scanline method from within loops by using local pointers

  RowRotated     := BitmapRotated.ScanLine[BH]; //Last BitmapRotated Scanline
  POriginalStart := BitmapOriginal.ScanLine[0]; //First BitmapOriginal Scanline
  // Step through each row of rotated image.
  for j := BH downto 0 do
    begin
      // Assume the bitmap has an even number of pixels in both dimensions and
      // the axis of rotation is to be the exact middle of the image -- so this
      // axis of rotation is not at the middle of any pixel.

      // The transformation (i,j) to (iPrime, jPrime) puts the center of each
      // pixel at odd-numbered coordinates.  The left and right sides of each
      // pixel (as well as the top and bottom) then have even-numbered coordinates.

      // The point (Ox, Oy) identifies the axis of rotation.

      // For a 640 x 480 pixel image, the center point is (320, 240).  Pixels
      // numbered (index i) 0..319 are left of this point along the "X" axis and
      // pixels numbered 320..639 are right of this point.  Likewise, vertically
      // pixels are numbered (index j) 0..239 above the axis of rotation and
      // 240..479 below the axis of rotation.

      // The subtraction (i, j) - (Ox, Oy) moves the axis of
      // rotation from (i, j) to (Ox, Oy), which is the
      // center of the bitmap in this implementation.
      jPrime := (2 * j) - jRot;
      jPrimeSinTheta := jPrime * sinTheta; //Simplify Calculation within Loop
      jPrimeCosTheta := jPrime * cosTheta; //Simplify Calculation within Loop
      POriginal := POriginalStart; //Pointer to First BitmapOriginal Scanline
      for i := BW downto 0 do
        begin
          // Rotate (iPrime, jPrime) to location of desired pixel
          // Transform back to pixel coordinates of image, including translation
          // of origin from axis of rotation to origin of image.
          // Make sure (iOriginal, jOriginal) is in BitmapOriginal.  If not,
          // assign blue color to corner points.
          iPrime := (2 * i) - iRot;
          iPrimeRotated := ROUND(iPrime * cosTheta - jPrimeSinTheta);
          iOriginal := (iPrimeRotated - 1) div 2 + Ox;
          if (iOriginal >= 0) and (iOriginal <= BW) then
            begin //Only Calaculate jPrimeRotated and jOriginal if Necessary
              jPrimeRotated := ROUND(iPrime * sinTheta + jPrimeCosTheta);
              jOriginal := (jPrimeRotated - 1) div 2 + Oy;
              if (jOriginal >= 0) and (jOriginal <= BH) then
                begin
                  // Assign pixel from rotated space to current pixel in BitmapRotated
                  RowOriginal   := Pointer(Integer(POriginal) + (jOriginal * ScanLineBytes));
                  RowRotated[i] := RowOriginal[iOriginal];
                end;
              end;
        end;
      Dec(Integer(RowRotated), ScanLineBytes); //Move Pointer to Previous BitmapRotated Scanline
    end;
SetFrameImageFrmBMP(FrmMain.SHP,GetShadowFromOposite(FrmMain.SHP,Frame),SHPPalette,BitmapRotated);
end; {RotateBitmap}

procedure TFrmAutoShadows.LoadPreviewFrameData;
begin
    BitmapOriginal.Free;

    BitmapOriginal := GetBMPOfFrameImage_ShadowColour(FrmMain.SHP,1,SHPPalette);

    if   BitmapOriginal.PixelFormat <> pf24bit
    then BitmapOriginal.PixelFormat := pf24bit;   // force to 24 bits
    SpiegelnHorizontal(BitmapOriginal);
    DrawFrameImage(FrmMain.SHP,1,1,true,false,SHPPalette,ImageOriginal);
    Ox := BitmapOriginal.Width  div 2;
    Oy := BitmapOriginal.Height div 2;

    // Rotate and display the image
    RotateBitmap;
end;

procedure TFrmAutoShadows.FormShow(Sender: TObject);
begin
LoadPreviewFrameData;
end;

procedure TFrmAutoShadows.Button1Click(Sender: TObject);
var
x : integer;
begin
ProgressBar1.Visible := true;
ProgressBar1.Max := FrmMain.SHP.Header.NumImages div 2-1;
ProgressBar1.Position := 0;

for x := 1 to FrmMain.SHP.Header.NumImages div 2 do
begin
RotateBitmap_frameimage(x);
ProgressBar1.Position := x-1;
end;

ProgressBar1.Visible := false;

close;
end;

procedure TFrmAutoShadows.Button2Click(Sender: TObject);
begin
close;
end;

end.
