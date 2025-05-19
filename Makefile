GEN_DIR = ./gen/go/
PROTO_DIR = ./proto/
# Имя proto-файла
PROTO = contest.proto
# Путь к protoc
PROTOC = protoc
# Каталоги для поиска импортов .proto
# ВКЛЮЧАЕМ путь к timestamp.proto, найденный на твоей машине
PROTO_INCLUDES = -I. -I/usr/local/Cellar/protobuf/29.3/include
# Опции генерации Go-кода
GO_OPTS = --go_out=. --go_opt=paths=source_relative

.PHONY: all
all: install gen

.PHONY: gen
gen:
	@echo "======= Генерация кода ========"

	@rm -rf $(GEN_DIR)
	@mkdir -p $(GEN_DIR)
	@$(PROTOC) $(PROTO_INCLUDES) $(GO_OPTS) $(PROTO_DIR)$(PROTO)\
	       && echo " ✅  Код сгенерирован!" || echo " ❌  Код не сгенерирован!"

.PHONY: install
install:
	@go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	@go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
	@protoc --version
#	@export PATH="$PATH:$(go env GOPATH)/bin"



