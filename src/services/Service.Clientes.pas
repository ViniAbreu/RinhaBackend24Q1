unit Service.Clientes;

interface

uses
  System.SysUtils, System.Classes, Service.Base, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.ConsoleUI.Wait, FireDAC.Comp.UI, Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, System.JSON, FireDAC.Phys.FB, FireDAC.Phys.FBDef;

type
  TServiceClientes = class(TServiceBase)
    qryClientes: TFDQuery;
    qryTransacao: TFDQuery;
    qryTransacaoID: TIntegerField;
    qryTransacaoCLIENTE_ID: TIntegerField;
    qryTransacaoVALOR: TIntegerField;
    qryTransacaoTIPO: TStringField;
    qryTransacaoDESCRICAO: TStringField;
    qryTransacaoREALIZADA_EM: TSQLTimeStampField;
    qryTransacaoLIMITE: TIntegerField;
    qryTransacaoSALDO: TIntegerField;
    qryClientesSALDO: TIntegerField;
    qryClientesLIMITE: TIntegerField;
    qryClientesID: TIntegerField;
    qrySaldo: TFDQuery;
    qryUltimasTransacoes: TFDQuery;
  public
    function Movimentar(const AIdCliente: string; const ABody: TJSONObject): Boolean;
    function Extrato(const AIdCliente: string): TJSONObject;
  end;

implementation

uses DataSet.Serialize;

{$R *.dfm}

function TServiceClientes.Extrato(const AIdCliente: string): TJSONObject;
begin
  Result := TJSONObject.Create;

  qrySaldo.ParamByName('cli_id').AsString := AIdCliente;
  qrySaldo.Open;

  qryUltimasTransacoes.ParamByName('cli_id').AsString := AIdCliente;
  qryUltimasTransacoes.Open;

  Result.AddPair('saldo', qrySaldo.ToJSONObject);
  Result.AddPair('ultimas_transacoes', qryUltimasTransacoes.ToJSONArray);
end;

function TServiceClientes.Movimentar(const AIdCliente: string; const ABody: TJSONObject): Boolean;
begin
  Result := False;
  Connection.StartTransaction;
  try
    qryTransacao.Open;
    ABody.AddPair('cliente_id', AIdCliente);
    qryTransacao.LoadFromJSON(ABody, False);

    qryClientes.ParamByName('cli_id').AsString := AIdCliente;
    qryClientes.Open;

    qryClientes.Edit;
    if ABody.GetValue<string>('tipo').ToUpper.Equals('D') then
      qryClientesSALDO.AsInteger := qryClientesSALDO.AsInteger - ABody.GetValue<Integer>('valor')
    else
      qryClientesSALDO.AsInteger := qryClientesSALDO.AsInteger + ABody.GetValue<Integer>('valor');
    qryClientes.Post;

    if ABody.GetValue<string>('tipo').ToUpper.Equals('D') and
      (qryClientesSALDO.AsInteger < (qryClientesLIMITE.AsInteger * -1)) then
    begin
      Connection.Rollback;
      Exit(False);
    end;

    qryTransacao.ApplyUpdates(0);
    qryClientes.ApplyUpdates(0);
    Connection.Commit;
    Result := True;
  except
    Connection.Rollback;
  end;
end;

end.
