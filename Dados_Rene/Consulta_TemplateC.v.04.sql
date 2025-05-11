set dateformat dmy
set language portuguese
set nocount on

declare @StartDate datetime
declare @EndDate datetime

set @StartDate = '23-04-2025 19:00:00'
set @EndDate = '24-04-2025 19:00:00'

IF OBJECT_ID('tempdb..#turnoeletra') IS NOT NULL DROP TABLE #turnoeletra

/* Cria a tabela temporária que vai puxar para cada ciclo sempre o último turno e a ultima letra */

select 

ID_CICLO, Turno, Letra, TurnoCompleto

into #turnoeletra
from (

select

OID,CYCLEOID as 'ID_Ciclo',STARTTIME_UTC as 'Start',ENDTIME_UTC as 'End',
case when CALENDARSHIFTTYPE like 'Day' then 'Turno 1'
	 when CALENDARSHIFTTYPE like 'Night' then 'Turno 2'
end as 'Turno',
CALENDARCREWID as 'Letra',
CALENDARNAME as 'TurnoCompleto'

from mssumm.dbo.CYCLE_S_FACT_MAIN
where dateadd(hour,-3,ENDTIME_UTC) > @StartDate
		and dateadd(hour,-3,ENDTIME_UTC) <= @EndDate 
		and CYCLETYPE in ('TruckCycle')
		and CREATIONMODE <> 3
        --and CYCLEOID = 181517170
) a

right join (

select 

MAX(OID) AS 'OID', CYCLEOID as 'CYCLEOID'

from mssumm.dbo.CYCLE_S_FACT_MAIN 

where dateadd(hour,-3,ENDTIME_UTC) > @StartDate
		and dateadd(hour,-3,ENDTIME_UTC) <= @EndDate
		and CYCLETYPE in ('TruckCycle')
		and CREATIONMODE <> 3
        --and CYCLEOID = 181517170

group by CYCLEOID

) b on a.OID = b.OID and a.ID_Ciclo = b.CYCLEOID

--select * from #turnoeletra

/* Consulta que retorna os dados sumarizados */

select

b.ID_Ciclo as 'CycleID',
tl.Letra as 'Crew',
tl.TurnoCompleto as 'FullShiftName',
tl.Turno as 'ShiftName',
b.TruckOperID,
b.LoadingOperID,
b.TruckFleet,
b.LoadingFleet,
b.Transporte as 'Truck',
b.Carga as 'LoadingUnit',
b.Origem as 'LoadLocation',
b.Destino as 'Destination',
b.PayloadNM as 'NominalPayloadTons',
b.Payload as 'PayloadTons',
b.Material_Block as 'MaterialName',
b.MaterialType,
b.Hierarquia_Bloco as 'BlockHierarchy',
b.[Block] as 'BlockName',
b.BlockID,
b.TotalDistance as 'TotalDistance',
b.EFHDistance as 'EFHDistance',
b.Inicio_Ciclo as 'StartCycleTimestamp',
b.SpotTime as 'SpotAtLoadTimestamp',
b.TravelFullTime as 'TravelFullTimestamp',
b.Start_Basculo as 'DumpingTimestamp',
b.Final_Ciclo as 'EndCycleTimestamp',
b.Viajando_Vazio_sec as 'EmptyTravelTime',
b.Fila_Carga_sec as 'QueueOriginTime',
b.Manobra_Carga_sec as 'SpotOriginTime',
b.Ag_Carga_sec as 'WaitforLoadTime',
b.Carregamento_sec as 'LoadingTime',
b.Viajando_Cheio_sec as 'FullTravelTime',
b.Fila_Basc_sec as 'QueueDestinationTime',
b.Manobra_Basc_sec as 'SpotDestinationTime',
b.Ag_Basc_sec as 'WaitforDumpTime',
b.Basculando_sec as 'DumpingTime'


