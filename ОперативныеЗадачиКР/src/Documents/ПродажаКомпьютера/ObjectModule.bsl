
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаказПокупателя") Тогда

		Клиент = ДанныеЗаполнения.Клиент;
		Компьютер = ДанныеЗаполнения.Компьютер;
		ДокументОснование = ДанныеЗаполнения.Ссылка;
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)

	ЗаполнитьНаборЗаписей_ГотовыеКомпьютеры();
	Движения.Записать();
	
	ДанныеДляКонтроля = ПолучитьДанныеДляКонтроля();
	
	Выборка = ДанныеДляКонтроля.Выбрать();
	
	Выборка.Следующий(); //Из запроса всегда будем получать одну строку 
	
	Если НЕ Выборка.РегКол = 0 Тогда
		
		Если Режим = РежимПроведенияДокумента.Оперативный Тогда 
			Отказ = Истина;
		КонецЕсли;
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "На складе готовых компьютеров нет компьютера под этот Заказ";
		Сообщение.Сообщить();
		
	КонецЕсли;
	
	Если Отказ Тогда 
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Документ " + Ссылка + " не проведен!";
		Сообщение.Сообщить();
		
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьДанныеДляКонтроля()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЕСТЬNULL(ГотовыеКомпьютерыОстатки.КоличествоОстаток, 0) КАК РегКол
	|ИЗ
	|	РегистрНакопления.ГотовыеКомпьютеры.Остатки(&МоментВремени, Заказ = &ДокументОснование) КАК ГотовыеКомпьютерыОстатки";
	
	ТочкаНаВременнойОсиСразуПослеМоментаВремени = Новый Граница(МоментВремени(), ВидГраницы.Включая);
	
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	Запрос.УстановитьПараметр("МоментВремени", ТочкаНаВременнойОсиСразуПослеМоментаВремени);

	Возврат Запрос.Выполнить();
	
КонецФункции

Процедура ЗаполнитьНаборЗаписей_ГотовыеКомпьютеры()
	
	Движения.ГотовыеКомпьютеры.Записывать = Истина;
	
	Движение = Движения.ГотовыеКомпьютеры.Добавить();
	
	Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
	Движение.Период = Дата;
	
	Движение.Заказ = ДокументОснование;
	Движение.Компьютер = Компьютер;
	
	Движение.Количество = 1;
	
КонецПроцедуры

