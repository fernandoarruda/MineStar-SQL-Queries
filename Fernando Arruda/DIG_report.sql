SELECT 
    b.BUCKET_LOAD_ID,
    b.MACHINE_ID,
    -- Coordinates for COR
    cor.X AS COR_X,
    cor.Y AS COR_Y,
    cor.Z AS COR_Z,
    -- Coordinates for DIG
    dig.X AS DIG_X,
    dig.Y AS DIG_Y,
    dig.Z AS DIG_Z,
    -- Coordinates for DUMP
    dump.X AS DUMP_X,
    dump.Y AS DUMP_Y,
    dump.Z AS DUMP_Z,
    -- Other fields if you want
    b.TIME_END,
    b.MATERIAL
FROM [TerrainProdFiles].[dbo].[CA_P_BUCKET_LOAD] AS b
-- Join for COR_COORD_ID
LEFT JOIN [TerrainProdFiles].[dbo].[CA_P_POSITION] AS cor
    ON b.COR_COORD_ID = cor.POSITION_ID
-- Join for DIG_COORD_ID
LEFT JOIN [TerrainProdFiles].[dbo].[CA_P_POSITION] AS dig
    ON b.DIG_COORD_ID = dig.POSITION_ID
-- Join for DUMP_COORD_ID
LEFT JOIN [TerrainProdFiles].[dbo].[CA_P_POSITION] AS dump
    ON b.DUMP_COORD_ID = dump.POSITION_ID
WHERE b.TIME_END >= '2025-02-01'; -- optional filter
