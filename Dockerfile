# Estágio de build
FROM golang:latest AS build

WORKDIR /app

# Copie apenas os arquivos necessários para a fase de build
COPY go.mod ./
COPY main.go ./

# Baixe e instale as dependências
RUN go mod download

# Construa o executável
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o server .

# Estágio final
FROM scratch

WORKDIR /app

# Copie apenas o executável do estágio de build
COPY --from=build /app/server ./

EXPOSE 8080

# Comando a ser executado quando o contêiner for iniciado
CMD ["./server"]