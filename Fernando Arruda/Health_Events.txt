
SELECT --TOP (100)
	   [timestamp] as 'Data da Ocorrência'
      ,[type] as 'Tipo'
	  ,[machine_N] as 'Máquina'
	  ,[machineClass_N] as 'Frota'
	  ,[eventNumber] as 'Evento'
	  ,[eventLevel] as 'Nível do evento'
      ,[alarmDescription] AS 'Descrição do alarme'
	  ,[mid] as 'MID'
      ,[mid_N] as 'MID Descrição'
      ,[cid] as 'CID'
      ,[cid_N] as 'CID Descrição'
      ,[fmi] as 'FMI'
      ,[fmi_N] as 'FMI Descrição'
      ,[worstUnitType] as 'Tipo do Pior Valor Registrado'
      ,[worstValue] as 'Pior Valor Registrado'
      ,[worstValue_D] as 'Decodificação do Pior Valor Registrado'
      ,[worstValue_U] as 'Unidade do Pior Valor Registrado'
      ,[payload_Q] as 'Payload'
      ,[duration] as 'Duração em segundos'
      ,ROUND([smu_Q], 2) as 'Horímetro'
	  ,[operator_N] as 'Operador'
      ,[speed_Q] as 'Velocidade'
      ,[XYZX] as 'X'
      ,[XYZY] as 'Y'
      ,[XYZZ] as 'Z'
FROM [mshist].[dbo].[V_HEALTH_EVENT]
WHERE locationTimestamp > '2025-01-31 23:59:59.000' --AND  locationTimestamp < '2025-03-01 00:00:01.000'
  AND duration IS NOT NULL
  --AND type = 'Health Maintenance' -- Eventos de sistema apenas
  --AND type = 'Health Dat'a --Eventos máquina
  --AND alarmDescription like '%%' --filtrar por evento especifico
  --AND mid = '116'--filtrar por MID/módulo especifico