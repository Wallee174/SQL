-- РЕШЕНИЕ ЗАДАНИЯ 1. получить все продажи произведенные в городе 'town1' за 2015 год
SELECT s.* -- все поля из таблицы продаж 
FROM sales s
INNER JOIN dep d
ON d.id = s.dep_id
AND d.city = 'town1' 
WHERE s.time >= to_date('01.01.2015', 'DD.MM.YYYY')
and s.time < to_date('01.01.2016', 'DD.MM.YYYY');

-- РЕШЕНИЕ ЗАДАНИЕ 2. показать все отделы, где в марте 2014 года были продажи товаров с ценой меньше 500.
-- По поводу этого задания - я не совсем понял формулировку. Поэтому сделал два варианта. Но мне кажется, что цена товара - это price в таблице prod
-- 1-ый вариант, если price в таблице prod

select distinct s.det_id -- показать все отделы
from sales s
inner join prod p
on p.id = s.prod_id
where s.time >= to_date('01.03.2014', 'DD.MM.YYYY') --  где в марте 2014 года
and s.time < to_date('01.04.2014', 'DD.MM.YYYY')
and p.price < 500; -- были продажи товаров с ценой меньше 500

-- 2-ой вариант решения 2-го задания, если цена cost в таблице sales

SELECT D.name, SUM(cost)
FROM sales S
JOIN dep D ON S.dep_id = D.id
where s.time >= to_date('01.03.2014', 'DD.MM.YYYY') --  где в марте 2014 года
and s.time < to_date('01.04.2014', 'DD.MM.YYYY')
GROUP BY D.name
HAVING SUM(cost) < 500; -- меньше 500


-- РЕШЕНИЕ ЗАДАНИЯ 3. Увеличить цену в два раза у всех товаров, которые продавались в прошлом году в отделе 'dep10'
UPDATE prod p
SET p.price = p.price * 2 -- Увеличить цену в два раза у всех товаров
WHERE EXISTS
(
    SELECT 1
    FROM sales s
    INNER JOIN dep d
    ON d.id = s.dep_id
    AND d.name = 'dep10' -- в отделе 'dep10'
    WHERE s.prod_id = p.id
    AND s.time >= add_months(trunc(sysdate, 'Y'), -12)-- которые продавались в прошлом году
    AND s.time < trunc(sysdate, 'Y')
);
