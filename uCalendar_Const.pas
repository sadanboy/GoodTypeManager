unit uCalendar_Const;

interface

const
   MONTHES_FOR_YEAR:Integer =12;
   DAYS_FOR_WEEK = 7;

   DAYS_OF_LEAP_YEAR:Integer = 366;
   DAYS_OF_NORMAL_YEAR:Integer = 365;

   SOLAR_TERMS_COUNT:Integer = 24;

   HEAVENLY_STEMS:Integer = 10;
   EARTHLY_BRANCHES:Integer = 12;
   CHINESE_SHENGXIAO:Integer = 12;
   MAX_GREGORIAN_MONTH_DAYS:Integer = 31;

   MAX_CHINESE_MONTH_DAYS:Integer = 30;
   CHINESE_L_MONTH_DAYS:Integer = 30;
   CHINESE_S_MONTH_DAYS:Integer = 29;
   MAX_CHINESE_MONTH_FOR_YEAR:Integer = 13;

   JD2000:Double = 2451545.0;
   // 圆周率
   PI = 3.1415926535897932384626433832795;

   /// <summary>
   /// 每弧度的角秒数
   /// </summary>
   ARC_SEC_PER_RADIAN:Double = 180.0 * 3600.0 / PI;

   /// <summary>
   /// 一度代表的弧度
   /// </summary>
   RADIAN_PER_ANGLE:Double = PI / 180.0;


   SUN_EL_V:Double = 360.0 / 365.2422;
   MOON_EL_V:Double = 360.0 / 27.32;

   // 节气定义
   VERNAL_EQUINOX      = 0;    // 春分
   CLEAR_AND_BRIGHT    = 1;    // 清明
   GRAIN_RAIN          = 2;    // 谷雨
   SUMMER_BEGINS       = 3;    // 立夏
   GRAIN_BUDS          = 4;    // 小满
   GRAIN_IN_EAR        = 5;    // 芒种
   SUMMER_SOLSTICE     = 6;    // 夏至
   SLIGHT_HEAT         = 7;    // 小暑
   GREAT_HEAT          = 8;    // 大暑
   AUTUMN_BEGINS       = 9;    // 立秋
   STOPPING_THE_HEAT   = 10;   // 处暑
   WHITE_DEWS          = 11;   // 白露
   AUTUMN_EQUINOX      = 12;   // 秋分
   COLD_DEWS           = 13;   // 寒露
   HOAR_FROST_FALLS    = 14;   // 霜降
   WINTER_BEGINS       = 15;   // 立冬
   LIGHT_SNOW          = 16;   // 小雪
   HEAVY_SNOW          = 17;   // 大雪
   WINTER_SOLSTICE     = 18;   // 冬至
   SLIGHT_COLD         = 19;   // 小寒
   GREAT_COLD          = 20;   // 大寒
   SPRING_BEGINS       = 21;   // 立春
   THE_RAINS           = 22;   // 雨水
   INSECTS_AWAKEN      = 23;   // 惊蛰
type
   SOLAR_TERMS = Integer;

const
  yueMing: array[0..11] of String =('正','二','三','四','五','六','七','八','九','十','冬','腊');
  Gan: array[0.. 9] of String =('甲','乙','丙','丁','戊','己','庚','辛','壬','癸');
  Zhi: array[0..11] of String =('子','丑','寅','卯','辰','巳','午','未','申','酉','戌','亥');
  ShX: array[0..11] of String =('鼠','牛','虎','兔','龙','蛇','马','羊','猴','鸡','狗','猪');
  rmc: array[0..29] of String =('初一','初二','初三','初四','初五','初六','初七','初八','初九','初十','十一','十二','十三','十四','十五','十六','十七','十八','十九','二十','廿一','廿二','廿三','廿四','廿五','廿六','廿七','廿八','廿九','三十');
  jqB: array[0..23] of String =( //节气表
  '春分','清明','谷雨','立夏','小满','芒种','夏至','小暑','大暑','立秋','处暑','白露',
  '秋分','寒露','霜降','立冬','小雪','大雪','冬至','小寒','大寒','立春','雨水','惊蛰');
implementation

end.
