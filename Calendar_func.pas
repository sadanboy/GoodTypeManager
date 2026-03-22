unit Calendar_func;

interface
 uses
   System.SysUtils,System.DateUtils,System.SysConst,
   System.Math,uCalendar_Const,Support,Sun,moon;

   //每月第一个节气发生日期基本都4-9日之间，第二个节气的发生日期都在16－24日之间
   function GetInitialEstimateSolarTerms(year, angle:Integer):Double;



   /// <summary>
   /// 计算指定年份的任意节气，angle是节气在黄道上的读数
   /// 返回指定节气的儒略日时间(力学时)
   /// </summary>
   /// <param name="year">传入要计算的年</param>
   /// <param name="angle">节气对应的角度</param>
   /// <returns>返回指定节气的儒略日时间(力学时)</returns>
   function  CalculateSolarTerms(year:Integer; angle:Integer):Double;

   /// <summary>
   /// 得到给定的时间后面第一个日月合朔的时间，平均误差小于3秒
   /// 输入参数是指定时间的力学时儒略日数
   /// 返回值是日月合朔的力学时儒略日数
   /// </summary>
   function CalculateMoonShuoJD(tdJD:double ):Double;

   /// <summary>
   /// 计算年的干支
   /// </summary>
   procedure CalculateStemsBranches(year:Integer;var stems:Integer;var branches:Integer);

implementation

   function GetInitialEstimateSolarTerms(year, angle:Integer):Double;
   var
     STMonth:Integer;
   begin
     STMonth := Floor(Ceil((angle + 90.0) / 30.0));

     STMonth:=IfThen(STMonth > 12,STMonth - 12,STMonth) ;
     //if STMonth>12 then STMonth:= STMonth - 12;

     //每月第一个节气发生日期基本都4-9日之间，第二个节气的发生日期都在16－24日之间
     if (((angle mod 15) = 0) and ((angle mod 30)<>0)) then
     begin
       Result:= CalculateJulianDay(year, STMonth, 6, 12, 0, 0.00);
     end else
     begin
       Result:= CalculateJulianDay(year, STMonth, 20, 12, 0, 0.00);
     end;
   end;

   function  CalculateSolarTerms(year:Integer; angle:Integer):Double;
   var
     JD0, JD1,stDegree,stDegreep:Double;
   begin
     JD1:= GetInitialEstimateSolarTerms(year, angle);
    repeat
       JD0:=JD1;
       stDegree := GetSunEclipticLongitudeEC(JD0);
       {
         对黄经0度迭代逼近时，由于角度360度圆周性，估算黄经值可能在(345,360]和[0,15)两个区间，
         如果值落入前一个区间，需要进行修正
       }
       stDegree := IfThen((angle = 0)and(stDegree>345.0),stDegree - 360.0,stDegree);
       stDegreep := (GetSunEclipticLongitudeEC(JD0 + 0.000005)
                      - GetSunEclipticLongitudeEC(JD0 - 0.000005)) / 0.00001;
       JD1 := JD0 - (stDegree - angle) / stDegreep;
    until((abs(JD1 - JD0) <= 0.0000001)) ;

    Result:=JD1;
   end;

   function CalculateMoonShuoJD(tdJD:double ):Double;
   var
     JD0, JD1,stDegree,stDegreep:Double;
   begin
     JD1 := tdJD;
     repeat
       JD0 := JD1;
		   var moonLongitude:Double := GetMoonEclipticLongitudeEC(JD0);
		   var sunLongitude:Double := GetSunEclipticLongitudeEC(JD0);
       if (moonLongitude>330.0)and(sunLongitude < 30.0) then
       begin
         sunLongitude := 360.0 + sunLongitude;
       end;
       if (sunLongitude>330.0)and(moonLongitude < 30.0) then
       begin
         moonLongitude := 60.0 + moonLongitude;
       end;

       stDegree := moonLongitude - sunLongitude;
       if stDegree>=360.0 then stDegree:=stDegree-360.0;
       if stDegree<-360.0 then stDegree:=stDegree+360.0;
       stDegreep := (GetMoonEclipticLongitudeEC(JD0 + 0.000005)
                   - GetSunEclipticLongitudeEC(JD0 + 0.000005)
                   - GetMoonEclipticLongitudeEC(JD0 - 0.000005)
                   + GetSunEclipticLongitudeEC(JD0 - 0.000005)) / 0.00001;
       JD1 := JD0 - stDegree / stDegreep;
     until ((abs(JD1 - JD0) <= 0.00000001));

     Result:=JD1;
   end;

   procedure CalculateStemsBranches(year:Integer;var stems:Integer;var branches:Integer);
   begin
     var sc:Integer := year - 2000;
     stems := (7 + sc) mod 10;
     branches := (5 + sc) mod 12;

     if stems <= 0 then stems :=stems + 10;
     if branches <= 0 then branches := branches + 12;
   end;
end.
