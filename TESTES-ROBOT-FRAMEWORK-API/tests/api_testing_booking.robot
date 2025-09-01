*** Settings ***
Resource          ../resources/api_testing_auth.resource
Resource          ../resources/api_testing_booking.resource
Suite Setup       Conectar na API e Gerar Token
Test Setup        Criar Nova Reserva Para Teste

*** Test Cases ***
Cenario: Atualizar Reserva com Sucesso
    ${dates}=    Create Dictionary    checkin=2025-01-01    checkout=2025-01-07
    &{payload}=     Create Dictionary    firstname=James    lastname=Bond    totalprice=700    depositpaid=${False}    additionalneeds=Martini
    Set To Dictionary    ${payload}    bookingdates=${dates}
    Editar Reserva    ${BOOKING_ID}    &{payload}

Cenario: Tentar Atualizar Reserva Sem Autenticacao
    ${dates}=    Create Dictionary    checkin=2025-01-01    checkout=2025-01-07
    &{payload}=     Create Dictionary    firstname=James    lastname=Bond    totalprice=700    depositpaid=${False}    additionalneeds=Martini
    Set To Dictionary    ${payload}    bookingdates=${dates}
    Tentar Editar Reserva Sem Token    ${BOOKING_ID}    &{payload}

Cenario: Atualizar Parcialmente Reserva com Sucesso
    ${payload_parcial}=    Create Dictionary    firstname=John    lastname=Wick
    Editar Parcialmente Reserva    ${BOOKING_ID}    ${payload_parcial}

Cenario: Tentar Atualizar Parcialmente Sem Autenticacao
    ${payload_parcial}=    Create Dictionary    firstname=John
    Tentar Editar Parcialmente Sem Token    ${BOOKING_ID}    ${payload_parcial}

Cenario: Deletar Reserva com Sucesso
    ${resposta}=    Deletar Reserva    ${BOOKING_ID}    201

Cenario: Verificar se Reserva foi Deletada
    Deletar Reserva    ${BOOKING_ID}    201
    Consultar Reserva por ID    ${BOOKING_ID}    404

Cenario: Tentar Deletar Reserva Sem Autenticacao
    Tentar Deletar Reserva Sem Token    ${BOOKING_ID}

Cenario: Tentar Deletar Reserva Inexistente
    [Setup]    No Operation
    ${id_invalido}=    Set Variable    99999999
    Deletar Reserva    ${id_invalido}    405
