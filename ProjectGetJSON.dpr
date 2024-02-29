program ProjectGetJSON;

uses
  Vcl.Forms,
  UnitMain in 'UnitMain.pas' {Form_Main};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm_Main, Form_Main);
  Application.Run;
end.
