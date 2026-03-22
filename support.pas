unit support;

interface

uses
  System.SysUtils, System.Math, System.DateUtils, System.TimeSpan,
  Winapi.Windows, uCalendar_Const, System.RegularExpressions,
  System.RegularExpressionsCore,System.SysConst;

const
  DaysOfMonth: array[1..12] of Integer = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);

type
  WZDAYTIME = record
    year: Integer;
    month: Integer;
    day: Integer;
    hour: Integer;
    minute: Integer;
    second: Double;
  end;

TRadianFormat = (rfDMS,   // 度分秒格式 (Degrees, Minutes, Seconds)
                   rfHMS);  // 时分秒格式 (Hours, Minutes, Seconds)
/// <summary>
/// 判断某年是否为闰年，
/// </summary>
/// <param name="year"></param>
/// <returns></returns>

function IsLeapYear(year: Integer): Boolean;
(*
判断是否是启用格里历以后的日期
1582年，罗马教皇将1582年10月4日指定为1582年10月15日，从此废止了凯撒大帝制定的儒略历，
改用格里历
*)

function IsGregorianDays(year, month, day: Integer): Boolean;
/// <summary>
/// 计算儒略日
/// </summary>
/// <param name="year"></param>
/// <param name="month"></param>
/// <param name="day"></param>
/// <param name="hour"></param>
/// <param name="minute"></param>
/// <param name="second"></param>
/// <returns>儒略日</returns>

function CalculateJulianDay(year, month, day, hour, minute: Integer; second: Double): Double; overload

/// <summary>
/// 计算儒略日
/// </summary>
/// <param name="year"></param>
/// <param name="month"></param>
/// <param name="day"></param>
/// <returns></returns>

function CalculateJulianDay(const year, month: Integer; const day: Double): Double; overload

/// <summary>
/// 获取一个月的天数
/// </summary>
/// <param name="year">年</param>
/// <param name="month">月</param>
/// <returns>月的天数</returns>

function GetDaysOfMonth(year: Integer; month: Integer): Integer;

function GetDaysOfMonthA(year: Integer; month: Integer): Integer;
/// <summary>
/// 度数转未弧度值
/// </summary>
/// <param name="degree">度数</param>
/// <returns>弧度</returns>

function DegreeToRadian(degree: Double): Double;
/// <summary>
/// 弧度转度数
/// </summary>
/// <param name="radian"></param>
/// <returns></returns>

function RadianToDegree(radian: Double): Double;
/// <summary>
/// 将角度置于0°--360°之间
/// </summary>
/// <param name="degree"></param>
/// <returns>度</returns>

function Mod360Degree(degree: Double): Double;

/// <summary>
/// 对超过0-2PI的角度转为0-2PI
/// </summary>
/// <param name="rad">弧度超过-PI到PI的弧度</param>
/// <returns>弧度</returns>
function rad2mrad(rad: Double): Double;
/// <summary>
/// 对超过-PI到PI的角度转为-PI到PI
/// </summary>
/// <param name="rad">弧度超过-PI到PI的弧度</param>
/// <returns>弧度</returns>

function rad2rrad(rad: Double): Double;
/// <summary>
/// 蔡勒公式计算星期数
/// </summary>
/// <param name="year">年</param>
/// <param name="month">月</param>
/// <param name="day">日</param>
/// <returns></returns>

function ZellerWeek(year: Integer; month: Integer; day: Integer): Integer;

function GetWeek(const year, month, day: Integer): Integer;

function JDNToHHMMSS(JD: Double): string;

function sunLat(dt: Double): Double;
/// <summary>
/// jd：儒略日
///  La地理经度
///  fa地理纬度
///  TZ时区
///  返回太阳升起时间
/// </summary>
//jd儒略日平午，La地理经度，fa地理纬度，TZ时区，返回太阳升起时间

function sheng(jd, La, fa, TZ: Double): Double;

function JDtoDatetime(const JD: Double): TDatetime;

