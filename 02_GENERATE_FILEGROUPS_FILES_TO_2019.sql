--select ps.name PScheme, pf.name PFunction from sys.partition_schemes ps join sys.partition_functions pf on (ps.function_id=pf.function_id)
--primeiro a DATA e logo os IDX---
USE PTC_LTA
GO
DECLARE @datacnt as int = 23					--- rever  -- o primeiro nº das luns a utilizar para o output sempre e data (para o exemplo utilizaremos as luns de 23 a 27 para DATA)
DECLARE @numdiskdata as int = 27					--- rever  -- o último nº das luns a utilizar para o output sempre e data (para o exemplo utilizaremos as luns de 23 a 27 para DATA)
DECLARE @datacnt2 as int = 13						--- rever  -- o primeiro nº das luns a utilizar para o output sempre e indexes (para o exemplo utilizaremos apenas a lun 13 para IDX)
DECLARE @numdiskdata2 as int = 13					--- rever  -- o último nº das luns a utilizar para o output sempre e indexes (para o exemplo utilizaremos apenas a lun 13 para IDX)
DECLARE @datapath as varchar(max) = 'E:\SQL_DATA_'  --- rever
DECLARE @datapath2 as varchar(max) = 'E:\SQL_DATA_' --- rever
DECLARE @BD AS VARCHAR(150)='PTC_LTA'				--- rever
DECLARE @dataf as varchar(max)
DECLARE @dataf2 as varchar(max)
DECLARE @CodData AS VARCHAR(150)
DECLARE @Ano AS VARCHAR(150)
DECLARE @Ano2 AS VARCHAR(150)
DECLARE @AnoMesInicial AS INT=201901				--- rever  --- INÍCIO
DECLARE @AnoMesFinal AS INT=202001					--- rever  ---- FIM

PRINT 'USE '+QUOTENAME(@BD)
PRINT 'GO'

DECLARE job_cursor CURSOR FOR  
 SELECT distinct @BD, DateKey/100, DateKey/10000
FROM [DBA_PTSI_Management].[dbo].[DimDate]						-- rever
  WHERE DateKey/100 BETWEEN @AnoMesInicial AND @AnoMesFinal
  ORDER BY 1


DECLARE @datacntinitial as int = @datacnt
DECLARE @datacnt2initial as int = @datacnt2

OPEN job_cursor   
FETCH NEXT FROM job_cursor INTO @BD,@Ano,@Ano2

WHILE @@FETCH_STATUS = 0 
	BEGIN   

		
        if @datacnt <= @numdiskdata
        begin
                if len(@datacnt) = 1 
					set @dataf = LTRIM(RTRIM(@datapath + '0' + cast(@datacnt as char(2))))
					else set @dataf = LTRIM(RTRIM(@datapath + cast(@datacnt as char(2))))
                set @datacnt = @datacnt + 1
					if @datacnt = @numdiskdata + 1
					--set @datacnt = 01
					set @datacnt = @datacntinitial
		end

		
		if @datacnt2 <= @numdiskdata2
        begin
                if len(@datacnt2) = 1 
					set @dataf2 = LTRIM(RTRIM(@datapath2 + '0' + cast(@datacnt2 as char(2))))
					else set @dataf2 = LTRIM(RTRIM(@datapath2 + cast(@datacnt2 as char(2))))
                set @datacnt2 = @datacnt2 + 1
					if @datacnt2 = @numdiskdata2 + 1
					--set @datacnt2 = 01
					set @datacnt2 = @datacnt2initial
		end
