// Сравнивает две таблицы значений
//
// Параметры:
//  Таблица1	- ТаблицаЗначений - Первая таблица
//  Таблица2	- ТаблицаЗначений - Вторая таблица
//  Колонки	- Массив, Строка - Колонки сравниваемых таблиц
// 
// Возвращаемое значение:
// Булево - Возвращает Истина, если таблицы одинаковы, в противном случае - Ложь
//
&НаСервереБезКонтекста
Функция ТаблицыЗначенийОдинаковы(Таблица1, Таблица2, Колонки = Неопределено)
	
	Если Колонки = Неопределено Тогда
		КолонкиМассив = Новый Массив;
		Для Каждого ТекущаяКолонка Из Таблица1.Колонки Цикл
			КолонкиМассив.Добавить(ТекущаяКолонка.Имя);
		КонецЦикла;
		
		КолонкиСтрока = СтрСоединить(КолонкиМассив, ", ");
		
	ИначеЕсли ТипЗнч(Колонки) = Тип("Массив") Тогда
		КолонкиСтрока = СтрСоединить(КолонкиМассив, ", ");
	Иначе
		КолонкиСтрока = Колонки;
	КонецЕсли;
	
	ТипЧисло_10_0 = Новый ОписаниеТипов("Число", , , Новый КвалификаторыЧисла(10 , 0, ДопустимыйЗнак.Любой));
	ВременнаяТаблица = Таблица1.СкопироватьКолонки(КолонкиСтрока);
	ВременнаяТаблица.Колонки.Добавить("Знак", ТипЧисло_10_0);
		
	Для Каждого ТекущаяСтрока Из Таблица1 Цикл
		НоваяСтрока = ВременнаяТаблица.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущаяСтрока, КолонкиСтрока);
		НоваяСтрока.Знак = 1;
	КонецЦикла;
		
	Для Каждого ТекущаяСтрока Из Таблица2 Цикл
		НоваяСтрока = ВременнаяТаблица.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущаяСтрока, КолонкиСтрока);
		НоваяСтрока.Знак = -1;
	КонецЦикла;
	
	ВременнаяТаблица.Свернуть(КолонкиСтрока, "Знак");
	
	Для Каждого ТекущаяСтрока Из ВременнаяТаблица Цикл
		Если ТекущаяСтрока.Знак <> 0 Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции
