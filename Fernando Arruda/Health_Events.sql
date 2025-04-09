  SELECT TOP (100)
	   [timestamp] AS 'Data da Ocorrência',
       [type] AS 'Tipo',
	   [machine_N] AS 'Máquina',
	   [machineClass_N] AS 'Frota',
	   [eventNumber] AS 'Evento',
	   [eventLevel] AS 'Nível do evento',
       [alarmDescription] AS 'Descrição do alarme',
	   [mid] AS 'MID',
       [mid_N] AS 'MID Descrição',
       [cid] AS 'CID',
       [cid_N] AS 'CID Descrição',
       [fmi] AS 'FMI',
       [fmi_N] AS 'FMI Descrição',
       [worstUnitType] AS 'Tipo do Pior Valor Registrado',
       [worstValue] AS 'Pior Valor Registrado',
       [worstValue_D] AS 'Decodificação do Pior Valor Registrado',
       [worstValue_U] AS 'Unidade do Pior Valor Registrado',
       [payload_Q] AS 'Payload',
       [duration] AS 'Duração em segundos',

       -- Conversão para hh:mm:ss
       RIGHT('0' + CAST(CAST([duration] AS INT) / 3600 AS VARCHAR(2)), 2) + ':' +
       RIGHT('0' + CAST((CAST([duration] AS INT) % 3600) / 60 AS VARCHAR(2)), 2) + ':' +
       RIGHT('0' + CAST(CAST([duration] AS INT) % 60 AS VARCHAR(2)), 2) AS 'Duração (hh:mm:ss)',

       ROUND([smu_Q], 2) AS 'Horímetro',
	   [operator_N] AS 'Operador',
       [speed_Q] AS 'Velocidade',
       [XYZX] AS 'Latitude(X)',
       [XYZY] AS 'Longitude (Y)',
       [XYZZ] AS 'Altura (Z)'

FROM [mshist].[dbo].[V_HEALTH_EVENT]
WHERE locationTimestamp > '2025-01-31 23:59:59.000' 
  AND duration IS NOT NULL
  --AND  locationTimestamp < '2025-03-01 00:00:01.000'
  --AND type = 'Health Maintenance' -- Eventos de sistema apenas
  --AND type = 'Health Dat'a --Eventos máquina
  --AND alarmDescription like '%%' --filtrar por evento especifico
  --AND mid = '116'--filtrar por MID/módulo especifico
