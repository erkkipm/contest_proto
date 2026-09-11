# contest_proto

Proto-контракты микросервиса конкурсных заявок Contest/СОФИТ (gRPC, пакет `contest`).

Потребители контракта:

| Потребитель | Что использует |
|---|---|
| Сервер Contest/СОФИТ (`85.143.219.160:50055`) | Реализация сервиса |
| Единая админка `admin` (ssofit.ru) | Заявки, персоны, артисты, песни, туры, итоги, аудит, геосправочник |
| Сайт «Музыка Гордых» (muzikagordyh.ru) | Публичный вывод заявок через `ListContestsByCategoryForSite` (`ContentForSite` — без персональных данных) |

## Сервис

Единственный сервис — `Contest`. Группы методов:

| Группа | Методы |
|---|---|
| Заявки | `AddContest`, `GetContestByID`, `GetContestsByPersonID`, `GetContestWithEmptyCategory`, `ListContests`, `ListContestsWithoutCategory`, `ListContestsByCategory`, `ListContestsByCategoryForSite`, `ListContestsByRegion`, `ListInactiveContests`, `SearchContests`, `ListContestDuplicates`, `UpdateContest`, `UpdateContestAddRate` |
| Персоны | `AddPerson`, `GetPersonByID`, `ListPersons`, `ListPersonsByRegion`, `UpdatePerson` |
| Артисты | `AddArtist`, `ListArtists`, `GetArtistByID`, `UpdateArtist` |
| Песни | `AddSong`, `ListSongs`, `GetSongByID`, `UpdateSong`, `UpdateSong720` |
| Литературные произведения | `AddLitWork`, `ListLitWorks`, `GetLitWorkByID`, `UpdateLitWork` |
| Итоги голосования | `GetResultsByCategory` |
| Туры | `OpenTour`, `CloseTour`, `ListTours`, `GetOpenTour` |
| Журнал аудита | `ListAuditEvents` |
| Справочник территорий | `ListFederalDistricts`, `ListRegions`, `ListSettlements`, `SuggestSettlements`, `ListCountries`, `ListForeignSettlements`, `ListGeoIssues`, `ResolveGeoIssue` |

Пометки о реализации методов на сервере СОФИТ — в комментариях `proto/contest.proto`.

## Генерация кода

```bash
make install   # protoc-gen-go, protoc-gen-go-grpc
make gen       # генерирует gen/go/ (contest.pb.go, contest_grpc.pb.go)
```

## Версионирование

Git-теги (`v0.12.0`, ...). Подключение в потребителях:

```bash
go get github.com/erkkipm/contest_proto@v0.12.0
```

Для локальной разработки в `go.mod` потребителя:

```
replace github.com/erkkipm/contest_proto => ../contest_proto
```

Добавление новых полей обратно совместимо — минорная версия. Номера занятых полей не переиспользуются.

## История версий

Восстановлена из git-тегов и сообщений коммитов; где описания в коммите не было — прочерк.

| Версия | Изменение |
|---|---|
| v0.12.0 | `territory` у заявки и туров, фильтры по территории |
| v0.11.0 | `winner_description` в `FullContent`, `ContentForSite`, `OneContest`, `UpdateContestRequest`/`UpdateContestResponse` |
| v0.10.0 | — |
| v0.9.0 | — |
| v0.8.0 | — |
| v0.7.0 | Метод `ListContestDuplicates` — поиск дубликатов заявок |
| v0.6.8 | — |
| v0.6.7 | Поле `search` в `ListContestsByCategory` и `ListContestsWithoutCategory` |
| v0.6.6 | — |
| v0.6.5 | Исправлена пометка `UpdatePerson` — метод реализован в `grpc_contest.go` |
| v0.6.4 | Поля `sort_by`/`sort_dir` в `ListContestsByCategory` и `ListContestsWithoutCategory` |
| v0.6.3 | `ListContestsWithoutCategory` |
| v0.6.0 – v0.6.2 | — |
| v0.5.0 | Поля `language` и `translation` в `Song` и `AddSongRequest` |
| v0.4.0 | Поля `video_720p`, `clip_720p`, `convert_status`, `convert_error` в `Song`; RPC `UpdateSong720` |
| v0.3.1 | Вывод для сайта без персональных данных |
| v0.2.25 | Вывод для сайта без персональных данных |
| v0.2.22 – v0.2.24 | Универсальность вывода заявок (фильтр по флагам) |
| v0.2.20 – v0.2.21 | Новые поля в модели `OneContest` |
| v0.2.19 | Исправлен сброс значений в `false` у Bool-полей |
| v0.2.18 | Вывод топ-3 для голосования |
| v0.2.13 – v0.2.17 | Поля для голосования топ-3 |
| v0.2.12 | Обновление всех полей заявки |
| v0.2.10 – v0.2.11 | Исправлена структура `FullContent`, добавлен `Rate` |
| v0.2.7 – v0.2.9 | Добавление оценки в заявку |
| v0.2.4 – v0.2.6 | Поля постраничного вывода в List-методах |
| v0.2.3 | `category` в `FullContent` |
| v0.2.0 – v0.2.2 | — |
| v0.1.6 – v0.1.18 | — |
| v0.1.2 – v0.1.5 | Получение заявок без категорий |
| v0.1.1 | Добавлено много функций |
| v0.0.19 – v0.0.21 | `LitWork` — литературные произведения |
| v0.0.18 | Поле `region` |
| v0.0.1 – v0.0.17 | — |
