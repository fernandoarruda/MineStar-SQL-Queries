/****** Script for SelectTopNRows command from SSMS  ******/
SET DATEFORMAT dmy;
SET LANGUAGE portuguese;
SET NOCOUNT ON;

DECLARE @StartDate datetime = '23-04-2025 19:00:00.000';
DECLARE @EndDate datetime = '23-04-2025 20:30:00.000';

WITH DadosFiltrados AS (
    SELECT 
        machine_N AS Truck,
        CASE 
            WHEN machine_N LIKE '77%' THEN 'CAT_777G'
            WHEN machine_N LIKE '78%' THEN 'CAT_785C'
            ELSE 'Outro Modelo'
        END AS Fleet,
        arrivalTime AS Timestamp,
		waypoint_N as Beacon,
        XYZX_Q AS CoordX,
        XYZY_Q AS CoordY,
        XYZZ_Q AS CoordZ
    FROM 
        mshist.dbo.V_PRODUCTION_EVENT WITH (NOLOCK)
    WHERE 
        arrivalTime > @StartDate
        AND arrivalTime <= @EndDate
        AND ObjectTypeID = 'PositionReport'
		and machine_N = '785_11'
)
SELECT *
FROM DadosFiltrados
WHERE Fleet <> 'Outro Modelo'
ORDER BY Timestamp ASC;
