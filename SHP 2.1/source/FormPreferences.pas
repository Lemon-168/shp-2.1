unit FormPreferences;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, StdCtrls, ComCtrls, ExtCtrls, Registry;

type
  TFrmPreferences = class(TForm)
    GroupBox1: TGroupBox;
    Bevel1: TBevel;
    Button2: TButton;
    Pref_List: TTreeView;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    AssociateCheck: TCheckBox;
    GroupBox3: TGroupBox;
    IconPrev: TImage;
    IconID: TTrackBar;
    BtnApply: TButton;
    TabSheet2: TTabSheet;
    CheckBox1: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    IconList: TImageList;
    UnitPalette: TComboBoxEx;
    BuildingPalette: TComboBoxEx;
    Label3: TLabel;
    AnimationPalette: TComboBoxEx;
    Label4: TLabel;
    CameoPalette: TComboBoxEx;
    TabSheet3: TTabSheet;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Label5: TLabel;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    procedure BtnApplyClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure IconIDChange(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Pref_ListClick(Sender: TObject);
    procedure Pref_ListKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Pref_ListKeyPress(Sender: TObject; var Key: Char);
    procedure Pref_ListKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CheckBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    IconPath: String;
    procedure ExtractIcon;
    procedure GetSettings;
  end;

var
  FrmPreferences: TFrmPreferences;

implementation

uses FormMain;

{$R *.dfm}

procedure TFrmPreferences.ExtractIcon;
var
  sWinDir: String;
  iLength: Integer;
  {Res: TResourceStream; }
  MIcon: TIcon;
begin

  // Initialize Variable
  iLength := 255;
  setLength(sWinDir, iLength);
  iLength := GetWindowsDirectory(PChar(sWinDir), iLength);
  setLength(sWinDir, iLength);
  IconPath := sWinDir + '\BS_SHP_BUILDER'+inttostr(IconID.Position)+'.ico';

  MIcon := TIcon.Create;
  IconList.GetIcon(IconID.Position,MIcon);
  MIcon.SaveToFile(IconPath);
  MIcon.Free;

  {Res := TResourceStream.Create(hInstance,'Icon_'+IntToStr(IconID.Position+1),RT_RCDATA);
  Res.SaveToFile(IconPath);
  Res.Free;}
end;

procedure TFrmPreferences.GetSettings;
begin
 // AssociateCheck.Checked:=Config.Assoc;
 // IconID.Position:=Config.Icon;
  AssociateCheck.Checked := FrmMain.FileAssosiationsPreferenceData.Assosiate;
  IconID.Position := FrmMain.FileAssosiationsPreferenceData.ImageIndex;
  IconIDChange(Self);

  CheckBox1.Checked := FrmMain.PalettePrefrenceData.GameSpecific;
end;

procedure TFrmPreferences.BtnApplyClick(Sender: TObject);
var
  Reg: TRegistry;
begin
  //Config.Icon:=IconID.Position;

  ExtractIcon;
  Reg :=TRegistry.Create;
  Reg.RootKey := HKEY_CLASSES_ROOT;
  Reg.OpenKey('\BS_SHP_BUILDER\DefaultIcon\',true);
  Reg.WriteString('',IconPath);
  Reg.CloseKey;
  Reg.Free;

if AssociateCheck.Checked = true then begin
 // Config.Assoc:=True;
  Reg :=TRegistry.Create;
  Reg.RootKey := HKEY_CLASSES_ROOT;
  Reg.OpenKey('\.shp\',true);
  Reg.WriteString('','BS_SHP_BUILDER');
  Reg.CloseKey;
  Reg.RootKey := HKEY_CLASSES_ROOT;
  Reg.OpenKey('\BS_SHP_BUILDER\shell\',true);
  Reg.WriteString('','Open');
  Reg.OpenKey('\BS_SHP_BUILDER\shell\open\command\',true);
  Reg.WriteString('',ParamStr(0)+' %1');
  Reg.CloseKey;
  Reg.RootKey := HKEY_CURRENT_USER;
  Reg.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.shp\',true);
  Reg.WriteString('Application',ParamStr(0)+' "%1"');
  Reg.CloseKey;
  Reg.Free;
  Close;
end else begin
 // Config.Assoc:=False;
  Reg :=TRegistry.Create;
  Reg.RootKey := HKEY_CLASSES_ROOT;
  Reg.DeleteKey('.shp');
  Reg.CloseKey;
  Reg.RootKey := HKEY_CLASSES_ROOT;
  Reg.DeleteKey('\BS_SHP_BUILDER\');
  Reg.CloseKey;
  Reg.RootKey := HKEY_CURRENT_USER;
  Reg.DeleteKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.shp\');
  Reg.CloseKey;
  Reg.Free;
  Close;
end;

end;

function GetComboBoxNo(filename:string; defult : cardinal): cardinal;
var
f_name : string;
x : integer;
begin
f_name := ansilowercase(filename);

result := defult;

begin

for x := 1 to FrmMain.PaletteSchemes_no do
if ansilowercase(FrmMain.PaletteSchemes[x].Filename) = f_name then
result := x-1;
end;

end;

function GetFilenameFromNo(itemindex:cardinal): string;
begin
result := FrmMain.PaletteSchemes[itemindex+1].Filename;
end;


procedure TFrmPreferences.FormShow(Sender: TObject);
var
x : integer;
begin
GetSettings;
PageControl1.ActivePageIndex := 0;
GroupBox1.Caption := 'File Associations';
         //  FrmMain.PaletteSchemes_no

UnitPalette.Images := FrmMain.ImageList;
BuildingPalette.Images := FrmMain.ImageList;
AnimationPalette.Images := FrmMain.ImageList;
CameoPalette.Images := FrmMain.ImageList;

for x := 1 to FrmMain.PaletteSchemes_no do
begin
UnitPalette.Items.Add(extractfilename(FrmMain.paletteschemes[x].filename));
UnitPalette.ItemsEx.ComboItems[x-1].ImageIndex := FrmMain.paletteschemes[x].ImageIndex;

BuildingPalette.Items.Add(extractfilename(FrmMain.paletteschemes[x].filename));
BuildingPalette.ItemsEx.ComboItems[x-1].ImageIndex := FrmMain.paletteschemes[x].ImageIndex;

AnimationPalette.Items.Add(extractfilename(FrmMain.paletteschemes[x].filename));
AnimationPalette.ItemsEx.ComboItems[x-1].ImageIndex := FrmMain.paletteschemes[x].ImageIndex;

CameoPalette.Items.Add(extractfilename(FrmMain.paletteschemes[x].filename));
CameoPalette.ItemsEx.ComboItems[x-1].ImageIndex := FrmMain.paletteschemes[x].ImageIndex;
end;

UnitPalette.ItemIndex := GetComboBoxNo(FrmMain.PalettePrefrenceData.UnitPalette.Filename,10);
AnimationPalette.ItemIndex := GetComboBoxNo(FrmMain.PalettePrefrenceData.AnimationPalette.Filename,0);
CameoPalette.ItemIndex := GetComboBoxNo(FrmMain.PalettePrefrenceData.CameoPalette.Filename,1);
BuildingPalette.ItemIndex := GetComboBoxNo(FrmMain.PalettePrefrenceData.BuildingPalette.Filename,10);

if FrmMain.alg = 1 then
RadioButton1.Checked := true
else
if FrmMain.alg = 2 then
RadioButton2.Checked := true
else
if FrmMain.alg = 3 then
RadioButton3.Checked := true
else
if FrmMain.alg = 4 then
RadioButton4.Checked := true;

end;

procedure TFrmPreferences.IconIDChange(Sender: TObject);
var MIcon: TIcon;//Icon: TResourceStream;


begin
 // Icon := TResourceStream.Create(hInstance,'Icon_'+IntToStr(IconID.Position+1),RT_RCDATA);
 MIcon := TIcon.Create;
 IconList.GetIcon(IconID.Position,MIcon);
 IconPrev.Picture.Icon := MIcon;
 // Icon.Free;
 MIcon.Free;
end;

procedure TFrmPreferences.Button2Click(Sender: TObject);
begin
FrmMain.PalettePrefrenceData.UnitPalette.Filename := GetFilenameFromNo(UnitPalette.ItemIndex);
FrmMain.PalettePrefrenceData.AnimationPalette.Filename := GetFilenameFromNo(AnimationPalette.ItemIndex);
FrmMain.PalettePrefrenceData.BuildingPalette.Filename := GetFilenameFromNo(BuildingPalette.ItemIndex);
FrmMain.PalettePrefrenceData.CameoPalette.Filename := GetFilenameFromNo(CameoPalette.ItemIndex);
FrmMain.PalettePrefrenceData.GameSpecific := CheckBox1.Checked;

FrmMain.FileAssosiationsPreferenceData.ImageIndex := IconID.Position;
FrmMain.FileAssosiationsPreferenceData.Assosiate := AssociateCheck.Checked;
BtnApplyClick(Sender);

if RadioButton1.Checked = true then
FrmMain.alg := 1
else
if RadioButton2.Checked = true then
FrmMain.alg := 2
else
if RadioButton3.Checked = true then
FrmMain.alg := 3
else
if RadioButton4.Checked = true then
FrmMain.alg := 4;

Close;
end;

procedure TFrmPreferences.Pref_ListClick(Sender: TObject);
begin
if pref_list.SelectionCount > 0 then
begin
if pref_list.Selected.Text = 'File Associations' then
PageControl1.ActivePageIndex := 0;

if pref_list.Selected.Text = 'Palette' then
PageControl1.ActivePageIndex := 1;

if pref_list.Selected.Text = 'Misc' then
PageControl1.ActivePageIndex := 2;

GroupBox1.Caption := pref_list.Selected.Text;

end;
end;

procedure TFrmPreferences.Pref_ListKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
Pref_ListClick(sender);
end;

procedure TFrmPreferences.Pref_ListKeyPress(Sender: TObject;
  var Key: Char);
begin
Pref_ListClick(sender);
end;

procedure TFrmPreferences.Pref_ListKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
Pref_ListClick(sender);
end;

procedure TFrmPreferences.CheckBox1Click(Sender: TObject);
begin
Label1.Enabled := CheckBox1.Checked;
Label2.Enabled := CheckBox1.Checked;
Label3.Enabled := CheckBox1.Checked;
Label4.Enabled := CheckBox1.Checked;

UnitPalette.Enabled := CheckBox1.Checked;
BuildingPalette.Enabled := CheckBox1.Checked;
AnimationPalette.Enabled := CheckBox1.Checked;
CameoPalette.Enabled := CheckBox1.Checked;
end;

end.
