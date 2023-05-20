Unit BattleShipUnit;

Interface

Uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
    System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, UnitSound,
    Vcl.Menus, Vcl.ActnMan, Vcl.ActnColorMaps, Vcl.ComCtrls, ListUnit;

Type

    TMap = Array [0 .. 9, 0 .. 9] Of Integer;

    TCoordinates = Array [1 .. 2] Of Integer;

    TArrOfPossibleShots = Array [1 .. 4, 1 .. 2] Of Integer;

    TShot = Array [1 .. 2] Of Integer;

    TShipData = Record
        StartOfShip, EndOfShip: TCoordinates;
        LifeDecks: Integer;
    End;

    TCoordinatesArr = Array [1 .. 10] Of TShipData;

    TPlayer = Record
        AllShips: TCoordinatesArr;
        OwnMap: TMap;
        Name: ShortString;
    End;

    TFileRecord = Record
        Player1: TPlayer;
        Player2: TPlayer;
        Time: Cardinal;
    End;

    TBattleForm = Class(TForm)
        Timer1: TTimer;
        MainMenu1: TMainMenu;
        N1: TMenuItem;
        N2: TMenuItem;
        StaticText1: TStaticText;
        StaticText2: TStaticText;
        N3: TMenuItem;
        StaticText3: TStaticText;
        StaticText4: TStaticText;
        Panel1: TPanel;
        RichEdit1: TRichEdit;
        N4: TMenuItem;
        N5: TMenuItem;
        N6: TMenuItem;
        SaveFile: TSaveDialog;
        SaveGame: TSaveDialog;
        Procedure FormCreate(Sender: TObject);
        Procedure Timer1Timer(Sender: TObject);
        Procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
          Shift: TShiftState; X, Y: Integer);
        Procedure N2Click(Sender: TObject);
        Procedure N3Click(Sender: TObject);
        Procedure FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
        Procedure N6Click(Sender: TObject);
        Procedure N5Click(Sender: TObject);
        Procedure N1Click(Sender: TObject);
        Procedure N4Click(Sender: TObject);
        Procedure FormKeyDown(Sender: TObject; Var Key: Word;
          Shift: TShiftState);
        Procedure FormShow(Sender: TObject);

    Private
        Img: Array [0 .. 4] Of TBitmap; // ����������� ������
        ImgForStat: Array [1 .. 2] Of TBitmap;
        ImgForLetter: Array [0 .. 9] Of TBitmap;
        ImgForNum: Array [0 .. 9] Of TBitmap;
        Current, ShootingMode, ShotNum: Integer; // ������� �����
        PossibleShots: TArrOfPossibleShots;
        NextShot, StartOfShooting, EndOfShooting: TShot;
        ShipOrientation: Integer;
        TimeOfStartGame: Longint;
        IsHatching: Boolean;
        Path, Pl1FleetLosses, Pl2FleetLosses: String;
        WaterShotS, SetShipS, ShotS, ButtonS: TSound;

        CountOfShips: Integer;

        Buf: TBitmap; // ����. �����
        Procedure InitializationResource();
        Procedure OutInformationAboutGamer();
        Procedure Bot�orrection();
        Procedure DrawLettersAndNum(I: Integer);
        Procedure DrawMaterials();
        Procedure DrawFleetLine(StartShip, EndShip, CountOfDecks: Integer;
          LocOfShips: TCoordinatesArr; RightOffset: Integer);
        Procedure DrawAllFleet(Gamer: String; CoorArrOfPlayer: TCoordinatesArr);
        Function IsMapHasShips(MapOfShips: TMap): Boolean;
        Procedure ShadeDeadShips(Var ArrOfShipsCoor: TCoordinatesArr;
          Var MapForShade: TMap);
        Procedure Delay(Ms: Longint);
        Procedure SetPossibleShots(I, J: Integer);
        Procedure ReverseOrientation();
        Function CalcLifeDecks(CoorArrOfPlayer: TCoordinatesArr): Integer;
        Procedure CreateInfoAboutGameOver(Status: Boolean);
        Procedure ShadeMaps();
        Procedure SaveLogToFile(Path: String);
        Procedure SaveGameState(Path: String);
        Procedure UpdateTabbleOfBattles(WinnerName: String);

    Public
        PlayersShips, OpponentShips: TCoordinatesArr;
        PlayerMap, OpponentMap: TMap;
        Name1, Name2: String;
        Mode: Integer;
        AddTime: Cardinal;

    End;

Var
    BattleForm: TBattleForm;

Implementation

{$R *.dfm}

Uses MainMenuUnit, AddPlayerUnit;

Procedure TBattleForm.OutInformationAboutGamer();
Begin

    BattleForm.StaticText1.Caption := Name1;
    BattleForm.StaticText2.Caption := Name2;
