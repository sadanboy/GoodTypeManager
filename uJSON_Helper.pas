{**************************************
时间：2021-06-18
      2023-07-15 增加了删除函数
功能：1 实现delphi原生的JSON操作为 S[] 操作方式
作者：sensor QQ：910731685
}
unit uJSON_Helper;

interface
uses
  //System.Classes,
  //System.Types,
  //System.DateUtil,
  //System.Generics.Collections,
  //System.SysUtils,
  System.JSON;

type
  TJSONObjectHelper = class helper for TJSONObject
    private
       function  Get_ValueS(PairName : string) : string;
       procedure Set_ValueS(PairName,PairValue : string);

       function  Get_ValueI(PairName : string) : Integer;
       procedure Set_ValueI(PairName : string; PairValue : Integer);

       function  Get_ValueI64(PairName : string) : Int64;
       procedure Set_ValueI64(PairName : string; PairValue : Int64);

       function  Get_ValueD(PairName : string) : TDateTime;
       procedure Set_ValueD(PairName : string; PairValue : TDateTime);

       function  Get_ValueB(PairName : string) : Boolean;
       procedure Set_ValueB(PairName : string; PairValue : Boolean);

       function  Get_ValueA(PairName : string) : TJSONArray;
       procedure Set_ValueA(PairName : string; PairValue : TJSONArray);

       function  Get_ValueO(PairName : string) : TJSONObject;
       procedure Set_ValueO(PairName : string; PairValue : TJSONObject);

       //2023-07-15
       function  Get_ValueExists(PairName : string) : Boolean;
       function  Get_ValueDelete(PairName : string) : Boolean;
    public
      //判断某个字段是否存在
      function PairExists(PairName : string) : Boolean;
      function DeletePair(PairName : string) : Boolean;  //删除某个节点，如果节点存在则返回True，否则返回False,但执行命令后，肯定节点不存在了。

      //定义字段读取函数
      property S[PairName : string] : string      read Get_ValueS   write Set_ValueS;
      property I[PairName : string] : integer     read Get_ValueI   write Set_ValueI;
      property I64[PairName : string] : Int64     read Get_ValueI64 write Set_ValueI64;
      property D[PairName : string] : TDateTime   read Get_ValueD   write Set_ValueD;
      property B[PairName : string] : Boolean     read Get_ValueB   write Set_ValueB;
      property A[PairName : string] : TJSONArray  read Get_ValueA   write Set_ValueA;
      property O[PairName : string] : TJSONObject read Get_ValueO   write Set_ValueO;

      //2023-07-15 增加
      property Exists[PairName : string] : Boolean  read Get_ValueExists;   //只读属性
      property Delete[PairName : string] : Boolean  read Get_ValueDelete;   //删除某个节点，如果节点存在则返回True，否则返回False,但执行命令后，肯定节点不存在了。
  end;

implementation

{ TJSONObjectHelper }



function TJSONObjectHelper.Get_ValueS(PairName: string): string;
var
  js : TJSONString;
begin
  if PairName = '' then  Exit;

  if Self.TryGetValue(PairName,js) then
     Result := js.Value
  else
     Result := '';
end;

function TJSONObjectHelper.PairExists(PairName: string): Boolean;
begin
  Result := Self.Values[PairName] <> nil;
end;



procedure TJSONObjectHelper.Set_ValueS(PairName, PairValue: string);
var
  js : TJSONString;
begin
  //1. 首先查找有没有该字段, 如果有，则直接删除
  if Self.TryGetValue(PairName,js) then
     begin
       Self.RemovePair(PairName).Free; //如果没有free，就会产生内存泄露
     end;
  //2. 然后在增加
  Self.AddPair(PairName, PairValue);
end;

function TJSONObjectHelper.Get_ValueI(PairName: string): Integer;
var
  ji : TJSONNumber;
begin
  if PairName = '' then  Exit(0);

  if Self.TryGetValue(PairName,ji) then
     Result := ji.AsInt
  else
     Result := 0;
end;

procedure TJSONObjectHelper.Set_ValueI(PairName: string; PairValue: Integer);
var
  jn : TJSONNumber;
