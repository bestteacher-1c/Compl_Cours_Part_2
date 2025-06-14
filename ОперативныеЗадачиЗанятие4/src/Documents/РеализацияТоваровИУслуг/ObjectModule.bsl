Процедура ОбработкаПроведения(Отказ, Режим)

	Если ДополнительныеСвойства.Свойство("РасчетСебестоимости") = Ложь Тогда

#Область ОперативноеПроведение

	Если Константы.РезервированиеВариант2.Получить() Тогда
		КонтрольСвободногоОстатка_Вариант2(Отказ, Режим);
	Иначе
		КонтрольСвободногоОстатка_Вариант1(Отказ, Режим);
	КонецЕсли;

	Для Каждого ТекСтрокаТовары Из Товары Цикл

		Если Отказ = Истина Тогда

			Сообщить("Не проведен документ " + Ссылка);
			Возврат;

		КонецЕсли;
			
		Движение = Движения.Продажи.Добавить();
		Движение.Период = Дата;
		Движение.Номенклатура = ТекСтрокаТовары.Номенклатура;
		Движение.Контрагент = Контрагент;
		Движение.Склад = Склад;
		Движение.Менеджер = Менеджер;
		Движение.Количество = ТекСтрокаТовары.Количество;
		Движение.Сумма = ТекСтрокаТовары.Сумма;
		Движение.Сумма = 0;

	КонецЦикла;

	Движение = Движения.Взаиморасчеты.Добавить();
	Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
	Движение.Период = Дата;
	Движение.Контрагент = Контрагент;
	Движение.Сумма = Товары.Итог("Сумма");

	Движение = Движения.ЗаданияНаРасчетСебестоимости.Добавить();
	Движение.Накладная = Ссылка;
		
		
	Движения.Взаиморасчеты.Записывать = Истина;
	Движения.Продажи.Записывать = Истина;
	Движения.ТоварыВРезерве.Записывать = Истина;
	Движения.ЗаданияНаРасчетСебестоимости.Записывать = Истина;
	
	Движения.СебестоимостьТоваров.Записывать = Истина;

#Область ПланированиеОказанияУслуг

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РеализацияТовары.Номенклатура,
	|	РеализацияТовары.Сумма,
	|	РеализацияТовары.Количество
	|ИЗ
	|	Документ.РеализацияТоваровИУслуг.Товары КАК РеализацияТовары
	|ГДЕ
	|	РеализацияТовары.Ссылка = &Ссылка
	|	И РеализацияТовары.Номенклатура.Услуга = ИСТИНА";

	Запрос.УстановитьПараметр("Ссылка", Ссылка);

	РезультатЗапроса = Запрос.Выполнить();

	Выборка = РезультатЗапроса.Выбрать();

	Пока Выборка.Следующий() Цикл

		Движение = Движения.ПланированиеОказанияУслуг.Добавить();

		Движение.Период = Дата;
		Движение.Услуга = Выборка.Номенклатура;
		Движение.Контрагент = Контрагент;
		Движение.ДокументОснование = Ссылка;

	КонецЦикла;

	Движения.ПланированиеОказанияУслуг.Записывать = Истина;

#КонецОбласти

#КонецОбласти
	Иначе

#Область РасчетСебестоимости
		//Сегодня работем в этой области!!
		Сообщить("Расчет себестоимости по документу " + Ссылка);
#КонецОбласти
		
	КонецЕсли;

КонецПроцедуры

