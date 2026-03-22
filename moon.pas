unit moon;

interface
uses
  System.Math, uCalendar_Const, VSOP87D.Earth, support, uNutation, elp2000_data,
  td_utc;

  procedure GetMoonEclipticParameter(dt:double;var Lp:Double;var D:Double; var M:double;var Mp:double;var F:double;var E:double);
  /// <summary>
  /// 计算月球地心黄经周期项的和
  /// </summary>
  function CalcMoonECLongitudePeriodic(D:Double;M:Double;Mp:Double;F:Double;E:Double):Double;

  /// <summary>
  /// 计算月球地心黄纬周期项的和
  /// </summary>
  function CalcMoonECLatitudePeriodicTbl(D:double;M :double ; Mp:double ;F:double; E:double ):Double;


  /// <summary>
  /// 计算月球地心距离周期项的和
  /// </summary>
  /// <param name="D"></param>
  /// <param name="M"></param>
  /// <param name="Mp"></param>
  /// <param name="F"></param>
  /// <param name="E"></param>
  /// <returns></returns>
  function CalcMoonECDistancePeriodicTbl(D:double;M: double ; Mp:double ; F:double ; E:double ):Double;

  //计算金星摄动,木星摄动以及地球扁率摄动对月球地心黄经的影响,dt 是儒略世纪数，Lp和F单位是度
  function CalcMoonLongitudePerturbation(dt:double;Lp:double; F: double):Double;
  //计算金星摄动,木星摄动以及地球扁率摄动对月球地心黄纬的影响,dt 是儒略世纪数，Lp、Mp和F单位是度
  function CalcMoonLatitudePerturbation(dt:double ; Lp:double ; F:double ; Mp:double ):Double;

  function GetMoonEclipticLongitudeEC(dbJD:double):Double;

  function GetMoonEclipticLatitudeEC(dbJD:double ):Double;

  function GetMoonEarthDistance(dbJD:double ):Double;
implementation

procedure GetMoonEclipticParameter(dt: double; var Lp: Double; var D: Double; var M: double; var Mp: double; var F: double; var E: double);
var
  T, T2, T3, T4: Double;
begin
  T := dt; //T是从J2000起算的儒略世纪数
  T2 := T * T;
  T3 := T2 * T;
  T4 := T3 * T;
  //月球平黄经
  Lp := 218.3164591 + 481267.88134236 * T - 0.0013268 * T2 + T3 / 538841.0 - T4 / 65194000.0;
  Lp := Mod360Degree(Lp);

  //*月日距角*/
  D := 297.8502042 + 445267.1115168 * T - 0.0016300 * T2 + T3 / 545868.0 - T4 / 113065000.0;
  D := Mod360Degree(D);

  //太阳平近点角*/
  M := 357.5291092 + 35999.0502909 * T - 0.0001536 * T2 + T3 / 24490000.0;
  M := Mod360Degree(M);

  //*月亮平近点角*/
  Mp := 134.9634114 + 477198.8676313 * T + 0.0089970 * T2 + T3 / 69699.0 - T4 / 14712000.0;
  Mp := Mod360Degree(Mp);

  //*月球经度参数(到升交点的平角距离)*/
  F := 93.2720993 + 483202.0175273 * T - 0.0034029 * T2 - T3 / 3526000.0 + T4 / 863310000.0;
  F := Mod360Degree(F);

  E := 1 - 0.002516 * T - 0.0000074 * T2;
end;


//计算月球地心黄经周期项的和
function CalcMoonECLongitudePeriodic(D:Double;M:Double;Mp:Double;F:Double;E:Double):Double;
var
  EI: Double;
  i: Integer;
begin
  EI := 0.0;
  for i := 0 to Length(Moon_longitude) - 1 do
  begin
    var sita: Double := Moon_longitude[i].D * D + Moon_longitude[i].M * M + Moon_longitude[i].Mp * Mp + Moon_longitude[i].F * F;
    sita := DegreeToRadian(sita);
    EI := EI + (Moon_longitude[i].eiA * sin(sita) * Power(E, Abs(Moon_longitude[i].M)));
  end;

  Result := EI;
end;


//计算月球地心黄纬周期项的和
function CalcMoonECLatitudePeriodicTbl(D: double; M: double; Mp: double; F: double; E: double): Double;
var
  EB: Double;
  i: Integer;
begin
  EB := 0.0;
  for i := 0 to Length(Moon_latitude) - 1 do
  begin
    var sita: Double := Moon_latitude[i].D * D + Moon_latitude[i].M * M + Moon_latitude[i].Mp * Mp + Moon_latitude[i].F * F;
    sita := DegreeToRadian(sita);
    EB := EB + (Moon_latitude[i].eiA * sin(sita) * Power(E, Abs(Moon_latitude[i].M)));
  end;

  Result := EB;
