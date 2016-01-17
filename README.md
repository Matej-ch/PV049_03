Vašim úkolem je doimplementovat jednoduchou Sinatra aplikaci, která umožní do SQLite databáze ukládat linky (URLs) a stahovat k nim statistiky z FB API.

K úspěšnému zvládnutá úkolu tedy budete potřebovat část implementovanou v úkolu č.2 - https://github.com/municz/simple_api

### Instalace závislostí

```
$ bundle install
$ bundle exec rake db:migrate
```

Spuštění webové aplikace přes shotgun (automaticky restartuje webový server při změně souborů)
```
$ bundle exec shotgun -p 3000
```

### Úkoly
Doimplementovat
* do lib/helpers/facebook.rb
  * přidat jako modul kód vaší aplikace z úkolu č.2
* do lib/app.rb
  * přidání / editace / smazání / editace linku do tabulky Links
  * např. na kliknutí stahovat přes Facebook modul informace o share a like count a uložení do tabulky Stats
  * vypsání informací o sdílení a počtu likes z tabulky Stats

**Ve složce views máte předpřipravené .slim templaty, ale můžete si aplikaci napsat po svém, stačí jen, aby to byla Sinatra.**
**Zbytečně si nekomplikujte život a nebojte se jít cestou nejmenšího odporu ;)**
**dotazy můžete posílat přímo k projektu v záložce issues nebo do diskuze na IS**


### Kontrola stylu
```
$ bundle exec rake rubocop
```
# zabalení výsledku (v případe, že to funguje a rubocop si nestěžuje)
```
$ tar czf ukol.tar.gz *
```
