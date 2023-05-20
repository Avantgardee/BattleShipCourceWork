Unit MainMenuUnit;

Interface

Uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
    Vcl.Imaging.PNGImage,
    System.Classes, Vcl.Graphics, GIFImg,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, UnitSound;

Type
    TMenuForm = Class(TForm)
        OpenGame: TOpenDialog;
        Image1: TImage;
        Timer1: TTimer;
        Panel2: TPanel;
        Image3: TImage;
        Panel3: TPanel;
        Image4: TImage;
        Panel4: TPanel;
        Image5: TImage;
        Panel1: TPanel;
        Image2: TImage;
        Panel5: TPanel;
        Image6: TImage;
        Panel6: TPanel;
        Image7: TImage;
        Procedure Button1Click(Sender: TObject);
        Procedure Button2Click(Sender: TObject);
        Procedure Button3Click(Sender: TObject);
        Procedure Button4Click(Sender: TObject);
        Procedure FormCreate(Sender: TObject);
        Procedure Timer1Timer(Sender: TObject);
        Procedure Image3MouseEnter(Sender: TObject);
        Procedure Image3MouseLeave(Sender: TObject);
        Procedure Image5MouseLeave(Sender: TObject);
        Procedure Image5MouseEnter(Sender: TObject);
        Procedure Image4MouseEnter(Sender: TObject);
        Procedure Image4MouseLeave(Sender: TObject);
        Procedure Image2MouseLeave(Sender: TObject);
        Procedure Image2MouseEnter(Sender: TObject);
        Procedure Image6Click(Sender: TObject);
        Procedure FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
        Procedure Image7Click(Sender: TObject);
        Procedure FormKeyDown(Sender: TObject; Var Key: Word;
          Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    Private
        ButtonS: TSound;
        Gif: TGifImage;
    Public
        FIsSound: Boolean;
    End;

Var
    MenuForm: TMenuForm;
    Path: String;

Implementation

{$R *.dfm}

Uses BattleShipUnit, TableOfBattlesUnit, AddPlayerUnit;

Procedure TMenuForm.Button1Click(Sender: TObject);
Begin
    If (ButtonS.Available) And (MenuForm.FIsSound) Then
        ButtonS.PlayTrack;
    AddShipsForm.Show;
    MenuForm.Hide;
End;

Procedure TMenuForm.Button2Click(Sender: TObject);
Begin
    If (ButtonS.Available) And (MenuForm.FIsSound) Then
        ButtonS.PlayTrack;
    TableForm.Show;
End;

Procedure LoadGame(Path: String);
Var
    FileInput: File Of TFileRecord;
    Temp: TFileRecord;
    I, J: Integer;
    Dir: String;
Begin
    Try
        Try
            AssignFile(FileInput, ChangeFileExt(Path, '.dat'));
            Reset(FileInput);
            Read(FileInput, Temp);
            BattleForm.PlayerMap := Temp.Player1.OwnMap;
            BattleForm.OpponentMap := Temp.Player2.OwnMap;
            BattleForm.Name1 := Temp.Player1.Name;
            BattleForm.PlayersShips := Temp.Player1.AllShips;
            BattleForm.OpponentShips := Temp.Player2.AllShips;
            BattleForm.AddTime := Temp.Time;
            BattleForm.Name2 := Temp.Player2.Name;
            BattleForm.Mode := 0;
            BattleForm.Timer1.Enabled := True;
            MenuForm.Hide;
            BattleForm.Show;
        Except
            MessageBox(MenuForm.Handle,
              '��������� ���� ������������, ���������� ������ ����',
              '��������������!', MB_OK + MB_ICONWARNING);
        End;
    Finally
        If FileExists(ChangeFileExt(Path, '.dat')) Then
            CloseFile(FileInput)
        Else
            MessageBox(MenuForm.Handle, '���� �� ������ ��� � ���� ������ ������',
              '��������������!', MB_OK + MB_ICONWARNING);
    End;
End;

Procedure TMenuForm.Button3Click(Sender: TObject);
Begin
    If (ButtonS.Available) And (MenuForm.FIsSound) Then
        ButtonS.PlayTrack;
    If OpenGame.Execute Then
        LoadGame(OpenGame.FileName);
End;

Procedure TMenuForm.Button4Click(Sender: TObject);
Begin
    If (ButtonS.Available) And (MenuForm.FIsSound) Then
        ButtonS.PlayTrack;
    Close;
End;

Procedure TMenuForm.FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
Begin
    CanClose := Application.MessageBox
      ('�� �������, ��� ������ ������� ���������?', '�����?',
      MB_YESNO + MB_ICONINFORMATION) = IdYES;
End;

Procedure TMenuForm.FormCreate(Sender: TObject);
Var
    Buf: TBitMap;
Begin
    ButtonS := TSound.Create('button.wav');
    Gif := TGifImage.Create;
    Path := ExtractFileDir(Application.ExeName);
    Try
        Gif.LoadFromFile(Path + '\imagesForGame\gif\start1.gif');
        Image3.Picture.LoadFromFile(Path + '\imagesForGame\start\game.bmp');
        Image5.Picture.LoadFromFile(Path + '\imagesForGame\start\loadgame.bmp');
        Image4.Picture.LoadFromFile
          (Path + '\imagesForGame\start\tableOfBattles.bmp');
        Image2.Picture.LoadFromFile(Path + '\imagesForGame\start\exit.bmp');
        Image6.Picture.LoadFromFile(Path + '\imagesForGame\start\sound.bmp');
    Except
        MessageBox(MenuForm.Handle,
          '������ �������� ������ ��� ����, ��������� ������������ ���������',
          '��������������!', MB_OK + MB_ICONWARNING);
        Application.Terminate;
    End;

    Gif.Animate := True;
    Gif.AnimateLoop := GlEnabled;
    Timer1.Enabled := True;
    FIsSound := True;
End;

Procedure TMenuForm.FormKeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
    If Key = VK_ESCAPE Then
        Close;
End;

procedure TMenuForm.FormShow(Sender: TObject);
begin
If FIsSound Then
        Image6.Picture.LoadFromFile(Path + '\imagesForGame\start\sound.bmp')
    Else
        Image6.Picture.LoadFromFile(Path + '\imagesForGame\start\nosound.bmp');
end;

Procedure TMenuForm.Image2MouseEnter(Sender: TObject);
Begin
    Try
        Image2.Picture.LoadFromFile(Path + '\imagesForGame\start\exitOn.bmp');
    Except
        MessageBox(MenuForm.Handle,
          '������ �������� ������ ��� ����, ��������� ������������ ���������',
          '��������������!', MB_OK + MB_ICONWARNING);
        Application.Terminate;
    End;
    // Path := ExtractFileDir(Application.ExeName);

End;

Procedure TMenuForm.Image2MouseLeave(Sender: TObject);
Begin
    Try
        Image2.Picture.LoadFromFile(Path + '\imagesForGame\start\exit.bmp');
    Except
        MessageBox(MenuForm.Handle,
          '������ �������� ������ ��� ����, ��������� ������������ ���������',
          '��������������!', MB_OK + MB_ICONWARNING);
        Application.Terminate;
    End;
    // Path := ExtractFileDir(Application.ExeName);

End;

Procedure TMenuForm.Image3MouseEnter(Sender: TObject);
Begin
    // Path := ExtractFileDir(Application.ExeName);
    Try
        Image3.Picture.LoadFromFile(Path + '\imagesForGame\start\gameOn.bmp');
    Except
        MessageBox(MenuForm.Handle,
          '������ �������� ������ ��� ����, ��������� ������������ ���������',
          '��������������!', MB_OK + MB_ICONWARNING);
        Application.Terminate;
    End;

End;

Procedure TMenuForm.Image3MouseLeave(Sender: TObject);
Begin
    // Path := ExtractFileDir(Application.ExeName);
    Image3.Picture.LoadFromFile(Path + '\imagesForGame\start\game.bmp');
End;

Procedure TMenuForm.Image4MouseEnter(Sender: TObject);
Begin
    // Path := ExtractFileDir(Application.ExeName);
    Try
        Image4.Picture.LoadFromFile
          (Path + '\imagesForGame\start\tableOfBattlesOn.bmp');
    Except
        MessageBox(MenuForm.Handle,
          '������ �������� ������ ��� ����, ��������� ������������ ���������',
          '��������������!', MB_OK + MB_ICONWARNING);
        Application.Terminate;
    End;

End;

Procedure TMenuForm.Image4MouseLeave(Sender: TObject);
Begin
    // Path := ExtractFileDir(Application.ExeName);

    Try
        Image4.Picture.LoadFromFile
          (Path + '\imagesForGame\start\tableOfBattles.bmp');
    Except
        MessageBox(MenuForm.Handle,
          '������ �������� ������ ��� ����, ��������� ������������ ���������',
          '��������������!', MB_OK + MB_ICONWARNING);
        Application.Terminate;
    End;
End;

Procedure TMenuForm.Image5MouseEnter(Sender: TObject);
Begin
    // Path := ExtractFileDir(Application.ExeName);

    Try
        Image5.Picture.LoadFromFile
          (Path + '\imagesForGame\start\loadGameOn.bmp');
    Except
        MessageBox(MenuForm.Handle,
          '������ �������� ������ ��� ����, ��������� ������������ ���������',
          '��������������!', MB_OK + MB_ICONWARNING);
        Application.Terminate;
    End;
End;

Procedure TMenuForm.Image5MouseLeave(Sender: TObject);
Begin
    // Path := ExtractFileDir(Application.ExeName);

    Try
        Image5.Picture.LoadFromFile(Path + '\imagesForGame\start\loadGame.bmp');
    Except
        MessageBox(MenuForm.Handle,
          '������ �������� ������ ��� ����, ��������� ������������ ���������',
          '��������������!', MB_OK + MB_ICONWARNING);
        Application.Terminate;
    End;
End;

Procedure TMenuForm.Image6Click(Sender: TObject);
Begin
    FIsSound := Not FIsSound;
    // Path := ExtractFileDir(Application.ExeName);
    If FIsSound Then
        Image6.Picture.LoadFromFile(Path + '\imagesForGame\start\sound.bmp')
    Else
        Image6.Picture.LoadFromFile(Path + '\imagesForGame\start\nosound.bmp');
    If (ButtonS.Available) And (MenuForm.FIsSound) Then
        ButtonS.PlayTrack;
End;

Procedure TMenuForm.Image7Click(Sender: TObject);
Begin
    If (ButtonS.Available) And (MenuForm.FIsSound) Then
        ButtonS.PlayTrack;
    Application.MessageBox
      ('����������� �������� "������� ���" ����������� ��������� ������ 251005 �������� ��������'
      + #10#13 + #10#13 + '�������:' + #10#13 +
      '�������� ��� � ���� ��� ���� ����������, � ������� ������ �� ������� �������� ���������� �� ����������� �� ����� ���������.'
      + #10#13 +
      ' ���� � ��������� �� ���� ����������� ������� ������� (���������� ������), �� ������� ��� ��� ����� ���������, � �������� �������� ����� ������� ��� ���� ���.',
      '����������');
End;

Procedure TMenuForm.Timer1Timer(Sender: TObject);
Begin
    Image1.Picture.Assign(Gif)

End;
Begin
    Path := ExtractFileDir(Application.ExeName);

End.
