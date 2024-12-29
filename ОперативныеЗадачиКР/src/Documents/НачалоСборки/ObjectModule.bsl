
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	//{{__КОНСТРУКТОР_ВВОД_НА_ОСНОВАНИИ
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаказПокупателя") Тогда
		// Заполнение шапки
		Компьютер = ДанныеЗаполнения.Компьютер;
		ДокументОснование = ДанныеЗаполнения.Ссылка;
		Для Каждого ТекСтрокаСпецификацияКомпьютера Из ДанныеЗаполнения.СпецификацияКомпьютера Цикл
			НоваяСтрока = СпецификацияКомпьютера.Добавить();
			НоваяСтрока.Количество = ТекСтрокаСпецификацияКомпьютера.Количество;
			НоваяСтрока.Комплектующая = ТекСтрокаСпецификацияКомпьютера.Комплектующая;
			НоваяСтрока.Свойство = ТекСтрокаСпецификацияКомпьютера.Свойство;
		КонецЦикла;
	КонецЕсли;
	//}}__КОНСТРУКТОР_ВВОД_НА_ОСНОВАНИИ
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)
	
	ЗаполнитьНаборЗаписей_ОстаткиКомплектующих();
	Движения.Записать();  //Записываем в базу данных данные из набора записей по регистру "Остатки комплектующий"
	                      //После этого регистр пересчитает остатки и мы их будем проверять. Если что-то "уйдет в минус" значит этого количества нет на складе и документ нельзя проводить!!
	ДанныеДляКонтроля = ПолучитьДанныеДляКонтроля(); // В этой переменной массив, состоящий из трех элементов (Вы еще помните, что в пакете было три запроса)
	                                                 //Нас интересует второй результат запроса
	РезультатЗапроса = ДанныеДляКонтроля[1];
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		//Если мы зашли в цикл хоть один раз, значит какая то комплектующая "ушла в минус"
		
		Отказ = Истина;
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "На складе комплектующих отсутствует " + Выборка.КомплектующаяПредставление
		+ ". Нехватка состовляет " + (-Выборка.РегКол);
		Сообщение.Сообщить();
		
	КонецЦикла;
	
	Если Не Отказ Тогда 
		
		ЗаполнитьНаборЗаписей_КомплектющиеВСборке();
		
	КонецЕсли;
	
	Если Отказ Тогда 
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Документ " + Ссылка + " не проведен!";
		Сообщение.Сообщить();
		
	КонецЕсли;

КонецПроцедуры

Функция ПолучитьДанныеДляКонтроля() 	
	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НачалоСборкиСпецификацияКомпьютера.Комплектующая,
	|	СУММА(НачалоСборкиСпецификацияКомпьютера.Количество) КАК Количество
	|ПОМЕСТИТЬ ТабДок
	|ИЗ
	|	Документ.НачалоСборки.СпецификацияКомпьютера КАК НачалоСборкиСпецификацияКомпьютера
	|ГДЕ
	|	НачалоСборкиСпецификацияКомпьютера.Ссылка = &СсылкаНаТекущийДокумент
	|
	|СГРУППИРОВАТЬ ПО
	|	НачалоСборкиСпецификацияКомпьютера.Комплектующая
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОстаткиКомплектующихОстатки.Комплектующая.Представление,
	|	ОстаткиКомплектующихОстатки.КоличествоОстаток КАК РегКол
	|ИЗ
	|	РегистрНакопления.ОстаткиКомплектующих.Остатки(
	|			&МоментВремени,
	|			Комплектующая В
	|				(ВЫБРАТЬ
	|					ТабДок.Комплектующая
	|				ИЗ
	|					ТабДок КАК ТабДок)) КАК ОстаткиКомплектующихОстатки
	|ГДЕ
	|	ОстаткиКомплектующихОстатки.КоличествоОстаток < 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ТабДок";
	
	ТочкаНаВременнойОсиСразуПослеМоментаВремени = Новый Граница(МоментВремени(), ВидГраницы.Включая);

	Запрос.УстановитьПараметр("МоментВремени", ТочкаНаВременнойОсиСразуПослеМоментаВремени);
	Запрос.УстановитьПараметр("СсылкаНаТекущийДокумент", Ссылка);

    Возврат Запрос.ВыполнитьПакет();  //Метод возрващает массив результатов запроса
	
КонецФункции

Процедура ЗаполнитьНаборЗаписей_ОстаткиКомплектующих()
	
	Движения.ОстаткиКомплектующих.Записывать = Истина;
	
	Для Каждого ТекСтрокаСпецификацияКомпьютера Из СпецификацияКомпьютера Цикл
		
		Движение = Движения.ОстаткиКомплектующих.Добавить();
		
		Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		Движение.Период = Дата;
		
		Движение.Комплектующая = ТекСтрокаСпецификацияКомпьютера.Комплектующая;
		
		Движение.Количество = ТекСтрокаСпецификацияКомпьютера.Количество;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьНаборЗаписей_КомплектющиеВСборке()
	
	Движения.КомплектющиеВСборке.Записывать = Истина;
	
	Для Каждого ТекСтрокаСпецификацияКомпьютера Из СпецификацияКомпьютера Цикл
		
		Движение = Движения.КомплектющиеВСборке.Добавить();
		
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Период = Дата;
		
		Движение.Заказ = ДокументОснование;
		Движение.Комплектующая = ТекСтрокаСпецификацияКомпьютера.Комплектующая;
		
		Движение.Количество = ТекСтрокаСпецификацияКомпьютера.Количество;
		
	КонецЦикла;
	
КонецПроцедуры