End;

Procedure TBattleForm.Bot�orrection();
Var
    I, J: Integer;
Begin
    ShootingMode := 1;
    ShotNum := 0;
    For I := 1 To 4 Do
        For J := 1 To 2 Do
            PossibleShots[I, J] := -1;
    NextShot[1] := -1;
    NextShot[2] := -1;
    StartOfShooting[1] := -1;
    StartOfShooting[2] := -1;
    EndOfShooting[1] := -1;
    EndOfShooting[2] := -1;
End;

Procedure TBattleForm.InitializationResource();
Var
    I, J: Integer;
Begin
    Path := ExtractFileDir(Application.ExeName);
    Buf := TBitmap.Create;
    Buf.Width := 1000;
    Buf.Height := 1000;
    Try
        For I := 0 To 4 Do
        Begin
            Img[I] := TBitmap.Create;
            If I = 1 Then
            Begin
                Img[I].TransparentColor := ClBlue;
                Img[I].Transparent := True;
            End;
            Img[I].LoadFromFile(Path + '\imagesForGame\' + IntToStr(I)
              + '.bmp');
        End;

        For I := 1 To 2 Do
        Begin
            ImgForStat[I] := TBitmap.Create;
            ImgForStat[I].LoadFromFile(Path + '\imagesForGame\' +
              IntToStr(I + 6) + '.bmp');
        End;
        For I := 0 To 9 Do
        Begin
            ImgForLetter[I] := TBitmap.Create;
            ImgForLetter[I].LoadFromFile(Path + '\imagesForGame\retroalphabet\'
              + IntToStr(I + 1) + '.bmp');
            ImgForNum[I] := TBitmap.Create;
            ImgForNum[I].LoadFromFile(Path + '\imagesForGame\retroalphabet\' +
              IntToStr(I + 11) + '.bmp');
        End;

        For I := 0 To 9 Do
            For J := 0 To 9 Do
            Begin
                PlayerMap[I, J] := 0;
                OpponentMap[I, J] := 0;
            End;
        ShotS := TSound.Create('shot.wav');
        WaterShotS := TSound.Create('watershot.wav');
        SetShipS := TSound.Create('setship.wav');
        ButtonS := TSound.Create('button.wav');
    Except
        MessageBox(BattleForm.Handle,
          '������ �������� ������ ��� ����, ��������� ������������ ���������',
          '��������������!', MB_OK + MB_ICONWARNING);
        Application.Terminate;
    End;

    Mode := 0; // ����� �����������
    CountOfShips := 1;
    ShipOrientation := 1; // ������������ ���������
    Current := 0;
    IsHatching := True;
    Name2 := '���������';
    Bot�orrection();
    AddTime := 0;
End;

Procedure TBattleForm.FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
Begin
    CanClose := Application.MessageBox('�� �������, ��� ������ ����� �� ���?' +
      #10#13 + '��� ������������� ������ ����� �������.', '�����?',
      MB_YESNO + MB_ICONINFORMATION) = IdYES;
    If CanClose Then
    Begin
        AddShipsForm.ClearUsersShips(PlayerMap, OpponentMap, PlayersShips,
          OpponentShips);
        Mode := 2;
        AddShipsForm.UpdateStas(AddPlayerUnit.PlayersShips);
        AddShipsForm.ClearUsersShips(AddPlayerUnit.PlayerMap,
          AddPlayerUnit.OpponentMap, AddPlayerUnit.PlayersShips,
          AddPlayerUnit.OpponentShips);
        Bot�orrection();
        AddShipsForm.UpdateStas(PlayersShips);
        AddTime := 0;
        RichEdit1.Text := '';
        MenuForm.Show;
    End;
End;

Procedure TBattleForm.FormCreate(Sender: TObject);
Begin
    InitializationResource();
    SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) OR
      WS_EX_APPWINDOW);

End;

Procedure TBattleForm.FormKeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
    If Key = VK_ESCAPE Then
        Close;
End;

Function TBattleForm.IsMapHasShips(MapOfShips: TMap): Boolean;
Var
    I, J: Integer;
    IsHasShips: Boolean;
Begin
    IsHasShips := False;
    // ��������� ���������� �������� ����� ��� ����������� ��������
    For I := 0 To 9 Do
        For J := 0 To 9 Do
            If MapOfShips[I, J] = 3 Then
                // ���� �� ����� ���� ���� ���� ������ ����������� �������, �� ������� ����
                IsHasShips := True;
    IsMapHasShips := IsHasShips;
End;

