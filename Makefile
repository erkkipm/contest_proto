# Каталоги
GEN_DIR    := ./gen/go
PROTO_DIR  := ./proto
# Имя proto-файла
PROTO      := contest.proto
# Протокол-буферный компилятор и пути поиска импортов
PROTOC          := protoc
PROTO_INCLUDES  := -I. -I/usr/local/Cellar/protobuf/29.3/include
# Опции для Go-плагинов
GO_OUT          := $(GEN_DIR)
GO_OPTS         := --go_out=$(GO_OUT) --go_opt=paths=source_relative
GRPC_OPTS       := --go-grpc_out=$(GO_OUT) --go-grpc_opt=paths=source_relative

.PHONY: all
all: install gen

.PHONY: gen
gen:
	@echo "======= Генерация protobuf + gRPC-кода ========"
	@rm -rf $(GEN_DIR)
	@mkdir -p $(GEN_DIR)

	$(PROTOC) \
		$(PROTO_INCLUDES) \
		$(GO_OPTS) \
		$(GRPC_OPTS) \
		$(PROTO_DIR)/$(PROTO) \
	&& echo " ✅  Код сгенерирован в $(GEN_DIR)" \
	|| echo " ❌  Ошибка генерации protobuf"

.PHONY: install
install:
	@echo "Устанавливаем protoc-gen-go и protoc-gen-go-grpc"
	@go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	@go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
	@protoc --version



