-- сначала посмотрим какие кредиты брались и в какие года
select name_product_type, date_credit from Parameters_application_form 
					join Product_type on Parameters_application_form.product_type=Product_type.id_product_type;

-- затем уже самый популярный вид продукта за текущий год
select name_product_type, count(*) as count_product from Parameters_application_form 
					join Product_type on Parameters_application_form.product_type=Product_type.id_product_type
					where date_part('year', date_credit) = date_part('year', current_date)
					group by name_product_type
					order by count_product desc limit 1;






