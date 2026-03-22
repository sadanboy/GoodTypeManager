unit uLunar;

interface
  uses
    System.SysUtils,uConst,System.StrUtils;

type
  TChinaDateInfo = record
    //日的公历信息
    FDayName: string;      //日名称（公历）
    FDayNo: Integer;       //所在公历月的月内日序数
    FDaysNum: Integer;     //所在公历月的总天数
    FDayJD: Double;        //2000.0起算儒略日,北京时12:00
    FFirstWeek: Integer;   //所在月的月首的星期,同lun.w0
    FMonth: Integer;       //所在公历月
    FWeek: Integer;        //星期
    FWeekNo: Integer;      //在本月中的周序号
    FWeekNum: Integer;     //本月的总周数
    FYear: Integer;        //所在公历年
    FDay:Integer;          //日名称（公历）
    //日的农历信息
    FLunDayNo:Integer;     //距离农历月首的便宜量，0对应初一
    FLunDayName:string;    //农历日名称，及“初一，初二等”
    FCurrToDZ:Integer;     //距冬至的天数
    FCurrToXZ:Integer;     //距夏至的天数
    FCurrToLQ:Integer;     //距立秋的天数
    FCurrToMZ:Integer;     //距芒种的天数
    FCurrToXS:Integer;     //距小暑的天数
    FLunMonName:string;    //农历月名称
    FlunDaysNum:Integer;   //所在农历月的总天数，判断月大小用
    FLunLeap:string;       //闰状况(值为'闰'或空串)
    FNextLunMonName:string;//下个月名称,判断除夕时要用到
    //日的农历纪年，月，日时以及星座
    Lyear:Integer;         //农历纪年(10进制,1984年起算)
    Lyear0:Integer;
    Lyear2:string;         //干支纪年(立春)
    Lyear3:string;         //干支纪年(正月)
    Lyear4:Integer;        //黄帝纪年
    //日的节日信息
    FA:string;              //重要喜庆日子名称(可将日子名称置红)
    FB:string;              //重要日子名称
    FC:string;              //各种日子名称(连成一大串)
    Fjia:Boolean;           //放假日子(可用于日期数字置红)
    //日的回历信息
    Hyear:Integer;          // 年(回历)
    Hmonth:Integer;         // 月(回历)
    Hday:Integer;           // 日(回历)
    //日的其它信息
    yxmc:string;
    yxjd:Double;
    yxsj:string;
    jqmc:string;
    jqjd:Double;
    jqsj:string;

    sFtv:array[0..11]of TArray<string>;
    procedure InitsFtv;
    procedure getDayName;
    procedure getHuiLi;
    function getNH(y:Integer):string;
  end;
  TChinaMonthInfo=record
    week0:Integer;//本月第一天的星期
    year:Integer;//公历年份

  end;

implementation
uses
  System.Math;


{ TDateInfo }

procedure TChinaDateInfo.getDayName;
var
  s,s2,wstr,w2str:string;
  typ:string;
begin
  var m0:string:=IfThen(FMonth<10,'0')+FMonth.ToString;
  var d0:string:=IfThen(FDay<10,'0')+FDay.ToString;
  if (FWeek=0)or(FWeek=6) then Fjia:=True; //星期日或星期六放假

  //按公历日查找
  for var i:Integer := Low(sFtv[FMonth-1]) to High(sFtv[FMonth-1]) do
  begin
    s:=sFtv[FMonth-1,i];
    if(s.Substring(0,2)<>d0)then Continue;
    s:=s.Substring(2,s.Length-2);
    typ:= s.Substring(0,1);
    if(s.Substring(5,1)='-')then //有年限的
    begin
      if (FYear<s.Substring(1,4).ToInteger-0)or(FYear>s.Substring(6,4).ToInteger-0)then
         Continue;
      s:=s.Substring(10,s.Length-10);
    end else
    begin
      if FYear<1850 then Continue;
      s:=s.Substring(1,s.Length-1);
    end;
    if typ='#' then
    begin
      FA:=FA+ s+ '  '; //放假的节日
      Fjia:=True;
    end;
    if(typ='I')then  FB :=FB+ s + ' '; //主要
    if(typ='.')then  FC:=FC + s + ' '; //其它
  end;
  //按周查找
  var w:Integer:=FWeekNo;
  if FWeek>FWeekNo then inc(w);
  var w2:=w;
  if FWeekNo=FWeekNum-1 then w2:=5;
  wstr:=m0 +w.ToString+FWeek.ToString;
  w2str:=m0+w2.ToString+FWeek.ToString;
  for var I:Integer := Low(wFtv) to High(wFtv) do
  begin
    s:=wFtv[i];
    s2:=s.Substring(0,4);
    if (s2<>wstr)and(s2<>w2str) then Continue;
    typ:=s.Substring(4,1);
    s:=s.Substring(5,s.Length-5);
    if typ='#' then
    begin
      FA:=FA+ s+ '  '; //放假的节日
      Fjia:=True;
    end;
    if(typ='I')then  FB :=FB+ s + ' '; //主要
    if(typ='.')then  FC:=FC+s + ' '; //其它
  end;
end;

procedure TChinaDateInfo.getHuiLi;
var
  d:Double;
  z,y,m:Integer;
begin
  d:=FDayJD+503105;         z:=Floor(d/10631);//10631为一周期(30年)
  d:=d-z*10631 ;            y:=Floor((d+0.5)/654.366);//加0.5的作用是保证闰年正确(一周中的闰年是第2,5,7,10,13,16,18,21,24,26,29年)
  d:=d-Floor(y*354.366+0.5);m:=Floor((d+0.11)/29.51); //分子加0.11,分母加0.01的作用是第354或355天的的月分保持为12月(m=11)
  d:=d-Floor(m*29.5+0.5);
  Hyear:=z*30+y+1;
  Hmonth:=m+1;
  Hday:=Floor(d+1);
end;

function TChinaDateInfo.getNH(y:Integer):string;
var
  JNB:TArray<string>;
  s,c:string;
  year,year2:Integer;
begin
  s:='';
  for var i:Integer := Low(CnYearNumber) to High(CnYearNumber) do
  begin
    JNB:=CnYearNumber[i].Split([',']);
    year:=JNB[0].ToInteger;
    year2:=year+JNB[1].ToInteger;
    if (y<year)or(y>=year2) then Continue;
    c:=JNB[6]+(y-year+1+JNB[2].ToInteger).ToString+'年';
    s:=s+IfThen(not s.IsEmpty,';','') +'【'+JNB[3]+'】'+JNB[4]+' '+JNB[5]+' '+c;
  end;
  Result:=s;
end;

procedure TChinaDateInfo.InitsFtv;
var
  ssFtv:TArray<string>;
begin
  ssFtv:=sFtvStr.Split(['|']);
  for var I:Integer := Low(ssFtv) to High(ssFtv) do
    sFtv[i]:=ssFtv[i].Split([',']);
end;

end.
