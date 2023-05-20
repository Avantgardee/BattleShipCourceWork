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
    // ��������� ������ ��� ������ �������� ������
    New(NewLineAboutFight);
    // ���������� ��������������� ���� �������� ������ ������ � ���
    NewLineAboutFight^.LineAboutFight := LineAboutFight;
    // ���������� ��������� �� �������� �������
    NewLineAboutFight^.Next := NIL;
    // ���� ��� �� ������ �������� � ������
    If Head = NIL Then
    Begin
        // ������������� ������� � ���������� �������� ����� ���������, ��������� ����
        Head := NewLineAboutFight;
        Tail := NewLineAboutFight;
    End
    // ���� ������ �� ������
    Else
    // �������� � ����� ������ ����� �������
    Begin
        Tail^.Next := NewLineAboutFight;
        Tail := NewLineAboutFight;
    End;
    // ��������� ����� ����� ������
    Inc(Count);
End;

Procedure TFightsList.SaveFightsList(FilePath: String);
Var
    FileFightsList: File Of TRecordLineAboutFight;
    TempList: PLineAboutFight;
    TempLineAboutFight: TRecordLineAboutFight;
Begin
    //�������� ��������� �� ������ ������� ������
    TempList := Self.Head;
    //��������� ���������� ��������� ���� ���� � �����
    AssignFile(FileFightsList, FilePath);
    //������������ ����
    Rewrite(FileFightsList);
    //���� ������ �� ��������
    While TempList <> NIL Do
    Begin
    //������� � ���������� �������� ������
        TempLineAboutFight := TempList^.LineAboutFight;
    //�������� ������� � ����
        Write(FileFightsList, TempLineAboutFight);
    //��������� ���������
        TempList := TempList^.Next;
    End;
    //������� ����
    CloseFile(FileFightsList);
End;

Class Function TFightsList.GetFightsListFromFile(FilePath: String): TFightsList;
Var
    F: File Of TRecordLineAboutFight;
    TempRecord: TRecordLineAboutFight;
    TempLineAboutFight: TRecordLineAboutFight;
    List: TFightsList;
Begin
    // �������� ������ ������ ��� ��������� ������
    List := TFightsList.Create;
    // ���������� ���������� ���� �����
    AssignFile(F, FilePath);
    Try
        // ���� ����� �� ����������
        If (Not(FileExists(FilePath))) Then
        Begin
            // �� ������� ���
            Rewrite(F);
        End
        Else
        Begin
            // ������� �������� ����
            Reset(F);
        End;
        Try
            // ���� ���� �� ������
            If FileSize(F) <> 0 Then
            Begin
                While (Not Eof(F)) Do
                Begin
                    // ��������� ��������� ������ � ��� � �������� � � ������ ���
                    Read(F, TempRecord);
                    List.AddNewLineAboutFight(TempRecord);
                End;
            End;
        Except
            MessageDlg('Confirmation', MtError, MbOKCancel, 0);

        End;
    Finally
        CloseFile(F);
        // ���������� ��������� ������
        Result := List;
    End;

End;

End.
