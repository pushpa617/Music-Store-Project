select * from employee

--senior  most employee
select top 1 last_name,first_name
from employee
order by levels desc

--country ith most invoices
select * from invoice
select * from invoice_line
select * from customer

select top 1 billing_country,count(billing_country)
from invoice
group by billing_country
order by count(billing_country) desc

--top 3 of total invoice
select top 3 total,billing_country
from invoice
order by total desc

--best country(most invoices)
select top 1 billing_country, sum(total)
from invoice
group by billing_country
order by sum(total) desc

--best customer who spends most invoices
select * from customer

select c.first_name,c.last_name,sum(i.total)
from customer c
join invoice i on
 c.customer_id=i.customer_id
 group by c.first_name,c.last_name
 order by sum(i.total) desc

 --

 select * from invoice_line
 select* from track
 select * from customer
  select * from invoice
  select * from genre
--first name,lastname,emaild of customers ho listen to rock genre
select distinct first_name,last_name, email
from customer c
join invoice i on c.customer_id= i.customer_id
join invoice_line n on n.invoice_id=i.invoice_id
join track t on n.track_id=n.track_id
join genre g on g.genre_id=t.genre_id
where g.genre_id like 1
order by email

--artist name who have ritten the most track music of rock genre

select * from artist
 select* from track
 --select * from invoice_line
 select* from album
 select * from genre

select a.name, count( al.album_id)
from artist a
join album al on al.artist_id=a.artist_id
join track t on t.album_id=al.album_id
where t.genre_id=1
group by a.name
order by count( al.album_id) desc

--track names longerthan avg song length

select name,milliseconds
from track
where milliseconds>(select AVG(cast(milliseconds as bigint)) from track)
order by milliseconds desc

--amount spent on artist by customers
select *from customer
select *from invoice
select *from invoice_line
select *from artist
select *from album
select *from track

select first_name,last_name,a.name,sum(il.unit_price*il.quantity) as price
from customer c
join invoice i on c.customer_id=i.customer_id
join invoice_line il on il.invoice_id=i.invoice_id
join track t on t.track_id=il.track_id
join album al on al.album_id=t.album_id
join artist a on a.artist_id=al.artist_id
group by first_name,last_name,a.name 
order by sum(il.unit_price*il.quantity) desc;

--country ith top genre
select *from customer
select *from genre
select *from invoice
select *from invoice_line
select *from track

with pop_genre as
(
select g.name,c.country,sum(il.quantity*il.unit_price) as total,count(il.quantity) as purchases,
row_number() over (partition by c.country order by count(il.quantity) desc) as number
from track t
join genre g on g.genre_id=t.genre_id
join invoice_line il on il.track_id=t.track_id
join invoice i on i.invoice_id=il.invoice_id
join customer c on c.customer_id=i.customer_id
group by c.country,g.name

)
select * 
from pop_genre where number<=1 

--customer that has spent most from each country
with cte as(
select c.country,c.first_name,c.last_name,sum(il.quantity*il.unit_price) as total,
ROW_NUMBER() over (partition by c.country order by sum(il.quantity) desc) as num
from track t
join genre g on g.genre_id=t.genre_id
join invoice_line il on il.track_id=t.track_id
join invoice i on i.invoice_id=il.invoice_id
join customer c on c.customer_id=i.customer_id
group by c.country,c.first_name,c.last_name)
select * from cte where num<=1


