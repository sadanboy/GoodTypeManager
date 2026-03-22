unit Sun;

interface
uses
  System.Math,VSOP87D.Earth,support,uCalendar_Const,uNutation;


function CalcPeriodicTerm(const coff:array of TVSOP87D_COEFFICIENT;count:Integer ;dt:Double):Double;


/// <summary>
/// 计算太阳的地心黄经(度)，dt是儒略千年数
/// </summary>
/// <param name="dt">儒略千年数</param>
/// <returns>计算太阳的地心黄经(度)</returns>
function CalcSunEclipticLongitudeEC(dt:double):Double;
{*计算太阳的地心黄纬(度)，dt是儒略千年数*}
function CalcSunEclipticLatitudeEC(dt:Double):Double;
//修正太阳的地心黄经，longitude, latitude 是修正前的太阳地心黄经和地心黄纬(度)，dt是儒略千年数，返回值单位度
function AdjustSunEclipticLongitudeEC(dt, longitude, latitude:Double):Double;

//修正太阳的地心黄纬，longitude是修正前的太阳地心黄纬(度)，dt是儒略千年数，返回值单位度
function AdjustSunEclipticLatitudeEC(dt:double ;  longitude:double):Double;

{*计算太阳地球之间的距离*}
function CalcSunEarthRadius(dt:double ):Double;


/// <summary>
/// 得到某个儒略日的太阳地心黄经(视黄经)，单位度
/// </summary>
/// <param name="jde">传入儒略日</param>
/// <returns>返回太阳地心黄经(视黄经)单位为 度</returns>
function GetSunEclipticLongitudeEC(jde:double ):Double;

//*得到某个儒略日的太阳地心黄纬(视黄纬)，单位度*/
function GetSunEclipticLatitudeEC(jde:double ):Double;
implementation

function CalcPeriodicTerm(const coff: array of TVSOP87D_COEFFICIENT; Count: Integer; dt: Double): Double;
var
  i: Integer;
  val: Double;
begin
  val := 0.0;
  for i := 0 to Count - 1 do
    val := val + coff[i].A * cos((coff[i].B + coff[i].C * dt));
  Result := val;
end;


//计算太阳的地心黄纬(度)，dt是儒略千年数
function CalcSunEclipticLongitudeEC(dt:double):Double;
var
  L0,L1,L2,L3,L4,L5:Double;
  L:Double;
begin
  L0:=CalcPeriodicTerm(Earth_L0,Length(Earth_L0),dt);
  L1:=CalcPeriodicTerm(Earth_L1,Length(Earth_L1),dt);
  L2:=CalcPeriodicTerm(Earth_L2,Length(Earth_L2),dt);
  L3:=CalcPeriodicTerm(Earth_L3,Length(Earth_L3),dt);
  L4:=CalcPeriodicTerm(Earth_L4,Length(Earth_L4),dt);
  L5:=CalcPeriodicTerm(Earth_L5,Length(Earth_L5),dt);
  L := (((((L5 * dt + L4) * dt + L3) * dt + L2) * dt + L1) * dt + L0) / 100000000.0;
  //地心黄经 = 日心黄经 + 180度
  Result:=Mod360Degree(Mod360Degree(L / RADIAN_PER_ANGLE) + 180.0);
  //Result:=L+PI;
end;

{*计算太阳的地心黄纬(度)，dt是儒略千年数*}
function CalcSunEclipticLatitudeEC(dt:Double):Double;
var
 B0,B1,B2,B3,B4,B:Double;
begin
  B0 := CalcPeriodicTerm(Earth_B0, Length(Earth_B0), dt);
  B1 := CalcPeriodicTerm(Earth_B1, Length(Earth_B1), dt);
  B2 := CalcPeriodicTerm(Earth_B2, Length(Earth_B2), dt);
  B3 := CalcPeriodicTerm(Earth_B3, Length(Earth_B3), dt);
  B4 := CalcPeriodicTerm(Earth_B4, Length(Earth_B4), dt);

  B := (((((B4 * dt) + B3) * dt + B2) * dt + B1) * dt + B0) / 100000000.0;
  //地心黄纬 = －日心黄纬
  Result:= -(B / RADIAN_PER_ANGLE);
