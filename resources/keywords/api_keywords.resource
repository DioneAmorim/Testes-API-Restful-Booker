*** Settings ***
Resource    ../variables/commom_variables.resource
Library    RequestsLibrary
Library    BuiltIn
Library    Collections
Library    JSONLibrary
Library    DateTime
Library    OperatingSystem

*** Keywords ***
Criar Sessão API
    Create Session    api    ${BASE_URL}    timeout=${TIMEOUT}    verify=False

Deleta sessão API
    Delete All Sessions

Test Teardown Padrão
    Delete All Sessions

Capturar Screenshot da Resposta
    [Documentation]    Salva a resposta da API como arquivo JSON para visualização
    ${timestamp}=    Get Current Date    result_format=%Y%m%d_%H%M%S_%f
    ${response_text}=    Set Variable    ${LAST_RESPONSE.text}
    ${response_status}=    Set Variable    ${LAST_RESPONSE.status_code}
    ${screenshot_dir}=    Set Variable    results/screenshots
    Create Directory    ${screenshot_dir}
    ${filename}=    Set Variable    ${screenshot_dir}/response_${timestamp}_${response_status}.json
    Create File    ${filename}    ${response_text}

Capturar Screenshot de Erro
    [Documentation]    Captura screenshot de erro da resposta
    ${status}=    Evaluate    ${LAST_RESPONSE}.status_code
    Log    ERRO: Status ${status} recebido    ERROR
    Capturar Screenshot da Resposta

Capturar Resultado do Teste
    [Documentation]    Captura screenshot de sucesso ou erro baseado no resultado do teste
    Run Keyword And Ignore Error    Capturar Screenshot da Resposta

Dado que o endpoint de autenticação está disponível
    Criar Sessão API

Dado que o endpoint de booking está disponível
    Criar Sessão API

Quando eu realizo o POST /auth com username ${username} e password ${password}
    ${payload}=    Create Dictionary    username=${username}    password=${password}
    ${response}=    POST On Session    api    ${AUTH_ENDPOINT}    json=${payload}
    Set Suite Variable    ${LAST_RESPONSE}    ${response}

Quando eu autentico como admin
    Quando eu realizo o POST /auth com username ${ADMIN_USERNAME} e password ${ADMIN_PASS}
    ${body}=    Convert String To JSON    ${LAST_RESPONSE.text}
    ${token}=    Extrair valor JSON    ${body}    token
    Set Suite Variable    ${AUTH_TOKEN}    ${token}

E o status da resposta deve ser ${status}
    Should Be Equal As Integers    ${LAST_RESPONSE.status_code}    ${status}

Então o status da resposta deve ser ${status}
    E o status da resposta deve ser ${status}

E o corpo da resposta deve conter o campo token
    ${body}=    Convert String To JSON    ${LAST_RESPONSE.text}
    ${value}=    Extrair valor JSON    ${body}    token
    Should Not Be Empty    ${value}

E o token retornado não deve estar vazio
    E o corpo da resposta deve conter o campo token

Então o corpo da resposta deve conter o campo token
    E o corpo da resposta deve conter o campo token

Então o tempo de resposta deve ser menor que ${seconds}
    Should Be True    ${LAST_RESPONSE.elapsed.total_seconds()} < ${seconds}

Então o status da resposta deve ser 401 ou 403
    Should Contain Any    ${REQUEST_ERROR}    403    401

Então a resposta não deve ser erro do servidor
    Should Be True    ${LAST_RESPONSE.status_code} < 500

Quando eu crio a reserva válida
    ${bookingdates}=    Create Dictionary    checkin=${BOOKING_CHECKIN}    checkout=${BOOKING_CHECKOUT}
    ${payload}=    Create Dictionary    firstname=${BOOKING_FIRSTNAME}    lastname=${BOOKING_LASTNAME}    totalprice=${BOOKING_TOTALPRICE}    depositpaid=${BOOKING_DEPOSITPAID}    bookingdates=${bookingdates}    additionalneeds=${BOOKING_ADDITIONALNEEDS}
    ${response}=    POST On Session    api    ${AUTH_BOOKING}    json=${payload}
    Set Suite Variable    ${LAST_RESPONSE}    ${response}
    ${body}=    Convert String To JSON    ${LAST_RESPONSE.text}
    ${bookingid}=    Extrair valor JSON    ${body}    bookingid
    Set Suite Variable    ${BOOKING_ID}    ${bookingid}

Quando eu crio a reserva sem firstname
    ${bookingdates}=    Create Dictionary    checkin=${BOOKING_CHECKIN}    checkout=${BOOKING_CHECKOUT}
    ${payload}=    Create Dictionary    lastname=${BOOKING_LASTNAME}    totalprice=${BOOKING_TOTALPRICE}    depositpaid=${BOOKING_DEPOSITPAID}    bookingdates=${bookingdates}
    ${response}=    POST On Session    api    ${AUTH_BOOKING}    json=${payload}
    Set Suite Variable    ${LAST_RESPONSE}    ${response}

