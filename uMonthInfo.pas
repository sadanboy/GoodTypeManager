unit uMonthInfo;

interface
uses
  System.Generics.Collections,uCalendar_Const,uDayInfo;
type
  PMONTH_INFO=^MONTH_INFO;
  MONTH_INFO=record
    month:Integer;         //公历月序号
    days:Integer;          //公历月天数
    first_week:Integer;    //本月1号的星期
    jieqiJD:Double;        //本月节气的JD，本地时间
    jieqi: SOLAR_TERMS;    //本月节气序号
    zhongqiJD:Double;      //本月中气的JD，本地时间
    zhongqi:SOLAR_TERMS;   //本月中气的序号
  end;
  CHN_MONTH_INFO=record
    mmonth:Integer;           //农历月序号
    mname:Integer;            //农历月名称
    mdays:Integer;            //本月天数
    shuoJD:Integer;        //本月朔日的JD，本地时间
    nextJD:Integer;        //下月朔日的JD，本地时间
    leap:Integer;             //0 是正常月，1 是闰月
  end;
  //TChineseCalendar=class;
  TMonthInfo=class
  protected
     constructor Create(info:MONTH_INFO);
  public
     destructor Destroy; override;
     procedure SetMonthInfo(const info:MONTH_INFO);
     procedure GetMonthInfo(info:MONTH_INFO);
     function GetDayInfo(day:Integer):TDayInfo;
     procedure AddSingleDay(info:TDayInfo);
     function  GetMonthIndex:Integer;
     function  GetDaysCount:Integer;
     function  GetFirstDayWeek:Integer;
     function CheckValidDayCount:Boolean;
     procedure ClearInfo;
  protected
     m_Info:MONTH_INFO;
     m_DayInfo:TList<TDayInfo>;
  end;


implementation

{ TMonthInfo }

procedure TMonthInfo.AddSingleDay(info: TDayInfo);
begin
  m_DayInfo.Add(info);
end;

function TMonthInfo.CheckValidDayCount: Boolean;
begin
   Result:=m_Info.days=m_DayInfo.Count;
end;

procedure TMonthInfo.ClearInfo;
begin
   m_DayInfo.Clear;
end;

constructor TMonthInfo.Create(info: MONTH_INFO);
begin
  m_DayInfo.Create;
  SetMonthInfo(info);
end;

destructor TMonthInfo.Destroy;
begin
  m_DayInfo.DisposeOf;
  inherited;
end;

function TMonthInfo.GetDayInfo(day: Integer): TDayInfo;
begin
   Assert((m_DayInfo.Count>0)and(m_DayInfo.Count<=MAX_GREGORIAN_MONTH_DAYS));
   if ((day<1)or(day>m_DayInfo.Count))  then
   begin
     Result:=m_DayInfo.First;
   end else
   Result:=m_DayInfo.Items[day-1];
end;

function TMonthInfo.GetDaysCount: Integer;
begin
  Result:=m_Info.days;
end;

function TMonthInfo.GetFirstDayWeek: Integer;
begin
  Result:=m_Info.first_week;
end;

function TMonthInfo.GetMonthIndex: Integer;
begin
  Result:=m_Info.month;
end;

procedure TMonthInfo.GetMonthInfo(info: MONTH_INFO);
begin
   info.month:=m_Info.month;
   info.days:=m_Info.days;
   info.first_week:=m_Info.first_week;
   info.jieqiJD:=m_Info.jieqiJD;
   info.jieqi:=m_Info.jieqi;
   info.zhongqiJD:=m_Info.zhongqiJD;
   info.zhongqi:=m_Info.zhongqi;
end;

procedure TMonthInfo.SetMonthInfo(const info: MONTH_INFO);
begin
   m_Info.month:=info.month;
   m_Info.days:=info.days;
   m_Info.first_week:=info.first_week;
   m_Info.jieqiJD:=info.jieqiJD;
   m_Info.jieqi:=info.jieqi;
   m_Info.zhongqiJD:=info.zhongqiJD;
   m_Info.zhongqi:=info.zhongqi
end;

end.
