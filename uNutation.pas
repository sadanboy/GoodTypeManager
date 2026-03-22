unit uNutation;

interface

uses
  System.Math,System.Math.Vectors,support;
type
  //天体章动系数类型变量
  NUTATION_COEFFICIENT=record
       D:double;
       M:double;
       Mp:double;
       F:double;
       omega:double;
       sine1:double;
       sine2:double;
       cosine1:double;
       cosine2:double;
  end;

const
  nutationIAU1980:array[0..62] of NUTATION_COEFFICIENT=(
    ( D: 0; M: 0; Mp: 0; F: 0; omega: 1; sine1:-171996;  sine2:-174.2;  cosine1:92025; cosine2:    8.9    ),
    ( D:-2; M: 0; Mp: 0; F: 2; omega: 2; sine1: -13187;  sine2:  -1.6;  cosine1: 5736; cosine2:   -3.1    ),
    ( D: 0; M: 0; Mp: 0; F: 2; omega: 2; sine1:  -2274;  sine2:  -0.2;  cosine1:  977; cosine2:   -0.5    ),
    ( D: 0; M: 0; Mp: 0; F: 0; omega: 2; sine1:   2062;  sine2:   0.2;  cosine1: -895; cosine2:    0.5    ),
    ( D: 0; M: 1; Mp: 0; F: 0; omega: 0; sine1:   1426;  sine2:  -3.4;  cosine1:   54; cosine2:   -0.1    ),
    ( D: 0; M: 0; Mp: 1; F: 0; omega: 0; sine1:    712;  sine2:   0.1;  cosine1:   -7; cosine2:      0    ),
    ( D:-2; M: 1; Mp: 0; F: 2; omega: 2; sine1:   -517;  sine2:   1.2;  cosine1:  224; cosine2:   -0.6    ),
    ( D: 0; M: 0; Mp: 0; F: 2; omega: 1; sine1:   -386;  sine2:  -0.4;  cosine1:  200; cosine2:      0    ),
    ( D: 0; M: 0; Mp: 1; F: 2; omega: 2; sine1:   -301;  sine2:     0;  cosine1:  129; cosine2:   -0.1    ),
    ( D:-2; M:-1; Mp: 0; F: 2; omega: 2; sine1:    217;  sine2:  -0.5;  cosine1:  -95; cosine2:    0.3    ),
    ( D:-2; M: 0; Mp: 1; F: 0; omega: 0; sine1:   -158;  sine2:     0;  cosine1:    0; cosine2:      0    ),
    ( D:-2; M: 0; Mp: 0; F: 2; omega: 1; sine1:    129;  sine2:   0.1;  cosine1:  -70; cosine2:      0    ),
    ( D: 0; M: 0; Mp:-1; F: 2; omega: 2; sine1:    123;  sine2:     0;  cosine1:  -53; cosine2:      0    ),
    ( D: 2; M: 0; Mp: 0; F: 0; omega: 0; sine1:     63;  sine2:     0;  cosine1:    0; cosine2:      0    ),
    ( D: 0; M: 0; Mp: 1; F: 0; omega: 1; sine1:     63;  sine2:   0.1;  cosine1:  -33; cosine2:      0    ),
    ( D: 2; M: 0; Mp:-1; F: 2; omega: 2; sine1:    -59;  sine2:     0;  cosine1:   26; cosine2:      0    ),
    ( D: 0; M: 0; Mp:-1; F: 0; omega: 1; sine1:    -58;  sine2:  -0.1;  cosine1:   32; cosine2:      0    ),
    ( D: 0; M: 0; Mp: 1; F: 2; omega: 1; sine1:    -51;  sine2:     0;  cosine1:   27; cosine2:      0    ),
    ( D:-2; M: 0; Mp: 2; F: 0; omega: 0; sine1:     48;  sine2:     0;  cosine1:    0; cosine2:      0    ),
    ( D: 0; M: 0; Mp:-2; F: 2; omega: 1; sine1:     46;  sine2:     0;  cosine1:  -24; cosine2:      0    ),
    ( D: 2; M: 0; Mp: 0; F: 2; omega: 2; sine1:    -38;  sine2:     0;  cosine1:   16; cosine2:      0    ),
    ( D: 0; M: 0; Mp: 2; F: 2; omega: 2; sine1:    -31;  sine2:     0;  cosine1:   13; cosine2:      0    ),
    ( D: 0; M: 0; Mp: 2; F: 0; omega: 2; sine1:     29;  sine2:     0;  cosine1:  -12; cosine2:      0    ),
    ( D:-2; M: 0; Mp: 1; F: 2; omega: 2; sine1:     29;  sine2:     0;  cosine1:  -12; cosine2:      0    ),
    ( D: 0; M: 0; Mp: 0; F: 2; omega: 0; sine1:     26;  sine2:     0;  cosine1:    0; cosine2:      0    ),
    ( D:-2; M: 0; Mp: 0; F: 2; omega: 0; sine1:    -22;  sine2:     0;  cosine1:    0; cosine2:      0    ),
    ( D: 0; M: 0; Mp:-1; F: 2; omega: 1; sine1:     21;  sine2:     0;  cosine1:  -10; cosine2:      0    ),
    ( D: 0; M: 2; Mp: 0; F: 0; omega: 0; sine1:     17;  sine2:  -0.1;  cosine1:    0; cosine2:      0    ),
    ( D: 2; M: 0; Mp:-1; F: 0; omega: 1; sine1:     16;  sine2:     0;  cosine1:   -8; cosine2:      0    ),
    ( D:-2; M: 2; Mp: 0; F: 2; omega: 2; sine1:    -16;  sine2:   0.1;  cosine1:    7; cosine2:      0    ),
    ( D: 0; M: 1; Mp: 0; F: 0; omega: 1; sine1:    -15;  sine2:     0;  cosine1:    9; cosine2:      0    ),
    ( D:-2; M: 0; Mp: 1; F: 0; omega: 1; sine1:    -13;  sine2:     0;  cosine1:    7; cosine2:      0    ),
    ( D: 0; M:-1; Mp: 0; F: 0; omega: 1; sine1:    -12;  sine2:     0;  cosine1:    6; cosine2:      0    ),
    ( D: 0; M: 0; Mp: 2; F:-2; omega: 0; sine1:     11;  sine2:     0;  cosine1:    0; cosine2:      0    ),
    ( D: 2; M: 0; Mp:-1; F: 2; omega: 1; sine1:    -10;  sine2:     0;  cosine1:    5; cosine2:      0    ),
    ( D: 2; M: 0; Mp: 1; F: 2; omega: 2; sine1:     -8;  sine2:     0;  cosine1:    3; cosine2:      0    ),
    ( D: 0; M: 1; Mp: 0; F: 2; omega: 2; sine1:      7;  sine2:     0;  cosine1:   -3; cosine2:      0    ),
    ( D:-2; M: 1; Mp: 1; F: 0; omega: 0; sine1:     -7;  sine2:     0;  cosine1:    0; cosine2:      0    ),
    ( D: 0; M:-1; Mp: 0; F: 2; omega: 2; sine1:     -7;  sine2:     0;  cosine1:    3; cosine2:      0    ),
    ( D: 2; M: 0; Mp: 0; F: 2; omega: 1; sine1:     -7;  sine2:     0;  cosine1:    3; cosine2:      0    ),
    ( D: 2; M: 0; Mp: 1; F: 0; omega: 0; sine1:      6;  sine2:     0;  cosine1:    0; cosine2:      0    ),
    ( D:-2; M: 0; Mp: 2; F: 2; omega: 2; sine1:      6;  sine2:     0;  cosine1:   -3; cosine2:      0    ),
    ( D:-2; M: 0; Mp: 1; F: 2; omega: 1; sine1:      6;  sine2:     0;  cosine1:   -3; cosine2:      0    ),
    ( D: 2; M: 0; Mp:-2; F: 0; omega: 1; sine1:     -6;  sine2:     0;  cosine1:    3; cosine2:      0    ),
    ( D: 2; M: 0; Mp: 0; F: 0; omega: 1; sine1:     -6;  sine2:     0;  cosine1:    3; cosine2:      0    ),
    ( D: 0; M:-1; Mp: 1; F: 0; omega: 0; sine1:      5;  sine2:     0;  cosine1:    0; cosine2:      0    ),
    ( D:-2; M:-1; Mp: 0; F: 2; omega: 1; sine1:     -5;  sine2:     0;  cosine1:    3; cosine2:      0    ),
    ( D:-2; M: 0; Mp: 0; F: 0; omega: 1; sine1:     -5;  sine2:     0;  cosine1:    3; cosine2:      0    ),
    ( D: 0; M: 0; Mp: 2; F: 2; omega: 1; sine1:     -5;  sine2:     0;  cosine1:    3; cosine2:      0    ),
    ( D:-2; M: 0; Mp: 2; F: 0; omega: 1; sine1:      4;  sine2:     0;  cosine1:    0; cosine2:      0    ),
    ( D:-2; M: 1; Mp: 0; F: 2; omega: 1; sine1:      4;  sine2:     0;  cosine1:    0; cosine2:      0    ),
    ( D: 0; M: 0; Mp: 1; F:-2; omega: 0; sine1:      4;  sine2:     0;  cosine1:    0; cosine2:      0    ),
    ( D:-1; M: 0; Mp: 1; F: 0; omega: 0; sine1:     -4;  sine2:     0;  cosine1:    0; cosine2:      0    ),
    ( D:-2; M: 1; Mp: 0; F: 0; omega: 0; sine1:     -4;  sine2:     0;  cosine1:    0; cosine2:      0    ),
    ( D: 1; M: 0; Mp: 0; F: 0; omega: 0; sine1:     -4;  sine2:     0;  cosine1:    0; cosine2:      0    ),
    ( D: 0; M: 0; Mp: 1; F: 2; omega: 0; sine1:      3;  sine2:     0;  cosine1:    0; cosine2:      0    ),
    ( D: 0; M: 0; Mp:-2; F: 2; omega: 2; sine1:     -3;  sine2:     0;  cosine1:    0; cosine2:      0    ),
    ( D:-1; M:-1; Mp: 1; F: 0; omega: 0; sine1:     -3;  sine2:     0;  cosine1:    0; cosine2:      0    ),
    ( D: 0; M: 1; Mp: 1; F: 0; omega: 0; sine1:     -3;  sine2:     0;  cosine1:    0; cosine2:      0    ),
    ( D: 0; M:-1; Mp: 1; F: 2; omega: 2; sine1:     -3;  sine2:     0;  cosine1:    0; cosine2:      0    ),
    ( D: 2; M:-1; Mp:-1; F: 2; omega: 2; sine1:     -3;  sine2:     0;  cosine1:    0; cosine2:      0    ),
    ( D: 0; M: 0; Mp: 3; F: 2; omega: 2; sine1:     -3;  sine2:     0;  cosine1:    0; cosine2:      0    ),
    ( D: 2; M:-1; Mp: 0; F: 2; omega: 2; sine1:     -3;  sine2:     0;  cosine1:    0; cosine2:      0    )
);

