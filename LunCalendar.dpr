program LunCalendar;

uses
  Vcl.Forms,
  uMainFrm in 'uMainFrm.pas' {MainForm},
  Calendar_func in 'units\Calendar_func.pas',
  elp2000_data in 'units\elp2000_data.pas',
  moon in 'units\moon.pas',
  Sun in 'units\Sun.pas',
  support in 'units\support.pas',
  td_utc in 'units\td_utc.pas',
  uCalendar_Const in 'units\uCalendar_Const.pas',
  uDayInfo in 'units\uDayInfo.pas',
  uNutation in 'units\uNutation.pas',
  uOther_fun in 'units\uOther_fun.pas',
  VSOP87D.Earth in 'units\VSOP87D.Earth.pas',
  VSOPD.DataConst in 'units\VSOPD.DataConst.pas',
  uConst in 'uConst.pas',
  uJSON_Helper in 'units\uJSON_Helper.pas',
  uSSQTool in 'units\uSSQTool.pas',
  AboutTTY in 'Form\AboutTTY.pas' {AboutBoxForm},
  uThreadTimer in 'Common\uThreadTimer.pas',
  uSimpleThread in 'Common\uSimpleThread.pas',
  uLunar in 'units\uLunar.pas',
  uChinaCalendar in 'units\uChinaCalendar.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := '中华天文历';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
