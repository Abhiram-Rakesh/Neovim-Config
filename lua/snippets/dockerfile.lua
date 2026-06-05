local ls = require 'luasnip'
local s = ls.snippet
local i = ls.insert_node
local fmt = require('luasnip.extras.fmt').fmt

ls.add_snippets('dockerfile', {

  -- Go multi-stage build
  s('df-go', fmt([[
FROM golang:{} AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o /app/{} ./{}

FROM gcr.io/distroless/static-debian12
COPY --from=builder /app/{} /{}
USER nonroot:nonroot
EXPOSE {}
ENTRYPOINT ["/{}"{}]
]], { i(1, '1.22-alpine'), i(2, 'server'), i(3, 'cmd/server'), i(4, 'server'), i(5, 'server'), i(6, '8080'), i(7, 'server'), i(8) })),

  -- Python multi-stage build
  s('df-python', fmt([[
FROM python:{}-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

FROM python:{}-slim
WORKDIR /app
COPY --from=builder /root/.local /root/.local
COPY . .
ENV PATH=/root/.local/bin:$PATH
USER nobody
EXPOSE {}
CMD ["python", "{}"]
]], { i(1, '3.12'), i(2, '3.12'), i(3, '8080'), i(4, 'main.py') })),

  -- Node multi-stage build
  s('df-node', fmt([[
FROM node:{}-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

FROM node:{}-alpine
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY . .
USER node
EXPOSE {}
CMD ["node", "{}"]
]], { i(1, '20'), i(2, '20'), i(3, '3000'), i(4, 'index.js') })),

  -- Generic multi-stage
  s('df-multistage', fmt([[
FROM {} AS builder
WORKDIR /build
COPY . .
RUN {}

FROM {}
WORKDIR /app
COPY --from=builder /build/{} .
USER {}
EXPOSE {}
ENTRYPOINT ["{}"]
]], { i(1, 'alpine:3.19'), i(2, 'make build'), i(3, 'alpine:3.19'), i(4, 'bin/app'), i(5, 'nobody'), i(6, '8080'), i(7, '/app/app') })),

  -- Simple single-stage
  s('df-simple', fmt([[
FROM {}
WORKDIR /app
COPY . .
RUN {}
EXPOSE {}
CMD ["{}"]
]], { i(1, 'alpine:3.19'), i(2, 'apk add --no-cache ca-certificates'), i(3, '8080'), i(4, '/app/server') })),

  -- Common RUN patterns
  s('df-run-apk', fmt([[
RUN apk add --no-cache \
    {} \
    && rm -rf /var/cache/apk/*
]], { i(1, 'ca-certificates curl bash') })),

  s('df-run-apt', fmt([[
RUN apt-get update && apt-get install -y --no-install-recommends \
    {} \
    && rm -rf /var/lib/apt/lists/*
]], { i(1, 'ca-certificates curl') })),

  s('df-healthcheck', fmt([[
HEALTHCHECK --interval={}s --timeout={}s --start-period={}s --retries={} \
  CMD {}
]], { i(1, '30'), i(2, '5'), i(3, '10'), i(4, '3'), i(5, 'curl -f http://localhost:8080/health || exit 1') })),

  s('df-arg-env', fmt([[
ARG {}={}
ENV {}=${}
]], { i(1, 'APP_VERSION'), i(2, 'latest'), i(3, 'APP_VERSION'), i(4, 'APP_VERSION') })),

})
