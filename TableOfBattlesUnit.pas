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
        Cells[0, 0] := '� ';
        Cells[1, 0] := '����� 1';
        Cells[2, 0] := '����� 2';
        Cells[3, 0] := '����� ����';
        Cells[4, 0] := '���� ������ 1';
        Cells[5, 0] := '���� ������ 2';
        Cells[6, 0] := '����������';
    End;
end;


Function CalcTotalTime(Time:Cardinal):String;
var
    Sec,Min:String;
begin
    Min:=IntToStr((Time) Div 1000 Div 60) + ' ���. ';
    Sec:=  IntToStr((Time) Div 1000 Mod 60) + ' ���.';
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
    //������ ������� ������� ���������� ��������, ������������ �� �����������
    TableForm.StringGrid1.ColWidths[0] := 40;
    TableForm.StringGrid1.ColWidths[1] := 180;
    TableForm.StringGrid1.ColWidths[2] :=90;
    TableForm.StringGrid1.ColWidths[3] := 100;
    TableForm.StringGrid1.ColWidths[6] := 180;
    //�������� ���� � ����������, ��� ��������� ���������
    Path := ExtractFileDir(Application.ExeName);
    //������� ��������� ������ � ���� ������
    TempList:=TFightsList.Create;
    //��������� ������ ���������� �� �����
    TempList:=TFightsList.GetFightsListFromFile(Path+'\fights.tof');
    //������ ���������� ����� � �������, ��������� �������� Count ������ TempList
    ListCount:=TempList.Count;
    TableForm.StringGrid1.RowCount := ListCount + 1;
    //�������� ��������� �� ������ ������� ������
    TempNode:=TempList.Head;
    //������ ����� ��� ��������� ����� � �������
    I:=1;
    //���� ���������� �� ����� ������ �� ��������, ��������� ������� ������� �� ����
    While TempNode <> NIL Do
    Begin
    //�������� �������������� ����� �������� ������
        TempLineAboutFight := TempNode^.LineAboutFight;
    //������ ���������� ��� �� �������� � ������������� �� ������ �������
        TableForm.StringGrid1.Cells[0, I] := IntTOStr(I);
        TableForm.StringGrid1.Cells[1, I] := TempLineAboutFight.PlayerName1;
        TableForm.StringGrid1.Cells[2, I] := TempLineAboutFight.PlayerName2;
    //������� ������� �� ���������� � ���: ������ � �������
        TableForm.StringGrid1.Cells[3, I] := CalcTotalTime(TempLineAboutFight.Time);
        TableForm.StringGrid1.Cells[4, I] := TempLineAboutFight.Pl1FleetLosses+'%';
        TableForm.StringGrid1.Cells[5, I] := TempLineAboutFight.Pl2FleetLosses+'%';
    //������ ����������
        TableForm.StringGrid1.Cells[6, I] := TempLineAboutFight.Winner;
    //���������� �������� � ������� � ���������� �������� ������
        Inc(I);
        TempNode := TempNode^.Next;
    End;

End;

procedure TTableForm.FormShow(Sender: TObject);
begin
   LoadInfoInTable();
end;
end.
