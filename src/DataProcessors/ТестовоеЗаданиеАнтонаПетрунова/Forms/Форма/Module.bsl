#Область ОписаниеПеременных

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ДатаВыполнения = ТекущаяДатаСеанса();
	ГруппировкаДерева = "Дата";
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаДереваПриИзменении(Элемент)     
	
	КоличествоЭлементовДереваНаФорме = Дерево.ПолучитьЭлементы().Количество();   
	
	// Проверить ДанныеФормыДерево на пустоту, и если оно НЕ пустое, 
	// то выполнить автоматическую группировку дерева по выбранному полю-условию
	Если КоличествоЭлементовДереваНаФорме = 0 Тогда   
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Дерево пустое. Чтобы перегруппировать дерево, его необходимо сначаала заполнить!";
		Сообщение.Сообщить();    
		
	Иначе                                 
		
		// Вызвать процедуру по извлечению строк 2-го уровня из дерева и их новой группировке
		СгруппироватьДеревоЗаново(); 
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы 

&НаКлиенте
Процедура ЗаполнитьДерево(Команда) 
	
	ЗаполнитьДеревоНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоНаСервере() 

	// Создать новое дерево значений и добавить в него колонки "ЗначениеЧисла" и "ЗначениеДаты"
	ДеревоОбъект = Новый ДеревоЗначений;      
	ДеревоОбъект.Колонки.Добавить("ЗначениеЧисла", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(3)));
	ДеревоОбъект.Колонки.Добавить("ЗначениеДаты");    
	
	Генератор = Новый ГенераторСлучайныхЧисел;
	
	// В цикле создать 100 случайных чисел, 100 дат по условию и заполнить ими дерево значений
	Для Счетчик=1 По 100 Цикл
		
		НовоеЧисло = Генератор.СлучайноеЧисло(0, 100);
		НоваяДата = ДатаВыполнения + НовоеЧисло * 86400;              
		
		// Вызвать процедуру, которая добавляет и группирует новую строку
		ЗаполнитьСтрокуДерева(ДеревоОбъект, НовоеЧисло, НоваяДата, ГруппировкаДерева);
		
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(ДеревоОбъект, "Дерево");
	
КонецПроцедуры  

&НаКлиенте
Процедура ЗаполнитьДеревоИзСоответствия(Команда)
	
	ЗаполнитьДеревоИзСоответствияНаСервере(); 
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоИзСоответствияНаСервере()
	
	Генератор = Новый ГенераторСлучайныхЧисел;    
	
	// Создать соответствие массивов (или структуру массивов) для хранения связей "Число - Массив Дат" или "Дата - Массив Чисел
	СопоставлениеЧиселИДат = Новый Соответствие; 
	
	// В цикле заполнить это соответствие массивов в соответствии с необходимой группировкой
	Для Счетчик=1 По 100 Цикл
		
		НовоеЧисло = Генератор.СлучайноеЧисло(0, 100);
		НоваяДата = ДатаВыполнения + НовоеЧисло * 86400;   
		
		// Вызвать функцию по формированию записи в соответствии согласно группировке
		СопоставлениеЧиселИДат = СгруппироватьПоВыбранномуПолю(СопоставлениеЧиселИДат, НовоеЧисло, НоваяДата, ГруппировкаДерева);
		
	КонецЦикла;
	
	// Вызвать функцию, которая преобразует сформированное на предыдущем щаге соответствие массивов в дерево значний
	ДеревоОбъект = СформироватьДеревоИзСоответствия(СопоставлениеЧиселИДат, ГруппировкаДерева); 
	
	ЗначениеВРеквизитФормы(ДеревоОбъект, "Дерево");
	
КонецПроцедуры

&НаКлиенте
Процедура СортироватьДерево(Команда) 
	
	КоличествоСтрокДереваНаФорме = Дерево.ПолучитьЭлементы().Количество();
	
	// Проверить, что ДанныеФормыДерево НЕ пустое и запустить сортировку
	Если КоличествоСтрокДереваНаФорме = 0 Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Нельзя сортировать пустое дерево. Заполните его сначала!";
		Сообщение.Сообщить();
	Иначе
		СортироватьДеревоНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СортироватьДеревоНаСервере()
	
	ДеревоОбъект = РеквизитФормыВЗначение("Дерево");    
	
	Если ГруппировкаДерева = "Число" Тогда   
		ПолеДляСортировки = "ЗначениеЧисла";
	ИначеЕсли ГруппировкаДерева = "Дата" Тогда 
		ПолеДляСортировки = "ЗначениеДаты";
	КонецЕсли;
	
	ДеревоОбъект.Строки.Сортировать(ПолеДляСортировки);
	
	ЗначениеВРеквизитФормы(ДеревоОбъект, "Дерево");
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьДерево(Команда)
	
	КоличествоСтрокДереваНаФорме = Дерево.ПолучитьЭлементы().Количество();
	
	// Проверить, что ДанныеФормыДерево НЕ пустое и показать вопрос про очистку на сервере
	Если КоличествоСтрокДереваНаФорме = 0 Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Дерево не заполнено. Очищать нечего!";
		Сообщение.Сообщить();
	Иначе 
		
		ЧтоДелатьПослеОтветаНаВопрос = Новый ОписаниеОповещения("ПослеОтветаНаВопросОчисткаНаСервере", ЭтотОбъект);
		ТекстВопроса = "Это приведет к вызову сервера и безвозвратному удалению данных. Продолжить?";
		ПоказатьВопрос(ЧтоДелатьПослеОтветаНаВопрос,  ТекстВопроса, РежимДиалогаВопрос.ДаНет,,,"Очистка дерева на сервере");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеОтветаНаВопросОчисткаНаСервере(РезультатВопроса, ДополнительныеПараметры) Экспорт 
		
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ОчиститьДеревоНаСервере();
	КонецЕсли; 
	
КонецПроцедуры// ПослеОтветаНаВопрос()

&НаСервере
Процедура ОчиститьДеревоНаСервере()
	
	ДеревоОбъект = РеквизитФормыВЗначение("Дерево");
	
	ДеревоОбъект.Строки.Очистить();
	
	ЗначениеВРеквизитФормы(ДеревоОбъект, "Дерево");	
	
КонецПроцедуры  

&НаКлиенте
Процедура ОчиститьДеревоНаКлиенте(Команда)
	
	КоличествоСтрокДереваНаФорме = Дерево.ПолучитьЭлементы().Количество();
	
	// Проверить, что ДанныеФормыДерево НЕ пустое и показать вопрос про удаление данных дерева на форме (на клиенте)
	Если КоличествоСтрокДереваНаФорме = 0 Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Дерево не заполнено. Очищать нечего!";
		Сообщение.Сообщить();
	Иначе
	
		ЧтоДелатьПослеОтветаНаВопрос = Новый ОписаниеОповещения("ПослеОтветаНаВопросОчисткаНаКлиенте", ЭтотОбъект);
		ТекстВопроса = "Это приведет к быстрой очистке данных дерева на этой форме без вызова сервера. Продолжить?";
		ПоказатьВопрос(ЧтоДелатьПослеОтветаНаВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет, ,,"Очистка дерева только на форме");   
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеОтветаНаВопросОчисткаНаКлиенте(РезультатВопроса, ДополнительныеПараметры) Экспорт 

	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Дерево.ПолучитьЭлементы().Очистить();
	КонецЕсли;

КонецПроцедуры // ПослеОтветаНаВопросОчисткаНаКлиенте()


#КонецОбласти

#Область СлужебныеПроцедурыИФункции
     
