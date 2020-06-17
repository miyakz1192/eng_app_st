echo "do this on rails root dir"
set -x
cd ./lib/
grpc_tools_ruby_protoc --ruby_out=. --grpc_out=. ./erpc/sentence.proto
cd -
