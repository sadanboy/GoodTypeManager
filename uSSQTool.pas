unit uSSQTool;

interface
uses
  System.Math,System.SysUtils;
type
  TqsKing=(suoType,qiType);
const
   //朔直线拟合参数
   suoKB:TArray<Double>=[
      1457698.231017,29.53067166, // -721-12-17 h=0.00032 古历·春秋
      1546082.512234,29.53085106, // -479-12-11 h=0.00053 古历·战国
      1640640.735300,29.53060000, // -221-10-31 h=0.01010 古历·秦汉
      1642472.151543,29.53085439, // -216-11-04 h=0.00040 古历·秦汉

      1683430.509300,29.53086148, // -104-12-25 h=0.00313 汉书·律历志(太初历)平气平朔
      1752148.041079,29.53085097, //   85-02-13 h=0.00049 后汉书·律历志(四分历)
    //1807665.420323,29.53059851, //  237-02-12 h=0.00033 晋书·律历志(景初历)
      1807724.481520,29.53059851, //  237-04-12 h=0.00033 晋书·律历志(景初历)
      1883618.114100,29.53060000, //  445-01-24 h=0.00030 宋书·律历志(何承天元嘉历)
      1907360.704700,29.53060000, //  510-01-26 h=0.00030 宋书·律历志(祖冲之大明历)
      1936596.224900,29.53060000, //  590-02-10 h=0.01010 随书·律历志(开皇历)
      1939135.675300,29.53060000, //  597-01-24 h=0.00890 随书·律历志(大业历)
      1947168.00//  619-01-21
   ];

   //气直线拟合参数
   qiKB:TArray<Double>=[
      1640650.479938,15.21842500,  // -221-11-09 h=0.01709 古历·秦汉
      1642476.703182,15.21874996,  // -216-11-09 h=0.01557 古历·秦汉

      1683430.515601,15.218750011, // -104-12-25 h=0.01560 汉书·律历志(太初历)平气平朔 回归年=365.25000
      1752157.640664,15.218749978, //   85-02-23 h=0.01559 后汉书·律历志(四分历) 回归年=365.25000
      1807675.003759,15.218620279, //  237-02-22 h=0.00010 晋书·律历志(景初历) 回归年=365.24689
      1883627.765182,15.218612292, //  445-02-03 h=0.00026 宋书·律历志(何承天元嘉历) 回归年=365.24670
      1907369.128100,15.218449176, //  510-02-03 h=0.00027 宋书·律历志(祖冲之大明历) 回归年=365.24278
      1936603.140413,15.218425000, //  590-02-17 h=0.00149 随书·律历志(开皇历) 回归年=365.24220
      1939145.524180,15.218466998, //  597-02-03 h=0.00121 随书·律历志(大业历) 回归年=365.24321
      1947180.798300,15.218524844, //  619-02-03 h=0.00052 新唐书·历志(戊寅元历)平气定朔 回归年=365.24460
      1964362.041824,15.218533526, //  666-02-17 h=0.00059 新唐书·历志(麟德历) 回归年=365.24480
      1987372.340971,15.218513908, //  729-02-16 h=0.00096 新唐书·历志(大衍历,至德历) 回归年=365.24433
      1999653.819126,15.218530782, //  762-10-03 h=0.00093 新唐书·历志(五纪历) 回归年=365.24474
      2007445.469786,15.218535181, //  784-02-01 h=0.00059 新唐书·历志(正元历,观象历) 回归年=365.24484
      2021324.917146,15.218526248, //  822-02-01 h=0.00022 新唐书·历志(宣明历) 回归年=365.24463
      2047257.232342,15.218519654, //  893-01-31 h=0.00015 新唐书·历志(崇玄历) 回归年=365.24447
      2070282.898213,15.218425000, //  956-02-16 h=0.00149 旧五代·历志(钦天历) 回归年=365.24220
      2073204.872850,15.218515221, //  964-02-16 h=0.00166 宋史·律历志(应天历) 回归年=365.24437
      2080144.500926,15.218530782, //  983-02-16 h=0.00093 宋史·律历志(乾元历) 回归年=365.24474
      2086703.688963,15.218523776, // 1001-01-31 h=0.00067 宋史·律历志(仪天历,崇天历) 回归年=365.24457
      2110033.182763,15.218425000, // 1064-12-15 h=0.00669 宋史·律历志(明天历) 回归年=365.24220
      2111190.300888,15.218425000, // 1068-02-15 h=0.00149 宋史·律历志(崇天历) 回归年=365.24220
      2113731.271005,15.218515671, // 1075-01-30 h=0.00038 李锐补修(奉元历) 回归年=365.24438
      2120670.840263,15.218425000, // 1094-01-30 h=0.00149 宋史·律历志 回归年=365.24220
      2123973.309063,15.218425000, // 1103-02-14 h=0.00669 李锐补修(占天历) 回归年=365.24220
      2125068.997336,15.218477932, // 1106-02-14 h=0.00056 宋史·律历志(纪元历) 回归年=365.24347
      2136026.312633,15.218472436, // 1136-02-14 h=0.00088 宋史·律历志(统元历,乾道历,淳熙历) 回归年=365.24334
      2156099.495538,15.218425000, // 1191-01-29 h=0.00149 宋史·律历志(会元历) 回归年=365.24220
      2159021.324663,15.218425000, // 1199-01-29 h=0.00149 宋史·律历志(统天历) 回归年=365.24220
      2162308.575254,15.218461742, // 1208-01-30 h=0.00146 宋史·律历志(开禧历) 回归年=365.24308
      2178485.706538,15.218425000, // 1252-05-15 h=0.04606 淳祐历 回归年=365.24220
      2178759.662849,15.218445786, // 1253-02-13 h=0.00231 会天历 回归年=365.24270
      2185334.020800,15.218425000, // 1271-02-13 h=0.00520 宋史·律历志(成天历) 回归年=365.24220
      2187525.481425,15.218425000, // 1277-02-12 h=0.00520 本天历 回归年=365.24220
      2188621.191481,15.218437494, // 1280-02-13 h=0.00015 元史·历志(郭守敬授时历) 回归年=365.24250
      2322147.76// 1645-09-21
   ];
