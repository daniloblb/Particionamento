--exec DBA_PTSI_Management..sp_WhoIsActive 309

select * from sys.filegroups where name like '%2019%'

select count(*) [Contagem FGs Total Ano] from sys.filegroups where name like '%2019%'

select count(*)/6 [Contagem FGs Total Ano/PS's] --6 é o nº de PS's que tem a bd PTC_LTA usada no exemplo.
from sys.filegroups where name like '%2019%'