/// <summary>
/// 儒略日数转公历
/// 传入儒略日
/// </summary>
/// <param name="JD"></param>
/// <returns></returns>
function JDtoGregorianDays(const JD: Extended): WZDAYTIME;

function GregorianDaystoStr(const pDT: WZDAYTIME): string;

function GMTToLocalTime(GMTTime: TDateTime): TDateTime;

function JDtoStr(jd: Extended): string;
/// <summary>
/// 取得本地区时区
/// </summary>
/// <returns></returns>

function GetLocalTimezone: Integer;
/// <summary>
/// 将格林尼治时间转换为本地时间
/// </summary>
/// <param name="localJD"></param>
/// <returns></returns>

function JDLocalTimetoTD(localJD: double): Double;

procedure GetDayTimeFromJulianDay(jd: Double; var pDT: WZDAYTIME);

/// <param name="Rad">弧度</param>
/// <param name="FormatType">字符串格式0:输出格式示例: -23°59'48.23" 1:输出格式示例:18h29m44.52s</param>
/// <param name="ext">小数点保留位数默认保留2位</param>
/// <returns></returns>
function RadToStrE(const Rad: Double; FormatType: TRadianFormat; ext: ShortInt = 2): string;

/// <summary>
/// 将弧度转为字串,保留2位
/// </summary>
/// <param name="Rad"></param>
/// <param name="FormatType">字符串格式0:输出格式示例: -23°59'48.23" 1:输出格式示例:18h29m44.52s</param>
/// <returns></returns>
function RadToStr(const Rad: Double; FormatType: TRadianFormat;ext: ShortInt = 2): string;

/// <summary>
/// 将弧度转为字串,精确到分
/// </summary>
/// <param name="Rad">弧度</param>
/// <returns>输出格式示例: -23°59'</returns>
function RadToStr2(const Rad: Double): string;
//传入普通纪年或天文纪年，传回天文纪年

function year2Ayear(const c: string): string;
//传入天文纪年，传回显示用的常规纪年

function Ayear2year(const year: Integer): string;
//时间串转为小时

function TimeStrToHour(s: string): Double;
/// <summary>
///  取得英文星期名称
/// </summary>
/// <param name="aWeekDay"></param>
/// <param name="l"></param>
/// <returns></returns>
function WeekEnName(aWeekDay : Integer ; l : boolean = false): string;

function WeekCnName(aWeekDay : Integer ): string;

function MonthEnName(aMonth : Integer ; l : Boolean = false): string;
implementation
/// <summary>
///  取得英文星期名称
/// </summary>
/// <param name="aWeekDay"></param>
/// <param name="l"></param>
/// <returns></returns>
function WeekEnName(aWeekDay : Integer ; l : boolean = false): string;
const
  DefShortDayNames: array[0..6] of string = (SShortDayNameSun,
    SShortDayNameMon, SShortDayNameTue, SShortDayNameWed,
    SShortDayNameThu, SShortDayNameFri, SShortDayNameSat);

  DefLongDayNames: array[0..6] of string = (SLongDayNameSun,
    SLongDayNameMon, SLongDayNameTue, SLongDayNameWed,
    SLongDayNameThu, SLongDayNameFri, SLongDayNameSat);
begin
  case l of
    False :
       Result := DefShortDayNames[aWeekDay];
    True :
       Result := DefLongDayNames[aWeekDay];
  end;
end;

function WeekCnName(aWeekDay : Integer ): string;
const
  nStr1 : Array[0..6] of string =('日','一','二','三','四','五','六');
begin
  Result := nStr1[aWeekDay];
end;

