Unit ListUnit;

Interface

Uses System.SysUtils, Vcl.Dialogs;

Type
    PLineAboutFight = ^TNode;

    TRecordLineAboutFight = Record
        PlayerName1, PlayerName2, Winner: String[20];
        Pl1FleetLosses, Pl2FleetLosses: String[5];
        Time: Cardinal;
    End;

    TNode = Record
        LineAboutFight: TRecordLineAboutFight;
        Next: PLineAboutFight;
    End;

    TFightsList = Class
        Head: PLineAboutFight;
        Tail: PLineAboutFight;
        Count: Integer;
    Public
        Constructor Create();
        Procedure AddNewLineAboutFight(LineAboutFight: TRecordLineAboutFight);
        Procedure SaveFightsList(FilePath: String);
        Class Function GetFightsListFromFile(FilePath: String): TFightsList;
    End;

Implementation

Constructor TFightsList.Create;
Begin
    Self.Head := NIL;
    Self.Tail := NIL;
    Count := 0;
End;

Procedure TFightsList.AddNewLineAboutFight(LineAboutFight
  : TRecordLineAboutFight);
Var
    NewLineAboutFight: PLineAboutFight;
Begin
    // Выделение памяти для нового элемента списка
    New(NewLineAboutFight);
    // Присвоение информационному полю элемента списка записи о бое
    NewLineAboutFight^.LineAboutFight := LineAboutFight;
    // Обновления указателя на слеюущий элемент
    NewLineAboutFight^.Next := NIL;
    // Если нет ни одного элемента в списке
    If Head = NIL Then
    Begin
        // Инициализация первого и последнего элемента новым элементом, созданным выше
        Head := NewLineAboutFight;
        Tail := NewLineAboutFight;
    End
    // Если список не пустой
    Else
    // Добавить в конец списка новый элемент
    Begin
        Tail^.Next := NewLineAboutFight;
        Tail := NewLineAboutFight;
    End;
    // Увеличить общую длину списка
    Inc(Count);
End;

Procedure TFightsList.SaveFightsList(FilePath: String);
Var
    FileFightsList: File Of TRecordLineAboutFight;
    TempList: PLineAboutFight;
    TempLineAboutFight: TRecordLineAboutFight;
Begin
    //Получить указатель на первый элемент списка
    TempList := Self.Head;
    //Назначить переменной файлового типа путь к файлу
    AssignFile(FileFightsList, FilePath);
    //Перезаписать файл
    Rewrite(FileFightsList);
    //Пока список не кончился
    While TempList <> NIL Do
    Begin
    //Перейти к следующему элементу списка
        TempLineAboutFight := TempList^.LineAboutFight;
    //Записать элемент в файл
        Write(FileFightsList, TempLineAboutFight);
    //Назначить следующий
        TempList := TempList^.Next;
    End;
    //Закрыть файл
    CloseFile(FileFightsList);
End;

Class Function TFightsList.GetFightsListFromFile(FilePath: String): TFightsList;
Var
    F: File Of TRecordLineAboutFight;
    TempRecord: TRecordLineAboutFight;
    TempLineAboutFight: TRecordLineAboutFight;
    List: TFightsList;
Begin
    // Создание нового списка как экземпляр класса
    List := TFightsList.Create;
    // Назначение переменной пути файла
    AssignFile(F, FilePath);
    Try
        // Если файла не существует
        If (Not(FileExists(FilePath))) Then
        Begin
            // То создать его
            Rewrite(F);
        End
        Else
        Begin
            // Открыть выбраный файл
            Reset(F);
        End;
        Try
            // Если файл не пустой
            If FileSize(F) <> 0 Then
            Begin
                While (Not Eof(F)) Do
                Begin
                    // Прочитать очередную запись о бое и записать её в список боёв
                    Read(F, TempRecord);
                    List.AddNewLineAboutFight(TempRecord);
                End;
            End;
        Except
            MessageDlg('Confirmation', MtError, MbOKCancel, 0);

        End;
    Finally
        CloseFile(F);
        // Возвратить созданный список
        Result := List;
    End;

End;

End.
