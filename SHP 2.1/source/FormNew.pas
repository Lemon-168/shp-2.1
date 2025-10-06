unit FormNew;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Spin;

type
  TFrmNew = class(TForm)
    grpCurrentSize: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    btnOK: TButton;
    btnCancel: TButton;
    Label1: TLabel;
    txtWidth: TSpinEdit;
    txtHeight: TSpinEdit;
    txtFrames: TSpinEdit;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure txtWidthChange(Sender: TObject);
    procedure txtHeightChange(Sender: TObject);
    procedure txtFramesChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    x, y, z: integer; //size of voxel section currently
    changed, //has x,y or z changed at all? if not, no need to do anything
    dataloss: boolean; //and if changed, will this result in any voxels being lost?
  end;

var
  FrmNew: TFrmNew;

implementation

{$R *.DFM}

procedure TFrmNew.btnCancelClick(Sender: TObject);
begin
  changed:=false;
  Close;
end;

procedure TFrmNew.btnOKClick(Sender: TObject);
begin
  changed:=true;
  Close;
end;

procedure TFrmNew.FormShow(Sender: TObject);
begin
changed := false;
end;

procedure TFrmNew.txtWidthChange(Sender: TObject);
begin
   if txtWidth.Text = '' then
      txtWidth.Text := '1'
   else if txtWidth.Value > 10000 then
      txtWidth.Value := 10000;

end;

procedure TFrmNew.txtHeightChange(Sender: TObject);
begin
   if txtHeight.Text = '' then
      txtHeight.Text := '1'
   else if txtHeight.Value > 10000 then
      txtHeight.Value := 10000;
end;

procedure TFrmNew.txtFramesChange(Sender: TObject);
begin
   if txtFrames.Text = '' then
      txtFrames.Text := '1'
   else if txtFrames.Value > 10000 then
      txtFrames.Value := 10000;
end;

end.