function MonthEnName(aMonth : Integer ; l : Boolean = false): string;
const
  DefShortMonthNames: array[1..12] of string = (SShortMonthNameJan,
    SShortMonthNameFeb, SShortMonthNameMar, SShortMonthNameApr,
    SShortMonthNameMay, SShortMonthNameJun, SShortMonthNameJul,
    SShortMonthNameAug, SShortMonthNameSep, SShortMonthNameOct,
    SShortMonthNameNov, SShortMonthNameDec);

  DefLongMonthNames: array[1..12] of string = (SLongMonthNameJan,
    SLongMonthNameFeb, SLongMonthNameMar, SLongMonthNameApr,
    SLongMonthNameMay, SLongMonthNameJun, SLongMonthNameJul,
    SLongMonthNameAug, SLongMonthNameSep, SLongMonthNameOct,
    SLongMonthNameNov, SLongMonthNameDec);

begin
  case l of
    True : Result := DefLongMonthNames[aMonth];
    False: Result := DefShortMonthNames[aMonth];
  end;
end;
//字符串处理函数

function RadToStrE(const Rad: Double; FormatType: TRadianFormat; ext: ShortInt): string;
var
  w1, w2, w3: string;
  s, astr, bstr, cstr, dstr: string;
  dd: Double;
  a, b, c, d, q: Integer;
begin
  if Rad < 0 then
  begin
    dd := -Rad;
    s := '-';
  end
  else
  begin
    dd := Rad;
    s := '';
  end;
  case FormatType of
    rfDMS:
      begin
        w1 := '°';
        w2 := '''';
        w3 := '"';
        dd := dd * 180 / Pi;
      end;
    rfHMS:
      begin
        w1 := 'h';
        w2 := 'm';
        w3 := 's';
        dd := dd * 12 / Pi;
      end;
  end;
  a := Floor(dd);
  dd := (dd - a) * 60;
  b := Floor(dd);
  dd := (dd - b) * 60;
  c := Floor(dd);
  q := Floor(Power(10, ext));
  d := Floor((dd - c) * q + 0.5);
  if d > q then
  begin
    d := d - q;
    Inc(c);
  end;
  if c >= 60 then
  begin
    c := c - 60;
    Inc(b);
  end;
  if b >= 60 then
  begin
    b := b - 60;
    Inc(a);
  end;
  astr := '   ' + a.toString;
  bstr := '0' + b.ToString;
  cstr := '0' + c.ToString;
  dstr := '0000' + d.ToString;
  s := s + astr.Substring(astr.Length - 3, 3) + w1;
  s := s + bstr.Substring(bstr.Length - 2, 2) + w2;
  s := s + cstr.Substring(cstr.Length - 2, 2);
  if (ext > 0) then
    s := s + '.' + dstr.Substring(dstr.Length - ext, ext) + w3;
  if (ext <= 0) then
    s := s + w3;
  Result := s;
end;

function RadToStr(const Rad: Double; FormatType: TRadianFormat;ext: ShortInt = 2): string;
begin
  Result := RadTostrE(Rad, FormatType,ext);
end;
//输出格式示例: -23°59'

function RadToStr2(const Rad: Double): string; //将弧度转为字串,精确到分
var
  s, astr, bstr: string;
  dd: Double;
  w1, w2, w3: string;
  a, b: Integer;
begin
  dd := Rad;
  s := '+';
  w1 := '°';
  w2 := '''';
  w3 := '"';
  if Rad < 0 then
  begin
    dd := abs(Rad);
    s := '-';
  end;
  //dd := dd * 180 / pi;
  a := Floor(dd);
  b := Floor((dd - a) * 60 + 0.5);
  if (b >= 60) then
  begin
    b := b - 60;
    Inc(a);
  end;
  astr := '    ' + a.ToString;
  bstr := '0' + b.ToString;
  s := s + astr.Substring(astr.Length - 3, 3) + w1;
  s := s + bstr.Substring(bstr.Length - 2, 2) + w2;
  Result := s;
end;

function year2Ayear(const c: string): string;
var
  year, q: string;
  RegEx: TPerlRegEx;
  y: Integer;
