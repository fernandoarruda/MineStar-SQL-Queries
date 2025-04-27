SELECT 
    -- From Bucket Load
    b.BUCKET_LOAD_ID,
    b.MACHINE_ID,
    m.NAME AS LOADER_NAME,
	b.TIME_END,
    DATEADD(HOUR, -3, b.TIME_END) AS TIME_END_LOCAL,
    b.MATERIAL,
    t.OVERRIDE_MATERIAL, -- << Moved here, just after MATERIAL
    
    /*Coordinates for COR - Ccoordinates for centre of
rotation*/
    --cor.X AS COR_X,
    --cor.Y AS COR_Y,
    --cor.Z AS COR_Z,
    
    -- Coordinates for DIG
    dig.X AS DIG_X,
    dig.Y AS DIG_Y,
    dig.Z AS DIG_Z,
    
    -- Coordinates for DUMP of the loader bucket
    dump.X AS DUMP_X,
    dump.Y AS DUMP_Y,
    dump.Z AS DUMP_Z,
    
    -- From Truck Load
    t.TRUCK_ID,
    
    -- Truck name from CA_C_TRUCK
    ct.NAME AS TRUCK_NAME

FROM [TerrainProdFiles].[dbo].[CA_P_BUCKET_LOAD] AS b

-- Join Position table for COR_COORD_ID
LEFT JOIN [TerrainProdFiles].[dbo].[CA_P_POSITION] AS cor
    ON b.COR_COORD_ID = cor.POSITION_ID

-- Join Position table for DIG_COORD_ID
LEFT JOIN [TerrainProdFiles].[dbo].[CA_P_POSITION] AS dig
    ON b.DIG_COORD_ID = dig.POSITION_ID

-- Join Position table for DUMP_COORD_ID
LEFT JOIN [TerrainProdFiles].[dbo].[CA_P_POSITION] AS dump
    ON b.DUMP_COORD_ID = dump.POSITION_ID

-- Join Truck Load Buckets to find Truck Load ID
LEFT JOIN [TerrainProdFiles].[dbo].[CA_P_TRUCK_LOAD_BUCKETS] AS tb
    ON b.BUCKET_LOAD_ID = tb.BUCKET_LOAD_ID

-- Join Truck Load to bring Truck Info
LEFT JOIN [TerrainProdFiles].[dbo].[CA_P_TRUCK_LOAD] AS t
    ON tb.TRUCK_LOAD_ID = t.TRUCK_LOAD_ID

-- Join Truck table to get Truck Name
LEFT JOIN [TerrainProdFiles].[dbo].[CA_C_TRUCK] AS ct
    ON t.TRUCK_ID = ct.TRUCK_ID

-- Join Machine table to get Loader Name
LEFT JOIN [TerrainProdFiles].[dbo].[CA_C_MACHINE] AS m
    ON b.MACHINE_ID = m.MACHINE_ID

--WHERE b.TIME_END >= '2025-02-01'; -- Optional filter