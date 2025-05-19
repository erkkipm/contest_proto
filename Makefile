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
		&& echo " ✅  Код сгенерирован!" || echo " ❌  Код не сгенерирован!"

.PHONY: install
install:
	@go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	@go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
	@go get google.golang.org/protobuf
	@brew upgrade protobuf
	@protoc --version
