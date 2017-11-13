Котировки для российских инструментов
=====================================

Получает онлайн котировки российских инструментов используя perl [Finance::Quote](https://github.com/finance-quote/finance-quote)

Сделано для [GnuCash](http://www.gnucash.org/)

Установка
---------

* Скопировать все файлы *.pm в каталог Finance/Quote (Для Win обычно c:\strawberry\perl\site\lib\Finance\Quote\, для linux /usr/share/perl5/Finance/quote)

* Добавить в quote.pm (лежит на каталог выше), ссылку на новые модули

```perl
  # If we get an empty new(), or one starting with -defaults,
  # then load up the default methods.
  if (!@reqmodules or $reqmodules[0] eq "-defaults") {
    shift(@reqmodules) if (@reqmodules);
    # Default modules
    @modules = qw/AEX AIAHK ASEGR ASX BMONesbittBurns BSERO Bourso
            Cdnfundlibrary Citywire CSE Currencies Deka DWS FTPortfolios Fidelity FidelityFixed
            FinanceCanada Fool FTfunds HU GoldMoney HEX IndiaMutual LeRevenu
            ManInvestments Morningstar MorningstarJP MStaruk NZX Platinum Micex Moexbonds
            SEB SIXfunds SIXshares StockHouseCanada TSP TSX Tdefunds
            Tdwaterhouse Tiaacref TNetuk Troweprice Trustnet Union USFedBonds
            VWD ZA Cominvest Finanzpartner YahooJSON Yahoo::Asia
            Yahoo::Australia Yahoo::Brasil Yahoo::Europe Yahoo::NZ
            Yahoo::USA YahooYQL ZA_UnitTrusts/; }

  $this->_load_modules(@modules,@reqmodules);
```

![Добавление модуля](../master/pic/quote-add.gif)

Можно не редактировать quote.pm, а установить переменную среды перед запуском GnuCash

```
FQ_LOAD_QUOTELET="-defaults Micex Moexbonds"
```

В GnuCash заводить ценные бумаги примерно так:

![Пример в GnuCash](../master/pic/gnucash-sample.gif)


Облигации
---------

Модуль Moexbonds.pm 

Получает средневзвешенную цену предыдущего дня для облигаций на ММВБ

Содержит функции:
* moex_bond_ofz, Облигации в режиме T1, в основном ОФЗ
* moex_bond, Облигации в режиме T0, все кроме ОФЗ

Тикер указывать как на Мосбирже. Например SU26218RMFS6 - ОФЗ 26218, RU000A0JSGV0 - РЖД-32. Найти обозначение тикеров можно по поиску инструмента на [сайте биржи](http://www.moex.com)

![Пример в GnuCash](../master/pic/moexbonds-example.png)

Акции
-----

Модуль Micex.pm

Получает цену закрытия предыдущего торгового дня российских акций на ММВБ.

Котировки берутся с сайта http://export.rbc.ru/

![Пример в GnuCash](../master/pic/gnucash-sample.gif)
