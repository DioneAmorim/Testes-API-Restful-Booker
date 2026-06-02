*** Settings ***
Documentation    Testes de performance básica da API Restful Booker.
Resource    ../../../../resources/keywords/api_keywords.resource

Suite Setup     Criar Sessão API
Suite Teardown  Deleta sessão API
Test Teardown   Capturar Resultado do Teste

*** Test Cases ***
Carga de leitura de reserva em 10 requisições
    [Documentation]   Gera carga de leitura para um booking válido e valida tempo de resposta.
    [Tags]    performance    leitura
    Dado que o endpoint de booking está disponível
    Quando eu crio a reserva válida
    FOR    ${i}    IN RANGE    10
        Quando eu recupero a reserva usando o id
        Então o status da resposta deve ser 200
        Então o tempo de resposta deve ser menor que 2.0
    END
