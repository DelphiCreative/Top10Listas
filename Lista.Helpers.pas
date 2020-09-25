unit Lista.Helpers;

interface

uses
   FMX.Dialogs,
   FMX.Types,
   FMX.Layouts,
   FMX.Controls,
   FMX.Graphics,
   FMX.StdCtrls,
   FMX.Objects,
   System.Classes,
   System.Variants,
   FMX.MultiResBitmap,
   System.SysUtils,
   System.StrUtils,
   System.RegularExpressions,
   System.Types,
   FMX.Effects,
   System.UITypes;

type
 TShapeHelper = class helper for TShape

   function Imagem(const Value: String; Width :Real;
     Align : TAlignLayout = TAlignLayout.Left; X  :Real = 0;Y :Real = 0): TShape;

   function Text(const Value: String): TShape;
   function Size(const Value: Integer): TShape;
   function Color(const Value :String): TShape; overload;
   function Color(const Value :TAlphaColor): TShape; overload;
   function Bold : TShape;
   function Italic : TShape;
   function Underline : TShape;
   function StrikeOut : TShape;
   function LineBreak : TShape;

   function Add : TShape;
   function Exibir : String;
   procedure ImagemByName(name :String);
   procedure Texto(Text:String;FontSize :Real = 10);
   procedure ClickURL(Sender:TObject);
   procedure Sombrear;
end;

implementation

uses
   uMain;

var
   Str,Tags :String;

{ TImageHelper }
function TShapeHelper.Text(const Value: String): TShape;
begin
   Str := Value;
   Result := Self;
end;

function TShapeHelper.Add: TShape;
begin

   Hint := (Hint +' '+ Tags +  Str.Replace(' ',' '+tags)+' ');
   Str := '';
   Tags := '';
   Result := Self;
end;

function TShapeHelper.Bold: TShape;
begin
   tags := tags + ('<b>');
   Result := Self;
end;

procedure TShapeHelper.ClickURL(Sender: TObject);
begin

end;

function TShapeHelper.Color(const Value: TAlphaColor): TShape;
begin

  // tags := tags + ('<cor='+ InttoStr(value) +'>');

   Result := Self;
end;

function TShapeHelper.Color(const Value: String): TShape;
begin
   tags := tags + ('<'+value+'>');
   Result := Self;
end;

function TShapeHelper.Exibir: String;
begin
   Texto(Hint);
end;

function TShapeHelper.Imagem(const Value: String; Width :Real;
     Align : TAlignLayout = TAlignLayout.Left; X  :Real = 0;Y :Real = 0): TShape;
var
   R :TRectangle;
   L :TLayout;
begin

   L := TLayout.Create(Self);
   L.Tag := 1;
   if Width = 0 then begin
      Width:= Self.Height;
   end;

   if Align = TAlignLayout.Top then
      L.Height := Width

   else if Align = TAlignLayout.HorzCenter then begin
      L.Height := Width;
      L.Padding.Left := Self.Width / 3;
      L.Padding.Right := Self.Width / 3;

      Align := TAlignLayout.Top;

   end else
      L.Width := Width;

   if Align = TAlignLayout.Left then
     L.Margins.Right := 10
   else if Align = TAlignLayout.Right then
     L.Margins.Left := 10;

   L.Align := Align;
   Self.AddObject(L);

   R := TRectangle.Create(L);
   R.ImagemByName(Value);
   R.Align := TAlignLayout.Client;
   R.XRadius := X;
   R.YRadius := Y;

   L.AddObject(R);
   Result := Self;
end;

procedure TShapeHelper.ImagemByName(name: String);
var
   Item: TCustomBitmapItem;
   Size: TSize;
   i :Integer;
begin

   for I := 0 to FormMain.Imagens.Source.Count - 1 do begin
      if FormMain.Imagens.Source[I].Name = Name then begin
         FormMain.Imagens.BitmapItemByName(Name, Item, Size);
         Self.Fill.Kind := TBrushKind.Bitmap;
//         Self.Stroke.Kind := TBrushKind.None;
         Self.Stroke.Color := TAlphaColors.Null;
         
         Self.Fill.Bitmap.WrapMode := TWrapMode.TileStretch;
         Self.Fill.Bitmap.Bitmap := Item.MultiResBitmap.Bitmaps[1.0];
         Self.Tag := 1;
      end;
   end;

end;

function TShapeHelper.Italic: TShape;
begin
   tags := tags + ('<i>');
   Result := Self;
end;

function TShapeHelper.LineBreak: TShape;
begin
   Hint := (Hint +'<br>');
   Result := Self;
end;

function TShapeHelper.Size(const Value: Integer): TShape;
begin
   tags := tags + ('<font='+FloatToStr(Value)+'>');
   Result := Self;
end;

procedure TShapeHelper.Sombrear;
var
   S : TShadowEffect;
begin
   S := TShadowEffect.Create(Self);
   S.Distance    := 2;
   S.Direction   := 45;
   S.Softness    := 0.2;
   S.Opacity     := 0.2;
   S.ShadowColor := TAlphaColors.Black;
   Self.AddObject(S);
end;

function TShapeHelper.StrikeOut: TShape;
begin
   tags := tags + ('<r>');
   Result := Self;
end;