begin
  RegEx := TPerlRegEx.Create;
  try
    RegEx.Subject := c;
    RegEx.RegEx := '[^0-9Bb\*-]';
    RegEx.Replacement := '';
    RegEx.Options := [preCaseLess];
    RegEx.ReplaceAll;
    year := RegEx.Subject;
    q := year.Substring(0, 1);
    if (q = 'B') or (q = 'b') or (q = '*') then  //通用纪年法(公元前)
    begin
      y := 1 - year.Substring(1, year.Length).ToInteger;
      if y > 0 then
      begin
        y := 0;
        Exit('通用纪法的公元前纪法从B.C.1年开始。并且没有公元0年');
      end;
    end
    else
      y := year.ToInteger;
    if (y < -4712) then
    begin
      y := -4712;
      Exit('超过B.C. 4713不准')
    end;
    if (y > 9999) then
    begin
      y := 9999;
      Exit('超过9999年的农历计算很不准。')
    end;
    Result := y.ToString;
  finally
    RegEx.Free;
  end;
end;

function Ayear2year(const year: Integer): string;
begin
  if year < 0 then
    Result := 'B' + (-year + 1).ToString;
  Result := year.ToString;
end;

//时间串转为小时
function TimeStrToHour(s: string): Double;
var
  RegEx: TPerlRegEx;
  Str: TArray<string>;
  a, b: Integer;
  c: Double;
begin
  RegEx := TPerlRegEx.Create;
  try
    RegEx.Subject := s;
    RegEx.RegEx := '[^0-9:\.]';
    RegEx.Replacement := '';
    RegEx.Options := [preCaseLess];
    RegEx.ReplaceAll;
    Str := RegEx.Subject.Split([':']);
    if Length(Str) = 1 then
    begin
      a := Str[0].Substring(0, 2).ToInteger;
      b := Str[0].Substring(2, 2).ToInteger;
      c := Str[0].Substring(4, 2).ToDouble;
    end
    else
    begin
      if Length(Str) = 2 then
      begin
        if not Str[0].IsEmpty then
          a := Str[0].ToInteger
        else
          a := 0;
        if not Str[1].IsEmpty then
          b := Str[1].ToInteger
        else
          b := 0;
        c := 0.0
      end
      else
      begin
        if not Str[0].IsEmpty then
          a := Str[0].ToInteger
        else
          a := 0;
        if not Str[1].IsEmpty then
          b := Str[1].ToInteger
        else
          b := 0;
        if not Str[2].IsEmpty then
          c := Str[2].ToDouble
        else
          c := 0.0;
      end;
    end;
    Result := a + b / 60 + c / 3600;
  finally
    RegEx.Free
  end;
end;

function GetLocalTimezone: Integer;
var
  TimeZoneInfo: TTimeZoneInformation;
begin
  if not (GetTimeZoneInformation(TimeZoneInfo) = TIME_ZONE_ID_INVALID) then
    Result := (TimeZoneInfo.Bias div 60);
end;

function JDLocalTimetoTD(localJD: double): Double;
var
  tmp: Double;
begin
  tmp := localJD - GetLocalTimezone / 24;
  Result := tmp;
end;

function JDtoDatetime(const JD: Double): TDatetime;            // convert JD to UT ( TDatetime )
var
  A, B, F, H: Double;
  alpha, C, E: integer;
  D, Z: longint;
  dd, mm, yy: word;
begin
  H := Frac(JD + 0.5);        // JD starts at noon

  Z := trunc(JD + 0.5);
  F := (JD + 0.5) - Z;
  if (Z < 2299161.0) then
    A := Z
  else
  begin
    alpha := trunc((Z - 1867216.25) / 36524.25);
    A := Z + 1 + alpha - (alpha div 4);
  end;
  B := A + 1524;
  C := trunc((B - 122.1) / 365.25);
  D := trunc(365.25 * C);
  E := trunc((B - D) / 30.6001);
  dd := Trunc(B - D - int(30.6001 * E) + F);
  if (E < 14) then
    mm := E - 1
  else
    mm := E - 13;
  if mm > 2 then
    yy := C - 4716
  else
    yy := C - 4715;

  Result := EncodeDate(yy, mm, dd) + H;   // UT time
end;

