Процедура ОбработкаПроведения(Отказ, Режим)

	Движения.ОстаткиТоваров.Записывать = Истина;

	Для Каждого ТекСтрокаТовары Из Товары Цикл
		
		Если ТекСтрокаТовары.Номенклатура.Услуга Тогда
			Продолжить;
		КонецЕсли;
		
		Движение = Движения.ОстаткиТоваров.Добавить();
		
		Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		Движение.Период = Дата;
		Движение.Номенклатура = ТекСтрокаТовары.Номенклатура;
		Движение.Склад = Склад;
		Движение.Количество = ТекСтрокаТовары.Количество;

	КонецЦикла;

	Движения.Продажи.Записывать = Истина;
	Для Каждого ТекСтрокаТовары Из Товары Цикл
		Движение = Движения.Продажи.Добавить();
		Движение.Период = Дата;
		Движение.Номенклатура = ТекСтрокаТовары.Номенклатура;
		Движение.Контрагент = Контрагент;
		Движение.Склад = Склад;
		Движение.Менеджер = Менеджер;
		Движение.Количество = ТекСтрокаТовары.Количество;
		Движение.Сумма = ТекСтрокаТовары.Сумма;
		Движение.Себестоимость = 1; //Надо рассчитывать
	КонецЦикла;

	Движения.Взаиморасчеты.Записывать = Истина;

	Движение = Движения.Взаиморасчеты.Добавить();
	Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
	Движение.Период = Дата;
	Движение.Контрагент = Контрагент;
	Движение.Сумма = Товары.Итог("Сумма");

	Движения.ПланированиеОказанияУслуг.Записывать = Истина;

	Для Каждого ТекСтрокаТовары Из Товары Цикл
		
		Если ТекСтрокаТовары.Номенклатура.Услуга = Ложь Тогда
			Продолжить;
		КонецЕсли;

		Движение = Движения.ПланированиеОказанияУслуг.Добавить();

		Движение.Период = Дата;
		Движение.Услуга = ТекСтрокаТовары.Номенклатура;
		Движение.Контрагент = Контрагент;
		Движение.ДокументОснование = Ссылка;

	КонецЦикла;
		
КонецПроцедуры

