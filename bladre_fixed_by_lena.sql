Запити: 
1. Вибірка замовлень по групі товарів   
    загалом
     
    SELECT 
           c.client_name
         , pg.product_group_name
         , p.product_name
         , o.created_date::date
         , pl.platform_name
         , pr.price
         , pm.payment_method_name
         , o.feedback
    FROM orders o 
    LEFT JOIN clients c ON o.client_id = c.client_id
    LEFT JOIN products p ON o.product_id = p.product_id
    LEFT JOIN product_groups pg ON p.product_group_id = pg.product_group_id
    LEFT JOIN platforms pl ON o.platform_id = pl.platform_id
    LEFT JOIN payment_methods pm ON o.payment_method_id = pm.payment_method_id
    LEFT JOIN prices pr ON o.price_id = pr.price_id
    WHERE pg.product_group_id = 1
    AND pr.price_due_date IS NULL
    ;
         
     
    за вибраний період
     
    SELECT 
           c.client_name
         , pg.product_group_name
         , p.product_name
         , o.created_date::date
         , pl.platform_name
         , pr.price
         , pm.payment_method_name
         , o.feedback
    FROM orders o 
    LEFT JOIN clients c ON o.client_id = c.client_id
    LEFT JOIN products p ON o.product_id = p.product_id
    LEFT JOIN product_groups pg ON p.product_group_id = pg.product_group_id
    LEFT JOIN platforms pl ON o.platform_id = pl.platform_id
    LEFT JOIN payment_methods pm ON o.payment_method_id = pm.payment_method_id
    LEFT JOIN prices pr ON o.price_id = pr.price_id
    WHERE pg.product_group_id = 1
    AND (o.created_date between '2015-01-23' AND '2015-02-02'
    	OR o.modified_date between '2015-01-23' AND '2015-02-02')
 ;
    

    -- this one needs to be modified 
    по сумі замовлення
     
    SELECT 
           c.client_name
         , pg.product_group_name
         , p.product_name
         , o.created_date::date
         , pl.platform_name
         , pr.price
         , pm.payment_method_name
         , o.feedback
    FROM orders o 
    LEFT JOIN clients c ON o.client_id = c.client_id
    LEFT JOIN products p ON o.product_id = p.product_id
    LEFT JOIN product_groups pg ON p.product_group_id = pg.product_group_id
    LEFT JOIN platforms pl ON o.platform_id = pl.platform_id
    LEFT JOIN payment_methods pm ON o.payment_method_id = pm.payment_method_id
    LEFT JOIN prices pr ON o.price_id = pr.price_id
    WHERE pg.product_group_id = 1
    AND pr.price > start_price
     
2. Вибірка частоти клієнтів в замовленнях
 
    SELECT 
           c.client_name
         , count(order_id) AS number_of_orders
    FROM orders o 
    LEFT JOIN clients c ON o.client_id = c.client_id
    GROUP BY 1
    ORDER BY 2 DESC;
 
    також по сумі замовлення
 
    SELECT 
           c.client_name
         , count(o.order_id) AS number_of_orders
         , sum(pr.price) AS earnings
    FROM orders o 
    LEFT JOIN clients c ON o.client_id = c.client_id
    LEFT JOIN prices pr ON o.price_id = pr.price_id 
    GROUP BY 1
    ORDER BY 3 DESC;
 
3. Частота замовлень в певний час доби
 
    SELECT 
           pg.product_group_name
         , p.product_name
         , date_part('hour',o.created_date) AS hours
         , count(o.order_id) AS number_of_orders
    FROM orders o
    LEFT JOIN products p ON o.product_id = p.product_id
    LEFT JOIN product_groups pg ON p.product_group_id = pg.product_group_id
    GROUP BY 1,2,3
    ORDER BY 3
 
4. Частота замовлень по дням тижня
     
    SELECT 
           pg.product_group_name
         , p.product_name
         , date_part('dow',o.created_date) AS day_of_week
         , count(o.order_id) AS number_of_orders
    FROM orders o
    LEFT JOIN products p ON o.product_id = p.product_id
    LEFT JOIN product_groups pg ON p.product_group_id = pg.product_group_id
    GROUP BY 1,2,3
    ORDER BY 3
 