Процедура КонтрольСвободногоОстатка_Вариант1(Отказ, Режим)

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	РеализацияТоваровИУслугТовары.Номенклатура,
	|	РеализацияТоваровИУслугТовары.Количество
	|ИЗ
	|	Документ.РеализацияТоваровИУслуг.Товары КАК РеализацияТоваровИУслугТовары
	|ГДЕ
	|	РеализацияТоваровИУслугТовары.Ссылка = &Ссылка
	|	И РеализацияТоваровИУслугТовары.Номенклатура.Услуга = ЛОЖЬ";

	Запрос.УстановитьПараметр("Ссылка", Ссылка);

	РезультатЗапроса = Запрос.Выполнить();

	Выборка = РезультатЗапроса.Выбрать();

	Пока Выборка.Следующий() Цикл

		Движение = Движения.ОстаткиТоваров.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		Движение.Период = Дата;
		Движение.Номенклатура = Выборка.Номенклатура;
		Движение.Склад = Склад;
		Движение.Количество = Выборка.Количество;
		Движение.Свободно = Выборка.Количество;

		Движение = Движения.СвободныеОстатки.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		Движение.Период = Дата;
		Движение.Номенклатура = Выборка.Номенклатура;
		Движение.Склад = Склад;
		Движение.Количество = Выборка.Количество;
	КонецЦикла;

	Движения.СвободныеОстатки.Записывать = Истина;
	Движения.СвободныеОстатки.БлокироватьДляИзменения = Истина;
		
	Если Режим = РежимПроведенияДокумента.Оперативный Тогда
		
		МенеджерВТ = Новый МенеджерВременныхТаблиц;
		Движения.ОстаткиТоваров.ДополнительныеСвойства.Вставить("МенеджерВТ", МенеджерВТ);
		ДополнительныеСвойства.Вставить("МенеджерВТ", МенеджерВТ);
		
	КонецЕсли;
	
	Движения.Записать();
		
	//В зависимости от режима проведения выполняем разный запрос
	//В оперативном режиме считаем остатки только у увеличенных позиций
	//в неоперативном режиме считаем остатки по всем позициям

	Запрос = Новый Запрос;

	Если Режим = РежимПроведенияДокумента.Оперативный Тогда

		Запрос.МенеджерВременныхТаблиц = МенеджерВТ;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	СвободныеОстаткиОстатки.Номенклатура КАК Номенклатура,
		|	СвободныеОстаткиОстатки.КоличествоОстаток КАК КоличествоОстаток,
		|	"" по данным оперативных остатоков ТМЦ "" КАК ТекстПериодОстатка
		|ИЗ
		|	РегистрНакопления.СвободныеОстатки.Остатки(
		|			,
		|			Склад = &Склад
		|				И Номенклатура В
		|					(ВЫБРАТЬ
		|						ВТТоварыДокумента.Номенклатура КАК Номенклатура
		|					ИЗ
		|						ВТТоварыДокумента КАК ВТТоварыДокумента)) КАК СвободныеОстаткиОстатки
		|ГДЕ
		|	СвободныеОстаткиОстатки.КоличествоОстаток < 0
		|";

	Иначе

		Запрос.Текст =
		"ВЫБРАТЬ
		|	СвободныеОстатки.Номенклатура КАК Номенклатура
		|ПОМЕСТИТЬ ВТТоварыДокумента
		|ИЗ
		|	РегистрНакопления.СвободныеОстатки КАК СвободныеОстатки
		|ГДЕ
		|	СвободныеОстатки.Регистратор = &Регистратор
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СвободныеОстаткиОстатки.Номенклатура КАК Номенклатура,
		|	СвободныеОстаткиОстатки.КоличествоОстаток КАК КоличествоОстаток,
		|	"" по данным оперативных остатоков ТМЦ "" КАК ТекстПериодОстатка
		|ИЗ
		|	РегистрНакопления.СвободныеОстатки.Остатки(
		|			,
		|			Склад = &Склад
		|				И Номенклатура В
		|					(ВЫБРАТЬ
		|						ВТТоварыДокумента.Номенклатура КАК Номенклатура
		|					ИЗ
		|						ВТТоварыДокумента КАК ВТТоварыДокумента)) КАК СвободныеОстаткиОстатки
		|ГДЕ
		|	СвободныеОстаткиОстатки.КоличествоОстаток < 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ОстаткиТоваровОстатки.Номенклатура КАК Номенклатура,
		|	ОстаткиТоваровОстатки.КоличествоОстаток КАК КоличествоОстаток,
		|	""  на дату документа "" КАК ТекстПериодОстатка
		|ИЗ
		|	РегистрНакопления.СвободныеОстатки.Остатки(
		|			&Период,
		|			Склад = &Склад
		|				И Номенклатура В
		|					(ВЫБРАТЬ
		|						ВТТоварыДокумента.Номенклатура КАК Номенклатура
		|					ИЗ
		|						ВТТоварыДокумента КАК ВТТоварыДокумента)) КАК ОстаткиТоваровОстатки
		|ГДЕ
		|	ОстаткиТоваровОстатки.КоличествоОстаток < 0";

		Период = Новый Граница(МоментВремени(), ВидГраницы.Включая);

		Запрос.УстановитьПараметр("Период", Период);

	КонецЕсли;

	Запрос.УстановитьПараметр("Регистратор", Ссылка);
	Запрос.УстановитьПараметр("Склад", Склад);

	МассивРезультатов = Запрос.ВыполнитьПакет();

	Если ДополнительныеСвойства.Свойство("МенеджерВТ") Тогда

		МенеджерВТ.Закрыть();

	КонецЕсли;

	Для Каждого РезультатЗапроса Из МассивРезультатов Цикл
		
		Если РезультатЗапроса = Неопределено Тогда
			Продолжить;
		КонецЕсли;

		Если РезультатЗапроса.Колонки.Найти("Номенклатура") = Неопределено Тогда
			Продолжить;
		КонецЕсли;

		Если РезультатЗапроса.Пустой() = Ложь Тогда

			Отказ = Истина;

			ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();

			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл

				Сообщить("Нет " + ВыборкаДетальныеЗаписи.Номенклатура + ". Нехватка "
					+ ВыборкаДетальныеЗаписи.ТекстПериодОстатка + " составляет "
					+ ВыборкаДетальныеЗаписи.КоличествоОстаток);

			КонецЦикла;

		КонецЕсли;

	КонецЦикла;

	Если Отказ = Ложь Тогда

		Движения.ОстаткиТоваров.Записывать = Истина;
		
	КонецЕсли;

