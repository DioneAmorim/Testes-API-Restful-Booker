# 🌐 Automação de Testes de API - Restful-Booker

Este repositório contém o projeto de automação de testes para a API **Restful-Booker**, desenvolvido como parte do desafio técnico de QA. O projeto engloba testes funcionais (CRUD), validações de segurança, testes de performance e relatórios automatizados utilizando o **Robot Framework**.

---

## 🛠️ Ferramentas e Tecnologias Utilizadas

- **Linguagem:** Python 3.x
- **Framework de Testes:** Robot Framework
- **Bibliotecas do Robot:**
  - `RequestsLibrary` (Para consumo e validação das rotas HTTP)
  - `JSONLibrary` (Para manipulação e extração de dados dos payloads)
  - `Collections` & `BuiltIn` (Para lógica de asserções e manipulação de listas/dicionários)
  - `DateTime` & `OperatingSystem` (Para geração de timestamps e gerenciamento de arquivos de evidências)

---

## 📌 Cenários de Teste Cobertos (API Testing)

A estrutura de testes foi dividida para cobrir desde os requisitos obrigatórios até os diferenciais técnicos exigidos pelo desafio:

### Nível 1 (Obrigatório)
1. **Fluxo de Autenticação (`auth_suites.robot`):**
   - Geração de token de acesso com credenciais válidas de administrador.
   - Validação de tempo de resposta da rota de autenticação.
1.1 **Smoke de Fluxo Crítico (`smoke_suites.robot`):**
   - Valida o caminho principal de autenticação, criação, atualização e exclusão de reserva.
2. **Gestão de Reservas - CRUD (`booking_suites.robot`):**
   - **Create:** Criação de novas reservas enviando payloads válidos.
   - **Read:** Consulta e recuperação de dados de reservas utilizando o ID salvo.
   - **Update:** Atualização completa dos dados da reserva (`PUT`).
   - **Delete:** Exclusão definitiva de reservas com a validação do token de autenticação.
3. **Validação de Campos Obrigatórios (`booking_validator.robot`):**
   - Tentativa de criação de reservas ocultando campos obrigatórios (ex: `firstname`).

### Nível 2 (Diferencial)
1. **Testes de Performance (`performance_suites.robot`):**
   - Execução de carga simulando 10 requisições consecutivas de leitura de reservas para validar a estabilidade do endpoint.
   - Validação se o tempo de resposta permanece abaixo do limite aceitável de **2.0 segundos**.
2. **Testes de Segurança (`security_suites.robot`):**
   - Tentativa de atualizar ou excluir reservas válidas sem o envio do token de autenticação (Garante proteção das rotas).
   - Validação contra ataques de **SQL Injection** enviando payloads especiais no campo `firstname` (ex: `' OR '1'='1`).

---

## 🧪 Variáveis de Ambiente Utilizadas

Configuradas centralizadamente no arquivo `commom_variables.resource`:

- `${BASE_URL}`: `https://restful-booker.herokuapp.com` (Ambiente de testes da API)
- `${AUTH_ENDPOINT}`: `/auth`
- `${AUTH_BOOKING}`: `/booking`
- `${TIMEOUT}`: `30` (Tempo limite máximo para as requisições)

---

## 🪲 Análise de Bugs Encontrados

Durante a execução das suítes de validação de dados, o seguinte comportamento inesperado foi identificado na API:

- **Bug Encontrado:** Ao executar o teste de campos obrigatórios enviando um payload sem a propriedade `firstname`, a API retornou o status **`HTTP 500 Internal Server Error`** em vez de um erro tratado como **`HTTP 400 Bad Request`**. 
- **Impacto:** O servidor expôs uma falha interna de falta de tratamento de exceção na camada de aplicação ao tentar ler um campo nulo, o que representa um risco de estabilidade.

---

## 📸 Resultados e Evidências

O projeto possui um mecanismo automatizado (`Test Teardown Padrão`) que, ao final de cada cenário de teste executado com sucesso ou falha, extrai o corpo da resposta HTTP e gera um arquivo `.json` individualizado dentro de `results/screenshots/`.

### Como executar os testes localmente:

Certifique-se de ter o Robot Framework e as bibliotecas instaladas (`pip install -r requirements.txt`). No terminal, execute o comando abaixo na raiz do projeto:

```bash
robot -d results tests/funcional/api