&НаСервереБезКонтекста
Процедура ЗаполнитьСтрокуДерева(ДеревоОбъект, Число, Дата, ПолеГруппировки)        
	
	// В зависимости от выбранной группировки дерева объявить и проинициализировать следующие переменные
	Если ПолеГруппировки = "Число" Тогда  
		
		ГруппироватьПо = Число;
		КолонкаГруппировки = "ЗначениеЧисла";
		ЧислоРодителя = Число;
		ДатаРодителя = Неопределено; 
		
	ИначеЕсли ПолеГруппировки = "Дата" Тогда
		
		ГруппироватьПо = Дата;
		КолонкаГруппировки = "ЗначениеДаты";
		ДатаРодителя = Дата;
		ЧислоРодителя = Неопределено;
		
	КонецЕсли;
	
	// Выполнить поиск в дереве только по строкам 1-го уровня (по конкретному значению и по конкретной колонке)
	НайденнаяСтрока = ДеревоОбъект.Строки.Найти(ГруппироватьПо, КолонкаГруппировки);
	
	// Если такой записи нет, то вставить эту запись как строку 1-го уровня
	// Затем вставить строку 2-го уровня со значениями даты и числа
	Если НайденнаяСтрока = Неопределено Тогда
		
		НоваяГруппировка = ДеревоОбъект.Строки.Добавить();
		НоваяГруппировка.ЗначениеЧисла = ЧислоРодителя;
		НоваяГруппировка.ЗначениеДаты = ДатаРодителя;
		
		НоваяСтрока = НоваяГруппировка.Строки.Добавить();
		НоваяСтрока.ЗначениеЧисла = Число;
		НоваяСтрока.ЗначениеДаты = Дата;
		
	// Если запись найдена, то это значит, что строка 1-го уровня была добавлена раньше
	// Вставить в неё строку 2-го уровня
	Иначе
		
		НоваяСтрока = НайденнаяСтрока.Строки.Добавить();
		НоваяСтрока.ЗначениеЧисла = Число;
		НоваяСтрока.ЗначениеДаты = Дата;
		
	КонецЕсли; 
	
КонецПроцедуры// ЗаполнитьСтрокуДерева()

&НаСервере
Процедура СгруппироватьДеревоЗаново()
	
	// Получить исходный объект дерева из реквизита формы
	ДеревоИсходноеОбъект = РеквизитФормыВЗначение("Дерево");  
	
	// Создать новое ПУСТОЕ дерево значений с колонками "ЗначениеЧисла" и "ЗначениеДаты"
	ДеревоНоваяГруппировкаОбъект = Новый ДеревоЗначений; 
	ДеревоНоваяГруппировкаОбъект.Колонки.Добавить("ЗначениеЧисла");
	ДеревоНоваяГруппировкаОбъект.Колонки.Добавить("ЗначениеДаты");
	
	// В цикле получить все строки 1-го уровня, содержащиие в себе группировки
	Для каждого СтрокаУровня1 Из ДеревоИсходноеОбъект.Строки Цикл 
		
		// Получить строки 2-го уровня, содержащие в себе значени Числа и Даты
		Для каждого СтрокаУровня2 Из СтрокаУровня1.Строки Цикл
			
			Число = СтрокаУровня2.ЗначениеЧисла;
			Дата = СтрокаУровня2.ЗначениеДаты;
			
			// Вызвать процедуру по заполнению и группировке нового дерева. 
			// Передать в него значения Даты и Числа, полученные из исходного дерева
			ЗаполнитьСтрокуДерева(ДеревоНоваяГруппировкаОбъект, Число, Дата, ГруппировкаДерева);
			
		КонецЦикла;
		
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(ДеревоНоваяГруппировкаОбъект, "Дерево");
	
КонецПроцедуры // ДеревоСгруппироватьЗаново()

&НаСервереБезКонтекста
Функция СгруппироватьПоВыбранномуПолю(СоответствиеРезультат, Число, Дата, ПолеГруппировки)
	
	// Выбрать ключ и значение соответствия в зависимости от значения Группировки Дерева
	// Для группировки по числу Ключ - это число, для группировки по дате Ключ - это дата
	Если ПолеГруппировки = "Число" Тогда
		Ключ = Число;
		Значение = Дата;
	ИначеЕсли ПолеГруппировки = "Дата" Тогда
		Ключ = Дата;
		Значение = Число;   
	КонецЕсли;
	
	// Проверить наличие добавляемого в соответствие ключа 
	Если СоответствиеРезультат.Получить(Ключ) = Неопределено Тогда  
		
		// Если ключ не найден, вставить новый Ключ, содержащий в себе группировку, и Значение, равное пустому массиву
		СоответствиеРезультат.Вставить(Ключ, Новый Массив);  
		
		// В только что созданныую запись со значением типа Массив добавить новый элемент с нужным Значением
		СоответствиеРезультат.Получить(Ключ).Добавить(Значение);  
		
	// Если ключ найден, то в уже существующий массив добавить новый элемент со значением
	Иначе
		СоответствиеРезультат.Получить(Ключ).Добавить(Значение);
	КонецЕсли;
	
	Возврат СоответствиеРезультат;
	