5. Фідбек по замовленнях
 
    SELECT 
           c.client_name
         , pg.product_group_name
         , p.product_name
         , o.feedback
    FROM orders o 
    LEFT JOIN clients c ON o.client_id = c.client_id
    LEFT JOIN products p ON o.product_id = p.product_id
    LEFT JOIN product_groups pg ON p.product_group_id = pg.product_group_id
    WHERE o.feedback IS NOT NULL
    ORDER BY 1,2,3
 
    також список замовлень без фідбека
 
    SELECT 
           c.client_name
         , pg.product_group_name
         , p.product_name
         , o.feedback
    FROM orders o 
    LEFT JOIN clients c ON o.client_id = c.client_id
    LEFT JOIN products p ON o.product_id = p.product_id
    LEFT JOIN product_groups pg ON p.product_group_id = pg.product_group_id
    WHERE o.feedback IS NULL
    ORDER BY 1,2,3
 
6. Останнє замовлення клієнта
    (по часу давності)
    -- Под вопросом 
    SELECT 
           c.client_name
         , pg.product_group_name
         , p.product_name
         , o.created_date
         , pl.platform_name
         , pr.price
         , pm.payment_method_name
         , o.feedback    
    FROM orders o 
    LEFT JOIN clients c ON o.client_id = c.client_id
    LEFT JOIN products p ON o.product_id = p.product_id
    LEFT JOIN product_groups pg ON p.product_group_id = pg.product_group_id
    LEFT JOIN platforms pl ON o.platform_id = pl.platform_id
    LEFT JOIN payment_methods pm ON o.payment_method_id = pm.payment_method_id
    LEFT JOIN prices pr ON o.price_id = pr.price_id
    INNER JOIN
        (SELECT client_id, max(created_date) AS created_date FROM orders GROUP BY 1) max_date 
        ON o.client_id = max_date.client_id AND o.created_date = max_date.created_date
    ORDER BY 1
 
7. Загальна виручка по групі товарів    
 
    SELECT 
            pg.product_group_name,
            sum(pr.price) AS earnings
    FROM orders o 
    LEFT JOIN products p ON o.product_id = p.product_id
    LEFT JOIN product_groups pg ON p.product_group_id = pg.product_group_id
    LEFT JOIN prices pr ON o.price_id = pr.price_id
    GROUP BY 1
    ORDER BY 2 DESC
 
8. Загальна виручка за місяць   
 
    SELECT 
           date_part('month',o.created_date) AS current_month
         , sum(pr.price) AS earnings
    FROM orders o
    LEFT JOIN prices pr ON o.price_id = pr.price_id 
    WHERE date_part('month',o.created_date) = date_part('month',now()) 
      AND date_part('year',o.created_date) = date_part('year',now())
    GROUP BY 1
 
9. Загальна виручка по формі оплати 
 
    SELECT 
            pm.payment_method_name,
            sum(pr.price) AS earnings
    FROM orders o 
    LEFT JOIN payment_methods pm ON o.payment_method_id = pm.payment_method_id
    LEFT JOIN prices pr ON o.price_id = pr.price_id 
    GROUP BY 1
    ORDER BY 2 DESC
 
10. Частота використання форми оплати   
 
    SELECT 
            pm.payment_method_name,
            count(*)
    FROM orders o 
    LEFT JOIN payment_methods pm ON o.payment_method_id = pm.payment_method_id
    GROUP BY 1
    ORDER BY 2 DESC
 
11. Загальна виручка по площадці    
 
    SELECT 
            pl.platform_name,
            sum(pr.price) AS earnings
    FROM orders o 
    LEFT JOIN platforms pl ON o.platform_id = pl.platform_id    
    LEFT JOIN prices pr ON o.price_id = pr.price_id 
    GROUP BY 1
    ORDER BY 2 DESC
 
12. Загальна виручка по клієнту 
 
    SELECT 
            c.client_name,
            sum(pr.price) AS earnings
    FROM orders o 
    LEFT JOIN clients c ON o.client_id = c.client_id
    LEFT JOIN prices pr ON o.price_id = pr.price_id 
    GROUP BY 1
    ORDER BY 2 DESC