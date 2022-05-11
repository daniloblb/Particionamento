--select ps.name PScheme, pf.name PFunction from sys.partition_schemes ps join sys.partition_functions pf on (ps.function_id=pf.function_id)
-- SET 
USE PTC_LTA									-- rever
GO
--20190101 até 20191231+1(20200101)  
DECLARE @BD AS VARCHAR(150)='PTC_LTA'		-- rever
DECLARE @CodData AS VARCHAR(150)
DECLARE @Ano AS VARCHAR(150)
DECLARE @Ano2 AS VARCHAR(150)
DECLARE @AnoMesInicial AS INT=201901		-- rever -- Colcar data início particionamento
DECLARE @AnoMesFinal AS INT=202001			-- rever -- Colcar data fim particionamento

DECLARE job_cursor CURSOR FOR  

 SELECT @BD, DateKey/100,DateKey/10000,DateKey
FROM [DBA_PTSI_Management].[dbo].[DimDate]					-- rever (Garantir que está a base de dados onde está a tabela [DBA_PTSI_Management].[dbo].[DimDate])
  WHERE DateKey/100 BETWEEN @AnoMesInicial AND @AnoMesFinal
  ORDER BY 1

OPEN job_cursor   
FETCH NEXT FROM job_cursor INTO @BD,@Ano,@Ano2 ,@CodData  

PRINT 'USE '+quotename(@BD)
PRINT 'GO'
--FG_PTC_LTA_DAT_F_201604_F2
WHILE @@FETCH_STATUS = 0 
    BEGIN   


 --FG_PTC_CG_DAT_201612_F

--startWOT

PRINT 'SET DEADLOCK_PRIORITY HIGH;'
PRINT 'GO'
PRINT 'ALTER PARTITION SCHEME [PS_DIARIA_DAT_F] NEXT USED [FG_PTC_LTA_DAT_'+@Ano+'_F];'
PRINT 'ALTER PARTITION SCHEME [PS_DIARIA_IDX_F] NEXT USED [FG_PTC_LTA_IDX_'+@Ano+'_F];'
PRINT 'ALTER PARTITION SCHEME [PS_DIARIA_DAT_A2] NEXT USED [FG_PTC_LTA_DAT_'+@Ano+'_A2];'
PRINT 'ALTER PARTITION SCHEME [PS_DIARIA_DAT_F1] NEXT USED [FG_PTC_LTA_DAT_'+@Ano+'_F1];'
PRINT 'ALTER PARTITION SCHEME [PS_DIARIA_DAT_F2] NEXT USED [FG_PTC_LTA_DAT_'+@Ano+'_F2];'
PRINT 'ALTER PARTITION SCHEME [PS_DIARIA_IDX_A2] NEXT USED [FG_PTC_LTA_IDX_'+@Ano+'_A2];'
PRINT 'ALTER PARTITION SCHEME [PS_DIARIA_IDX_F1] NEXT USED [FG_PTC_LTA_IDX_'+@Ano+'_F1];'
PRINT 'ALTER PARTITION SCHEME [PS_DIARIA_IDX_F2] NEXT USED [FG_PTC_LTA_IDX_'+@Ano+'_F2];'

--endWOT
            PRINT 'ALTER PARTITION FUNCTION [PARTITION_F_DIARIA]() SPLIT RANGE ('+@CodData+ ')'
            PRINT 'GO'

        FETCH NEXT FROM job_cursor INTO @BD,@Ano ,@Ano2  ,@CodData 
    END  
CLOSE job_cursor   
DEALLOCATE job_cursor


--SELECT pf.name,MIN(prv.value)[MIN],max(prv.value)[MAX]
--  FROM sys.partition_functions pf with(nolock) 
-- INNER JOIN sys.partition_range_values prv with(nolock) ON pf.function_id=prv.function_id
--INNER JOIN sys.partitions p with(nolock) ON p.partition_number = prv.boundary_id
--WHERE pf.name='PARTITION_F_DIARIA'
--GROUP BY pf.name


----select name from sys.filegroups where name like '%_PNP_%'
