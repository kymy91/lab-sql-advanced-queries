/*Lab | SQL Advanced queries
In this lab, you will be using the Sakila database of movie rentals.

Instructions
List each pair of actors that have worked together.*/
USE sakila;

-- Q1 List each pair of actors that have worked together.

with cte_actors as (
select film_id, a.actor_id, b.first_name, b.last_name
from sakila.film_actor as a
join sakila.actor as b
on a.actor_id = b.actor_id
group by film_id, actor_id
order by actor_id
)
select a2.film_id, a2.actor_id as Actor, a2.first_name, a2.last_name, 
b2.actor_id as Partner, c.first_name, c.last_name
from cte_actors as a2
join sakila.film_actor as b2
on a2.film_id = b2.film_id
and a2.actor_id <> b2.actor_id
join sakila.actor as c
on b2.actor_id = c.actor_id;

#Check with previous work: 
select concat(aa.first_name, ' ', aa.last_name) As Actor1, 
concat(ac.first_name, ' ', ac.last_name) as Actor2, ff.film_id
from actor as  aa
inner join film_actor as  fa on aa.actor_id = fa.actor_id
inner join film_actor as ff on fa.film_id = ff.film_id
inner join actor ac on ac.actor_id = ff.actor_id
where fa.actor_id > ff.actor_id;
# return 14915

-- Q2 For each film, list actor that has acted in more films.
select a.film_id, b.title, a.actor_id 
from sakila.film_actor as a
join sakila.film as b
on a.film_id = b.film_id
where actor_id in (
	select actor_id from (
		select actor_id, count(film_id) as Counter
		from sakila.film_actor
		group by  actor_id
		order by Counter desc) sub1)
order by actor_id;

#inner query
select actor_id from (select actor_id, count(film_id) as n_films from film_actor
group by actor_id
order by n_films desc) as sub_test;