nutationIAU2000B : array[0..76,0..10] of Double = (
 //l  l' F  D  Om         A        A'      A"        B      B'     B"
 ( 0, 0, 0, 0, 1, -172064161, -174666,  33386, 92052331,  9086, 15377),
 ( 0, 0, 2,-2, 2,  -13170906,   -1675, -13696,  5730336, -3015, -4587),
 ( 0, 0, 2, 0, 2,   -2276413,    -234,   2796,   978459,  -485,  1374),
 ( 0, 0, 0, 0, 2,    2074554,     207,   -698,  -897492,   470,  -291),
 ( 0, 1, 0, 0, 0,    1475877,   -3633,  11817,    73871,  -184, -1924),
 ( 0, 1, 2,-2, 2,    -516821,    1226,   -524,   224386,  -677,  -174),
 ( 1, 0, 0, 0, 0,     711159,      73,   -872,    -6750,     0,   358),
 ( 0, 0, 2, 0, 1,    -387298,    -367,    380,   200728,    18,   318),
 ( 1, 0, 2, 0, 2,    -301461,     -36,    816,   129025,   -63,   367),
 ( 0,-1, 2,-2, 2,     215829,    -494,    111,   -95929,   299,   132),
 ( 0, 0, 2,-2, 1,     128227,     137,    181,   -68982,    -9,    39),
 (-1, 0, 2, 0, 2,     123457,      11,     19,   -53311,    32,    -4),
 (-1, 0, 0, 2, 0,     156994,      10,   -168,    -1235,     0,    82),
 ( 1, 0, 0, 0, 1,      63110,      63,     27,   -33228,     0,    -9),
 (-1, 0, 0, 0, 1,     -57976,     -63,   -189,    31429,     0,   -75),
 (-1, 0, 2, 2, 2,     -59641,     -11,    149,    25543,   -11,    66),
 ( 1, 0, 2, 0, 1,     -51613,     -42,    129,    26366,     0,    78),
 (-2, 0, 2, 0, 1,      45893,      50,     31,   -24236,   -10,    20),
 ( 0, 0, 0, 2, 0,      63384,      11,   -150,    -1220,     0,    29),
 ( 0, 0, 2, 2, 2,     -38571,      -1,    158,    16452,   -11,    68),
 ( 0,-2, 2,-2, 2,      32481,       0,      0,   -13870,     0,     0),
 (-2, 0, 0, 2, 0,     -47722,       0,    -18,      477,     0,   -25),
 ( 2, 0, 2, 0, 2,     -31046,      -1,    131,    13238,   -11,    59),
 ( 1, 0, 2,-2, 2,      28593,       0,     -1,   -12338,    10,    -3),
 (-1, 0, 2, 0, 1,      20441,      21,     10,   -10758,     0,    -3),
 ( 2, 0, 0, 0, 0,      29243,       0,    -74,     -609,     0,    13),
 ( 0, 0, 2, 0, 0,      25887,       0,    -66,     -550,     0,    11),
 ( 0, 1, 0, 0, 1,     -14053,     -25,     79,     8551,    -2,   -45),
 (-1, 0, 0, 2, 1,      15164,      10,     11,    -8001,     0,    -1),
 ( 0, 2, 2,-2, 2,     -15794,      72,    -16,     6850,   -42,    -5),
 ( 0, 0,-2, 2, 0,      21783,       0,     13,     -167,     0,    13),
 ( 1, 0, 0,-2, 1,     -12873,     -10,    -37,     6953,     0,   -14),
 ( 0,-1, 0, 0, 1,     -12654,      11,     63,     6415,     0,    26),
 (-1, 0, 2, 2, 1,     -10204,       0,     25,     5222,     0,    15),
 ( 0, 2, 0, 0, 0,      16707,     -85,    -10,      168,    -1,    10),
 ( 1, 0, 2, 2, 2,      -7691,       0,     44,     3268,     0,    19),
 (-2, 0, 2, 0, 0,     -11024,       0,    -14,      104,     0,     2),
 ( 0, 1, 2, 0, 2,       7566,     -21,    -11,    -3250,     0,    -5),
 ( 0, 0, 2, 2, 1,      -6637,     -11,     25,     3353,     0,    14),
 ( 0,-1, 2, 0, 2,      -7141,      21,      8,     3070,     0,     4),
 ( 0, 0, 0, 2, 1,      -6302,     -11,      2,     3272,     0,     4),
 ( 1, 0, 2,-2, 1,       5800,      10,      2,    -3045,     0,    -1),
 ( 2, 0, 2,-2, 2,       6443,       0,     -7,    -2768,     0,    -4),
 (-2, 0, 0, 2, 1,      -5774,     -11,    -15,     3041,     0,    -5),
 ( 2, 0, 2, 0, 1,      -5350,       0,     21,     2695,     0,    12),
 ( 0,-1, 2,-2, 1,      -4752,     -11,     -3,     2719,     0,    -3),
 ( 0, 0, 0,-2, 1,      -4940,     -11,    -21,     2720,     0,    -9),
 (-1,-1, 0, 2, 0,       7350,       0,     -8,      -51,     0,     4),
 ( 2, 0, 0,-2, 1,       4065,       0,      6,    -2206,     0,     1),
 ( 1, 0, 0, 2, 0,       6579,       0,    -24,     -199,     0,     2),
 ( 0, 1, 2,-2, 1,       3579,       0,      5,    -1900,     0,     1),
 ( 1,-1, 0, 0, 0,       4725,       0,     -6,      -41,     0,     3),
 (-2, 0, 2, 0, 2,      -3075,       0,     -2,     1313,     0,    -1),
 ( 3, 0, 2, 0, 2,      -2904,       0,     15,     1233,     0,     7),
 ( 0,-1, 0, 2, 0,       4348,       0,    -10,      -81,     0,     2),
 ( 1,-1, 2, 0, 2,      -2878,       0,      8,     1232,     0,     4),
 ( 0, 0, 0, 1, 0,      -4230,       0,      5,      -20,     0,    -2),
 (-1,-1, 2, 2, 2,      -2819,       0,      7,     1207,     0,     3),
 (-1, 0, 2, 0, 0,      -4056,       0,      5,       40,     0,    -2),
 ( 0,-1, 2, 2, 2,      -2647,       0,     11,     1129,     0,     5),
 (-2, 0, 0, 0, 1,      -2294,       0,    -10,     1266,     0,    -4),
 ( 1, 1, 2, 0, 2,       2481,       0,     -7,    -1062,     0,    -3),
 ( 2, 0, 0, 0, 1,       2179,       0,     -2,    -1129,     0,    -2),
 (-1, 1, 0, 1, 0,       3276,       0,      1,       -9,     0,     0),
 ( 1, 1, 0, 0, 0,      -3389,       0,      5,       35,     0,    -2),
 ( 1, 0, 2, 0, 0,       3339,       0,    -13,     -107,     0,     1),
 (-1, 0, 2,-2, 1,      -1987,       0,     -6,     1073,     0,    -2),
 ( 1, 0, 0, 0, 2,      -1981,       0,      0,      854,     0,     0),
 (-1, 0, 0, 1, 0,       4026,       0,   -353,     -553,     0,  -139),
 ( 0, 0, 2, 1, 2,       1660,       0,     -5,     -710,     0,    -2),
 (-1, 0, 2, 4, 2,      -1521,       0,      9,      647,     0,     4),
 (-1, 1, 0, 1, 1,       1314,       0,      0,     -700,     0,     0),
 ( 0,-2, 2,-2, 1,      -1283,       0,      0,      672,     0,     0),
 ( 1, 0, 2, 2, 1,      -1331,       0,      8,      663,     0,     4),
 (-2, 0, 2, 2, 2,       1383,       0,     -2,     -594,     0,    -2),
 (-1, 0, 0, 0, 2,       1405,       0,      4,     -610,     0,     2),
 ( 1, 1, 2,-2, 2,       1290,       0,      0,     -556,     0,     0)
);

