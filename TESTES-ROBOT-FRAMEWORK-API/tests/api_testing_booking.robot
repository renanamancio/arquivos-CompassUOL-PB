*** Settings ***
Resource          ../resources/api_testing_booking.resource
Suite Setup       Criar Sessão

*** Test Cases ***

Cenário 01: Verificar se a API está em execução
    [Tags]    PING
    ${response}=    Verificar Conectividade
    Validar Status Code    201    ${response}

Cenário 02: Gerar token de autenticação
    [Tags]    AUTH
    ${token}=    Obter Token de Autenticação
    Should Not Be Empty    ${token}[token]

Cenário 03: Retornar todos os IDs de reservas
    [Tags]    GET_BOOKING_IDS
    ${response}=    Listar Reservas
    Validar Status Code    200    ${response}

Cenário 04: Retornar reserva específica por ID
    [Tags]    GET_BOOKING_ID
    ${booking_id}=    Obter Primeiro ID da Lista
    ${booking_data}=    Obter Detalhes da Reserva    ${booking_id}
    Should Not Be Empty    ${booking_data}[firstname]

Cenário 05: Filtrar reservas por nome
    [Tags]    GET_BOOKING_NOME
    ${booking_id}=    Obter Primeiro ID da Lista
    ${booking_data}=    Obter Detalhes da Reserva    ${booking_id}
    ${response}=    Listar Reservas    firstname=${booking_data}[firstname]
    Validar Status Code    200    ${response}

Cenário 06: Filtrar reservas por sobrenome
    [Tags]    GET_BOOKING_SOBRENOME
    ${booking_id}=    Obter Primeiro ID da Lista
    ${booking_data}=    Obter Detalhes da Reserva    ${booking_id}
    ${response}=    Listar Reservas    lastname=${booking_data}[lastname]
    Validar Status Code    200    ${response}

Cenário 07: Filtrar reservas por nome e sobrenome
    [Tags]    GET_BOOKING_NOME_SOBRENOME
    ${booking_id}=    Obter Primeiro ID da Lista
    ${booking_data}=    Obter Detalhes da Reserva    ${booking_id}
    ${response}=    Listar Reservas    firstname=${booking_data}[firstname]    lastname=${booking_data}[lastname]
    Validar Status Code    200    ${response}

Cenário 08: Filtrar reservas por data de checkin
    [Tags]    GET_BOOKING_CHECKIN
    ${booking_id}=    Obter Primeiro ID da Lista
    ${booking_data}=    Obter Detalhes da Reserva    ${booking_id}
    ${response}=    Listar Reservas    checkin=${booking_data}[bookingdates][checkin]
    Validar Status Code    200    ${response}

Cenário 09: Filtrar reservas por data de checkout
    [Tags]    GET_BOOKING_CHECKOUT
    ${booking_id}=    Obter Primeiro ID da Lista
    ${booking_data}=    Obter Detalhes da Reserva    ${booking_id}
    ${response}=    Listar Reservas    checkout=${booking_data}[bookingdates][checkout]
    Validar Status Code    200    ${response}

Cenário 10: Filtrar reservas por período completo
    [Tags]    GET_BOOKING_CHECKIN_CHECKOUT
    ${booking_id}=    Obter Primeiro ID da Lista
    ${booking_data}=    Obter Detalhes da Reserva    ${booking_id}
    ${response}=    Listar Reservas    checkin=${booking_data}[bookingdates][checkin]    checkout=${booking_data}[bookingdates][checkout]
    Validar Status Code    200    ${response}

Cenário 11: Criar nova reserva
    [Tags]    POST_BOOKING
    ${response}=    Criar Reserva    Renan    Amancio    350    ${True}    2024-01-01    2024-01-02    Internet
    Validar Status Code    200    ${response}
    ${booking_data}=    Set Variable    ${response.json()}
    Should Not Be Empty    ${booking_data}[bookingid]

Cenário 12: Atualizar reserva completa com Basic Auth
    [Tags]    PUT_BOOKING_BASIC_AUTH
    ${response}=    Atualizar Reserva Completa    1    João    Silva    500    ${True}    2024-02-01    2024-02-05    Breakfast
    Validar Status Code    200    ${response}

Cenário 13: Atualizar reserva completa com Cookie
    [Tags]    PUT_BOOKING_COOKIE
    ${token}=    Obter Token de Autenticação
    ${response}=    Atualizar Reserva Completa Com Token    1    Maria    Santos    600    ${False}    2024-03-01    2024-03-07    Dinner    ${token}
    Validar Status Code    200    ${response}

Cenário 14: Atualizar reserva parcialmente com Basic Auth
    [Tags]    PATCH_BOOKING_BASIC_AUTH
    ${response}=    Atualizar Reserva Parcial    1    basic    firstname=Carlos    lastname=Oliveira
    Validar Status Code    200    ${response}

Cenário 15: Atualizar reserva parcialmente com Cookie
    [Tags]    PATCH_BOOKING_COOKIE
    ${token}=    Obter Token de Autenticação
    ${response}=    Atualizar Reserva Parcial Com Token    1    ${token}    firstname=Ana    lastname=Costa
    Validar Status Code    200    ${response}

Cenário 16: Excluir reserva com Basic Auth
    [Tags]    DELETE_BOOKING_BASIC_AUTH
    ${response}=    Excluir Reserva    1
    Validar Status Code    201    ${response}

Cenário 17: Excluir reserva com Cookie
    [Tags]    DELETE_BOOKING_COOKIE
    ${token}=    Obter Token de Autenticação
    ${response}=    Excluir Reserva Com Token    1    ${token}
    Validar Status Code    201    ${response}