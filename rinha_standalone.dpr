program rinha_standalone;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Horse,
  Horse.Jhonson,
  DataSet.Serialize,
  DataSet.Serialize.Config,
  Controller.Main in 'src\controllers\Controller.Main.pas',
  Provider.Connection in 'src\providers\Provider.Connection.pas' {ProviderConnection: TDataModule},
  Service.Base in 'src\services\Service.Base.pas' {ServiceBase: TDataModule},
  Service.Clientes in 'src\services\Service.Clientes.pas' {ServiceBase1: TDataModule};

begin
  THorse.Use(Jhonson());
  TDataSetSerializeConfig.GetInstance.CaseNameDefinition := cndLower;

  Controller.Main.Registry;

  THorse.Listen(8080);
end.
