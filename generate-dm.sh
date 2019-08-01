#!/usr/bin/env bash

cd dm/proto

echo "generate dm protobuf code..."
GOGO_ROOT=${GOPATH}/src/github.com/gogo/protobuf
if [ ! -d $GOGO_ROOT ]; then
		echo "please use the following command to get gogo."
		echo "go get -u github.com/gogo/protobuf/protoc-gen-gogofaster"
		exit 1
fi

GATEWAY_ROOT=${GOPATH}/src/github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway
if [ ! -d $GOGO_ROOT ]; then
	echo "please use the following command to get grpc-gateway."
	echo "go get -u github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway"
	exit 1
fi

protoc -I.:${GOGO_ROOT}:${GOGO_ROOT}/protobuf --gogofaster_out=plugins=grpc:../pb/ *.proto

protoc -I.:${GOGO_ROOT}:${GOGO_ROOT}/protobuf --grpc-gateway_out=logtostderr=true:../pb/ dmmaster.proto


cd ../pb
sed -i.bak -E 's/import _ \"gogoproto\"//g' *.pb.go
sed -i.bak -E 's/import fmt \"fmt\"//g' *.pb.go
rm -f *.bak
goimports -w *.pb.go
