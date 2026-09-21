GEN_DIR = ./gen/go/
PROTO_DIR = ./proto/
PROTOC_INCLUDE = $(shell dirname $(shell which protoc))/../include
GOOGLE_INCLUDE = /usr/local/include  # ← самый стабильный путь

.PHONY: all
all: install gen

.PHONY: gen
gen:
	@echo "======= Генерация кода ========"
	@rm -rf $(GEN_DIR)
	@mkdir -p $(GEN_DIR)
	@protoc -I $(PROTO_DIR) -I $(PROTOC_INCLUDE) -I $(GOOGLE_INCLUDE) $(PROTO_DIR)*.proto \
		--go_out=$(GEN_DIR) --go_opt=paths=source_relative \
		--go-grpc_out=$(GEN_DIR) --go-grpc_opt=paths=source_relative \
		--experimental_allow_proto3_optional \
		|| { echo " ❌  Код не сгенерирован!"; exit 1; }
	@echo " ✅  Код сгенерирован!"

.PHONY: install
install:
	@go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	@go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
	@go get google.golang.org/protobuf
	@brew upgrade protobuf
	@protoc --version

# Выпуск версии одной командой: make release V=v0.X.Y [M="описание"]
# Проверки → README на V → make gen → go build/vet → коммит «Contest Proto V описание» → тег V → push master и тега.
# В «Истории версий» README должна быть строка V — её текст идёт в сообщение коммита; M="..." — задать своё.
.PHONY: release
release:
	@echo "$(V)" | grep -qE '^v[0-9]+\.[0-9]+\.[0-9]+$$' || { echo " ❌  Укажи версию: make release V=v0.X.Y"; exit 1; }
	@test "$$(git rev-parse --abbrev-ref HEAD)" = master || { echo " ❌  Выпуск только с ветки master"; exit 1; }
	@git fetch -q origin master && git merge-base --is-ancestor origin/master HEAD || { echo " ❌  Локальный master отстаёт от GitHub — сначала git pull"; exit 1; }
	@if git rev-parse -q --verify "refs/tags/$(V)" >/dev/null || git ls-remote --exit-code --tags origin "refs/tags/$(V)" >/dev/null; then echo " ❌  Тег $(V) уже существует"; exit 1; fi
	@awk -F' *[|] *' -v v='$(V)' '$$2 == v { f = 1 } END { exit !f }' README.md || { echo " ❌  В «Истории версий» README нет строки $(V) — добавь её"; exit 1; }
	@perl -pi -e 's/(contest_proto\@|Git-теги \(`)v\d+\.\d+\.\d+/$${1}$(V)/' README.md
	@$(MAKE) --no-print-directory gen
	@go build ./... && go vet ./...
	@git add -u && git add proto gen
	@DESC="$$M"; [ -n "$$DESC" ] || DESC=$$(awk -F' *[|] *' -v v='$(V)' '$$2 == v { gsub(/`/, "", $$3); print $$3; exit }' README.md); \
	if git diff --cached --quiet; then \
		git log -1 --format=%s | tr ' ' '\n' | grep -qxF "$(V)" || { echo " ❌  Изменений нет, а последний коммит не про $(V)"; exit 1; }; \
		echo "Коммит уже есть: $$(git log -1 --format='%h %s')"; \
	else \
		echo "Будет коммит: Contest Proto $(V) $$DESC"; git diff --cached --stat; \
	fi; \
	git ls-files --others --exclude-standard | sed 's/^/   не войдёт (не в git): /'; \
	printf "Выпустить $(V) — коммит, тег и push на GitHub? [y/N] "; read ans; \
	[ "$$ans" = y ] || [ "$$ans" = Y ] || { echo " Отменено — на GitHub ничего не ушло"; exit 1; }; \
	git diff --cached --quiet || git commit -q -m "Contest Proto $(V) $$DESC"
	@git tag $(V)
	@git push -q --atomic origin master $(V) || { echo " ❌  Push не прошёл. Тег $(V) стоит локально — повтори: git push --atomic origin master $(V)"; exit 1; }
	@echo " ✅  $(V) → $$(git log -1 --format='%h %s')"
	@echo "    В потребителях: go get github.com/erkkipm/contest_proto@$(V)"
