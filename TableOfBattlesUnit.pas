unit TableOfBattlesUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, ListUnit, Vcl.StdCtrls,
  Vcl.ExtCtrls;

type
  TTableForm = class(TForm)
    StringGrid1: TStringGrid;
    Image1: TImage;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TableForm: TTableForm;

implementation

{$R *.dfm}



procedure TTableForm.FormCreate(Sender: TObject);
begin
BorderIcons := BorderIcons - [BiMaximize] + [BiHelp];
    BorderStyle := BsSingle;
    Position := PoDesktopCenter;
With StringGrid1 Do
    Begin
        Cells[0, 0] := '№ ';
        Cells[1, 0] := 'Игрок 1';
        Cells[2, 0] := 'Игрок 2';
        Cells[3, 0] := 'Время игры';
        Cells[4, 0] := 'Флот игрока 1';
        Cells[5, 0] := 'Флот игрока 2';
        Cells[6, 0] := 'Победитель';
    End;
end;


Function CalcTotalTime(Time:Cardinal):String;
var
    Sec,Min:String;
begin
    Min:=IntToStr((Time) Div 1000 Div 60) + ' мин. ';
    Sec:=  IntToStr((Time) Div 1000 Mod 60) + ' сек.';
    CalcTotalTime:=Min+Sec;
end;

Procedure LoadInfoInTable();
Var
    TempNode: PLineAboutFight;
    Path:String;
    ListCount,I: Integer;
    TempList: TFightsList;
    TempRecord,TempLineAboutFight: TRecordLineAboutFight;
Begin
    //Задать ячейкам таблицы определённы значения, отличающиеся от стандартных
    TableForm.StringGrid1.ColWidths[0] := 40;
    TableForm.StringGrid1.ColWidths[1] := 180;
    TableForm.StringGrid1.ColWidths[2] :=90;
    TableForm.StringGrid1.ColWidths[3] := 100;
    TableForm.StringGrid1.ColWidths[6] := 180;
    //Получить путь к директории, где находится программа
    Path := ExtractFileDir(Application.ExeName);
    //Создать экземпляр класса в виде списка
    TempList:=TFightsList.Create;
    //Заполнить список значениями из файла
    TempList:=TFightsList.GetFightsListFromFile(Path+'\fights.tof');
    //Задать количество строк в таблице, используя свойство Count списка TempList
    ListCount:=TempList.Count;
    TableForm.StringGrid1.RowCount := ListCount + 1;
    //Получить указатель на первый элемент списка
    TempNode:=TempList.Head;
    //Задать число для нумерации строк в таблице
    I:=1;
    //Пока полученный из файла список не кончился, заполнять таблицу данными из него
    While TempNode <> NIL Do
    Begin
    //Получить информационную часть элемента списка
        TempLineAboutFight := TempNode^.LineAboutFight;
    //Запись информации имён из элемента в соответвующие ей ячейки таблицы
        TableForm.StringGrid1.Cells[0, I] := IntTOStr(I);
        TableForm.StringGrid1.Cells[1, I] := TempLineAboutFight.PlayerName1;
        TableForm.StringGrid1.Cells[2, I] := TempLineAboutFight.PlayerName2;
    //Перевод времени из миллисекуд в вид: минуты и секунды
        TableForm.StringGrid1.Cells[3, I] := CalcTotalTime(TempLineAboutFight.Time);
        TableForm.StringGrid1.Cells[4, I] := TempLineAboutFight.Pl1FleetLosses+'%';
        TableForm.StringGrid1.Cells[5, I] := TempLineAboutFight.Pl2FleetLosses+'%';
    //Запись победителя
        TableForm.StringGrid1.Cells[6, I] := TempLineAboutFight.Winner;
    //Увеличение счётчика и переход к следующему элементу списка
        Inc(I);
        TempNode := TempNode^.Next;
    End;

End;

procedure TTableForm.FormShow(Sender: TObject);
begin
   LoadInfoInTable();
end;
end.
