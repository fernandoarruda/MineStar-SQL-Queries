set dateformat dmy
set nocount on
declare @StartDate datetime
declare @EndDate datetime
set @StartDate = '31-01-2025 19:00:00'
set @EndDate = '28-02-2025 19:00:00'

IF OBJECT_ID('tempdb..#resumogeologiaeplanejamento') IS NOT NULL DROP TABLE #resumogeologiaeplanejamento

select

concat('Periodo de: ', convert(varchar(10),@Startdate,103), ' até ', convert(varchar(10),@EndDate,103)) as 'PeriodoParametro',
b.ID_Ciclo as 'CycleID',
b.Inicio_Ciclo as 'TimeStart',
b.Final_Ciclo as 'TimeFinish',
b.[OrigemBlock],
b.Destino,
b.Material_Operator,
b.Material_MES,
b.Material_Block,
b.sourceblockhierarchy as 'Hierarchy_Block',
b.PayloadNM,
b.Payload,
(b.Dist_Viaj_Vazio_KM + b.Dist_Viaj_Cheio_KM)/2 as 'DMT_KM',
b.CU, b.AU, b.PY, b.RECCU, b.RECAU, b.Densidade, b.AxB, b.BWI, b.PNPA, b.FE,  b.PB, b.S, b.ANX, b.BHC, b.BTOF, b.BTOS, b.GNS, b.MIX, b.MPI, b.MTF, b.NSR, b.OX, b.PEG, b.QDPB, b.QSRT, b.SRT, b.TON, b.TPH,(b.Payload * b.CU) as 'Nota_CU',       (b.Payload * b.AU) as 'Nota_AU',(b.Payload * b.PY) as 'Nota_PY',       (b.Payload * b.RECCU) as 'Nota_RECCU',(b.Payload * b.RECAU) as 'Nota_RECAU', (b.Payload * b.Densidade) as 'Nota_Densidade', (b.Payload * b.AxB) as 'Nota_AxB',     (b.Payload * b.BWI) as 'Nota_BWI',(b.Payload * b.PNPA) as 'Nota_PNPA',   (b.Payload * b.FE) as 'Nota_FE', (b.Payload * b.PB) as 'Nota_PB',       (b.Payload * b.S) as 'Nota_S',(b.Payload * b.ANX) as 'Nota_ANX',     (b.Payload * b.BHC) as 'Nota_BHC',(b.Payload * b.BTOF) as 'Nota_BTOF',   (b.Payload * b.BTOS) as 'Nota_BTOS',(b.Payload * b.GNS) as 'Nota_GNS',     (b.Payload * b.MIX) as 'Nota_MIX',(b.Payload * b.MPI) as 'Nota_MPI',     (b.Payload * b.MTF) as 'Nota_MTF',(b.Payload * b.NSR) as 'Nota_NSR',     (b.Payload * b.OX) as 'Nota_OX',
(b.Payload * b.PEG) as 'Nota_PEG',     (b.Payload * b.QDPB) as 'Nota_QDPB',
(b.Payload * b.QSRT) as 'Nota_QSRT',   (b.Payload * b.SRT) as 'Nota_SRT',
(b.Payload * b.TON) as 'Nota_TON',     (b.Payload * b.TPH) as 'Nota_TPH'

