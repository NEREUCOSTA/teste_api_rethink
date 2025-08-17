# Rethink Bank Test — Automação de API (Robot Framework)

Repositório pronto para executar testes **end-to-end** da API do desafio Rethink Bank, usando **Robot Framework + RequestsLibrary**.

- **Jornadas cobertas:** cadastro → confirmação de e-mail → login → envio de pontos → caixinha (depósito/saque/extrato) → extrato geral → saldo → exclusão de conta.
- **Validações positivas e negativas** (contratos, regras de negócio e segurança de autenticação).
- **Estratégia de autenticação** com armazenamento de *token* e renovação automática quando necessário.
- **Evidências** salvas em `/evidence` por cenário + *logs* padrão do Robot (`log.html`).

> API e docs do desafio: `https://github.com/rethink-projects/rethinkbanktest` (Swagger em `/docs`)  
> Backend público (default do projeto): `https://points-app-backend.vercel.app/`

## Como rodar

### 1) Requisitos
- Python 3.10+
- Pip

### 2) Instalar dependências
```bash
pip install -r requirements.txt
```

### 3) Executar todos os testes
```bash
robot -d output tests
```
Dica: paralelizar (opcional, se instalar `pabot`):
```bash
pabot -d output tests
```

### 4) Variáveis de ambiente
- `BASE_URL` — URL base da API (default: `https://points-app-backend.vercel.app`)
- `AUTH_RENEW_BEFORE_SEC` — janela (em segundos) para renovação antecipada do token (default: 60)
- `EVIDENCE_DIR` — pasta de evidências (default: `evidence`)

Exemplo:
```bash
set BASE_URL=https://points-app-backend.vercel.app
set AUTH_RENEW_BEFORE_SEC=60
```

### 5) Saídas
- `output/log.html`, `output/report.html`, `output/output.xml`
- Evidências em `evidence/` (request/response por teste)

## Estrutura

```
rethinkbanktest-robot/
├─ README.md
├─ requirements.txt
├─ libs/
│  └─ cpf.py
├─ resources/
│  ├─ auth.resource
│  ├─ keywords.resource
│  └─ variables.resource
├─ tests/
│  ├─ e2e_journeys.robot
│  ├─ negative_tests.robot
│  └─ caixinha_and_points.robot
├─ evidence/
├─ output/
└─ .github/workflows/ci.yml
```

## Evidências

Cada teste chama o keyword `Save Evidence` salvando **requisição, resposta e status** em arquivos `.txt` nomeados com *timestamp* na pasta `evidence/`. Além disso, todas as chamadas HTTP ficam detalhadas no `log.html` do Robot.

## Estratégia de autenticação

- O token de sessão é obtido via `/login` e adicionado ao header `Authorization: Bearer <token>`.
- O token **expira em ~10 minutos**; o projeto guarda o horário de aquisição e pode renovar antes de expirar (configurável por `AUTH_RENEW_BEFORE_SEC`).
- Há testes negativos cobrindo **token ausente**, **token inválido** e **expirado** (o último simulado por manipulação de header).

## Bugs & Análise (preencha após rodar)

Preencha a seção abaixo com os achados do seu ambiente. Deixe sua classificação de severidade e impactos.

### a) Há bugs? Quais cenários esperados?
- …

### b) Classificação de criticidade
- …

### c) Pronto para produção?
- …

## CI (GitHub Actions)

O *workflow* `ci.yml` instala dependências e executa `robot -d output tests`, publicando os artefatos (`output/` e `evidence/`).

---

Feito com ❤️ em Robot Framework.
