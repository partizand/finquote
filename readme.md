Скрипты для Finance::Quote для российских инструментов
======================================================

Сделано для [GnuCash](http://www.gnucash.org/)

Moexbonds
---------

Получает котировки облигаций. Пока только ОФЗ.

Тикер указывать как на Мосбирже, например SU26208RMFS7 - ОФЗ 26208

Получает средневзвешенную цену предыдущего дня.

Найти обозначение тикеров можно по поиску инструмента на [сайте биржи](http://www.moex.com)

Установка и использование аналогично micex

Не проверял работу когда нет торгов, воскресенье и т.п., возможны сюрпризы

![Пример в GnuCash](../master/pic/moexbonds-example.png)

Micex
-----

Получает котировки российских акций на ММВБ.

Котировки берутся с сайта [http://export.rbc.ru/]

Получает цену закрытия предыдущего торгового дня.

Как установить:

* Скопировать micex.pm в каталог Finance/Quote (Для Win обычно c:\perl\site\Finance\Quote, для linux /usr/share/perl5/Finance/quote)

* Добавить в quote.pm (лежит на каталог выше), ссылку на новый модуль

![Добавление модуля](../master/pic/quote-add.gif)

    В GnuCash заводить ценные бумаги примерно так:

![Пример в GnuCash](../master/pic/gnucash-sample.gif)
