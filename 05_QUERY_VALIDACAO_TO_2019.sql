select @@SERVERNAME [Inst�ncia], DB_NAME() [BD]
go

select COUNT (*) n,
LEFT (cast(value as int)   ,6) [Ano/M�s]
from sys.partition_range_values
where LEFT (cast(value as int)   ,4) = 2018
group by LEFT (cast(value as int)   ,6)
order by 2