object ProviderConnection: TProviderConnection
  Height = 245
  Width = 262
  object Connection: TFDConnection
    Params.Strings = (
      'Database=//firebird/data/rinha_backend'
      'Password=masterkey'
      'User_Name=rinha'
      'Server=localhost'
      'Port=3050'
      'CharacterSet=UTF8'
      'DriverID=FB')
    LoginPrompt = False
    Left = 56
    Top = 64
  end
  object GUIxWaitCursor: TFDGUIxWaitCursor
    Provider = 'Console'
    Left = 56
    Top = 128
  end
end
