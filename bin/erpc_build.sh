echo "do this on rails root dir"
set -x
grpc_tools_ruby_protoc --ruby_out=./ruby --grpc_out=./ruby erpc/sentence.proto
