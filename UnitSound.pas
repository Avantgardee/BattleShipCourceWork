unit UnitSound;

interface

type
  TSound = class
  private
    FTrackName: string;
    FIsDownloaded: Boolean;
    procedure LoadSound();
  public
    constructor Create(ATrackName: string);
    procedure PlayTrack();
    procedure StopSound();
    property Available: Boolean read FIsDownloaded;
  end;

implementation

uses
  MMSystem;

constructor TSound.Create(ATrackName: string);
begin
  FTrackName := ATrackName;
  LoadSound();
end;

procedure TSound.LoadSound();
var
  SoundFile: file;
  Extension: String;
begin
    Try
        AssignFile(SoundFile, FTrackName);
        Reset(SoundFile);
        Extension := Copy(FTrackName, Length(FTrackName) - 3, 4);
        If Extension = '.wav' Then
            FIsDownloaded := True
        Else
            FIsDownloaded := False;
    Except
        FIsDownloaded := False;
    End;
end;

procedure TSound.PlayTrack();
begin
  PlaySound(PChar(FTrackName), 0, SND_ASYNC);
end;

procedure TSound.StopSound();
begin
  PlaySound(nil, 0, SND_PURGE); //SND_PURGE //0, 0, Snd_Purge
end;

end.
