/*****-----------ЗАДАНИЕ 1 -----------*********
удалить из таблицы AgentTask таски, которые никогда не запускались

ДАЛЕЕ РЕШЕНИЕ:
*/

DELETE FROM [PortalOne_QA_vkalanov_1].[dbo].[AgentTask]
WHERE [LastExecutionTime] is null							/*Где значение равно нулю */



/******----------- ЗАДАНИЕ 2 -----------******* 
вставить три новых настройки в таблицу [PortalOneSettingValue]:
- на уровне Common. Настройка - ClientAddress
- На уровне клиента для клиента Demo. Настройка - ClientCity
- на уровне портала для портала Generic Portal 2.0 Demo. Настройка - ClientEmail

Не использовать в квери айдишники настройки/портала или клиента напрямую. Использовать переменные вместо айдишников. В переменную записывается айдишник после его определения по имени.

ДАЛЕЕ РЕШЕНИЕ:
*/
 
DECLARE @SettingID1 int, @SettingID2 int, @SettingID3 int, @ClientDemo int, @PortalGeneric2demo int /*Задаю переменные */
SET @SettingID1 = (SELECT [SettingID] FROM [PortalOne_QA_vkalanov_1].[dbo].[Setting] WHERE [Name] = 'ClientAddress') /*Получаю значение Setting ID = 187 из таблицы Setting (соответствует настройке  ClientAdress*/
SET @SettingID2 = (SELECT [SettingID] FROM [PortalOne_QA_vkalanov_1].[dbo].[Setting] WHERE [Name] = 'ClientCity')    /*Получаю значение Setting ID = 188 из таблицы Setting (соответствует настройке  ClientCity */
SET @SettingID3 = (SELECT [SettingID] FROM [PortalOne_QA_vkalanov_1].[dbo].[Setting] WHERE [Name] = 'ClientEmail')   /* Получаю значение Setting ID = 189 из таблицы Setting (соответствует настройке  ClientEmail  */
SET @ClientDemo = (SELECT [ClientId] FROM [PortalOne_QA_vkalanov_1].[dbo].[Client] WHERE [Key] = 'Demo')			/* Получаю значение ClientID = 9 из таблица Client (соответствует переменной для клиента Demo   */ 
SET @PortalGeneric2demo = (SELECT [PortalId] FROM [PortalOne_QA_vkalanov_1].[dbo].[Portal] WHERE [PortalName] = 'Generic Portal 2.0 Demo')   /* Получаю значение PortalID = 12 ( соответствует переменной для портала Generic Portal 2.0 Demo  */

/*Можно сделать вывод переменных и посмотреть, всё ли выходит так
PRINT @SettingID1;
PRINT @SettingID2;
PRINT @SettingID3;
Print @ClientDemo;
Print @PortalGeneric2demo;
*****************************/

INSERT INTO [PortalOne_QA_vkalanov_1].[dbo].[PortalOneSettingValue] (SettingId)  VALUES (@SettingID1);								 /*Добавляем настройку ClientAddres на уровень Common  */
INSERT INTO [PortalOne_QA_vkalanov_1].[dbo].[PortalOneSettingValue] (SettingId, ClientId)  VALUES (@SettingID2, @ClientDemo);		/* Добавляем настройку ClientCity на уровень клиента для клиента Demo*/
INSERT INTO [PortalOne_QA_vkalanov_1].[dbo].[PortalOneSettingValue] (SettingId, PortalId)  VALUES (@SettingID3, @PortalGeneric2demo); /* Добавляем настройку ClientEmail на уровень портала для портала Generic Portal 2.0 Demo*/


/*****-----------ЗАДАНИЕ 3 ----------************
Обновить портальную настройку ProcessOneAuthenticationKey для портала GenericModal 2.0 Demo
Новый ключ должен соответствовать ключу инстанса XP_Sandbox мерчанта Test Merchant XP for failed Sweep

не использовать ключ, Id настройки b Id клиента напрямую. Не использовать переменные в учебных целях, реализовать всё на подселектах.

ДАЛЕЕ РЕШЕНИЕ:
*/


UPDATE [PortalOne_QA_vkalanov_1].[dbo].[PortalOneSettingValue] SET [Value] = 
(
	SELECT [AuthenticationKey] FROM [ProcessOne_QA_vkalanov_1].[dbo].[Instance] WHERE [MerchantID] =      /* Получаем значение Ключа по ИД мерча = 8 ,  ключ равен  "59215B23-D24A-4283-8627-F90B257D5147"  */ 
	   (
			SELECT [MerchantId] FROM [ProcessOne_QA_vkalanov_1].[dbo].[Merchant] WHERE [MerchantName] = 'Test Merchant XP for failed Sweep')  /*Определяем какой ИД у Мерчанта, на котором находится нужный нам ключ. ИД Мерча = 8  */ 
)
WHERE [PortalId] = 
(
	SELECT [PortalId] FROM [PortalOne_QA_vkalanov_1].[dbo].[Portal] WHERE [PortalName] = 'Generic Modal 2.0 Demo' /*Получает PortalID */
)
	AND 
	[SettingId] = 
(
	SELECT [SettingId] FROM [PortalOne_QA_vkalanov_1].[dbo].[Setting] WHERE [Name] = 'ProcessOneAuthenticationKey'   /* Получаем номер SettingID */
)



/*****--------------ЗАДАНИЕ 4 --------------*************
4.1) показать в одной таблице только номер телефона (customerPhone) CustomerID и имя кастомера. Если у кастомера нет привязанного номера телефон - не включать его в таблицу
4.2) показать в одной таблице только номер телефона (customerPhone) CustomerID и имя кастомера. Если у кастомера нет привязанного номера телефон - всё равно включить его в таблицу.

ДАЛЕЕ РЕШЕНИЕ:
*/ 