var
  SBstr:string;
  QBstr:string;
//低精度定朔计算,在2000年至600，误差在2小时以内(仍比古代日历精准很多)
function so_low(w:Double):Double;

//最大误差小于30分钟，平均5分
function qi_low(w:Double):Double;

//气朔解压缩
function jieya(str:string):string;
//初始话气朔数据
procedure InitSuoQi(var SB:string;var QB:string);
//jd应靠近所要取得的气朔日,qs='气'时，算节气的儒略日
function calc(jde:Double;qsType:TqsKing):Double;
implementation
//低精度定朔计算,在2000年至600，误差在2小时以内(仍比古代日历精准很多)
function so_low(w:Double):Double;
var
  t:Double;
begin
   var v:Double:= 7771.37714500204;
   t:=(w+1.08472)/v;
   t:=t-( -0.0000331*t*t
    + 0.10976 *cos( 0.785 + 8328.6914*t)
    + 0.02224 *cos( 0.187 + 7214.0629*t)
    - 0.03342 *cos( 4.669 +  628.3076*t ) )/v
    + (32*(t+1.8)*(t+1.8)-20)/86400/36525;
   Result:= t*36525+8/24;
end;

//最大误差小于30分钟，平均5分
function qi_low(w:Double):Double;
var
  t,L,v:Double;
begin
  v:= 628.3319653318;
  t:=(w-4.895062166)/v; //第一次估算,误差2天以内
  t:=t-( 53*t*t + 334116*cos( 4.67+628.307585*t)
     + 2061*cos( 2.678+628.3076*t)*t )/v/10000000; //第二次估算,误差2小时以内
  L:= 48950621.66 + 6283319653.318*t + 53*t*t //平黄经
      +334166 * cos( 4.669257+  628.307585*t) //地球椭圆轨道级数展开
      +3489 * cos( 4.6261  + 1256.61517*t ) //地球椭圆轨道级数展开
      +2060.6 * cos( 2.67823 +  628.307585*t ) * t  //一次泊松项
      - 994 - 834*sin(2.1824-33.75705*t); //光行差与章动修正
  t:=t- (L/10000000 -W )/628.332 + (32*(t+1.8)*(t+1.8)-20)/86400/36525;
  Result:= t*36525+8/24;
end;

function jieya(str:string):string;
var
  o,o2,s:string;