begin
  //1. 首先查找有没有该字段, 如果有，则直接删除
  if Self.TryGetValue(PairName,jn) then
     Self.RemovePair(PairName).Free;
  //2. 然后在增加
  Self.AddPair(PairName, TJSONNumber.Create(PairValue));
end;

function TJSONObjectHelper.Get_ValueD(PairName: string): TDateTime;
var
  ji : TJSONNumber;
begin
  if PairName = '' then  Exit(0);

  if Self.TryGetValue(PairName,ji) then
     Result := ji.AsDouble
  else
     Result := 0;
end;

function TJSONObjectHelper.Get_ValueDelete(PairName: string): Boolean;
begin
  if not Self.PairExists(PairName) then Exit(False);
  Self.RemovePair(PairName).Free;
  Result := True;
end;

function TJSONObjectHelper.Get_ValueExists(PairName: string): Boolean;
begin
  Result := Self.Values[PairName] <> nil;
end;

procedure TJSONObjectHelper.Set_ValueD(PairName: string; PairValue: TDateTime);
var
  jn : TJSONNumber;
begin
  //1. 首先查找有没有该字段, 如果有，则直接删除
  if Self.TryGetValue(PairName,jn) then
     Self.RemovePair(PairName).Free;
  Self.AddPair(PairName, TJSONNumber.Create(PairValue));
end;


function TJSONObjectHelper.Get_ValueB(PairName: string): Boolean;
var
  jb : TJSONBool;
begin
  if PairName = '' then  Exit(False);

  if Self.TryGetValue(PairName,jb) then
     Result := jb.AsBoolean
  else
     Result := False;
end;

procedure TJSONObjectHelper.Set_ValueB(PairName: string; PairValue: Boolean);
var
  jb : TJSONBool;
begin
  //1. 首先查找有没有该字段, 如果有，则直接删除
  if Self.TryGetValue(PairName,jb) then
     Self.RemovePair(PairName).Free;
  Self.AddPair(PairName, TJSONBool.Create(PairValue));
end;


function TJSONObjectHelper.Get_ValueI64(PairName: string): Int64;
var
  ji : TJSONNumber;
begin
  if PairName = '' then  Exit(0);

  if Self.TryGetValue(PairName,ji) then
     Result := ji.AsInt64
  else
     Result := 0;
end;


procedure TJSONObjectHelper.Set_ValueI64(PairName: string; PairValue: Int64);
var
  jn : TJSONNumber;
begin
  //1. 首先查找有没有该字段, 如果有，则直接删除
  if Self.TryGetValue(PairName,jn) then
     Self.RemovePair(PairName).Free;
  Self.AddPair(PairName, TJSONNumber.Create(PairValue));
end;





function TJSONObjectHelper.DeletePair(PairName: string): Boolean;
begin
  if not Self.PairExists(PairName) then Exit(False);
  Self.RemovePair(PairName).Free;
  Result := True;
end;

function TJSONObjectHelper.Get_ValueA(PairName: string): TJSONArray;
begin
  if PairName = '' then  Exit(nil);

  Self.TryGetValue(PairName,Result);
end;





procedure TJSONObjectHelper.Set_ValueA(PairName: string; PairValue: TJSONArray);
var
  ja : TJSONArray;
begin
  //1. 首先查找有没有该字段, 如果有，则直接删除
  if Self.TryGetValue(PairName,ja) then
     Self.RemovePair(PairName).Free;

  Self.AddPair(PairName, PairValue);
end;


function TJSONObjectHelper.Get_ValueO(PairName: string): TJSONObject;
var
  jo : TJSONObject;
begin
  if PairName = '' then  Exit(nil);

  if Self.TryGetValue(PairName,jo) then
     Result := jo
  else
     Result := nil;
end;

procedure TJSONObjectHelper.Set_ValueO(PairName: string; PairValue: TJSONObject);
var
  jo : TJSONObject;
begin
  //1. 首先查找有没有该字段, 如果有，则直接删除
  if Self.TryGetValue(PairName,jo) then
     Self.RemovePair(PairName).Free;
  Self.AddPair(PairName, PairValue as TJSONObject);
end;

end.