--startWOT
PRINT 'SET DEADLOCK_PRIORITY HIGH;'
PRINT 'GO'
PRINT 'ALTER DATABASE ['+@BD+'] ADD FILEGROUP [FG_PTC_LTA_DAT_'+@Ano+'_F]'
PRINT 'ALTER DATABASE ['+@BD+'] ADD FILEGROUP [FG_PTC_LTA_IDX_'+@Ano+'_F]'
PRINT 'GO'
PRINT 'ALTER DATABASE ['+@BD+'] ADD FILE (NAME=''FG_PTC_LTA_DAT_'+@Ano+'_F'',FILENAME='''+@dataf+'\'+@BD+'\FG_PTC_LTA_DAT_'+@Ano+'_F.ndf'',SIZE=1MB,MAXSIZE=15GB,FILEGROWTH=256MB) TO FILEGROUP [FG_PTC_LTA_DAT_'+@Ano+'_F]'
PRINT 'ALTER DATABASE ['+@BD+'] ADD FILE (NAME=''FG_PTC_LTA_IDX_'+@Ano+'_F'',FILENAME='''+@dataf2+'\'+@BD+'\FG_PTC_LTA_IDX_'+@Ano+'_F.ndf'',SIZE=1MB,MAXSIZE=15GB,FILEGROWTH=256MB) TO FILEGROUP [FG_PTC_LTA_IDX_'+@Ano+'_F]'
PRINT 'GO'
PRINT 'ALTER DATABASE ['+@BD+'] ADD FILEGROUP [FG_PTC_LTA_DAT_'+@Ano+'_A2]'
PRINT 'ALTER DATABASE ['+@BD+'] ADD FILEGROUP [FG_PTC_LTA_DAT_'+@Ano+'_F1]'
PRINT 'ALTER DATABASE ['+@BD+'] ADD FILEGROUP [FG_PTC_LTA_DAT_'+@Ano+'_F2]'
PRINT 'ALTER DATABASE ['+@BD+'] ADD FILEGROUP [FG_PTC_LTA_IDX_'+@Ano+'_A2]'
PRINT 'ALTER DATABASE ['+@BD+'] ADD FILEGROUP [FG_PTC_LTA_IDX_'+@Ano+'_F1]'
PRINT 'ALTER DATABASE ['+@BD+'] ADD FILEGROUP [FG_PTC_LTA_IDX_'+@Ano+'_F2]'
PRINT 'GO'
PRINT 'ALTER DATABASE ['+@BD+'] ADD FILE (NAME=''FG_PTC_LTA_DAT_'+@Ano+'_A2'',FILENAME='''+@dataf+'\'+@BD+'\FG_PTC_LTA_DAT_'+@Ano+'_A2.ndf'',SIZE=1MB,MAXSIZE=15GB,FILEGROWTH=256MB) TO FILEGROUP [FG_PTC_LTA_DAT_'+@Ano+'_A2]'
PRINT 'ALTER DATABASE ['+@BD+'] ADD FILE (NAME=''FG_PTC_LTA_DAT_'+@Ano+'_F1'',FILENAME='''+@dataf+'\'+@BD+'\FG_PTC_LTA_DAT_'+@Ano+'_F1.ndf'',SIZE=1MB,MAXSIZE=15GB,FILEGROWTH=256MB) TO FILEGROUP [FG_PTC_LTA_DAT_'+@Ano+'_F1]'
PRINT 'ALTER DATABASE ['+@BD+'] ADD FILE (NAME=''FG_PTC_LTA_DAT_'+@Ano+'_F2'',FILENAME='''+@dataf+'\'+@BD+'\FG_PTC_LTA_DAT_'+@Ano+'_F2.ndf'',SIZE=1MB,MAXSIZE=15GB,FILEGROWTH=256MB) TO FILEGROUP [FG_PTC_LTA_DAT_'+@Ano+'_F2]'
PRINT 'ALTER DATABASE ['+@BD+'] ADD FILE (NAME=''FG_PTC_LTA_IDX_'+@Ano+'_A2'',FILENAME='''+@dataf2+'\'+@BD+'\FG_PTC_LTA_IDX_'+@Ano+'_A2.ndf'',SIZE=1MB,MAXSIZE=15GB,FILEGROWTH=256MB) TO FILEGROUP [FG_PTC_LTA_IDX_'+@Ano+'_A2]'
PRINT 'ALTER DATABASE ['+@BD+'] ADD FILE (NAME=''FG_PTC_LTA_IDX_'+@Ano+'_F1'',FILENAME='''+@dataf2+'\'+@BD+'\FG_PTC_LTA_IDX_'+@Ano+'_F1.ndf'',SIZE=1MB,MAXSIZE=15GB,FILEGROWTH=256MB) TO FILEGROUP [FG_PTC_LTA_IDX_'+@Ano+'_F1]'
PRINT 'ALTER DATABASE ['+@BD+'] ADD FILE (NAME=''FG_PTC_LTA_IDX_'+@Ano+'_F2'',FILENAME='''+@dataf2+'\'+@BD+'\FG_PTC_LTA_IDX_'+@Ano+'_F2.ndf'',SIZE=1MB,MAXSIZE=15GB,FILEGROWTH=256MB) TO FILEGROUP [FG_PTC_LTA_IDX_'+@Ano+'_F2]'
PRINT 'GO'
PRINT 'GO'
--endWOT

        FETCH NEXT FROM job_cursor INTO @BD,@Ano,@Ano2
    END  
CLOSE job_cursor   
DEALLOCATE job_cursor
