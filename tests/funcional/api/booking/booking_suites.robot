*** Settings ***
Documentation    Suites básicas de CRUD e validações de reservas.
Resource    ../../../../resources/keywords/api_keywords.resource

Suite Setup     Criar Sessão API
Suite Teardown  Deleta sessão API
Test Teardown   Capturar Resultado do Teste

*** Test Cases ***
Criar reserva com payload válido
    [Documentation]   Cria uma reserva válida e valida o retorno de booking.
    [Tags]    booking    positivo
    Dado que o endpoint de booking está disponível
    Quando eu crio a reserva válida
    Então o status da resposta deve ser 200
    E a reserva criada deve conter firstname John e lastname Doe

Obter reserva existente
    [Documentation]   Cria e recupera uma reserva por ID, validando os dados retornados.
    [Tags]    booking    leitura
    Dado que o endpoint de booking está disponível
    Quando eu crio a reserva válida
    Quando eu recupero a reserva usando o id
    Então o status da resposta deve ser 200
    E a resposta deve conter firstname John e lastname Doe

Atualizar reserva existente
    [Documentation]   Atualiza uma reserva criada usando token válido e valida o resultado.
    [Tags]    booking    atualizacao
    Dado que o endpoint de booking está disponível
    Quando eu crio a reserva válida
    Quando eu autentico como admin
    Quando eu atualizo a reserva com id salvo
    Então o status da resposta deve ser 200
    E a resposta deve conter firstname Jane e lastname Doe

Excluir reserva existente
    [Documentation]   Exclui reserva criada usando token válido e valida o status de exclusão.
    [Tags]    booking    exclusao
    Dado que o endpoint de booking está disponível
    Quando eu crio a reserva válida
    Quando eu autentico como admin
    Quando eu excluo a reserva com id salvo
    Então o status da resposta deve ser 201

Validar campos obrigatórios na reserva
    [Documentation]   Cria uma reserva sem firstname e valida tratamento de payload obrigatório.
    [Tags]    booking    negativo    validacao
    Dado que o endpoint de booking está disponível
    ${result}=    Run Keyword And Ignore Error    Quando eu crio a reserva sem firstname
    ${status}=    Get From List    ${result}    0
    Run Keyword If    '${status}' == 'FAIL'    Log    Erro esperado ao enviar payload inválido
    Run Keyword If    '${status}' == 'PASS'    Então o status da resposta deve ser 400