Quando eu recupero a reserva usando o id
    ${response}=    GET On Session    api    ${AUTH_BOOKING}/${BOOKING_ID}
    Set Suite Variable    ${LAST_RESPONSE}    ${response}

Quando eu atualizo a reserva com id salvo
    ${bookingdates}=    Create Dictionary    checkin=${BOOKING_CHECKIN}    checkout=${BOOKING_CHECKOUT}
    ${payload}=    Create Dictionary    firstname=${UPDATED_BOOKING_FIRSTNAME}    lastname=${UPDATED_BOOKING_LASTNAME}    totalprice=${UPDATED_BOOKING_TOTALPRICE}    depositpaid=${UPDATED_BOOKING_DEPOSITPAID}    bookingdates=${bookingdates}    additionalneeds=${UPDATED_BOOKING_ADDITIONALNEEDS}
    ${headers}=    Create Dictionary    Cookie=token=${AUTH_TOKEN}
    ${response}=    PUT On Session    api    ${AUTH_BOOKING}/${BOOKING_ID}    json=${payload}    headers=${headers}
    Set Suite Variable    ${LAST_RESPONSE}    ${response}

Quando eu tento atualizar a reserva com id salvo sem token
    Set Suite Variable    ${REQUEST_ERROR}    ${EMPTY}
    ${bookingdates}=    Create Dictionary    checkin=${BOOKING_CHECKIN}    checkout=${BOOKING_CHECKOUT}
    ${payload}=    Create Dictionary    firstname=${UPDATED_BOOKING_FIRSTNAME}    lastname=${UPDATED_BOOKING_LASTNAME}    totalprice=${UPDATED_BOOKING_TOTALPRICE}    depositpaid=${UPDATED_BOOKING_DEPOSITPAID}    bookingdates=${bookingdates}    additionalneeds=${UPDATED_BOOKING_ADDITIONALNEEDS}
    ${result}=    Run Keyword And Ignore Error    PUT On Session    api    ${AUTH_BOOKING}/${BOOKING_ID}    json=${payload}
    ${error_msg}=    Get From List    ${result}    1
    Set Suite Variable    ${REQUEST_ERROR}    ${error_msg}

Quando eu excluo a reserva com id salvo
    ${headers}=    Create Dictionary    Cookie=token=${AUTH_TOKEN}
    ${response}=    DELETE On Session    api    ${AUTH_BOOKING}/${BOOKING_ID}    headers=${headers}
    Set Suite Variable    ${LAST_RESPONSE}    ${response}

Quando eu tento excluir a reserva com id salvo sem token
    Set Suite Variable    ${REQUEST_ERROR}    ${EMPTY}
    ${result}=    Run Keyword And Ignore Error    DELETE On Session    api    ${AUTH_BOOKING}/${BOOKING_ID}
    ${error_msg}=    Get From List    ${result}    1
    Set Suite Variable    ${REQUEST_ERROR}    ${error_msg}

Quando eu crio a reserva com payload especial
    ${bookingdates}=    Create Dictionary    checkin=${BOOKING_CHECKIN}    checkout=${BOOKING_CHECKOUT}
    ${payload}=    Create Dictionary    firstname=${BOOKING_SPECIAL_FIRSTNAME}    lastname=${BOOKING_LASTNAME}    totalprice=${BOOKING_TOTALPRICE}    depositpaid=${BOOKING_DEPOSITPAID}    bookingdates=${bookingdates}    additionalneeds=${BOOKING_ADDITIONALNEEDS}
    ${response}=    POST On Session    api    ${AUTH_BOOKING}    json=${payload}
    Set Suite Variable    ${LAST_RESPONSE}    ${response}

E a reserva criada deve conter firstname ${firstname} e lastname ${lastname}
    ${body}=    Convert String To JSON    ${LAST_RESPONSE.text}
    ${booking}=    Extrair valor JSON    ${body}    booking
    ${first}=    Extrair valor JSON    ${booking}    firstname
    ${last}=    Extrair valor JSON    ${booking}    lastname
    Should Be Equal    ${first}    ${firstname}
    Should Be Equal    ${last}     ${lastname}

E a resposta deve conter firstname ${firstname} e lastname ${lastname}
    ${body}=    Convert String To JSON    ${LAST_RESPONSE.text}
    ${first}=    Extrair valor JSON    ${body}    firstname
    ${last}=    Extrair valor JSON    ${body}    lastname
    Should Be Equal    ${first}    ${firstname}
    Should Be Equal    ${last}     ${lastname}

Extrair valor JSON
    [Arguments]    ${json_object}    ${path}
    ${values}=    Get Value From JSON    ${json_object}    ${path}
    ${value}=    Get From List    ${values}    0
    RETURN    ${value}