begin
  o:='0000000000';
  o2:=o+o;
  s:=str;
  s:=s.Replace('J','00',[rfReplaceAll]);
  s:=s.Replace('I','000',[rfReplaceAll]);
  s:=s.Replace('H','0000',[rfReplaceAll]);
  s:=s.Replace('G','00000',[rfReplaceAll]);
  s:=s.Replace('t','02',[rfReplaceAll]);
  s:=s.Replace('s','002',[rfReplaceAll]);
  s:=s.Replace('r','0002',[rfReplaceAll]);
  s:=s.Replace('q','00002',[rfReplaceAll]);
  s:=s.Replace('p','000002',[rfReplaceAll]);
  s:=s.Replace('o','0000002',[rfReplaceAll]);
  s:=s.Replace('n','00000002',[rfReplaceAll]);
  s:=s.Replace('m','000000002',[rfReplaceAll]);
  s:=s.Replace('l','0000000002',[rfReplaceAll]);
  s:=s.Replace('k','01',[rfReplaceAll]);
  s:=s.Replace('j','0101',[rfReplaceAll]);
  s:=s.Replace('i','001',[rfReplaceAll]);
  s:=s.Replace('h','001001',[rfReplaceAll]);
  s:=s.Replace('g','0001',[rfReplaceAll]);
  s:=s.Replace('f','00001',[rfReplaceAll]);
  s:=s.Replace('e','000001',[rfReplaceAll]);
  s:=s.Replace('d','0000001',[rfReplaceAll]);
  s:=s.Replace('c','00000001',[rfReplaceAll]);
  s:=s.Replace('b','000000001',[rfReplaceAll]);
  s:=s.Replace('a','0000000001',[rfReplaceAll]);
  s:=s.Replace('A',o2+o2+o2,[rfReplaceAll]);
  s:=s.Replace('B',o2+o2+o,[rfReplaceAll]);
  s:=s.Replace('C',o2+o2,[rfReplaceAll]);
  s:=s.Replace('D',o2+o,[rfReplaceAll]);
  s:=s.Replace('E',o2,[rfReplaceAll]);
  s:=s.Replace('F',o,[rfReplaceAll]);
  Result:=s;
end;
//初始话气朔数据
procedure InitSuoQi(var SB:string;var QB:string);
var
  suoS,qiS:string;
