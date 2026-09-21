module github.com/erkkipm/contest_proto

go 1.25.0

require (
	google.golang.org/grpc v1.82.0
	google.golang.org/protobuf v1.36.11
)

require (
	golang.org/x/net v0.53.0 // indirect
	golang.org/x/sys v0.43.0 // indirect
	golang.org/x/text v0.36.0 // indirect
	google.golang.org/genproto/googleapis/rpc v0.0.0-20260414002931-afd174a4e478 // indirect
)

// v0.14.0: тег ошибочно стоит на коммите v0.13.0 — используйте v0.14.1
retract v0.14.0