end;


//计算月球地心距离周期项的和
function CalcMoonECDistancePeriodicTbl(D: double; M: double; Mp: double; F: double; E: double): Double;
var
  ER: Double;
  i: Integer;
begin
  ER := 0.0;
  for i := 0 to SizeOf(Moon_longitude) div SizeOf(Moon_longitude[0]) - 1 do
  begin
    var sita: Double := Moon_longitude[i].D * D + Moon_longitude[i].M * M + Moon_longitude[i].Mp * Mp + Moon_longitude[i].F * F;
    sita := DegreeToRadian(sita);
    ER := ER + (Moon_longitude[i].erA * Cos(sita) * Power(E, Abs(Moon_longitude[i].M)));
  end;
  Result := ER;
end;


//计算金星摄动,木星摄动以及地球扁率摄动对月球地心黄经的影响,dt 是儒略世纪数，Lp和F单位是度
function CalcMoonLongitudePerturbation(dt: double; Lp: double; F: double): Double;
begin
  var T: Double := dt; //T是从J2000起算的儒略世纪数
  var A1: Double := 119.75 + 131.849 * T;
  var A2: Double := 53.09 + 479264.290 * T;
  A1 := Mod360Degree(A1);
  A2 := Mod360Degree(A2);

  Result := 3958.0 * sin(DegreeToRadian(A1));
  Result := Result + (1962.0 * sin(DegreeToRadian(Lp - F)));
  Result := Result + (318.0 * sin(DegreeToRadian(A2)));
end;


//计算金星摄动,木星摄动以及地球扁率摄动对月球地心黄纬的影响,dt 是儒略世纪数，Lp、Mp和F单位是度
function CalcMoonLatitudePerturbation(dt: double; Lp: double; F: double; Mp: double): Double;
begin
  var T: Double := dt; //T是从J2000起算的儒略世纪数
  var A1: Double := 119.75 + 131.849 * T;
  var A3: Double := 313.45 + 481266.484 * T;

  A1 := Mod360Degree(A1);
  A3 := Mod360Degree(A3);

  Result := -2235.0 * sin(DegreeToRadian(Lp));
  Result := Result + (382.0 * sin(DegreeToRadian(A3)));
  Result := Result + (175.0 * sin(DegreeToRadian(A1 - F)));
  Result := Result + (175.0 * sin(DegreeToRadian(A1 + F)));
  Result := Result + (127.0 * sin(DegreeToRadian(Lp - Mp)));
  Result := Result + (115.0 * sin(DegreeToRadian(Lp + Mp)));
end;

function GetMoonEclipticLongitudeEC(dbJD: double): Double;
var
  Lp, D, M, Mp, F, E: Double;
  dt: Double;
begin
  dt := (dbJD - JD2000) / 36525.0; //儒略世纪数
  GetMoonEclipticParameter(dt, Lp, D, M, Mp, F, E);

  //计算月球地心黄经周期项
  var EI: Double := CalcMoonECLongitudePeriodic(D, M, Mp, F, E);
  //*修正金星,木星以及地球扁率摄动*/
  EI := EI + CalcMoonLongitudePerturbation(dt, Lp, F);
  //计算月球地心黄经
  var longitude: Double := Lp + EI / 1000000.0;
  //计算天体章动干扰
  longitude := longitude + CalcEarthLongitudeNutation(dt / 10.0);

  longitude := Mod360Degree(longitude); //映射到0-360范围内

  Result := longitude;
end;

function GetMoonEclipticLatitudeEC(dbJD:double ):Double;
var
  Lp,D,M,Mp,F,E:Double;
  dt:Double;
begin
  dt:=(dbJD-JD2000)/36525.0;//儒略世纪数
  GetMoonEclipticParameter(dt,Lp, D, M, Mp, F, E);

  //计算月球地心黄纬周期项
  var EB:Double:= CalcMoonECLatitudePeriodicTbl(D, M, Mp, F, E);

  //修正金星,木星以及地球扁率摄动
  EB := EB + CalcMoonLatitudePerturbation(dt, Lp, F, Mp);
  var latitute:=EB/1000000.0;

  Result:=latitute;
end;

{ TODO : 计算月球地心黄纬 }
function GetMoonEarthDistance(dbJD:double ):Double;
var
  Lp,D,M,Mp,F,E:Double;
  dt:Double;
begin
  dt:=(dbJD-JD2000)/36525.0;//儒略世纪数
  GetMoonEclipticParameter(dt,Lp, D, M, Mp, F, E);

  //计算月球地心距离周期项
  var ER:double  := CalcMoonECDistancePeriodicTbl(D, M, Mp, F, E);

  //计算月球地心黄纬
  Result:= 385000.56 + ER / 1000.0;
end;
end.
