program SHP_Builder;

uses
  Forms,
  FormMain in 'FormMain.pas' {FrmMain},
  Palette in 'Palette.pas',
  Shp_Engine in 'Shp_Engine.pas',
  Shp_File in 'Shp_File.pas',
  FormAbout in 'FormAbout.pas' {FrmAbout},
  FormNew in 'FormNew.pas' {FrmNew},
  FormPreview in 'FormPreview.pas' {FrmPreview},
  Shp_Engine_Image in 'Shp_Engine_Image.pas',
  FormReplaceColour in 'FormReplaceColour.pas' {frmReplaceColour},
  FormDarkenLightenTool in 'FormDarkenLightenTool.pas' {frmdarkenlightentool},
  FormPreferences in 'FormPreferences.pas' {FrmPreferences},
  FormAutoShadows in 'FormAutoShadows.pas' {FrmAutoShadows},
  FormResize in 'FormResize.pas' {FrmResize},
  Mouse in 'Mouse.pas',
  FormImportImageAsSHP in 'FormImportImageAsSHP.pas' {FrmImportImageAsSHP},
  FormSequence in 'FormSequence.pas' {FrmSequence};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'SHP Builder';
  Application.CreateForm(TFrmMain, FrmMain);
  Application.CreateForm(TFrmAbout, FrmAbout);
  Application.CreateForm(TFrmNew, FrmNew);
  Application.CreateForm(TFrmPreview, FrmPreview);
  Application.CreateForm(TfrmReplaceColour, frmReplaceColour);
  Application.CreateForm(Tfrmdarkenlightentool, frmdarkenlightentool);
  Application.CreateForm(TFrmPreferences, FrmPreferences);
  Application.CreateForm(TFrmAutoShadows, FrmAutoShadows);
  Application.CreateForm(TFrmResize, FrmResize);
  Application.CreateForm(TFrmImportImageAsSHP, FrmImportImageAsSHP);
  Application.CreateForm(TFrmSequence, FrmSequence);
  Application.Run;
end.