function JDtoGregorianDays(const JD: Extended): WZDAYTIME;
var
  F, H, ss: Double;
  C: Integer;
  D, Z: LongInt;
  hh, mm: Integer;
begin       // JD starts at noon

  D := Floor(JD + 0.5);
  F := (JD + 0.5) - D;
  if (D >= 2299161) then
  begin
    C := Floor((D - 1867216.25) / 36524.25);
    D := D + 1 + C - Floor(C div 4);
  end;
  D := D + 1524;
  Result.year := Floor((D - 122.1) / 365.25);
  D := D - Floor(365.25 * Result.year);
  Result.month := Floor(D / 30.6001);
  D := D - Floor(30.6001 * Result.month);
  Result.day := D;
  if (Result.month > 13) then
  begin
    Result.month := Result.month - 13;
    Result.year := Result.year - 4715;
  end
  else
  begin
    Result.month := Result.month - 1;
    Result.year := Result.year - 4716;
  end;
  F := F * 24;
  hh := Trunc(F);
  F := F - hh;
  F := F * 60;
  mm := Trunc(F);
  F := F - mm;
  F := F * 60;
  ss := F;
  with Result do
  begin
    hour := hh;
    minute := mm;
    second := ss;
  end;
end;

function GregorianDaystoStr(const pDT: WZDAYTIME): string;
var
  month, day, h, m: Integer;
  s: Double;
  mms, dd, hh, mm, ss: string;
begin
  month := pDT.month;
  day := pDT.day;
  h := pDT.hour;
  m := pDT.minute;
  s := pDT.second;
  if month < 10 then
    mms := '0' + month.ToString
  else
    mms := month.ToString;
  if day < 10 then
    dd := '0' + day.ToString
  else
    dd := day.ToString;
  if h < 10 then
    hh := '0' + h.toString
  else
    hh := h.tostring;
  if m < 10 then
    mm := '0' + m.ToString
  else
    mm := m.ToString;
  if s < 10 then
    ss := '0' + s.ToString
  else
    ss := s.ToString;
  Result := pDT.year.ToString + '-' + mms + '-' + dd + '  ' + hh + ':' + mm + ':' + ss.Substring(0, 2);
end;

function JDtoStr(jd: Extended): string;
var
  pDT: WZDAYTIME;
begin
  pDT := JDtoGregorianDays(jd);
  Result := GregorianDaystoStr(pDT);
end;

function NowGMT: TDateTime;
var
  ST: TSystemTime;  // current system time
begin
  // This Windows API function gets system time in UTC/GMT
  GetSystemTime(ST);
  Result := SystemTimeToDateTime(ST);
end;

function GMTToLocalTime(GMTTime: TDateTime): TDateTime;
var
  GMTST: TSystemTime;
  LocalST: TSystemTime;
begin
  DateTimeToSystemTime(GMTTime, GMTST);
  Win32Check(SystemTimeToTzSpecificLocalTime(nil, GMTST, LocalST));
  Result := SystemTimeToDateTime(LocalST);
end;

function IsLeapYear(year: Integer): Boolean;
begin
  Result := (((year mod 4) = 0) and ((year mod 100) <> 0)) or ((year mod 100) = 0);
end;

function IsGregorianDays(year, month, day: Integer): Boolean;
begin
  if year < 1582 then
  begin
    Result := False;
    Exit;
  end;
  if year = 1582 then
  begin
    if ((month < 10) or ((month = 10) and (day <= 4))) then
    begin
      Result := False;
      Exit;
    end;
  end;
  Result := True;
end;

function CalculateJulianDay(year, month, day, hour, minute: Integer; second: Double): Double;
var
  B: Integer;
  A, BB: Double;
  y, m, d: Integer;
