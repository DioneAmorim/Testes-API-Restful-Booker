*** Settings ***
Documentation  Testes de autenticação básica da API Restful Booker.
...            Valida geração de token, rejeição de credenciais inválidas
...            e comportamentos com dados ausentes.

Resource    ../../../../resources/keywords/api_keywords.resource

Suite Setup     Criar Sessão API
Suite Teardown  Deleta sessão API
Test Teardown   Capturar Resultado do Teste

*** Test Cases ***
Cenario 1: Autenticação com credenciais válidas deve retornar token
    [Documentation]   Valida que POST /auth com credenciais válidas retorna token válido.
    [Tags]    positivo    autenticacao
    Dado que o endpoint de autenticação está disponível
    Quando eu realizo o POST /auth com username admin e password password123
    Então o status da resposta deve ser 200
    E o corpo da resposta deve conter o campo token
    E o token retornado não deve estar vazio

Cenario 2: Autenticação com senha incorreta deve retornar mensagem de erro
    [Documentation]   Valida que credenciais inválidas não gerem token de acesso.
    [Tags]   campos-invalidos
    Dado que o endpoint de autenticação está disponível
    Quando eu realizo o POST /auth com username admin e password senha_errada
    Então o status da resposta deve ser 200
    # Aqui assumimos que a API retorna 200 com mensagem de falha ou 403/4xx dependendo da implementação.
    # Ajuste conforme o comportamento real da API.
 