Procedure TBattleForm.DrawLettersAndNum(I: Integer);
Begin
    Buf.Canvas.Draw(I * 32 + 32, 0, ImgForLetter[I]);
    Buf.Canvas.Draw(0, I * 32 + 32, ImgForNum[I]);
    Buf.Canvas.Draw(I * 32 + 32 + 500, 0, ImgForLetter[I]);
    Buf.Canvas.Draw(500, I * 32 + 32, ImgForNum[I]);
End;

Procedure TBattleForm.DrawMaterials();
Var
    I, J: Integer;
Begin
    Buf.Canvas.Brush.Color := ClWhite; // ���������� ������ ����� ����
    Buf.Canvas.Pen.Style := PsClear; // ���������� �������
    Buf.Canvas.Rectangle(0, 0, 1000, 600);
    // ���������� �������������� � ��������� ���������� � �������
    For I := 0 To 9 Do
    Begin
        DrawLettersAndNum(I); // ���������� ����� � �����
        For J := 0 To 9 Do
        Begin
            If PlayerMap[I, J] = 1 Then
                Buf.Canvas.Draw(I * 32 + 32, J * 32 + 32, Img[2]);

            Buf.Canvas.Draw(I * 32 + 32, J * 32 + 32, Img[PlayerMap[I, J]]);
            // ���������� ����� ���� ������ ��� ���������
            Case OpponentMap[I, J] Of // ���������� ����� ���� ����������
                0:
                    Buf.Canvas.Draw(I * 32 + 32 + 500, J * 32 + 32, Img[0]);
                // ���� � ������ 0 (���������� ������), �� ���������� �������� ����
                1:
                    Begin
                        Buf.Canvas.Draw(I * 32 + 32 + 500, J * 32 + 32, Img[2]);
                        // ���� � ������ 1 (������ �� ��������� "����"), �� ���������� �������� ���������
                        Buf.Canvas.Draw(I * 32 + 500 + 32, J * 32 + 32, Img[1]);
                        // � �������� �� ��������
                    End;
                2:
                    Buf.Canvas.Draw(I * 32 + 500 + 32, J * 32 + 32, Img[2]);
                // ���� � ������ 2 (������, ������� ���������� ������ ������ ��������)
                3:
                    Buf.Canvas.Draw(I * 32 + 500 + 32, J * 32 + 32, Img[0]);
                // ���� � ������ 3 (������ � �������), �� ���������� �������� ����
                4:
                    Buf.Canvas.Draw(I * 32 + 500 + 32, J * 32 + 32, Img[4]);
                // ���� � ������ 4 (������ � �������� �������), �� ���������� ��������� �������
            End;
            If (Mode = 2) And (OpponentMap[I, J] = 3) Then
                // ���� ����� ���� ���������� �� ��������� "���������",
                // �� ���������� ���������� �������� ����������
                Buf.Canvas.Draw(I * 32 + 32 + 500, J * 32 + 32, Img[3]);
        End;
    End;
End;

Procedure RichEdit_MoveTo(RichEdit: TRichEdit; LineNumber, CharNumber: Word);

Begin

    RichEdit.SelStart := RichEdit.Perform(EM_LINEINDEX, LineNumber, 0) +
      CharNumber;

End;

Procedure CreateStatusOfBattle(XShot, YShot: Integer; CurrentPlayer: String;
  StatusOfShot, IsKilled: Boolean);
Var
    LetterOfGun, I: AnsiChar;
