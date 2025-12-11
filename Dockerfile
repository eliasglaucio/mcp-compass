# Usar imagem leve do Node.js
FROM node:20-alpine AS builder

# Instalar pnpm (usado pelo projeto)
RUN npm install -g pnpm

# Criar diretório de trabalho
WORKDIR /app

# Copiar arquivos de dependência
COPY package.json pnpm-lock.yaml tsconfig.json ./

# Instalar dependências
RUN pnpm install

# Copiar o código fonte
COPY src ./src
COPY assets ./assets 

# Compilar o TypeScript (build)
RUN pnpm run build

# --- Estágio Final ---
FROM node:20-alpine

WORKDIR /app

# Copiar apenas os arquivos necessários do estágio de build
COPY --from=builder /app/build ./build
COPY --from=builder /app/package.json ./
COPY --from=builder /app/node_modules ./node_modules

# O comando que mantém o servidor rodando
ENTRYPOINT ["node", "build/index.js"]