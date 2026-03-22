unit UnitBitmapRgn;

interface

uses Windows, Graphics, Forms, Classes, Controls, Dialogs, SysUtils;

type
  TBitmapRgn = class(TComponent)
  private
    FMask: TBitmap;
    FColor: TColor;
    FControl: TWinControl;
    function CreateRegion: HRGN;
    procedure SetBitmap(value: TBitmap);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Regionize;
  published
    property Mask: TBitmap read FMask write SetBitmap;
    property TransparentColor: TColor read FColor write FColor;
  end;

procedure Register;

implementation

procedure Register;
begin
     RegisterComponents('Free', [TBitmapRgn]);
end;

constructor TBitmapRgn.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);
     if AOwner is TWinControl then
       FControl := TWinControl(AOwner);
     FMask := TBitmap.Create;
end;

destructor TBitmapRgn.Destroy;
begin
     if FMask<>nil then FMask.Free;
     FControl := nil;
     inherited Destroy;
end;

procedure TBitmapRgn.SetBitmap(value: TBitmap);
begin
     if FMask<>nil then FMask.Free;
     FMask := TBitmap.Create;
     FMask.Assign(value);
end;

function TBitmapRgn.CreateRegion: HRGN;
var
   dc, dc_c: HDC;
   rgn: HRGN;
   x, y: integer;
   coord: TPoint;
   line: boolean;
   color: TColor;
begin
     dc := GetWindowDC(FControl.Handle);
     dc_c := CreateCompatibleDC(dc);
     SelectObject(dc_c, FMask.Handle);
     BeginPath(dc);
     for x:=0 to FMask.Width-1 do
     begin
          line := false;
          for y:=0 to FMask.Height-1 do
          begin
               color := GetPixel(dc_c, x, y);
               if not (color = FColor) then
               begin
                    if not line then
                    begin
                         line := true;
                         coord.x := x;
                         coord.y := y;
                    end;
               end;
               if (color = FColor) or (y=FMask.Height-1) then
               begin
                    if line then
                    begin
                         line := false;
                         MoveToEx(dc, coord.x, coord.y, nil);
                         LineTo(dc, coord.x, y);
                         LineTo(dc, coord.x + 1, y);
                         LineTo(dc, coord.x + 1, coord.y);
                         CloseFigure(dc);
                    end;
               end;
          end;
     end;
     EndPath(dc);
     rgn := PathToRegion(dc);
     ReleaseDC(FControl.Handle, dc);
     Result := rgn;
end;

procedure TBitmapRgn.Regionize;
var
   rgn: HRGN;
begin
     if (FMask<>nil) and (Owner<>nil) and (Owner is TWinControl) then begin
       rgn := CreateRegion;
       if rgn<>0 then begin
         SetWindowRgn(FControl.Handle, rgn, true);
         FControl.Width := FMask.Width;
         FControl.Height := FMask.Height;
       end;
       FMask.Free;
       FMask := TBitmap.Create;
     end;
end;

end.