end;

//修正太阳的地心黄经，longitude, latitude 是修正前的太阳地心黄经和地心黄纬(度)，dt是儒略千年数，返回值单位度
function AdjustSunEclipticLongitudeEC(dt, longitude, latitude:Double):Double;
var
  T,dbLdash:Double;
begin
  T:=dt*10;
  dbLdash:= longitude - 1.397 * T - 0.00031 * T * T;
  // 转换为弧度
  dbLdash :=dbLdash* RADIAN_PER_ANGLE;
  Result:=(-0.09033 + 0.03916 * (cos(dbLdash) + sin(dbLdash)) * tan(latitude * RADIAN_PER_ANGLE)) / 3600.0;
end;

//修正太阳的地心黄纬，longitude是修正前的太阳地心黄纬(度)，dt是儒略千年数，返回值单位度
function AdjustSunEclipticLatitudeEC(dt:double ;  longitude:double):Double;
var
  T,dLdash:Double;
begin
  T:=dt*10;
  dLdash := longitude - 1.397 * T - 0.00031 * T * T ;
  // 转换为弧度
  dLdash := dLdash* RADIAN_PER_ANGLE ;
  Result:=(0.03916 * (cos(dLdash) - sin(dLdash))) / 3600.0 ;
end;

{*计算太阳地球之间的距离*}
function CalcSunEarthRadius(dt:double ):Double;
var
 R0,R1,R2,R3,R4,R:Double;
begin
  R0 := CalcPeriodicTerm(Earth_R0, Length(Earth_R0), dt);
  R1 := CalcPeriodicTerm(Earth_R1, Length(Earth_R1), dt);
  R2 := CalcPeriodicTerm(Earth_R2, Length(Earth_R2), dt);
  R3 := CalcPeriodicTerm(Earth_R3, Length(Earth_R3), dt);
  R4 := CalcPeriodicTerm(Earth_R4, Length(Earth_R4), dt);

  R := (((((R4 * dt) + R3) * dt + R2) * dt + R1) * dt + R0) / 100000000.0;

  Result:= R;
end;


function GetSunEclipticLongitudeEC(jde:double ):Double;
var
  dt,longitude,latitude:Double;
begin
  dt := (jde - JD2000) / 365250.0; //儒略千年数
  // 计算太阳的地心黄经
  longitude := CalcSunEclipticLongitudeEC(dt);
  // 计算太阳的地心黄纬
  latitude := CalcSunEclipticLatitudeEC(dt) {* 3600.0};

  // 修正精度
  longitude := longitude + AdjustSunEclipticLongitudeEC(dt, longitude, latitude);

  // 修正天体章动
  longitude := longitude + CalcEarthLongitudeNutation(dt);

  // 修正光行差
  //*太阳地心黄经光行差修正项是: -20".4898/R*/
  longitude := longitude - (20.4898 / CalcSunEarthRadius(dt)) / 3600.0;
  Result:=longitude;
end;

//*得到某个儒略日的太阳地心黄纬(视黄纬)，单位度*/
function GetSunEclipticLatitudeEC(jde:double ):Double;
var
 dt,longitude,latitude,delta:Double;
begin
  dt:=(jde-JD2000)/365250.0;//儒略千年数

  //计算太阳的地心黄经
  longitude:=CalcSunEclipticLatitudeEC(dt);
  //计算太阳的地心黄纬
  latitude:=CalcSunEclipticLongitudeEC(dt);

  //修正精度
  delta:=AdjustSunEclipticLatitudeEC(dt,longitude);
  latitude:=latitude+delta*3600.0;
  Result:=latitude;
end;

end.
