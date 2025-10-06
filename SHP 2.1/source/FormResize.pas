unit FormResize;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Mask, Spin;

type
  TFrmResize = class(TForm)
    grpCurrentSize: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    btnOK: TButton;
    btnCancel: TButton;
    GroupBox1: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    spePercHeight: TSpinEdit;
    spePercWidth: TSpinEdit;
    speHeight: TSpinEdit;
    speWidth: TSpinEdit;
    chbMaintainRatio: TCheckBox;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure spePercHeightChange(Sender: TObject);
    procedure spePercWidthChange(Sender: TObject);
    procedure speHeightChange(Sender: TObject);
    procedure speWidthChange(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
    x, y, z: integer; //size of voxel section currently
    changed, //has x,y or z changed at all? if not, no need to do anything
    dataloss: boolean; //and if changed, will this result in any voxels being lost?
  end;

var
  FrmResize: TFrmResize;

implementation

uses FormMain;

{$R *.DFM}

procedure TFrmResize.btnCancelClick(Sender: TObject);
begin
  changed:=false;
  Close;
end;

procedure TFrmResize.btnOKClick(Sender: TObject);
begin
  changed:=true;
  Close;
end;

procedure TFrmResize.FormShow(Sender: TObject);
begin
  changed := false;
  spePercHeight.Text := '100';
  spePercWidth.Text := '100';
  speWidth.Text := inttostr(FrmMain.SHP.Header.Width);
  speHeight.Text := inttostr(FrmMain.SHP.Header.Height);
  chbMaintainRatio.Checked := false;
end;

// The codes below update the percetanges with the dimensions
// while the user is editing the values and vice versa.
procedure TFrmResize.spePercHeightChange(Sender: TObject);
begin
   if ((spePercHeight.Text <> '') and (spePercHeight.Value > -1)) then
      try
         speHeight.Text := inttostr(round((FrmMain.SHP.Header.Height * strtoint(spePercHeight.Text)) div 100))
      except
         spePercHeight.Text := '100';
         speHeight.Text := inttostr(FrmMain.SHP.Header.Height);
      end
   else
      speHeight.Text := '0';
   if chbMaintainRatio.Checked then
      spePercWidth.Text := spePercHeight.Text;
end;

procedure TFrmResize.spePercWidthChange(Sender: TObject);
begin
   if ((spePercWidth.Text <> '') and (spePercWidth.Value > -1)) then
      try
         speWidth.Text := inttostr(round((FrmMain.SHP.Header.Width * strtoint(spePercWidth.Text)) div 100))
      except
         spePercWidth.Text := '100';
         speWidth.Text := inttostr(FrmMain.SHP.Header.Width);
      end
   else
      speWidth.Text := '0';
   if chbMaintainRatio.Checked then
      spePercHeight.Text := spePercWidth.Text;
end;

procedure TFrmResize.speHeightChange(Sender: TObject);
begin
   if ((speHeight.Text <> '') and (speHeight.Value > -1)) then
      try
         spePercHeight.Text := inttostr(round((strtoint(speHeight.Text) / FrmMain.SHP.Header.Height) * 100))
      except
         spePercHeight.Text := '100';
         speHeight.Text := inttostr(FrmMain.SHP.Header.Height);
      end
   else
      spePercHeight.Text := '0';
end;

procedure TFrmResize.speWidthChange(Sender: TObject);
begin
   if ((speWidth.Text <> '') and (speWidth.Value > -1)) then
      try
         spePercWidth.Text := inttostr(round((strtoint(speWidth.Text) / FrmMain.SHP.Header.Width) * 100))
      except
         spePercWidth.Text := '100';
         speWidth.Text := inttostr(FrmMain.SHP.Header.Width);
      end
   else
      spePercWidth.Text := '0';
end;

end.