КонецПроцедуры

Процедура КонтрольСвободногоОстатка_Вариант2(Отказ, Режим)
	
	
	Движения.ОстаткиТоваров.Записывать = Истина;
	Движения.Записать(); //Очищаем информацию о резервах!!

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РеализацияТоваровИУслугТовары.Номенклатура,
	|	РеализацияТоваровИУслугТовары.Количество
	|ИЗ
	|	Документ.РеализацияТоваровИУслуг.Товары КАК РеализацияТоваровИУслугТовары
	|ГДЕ
	|	РеализацияТоваровИУслугТовары.Ссылка = &Ссылка
	|	И РеализацияТоваровИУслугТовары.Номенклатура.Услуга = ЛОЖЬ";

	Запрос.УстановитьПараметр("Ссылка", Ссылка);

	РезультатЗапроса = Запрос.Выполнить();

	Выборка = РезультатЗапроса.Выбрать();

	Пока Выборка.Следующий() Цикл

		Движение = Движения.ОстаткиТоваров.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		Движение.Период = Дата;
		Движение.Номенклатура = Выборка.Номенклатура;
		Движение.Склад = Склад;
		Движение.Количество = Выборка.Количество;
		Движение.Свободно = Выборка.Количество;

	КонецЦикла;

	Движения.ОстаткиТоваров.Записывать = Истина;
	Движения.ОстаткиТоваров.БлокироватьДляИзменения = Истина;
	
	Если Режим = РежимПроведенияДокумента.Оперативный Тогда
		
		МенеджерВТ = Новый МенеджерВременныхТаблиц;
		Движения.ОстаткиТоваров.ДополнительныеСвойства.Вставить("МенеджерВТ", МенеджерВТ);
		ДополнительныеСвойства.Вставить("МенеджерВТ", МенеджерВТ);
		
	КонецЕсли;
	
	Движения.Записать();
		
	//В зависимости от режима проведения выполняем разный запрос
	//В оперативном режиме считаем остатки только у увеличенных позиций
	//в неоперативном режиме считаем остатки по всем позициям

	Запрос = Новый Запрос;

	Если Режим = РежимПроведенияДокумента.Оперативный Тогда

		Запрос.МенеджерВременныхТаблиц = МенеджерВТ;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ОстаткиТоваровОстатки.Номенклатура КАК Номенклатура,
		|	ОстаткиТоваровОстатки.СвободноОстаток КАК СвободноОстаток,
		|	"" по данным оперативных остатоков ТМЦ "" КАК ТекстПериодОстатка
		|ИЗ
		|	РегистрНакопления.ОстаткиТоваров.Остатки(
		|			,
		|			Склад = &Склад
		|				И Номенклатура В
		|					(ВЫБРАТЬ
		|						ВТТоварыДокумента.Номенклатура КАК Номенклатура
		|					ИЗ
		|						ВТТоварыДокумента КАК ВТТоварыДокумента)) КАК ОстаткиТоваровОстатки
		|ГДЕ
		|	ОстаткиТоваровОстатки.СвободноОстаток < 0
		|";

	Иначе
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ОстаткиТоваров.Номенклатура КАК Номенклатура
		|ПОМЕСТИТЬ ВТТоварыДокумента
		|ИЗ
		|	РегистрНакопления.ОстаткиТоваров КАК ОстаткиТоваров
		|ГДЕ
		|	ОстаткиТоваров.Регистратор = &Регистратор
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ОстаткиТоваровОстатки.Номенклатура КАК Номенклатура,
		|	ОстаткиТоваровОстатки.СвободноОстаток КАК СвободноОстаток,
		|	"" по данным оперативных остатоков ТМЦ "" КАК ТекстПериодОстатка
		|ИЗ
		|	РегистрНакопления.ОстаткиТоваров.Остатки(, Склад = &Склад
		|	И Номенклатура В
		|		(ВЫБРАТЬ
		|			ВТТоварыДокумента.Номенклатура КАК Номенклатура
		|		ИЗ
		|			ВТТоварыДокумента КАК ВТТоварыДокумента)) КАК ОстаткиТоваровОстатки
		|ГДЕ
		|	ОстаткиТоваровОстатки.СвободноОстаток < 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ОстаткиТоваровОстатки.Номенклатура КАК Номенклатура,
		|	ОстаткиТоваровОстатки.СвободноОстаток КАК СвободноОстаток,
		|	""  на дату документа "" КАК ТекстПериодОстатка
		|ИЗ
		|	РегистрНакопления.ОстаткиТоваров.Остатки(&Период, Склад = &Склад
		|	И Номенклатура В
		|		(ВЫБРАТЬ
		|			ВТТоварыДокумента.Номенклатура КАК Номенклатура
		|		ИЗ
		|			ВТТоварыДокумента КАК ВТТоварыДокумента)) КАК ОстаткиТоваровОстатки
		|ГДЕ
		|	ОстаткиТоваровОстатки.СвободноОстаток < 0";

		Период = Новый Граница(МоментВремени(), ВидГраницы.Включая);

		Запрос.УстановитьПараметр("Период", Период);

	КонецЕсли;

	Запрос.УстановитьПараметр("Регистратор", Ссылка);
	Запрос.УстановитьПараметр("Склад", Склад);

	МассивРезультатов = Запрос.ВыполнитьПакет();

	Если ДополнительныеСвойства.Свойство("МенеджерВТ") Тогда

		МенеджерВТ.Закрыть();

	КонецЕсли;

	Для Каждого РезультатЗапроса Из МассивРезультатов Цикл

		Если РезультатЗапроса = Неопределено Тогда
			Продолжить;
		КонецЕсли;

		Если РезультатЗапроса.Колонки.Найти("Номенклатура") = Неопределено Тогда
			Продолжить;
		КонецЕсли;

		Если РезультатЗапроса.Пустой() = Ложь Тогда

			Отказ = Истина;

			ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();

			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл

				Сообщить("Нет " + ВыборкаДетальныеЗаписи.Номенклатура + ". Нехватка "
					+ ВыборкаДетальныеЗаписи.ТекстПериодОстатка + " составляет "
					+ ВыборкаДетальныеЗаписи.СвободноОстаток);

			КонецЦикла;

		КонецЕсли;

	КонецЦикла;