КонецФункции // СгруппироватьПоВыбранномуПолю()

&НаСервереБезКонтекста
Функция СформироватьДеревоИзСоответствия(СоответствиеСГруппировками, ПолеГруппировки)
	
	// Создать новое дерево значений и добавить в него необходимые колонки
	ДеревоОбъект = Новый ДеревоЗначений;
	ДеревоОбъект.Колонки.Добавить("ЗначениеЧисла");
	ДеревоОбъект.Колонки.Добавить("ЗначениеДаты"); 
	
	// В цикле обойти элементы соответствия. Они содержат группировки
	Для каждого ТекГруппировка Из СоответствиеСГруппировками Цикл
		
		// Проинициализировать переменную ПолеГруппировки в соответсвии с требуемой ГруппировкойДерева
		Если ПолеГруппировки = "Число" Тогда
			Ключ = Формат(Число(ТекГруппировка.Ключ), "ЧЦ=3; ЧН=000; ЧВН=");
		ИначеЕсли ПолеГруппировки = "Дата" Тогда 
			Ключ = Дата(ТекГруппировка.Ключ);
		КонецЕсли;
		
		// Создать строку 1-го уровня
		НоваяГруппировка = ДеревоОбъект.Строки.Добавить();  
		
		// В зависимости от Группировки дерева заполнить либо ЗначениеДаты, либо ЗначениеЧисла
		Если ПолеГруппировки = "Число" Тогда 
			НоваяГруппировка.ЗначениеЧисла = Ключ;
		ИначеЕсли ПолеГруппировки = "Дата" Тогда 
			НоваяГруппировка.ЗначениеДаты = Ключ;
		КонецЕсли;
		
		// В цикле обойти все массивы, которые соответствуют значениям соответствия
		Для каждого ТекЗапись Из ТекГруппировка.Значение Цикл
			
			// Добавить строку 2-го уровня
			НоваяЗапись = НоваяГруппировка.Строки.Добавить(); 
			
			// Заполнить поля строки 2-го уровня в соответствии с текущей Группировкой Дерева
			Если ПолеГруппировки = "Число" Тогда 
				НоваяЗапись.ЗначениеЧисла = Ключ;
				НоваяЗапись.ЗначениеДаты = ТекЗапись;  
			ИначеЕсли ПолеГруппировки = "Дата" Тогда 
				НоваяЗапись.ЗначениеДаты = Ключ;
				НоваяЗапись.ЗначениеЧисла = ТекЗапись;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла; 
	
	Возврат ДеревоОбъект;
	
КонецФункции // СформироватьДеревоИзСоответствия()

#КонецОбласти   

#Область НеиспользуемыеПроцедурыИФункции

 &НаСервере
Процедура СгруппироватьДеревоЗановоИзСоответствия()
	
	ДеревоОбъект = РеквизитФормыВЗначение("Дерево");    
	
	СоответствиеДляГруппировки = Новый Соответствие;
	
	// Т.к. все значения пар находятся на 2-м уровне вложенности дерева
	Для каждого СтрокаУровня1 Из ДеревоОбъект.Строки Цикл 
		
		Для каждого СтрокаУровня2 Из СтрокаУровня1.Строки Цикл
			
			Число = СтрокаУровня2.ЗначениеЧисла;
			Дата = СтрокаУровня2.ЗначениеДаты;
			
			СоответствиеДляГруппировки = СгруппироватьПоВыбранномуПолю(СоответствиеДляГруппировки, Число, Дата, ГруппировкаДерева);
			
		КонецЦикла;
		
	КонецЦикла;
	
	ДеревоОбъект = СформироватьДеревоИзСоответствия(СоответствиеДляГруппировки, ГруппировкаДерева);
	ЗначениеВРеквизитФормы(ДеревоОбъект, "Дерево");
	
КонецПроцедуры// СгруппироватьДеревоЗаново()

#КонецОбласти