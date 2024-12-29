
Процедура ОбработкаПроведения(Отказ, Режим)
	//{{__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!

	// регистр ОстаткиКомплектующих Приход
	Движения.ОстаткиКомплектующих.Записывать = Истина;
	Для Каждого ТекСтрокаКомплектующие Из Комплектующие Цикл
		
		Движение = Движения.ОстаткиКомплектующих.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Период = Дата;
		
		Движение.Комплектующая = ТекСтрокаКомплектующие.Комплектующая;
		
		Движение.Количество = ТекСтрокаКомплектующие.Количество;
	КонецЦикла;

	//}}__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
КонецПроцедуры