Begin
    // ��������� ������� � RichEdit � �����
    RichEdit_MoveTo(BattleForm.RichEdit1, BattleForm.RichEdit1.CaretPos.Y, 0);

    // ���������� ����� �� RichEdit, ���� ����� �� �������
    Application.ProcessMessages;
    If BattleForm.Showing Then
        BattleForm.RichEdit1.SetFocus;
    // ������� ������ ����� ��� �����, ��������� ���� ������� ASCII
    For I := #192 To #201 Do
        If XShot + 1 = (Ord(I) - Ord(#192) + 1) Then
            LetterOfGun := I;
    // ���� ������� �������
    If StatusOfShot Then
    Begin
        // ���� ������� ������ �������
        If Not(IsKilled) Then
        Begin
            // ����� ����� �� ����������
            BattleForm.RichEdit1.SelAttributes.Color := RGB(183, 65, 14);
            // ���������� ��������� � ������ �����
            BattleForm.RichEdit1.Lines.Add
              (CurrentPlayer + ': ����� � ������� � ������: ' + '"' +
              LetterOfGun + '" - ' + IntToStr(YShot + 1) + #13#10);
            // �������� ���� �� �������
            BattleForm.RichEdit1.SelAttributes.Color := RGB(0, 0, 139);
        End
        // ���� ������� ���� �������
        Else
        Begin
            // ������� ���� �� �������
            BattleForm.RichEdit1.SelAttributes.Color := RGB(255, 36, 0);
            // ���������� ��������� � ������ �����
            BattleForm.RichEdit1.Lines.Add
              (CurrentPlayer + ': ���� �������, ��������� � ������: ' + '"' +
              LetterOfGun + '" - ' + IntToStr(YShot + 1) + #13#10);
            // �������� ���� �� �������
            BattleForm.RichEdit1.SelAttributes.Color := RGB(0, 0, 139);
        End
    End
    // ���� ����� ��������
    Else
    Begin
        // ������� �� ����� ����
        BattleForm.RichEdit1.SelAttributes.Color := RGB(0, 0, 139);
        // ���������� ��������� � ������ �����
        BattleForm.RichEdit1.Lines.Add(CurrentPlayer + ': �������� �� ������: '
          + '"' + LetterOfGun + '" - ' + IntToStr(YShot + 1) + #13#10);
    End;

End;

Procedure TBattleForm.ShadeDeadShips(Var ArrOfShipsCoor: TCoordinatesArr;
  Var MapForShade: TMap);
Var
    I, M, N, NumOfDecks: Integer;
Begin
    // ������� ���� �������� � ���������� ������� ��������
    For I := 1 To 10 Do
    Begin
        // ���� ����� ����� ���������� ������� ����� 0, �� ������������ ������������� ������� ������ �������,
        // ��������� ���������� ��������� � �������� ������
        If ArrOfShipsCoor[I].LifeDecks = 0 Then
        Begin
            For M := ArrOfShipsCoor[I].StartOfShip[1] - 1 To ArrOfShipsCoor[I]
              .EndOfShip[1] + 1 Do
                For N := ArrOfShipsCoor[I].StartOfShip[2] - 1 To ArrOfShipsCoor
                  [I].EndOfShip[2] + 1 Do
                    // �������� �� ��, �� ����� �� ���������� �� ������� �������, � ���� ������ � ���������� ������������
                    // ����� �������� "����", �� ��������� �� ����� 2 ��� ���������
                    If (M > -1) And (N > -1) And (M < 10) And (N < 10) And
                      (MapForShade[M, N] = 0) Then
                        MapForShade[M, N] := 2;
        End;
    End;
End;

Procedure TBattleForm.Delay(Ms: Longint);
Var
    TheTime: LongInt;
Begin
    BattleForm.Panel1.Color := RGB(0, 50, 0);
    BattleForm.Panel1.Caption := '����� ' + Name2;
    TheTime := GetTickCount + Ms;
    While GetTickCount < TheTime Do
        Application.ProcessMessages;
    BattleForm.Panel1.Color := RGB(34, 180, 34);
    BattleForm.Panel1.Caption := '����� ' + Name1;

End;

Function DefineShip(XOfShot, YOfShot: Integer; Var ArrOfCoor: TCoordinatesArr;
  IsShot: Boolean): Boolean;
Var
    I: Integer;
    IsFind, IsKilled: Boolean;
Begin
    I := 1; // ��������� ��������� �������� ��� ������
    IsFind := True;
    IsKilled := False;
    While (I < 11) And (IsFind) Do
    // ���� ���������� ������������� �������� ������ 11
    // � ������� � ������� ������������ �� ������
    Begin
        // ���� ���������� �������� �������� � ������ �������
        If (ArrOfCoor[I].StartOfShip[1] <= XOfShot) And
          (ArrOfCoor[I].EndOfShip[1] >= XOfShot) And
          (ArrOfCoor[I].StartOfShip[2] <= YOfShot) And
          (ArrOfCoor[I].EndOfShip[2] >= YOfShot) Then
        Begin
            // ���������� ���������� ���������� �����, � ����� �������� �� ��, �� ���� �� �������
            If IsShot Then
                Dec(ArrOfCoor[I].LifeDecks);
            If (ArrOfCoor[I].LifeDecks = 0) Then
                IsKilled := True;
            IsFind := False;
        End;
        Inc(I);
    End;
    DefineShip := IsKilled;
End;

Procedure TBattleForm.SetPossibleShots(I, J: Integer);
Begin
    // ������ ��������� ������ ��� �������� - �������
    PossibleShots[1, 1] := I;
    PossibleShots[1, 2] := J - 1;
    // ������ ��������� ������ ��� �������� - ������
    PossibleShots[2, 1] := I;
    PossibleShots[2, 2] := J + 1;
    // ������ ��������� ������ ��� �������� - ������
    PossibleShots[3, 1] := I + 1;
    PossibleShots[3, 2] := J;
    // ������ ��������� ������ ��� �������� - �����
    PossibleShots[4, 1] := I - 1;
    PossibleShots[4, 2] := J;
End;

Procedure TBattleForm.ShadeMaps();
Begin
    If IsHatching Then
    Begin
        ShadeDeadShips(OpponentShips, OpponentMap);
        ShadeDeadShips(PlayersShips, PlayerMap);
    End;
End;

Procedure TBattleForm.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Var
    I, J: Integer;
    NewShot, Status, IsShipKilled: Boolean;
Begin
    // ��������� ����� ��������� ������� �� ������
    Status := False;
    // ���� ����� ���� ������� �� "����"
    If Mode = 1 Then
    Begin
        // ���� ������������ ����� �� ���� ���������� �� ����� ��� ����
        If Current = 1 Then
        Begin
            ShowMessage('������ ��� ��������');
            Exit;
        End;
        // ���������� ������ �����, �� ������� ����� �����
        X := (X - 500) Div 32 - 1;
        Y := Y Div 32 - 1;
        // ���� ������� � ������ � �������
        If (X >= 0) And (Y >= 0) And (X <= 9) And (Y <= 9) And
          (OpponentMap[X, Y] = 3) Then
        Begin
            // �������� ���� ��������� �������
            Status := True;
            // ��������� �������� ��������� ������� ������ ������
            OpponentMap[X, Y] := 4;
            // ����������� ����, ����� ��� ������� (����� ��� ����)
            IsShipKilled := DefineShip(X, Y, OpponentShips, True);
            // �������� ��������� ��� ���� ���
            CreateStatusOfBattle(X, Y, Name1, Status, IsShipKilled);
            Current := 0;
            If (ShotS.Available) And (MenuForm.FIsSound) Then
                ShotS.PlayTrack;
            DrawMaterials();
            ShadeMaps();
        End;
        // ���� ����� ��������
        If (X >= 0) And (Y >= 0) And (X <= 9) And (Y <= 9) And
          (OpponentMap[X, Y] = 0) Then
        Begin
            // �������� ��������� ��� ���� ���
            Status := False;
            CreateStatusOfBattle(X, Y, Name1, Status, IsShipKilled);
            Current := 1;
            If WatershotS.Available And (MenuForm.FIsSound) Then
                WatershotS.PlayTrack;
            // ��������� �������� ������� ������ ������
            OpponentMap[X, Y] := 1;
            // ������������ ����� ��� �������� ����������
            NewShot := False;
            DrawMaterials();
            // ��������, ��� ���� ����� ��������� �� ����� ���������
            Delay(900);
            // ���� ���� ����������� ����
            While Not(NewShot) And IsMapHasShips(PlayerMap) Do
            Begin
                // ����������� ����� ���������� �� "��������� ��������"
                If ShootingMode = 1 Then
                Begin
                    I := Random(10);
                    J := Random(10);
                End;
                // ���� ������� ���������� ���������
                If (ShootingMode = 1) And (PlayerMap[I, J] = 0) Then
                Begin
                    // �������� ��������� ��� ����
                    Status := False;
                    CreateStatusOfBattle(I, J, Name2, Status, IsShipKilled);
                    Current := 0;
                    // ���������� ������ ����� �������� "������" � ������������ �����
                    PlayerMap[I, J] := 1;
                    DrawMaterials();
                    NewShot := True;
                    ShadeMaps();
                End;
                If (ShootingMode = 1) And (PlayerMap[I, J] = 3) Then
                Begin
                    Status := True;
                    PlayerMap[I, J] := 4;
                    IsShipKilled := DefineShip(I, J, PlayersShips, True);
                    If Not(IsShipKilled) Then
                    Begin
                        ShootingMode := 2;
                        ShotNum := 1;
                        SetPossibleShots(I, J);
                        NextShot[1] := PossibleShots[ShotNum, 1];
                        NextShot[2] := PossibleShots[ShotNum, 2];
                        StartOfShooting[1] := I;
                        StartOfShooting[2] := J;
                    End;
                    CreateStatusOfBattle(I, J, Name2, Status, IsShipKilled);
                    Current := 1;
                    DrawMaterials();
                    Delay(800);
                    ShadeMaps();
                End;

                If Not(((NextShot[1] > -1) And (NextShot[2] > -1)) And
                  ((NextShot[1] < 10) And (NextShot[2] < 10))) And
                  (ShootingMode = 2) Then
                Begin
                    Inc(ShotNum);
                    If ShotNum = 5 Then
                    Begin
                        ShotNum := 0;
                        ShootingMode := 1;
                        If Not(DefineShip(EndOfShooting[1], EndOfShooting[2],
                          PlayersShips, False)) Then
                        Begin
                            ShootingMode := 2;
                            ShotNum := 1;
                            SetPossibleShots(StartOfShooting[1],
                              StartOfShooting[2]);
                            NewShot := True;
                        End;
                    End;
                    NextShot[1] := PossibleShots[ShotNum, 1];
                    NextShot[2] := PossibleShots[ShotNum, 2];
                End;

                If (((NextShot[1] > -1) And (NextShot[2] > -1)) And
                  ((NextShot[1] < 10) And (NextShot[2] < 10))) And
                  (ShootingMode = 2) And
                  (PlayerMap[NextShot[1], NextShot[2]] = 0) And
                  Not(NewShot) Then
                Begin
                    Inc(ShotNum);
                    PlayerMap[NextShot[1], NextShot[2]] := 1;
                    If ShotNum = 5 Then
                    Begin
                        ShotNum := 0;
                        ShootingMode := 1;
                        If Not(DefineShip(EndOfShooting[1], EndOfShooting[2],
                          PlayersShips, False)) Then
                        Begin
                            ShootingMode := 2;
                            ShotNum := 1;
                            SetPossibleShots(StartOfShooting[1],
                              StartOfShooting[2]);
                        End;
                    End;
                    Status := False;
                    CreateStatusOfBattle(NextShot[1], NextShot[2], Name2,
                      Status, IsShipKilled);
                    NextShot[1] := PossibleShots[ShotNum, 1];
                    NextShot[2] := PossibleShots[ShotNum, 2];
                    Current := 0;
                    NewShot := True;
                    Delay(800);
                    ShadeMaps();
                End;

                If (((NextShot[1] > -1) And (NextShot[2] > -1)) And
                  ((NextShot[1] < 10) And (NextShot[2] < 10))) And
                  (ShootingMode = 2) And
                  (PlayerMap[NextShot[1], NextShot[2]] = 3) And
                  Not(NewShot) Then
                Begin
                    Status := True;
                    Current := 1;
                    PlayerMap[NextShot[1], NextShot[2]] := 4;
                    EndOfShooting[1] := NextShot[1];
                    EndOfShooting[2] := NextShot[2];
                    IsShipKilled := DefineShip(NextShot[1], NextShot[2],
                      PlayersShips, True);
                    CreateStatusOfBattle(NextShot[1], NextShot[2], Name2,
                      Status, IsShipKilled);
                    If IsShipKilled Then
                    Begin
                        ShotNum := 0;
                        ShootingMode := 1;
                    End;
                    If ShootingMode = 2 Then
                    Begin
                        ShotNum := 1;
                        SetPossibleShots(NextShot[1], NextShot[2]);
                        NextShot[1] := PossibleShots[ShotNum, 1];
                        NextShot[2] := PossibleShots[ShotNum, 2];
                        Delay(800);
                    End;
                    ShadeMaps();
                End;

                If (((NextShot[1] > -1) And (NextShot[2] > -1)) And
                  ((NextShot[1] < 10) And (NextShot[2] < 10))) And
                  (ShootingMode = 2) And
                  ((PlayerMap[NextShot[1], NextShot[2]] = 2) Or
                  (PlayerMap[NextShot[1], NextShot[2]] = 1) Or
                  (PlayerMap[NextShot[1], NextShot[2]] = 4)) And
                  Not(NewShot) Then
                Begin
                    Inc(ShotNum);
                    If ShotNum = 5 Then
                    Begin
                        ShotNum := 0;
                        ShootingMode := 1;
                        If Not(DefineShip(EndOfShooting[1], EndOfShooting[2],
                          PlayersShips, False)) Then
                        Begin
                            ShootingMode := 2;
                            ShotNum := 1;
                            SetPossibleShots(StartOfShooting[1],
                              StartOfShooting[2]);
                        End;
                    End;
                    NextShot[1] := PossibleShots[ShotNum, 1];
                    NextShot[2] := PossibleShots[ShotNum, 2];
                End;

            End;
        End;
    End;

End;

Procedure TBattleForm.FormShow(Sender: TObject);
Begin
    N2.Checked := MenuForm.FIsSound;
End;

Procedure TBattleForm.ReverseOrientation();
Begin
    If ShipOrientation = 1 Then
        ShipOrientation := 2
    Else
        ShipOrientation := 1;
End;

Procedure TBattleForm.N1Click(Sender: TObject);
Begin
    If ButtonS.Available And (MenuForm.FIsSound) Then
        ButtonS.PlayTrack;
End;

Procedure TBattleForm.N2Click(Sender: TObject);
Begin
    MenuForm.FIsSound := Not MenuForm.FIsSound;
    If ButtonS.Available And (MenuForm.FIsSound) Then
        ButtonS.PlayTrack;
End;

Procedure TBattleForm.N3Click(Sender: TObject);
Begin
    IsHatching := Not IsHatching;
    N3.Checked := Not N3.Checked;
    If ButtonS.Available And (MenuForm.FIsSound) Then
        ButtonS.PlayTrack;

End;

Procedure TBattleForm.N4Click(Sender: TObject);
Begin
    If ButtonS.Available And (MenuForm.FIsSound) Then
        ButtonS.PlayTrack;
End;

Procedure TBattleForm.SaveGameState(Path: String);
Var
    FileOutput: File Of TFileRecord;
    Temp: TFileRecord;
Begin
    Try
        Try
            AssignFile(FileOutput, ChangeFileExt(Path, '.dat'));
            Rewrite(FileOutput);
            Temp.Player1.AllShips := PlayersShips;
            Temp.Player1.OwnMap := PlayerMap;
            Temp.Player1.Name := Name1;
            Temp.Player2.AllShips := OpponentShips;
            Temp.Player2.OwnMap := OpponentMap;
            Temp.Player2.Name := Name2;
            Temp.Time := GetTickCount - TimeOfStartGame;
            Write(FileOutput, Temp);
        Except
            MessageBox(BattleForm.Handle,
              '��������� ���� ������������, ���������� ������ ����',
              '��������������!', MB_OK + MB_ICONWARNING);
        End;
    Finally
        CloseFile(FileOutput);
    End;
End;

Procedure TBattleForm.N5Click(Sender: TObject);
Begin
    If ButtonS.Available And (MenuForm.FIsSound) Then
        ButtonS.PlayTrack;
    If (Mode = 1) And SaveGame.Execute Then
        SaveGameState(SaveGame.FileName);
End;

Procedure TBattleForm.SaveLogToFile(Path: String);
Var
    FileOutput: TextFile;
Begin
    Try
        Try
            AssignFile(FileOutput, ChangeFileExt(Path, '.txt'));
            Rewrite(FileOutput);
            Writeln(FileOutput, RichEdit1.Text);
        Except
            MessageBox(BattleForm.Handle,
              '��������� ���� ������������, ���������� ������ ����',
              '��������������!', MB_OK + MB_ICONWARNING);
        End;
    Finally
        CloseFile(FileOutput);
    End;
End;

Procedure TBattleForm.N6Click(Sender: TObject);
Begin
    If ButtonS.Available And (MenuForm.FIsSound) Then
        ButtonS.PlayTrack;
    If (Mode > 0) And SaveFile.Execute Then
        SaveLogToFile(SaveFile.FileName);
End;

Procedure TBattleForm.DrawFleetLine(StartShip, EndShip, CountOfDecks: Integer;
  LocOfShips: TCoordinatesArr; RightOffset: Integer);
Var
    I, J, SkipSquares, TopOffset: Integer;
    ImgOfDeck: TBitmap;
Begin
    Case CountOfDecks Of
        // � ����������� �� ����� �����, ���������� ��� �������� � ������ ���������,
        // ���������� ������ �������, ������� ����� ������ ������. ��� ������ ���-�� �����, ��� ������ ������
        1:
            TopOffset := 3;
        2:
            TopOffset := 5;
        3:
            TopOffset := 7;
        4:
            TopOffset := 9;
    End;
    SkipSquares := 0;
    // ���������� ��������� ��������, ������� ����� ����������, ����� ����������
    // ����� �������
    For I := StartShip To EndShip Do
    // � ����������� �� ���������� ����������, �������������� �������, �������
    Begin // c ������� � �������� StartShip, ���������� ������� � �������� EndShip
        ImgOfDeck := ImgForStat[1];
        If (LocOfShips[I].LifeDecks = 0) Then
            ImgOfDeck := ImgForStat[2];
        // ���� ��� ������ ������� �������, �� ������� �������� �� "����"
        For J := 1 To CountOfDecks Do // ��������� ���� ����� �������
            Buf.Canvas.Draw((J - 1) * 16 + SkipSquares + 32 + RightOffset,
              360 + TopOffset * 16, ImgOfDeck);
        Inc(SkipSquares, (CountOfDecks + 1) * 16);
    End;

End;

Function TBattleForm.CalcLifeDecks(CoorArrOfPlayer: TCoordinatesArr): Integer;
Var
    I, Sum: Integer;
Begin
    Sum := 0;
    For I := 1 To 10 Do
        Sum := Sum + CoorArrOfPlayer[I].LifeDecks;
    CalcLifeDecks := Sum;
End;

Function MakePercentage(LifeDecks: Real): String;
Var
    Percent: Real;
Begin
    Percent := LifeDecks * 100 / 20;
    MakePercentage := Format('%.0f', [Percent]);
End;

Function OutPercent(PerToOut, Person: String): String;
Const
    InfoStr = '��������� �����:' + #10#13;
Begin
    If Person = 'Player' Then
        OutPercent := InfoStr + PerToOut + ' %'
    Else
        OutPercent := InfoStr + PerToOut + ' %';
End;

Procedure TBattleForm.DrawAllFleet(Gamer: String;
  CoorArrOfPlayer: TCoordinatesArr);
Var
    Offset: Integer;
Begin
    If Gamer = 'Player' Then
        Offset := 0
    Else
        Offset := 500;
    DrawFleetLine(1, 1, 4, CoorArrOfPlayer, Offset);
    DrawFleetLine(2, 3, 3, CoorArrOfPlayer, Offset);
    DrawFleetLine(4, 6, 2, CoorArrOfPlayer, Offset);
    DrawFleetLine(7, 10, 1, CoorArrOfPlayer, Offset);
End;

Procedure TBattleForm.UpdateTabbleOfBattles(WinnerName: String);
Var
    TempList: TFightsList;
    TempRecord: TRecordLineAboutFight;
    Path: String;
Begin
    // �������� ���� � ����������, ��� ��������� ���������
    Path := ExtractFileDir(Application.ExeName);
    // �������� ����� �������
    TempRecord.PlayerName1 := Name1;
    TempRecord.PlayerName2 := Name2;
    // ������� ���������� ������ � ��������� ����� ������� � �������� � ������
    Pl1FleetLosses := MakePercentage(CalcLifeDecks(PlayersShips));
    Pl2FleetLosses := MakePercentage(CalcLifeDecks(OpponentShips));
    TempRecord.Pl1FleetLosses := Pl1FleetLosses;
    TempRecord.Pl2FleetLosses := Pl2FleetLosses;
    // �������� ���������� ������
    TempRecord.Winner := WinnerName;
    // ��������� ����� ����� ���� � ������ ����, ���� �� ��������� ���� ��� ���
    TempRecord.Time := GetTickCount - TimeOfStartGame + AddTime;
    // ������� ��������� ������ � ���� ������
    TempList := TFightsList.Create;
    // �������� ������ �� �����
    TempList := TFightsList.GetFightsListFromFile(Path + '\fights.tof');
    // �������� ��������� ������ � ��� � ������ ���
    TempList.AddNewLineAboutFight(TempRecord);
    // �������� ���������� ����� ����� �������
    TempList.SaveFightsList(Path + '\fights.tof');
End;

Procedure TBattleForm.CreateInfoAboutGameOver(Status: Boolean);
Var
    Winner: String;

Begin

    If Status Then
        Winner := Name1
    Else
        Winner := Name2;
    BattleForm.Timer1.Enabled := False;
    Showmessage(Winner + ' �������! ' + #10#13 + '����� ����� ����: ' +
      IntToStr((GetTickCount - TimeOfStartGame + AddTime) Div 1000 Div 60) +
      ' ���. ' + IntToStr((GetTickCount - TimeOfStartGame + AddTime)
      Div 1000 Mod 60) + ' ���.');
    BattleForm.RichEdit1.SelAttributes.Color := RGB(34, 180, 34);
    BattleForm.RichEdit1.Lines.Add('���� �����������! ������ �������: '
      + Winner);
    Inc(Mode);
    UpdateTabbleOfBattles(Winner);
End;

Procedure TBattleForm.Timer1Timer(Sender: TObject);
Var
    I, J, N, NumberOfDecks, OrientationX, OrientationY: Integer;
Begin

    If (Mode = 0) Then
    Begin
        Mode := 1;
        Current := 0;
        TimeOfStartGame := GetTickCount;
        OutInformationAboutGamer();
        Panel1.Caption := '����� ' + Name1;
        BattleForm.Panel1.Color := RGB(34, 180, 34);
        RichEdit1.Lines.Add('���� ��������! - ����� ' + Name1);
    End;
    If Not(IsMapHasShips(PlayerMap)) And (Mode = 1) Then
    Begin
        CreateInfoAboutGameOver(False);
    End;

    If Not(IsMapHasShips(OpponentMap)) And (Mode = 1) Then
    Begin
        CreateInfoAboutGameOver(True);
    End;
    DrawMaterials();
    DrawAllFleet('Player', PlayersShips);
    DrawAllFleet('Opponent', OpponentShips);
    BattleForm.StaticText3.Caption :=
      OutPercent(MakePercentage(CalcLifeDecks(PlayersShips)), 'Player');
    BattleForm.StaticText4.Caption :=
      OutPercent(MakePercentage(CalcLifeDecks(OpponentShips)), 'Opponent');
    BattleForm.Canvas.Draw(0, 0, Buf);
End;

End.
