
/****** Script for SelectTopNRows command from SSMS  ******/
SELECT --TOP (2000) 
	   [startTime] AS Hora_Inicio_Ciclo
	  ,[endTime] AS Hora_Fim_Ciclo
	  ,[creationMode_D] AS Ciclo_Autimático_ou_Editado
	  ,[secondaryMachineName] AS Máquina_Carga
	  ,[loaderMaterialName] AS Material
      ,[secondaryOperatorName] AS Operador_Carga
      ,[sourceBlockLevel]
      ,[sourceBlockName]
      ,[sourceCoordsX] AS Longitude_Carregamento_X
      ,[sourceCoordsY] AS Latitude_Carregamento_Y
      ,[sourceCoordsZ] AS Altura_Carregamento_Z
      ,[sourceLocationName]
      ,[primaryMachineName] AS Caminhão
	  ,ROUND([startSMU_Q],2) AS Horímetro_Inicial
	  ,ROUND([endSMU],2) AS Horímetro_Final
	  ,[payload_Q] AS CargaÚtil
	  ,[primaryOperatorName] AS Operador_Transporte
      ,[dumpPositionX] AS Longitude_Basculamento_X
      ,[dumpPositionY] AS Latitude_Basculamento_Y
      ,[dumpPositionZ] AS Altitude_Basculamento_Z
      ,[endProcessorClassName] AS Classe_processador
      ,[endProcessorName] AS Nome_Processador 

  FROM [mshist].[dbo].[V_CYCLE]

  WHERE createdDate >  '2024-08-04 23:59:59' AND createdDate < '2024-08-08 00:00:01'
  AND primaryMachineCategoryName like '%Truck%'
    

