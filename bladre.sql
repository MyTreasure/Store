Запити: 
1. Вибірка замовлень по групі товарів   
    загалом
     
    SELECT 
           c.client_name
         , pg.product_group_name
         , p.product_name
         , o.order_time
         , o.order_date
         , o.order_day_of_week
         , pl.platform
         , o.price
         , pm.payment_method
         , o.feedback
    FROM orders o 
    LEFT JOIN clients c ON o.client_id = c.client_id
    LEFT JOIN product_groups pg ON o.product_group_id = pg.product_group_id
    LEFT JOIN products p ON o.product_id = p.product_id
    LEFT JOIN platforms pl ON o.platform_id = pl.platform_id
    LEFT JOIN payment_methods pm ON o.payment_method_id = pm.payment_method_id
    WHERE pg.product_group = 'bla-bla'
    ;
         
     
    за вибраний період
     
    SELECT 
         , c.client_name
         , pg.product_group
         , p.product_name
         , o.order_time
         , o.order_date
         , o.order_day_of_week
         , pl.platform
         , o.price
         , pm.payment_method
         , o.feedback    
    FROM orders o 
    LEFT JOIN clients c ON o.client_id = c.client_id
    LEFT JOIN product_groups pg ON o.product_group_id = pg.product_group_id
    LEFT JOIN products p ON o.product_id = p.product_id
    LEFT JOIN platforms pl ON o.platform_id = pl.platform_id
    LEFT JOIN payment_methods pm ON o.payment_method_id = pm.payment_method_id
    WHERE pg.product_group = 'bla-bla'
    AND o.date between 'start_date' AND 'end_date'
 
     
    по сумі замовлення
     
    SELECT 
         , c.client_name
         , pg.product_group
         , p.product_name
         , o.order_time
         , o.order_date
         , o.order_day_of_week
         , pl.platform
         , o.price
         , pm.payment_method
         , o.feedback    
    FROM orders o 
    LEFT JOIN clients c ON o.client_id = c.client_id
    LEFT JOIN product_groups pg ON o.product_group_id = pg.product_group_id
    LEFT JOIN products p ON o.product_id = p.product_id
    LEFT JOIN platforms pl ON o.platform_id = pl.platform_id
    LEFT JOIN payment_methods pm ON o.payment_method_id = pm.payment_method_id
    WHERE pg.product_group = 'bla-bla'
    AND price > start_price
     
2. Вибірка частоти клієнтів в замовленнях
 
    SELECT 
           c.client_name
         , count(order_id)
    FROM orders o 
    LEFT JOIN clients c ON o.client_id = c.client_id
    GROUP BY 1
 
 
    також по сумі замовлення
 
    SELECT 
           c.client_name
         , count(o.order_id)
         , sum(o.price)
    FROM orders o 
    LEFT JOIN clients c ON o.client_id = c.client_id
    GROUP BY 1
 
3. Частота замовлень в певний час доби
 
    SELECT 
           pg.product_group
         , p.product_name
         , hour(o.order_time)
         , count(o.order_id)
    FROM orders o
    LEFT JOIN product_groups pg ON o.product_group_id = pg.product_group_id
    LEFT JOIN products p ON o.product_id = p.product_id
    GROUP BY 1,2,3
    ORDER BY 3
 
4. Частота замовлень по дням тижня
     
    SELECT 
           pg.product_group
         , p.product_name
         , o.order_day_of_week
         , count(o.order_id)
    FROM orders o
    LEFT JOIN product_groups pg ON o.product_group_id = pg.product_group_id
    LEFT JOIN products p ON o.product_id = p.product_id
    GROUP BY 1,2,3
    ORDER BY 3
 
5. Фідбек по замовленнях
 
    SELECT 
         , c.client_name
         , pg.product_group
         , p.product_name
         , o.feedback
    FROM orders o 
    LEFT JOIN clients c ON o.client_id = c.client_id
    LEFT JOIN product_groups pg ON o.product_group_id = pg.product_group_id
    LEFT JOIN products p ON o.product_id = p.product_id
    WHERE o.feedback IS NOT NULL
    ORDER BY 1,2,3
 
    також список замовлень без фідбека
 
    SELECT 
         , c.client_name
         , pg.product_group
         , p.product_name
         , o.feedback
    FROM orders o 
    LEFT JOIN clients c ON o.client_id = c.client_id
    LEFT JOIN product_groups pg ON o.product_group_id = pg.product_group_id
    LEFT JOIN products p ON o.product_id = p.product_id
    WHERE o.feedback IS NULL
    ORDER BY 1,2,3
 
6. Останнє замовлення клієнта
    (по часу давності)
     
    SELECT 
         , c.client_name
         , pg.product_group
         , p.product_name
         , o.order_time
         , o.order_date
         , o.order_day_of_week
         , pl.platform
         , o.price
         , pm.payment_method
         , o.feedback    
    FROM orders o 
    LEFT JOIN clients c ON o.client_id = c.client_id
    LEFT JOIN product_groups pg ON o.product_group_id = pg.product_group_id
    LEFT JOIN products p ON o.product_id = p.product_id
    LEFT JOIN platforms pl ON o.platform_id = pl.platform_id
    LEFT JOIN payment_methods pm ON o.payment_method_id = pm.payment_method_id
    INNER JOIN
        (SELECT client_id, max(order_date), max(order_time) FROM orders) max_date ON o.client_id = max_date.client_id
    ORDER BY 1
 
7. Загальна виручка по групі товарів    
 
    SELECT 
            pg.product_group,
            sum(o.price)
    FROM orders o LEFT JOIN product_groups pg ON o.product_group_id = pg.product_group_id
    GROUP BY 1
 
8. Загальна виручка за місяць   
 
   SELECT 
            date_format(order_date, '%M'),
            sum(o.price)
    FROM orders o 
    WHERE month(order_date) = month(current_date()) 
      AND year(order_date) = year(current_date()) 
    GROUP BY 1
 
9. Загальна виручка по формі оплати 
 
    SELECT 
            pm.payment_method,
            sum(o.price)
    FROM orders o LEFT JOIN payment_methods pm ON o.payment_method_id = pm.payment_method_id
    GROUP BY 1
 
10. Частота використання форми оплати   
 
    SELECT 
            pm.payment_method,
            count(*)
    FROM orders o LEFT JOIN payment_methods pm ON o.payment_method_id = pm.payment_method_id
    GROUP BY 1
 
11. Загальна виручка по площадці    
 
    SELECT 
            pl.platform,
            sum(o.price)
    FROM orders o LEFT JOIN platforms pl ON o.platform_id = pl.platform_id
    GROUP BY 1
 
12. Загальна виручка по клієнту 
 
    SELECT 
            c.client_name,
            sum(o.price)
    FROM orders o LEFT JOIN clients c ON o.client_id = c.client_id
    GROUP BY 1