into #resumogeologiaeplanejamento
from (
	select 
	ID_Ciclo,
	min(inicio_ciclo) as 'Inicio_Ciclo',
	max(final_ciclo) as 'Final_Ciclo',
	Bloco as 'OrigemBlock',
	--max(Origem) as 'Origem',
	max(Destino) as 'Destino',
	Material_Operator,
	Material_MES,
	Material_Block,
	sourceblockhierarchy,
	Max(PayloadNM) as 'PayloadNM',
	Max(Payload) as 'Payload',
	sum(Dist_Viaj_Vazio_KM) as 'Dist_Viaj_Vazio_KM',
	sum(Dist_Viaj_Cheio_KM) as 'Dist_Viaj_Cheio_KM',
	max(case when CU = 0 then null else CU end) as 'CU',	max(case when AU = 0 then null else AU end) as 'AU',	max(case when PY = 0 then null else PY end) as 'PY',	max(case when RECAU = 0 then null else RECAU end) as 'RECAU',	max(case when RECCU = 0 then null else RECCU end) as 'RECCU',	max(case when Densidade = 0 then null else Densidade end) as 'Densidade',	max(case when AxB = 0 then null else AxB end) as 'AxB',	max(case when BWI = 0 then null else BWI end) as 'BWI',	max(case when PNPA = 0 then null else PNPA end) as 'PNPA',	max(case when FE = 0 then null else FE end) as 'FE',	max(case when PB = 0 then null else PB end) as 'PB',	max(case when S = 0 then null else S end) as 'S',	max(case when ANX = 0 then null else ANX end) as 'ANX',	max(case when BHC = 0 then null else BHC end) as 'BHC',	max(case when BTOF = 0 then null else BTOF end) as 'BTOF',	max(case when BTOS = 0 then null else BTOS end) as 'BTOS',	max(case when GNS = 0 then null else GNS end) as 'GNS',	max(case when MIX = 0 then null else MIX end) as 'MIX',	max(case when MPI = 0 then null else MPI end) as 'MPI',	max(case when MTF = 0 then null else MTF end) as 'MTF',	max(case when NSR = 0 then null else NSR end) as 'NSR',	max(case when OX = 0 then null else OX end) as 'OX',	max(case when PEG = 0 then null else PEG end) as 'PEG',	max(case when QDPB = 0 then null else QDPB end) as 'QDPB',	max(case when QSRT = 0 then null else QSRT end) as 'QSRT',	max(case when SRT = 0 then null else SRT end) as 'SRT',	max(case when TON = 0 then null else TON end) as 'TON',	max(case when TPH = 0 then null else TPH end) as 'TPH'
	from
		  (		
		select

		CYCLEOID as 'ID_Ciclo',
		dateadd(hour, -3,STARTTIME_UTC) as 'Inicio_Ciclo',
		dateadd(hour,-3,ENDTIME_UTC) as 'Final_Ciclo',
		SOURCEDESTINATIONNAME as 'Origem',
		SINKDESTINATIONNAME as 'Destino',
		LOADERMATERIALNAME as 'Material_Operator',
		LOADERMATERIALGROUPLEVEL1 as 'Material_MES',
		SOURCEBLOCKMATERIAL as 'Material_Block',
		SOURCEBLOCKNAME as 'Bloco',
		SOURCEBLOCKHIERARCHY,
		sum(case when TIMEELAPSEDTOCYCLEENDTIME_Q = 43200 then 0 else PAYLOADNOMINAL_Q end) as 'PayloadNM',
		sum(case when TIMEELAPSEDTOCYCLEENDTIME_Q = 43200 then 0 else PAYLOAD_Q end) as 'Payload',
		sum(EMPTYSLOPEDISTANCE_Q)/1000 as 'Dist_Viaj_Vazio_KM',
		sum(LOADEDSLOPEDISTANCE_Q)/1000 as 'Dist_Viaj_Cheio_KM',
		max(GRADEVALUEAU_Q)*10000 as 'AU', max(GRADEVALUECU_Q) as 'CU',  max(GRADEVALUEPY_Q) as 'PY', max(GRADEVALUERECAU_Q) as 'RECAU',
		max(GRADEVALUERECCU_Q) as 'RECCU', max(GRADEVALUEDENSIDADE_Q) as 'Densidade',  max(GRADEVALUEAXB_Q) as 'AxB', max(GRADEVALUEBWI_Q) as 'BWI',		max(GRADEVALUEPNPA_Q) as 'PNPA', max(GRADEVALUEFE_Q) as 'FE', max(GRADEVALUEPB_Q) as 'PB', max(GRADEVALUES_Q) as 'S',
		max(GRADEVALUEANX_Q) as 'ANX', max(GRADEVALUEBCH_Q) as 'BHC', max(GRADEVALUEBTOF_Q) as 'BTOF',	max(GRADEVALUEBTOS_Q) as 'BTOS',
		max(GRADEVALUEGNS_Q) as 'GNS', max(GRADEVALUEMIX_Q) as 'MIX', max(GRADEVALUEMPI_Q) as 'MPI', max(GRADEVALUEMTF_Q) as 'MTF',
		max(GRADEVALUENSR_Q) as 'NSR', max(GRADEVALUEOX_Q) as 'OX', max(GRADEVALUEPEG_Q) as 'PEG', max(GRADEVALUEQDPB_Q) as 'QDPB',
		max(GRADEVALUEQSRT_Q) as 'QSRT', max(GRADEVALUESRT_Q) as 'SRT',	max(GRADEVALUETON_Q) as 'TON', max(GRADEVALUETPH_Q) as 'TPH'
		from mssumm.dbo.CYCLE_S_FACT_MAIN left join mssumm.dbo.cycle_dim_calendar on SOURCE_ENTITY = calendaroid
		where dateadd(hour,-3,ENDTIME_UTC) > @StartDate
				and dateadd(hour,-3,ENDTIME_UTC) <= @EndDate 
				and CYCLETYPE like 'TruckCycle'
				and CREATIONMODE <> 3				--and CYCLEOID in (233774700, 233777082, 233783808, 233776898, 233914558, 233914470)
		group by CYCLEOID, dateadd(hour, -3,STARTTIME_UTC), dateadd(hour,-3,ENDTIME_UTC), 
					SOURCEDESTINATIONNAME, SINKDESTINATIONNAME, LOADERMATERIALNAME, LOADERMATERIALGROUPLEVEL1,
					SOURCEBLOCKMATERIAL, SOURCEBLOCKNAME, SOURCEBLOCKHIERARCHY
		) a

	group by id_ciclo, Material_Operator, Material_MES, Material_Block, Bloco, sourceblockhierarchy
			
	)b 
