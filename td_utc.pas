unit td_utc;

interface
type
  TD_UTC_DELTA=record
    year:Integer;
    d1,d2,d3,d4:Double;
  end;
const
  // TD - UT1 计算表
  deltaTbl:array[0..22]of TD_UTC_DELTA=(
    (year: -4000;d1:108371.7;d2:-13036.80;d3:392.000;d4: 0.0000  ),
    (year:  -500;d1: 17201.0;d2:  -627.82;d3: 16.170;d4:-0.3413  ),
    (year:  -150;d1: 12200.6;d2:  -346.41;d3:  5.403;d4:-0.1593  ),
    (year:   150;d1:  9113.8;d2:  -328.13;d3: -1.647;d4: 0.0377  ),
    (year:   500;d1:  5707.5;d2:  -391.41;d3:  0.915;d4: 0.3145  ),
    (year:   900;d1:  2203.4;d2:  -283.45;d3: 13.034;d4:-0.1778  ),
    (year:  1300;d1:   490.1;d2:   -57.35;d3:  2.085;d4:-0.0072  ),
    (year:  1600;d1:   120.0;d2:    -9.81;d3: -1.532;d4: 0.1403  ),
    (year:  1700;d1:    10.2;d2:    -0.91;d3:  0.510;d4:-0.0370  ),
    (year:  1800;d1:    13.4;d2:    -0.72;d3:  0.202;d4:-0.0193  ),
    (year:  1830;d1:     7.8;d2:    -1.81;d3:  0.416;d4:-0.0247  ),
    (year:  1860;d1:     8.3;d2:    -0.13;d3: -0.406;d4: 0.0292  ),
    (year:  1880;d1:    -5.4;d2:     0.32;d3: -0.183;d4: 0.0173  ),
    (year:  1900;d1:    -2.3;d2:     2.06;d3:  0.169;d4:-0.0135  ),
    (year:  1920;d1:    21.2;d2:     1.69;d3: -0.304;d4: 0.0167  ),
    (year:  1940;d1:    24.2;d2:     1.22;d3: -0.064;d4: 0.0031  ),
    (year:  1960;d1:    33.2;d2:     0.51;d3:  0.231;d4:-0.0109  ),
    (year:  1980;d1:    51.0;d2:     1.29;d3: -0.026;d4: 0.0032  ),
    (year:  2000;d1:   63.87;d2:      0.1;d3:    0.0;d4:    0.0  ),
    (year:  2005;d1:    64.7;d2:     0.21;d3:    0.0;d4:    0.0  ),
    (year:  2012;d1:    66.8;d2:     0.22;d3:    0.0;d4:    0.0  ),
    (year:  2018;d1:    69.0;d2:     0.36;d3:    0.0;d4:    0.0  ),
    (year:  2028;d1:    72.6;d2:      0.0;d3:    0.0;d4:    0.0  ));

// TD - UT1 计算表
function deltatExt(y:Double;jsd:Integer):Double;
function TdUtcDeltatT(y:Double):Double;

function dt_calc(y:Double):Double;
function dt_T(jd2k:Double):Double;

implementation

function deltatExt(y:Double;jsd:Integer):Double;
var
  dy:Double;
begin
  dy:=(y-1820.0)/100.0;
  Result:=-20.0+jsd*dy*dy;//二次曲线外推
end;

//计算世界时与原子时之差,传入年
function TdUtcDeltatT(y:Double):Double;
var
  y1,y0,jsd:Integer;
  sd,t0:Double;
begin
  y0:=deltaTbl[Length(deltaTbl)-1].year;
  t0:=deltaTbl[Length(deltaTbl)-1].d1;
  if (y>=2005) then
  begin
    //sd是2005年之后几年（一值到y1年）的速度估计。
    //jsd是y1年之后的加速度估计。瑞士星历表jsd=31,NASA网站jsd=32,skmap的jsd=29
    y1:=2014;
    sd:=0.4;
    jsd:=31;
    if (y<=y1) then
    begin
      //直线外推
      Result:=64.7+(y-2005)*sd;
      Exit;
    end;
    var v  : Double:=deltatExt(y,jsd); //二次曲线外推
    var dv : Double:=deltatExt(y1,jsd)-(64.7+(y1-2005)*sd);//y1年的二次外推与直线外推的差
    if y<(y1+100) then
    begin
      v:=v-dv*(y1+100-y)/100;
      Result:=v;
      Exit;
    end;
  end else
  begin
    var i:Integer;
    for i := 0 to High(deltaTbl) do
    begin
      if (y<deltaTbl[i+1].year) then Break;
    end;
    var t1:Double:= Double(y - deltaTbl[i].year)/double(deltaTbl[i + 1].year - deltaTbl[i].year) * 10.0;
    var t2:Double:=t1*t1;
    var t3:Double:=t2*t1;
    Result:= deltaTbl[i].d1 + deltaTbl[i].d2 * t1 + deltaTbl[i].d3 * t2 + deltaTbl[i].d4 * t3;
  end;
end;

function dt_calc(y:Double):Double;
var
 jsd,i:Integer;
 v,dv:Double;
begin
  var y0:Integer:= deltaTbl[Length(deltaTbl)-1].year;
  var t0:Double:= deltaTbl[Length(deltaTbl)-1].d1;
  if y>=y0 then
  begin
    jsd:=31; //jsd是y1年之后的加速度估计。瑞士星历表jsd=31,NASA网站jsd=32,skmap的jsd=29
    if y>y0+100 then
    begin
      Result:= deltatExt(y,jsd);
      Exit;
    end;
    v:=deltatExt(y,jsd); //二次曲线外推
    dv:=deltatExt(y0,jsd)-t0; //ye年的二次外推与te的差
    Result:=v-dv*(y0+100-y)/100;
  end;


    for  i := 0 to (SizeOf(deltaTbl) div SizeOf(deltaTbl[0]))-1 do
    begin
      if (y<deltaTbl[i+1].year) then Break;
    end;
    var t1:Double:= Double(y - deltaTbl[i].year)/double(deltaTbl[i + 1].year - deltaTbl[i].year) * 10.0;
    var t2:Double:=t1*t1;
    var t3:Double:=t2*t1;
    Result:= deltaTbl[i].d1 + deltaTbl[i].d2 * t1 + deltaTbl[i].d3 * t2 + deltaTbl[i].d4 * t3;
end;

/// <summary>
/// 传入儒略日（J2000 起算），计算 TD-UT（单位：日）
/// </summary>
/// <param name="jd2k"></param>
/// <returns></returns>
function dt_T(jd2k:Double):Double;
begin
  //传入儒略日(J2000起算),计算TD-UT(单位:日)
  Result:= dt_calc(jd2k/365.2425 + 2000) / 86400.0;
end;
end.