//计算某时刻的黄经章动干扰量，dt是儒略千年数，返回值单位是度
function CalcEarthLongitudeNutation(dt:Double):Double;
//*计算某时刻的黄赤交角章动干扰量，dt是儒略千年数，返回值单位是度*/
function CalcEarthObliquityNutation(dt:double):Double;
implementation
procedure GetEarthNutationParameter(dt:double; var D:double;var M:double; var Mp:Double; var F:double; var  Omega:double);
var
  T,T2,T3:Double;
begin
  T  := dt * 10; //T是从J2000起算的儒略世纪数
  T2 := T * T;
  T3 := T2 * T;

  //平距角（如月对地心的角距离
  D := 297.85036 + 445267.111480 * T - 0.0019142 * T2 + T3 / 189474.0;

  //太阳（地球）平近点角
  M := 357.52772 + 35999.050340 * T - 0.0001603 * T2 - T3 / 300000.0;

  //月亮平近点角
  Mp := 134.96298 + 477198.867398 * T + 0.0086972 * T2 + T3 / 56250.0;

  //月亮纬度参数
  F := 93.27191 + 483202.017538 * T - 0.0036825 * T2 + T3 / 327270.0;

  //黄道与月亮平轨道升交点黄经
  Omega := 125.04452 - 1934.136261 * T + 0.0020708 * T2 + T3 / 450000.0;