/*Решение 4.1. показать в одной таблице только номер телефона (customerPhone) CustomerID и имя кастомера. Если у кастомера нет привязанного номера телефон - не включать его в таблицу */
USE [PortalOne_QA_vkalanov_1]
SELECT [Customer].[CustomerName] as Customer, [Customer].[CustomerId] as ID, [CustomerPhone].[PhoneNumber] as Phone
FROM [CustomerPhone]
INNER JOIN [Customer] ON [CustomerPhone].[CustomerId] = [Customer].[CustomerId]         /*Получаем пересекающиеся значения из двух таблиц */
ORDER BY [CustomerName]


----------КРЕАТИВНЫЙ ПОДХОД №1---------------------
SELECT b.[CustomerName], b.[CustomerId], q.[PhoneNumber]
FROM [CustomerPhone] q
INNER JOIN [Customer] b 
ON q.[CustomerId] = b.[CustomerId]         
ORDER BY CustomerName

----------КРЕАТИВНЫЙ ПОДХОД №2------------------------
SELECT b.[CustomerName] as CustomerName, b.[CustomerId] as ID, q.[PhoneNumber] as Phone
FROM [CustomerPhone] q
INNER JOIN [Customer] b 
ON q.[CustomerId] = b.[CustomerId]         
ORDER BY CustomerName

----------------------------------------------------

/*Решение 4.2 показать в одной таблице только номер телефона (customerPhone) CustomerID и имя кастомера. Если у кастомера нет привязанного номера телефон - всё равно включить его в таблицу.*/

SELECT Customer.Customerid, PhoneNumber, CustomerName FROM [PortalOne_QA_vkalanov_1].[dbo].[CustomerPhone]
RIGHT JOIN Customer ON CustomerPhone.CustomerId = Customer.CustomerId      /*Получаем все значения из кастомера, не зависимо от наличия номера */


----------КРЕАТИВНЫЙ ПОДХОД -------------
USE [PortalOne_QA_vkalanov_1]
SELECT b.Customerid, q.PhoneNumber, b.CustomerName 
FROM CustomerPhone q
RIGHT JOIN Customer b
ON q.CustomerId = b.CustomerId  




SELECT * FROM [PolicyHash] PH
JOIN [PolicyHashPropertyValue] PHPV on PHPV.PolicyHashId = PH.PolicyHashId
JOIN [PolicyHashProperty] PHP on PHP.PolicyHashPropertyId = PHPV.PolicyHashPropertyId
WHERE PH.ClientId in (46)
ORDER BY PHPV.PolicyHashId

--------------------------------------


/*******------------------Задание 5---------------**************
Показать кастомеров, у которых привязано 2 и более платежных метода в таблице [PortalPaymentMethod]
ДАЛЕЕ РЕШЕНИЕ
*/

USE [PortalOne_AT_eshevchenko_1]							/*Используем нужную базу данных */
SELECT CustomerId, COUNT(PortalPaymentMethodId) as PortalPaymentMethodIDCount FROM PortalPaymentMethod
GROUP BY CustomerId
HAVING COUNT(PortalPaymentMethodId) >= 2						/*Делаем отбор по количеству от 2 и более */



/******-----------------Задание 6 ------------------******************
6.1) показать по каким полисам хоть раз проводилась успешная оплата кредитной картой (ChargeCC, ChargeCCNoFee) в таблице Transaction (поле ClientRefData1). Вывести только список этих полисов. Количество транзакций для полиса не имеет значения.

ДАЛЕЕ РЕШЕНИЕ: */

  SELECT DISTINCT [ClientRefData1] FROM [ProcessOne_qa_vkalanov_1].[dbo].[Transaction]       /*Выбираем нужную таблицу */
  WHERE [Status] = 2 AND Type IN (1,14)													 /*Успешность = 2,  Типы кредитных карт 1 и 14*/ 


/*
6.2) Показать список всех активных порталов, имеющих в названии "Module". Отсортировать по дате создания (порталы созданные позже - в начале списка). см. [dbo].[Portal]

ДАЛЕЕ РЕШЕНИЕ:  */

SELECT [PortalName], [Created]
 FROM [PortalOne_QA_vkalanov_1].[dbo].[Portal]
 WHERE [isActive] = 1 AND [PortalName] LIKE '%Module%'   /*Условие "Активный портал" = 1  и  "Имя Портала" = где в имени есть слово %Module% */ 
 ORDER BY [Created] DESC								/*Отсортировываем по дате */


/*
6.3) Показать все данные для транзакций от 100 до 200 влючительно (PostedAmount).

ДАЛЕЕ РЕШЕНИЕ:  */

SELECT * FROM [ProcessOne_QA_vkalanov_1].[dbo].[Transaction]   
WHERE [PostedAmount] BETWEEN 100 AND 200						 /* Где значение транзакции МЕЖДУ 100 и 200 */ 


/*
6.4) Показать все данные для транзакций типа 7,27,32,53,57,62

ДАЛЕЕ РЕШЕНИЕ:     */

SELECT * FROM [ProcessOne_QA_vkalanov_1].[dbo].[Transaction]  
WHERE [Type] IN (7,27,32,53,57,62)					/*  Где транзакции имеют конкретный тип */

-------------------------------------------------------------
------------------------- IT`S ALL. COMPLETE ----------------
-------------------------------------------------------------
