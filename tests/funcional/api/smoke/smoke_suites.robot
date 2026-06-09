*** Settings ***
Documentation    Smoke tests básicos de validação de autenticação e fluxo de bookings.
Resource         ../../../../resources/keywords/api_keywords.resource

Suite Setup      Criar Sessão API
Suite Teardown   Deleta sessão API
Test Teardown    Capturar Resultado do Teste

*** Test Cases ***
Smoke End-to-End da API Restful Booker
    [Documentation]   Valida o fluxo crítico de autenticação, criação, atualização e exclusão de reservas.
    [Tags]    smoke    endtoend
    Dado que o endpoint de autenticação está disponível
    Dado que o endpoint de booking está disponível
    Quando eu autentico como admin
    Quando eu crio a reserva válida
    Quando eu atualizo a reserva com id salvo
    Quando eu excluo a reserva com id salvo
    Então o status da resposta deve ser ${DELETE_BOOKING_STATUS}