procedure TShapeHelper.Texto(Text: String; FontSize: Real);
var
   Arr,ArrFont,ArrReplace :TArray<string>;
   fontReplace,
   colorReplace :String;
   I  : Integer;
   T,T2  : TText;
   FL  : TFlowLayout;
   L,FFundo  : TLayout;
   Font, Criar : Boolean;
   FSize  : Integer;
begin
   if Text <> '' then begin

      Font := False;

      Text := Trim(Text.Replace('  ',' ').Replace(#$D#$A,' <br>'));

      Self.BeginUpdate;
      Self.HitTest := True;
      for I := Self.ComponentCount - 1  downto 0 do
        if  (Self.Components[i] is TLayout) and ((Self.Components[i] as TLayout).Tag = 0) then
           Self.Components[i].DisposeOf;

      FL := TFlowLayout.Create(Self);
      FL.Align := TAlignLayout.Client;
      FL.HitTest := False;
      Arr := TRegEx.Split(text,' ');
      for i := 0 to TRegEx.Matches(text,' ').Count do begin

         FontReplace := '';
         if AnsiContainsText(arr[i],'<p>') then begin
            L := TLayout.Create(FL);
            L.Width := 2000;
            L.Height := 16;
            Fl.AddObject(L);
         end;

         if AnsiContainsText(arr[i],'<br>') then begin
            L := TLayout.Create(FL);
            L.Width := 2000;
            L.Height := 2;
            Fl.AddObject(L);
         end;

         T := TText.Create(FL);
         T.Text := arr[i];

         if Self.Fill.Color = TAlphaColors.White then
            T.TextSettings.FontColor := TAlphaColors.Black
         else
            T.TextSettings.FontColor := TAlphaColors.White;

         T.TextSettings.Font.Size := FontSize ;
         T.AutoSize := True;
         T.HitTest := True;

         T.TextSettings.Font.Style := [];

         if AnsiContainsText(arr[i],'<b>') then begin
            T.TextSettings.Font.Style := T.TextSettings.Font.Style + [TFontStyle.fsBold];
         end;

         if AnsiContainsText(arr[i],'<i>') then
            T.TextSettings.Font.Style := T.TextSettings.Font.Style + [TFontStyle.fsItalic];

         if AnsiContainsText(arr[i],'<s>') then
            T.TextSettings.Font.Style := T.TextSettings.Font.Style + [TFontStyle.fsUnderline];

         if AnsiContainsText(arr[i],'<r>') then
            T.TextSettings.Font.Style := T.TextSettings.Font.Style + [TFontStyle.fsStrikeOut];

         if AnsiContainsText(arr[i],'www.') then begin
            T.TextSettings.FontColor := TAlphaColors.Steelblue;
            T.Cursor := crHandPoint;
            T.OnClick := ClickURL;
         end;

         if AnsiContainsText(arr[i],'<red>') then
            T.TextSettings.FontColor := TAlphaColors.Red
         else if AnsiContainsText(arr[i],'<green>') then
            T.TextSettings.FontColor := TAlphaColors.Green
         else if AnsiContainsText(arr[i],'<white>') then
            T.TextSettings.FontColor := TAlphaColors.White
         else if AnsiContainsText(arr[i],'<black>') then
            T.TextSettings.FontColor := TAlphaColors.Black
         else if AnsiContainsText(arr[i],'<yellow>') then
            T.TextSettings.FontColor := TAlphaColors.Yellow
         else if AnsiContainsText(arr[i],'<Darkslategray>') then
            T.TextSettings.FontColor := TAlphaColors.Darkslategray             
         else if AnsiContainsText(arr[i],'<blue>') then
            T.TextSettings.FontColor := TAlphaColors.Cornflowerblue; 

         if AnsiContainsText(arr[i],'<cor=') then begin
            Font := True;
            ArrFont := TRegEx.Split(arr[i],'<cor=');
            ArrReplace := TRegEx.Split(ArrFont[1],'>');
            T.TextSettings.FontColor := StrToInt(ArrReplace[0]);
            colorReplace := '<cor='+(ArrReplace[0])+'>';
         end;

         if AnsiContainsText(arr[i],'<font=') then begin
            Font := True;
            ArrFont := TRegEx.Split(arr[i],'<font=');
            ArrReplace := TRegEx.Split(ArrFont[1],'>');
            fontReplace := '<font='+(ArrReplace[0])+'>';
            FSize := StrToInt(ArrReplace[0]);
         end;

         if Font then
            T.TextSettings.Font.Size := FSize;;

         if AnsiContainsText(arr[i],'</font>') then
            Font := False;

         T.Height := 28;
         T.Width := 500;

         T.Text := arr[i]
                   .Replace('<red>','')
                   .Replace('<yellow>','')
                   .Replace('<blue>','')
                   .Replace('<green>','')
                   .Replace('<r>','')
                   .Replace('<s>','')
                   .Replace('<b>','')
                   .Replace('<i>','')
                   .Replace('<br>','')
                   .Replace('<p>','')
                   .Replace(fontReplace,'')
                   .Replace('</font>','');

         T.TextSettings.HorzAlign := TTextAlign.Center;
         T.TextSettings.VertAlign := TTextAlign.Trailing;
         if T.Text <> '' then
            FL.AddObject(T);
      end;

      FL.EndUpdate;
      Self.AddObject(FL);
      Self.EndUpdate;
   end;
end;

function TShapeHelper.Underline: TShape;
begin
   tags := tags + ('<s>');
   Result := Self;
end;

end.
