Перем УправлениеСписком;

Функция УдалитьКаталог(ПутьКаталога)
	Попытка
		УдалитьФайлы(ПутьКаталога);	
	Исключение
		Сообщить(ОписаниеОшибки());
	КонецПопытки;
	

КонецФункции // УдалитьКешБазы(База)

///  Очищает кеш всех баз из файла ibases.v8i
//
Функция ОчиститьВесьКеш() Экспорт
	
	СИ = Новый СистемнаяИнформация;
	Окружение = СИ.ПеременныеСреды();

	ПутьКФайлуСпискаБаз = Окружение.Получить("USERPROFILE")+"\appdata\roaming\1c\1cestart\ibases.v8i";
	СписокБаз = УправлениеСписком.ПолучитьСписокБаз(ПутьКФайлуСпискаБаз);

	Для каждого Стр Из СписокБаз Цикл
		База = Стр.Значение;

		Сообщить("Очистка кеша базы: " + База.Name);
		КаталогКеша = Окружение.Получить("USERPROFILE")+"\appdata\local\1c\1cv8\" + База.ID;
		УдалитьКаталог(КаталогКеша);

	КонецЦикла;

	Возврат Истина;
КонецФункции // ОчиститьВесьКеш()

///  Очищает кеш базы
//
// Параметры:
//  Параметры      - Структура - Ключ: "Путь", Значение: Путь к БД;
//
// Возвращаемое значение:
//  Булево - Очистка прошла успешно/не успешно
// 
Функция ОчиститьКешБазы(Параметры) Экспорт
	СИ = Новый СистемнаяИнформация;
	Окружение = СИ.ПеременныеСреды();

	ПутьКФайлуСпискаБаз = Окружение.Получить("USERPROFILE")+"\appdata\roaming\1c\1cestart\ibases.v8i";
	СписокБаз = УправлениеСписком.ПолучитьСписокБаз(ПутьКФайлуСпискаБаз);
	ПутьОчистки = "";
	Для каждого Стр Из СписокБаз Цикл
		База = Стр.Значение;

		Если База.Свойство("Connect") Тогда
			СтрБ = База.Connect.Structure;
			Если СтрБ.Свойство("File") Тогда
				Если ВРЕГ(СтрБ.File) = ВРег(Параметры.Путь) Тогда
					ПутьОчистки = Окружение.Получить("USERPROFILE")+"\appdata\local\1c\1cv8\" + База.ID;
					Прервать;
				КонецЕсли;
			ИначеЕсли СтрБ.Свойство("ws") Тогда
				Если ВРЕГ(СтрБ.ws) = ВРег(Параметры.Путь) Тогда
					ПутьОчистки = Окружение.Получить("USERPROFILE")+"\appdata\local\1c\1cv8\" + База.ID;
					Прервать;
				КонецЕсли;
			ИначеЕсли СтрБ.Свойство("Srvr") Тогда
				Если ВРЕГ(СтрБ.Srvr) = ВРег(Параметры.Путь) Тогда
					ПутьОчистки = Окружение.Получить("USERPROFILE")+"\appdata\local\1c\1cv8\" + База.ID;
					Прервать;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;

	КонецЦикла;

	Если СокрЛП(ПутьОчистки) <> "" Тогда
		УдалитьКаталог(ПутьОчистки);
		Возврат Истина;
	КонецЕсли;

	Возврат Ложь;
КонецФункции

Процедура Выполнить(Параметры)
	Если Параметры[0] = "all" Тогда
		ОчиститьВесьКеш();
	ИначеЕсли СокрЛП(Параметры[0]) = "P" Тогда
		Инфо = Новый Структура();
		Инфо.Вставить("Путь",""""+Параметры[1]+"""");
		Результат = ОчиститьКешБазы(Инфо);
		Если Результат = Истина Тогда
			Сообщить("Очищен кеш: " + Инфо.Путь);
		Иначе
			Сообщить("Возникли проблемы при очистке кеша: " + Инфо.Путь);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

УправлениеСписком = ЗагрузитьСценарий("parserV8i.os");

Выполнить(АргументыКоманднойСтроки);

// МассивПарамеров = новый Массив;
// МассивПарамеров.Добавить("all");
// МассивПарамеров.Добавить("P");
// МассивПарамеров.Добавить("c:\work\db\v8_tasks\");

// Выполнить(МассивПарамеров);