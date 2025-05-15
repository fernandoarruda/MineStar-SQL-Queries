SELECT [OID]
	  ,[timestamp]
      ,[machineName]
      ,[operatorName]
      ,[itemName]
      ,[itemStatus]
      ,[itemStatus_D]


  FROM [mshist].[dbo].[V_SAFETY_CHECK_RECORD]

  /*where timestamp_UTC > '2024-12-31 19:00:00.000'
		and timestamp_UTC < '2025-01-08 19:00:00.000'
		and machineName = '785_12'*/

order by timestamp desc