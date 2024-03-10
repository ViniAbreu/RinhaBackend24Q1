unit Controller.Main;

interface

procedure Registry;

implementation

uses Horse, Service.Clientes, System.JSON, DataSet.Serialize, System.SysUtils;

procedure InsertTransaction(Req: THorseRequest; Res: THorseResponse);
var
  LService: TServiceClientes;
begin
  LService := TServiceClientes.Create(nil);
  try
    if not (Req.Params.Items['id'].ToInteger in [1, 2, 3, 4, 5]) then
    begin
      Res.Send('Cliente não encontrado').Status(THTTPStatus.NotFound);
      Exit;
    end;

    if LService.Movimentar(Req.Params.Items['id'], Req.Body<TJSONObject>) then
      Res.Send(Lservice.qryClientes.ToJSONObject).Status(THTTPStatus.OK)
    else
      Res.Send('Essa transação deixara o saldo inconsistente.').Status(THTTPStatus.UnprocessableEntity);
  finally
    LService.Free;
  end;
end;

procedure GetExtrato(Req: THorseRequest; Res: THorseResponse);
var
  LService: TServiceClientes;
begin
  LService := TServiceClientes.Create(nil);
  try
    if not (Req.Params.Items['id'].ToInteger in [1, 2, 3, 4, 5]) then
    begin
      Res.Send('Cliente não encontrado').Status(THTTPStatus.NotFound);
      Exit;
    end;

    Res.Send(LService.Extrato(Req.Params.Items['id'])).Status(THTTPStatus.OK);
  finally
    LService.Free;
  end;
end;

procedure Registry;
begin
  THorse.Get('clientes/:id/extrato', GetExtrato);
  THorse.Post('clientes/:id/transacoes', InsertTransaction);
end;

end.
