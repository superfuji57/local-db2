library(RODBC)
library(RMySQL)
dsn.name <- "RPORTING"
user.name <- "bisql05"
pw <- "bisql05"
con1 <- odbcConnect('rporting', uid='bisql05', pwd='bisql05')

table.list <- sqlTables(con1, tableType="TABLE", schema="STOR2APP")
cat("There are", nrow(table.list), "tables in the DB2INST1 schema.\n")
table.name <- "STOR2APP.ORDERS"
col.list <- sqlColumns(con1, table.name)
nrow(col.list)

x <- sqlQuery(con1, query="select  count(Distinct ORDERS_ID)  from stor2app.ORDERS o
where o.STOREENT_ID = 10201
and date(o.timeplaced) between Date('2014-04-01') and Date('2014-04-30')
")

coolOrders <- "select 'TCOOL V2' Segment, sum (o.amount+o.adjustment) Revenue, Count(Distinct o.ORDER_ID) orders, sum (o.units) items,date(o.submit_date) Reporting_Date 
from cool2.c_orders_rpt o 
left outer join bisql05.v_ucn_exclusion u on o.UCN = u.UCN_KEY 
where u.UCN_KEY is null and o.parent_teacher_flag = 'T' 
and date(o.submit_date) between '2014-06-01' and '2014-06-28'
group by date(o.submit_date)"

# Close connections
odbcCloseAll()
cat("Database connections are closed.\n")