end;
//计算某时刻的黄经章动干扰量，dt是儒略千年数，返回值单位是度
function CalcEarthLongitudeNutation(dt:Double):Double;
var
  T,D,M,Mp,F,Omega:Double;
  i:Integer;
  sita,resulte:Double;
begin
  T := dt * 10;

	GetEarthNutationParameter(dt, D, M, Mp, F, Omega);

  resulte := 0.0 ;
  for i := 0 to Length(nutationIAU1980)-1 do
  begin
    sita := nutationIAU1980[i].D * D + nutationIAU1980[i].M * M + nutationIAU1980[i].Mp * Mp + nutationIAU1980[i].F * F + nutationIAU1980[i].omega * Omega;
    sita := DegreeToRadian(sita);
    resulte :=resulte+ (nutationIAU1980[i].sine1 + nutationIAU1980[i].sine2 * T ) * sin(sita);
  end;

  //*先乘以章动表的系数 0.0001，然后换算成度的单位*/
  Result:= resulte * 0.0001 / 3600.0;
end;

//*计算某时刻的黄赤交角章动干扰量，dt是儒略千年数，返回值单位是度*/
function CalcEarthObliquityNutation(dt:double):Double;
var
  T,D,M,Mp,F,Omega:Double;
  sita,resulte:Double;
begin
  T:=dt*10;
  GetEarthNutationParameter(dt, D, M, Mp, F, Omega);
  for var I:Integer := Low(nutationIAU1980) to High(nutationIAU1980) do
  begin
    sita := nutationIAU1980[i].D * D + nutationIAU1980[i].M * M + nutationIAU1980[i].Mp * Mp + nutationIAU1980[i].F * F + nutationIAU1980[i].omega * Omega;
    sita := DegreeToRadian(sita);
    resulte :=resulte+ (nutationIAU1980[i].cosine1 + nutationIAU1980[i].cosine2 * T ) * Cos(sita);
  end;
  //*先乘以章动表的系数 0.0001，然后换算成度的单位*/
  Result:= resulte * 0.0001 / 3600.0;
end;
end.
