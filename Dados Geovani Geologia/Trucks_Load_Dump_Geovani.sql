SELECT
	--Identificação do ciclo
    [OID],
    [creationMode_D],
    [lastModified],
    [createdDate],

	--Máquinas & Operadores
    [primaryMachineCategoryName],
    [primaryMachineClassName],
    [primaryMachineName],
    [primaryOperatorName],
    [secondaryMachineCategoryName],
    [secondaryMachineClassName],
    [secondaryMachineName],
    [secondaryOperatorName],

	--Horários e horímetros
    [startTime],
    [endTime],
    ROUND([startSMU_Q],2) AS [startSMU_Q],
    ROUND([endSMU_Q],2) AS [endSMU_Q],


	--Origem e carregamento
    [sourceLocationName],
    [sourceBlockLevel],
    [sourceBlockName],
    [sourceCoordsX],
    [sourceCoordsY],
    [sourceCoordsZ],
    [sourceLocation_N],
    [loaderMaterialName],
    [operMaterialName],

	--Payload
    [nominalPayload_Q],
    [payload_Q],

	--Destino Planejado (Sink)
    [assignedSinkLocationName],
    [observedSinkLocationName],
    [endSinkLocationName],
    [endProcessorClassName],
    [endProcessorName],
    [endSinkCoordsX],
    [endSinkCoordsY],
    [endSinkCoordsZ],
    [lastKnownMaterialName],

	--Posição Real de Descarga (Dump)
    [dumpPositionX],
    [dumpPositionY],
    [dumpPositionZ]

FROM [mshist].[dbo].[V_CYCLE]
WHERE primaryMachineCategoryName = 'Truck Classes'
/*AND startTime >= '2025-05-13 00:00:00' --Ajustar para data de inicio desejada
AND endTime <= '2025-05-13 23:59:59' --Ajustar para data final desejada*/
ORDER BY createdDate DESC
