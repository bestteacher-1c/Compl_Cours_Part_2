

&НаСервере
Процедура ЗаполнитьНаСервере()
	
	//Перейти ~Метка1;  //Заглушка
	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	МАКСИМУМ(ПланированиеОказаниеУслугСрезПоследних.СервисМенеджер) КАК СервисМенеджер,
		|	ПланированиеОказаниеУслугСрезПоследних.Услуга,
		|	ПланированиеОказаниеУслугСрезПоследних.Контрагент,
		|	ПланированиеОказаниеУслугСрезПоследних.ДокументОснование
		|ИЗ
		|	РегистрСведений.ПланированиеОказанияУслуг.СрезПоследних КАК ПланированиеОказаниеУслугСрезПоследних
		|
		|СГРУППИРОВАТЬ ПО
		|	ПланированиеОказаниеУслугСрезПоследних.Контрагент,
		|	ПланированиеОказаниеУслугСрезПоследних.Услуга,
		|	ПланированиеОказаниеУслугСрезПоследних.ДокументОснование
		|
		|ИМЕЮЩИЕ
		|	МАКСИМУМ(ПланированиеОказаниеУслугСрезПоследних.СервисМенеджер) = ЗНАЧЕНИЕ(Справочник.СервисМенеджеры.ПустаяСсылка)";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Объект.Состав.Очистить();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		НоваяСтрока = Объект.Состав.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока , ВыборкаДетальныеЗаписи);
		
	КонецЦикла;
	
	//~Метка1: //Заглушка
	
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	
	Если Объект.Состав.Количество() > 0 Тогда
		
		ПоказатьВопрос(Новый ОписаниеОповещения("ЗаполнитьЗавершение", ЭтотОбъект)
		, "Таблица состава документа будет перезаполнена! Продолжать?", РежимДиалогаВопрос.ДаНет);
		
		Возврат;
		 
	 КонецЕсли;
	 
	ЗаполнитьСостав();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Если РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		
		Возврат;
		
    КонецЕсли;
    
    ЗаполнитьСостав();

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСостав()
    
    ЗаполнитьНаСервере();
    
КонецПроцедуры