from (

	select 

	ID_Ciclo,
	TipoCiclo,
	max(dia) as 'Dia',
	max(creationmode) as 'creationmode',
	case when count(id_ciclo) > 1 then concat (count(Id_ciclo),' ', 'turnos') else max(Turno) end as 'Turno',
	max(FullShiftName) as 'FullShiftName',
	min(inicio_ciclo) as 'Inicio_Ciclo',
	max(final_ciclo) as 'Final_Ciclo',
	LoadingFleet,
	Carga,
	TruckFleet,
	Transporte,
	Origem,
	Destino,
	Material_Block,
	Hierarquia_Bloco,
	Bloco as 'Block',
	sum(PayloadNM) as 'PayloadNM',
	sum(Payload) as 'Payload',
	max(SpotTime) as 'SpotTime',
	max(TravelFullTime) as 'TravelFullTime',
	max(Start_Basculo) as 'Start_Basculo',
	sum(Viajando_Cheio_sec) as 'Viajando_Cheio_sec',
	sum(Fila_Basc_sec) as 'Fila_Basc_sec',
	sum(Manobra_Basc_sec) as 'Manobra_Basc_sec',
	sum(Ag_Basc_sec) as 'Ag_Basc_sec',
	sum(Basculando_sec) as 'Basculando_sec',
	MaterialType,
	sum(TotalDistance) as 'TotalDistance',
	sum(EFHDistance) as 'EFHDistance',
	BlockID,
	TruckOperID,
	LoadingOperID,
	max(Start_Loading) as 'Start_Loading',
	max(End_Loading) as 'End_Loading',
	sum(Viajando_Vazio_sec) as 'Viajando_Vazio_sec',
	sum(Fila_Carga_sec) as 'Fila_Carga_sec',
	sum(Manobra_Carga_sec) as 'Manobra_Carga_sec',
	sum(Ag_Carga_sec) as 'Ag_Carga_sec',
	sum(Carregamento_sec) as 'Carregamento_sec'


	from
		( 
		select

		CYCLEOID as 'ID_Ciclo',
		CYCLETYPE as 'TipoCiclo',
		(convert(varchar(10),ENDTIME,103)) as 'Dia',
		creationmode,
		case when CALENDARSHIFTTYPE like 'Day' then 'Turno 1'
		     when CALENDARSHIFTTYPE like 'Night' then 'Turno 2'
	    end as 'Turno',
		CALENDARNAME as 'FullShiftName',
		STARTTIME as 'Inicio_Ciclo',
		SECONDARYMACHINECLASSNAME as 'LoadingFleet',
		SECONDARYMACHINENAME as 'Carga',
		PRIMARYMACHINECLASSNAME as 'TruckFleet',
		PRIMARYMACHINENAME as 'Transporte',
		SOURCEDESTINATIONNAME as 'Origem',
		SINKDESTINATIONNAME as 'Destino',
		SOURCEBLOCKMATERIAL as 'Material_Block',
		SOURCEBLOCKHIERARCHY as 'Hierarquia_Bloco',
		SOURCEBLOCKNAME as 'Bloco',
		sum(PAYLOADNOMINAL_Q) as 'PayloadNM',
		sum(PAYLOAD_Q) as 'Payload',
		SPOTTINGSTARTTIME as 'SpotTime',
		LOADINGENDTIME as 'TravelFullTime',
		DUMPINGSTARTTIME as 'Start_Basculo',
		ENDTIME as 'Final_Ciclo',
		SOURCEBLOCKMATERIALGROUPLEVEL1 as 'MaterialType',
		sum(EMPTYSLOPEDISTANCE_Q)+sum(LOADEDSLOPEDISTANCE_Q) as 'TotalDistance',
		sum(EMPTYEFHDISTANCE_Q)+sum(LOADEDEFHDISTANCE_Q) as 'EFHDistance',
		SOURCEBLOCKOID as 'BlockID',
		PRIMARYOPERATOROID as 'TruckOperID',
		SECONDARYOPERATOROID as 'LoadingOperID',
		LOADINGSTARTTIME as 'Start_Loading',
		LOADINGENDTIME as 'End_Loading',
		sum(TRAVELLINGEMPTYDURATION_Q) as 'Viajando_Cheio_sec',
		sum(TRAVELLINGEMPTYDURATION_Q) as 'Viajando_Vazio_sec',
		sum(QUEUINGATSOURCEDURATION_Q) as 'Fila_Carga_sec',
		sum(SPOTTINGATSOURCEDURATION_Q) as 'Manobra_Carga_sec',
		sum(WAITFORLOADDURATION_Q) as 'Ag_Carga_sec',
		sum(LOADINGDURATION_Q) as 'Carregamento_sec',
		sum(QUEUINGATSINKDURATION_Q) as 'Fila_Basc_sec',
		sum(SPOTTINGATSINKDURATION_Q) as 'Manobra_Basc_sec',
		sum(WAITFORDUMPDURATION_Q) as 'Ag_Basc_sec',
		sum(DUMPINGDURATION_Q) as 'Basculando_sec'	


		from mssumm.dbo.CYCLE_S_FACT_MAIN 

		where ENDTIME > @StartDate
			  and ENDTIME <= @EndDate 
			  and CYCLETYPE in ('TruckCycle')
			  and CREATIONMODE <> 3
			  --and cycleoid = 182350764
			  --and PRIMARYMACHINENAME = '785_11'

		group by CYCLEOID, CYCLETYPE, (convert(varchar(10),endtime,103)), CREATIONMODE, STARTTIME, CALENDARSHIFTTYPE, ENDTIME, SECONDARYMACHINENAME, SECONDARYOPERATORNAME, PRIMARYMACHINENAME,
				 PRIMARYOPERATORNAME, SOURCEDESTINATIONNAME, SINKDESTINATIONNAME, LOADERMATERIALNAME, SOURCEBLOCKNAME, SOURCEBLOCKHIERARCHY, TRAVELLINGFULLDURATION_Q, EMPTYEFHDISTANCE_Q,				
				 SOURCEBLOCKMATERIAL, DUMPINGSTARTTIME, LOADINGENDTIME, LOADINGSTARTTIME, CALENDARNAME, QUEUINGSTARTTIME, LOADINGENDTIME, FULLEXPECTEDTRAVELDURATION_Q, 
				 LOADEDEFHDISTANCE_Q, SOURCEBLOCKOID, PRIMARYOPERATOROID, SOURCEBLOCKMATERIALGROUPLEVEL1, SECONDARYMACHINECLASSNAME, PRIMARYMACHINECLASSNAME, SPOTTINGSTARTTIME,
				 SECONDARYOPERATOROID
			 ) a

	group by id_ciclo, TipoCiclo, Carga, Transporte, Origem, Destino, Material_Block, Bloco, Hierarquia_Bloco, MaterialType, TruckOperID, BlockID, LoadingFleet, TruckFleet, LoadingOperID

	)b left join mshist.dbo.V_CYCLE vc on b.ID_Ciclo = vc.OID
	   left join #turnoeletra tl on tl.ID_Ciclo = b.ID_Ciclo

order by TipoCiclo, b.Inicio_Ciclo