КонецПроцедуры

Процедура ЗарезервироватьТовары_Вариант1() Экспорт

	Отказ = Ложь;    //Это объявление переменной

	НачатьТранзакцию();

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	РеализацияТоваровИУслугТовары.Номенклатура,
	|	РеализацияТоваровИУслугТовары.Количество
	|ИЗ
	|	Документ.РеализацияТоваровИУслуг.Товары КАК РеализацияТоваровИУслугТовары
	|ГДЕ
	|	РеализацияТоваровИУслугТовары.Ссылка = &Ссылка
	|	И РеализацияТоваровИУслугТовары.Номенклатура.Услуга = ЛОЖЬ";

	Запрос.УстановитьПараметр("Ссылка", Ссылка);

	РезультатЗапроса = Запрос.Выполнить();

	Выборка = РезультатЗапроса.Выбрать();

	Пока Выборка.Следующий() Цикл

		Движение = Движения.ТоварыВРезерве.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Период = Дата;
		Движение.Номенклатура = Выборка.Номенклатура;
		Движение.Склад = Склад;
		Движение.Количество = Выборка.Количество;

		Движение = Движения.СвободныеОстатки.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		Движение.Период = Дата;
		Движение.Номенклатура = Выборка.Номенклатура;
		Движение.Склад = Склад;
		Движение.Количество = Выборка.Количество;

	КонецЦикла;

	Движения.СвободныеОстатки.Записывать = Истина;
	Движения.СвободныеОстатки.БлокироватьДляИзменения = Истина;

	МенеджерВТ = Новый МенеджерВременныхТаблиц;
	Движения.СвободныеОстатки.ДополнительныеСвойства.Вставить("МенеджерВТ", МенеджерВТ);

	Движения.Записать();

	Запрос.МенеджерВременныхТаблиц = МенеджерВТ;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СвободныеОстаткиОстатки.Номенклатура КАК Номенклатура,
	|	СвободныеОстаткиОстатки.КоличествоОстаток КАК КоличествоОстаток,
	|	"" по данным оперативных остатоков ТМЦ "" КАК ТекстПериодОстатка
	|ИЗ
	|	РегистрНакопления.СвободныеОстатки.Остатки(
	|			,
	|			Склад = &Склад
	|				И Номенклатура В
	|					(ВЫБРАТЬ
	|						ВТТоварыДокумента.Номенклатура КАК Номенклатура
	|					ИЗ
	|						ВТТоварыДокумента КАК ВТТоварыДокумента)) КАК СвободныеОстаткиОстатки
	|ГДЕ
	|	СвободныеОстаткиОстатки.КоличествоОстаток < 0
	|";

	Запрос.УстановитьПараметр("Регистратор", Ссылка);
	Запрос.УстановитьПараметр("Склад", Склад);

	РезультатЗапроса = Запрос.Выполнить();

	МенеджерВТ.Закрыть();

	Если РезультатЗапроса.Пустой() = Ложь Тогда

		Отказ = Истина;

		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();

		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл

			Сообщить("Для установки резерва нет " + ВыборкаДетальныеЗаписи.Номенклатура + ". Нехватка "
				+ ВыборкаДетальныеЗаписи.КоличествоОстаток);

		КонецЦикла;

	КонецЕсли;

	Если Отказ = Истина Тогда

		ОтменитьТранзакцию();
		Возврат;

	КонецЕсли;

	Движения.ТоварыВРезерве.Записать();

	ЗафиксироватьТранзакцию();

