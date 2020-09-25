unit uMain;

interface

uses
  System.Generics.Collections,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Ani, FMX.Objects, FMX.TabControl,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.ImageList,
  FMX.ImgList, FMX.ScrollBox, FMX.Memo, FMX.Effects, FMX.ListBox;

type
  TFormMain = class(TForm)
    VertScrollBox1: TVertScrollBox;
    FloatAnimation1: TFloatAnimation;
    Rectangle1: TRectangle;
    Lista: TFDMemTable;
    ListaID: TIntegerField;
    ListaTitulo: TStringField;
    ListaDescricao: TStringField;
    ListaSubTitulo: TStringField;
    ListaValor: TCurrencyField;
    Imagens: TImageList;
    Rectangle2: TRectangle;
    GridPanelLayout1: TGridPanelLayout;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    SpeedButton10: TSpeedButton;
    Text1: TText;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RClick(Sender: TObject);
    procedure FloatAnimation1Finish(Sender: TObject);
    procedure FloatAnimation2Finish(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure LimpaLista;

  private
    { Private declarations }
  public
    { Public declarations }
     ListAnimationX,ListAnimationY :TObjectList<TFloatAnimation>;
     ListRectangle :TObjectList<TShape>;
     procedure Card(var MemTable :TFDMemTable;var Vert:TVertScrollBox;
       Modelo: Integer);
  end;

var
  FormMain: TFormMain;
  showLista :Boolean;

implementation

{$R *.fmx}

uses Lista.Helpers;

procedure TFormMain.Card(var MemTable :TFDMemTable;var Vert:TVertScrollBox;
       Modelo: Integer);
var
   R :TRoundRect;
   FX,FY :TFloatAnimation;
   I :Integer;
begin

   ListAnimationX.Clear;
   ListAnimationY.Clear;
   ListRectangle.Clear;

   MemTable.First;
   while not MemTable.Eof do begin
      I := MemTable.RecNo-1;

      R := TRoundRect.Create(Vert);
      R.Fill.Color := TAlphaColors.White;
      R.Stroke.Color := TAlphaColors.Darkgray;
      R.Height := 100;
      R.Tag := I;
      R.Width := Vert.Width - 5;
      R.OnClick := RClick;
      R.Position.X := (Vert.Width + 10) * I;
      R.Sombrear;
      R.Corners := [];

      if Modelo = 0 then begin

      end else if Modelo = 1 then begin

      end else if Modelo = 2 then begin

      end else if Modelo = 3 then begin

      end else if Modelo = 4 then begin

      end else if Modelo = 5 then begin

      end else if Modelo = 6 then begin

      end else if Modelo = 7 then begin

      end else if Modelo = 8 then begin

      end else if Modelo = 9 then begin

      end;

      R.Position.Y := I * (R.Height + 4);

      Vert.AddObject(R);

      FX := TFloatAnimation.Create(R);
      FX.Delay := I/100;
      FX.Duration := 0.1 * (I+1);
      FX.PropertyName := 'Position.X';
      FX.StartFromCurrent := True;
      FX.StopValue := 0;
      FX.OnFinish := FloatAnimation1Finish;
      FX.Tag := I;

      R.AddObject(FX);
      ListAnimationX.Add(FX);

      FY := TFloatAnimation.Create(R);
      FY.Delay := I /100;
      FY.Duration := 0.1 * (i+1);
      FY.PropertyName := 'Position.Y';
      FY.Interpolation := TInterpolationType.Back;
      FY.StartFromCurrent := True;
      FY.StopValue := R.Position.Y - (R.Height + 4);
      FY.Tag := i;
      FY.OnFinish := FloatAnimation2Finish;

      R.AddObject(FY);
      ListAnimationY.Add(FY);
      ListRectangle.Add(R);

      FX.Start;
      MemTable.Next;
   end;


end;

procedure TFormMain.FloatAnimation1Finish(Sender: TObject);
var
   I :Integer;
begin
   if TFloatAnimation(Sender).StopValue > 0 then begin
      for I := TFloatAnimation(Sender).Tag + 1 to ListAnimationY.Count - 1 do
         ListAnimationY.Items[I].Start;
   end;
end;

procedure TFormMain.FloatAnimation2Finish(Sender: TObject);
begin
   ListAnimationY.Items[TFloatAnimation(Sender).Tag].StopValue :=
   ListRectangle.Items[TFloatAnimation(Sender).Tag].Position.Y - (ListRectangle.Items[TFloatAnimation(Sender).Tag].Height + 4);
end;

procedure TFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   ListAnimationX.DisposeOf;
   ListAnimationY.DisposeOf;
   ListRectangle.DisposeOf;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
   ListAnimationX := TObjectList<TFloatAnimation>.Create;
   ListAnimationY := TObjectList<TFloatAnimation>.Create;
   ListRectangle := TObjectList<TShape>.Create;

   Lista.Open;
   Lista.AppendRecord([1,'Hamburguer','Lanches','Carne bovina, alface, tomate, cebola, catchup, maionese',12.9]);
   Lista.AppendRecord([2,'Cachorro Quente','Lanches','Salsicha, batata palha, milho, maionese',12.9]);
   Lista.AppendRecord([3,'X-Burguer','Lanches','Carne bovina, queijo, tomate, cebola, catchup, alface, maionese',12.9]);
   Lista.AppendRecord([4,'X-Bacon','Lanches','Carne bovina, bacon, queijo, tomate, cebola, catchup, alface, maionese',12.9]);
   Lista.AppendRecord([5,'Calabresa','Pizzas','Calabresa, queijo, tomate, cebola, azeitona,orégano',29.9]);

end;

procedure TFormMain.LimpaLista;
var I :Integer;
begin
   for I := 0 to ListAnimationX.Count -1 do begin
      ListAnimationX.Items[i].StopValue := VertScrollBox1.Width + 10;
      ListAnimationX.Items[i].Start;
   end;
end;

procedure TFormMain.RClick(Sender: TObject);
begin
   ListAnimationX.Items[TRectangle(Sender).tag].Duration := 0.1;
   ListAnimationX.Items[TRectangle(Sender).tag].Delay := 0;
   ListAnimationX.Items[TRectangle(Sender).tag].StopValue := VertScrollBox1.Width + 10;
   ListAnimationX.Items[TRectangle(Sender).tag].Start;
end;

procedure TFormMain.SpeedButton1Click(Sender: TObject);
begin
   if showLista then
      LimpaLista
   else
      card(Lista,VertScrollBox1, TSpeedButton(Sender).tag);

   showLista := not showLista;

end;

end.
