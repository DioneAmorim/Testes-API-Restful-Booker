*** Settings ***
Documentation    Testes de segurança para a API Restful Booker.
Resource    ../../../../resources/keywords/api_keywords.resource

Suite Setup     Criar Sessão API
Suite Teardown  Deleta sessão API
Test Teardown   Capturar Resultado do Teste

*** Test Cases ***
Atualizar reserva sem token deve ser negado
    [Documentation]   Valida que não é possível atualizar booking sem autenticação.
    [Tags]    seguranca    auth
    Dado que o endpoint de booking está disponível
    Quando eu crio a reserva válida
    Quando eu tento atualizar a reserva com id salvo sem token
    Então o status da resposta deve ser 401 ou 403

Excluir reserva sem token deve ser negado
    [Documentation]   Valida que não é possível excluir booking sem autenticação.
    [Tags]    seguranca    auth
    Dado que o endpoint de booking está disponível
    Quando eu crio a reserva válida
    Quando eu tento excluir a reserva com id salvo sem token
    Então o status da resposta deve ser 401 ou 403

Payload especial não deve causar erro de servidor
    [Documentation]   Valida que payload com caracteres especiais não causa erro 500.
    [Tags]    seguranca    injeção
    Dado que o endpoint de booking está disponível
    Quando eu crio a reserva com payload especial
    Então a resposta não deve ser erro do servidor
