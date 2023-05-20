unit LoadUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.jpeg;

type
  TStartForm = class(TForm)
    Image1: TImage;
    TimerLoadScreen: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure TimerLoadScreenTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  StartForm: TStartForm;

implementation

{$R *.dfm}

procedure TStartForm.FormCreate(Sender: TObject);
begin
    SetWindowRgn(Handle, CreateEllipticRgn(0, 0, 500, 500), False);
end;

procedure TStartForm.TimerLoadScreenTimer(Sender: TObject);
begin
      TimerLoadScreen.Enabled := False;
end;

end.