begin
  y := year;
  m := month;
  d := day;
  if (year = 1582) and (month = 10) and (day > 4) and (day <= 15) then
  begin
    d := 15;
  end;
  if (month <= 2) then
  begin
    m := month + 12;
    y := year - 1;
    ;
  end;
  B := -2;
  if IsGregorianDays(year, month, day) then
  begin
    B := y div 400 - y div 100;
  end;
  A := 365.25 * y;
  BB := 30.6001 * (m + 1);
  Result := Floor(A) + int(BB) + B + 1720996.5 + d + hour / 24.0 + minute / 1440.0 + second / 86400.0;
end;

function CalculateJulianDay(const year, month: Integer; const day: Double): Double; overload
var
  n: Integer;
  y, m: Integer;
  d: Double;
begin
  n := 0;
  y := year;
  m := month;
  d := day;
  if (year = 1582) and (month = 10) and (Floor(day) > 4) and (Floor(day) <= 15) then
  begin
    d := 15.5;
  end;
  if (month <= 2) then
  begin
    m := month + 12;
    y := year - 1;
  end;
  if IsGregorianDays(year, month, Floor(day)) then
  begin
    n := Floor(y div 100);
    n := 2 - n + floor(n div 4);
  end;
  Result := Floor(365.25 * (y + 4716)) + Floor(30.6001 * (m + 1)) + d + n - 1524.5;
end;

//取得某年某月的天数
function GetDaysOfMonth(year: Integer; month: Integer): Integer;
var
  days: Integer;
begin
  if ((month < 1) or (month > 12)) then
  begin
    Result := 0;
    Exit;
  end;
  days := daysOfMonth[month];
  if ((month = 2) and IsLeapYear(year)) then
    Inc(days);
  if (year = 1582) and (month = 10) then
    Dec(days, 10);
  Result := days;
end;

function GetDaysOfMonthA(year: Integer; month: Integer): Integer;
var
  jdn1, jdn2: Integer;
  day, days: Integer;
begin
  if ((month < 1) or (month > 12)) then
  begin
    Result := 0;
    Exit;
  end;
  day := daysOfMonth[month];
  jdn1 := Floor(CalculateJulianDay(year, month, 1.5));
  jdn2 := Floor(CalculateJulianDay(year, month, day + 0.5));
  days := jdn2 - jdn1 + 1;
  Result := days;
end;

function DegreeToRadian(degree: Double): Double;
begin
  Result := degree * Pi / 180.0;
end;

function RadianToDegree(radian: Double): Double;
begin
  Result := radian * 180.0 / Pi;
end;

function Mod360Degree(degree: Double): Double;
var
  dbValue: Double;
begin
  dbValue := degree;
  while dbValue < 0.0 do
    dbValue := dbValue + 360.0;
  while dbValue > 360.0 do
    dbValue := dbValue - 360.0;
  Result := dbValue;
end;

//对超过0-2PI的角度转为0-2PI
function rad2mrad(rad: Double): Double;
var
  dbValue: Double;
begin
  dbValue := FMod(rad, 2 * pi);
  if dbValue < 0.0 then
  begin
    Result := dbValue + 2 * pi;
    Exit;
  end;
  Result := dbValue;
end;

//对超过-PI到PI的角度转为-PI到PI
function rad2rrad(rad: Double): Double;
var
  dbValue: Double;
begin
  dbValue := FMod(rad, 2 * pi);
  if dbValue <= -PI then
  begin
    Result := dbValue + 2 * pi;
    Exit;
  end;
  if dbValue > PI then
  begin
    Result := dbValue - 2 * pi;
    Exit;
  end;
  Result := dbValue;
end;

function ZellerWeek(year: Integer; month: Integer; day: Integer): Integer;
var
  w, y, c, m, d: Integer;
  dn: Integer;
