select * from df_orders;

--/1.find top 10 highest revenue products
select top 10 product_id ,sum (sale_price) as sales  from df_orders group by product_id order by sales desc;

--/2.find top 5 highest selling products in each region
with cte as(
select  product_id,region,sum (sale_price) as sales 
from  df_orders 
group by region,product_id)
select *from(
select *,ROW_NUMBER() over (partition by region order by sales desc)as rn 
from cte)A 
where rn<=5;

--/3.find over month growth comparison for 2022 and 2023 sales jan 2022 vs jan 2023
with cte as(
select year(order_date)as orderyear,month(order_date)as ordermonth ,sum(sale_price) as sales from df_orders 
group by year(order_date),month(order_date)
--order by year(order_date),month(order_date)
)
select ordermonth,
sum(case when orderyear= 2022 then sales else 0 end)as sales2022,
sum(case when orderyear= 2023 then sales else 0 end)as sales2023
from cte
group by ordermonth
order by ordermonth;

--/4.for each category which month had highest sales
with cte as(
select category,format(order_date,'yyyyMM')as orderyearmonth,sum (sale_price) as sales from df_orders
group by category,format(order_date,'yyyyMM')
)
--order by category,format(order_date,'yyyymm')(in sub equery order by clause will not work)
select* from(
select *,ROW_NUMBER() over (partition by category order by sales desc)as rn from cte)A
where rn=1

--/5.which sub category had highest growth by profit in 2023 compare to 2022
with cte as(
select sub_category, year(order_date)as orderyear,month(order_date)as ordermonth ,sum(sale_price) as sales from df_orders 
group by sub_category,year(order_date),month(order_date)
--order by year(order_date),month(order_date)
)
,cte2 as(
select sub_category,
sum(case when orderyear= 2022 then sales else 0 end)as sales2022,
sum(case when orderyear= 2023 then sales else 0 end)as sales2023
from cte
group by sub_category)
select top 1*,(sales2023-sales2022)
from cte2
order by (sales2023-sales2022)desc;

--/6 Create a stored procedure to fetch the result according to the productid from df_Orders Table.
create procedure product_id
as
begin
select *from df_Orders
end;

execute product_id;

select*from df_Orders;

--/7display triggers for df_Orders table
create trigger triggerinsert
on df_Orders
for insert
as
begin
 declare @product_id int
 select @product_id = product_id from inserted
 insert into table_audit_test
 values('new productid =' +cast (@product_id as nvarchar(10))+ 'is added at' + cast (getdate()as nvarchar (20))
 )
 end;

 create table table_audit
 (auditdetails varchar(100))

 --/8. Create a user-defined function for the df_Orders table to fetch a particular product  based upon the user’s preference
create function getcategory(@category as varchar (40))
returns table
as
return (SELECT *FROM df_Orders  WHERE category=@category)

select * from dbo.getcategory('Furniture')

--/9. If there is an increase in sales of 5%, calculate the increasedsales.
select  product_id,sale_price,sale_price*5/(select sum (sale_price) from  df_Orders) as  increasedsales
from df_Orders order by  sale_price desc;

--/10.create index for fact table and delete

--/create
create index demo
on df_Orders (profit,sale_price);
--/delete
drop index df_Orders.demo

--/find
 sp_helpindex df_Orders;

