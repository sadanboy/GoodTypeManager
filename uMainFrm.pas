unit uMainFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Calendar_func, Vcl.StdCtrls, support, system.DateUtils, uCalendar_Const,
  uNutation, System.Math, VSOP87D.Earth, system.JSON, uJSON_Helper,
  system.Generics.Collections, Vcl.ExtCtrls, System.RegularExpressionsCore,
  System.RegularExpressions, System.StrUtils, Vcl.Menus, SynEdit, Vcl.ComCtrls,
  uThreadTimer;

type
  TTimeZoneInfo = record
    Country: string;
    Offset: Double;
    Code: string;
    Cities: string;
  end;

  TMyRecord = record
  private
    FName: string;
    FValue: Integer;
    FSomeChar: Char;
  public
    function ToString: string;
    procedure SetValue(NewString: string);
    procedure Init(NewValue: Integer);
  end;

  TMainForm = class(TForm)
    pnl1: TPanel;
    mmo1: TMemo;
    spl1: TSplitter;
    SynEdit1: TSynEdit;
    pnlTop: TPanel;
    cbbCity: TComboBox;
    cbbPro: TComboBox;
    lblLat: TLabel;
    lblLon: TLabel;
    pgcMain: TPageControl;
    tsMonthCalendar: TTabSheet;
    tsYearCalendar: TTabSheet;
    tsTest: TTabSheet;
    edt1: TEdit;
    edt2: TEdit;
    edt3: TEdit;
    btn10: TButton;
    btn11: TButton;
    btn7: TButton;
    btn5: TButton;
    btn6: TButton;
    btnTrunc: TButton;
    btnFloor: TButton;
    btn2: TButton;
    btn4: TButton;
    btn9: TButton;
    btn8: TButton;
    btn3: TButton;
    btn1: TButton;
    cbb1: TComboBox;
    pnlContinents: TPanel;
    lblDateTime: TLabel;
    lbl1: TLabel;
    lbl2: TLabel;
    cbbContinents: TComboBox;
    cbbSQ: TComboBox;
    lblSQDateTime: TLabel;
    lblCity: TLabel;
    btn12: TButton;
    btn13: TButton;
    edt4: TEdit;
    procedure FormDestroy(Sender: TObject);
    procedure AboutItemClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn10Click(Sender: TObject);
    procedure btn11Click(Sender: TObject);
    procedure btn12Click(Sender: TObject);
    procedure btn13Click(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure btn4Click(Sender: TObject);
    procedure btn5Click(Sender: TObject);
    procedure btn6Click(Sender: TObject);
    procedure btn7Click(Sender: TObject);
    procedure btn8Click(Sender: TObject);
    procedure btn9Click(Sender: TObject);
    procedure btnFloorClick(Sender: TObject);
    procedure btnTruncClick(Sender: TObject);
    procedure cbbCityChange(Sender: TObject);
    procedure cbbContinentsChange(Sender: TObject);
    procedure cbbProChange(Sender: TObject);
    procedure cbbSQChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FThreadTimer: TThreadTimer;
    CountryList: TList<TTimeZoneInfo>;  // 存储当前洲的国家信息
    procedure InitCombPro;
    procedure InitComCity;
    procedure InitLatLon;

    procedure OnThreadTimer(Sender: TThreadTimer);
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

function GetLocalTimezoneA: string;

procedure ShowMesLog(s: string);

implementation

uses
  uLunar, uConst, uSSQTool, AboutTTY, td_utc;
{$R *.dfm}

function GetActualPlatform:TOSVersion.TArchitecture;
begin
  Result:=TOSVersion.Architecture;
  if (TOSVersion.Major>=10)and(TOSVersion.Build>=16299) then
  begin
    var ProcessMachine:Word:=0;
    var NativeMachine:Word:=0;
    //if IsWow64Process(GetCurrentProcess,@ProcessMachine,@NativeMachine) then

  end;
end;
function ParseCountryInfo(const S: string): TTimeZoneInfo;
var
  CommaPos, FirstHash, SecondHash: Integer;
  OffsetStr, Rest: string;
begin
  // 查找逗号分隔国家名和后续信息
  CommaPos := Pos(',', S);
  if CommaPos = 0 then
    raise Exception.Create('Invalid format: missing comma');

  Result.Country := Copy(S, 1, CommaPos - 1);
  Rest := Copy(S, CommaPos + 1, MaxInt);

  // 查找第一个 '#'
  FirstHash := Pos('#', Rest);
  if FirstHash = 0 then
    raise Exception.Create('Invalid format: missing #');

  // 提取偏移量部分
  OffsetStr := Copy(Rest, 1, FirstHash - 1);
  Result.Offset := StrToFloatDef(OffsetStr, 0);

  // 剩余部分（从第一个#之后）
  Rest := Copy(Rest, FirstHash + 1, MaxInt);

  // 判断第二个字符是否为 '#'（即是否以 '##' 开头）
  if (Length(Rest) > 0) and (Rest[1] = '#') then
  begin
    // 格式：##城市（无代码）
    Result.Code := '';
    Result.Cities := Copy(Rest, 2, MaxInt);  // 跳过两个 #
  end
  else
  begin
    // 格式：#代码#城市
    SecondHash := Pos('#', Rest);
    if SecondHash = 0 then
      raise Exception.Create('Invalid format: missing second #');
    Result.Code := Copy(Rest, 1, SecondHash - 1);
    Result.Cities := Copy(Rest, SecondHash + 1, MaxInt);
  end;
end;

procedure FillContinentComboBox(Combo: TComboBox);
var
  I: Integer;
begin
  Combo.Items.BeginUpdate;
  try
    Combo.Clear;
    for I := 0 to High(Continents) do
      Combo.Items.Add(Continents[I].Continents);
  finally
    Combo.Items.EndUpdate;
  end;
end;

procedure FillCountryComboBox(ContinentIndex: Integer; Combo: TComboBox; CountryList: TList<TTimeZoneInfo>);
var
  I: Integer;
  Info: TTimeZoneInfo;
begin
  CountryList.Clear;
  Combo.Items.BeginUpdate;
  try
    Combo.Clear;
    for I := Continents[ContinentIndex].beginn to Continents[ContinentIndex].ende do
    begin
      Info := ParseCountryInfo(SQv[I]);  // 假设 ParseCountryInfo 已定义
      CountryList.Add(Info);
      Combo.Items.Add(Info.Country);
    end;
  finally
    Combo.Items.EndUpdate;
  end;
end;

procedure UpdateCountryDisplay(CountryIndex: Integer; CountryList: TList<TTimeZoneInfo>; CityLabel, TimeLabel: TLabel);
var
  Info: TTimeZoneInfo;
  UTCTime, LocalTime: TDateTime;
begin
  if (CountryIndex < 0) or (CountryIndex >= CountryList.Count) then
  begin
    CityLabel.Caption := '';
    TimeLabel.Caption := '';
    Exit;
  end;

  Info := CountryList[CountryIndex];
  CityLabel.Caption := '主要城市：' + Info.Cities;

  UTCTime := TTimeZone.local.ToUniversalTime(Now);
  LocalTime := UTCTime + Info.Offset / 24;
  TimeLabel.Caption := Format('当前时间：%s', [FormatDateTime('dd日 hh:nn:ss', LocalTime)]);
end;

procedure ShowMesLog(s: string);
begin

  MainForm.mmo1.Lines.Add(s);
  if MainForm.mmo1.Lines.Count > 5000 then
    MainForm.mmo1.lines.Clear;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin

  FThreadTimer.Free; // 因在父类中已设计好，此处直接 free 即可，像普通类那样对待即可
  CountryList.Free;
end;

procedure TMainForm.AboutItemClick(Sender: TObject);
var
  dlg: TAboutBoxForm;
begin
  dlg := nil;
  try
    dlg := TAboutBoxForm.Create(Self, True);
    dlg.ShowModal;
  finally
    FreeAndNil(dlg);
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  CountryList := TList<TTimeZoneInfo>.Create;
  FThreadTimer := TThreadTimer.Create;
  FThreadTimer.OnThreadTimer := Self.OnThreadTimer; // 给指定 OnThreadTimer 事件
  FThreadTimer.Interval := 1000; // 间隔 1 秒
  FThreadTimer.StartThread; // 启动线程
  edt1.Text := YearOf(Now).ToString;
  edt2.Text := MonthOf(Now).ToString;
  edt3.Text := DayOf(Now).ToString;
  InitCombPro;
  InitComCity;
  InitLatLon;
  FillContinentComboBox(cbbContinents);
  if cbbContinents.Items.Count > 0 then
    cbbContinents.ItemIndex := 0;            // 触发 ComboBox1Change
  FillCountryComboBox(cbbContinents.ItemIndex, cbbSQ, CountryList);
  if cbbSQ.Items.Count > 0 then
    cbbSQ.ItemIndex := 0;
end;

procedure TMainForm.InitCombPro;
var
  i: Integer;
begin
  cbbPro.Items.Clear;
  for i := 0 to 33 do
  begin
    cbbPro.Items.Add(pro[i].provence);
  end;
  cbbPro.ItemIndex := 0;
end;

procedure TMainForm.InitComCity;
var
  i: Integer;
begin
  cbbCity.Items.Clear;
  for i := pro[cbbPro.ItemIndex].beginn to pro[cbbPro.ItemIndex].ende do
  begin
    cbbCity.Items.Add(City[i])
  end;
  cbbCity.ItemIndex := 0;
end;

procedure TMainForm.InitLatLon;
var
  dsp: string;
  i: Integer;
begin
  dsp := cbbCity.Text;
  for i := 0 to 3191 do
  begin
    if SameStr(city[i], dsp) then
    begin
//      lbl13.Caption:=Format('经度：%4.2f',[lon[i]]);
//      FFa:=lon[i];
      lblLat.Caption := '经度：' + RadToStr2(lon[i]);
//      lbl14.Caption:=Format('纬度：%4.2f',[lat[i]]);
//      FLa:=lat[i];
      lblLon.Caption := '纬度：' + RadToStr2(lat[i]);
    end;
  end;
end;

procedure TMainForm.OnThreadTimer(Sender: TThreadTimer);
begin
  // 因为此过程中的代码是在线程中执行，又需要访问 vcl 即 memMsg
  // 所以要用这样写。把访问 vcl 的代码提升到主线程来执行
  // 另可用 TThread.Queue ，用法类似
  TThread.Synchronize(nil,
    procedure
    begin
      lblDateTime.Caption := FormatDateTime('yyyy年mm月dd日 hh:mm:ss', Now);
      if cbbSQ.ItemIndex >= 0 then
        UpdateCountryDisplay(cbbSQ.ItemIndex, CountryList, lblCity, lblSQDateTime);
    end);
end;

procedure TMainForm.btn10Click(Sender: TObject);
var
  B: TArray<string>;
  i: Integer;
  s: string;
  Index: Integer;
  arrName: string;
begin
  s := Trim(mmo1.Text);
  s := s.Substring(0, s.Length - 1).Trim;
  if not s.IsEmpty then
    B := s.Split([','])
  else
    Exit;
  s := '';
  for i := Low(B) to High(B) do
  begin
    if (i mod 3) = 0 then
      s := s + IfThen(not s.IsEmpty, ',' + #13#10, '') + '(A: ' + B[i] + ';  B: ' + B[i + 1] + ';  C: ' + B[i + 2] + ' )';
  end;
  SynEdit1.Lines.Clear;
  SynEdit1.Lines.Add(s);
end;

procedure TMainForm.btn11Click(Sender: TObject);
var
  F: Extended;
begin
//  f:=XL0[0];
//  ShowMesLog(f.ToString);
//  f:=XL0[1];
//  ShowMesLog(f.ToString);
//  f:=XL0[2];
//  ShowMesLog(f.ToString);
end;

procedure TMainForm.btn12Click(Sender: TObject);
var
  w, y, m, d, h, mm, s: Integer;
begin
  y := StrToIntDef(edt1.Text, 2000);
  m := StrToIntDef(edt2.Text, 1);
  d := StrToIntDef(edt3.Text, 1);
  h := 12;
  mm := 0;
  s := 0;
  w := ZellerWeek(y, m, d);
  mmo1.Lines.Add(y.ToString + '年' + m.ToString + '月' + d.ToString + '日' + h.ToString + ':' + mm.ToString + ':' + s.ToString + '的儒略日为：' + CalculateJulianDay(y, m, d, h, mm, s).ToString + WeekEnName(w, True));
  w := GetWeek(y, m, d);
  mmo1.Lines.Add(y.ToString + '年' + m.ToString + '月' + d.ToString + '日' + h.ToString + ':' + mm.ToString + ':' + s.ToString + '的儒略日为：' + CalculateJulianDay(y, m, d + 0.5).ToString + '星期' + WeekCnName(w));
end;

procedure TMainForm.btn13Click(Sender: TObject);
var
  i: Integer;
  j:Double;
  jd:Double;
  s:string;
begin
   jd:= 2461105.08339965;
   j:=td_utc.dt_T(jd-jd2000);
   mmo1.Lines.Add(j.ToString);
   mmo1.Lines.Add('------------');
   
   mmo1.Lines.Add('------------');
   j:= CalcEarthLongitudeNutation((jd-jd2000)/36525)/RADIAN_PER_ANGLE/100;
   mmo1.Lines.Add(j.ToString);
   var y0:= deltaTbl[Length(deltaTbl)-1].year;
   var t0:= deltaTbl[Length(deltaTbl)-1].d1;
   mmo1.Lines.Add('$$$$$$$$$$$$$$$$$$$$$$$$');
   mmo1.Lines.Add(y0.ToString);
   mmo1.Lines.Add(t0.ToString);
   mmo1.Lines.Add('------------------');
   mmo1.Lines.Add(SizeOf(deltaTbl).ToString);
   mmo1.Lines.Add(SizeOf(deltaTbl[0]).ToString);
   mmo1.Lines.Add(((SizeOf(deltaTbl)) div (SizeOf(deltaTbl[0]))) .ToString);
   mmo1.Lines.Add(High(deltaTbl).ToString);
   mmo1.Lines.Add('****************************');
   //jd:=2436116.31;
   jd:=StrToFloatDef(edt4.Text,2436116.31);
   s:=JDtoStr(jd);
   mmo1.Lines.Add(s);
   //NormalizeAngle
end;

procedure TMainForm.btn1Click(Sender: TObject);
var
  SolarTermss: TArray<Double>;
  SolarTermStr: TArray<string>;
  i: Integer;
  ss: string;
  dt: TDateTime;
  year: Integer;
  dtt: Double;
begin
  mmo1.Lines.Clear;
  year := StrToIntDef(edt1.Text, 2012);
  SetLength(SolarTermss, 24);
  SetLength(SolarTermStr, 24);
  dtt := CalculateSolarTerms(year, 345);
  for i := 0 to 23 do
  begin
    SolarTermss[i] := CalculateSolarTerms(year, (SJieQiArray[i].JQNo) * 15);
      //dt:= GMTToLocalTime(JDtoDatetime(SolarTermss[i]));
      //SolarTermStr[i]:= FormatDateTime('YYYY-MM-DD HH:mm:ss',dt);
      //ss:=FormatDateTime('YYYY-MM-DD HH:mm:ss',dt)+' '+jqB[i] +' jd'+ SolarTermss[i].ToString;
    ss := JDtoStr((SolarTermss[i]) + 8 / 24 - dt_T(SolarTermss[i] / 36525)) + ' ' + SJieQiArray[i].JQMC + ' jd  ' + (SolarTermss[i]).ToString;
      //ss:=JDNToHHMMSS(SolarTermss[i]);
    mmo1.Lines.Add(ss);
  end;
  mmo1.Lines.Add('-----------------------------------------');
  ss := JDtoStr(2461105.083436179 + 8 / 24) + ' ' + jqB[23] + ' jd  ' + dtt.ToString;
  mmo1.Lines.Add(ss);
  var f: Double := 8 / 24;
  ss := f.ToString;
  mmo1.Lines.Add(ss);
  mmo1.Lines.Add('-----------------------------------------');
//   for I := 0 to 23 do
//    begin
//        SolarTermss[i]:= CalculateSolarTerms(year,(SCnJieQiArray[i].JQNo)*15);
//      //dt:= GMTToLocalTime(JDtoDatetime(SolarTermss[i]));
//      //SolarTermStr[i]:= FormatDateTime('YYYY-MM-DD HH:mm:ss',dt);
//      //ss:=FormatDateTime('YYYY-MM-DD HH:mm:ss',dt)+' '+jqB[i] +' jd'+ SolarTermss[i].ToString;
//      ss:=JDtoStr(((SolarTermss[i]-dt_T(SolarTermss[i]-JD2000))+8/24))+' '+SCnJieQiArray[i].JQMC +' jd  '+ ((SolarTermss[i]-dt_T(SolarTermss[i]-JD2000))+8/24).ToString;
//      //ss:=JDNToHHMMSS(SolarTermss[i]);
//      mmo1.Lines.Add(ss);
//    end;
  ss := JDNToHHMMSS(0.083436179 + 8 / 24);
  mmo1.Lines.Add(ss);
end;

procedure TMainForm.btn2Click(Sender: TObject);
var
  y0: Integer;
begin
  y0 := deltaTbl[Length(deltaTbl) - 1].year;
  //ShowMessage(y0.ToString+'  '+Length(Earth_L0).ToString+'  '+(SizeOf(Earth_L0) div SizeOf(Earth_L0[0])).ToString);
  ShowMessage(Length(Earth_L0).ToString + '  ' + High(Earth_L0).ToString);
  ShowMessage(SizeOf(Earth_L0[0]).ToString);
  //ShowMessage(GetLocalTimezoneA);
  ShowMessage(DegToRad(1072260.70369).ToString);
end;

procedure TMainForm.btn3Click(Sender: TObject);
var
  jo: TJSONObject;
  S: string;
  sName: string;
  iAge: Integer;
  bSex: Boolean;
  sBirth: string;
  iSalary: Int64;
  sHobby1: string;
begin
  jo := TJSONObject.Create;
  try
    //赋值操作
    jo.S['name'] := 'sensor';
    jo.I['age'] := 50;
    jo.B['sex'] := True;     //True表示男，False表示女
    jo.D['Birth'] := StrToDateTime('1970-02-13');   //日期型参数
    //子对象
    jo.O['workplace'] := TJSONObject.Create;
    jo.O['workplace'].S['address'] := '深圳市南山区科技园';
    jo.O['workplace'].S['tel'] := '0755-831788xx';
    jo.O['workplace'].I64['salary'] := 9223372036854775807;
    //数组
    jo.A['hobbies'] := TJSONArray.Create;
    jo.A['hobbies'].Add('乒乓球');
    jo.A['hobbies'].Add('下象棋');
    //S := jo.ToJSON;
    //S := jo.ToString;
    S := jo.Format;  //格式化成字符串,Delphi 10.3以后才有的格式化功能
    mmo1.Lines.Add(S);
    //读取操作
    sName := jo.S['name'];   //sensor
    iAge := jo.I['age'];    //57
    bSex := jo.B['sex'];    //True
    sBirth := FormatDateTime('YYYY-MM-DD', jo.D['Birth']);  // 1970-02-13
    iSalary := jo.O['workplace'].I64['salary'];   // 9223372036854775807
    sHobby1 := jo.A['hobbies'].Items[0].Value;    // 乒乓球

    S := '姓名：' + sName + sLineBreak + '' + iAge.ToString + sLineBreak + '' + bSex.ToString(bSex);
    //删除操作
    jo.DeletePair('sex');     // 删除性别 函数法
    jo.Delete['sex'];         // 删除性别 数组法
    S := S + sLineBreak + jo.Format;
    mmo1.Lines.Add(S);
  finally
    jo.Free;
  end;

end;

procedure TMainForm.btn4Click(Sender: TObject);
var
//p:pchar;
  s: string;
begin
  s := 'hello world';
  if s.Compare(s, 'Hello world') = 0 then
    ShowMessage('OK')
  else
    ShowMessage('No');

//  getmem(p,255);
//  getwindowtext(Self.Handle,p,255);
//  showmessage(strpas(p));
//  freemem(p);
end;

procedure TMainForm.btn5Click(Sender: TObject);
var
  p: Double;
  str: string;
  arr: TArray<string>;
begin
  p := (4 * Tan(1.0));
  ShowMessage(p.ToString);
  ShowMessage(FloatToStr(1 / Tan(Pi / 6)));
  mmo1.Lines.Clear;
  str := 'A-1,B-2,,,C-3,D-4';
  mmo1.Lines.Add(str);
  arr := str.Split([',']); // arr[0] = A-1; Length(arr) = 6
  mmo1.Lines.Add(Length(arr).ToString);
  arr := str.Split([','], TStringSplitOptions.ExcludeEmpty); // 忽略空项; Length(arr) = 4
  mmo1.Lines.Add(Length(arr).ToString);
  arr := str.Split([','], 2); // 只提取前 2
  mmo1.Lines.Add(Length(arr).ToString);
  arr := str.Split([',', '-'], TStringSplitOptions.ExcludeEmpty); //arr[0] = A; Length(arr)= 8
  mmo1.Lines.Add(Length(arr).ToString);
  arr := str.Split([',,,'], TStringSplitOptions.None); // 分隔符可以是一个字符串数组
  mmo1.Lines.Add(Length(arr).ToString);
end;

procedure TMainForm.btn6Click(Sender: TObject);
var
  MyRec: TMyRecord;
  mydateinfo: TChinaDateInfo;
  i: Integer;
  s: string;
  month: Integer;
  day: Integer;
  year: Integer;
begin
  year := StrToIntDef(edt1.Text, 2024);
  month := StrToIntDef(edt2.Text, 11);
  day := StrToIntDef(edt3.Text, 1);
  mmo1.Lines.Clear;
  MyRec.Init(10);
  MyRec.SetValue('Hello');
  mmo1.Lines.Add(MyRec.ToString);
  mmo1.Lines.Add(MyRec.FValue.ToString);
  mmo1.Lines.Add('----------------------------------');
  with mydateinfo do
  begin
    FYear := year;
    FMonth := month;
    FDay := day;
    FWeek := 2;
  end;
  mydateinfo.InitsFtv;
  mydateinfo.getDayName;

  mmo1.Lines.Add(Low(mydateinfo.sFtv).ToString);
  mmo1.Lines.Add(High(mydateinfo.sFtv).ToString);
  mmo1.Lines.Add(Length(mydateinfo.sFtv[month - 1]).ToString);
  mmo1.Lines.Add('------------------------------------');
  for i := Low(mydateinfo.sFtv[month - 1]) to High(mydateinfo.sFtv[month - 1]) do
  begin
    s := mydateinfo.sFtv[month - 1][i];
    mmo1.Lines.Add(s);
  end;
  mmo1.Lines.Add('------------------------------------');
//  for I := Low(wFtv) to High(wFtv) do
//    mmo1.Lines.Add(wFtv[i]);
  mmo1.Lines.Add(mydateinfo.FA);
  mmo1.Lines.Add(mydateinfo.FB);
  mmo1.Lines.Add(mydateinfo.FC);
  mmo1.Lines.Add('------------------------------------');
  mmo1.Lines.Add(mydateinfo.getNH(year));
  SynEdit1.Lines.Add(mydateinfo.getNH(year));
end;

procedure TMainForm.btn7Click(Sender: TObject);
var
  year, q: string;
  //RegEx:TPerlRegEx;
  s: string;
  h: double;
begin
  year := edt1.Text;
  year := year2ayear(year);
  showmessage(year);
  s := '21:12:20';
  h := timestrtohour(s);
  showmessage(h.ToString);
end;

procedure TMainForm.btn8Click(Sender: TObject);
var
  f1: Double;
begin
  mmo1.Clear;
  mmo1.Lines.Add(QBstr);
  mmo1.Lines.Add('---------');
  mmo1.Lines.Add(SBstr);
  f1 := calc(1, qiType);
  ShowMessage(f1.ToString);
end;

procedure TMainForm.btn9Click(Sender: TObject);
var
  RegEx: TPerlRegEx;
begin
   //
  RegEx := TPerlRegEx.Create;
  try
    RegEx.Subject := '0371-12345678';
    mmo1.Lines.Add(RegEx.Subject);
    RegEx.RegEx := '(\d{3,4})-(\d{8})';
    RegEx.Replacement := '($1)$2';
    RegEx.ReplaceAll;
    mmo1.Lines.Add(RegEx.Subject);
    RegEx.Subject := '0371-12345678';
    mmo1.Lines.Add(RegEx.Subject);
    RegEx.RegEx := '((\d{3,4})-(\d{8}))';
    RegEx.Replacement := '固话$1的区号时$2，号码是$3';
    RegEx.ReplaceAll;
    mmo1.Lines.Add(RegEx.Subject);
  finally
    RegEx.Free;
  end;
end;

procedure TMainForm.btnFloorClick(Sender: TObject);
var
  x: Double;
begin

  x := StrToFloatDef(edt1.Text, 0.0);
  mmo1.Lines.Add(x.ToString + 'Floor 取整后结果' + Floor(x).ToString);
  mmo1.Lines.Add(x.ToString + 'Ceil 取整后结果' + ceil(x).ToString);
  mmo1.Lines.Add(x.ToString + 'Trunc 取整后结果' + Trunc(x).ToString);
  mmo1.Lines.Add(x.ToString + 'Round 取整后结果' + Round(x).ToString);
  mmo1.Lines.Add(RadToStr(3.12, rfDMS, 0));
  mmo1.Lines.Add(RadToStr(3.12, rfHMS, 0));
end;

procedure TMainForm.btnTruncClick(Sender: TObject);
var
  x: Double;
  s: string;
begin
  x := StrToFloatDef(edt1.Text, 0.0);
  s := Mod360Degree(x).ToString;
  mmo1.Lines.Add(s);
end;

procedure TMainForm.cbbCityChange(Sender: TObject);
begin
  InitLatLon;
end;

procedure TMainForm.cbbContinentsChange(Sender: TObject);
begin
  if cbbContinents.ItemIndex < 0 then
    Exit;
  FillCountryComboBox(cbbContinents.ItemIndex, cbbSQ, CountryList);
  if cbbSQ.Items.Count > 0 then
    cbbSQ.ItemIndex := 0;            // 触发 ComboBox2Change
end;

procedure TMainForm.cbbProChange(Sender: TObject);
begin
  InitComCity;
  InitLatLon;
end;

procedure TMainForm.cbbSQChange(Sender: TObject);
begin
  UpdateCountryDisplay(cbbSQ.ItemIndex, CountryList, lblCity, lblSQDateTime);
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  lblDateTime.Caption := FormatDateTime('yyyy年mm月dd日 hh:mm:ss', Now);
  UpdateCountryDisplay(cbbSQ.ItemIndex, CountryList, lblCity, lblSQDateTime);
end;

function GetLocalTimezoneA: string;
var
  TimeZoneInfo: TTimeZoneInformation;
begin
  if GetTimeZoneInformation(TimeZoneInfo) = TIME_ZONE_ID_INVALID then
    Result := '' // 无法获取本地时区信息
  else
    //SetString(Result, PChar(@TimeZoneInfo), SizeOf(TTimeZoneInformation));
    Result := TimeZoneInfo.StandardBias.ToString + sLineBreak + TimeZoneInfo.Bias.ToString + sLineBreak + TimeZoneInfo.StandardName + sLineBreak + TimeZoneInfo.StandardBias.ToString;
end;

{ TMyRecord }

procedure TMyRecord.Init(NewValue: Integer);
begin
  FValue := NewValue;
  FSomeChar := 'A';
end;

procedure TMyRecord.SetValue(NewString: string);
begin
  FName := NewString;
end;

function TMyRecord.ToString: string;
begin
  Result := FName + ' [' + FSomeChar + ']: ' + FValue.ToString;
end;

end.