order by b.Final_Ciclo

--select * from #resumogeologiaeplanejamento order by TimeFinish

select

PeriodoParametro,
concat('Periodo de: ', min(TimeStart), ' até ', max(TimeFinish)) as 'PeriodoDados',
Destino,
Material_Operator,
Material_Block,
Material_MES,
round(avg(DMT_KM),2) as 'DMT_KM',
count(CycleID) as 'NumCiclos',
round(sum(payload),4) as 'MassaTotal', --sum(Nota_CU) as 'SumNotaCU',round(avg(CU),4) as 'MedSp_CU',
round( (sum(Nota_CU) / sum(payload)) ,4) as 'MedPd_CU', --sum(Nota_AU) as 'SumNotaAU', round(avg(AU),4) as 'MedSp_AU',
round( (sum(Nota_AU) / sum(payload)) ,4) as 'MedPd_AU',
round( (sum(Nota_PY) / sum(payload)) ,4) as 'MedPd_PY',
round( (sum(Nota_RECCU) / sum(payload)) ,4) as 'MedPd_RECCU',
round( (sum(Nota_RECAU) / sum(payload)) ,4) as 'MedPd_RECAU',
round( (sum(Nota_Densidade) / sum(payload)) ,4) as 'MedPd_Densidade',
round( (sum(Nota_AxB) / sum(payload)) ,4) as 'MedPd_AxB',
round( (sum(Nota_BWI) / sum(payload)) ,4) as 'MedPd_BWI',
round( (sum(Nota_PNPA) / sum(payload)) ,4) as 'MedPd_PNPA',
round( (sum(Nota_FE) / sum(payload)) ,4) as 'MedPd_FE',
round( (sum(Nota_PB) / sum(payload)) ,4) as 'MedPd_PB',
round( (sum(Nota_S) / sum(payload)) ,4) as 'MedPd_S',
round( (sum(Nota_ANX) / sum(payload)) ,4) as 'MedPd_ANX',
round( (sum(Nota_BHC) / sum(payload)) ,4) as 'MedPd_BHC',
round( (sum(Nota_BTOF) / sum(payload)) ,4) as 'MedPd_BTOF', --round( avg(BTOS) ,4) as 'MedSp_BTOS',
round( (sum(Nota_BTOS) / sum(payload)) ,4) as 'MedPd_BTOS',
round( (sum(Nota_GNS) / sum(payload)) ,4) as 'MedPd_GNS',
round( (sum(Nota_MIX) / sum(payload)) ,4) as 'MedPd_MIX',
round( (sum(Nota_MPI) / sum(payload)) ,4) as 'MedPd_MPI',
round( (sum(Nota_MTF) / sum(payload)) ,4) as 'MedPd_MTF',
round( (sum(Nota_NSR) / sum(payload)) ,4) as 'MedPd_NSR',
round( (sum(Nota_OX) / sum(payload)) ,4) as 'MedPd_OX',
round( (sum(Nota_PEG) / sum(payload)) ,4) as 'MedPd_PEG',
round( (sum(Nota_QDPB) / sum(payload)) ,4) as 'MedPd_QDPB',
round( (sum(Nota_QSRT) / sum(payload)) ,4) as 'MedPd_QSRT',
round( (sum(Nota_SRT) / sum(payload)) ,4) as 'MedPd_SRT',
round( (sum(Nota_TON) / sum(payload)) ,4) as 'MedPd_TON', --round( avg(TPH) ,4) as 'MedSp_TPH',
round( (sum(Nota_TPH) / sum(payload)) ,4) as 'MedPd_TPH'

from #resumogeologiaeplanejamento

group by PeriodoParametro, Destino, Material_Operator, Material_MES, Material_Block

order by Destino