begin
  m := month;
  d := day;
  //由于从1582年10月4日直接跳到了1582年10月15日中间少了10天所以加个判断
  if (year = 1582) and (month = 10) and (day > 4) and (day <= 15) then
  begin
    d := 15;
  end;
  if month <= 2 then
  begin
    Dec(year);
    m := month + 12;
  end;
  y := year mod 100;
  c := year div 100;
  dn := y + y div 4 + ((13 * (m + 1)) div 5) + d - 1;
  if IsGregorianDays(year, month, day) then
    w := (dn + (c div 4) - 2 * c) mod 7
     //w:= (y+y div 4 +c div 4-2*c+((13*(m+1)) div 5)+ d-1) mod 7
  else
    w := (dn + 5 - c) mod 7;
     //w:=(5-c+y+(y div 4)+((13*(m+1))div 5) + d -1) mod 7;
    //w:=(d+2*m+(3*(m+1))div 5 +y +y div 4 +5) mod 7;
    //w:=(y+y div 4+c div 4 -2*c +(13*(m+1)) div 5 +d +2) mod 7;
  if w < 0 then
    Inc(w, 7);
  Result := w;
end;

//通过JD计算某年某月某日的星期数
function GetWeek(const Year, month, day: Integer): Integer;
var
  jd: Double;
begin
  jd := CalculateJulianDay(Year, month, day + 0.5);
  Result := Floor(jd + 1.5 + 7000000) mod 7;
end;

//取儒略日数中的时间
function JDNToHHMMSS(JD: Double): string;
var
  T: Double;
  h, m, s: Integer;
  hh, mm, ss: string;
begin
  T := JD + 0.5;
  T := (T - floor(T)) * 24;
  h := Floor(T);
  if (h < 10) then
    hh := '0' + h.toString
  else
    hh := h.tostring;
  T := (T - h) * 60;
  m := Floor(T);
  if m < 10 then
    mm := '0' + m.ToString
  else
    mm := m.ToString;
  T := (T - m) * 60;
  s := Floor(T + 0.5);
  if s < 10 then
    ss := '0' + s.ToString
  else
    ss := s.ToString;
  Result := hh + ':' + mm + ':' + ss;
end;
//-----------------------------------------------
//太阳升降计算
function sunLat(dt: Double): Double;
var
  t, J: Double;
begin
  t := dt + (32 * (dt + 1.8) * (dt + 1.8) - 20) / 86400 / 36525;
  J := 48950621.66 + 6283319653.318 * t + 53 * t * t - 994 + 334166 * cos(4.669257 + 628.307585 * t) + 3489 * cos(4.6261 + 1256.61517 * t) + 2060.6 * cos(2.67823 + 628.307585 * t) * t;
  Result := J / 10000000;
end;

//jd儒略日平午，L地理经度，fa地理纬度，TZ时区，返回太阳升起时间
function sheng(jd, La, fa, TZ: Double): Double;
var
  T: Double;
  J, sinJ, cosJ: Double;
  gst: Double;
  E, A, D, cosH0, H0, H, jdn: Double;
begin
  jdn := jd - TZ;
  T := jdn / 36525;
  J := sunLat(T);
  sinJ := Sin(J);
  cosJ := Cos(J);
  gst := 2 * PI * (0.7790572732640 + 1.00273781191135448 * jdn) //恒星时（子午圈位置）
    + (0.014506 + 4612.15739966 * T + 1.39667721 * T * T) / ARC_SEC_PER_RADIAN;
  E := (84381.4060 - 46.836769 * T) / ARC_SEC_PER_RADIAN; //黄赤交角
  A := ArcTan2(sinJ * cos(E), cosJ); //太阳赤经
  D := ArcSin(sin(E) * sinJ);      //太阳赤纬
  cosH0 := (sin(-50 * 60 / ARC_SEC_PER_RADIAN) - sin(fa) * sin(D)) / (cos(fa) * cos(D)); //日出的时角计算
  if ((cosH0 >= 1) or (cosH0 <= -1)) then
  begin
    Result := 0.0;
    Exit;
  end;
  H0 := -ArcCos(cosH0); //升点时角（日出）
  H := gst - La - A; //太阳时角
  Result := jdn - rad2rrad(H - H0) / 6.28 + TZ;
end;

procedure GetDayTimeFromJulianDay(jd: Double; var pDT: WZDAYTIME);
begin
  //
end;

end.

