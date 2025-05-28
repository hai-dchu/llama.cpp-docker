FROM ubuntu:22.04
RUN echo "==========Begin LLama.cpp docker installation==========="

RUN echo "==========Installing dependencies======================="

RUN apt-get update && \
apt-get install -y \
python3-pip \
ninja-build \
cmake \
curl libcurl4-openssl-dev \
build-essential \
gcc \
g++ \
git

WORKDIR /llama.cpp

COPY . .

RUN cmake \
    -S . \
    -B build \
    -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=. \
    -DLLAMA_BUILD_TESTS=OFF \
    -DLLAMA_BUILD_EXAMPLES=ON \
    -DLLAMA_BUILD_SERVER=ON

RUN cmake --build build --config Release

RUN cmake --install build --config Release

RUN chmod +x /llama.cpp/build/bin/*

RUN echo "==========Run llama-server=============================="

EXPOSE 8080

CMD ["/llama.cpp/build/bin/llama-server", "-m", "./models/SmolLM2.q8.gguf", "--host", "0.0.0.0", "--port", "8080"]