КонецПроцедуры

Процедура ЗарезервироватьТовары_Вариант2() Экспорт

	Отказ = Ложь;    //Это объявление переменной

	НачатьТранзакцию();

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РеализацияТоваровИУслугТовары.Номенклатура,
	|	РеализацияТоваровИУслугТовары.Количество
	|ИЗ
	|	Документ.РеализацияТоваровИУслуг.Товары КАК РеализацияТоваровИУслугТовары
	|ГДЕ
	|	РеализацияТоваровИУслугТовары.Ссылка = &Ссылка
	|	И РеализацияТоваровИУслугТовары.Номенклатура.Услуга = ЛОЖЬ";

	Запрос.УстановитьПараметр("Ссылка", Ссылка);

	РезультатЗапроса = Запрос.Выполнить();

	Выборка = РезультатЗапроса.Выбрать();

	Пока Выборка.Следующий() Цикл

		Движение = Движения.ОстаткиТоваров.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Период = Дата;
		Движение.Номенклатура = Выборка.Номенклатура;
		Движение.Склад = Склад;
		Движение.Резерв = Выборка.Количество;

		Движение = Движения.ОстаткиТоваров.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		Движение.Период = Дата;
		Движение.Номенклатура = Выборка.Номенклатура;
		Движение.Склад = Склад;
		Движение.Свободно = Выборка.Количество;

	КонецЦикла;

	Движения.ОстаткиТоваров.Записывать = Истина;
	Движения.ОстаткиТоваров.БлокироватьДляИзменения = Истина;

	МенеджерВТ = Новый МенеджерВременныхТаблиц;
	Движения.ОстаткиТоваров.ДополнительныеСвойства.Вставить("МенеджерВТ", МенеджерВТ);

	Движения.Записать();

	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВТ;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОстаткиТоваровОстатки.Номенклатура КАК Номенклатура,
	|	ОстаткиТоваровОстатки.СвободноОстаток КАК СвободноОстаток,
	|	"" по данным оперативных остатоков ТМЦ "" КАК ТекстПериодОстатка
	|ИЗ
	|	РегистрНакопления.ОстаткиТоваров.Остатки(
	|			,
	|			Склад = &Склад
	|				И Номенклатура В
	|					(ВЫБРАТЬ
	|						ВТТоварыДокумента.Номенклатура КАК Номенклатура
	|					ИЗ
	|						ВТТоварыДокумента КАК ВТТоварыДокумента)) КАК ОстаткиТоваровОстатки
	|ГДЕ
	|	ОстаткиТоваровОстатки.СвободноОстаток < 0
	|";

	Запрос.УстановитьПараметр("Регистратор", Ссылка);
	Запрос.УстановитьПараметр("Склад", Склад);

	РезультатЗапроса = Запрос.Выполнить();

	МенеджерВТ.Закрыть();

	Если РезультатЗапроса.Пустой() = Ложь Тогда

		Отказ = Истина;

		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();

		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл

			Сообщить("Для установки резерва нет " + ВыборкаДетальныеЗаписи.Номенклатура
				+ ". Нехватка свободного остатка " + ВыборкаДетальныеЗаписи.СвободноОстаток);

		КонецЦикла;

	КонецЕсли;

	Если Отказ = Истина Тогда

		ОтменитьТранзакцию();
		Возврат;
		
	КонецЕсли;

	Движения.ТоварыВРезерве.Записать();

	ЗафиксироватьТранзакцию();
	

КонецПроцедуры