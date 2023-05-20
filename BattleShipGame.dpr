program BattleShipGame;

uses
  Vcl.Forms,
  BattleShipUnit in 'BattleShipUnit.pas' {BattleForm},
  UnitSound in 'UnitSound.pas',
  MainMenuUnit in 'MainMenuUnit.pas' {MenuForm},
  Vcl.Themes,
  Vcl.Styles,
  TableOfBattlesUnit in 'TableOfBattlesUnit.pas' {TableForm},
  AddPlayerUnit in 'AddPlayerUnit.pas' {AddShipsForm},
  ListUnit in 'ListUnit.pas',
  LoadUnit in 'LoadUnit.pas' {StartForm};

{$R *.res}

begin
  Application.Initialize;

  StartForm := TStartForm.Create(Application);
  StartForm.Show;
  StartForm.Update;
  Application.MainFormOnTaskbar := True;


  Application.CreateForm(TMenuForm, MenuForm);
  MenuForm.Visible:=false;
  While StartForm.TimerLoadScreen.Enabled do
  begin
      Application.ProcessMessages;
  end;
  StartForm.Hide;
  StartForm.Free;
  TStyleManager.TrySetStyle('Tablet Light');
   Application.CreateForm(TBattleForm, BattleForm);
  Application.CreateForm(TTableForm, TableForm);
  Application.CreateForm(TAddShipsForm, AddShipsForm);
  Application.CreateForm(TStartForm, StartForm);
  Application.Run;
end.
