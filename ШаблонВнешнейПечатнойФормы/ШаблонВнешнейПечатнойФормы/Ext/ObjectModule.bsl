﻿#Область ПрограммныйИнтерфейс

Функция СведенияОВнешнейОбработке() Экспорт
	
	Сведения = ДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке();
	Сведения.Вид 			= ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиПечатнаяФорма();
	Сведения.Версия 		= "1.0";
	Сведения.Наименование 	= "Шаблон внешней печатной формы";
	Сведения.Информация 	= "Это шаблон для создания внешней печатной формы";
	
	Сведения.Назначение.Добавить("Документ.<вид документа>");
	
	Команда = Сведения.Команды.Добавить();
	Команда.Идентификатор 	= "ШаблонВнешнейПечатнойФормы";
	Команда.Представление 	= "Шаблон внешней печатной формы";
	Команда.Использование 	= ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыВызовСерверногоМетода();
	Команда.Модификатор		= "ПечатьMXL";
	
	Возврат Сведения;
	
КонецФункции

Функция Печать(МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт

	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ШаблонВнешнейПечатнойФормы") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
			"ШаблонВнешнейПечатнойФормы",
			"Шаблон внешней печатной формы",
			СформироватьПечатнуюФорму(МассивОбъектов, ОбъектыПечати));
		
	КонецЕсли;

КонецФункции // Печать()
	
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьДанныеПечати(МассивОбъектов)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Шапка.Ссылка КАК Ссылка,
	|	Шапка.Дата КАК Дата,
	|	Шапка.Номер КАК Номер
	|ИЗ
	|	Документ.<вид документа> КАК Шапка
	|ГДЕ
	|	Шапка.Ссылка В(&МассивОбъектов)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТабличнаяЧасть.Ссылка КАК Ссылка,
	|	ТабличнаяЧасть.НомерСтроки КАК НомерСтроки
	|ИЗ
	|	Документ.<вид документа>.<имя табличной части> КАК ТабличнаяЧасть
	|ГДЕ
	|	ТабличнаяЧасть.Ссылка В(&МассивОбъектов)";
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	ВыборкаШапка 	= МассивРезультатов[0].Выбрать();
	ВыборкаСтроки 	= МассивРезультатов[1].Выбрать();
	
	Результат = Новый Структура;
	Результат.Вставить("ВыборкаШапка", 	ВыборкаШапка);
	Результат.Вставить("ВыборкаСтроки", ВыборкаСтроки);
	
	Возврат Результат;
	
КонецФункции

функция СформироватьПечатнуюФорму(МассивОбъектов, ОбъектыПечати)
	
	Макет = ПолучитьМакет("Макет");
	
	ОбластьШапка 	= Макет.ПолучитьОбласть("Шапка");
	ОбластьСтрока 	= Макет.ПолучитьОбласть("Строка");
	
	ДанныеПечати = ПолучитьДанныеПечати(МассивОбъектов);
	ВыборкаШапка = ДанныеПечати.ВыборкаШапка;
	ВыборкаСтроки = ДанныеПечати.ВыборкаСтроки;
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	Пока ВыборкаШапка.Следующий() Цикл
		
		Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда			
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();			
		КонецЕсли;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// заполнение табличного документа
		ОбластьШапка.Параметры.Заполнить(ВыборкаШапка);
		
		ТабличныйДокумент.Вывести(ОбластьШапка);
		
		Пока ВыборкаСтроки.НайтиСледующий(Новый Структура("Ссылка", ВыборкаШапка.Ссылка)) Цикл
			
			ОбластьСтрока.Параметры.Заполнить(ВыборкаСтроки);
			
			ТабличныйДокумент.Вывести(ОбластьСтрока);
		
		КонецЦикла;
		
		// конец заполнение табличного документа
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент,
			НомерСтрокиНачало,
			ОбъектыПечати,
			ВыборкаШапка.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

#КонецОбласти