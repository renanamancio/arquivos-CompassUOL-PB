*** Settings ***
Library         RequestsLibrary
Library         Collections
Library         JSONLibrary

*** Variables ***
${BASE_URL}              https://restful-booker.herokuapp.com
${SESSION_ALIAS}         API-Reservas
&{DEFAULT_HEADERS}       Content-Type=application/json    Accept=application/json
${BASIC_AUTH_HEADER}     Basic YWRtaW46cGFzc3dvcmQxMjM=
&{AUTH_CREDENTIALS}      username=admin    password=password123

*** Keywords ***
Criar Sessão
    Create Session    alias=${SESSION_ALIAS}    url=${BASE_URL}

Validar Status Code
    [Arguments]    ${expected_status}    ${response}
    Status Should Be    ${expected_status}    ${response}
    RETURN    ${response}

Obter Token de Autenticação
    [Arguments]    ${username}=${AUTH_CREDENTIALS}[username]    ${password}=${AUTH_CREDENTIALS}[password]
    ${payload}=    Create Dictionary    username=${username}    password=${password}
    ${response}=    POST On Session    ${SESSION_ALIAS}    /auth    json=${payload}    headers=&{DEFAULT_HEADERS}
    ${token_data}=    Set Variable    ${response.json()}
    RETURN    ${token_data}

Verificar Conectividade
    ${response}=    GET On Session    ${SESSION_ALIAS}    /ping
    RETURN    ${response}

Listar Reservas
    [Arguments]    &{filtros}
    ${query_params}=    Set Variable    ${EMPTY}
    FOR    ${key}    ${value}    IN    &{filtros}
        ${query_params}=    Set Variable If    '${query_params}' == '${EMPTY}'    ${key}=${value}    ${query_params}&${key}=${value}
    END
    ${endpoint}=    Set Variable If    '${query_params}' == '${EMPTY}'    /booking    /booking?${query_params}
    ${response}=    GET On Session    ${SESSION_ALIAS}    ${endpoint}
    RETURN    ${response}

Obter Primeiro ID da Lista
    ${response}=    Listar Reservas
    ${bookings_list}=    Set Variable    ${response.json()}
    ${first_booking}=    Get From List    ${bookings_list}    0
    ${booking_id}=    Set Variable    ${first_booking['bookingid']}
    RETURN    ${booking_id}

Obter Detalhes da Reserva
    [Arguments]    ${booking_id}
    ${response}=    GET On Session    ${SESSION_ALIAS}    /booking/${booking_id}
    ${booking_data}=    Set Variable    ${response.json()}
    RETURN    ${booking_data}

Criar Reserva
    [Arguments]    ${firstname}    ${lastname}    ${totalprice}    ${depositpaid}    ${checkin}    ${checkout}    ${additionalneeds}=${EMPTY}
    ${booking_dates}=    Create Dictionary    checkin=${checkin}    checkout=${checkout}
    ${payload}=    Create Dictionary    
    ...    firstname=${firstname}
    ...    lastname=${lastname}
    ...    totalprice=${totalprice}
    ...    depositpaid=${depositpaid}
    ...    bookingdates=${booking_dates}
    ...    additionalneeds=${additionalneeds}
    ${response}=    POST On Session    ${SESSION_ALIAS}    /booking    json=${payload}    headers=&{DEFAULT_HEADERS}
    RETURN    ${response}

Atualizar Reserva Completa
    [Arguments]    ${booking_id}    ${firstname}    ${lastname}    ${totalprice}    ${depositpaid}    ${checkin}    ${checkout}    ${additionalneeds}=${EMPTY}    ${auth_type}=basic
    ${booking_dates}=    Create Dictionary    checkin=${checkin}    checkout=${checkout}
    ${payload}=    Create Dictionary
    ...    firstname=${firstname}
    ...    lastname=${lastname}
    ...    totalprice=${totalprice}
    ...    depositpaid=${depositpaid}
    ...    bookingdates=${booking_dates}
    ...    additionalneeds=${additionalneeds}
    ${headers}=    Criar Headers com Autenticação    ${auth_type}
    ${response}=    PUT On Session    ${SESSION_ALIAS}    /booking/${booking_id}    json=${payload}    headers=${headers}
    RETURN    ${response}

Atualizar Reserva Parcial
    [Arguments]    ${booking_id}    ${auth_type}=basic    &{campos}
    ${headers}=    Criar Headers com Autenticação    ${auth_type}
    ${response}=    PATCH On Session    ${SESSION_ALIAS}    /booking/${booking_id}    json=&{campos}    headers=${headers}
    RETURN    ${response}

Excluir Reserva
    [Arguments]    ${booking_id}    ${auth_type}=basic
    ${headers}=    Criar Headers com Autenticação    ${auth_type}
    ${response}=    DELETE On Session    ${SESSION_ALIAS}    /booking/${booking_id}    headers=${headers}
    RETURN    ${response}

Criar Headers com Autenticação
    [Arguments]    ${auth_type}    ${token_data}=${NONE}
    ${headers}=    Create Dictionary    &{DEFAULT_HEADERS}
    IF    '${auth_type}' == 'basic'
        Set To Dictionary    ${headers}    Authorization=${BASIC_AUTH_HEADER}
    ELSE IF    '${auth_type}' == 'cookie' and ${token_data} is not ${NONE}
        Set To Dictionary    ${headers}    Cookie=token=${token_data}[token]
    END
    RETURN    ${headers}

Atualizar Reserva Completa Com Token
    [Arguments]    ${booking_id}    ${firstname}    ${lastname}    ${totalprice}    ${depositpaid}    ${checkin}    ${checkout}    ${additionalneeds}    ${token_data}
    ${booking_dates}=    Create Dictionary    checkin=${checkin}    checkout=${checkout}
    ${payload}=    Create Dictionary
    ...    firstname=${firstname}
    ...    lastname=${lastname}
    ...    totalprice=${totalprice}
    ...    depositpaid=${depositpaid}
    ...    bookingdates=${booking_dates}
    ...    additionalneeds=${additionalneeds}
    ${headers}=    Create Dictionary    &{DEFAULT_HEADERS}
    Set To Dictionary    ${headers}    Cookie=token=${token_data}[token]
    ${response}=    PUT On Session    ${SESSION_ALIAS}    /booking/${booking_id}    json=${payload}    headers=${headers}
    RETURN    ${response}

Atualizar Reserva Parcial Com Token
    [Arguments]    ${booking_id}    ${token_data}    &{campos}
    ${headers}=    Create Dictionary    &{DEFAULT_HEADERS}
    Set To Dictionary    ${headers}    Cookie=token=${token_data}[token]
    ${response}=    PATCH On Session    ${SESSION_ALIAS}    /booking/${booking_id}    json=&{campos}    headers=${headers}
    RETURN    ${response}

Excluir Reserva Com Token
    [Arguments]    ${booking_id}    ${token_data}
    ${headers}=    Create Dictionary    &{DEFAULT_HEADERS}
    Set To Dictionary    ${headers}    Cookie=token=${token_data}[token]
    ${response}=    DELETE On Session    ${SESSION_ALIAS}    /booking/${booking_id}    headers=${headers}
    RETURN    ${response}