begin
  //  619-01-21开始16598个朔日修正表 d0=1947168
  suoS:='EqoFscDcrFpmEsF2DfFideFelFpFfFfFiaipqti1ksttikptikqckstekqttgkqttgkqteksttikptikq2fjstgjqttjkqttgkqt';
  suoS:=suoS+'ekstfkptikq2tijstgjiFkirFsAeACoFsiDaDiADc1AFbBfgdfikijFifegF1FhaikgFag1E2btaieeibggiffdeigFfqDfaiBkF';
  suoS:=suoS+'1kEaikhkigeidhhdiegcFfakF1ggkidbiaedksaFffckekidhhdhdikcikiakicjF1deedFhFccgicdekgiFbiaikcfi1kbFibef';
  suoS:=suoS+'gEgFdcFkFeFkdcfkF1kfkcickEiFkDacFiEfbiaejcFfffkhkdgkaiei1ehigikhdFikfckF1dhhdikcfgjikhfjicjicgiehdik';
  suoS:=suoS+'cikggcifgiejF1jkieFhegikggcikFegiegkfjebhigikggcikdgkaFkijcfkcikfkcifikiggkaeeigefkcdfcfkhkdgkegieid';
  suoS:=suoS+'hijcFfakhfgeidieidiegikhfkfckfcjbdehdikggikgkfkicjicjF1dbidikFiggcifgiejkiegkigcdiegfggcikdbgfgefjF1';
  suoS:=suoS+'kfegikggcikdgFkeeijcfkcikfkekcikdgkabhkFikaffcfkhkdgkegbiaekfkiakicjhfgqdq2fkiakgkfkhfkfcjiekgFebicg';
  suoS:=suoS+'gbedF1jikejbbbiakgbgkacgiejkijjgigfiakggfggcibFifjefjF1kfekdgjcibFeFkijcfkfhkfkeaieigekgbhkfikidfcje';
  suoS:=suoS+'aibgekgdkiffiffkiakF1jhbakgdki1dj1ikfkicjicjieeFkgdkicggkighdF1jfgkgfgbdkicggfggkidFkiekgijkeigfiski';
  suoS:=suoS+'"ggfaidheigF1jekijcikickiggkidhhdbgcfkFikikhkigeidieFikggikhkffaffijhidhhakgdkhkijF1kiakF1kfheakgdkif';
  suoS:=suoS+'iggkigicjiejkieedikgdfcggkigieeiejfgkgkigbgikicggkiaideeijkefjeijikhkiggkiaidheigcikaikffikijgkiahi1';
  suoS:=suoS+'hhdikgjfifaakekighie1hiaikggikhkffakicjhiahaikggikhkijF1kfejfeFhidikggiffiggkigicjiekgieeigikggiffig';
  suoS:=suoS+'gkidheigkgfjkeigiegikifiggkidhedeijcfkFikikhkiggkidhh1ehigcikaffkhkiggkidhh1hhigikekfiFkFikcidhh1hit';
  suoS:=suoS+'cikggikhkfkicjicghiediaikggikhkijbjfejfeFhaikggifikiggkigiejkikgkgieeigikggiffiggkigieeigekijcijikgg';
  suoS:=suoS+'ifikiggkideedeijkefkfckikhkiggkidhh1ehijcikaffkhkiggkidhh1hhigikhkikFikfckcidhh1hiaikgjikhfjicjicgie';
  suoS:=suoS+'hdikcikggifikigiejfejkieFhegikggifikiggfghigkfjeijkhigikggifikiggkigieeijcijcikfksikifikiggkidehdeij';
  suoS:=suoS+'cfdckikhkiggkhghh1ehijikifffffkhsFngErD1pAfBoDd1BlEtFqA2AqoEpDqElAEsEeB2BmADlDkqBtC1FnEpDqnEmFsFsAFn';
  suoS:=suoS+'llBbFmDsDiCtDmAB2BmtCgpEplCpAEiBiEoFqFtEqsDcCnFtADnFlEgdkEgmEtEsCtDmADqFtAFrAtEcCqAE1BoFqC1F1DrFtBmF';
  suoS:=suoS+'tAC2ACnFaoCgADcADcCcFfoFtDlAFgmFqBq2bpEoAEmkqnEeCtAE1bAEqgDfFfCrgEcBrACfAAABqAAB1AAClEnFeCtCgAADqDoB';
  suoS:=suoS+'mtAAACbFiAAADsEtBqAB2FsDqpFqEmFsCeDtFlCeDtoEpClEqAAFrAFoCgFmFsFqEnAEcCqFeCtFtEnAEeFtAAEkFnErAABbFkAD';
  suoS:=suoS+'nAAeCtFeAfBoAEpFtAABtFqAApDcCGJ';

   //1645-09-23开始7567个节气修正表
  qiS:='FrcFs22AFsckF2tsDtFqEtF1posFdFgiFseFtmelpsEfhkF2anmelpFlF1ikrotcnEqEq2FfqmcDsrFor22FgFrcgDscFs22FgEe';
  qiS:=qiS+'FtE2sfFs22sCoEsaF2tsD1FpeE2eFsssEciFsFnmelpFcFhkF2tcnEqEpFgkrotcnEqrEtFermcDsrE222FgBmcmr22DaEfnaF22';
  qiS:=qiS+'2sD1FpeForeF2tssEfiFpEoeFssD1iFstEqFppDgFstcnEqEpFg11FscnEqrAoAF2ClAEsDmDtCtBaDlAFbAEpAAAAAD2FgBiBqo';
  qiS:=qiS+'BbnBaBoAAAAAAAEgDqAdBqAFrBaBoACdAAf1AACgAAAeBbCamDgEifAE2AABa1C1BgFdiAAACoCeE1ADiEifDaAEqAAFe1AcFbcA';
  qiS:=qiS+'AAAAF1iFaAAACpACmFmAAAAAAAACrDaAAADG0';

  SB:=jieya(suoS);
  QB:=jieya(qiS);
end;

//jde应靠近所要取得的气朔日,qs=qiType时，算节气的儒略日
function calc(jde:Double;qsType:TqsKing):Double;
var
  jd:Double;
  B:TArray<Double>;
  i,D,pc:Integer;
  f1,f2,f3:Double;
  n:string;
begin
  jd:=jde+2451545;
  B:=suoKB;pc:=14;
  if qsType=qiType then begin B:=qiKB; pc:=7  end;
  f1:=B[0]-pc;f2:=B[Length(B)-1]-pc;f3:=2436935;
  //平气朔表中首个之前，使用现代天文算法。1960.1.1以后，使用现代天文算法 (这一部分调用了qi_high和so_high,所以需星历表支持)
  if (jd<f1)or(jd>=f3) then
  begin
    if qsType=qiType then

  end;

  Result:=f1;
end;
Initialization
  InitSuoQi(SBstr,QBstr);

end.
