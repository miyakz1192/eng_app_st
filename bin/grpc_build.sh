echo "do this on rails root dir"
set -x
grpc_tools_ruby_protoc --ruby_out=. --grpc_out=. lib/proto/sentence.proto
