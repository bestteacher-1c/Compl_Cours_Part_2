
Процедура ОбработкаПроведения(Отказ, Режим)
	//{{__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!

	// регистр ПланированиеОказанияУслуг
	Движения.ПланированиеОказанияУслуг.Записывать = Истина;
	Для Каждого ТекСтрокаСостав Из Состав Цикл
		Движение = Движения.ПланированиеОказанияУслуг.Добавить();
		Движение.Период = Дата;
		Движение.СервисМенеджер = СервисМенеджер;
		Движение.Услуга = ТекСтрокаСостав.Услуга;
		Движение.Контрагент = ТекСтрокаСостав.Контрагент;
		Движение.ДокументОснование = ТекСтрокаСостав.ДокументОснование;
		Движение.ПланируемаяДатаВыполнения = ТекСтрокаСостав.ПланируемаяДатаВыполнения;
		Движение.РеальнаяДатаВыполнения = Дата;
	КонецЦикла;

	//}}__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
КонецПроцедуры
