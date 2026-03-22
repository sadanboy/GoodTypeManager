unit uDayInfo;

interface
uses
  uCalendar_Const;
type
  DayInfo=record
    dayNo  :Integer;     //本月内的日序号
    week   :Integer;     //本日的星期
    mdayNo :Integer;     //本日对应的农历月内日序号
    mmonth :Integer;     //本日所在的农历月序号
    st     :SOLAR_TERMS; //本日对应的节气，-1 表示不是节气
  end;

  TDayInfo = class(TObject)
  public
    constructor Create(info:DayInfo);
    destructor Destroy; override;
    procedure SetDayInfo(const info : DayInfo);
    procedure GetDayInfo(var info:DayInfo);
  protected
    m_Info: DayInfo;
  end;

implementation

constructor TDayInfo.Create(info:DayInfo);
begin
  inherited Create;
  SetDayInfo(info);
end;

destructor TDayInfo.Destroy;
begin
  inherited Destroy;
end;

procedure TDayInfo.GetDayInfo(var info: DayInfo);
begin
  info.dayNo:=m_Info.dayNo;
  info.week:=m_Info.week;
  info.mdayNo:=m_Info.mdayNo;
  info.mmonth:=m_Info.mmonth;
  info.st:= m_Info.st;
end;

procedure TDayInfo.SetDayInfo(const info:DayInfo);
begin
  m_Info.dayNo:=info.dayNo;
  m_Info.week:=info.week;
  m_Info.mdayNo:=info.mdayNo;
  m_Info.mmonth:=info.mmonth;
  m_Info.st:= info.st;
end;

end.
