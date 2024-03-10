inherited ServiceClientes: TServiceClientes
  Width = 447
  inherited Connection: TFDConnection
    Params.Strings = (
      'Database=C:\Projetos\RinhaBackEnd\RINHABACKEND.FDB'
      'Password=masterkey'
      'User_Name=SYSDBA'
      'Server=localhost'
      'Port=3055'
      'CharacterSet=UTF8'
      'DriverID=FB')
  end
  object qryClientes: TFDQuery
    CachedUpdates = True
    Connection = Connection
    SQL.Strings = (
      'select sld.id,'
      '       sld.valor as saldo,'
      '       cli.limite'
      'from saldos sld'
      'inner join clientes cli on cli.id = sld.cliente_id'
      'where sld.cliente_id = :cli_id')
    Left = 232
    Top = 48
    ParamData = <
      item
        Name = 'CLI_ID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
    object qryClientesID: TIntegerField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      ReadOnly = True
      Visible = False
    end
    object qryClientesSALDO: TIntegerField
      FieldName = 'SALDO'
      Origin = 'VALOR'
      Required = True
    end
    object qryClientesLIMITE: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'LIMITE'
      Origin = 'LIMITE'
      ProviderFlags = []
      ReadOnly = True
    end
  end
  object qryTransacao: TFDQuery
    CachedUpdates = True
    Connection = Connection
    SQL.Strings = (
      'select trn.id, '
      '       trn.cliente_id, '
      '       trn.valor, '
      '       trn.tipo, '
      '       trn.descricao, '
      '       trn.realizada_em,'
      '       cli.limite,'
      '       sld.valor as saldo'
      'from transacoes trn'
      'inner join clientes cli on cli.id = trn.cliente_id'
      'inner join saldos sld on sld.cliente_id = trn.cliente_id')
    Left = 136
    Top = 48
    object qryTransacaoID: TIntegerField
      AutoGenerateValue = arAutoInc
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      ReadOnly = True
    end
    object qryTransacaoCLIENTE_ID: TIntegerField
      FieldName = 'CLIENTE_ID'
      Origin = 'CLIENTE_ID'
      Required = True
    end
    object qryTransacaoVALOR: TIntegerField
      FieldName = 'VALOR'
      Origin = 'VALOR'
      Required = True
    end
    object qryTransacaoTIPO: TStringField
      FieldName = 'TIPO'
      Origin = 'TIPO'
      Required = True
      FixedChar = True
      Size = 1
    end
    object qryTransacaoDESCRICAO: TStringField
      FieldName = 'DESCRICAO'
      Origin = 'DESCRICAO'
      Required = True
      Size = 10
    end
    object qryTransacaoREALIZADA_EM: TSQLTimeStampField
      FieldName = 'REALIZADA_EM'
      Origin = 'REALIZADA_EM'
      ReadOnly = True
    end
    object qryTransacaoLIMITE: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'LIMITE'
      Origin = 'LIMITE'
      ProviderFlags = []
      ReadOnly = True
    end
    object qryTransacaoSALDO: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'SALDO'
      Origin = 'VALOR'
      ProviderFlags = []
      ReadOnly = True
    end
  end
  object qrySaldo: TFDQuery
    Connection = Connection
    SQL.Strings = (
      'select sld.valor as total,'
      '       localtimestamp as data_extrato,'
      '       cli.limite'
      'from clientes cli'
      'inner join saldos sld on sld.cliente_id = cli.id'
      'where sld.cliente_id = :cli_id')
    Left = 232
    Top = 112
    ParamData = <
      item
        Name = 'CLI_ID'
        ParamType = ptInput
      end>
  end
  object qryUltimasTransacoes: TFDQuery
    Connection = Connection
    SQL.Strings = (
      
        'select first 10 trn.valor, trn.tipo, trn.descricao, trn.realizad' +
        'a_em'
      'from transacoes trn'
      'where trn.cliente_id = :cli_id'
      'order by trn.realizada_em desc')
    Left = 328
    Top = 112
    ParamData = <
      item
        Name = 'CLI_ID'
        ParamType = ptInput
      end>
  end
end
