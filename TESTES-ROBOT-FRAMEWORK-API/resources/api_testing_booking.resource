*** Settings ***
Library         RequestsLibrary
Library         Collections

*** Keywords ***
Conectar na API e Gerar Token
    Create Session    alias=Restful-booker    url=https://restful-booker.herokuapp.com
    &{credentials}=    Create Dictionary
    ...               username=admin
    ...               password=password123
    ${resposta_auth}=    POST On Session
    ...                  Restful-booker
    ...                  /auth
    ...                  json=${credentials}
    Status Should Be    200    ${resposta_auth}
    ${json_response}=    Set Variable    ${resposta_auth.json( )}
    ${token_value}=      Get From Dictionary    ${json_response}    token
    Set Global Variable    ${TOKEN}    ${token_value}

Criar Nova Reserva Para Teste
    ${booking_body}=    Create Dictionary
    ...                 firstname=Jim
    ...                 lastname=Brown
    ...                 totalprice=111
    ...                 depositpaid=${True}
    ...                 additionalneeds=Breakfast
    ${dates}=           Create Dictionary
    ...                 checkin=2024-01-01
    ...                 checkout=2024-01-02
    Set To Dictionary    ${booking_body}    bookingdates    ${dates}
    ${post_response}=    POST On Session
    ...                  Restful-booker
    ...                  /booking
    ...                  json=${booking_body}
    Status Should Be    200    ${post_response}
    ${new_booking}=      Set Variable         ${post_response.json()}
    ${new_booking_id}=   Get From Dictionary    ${new_booking}    bookingid
    Set Test Variable    ${BOOKING_ID}    ${new_booking_id}

Editar Reserva
    [Arguments]    ${booking_id}    ${payload}
    ${header_dict}=     Create Dictionary
    ...                 Content-Type=application/json
    ...                 Accept=application/json
    ...                 Cookie=token=${TOKEN}
    ${put_response}=    PUT On Session
    ...                 Restful-booker
    ...                 /booking/${booking_id}
    ...                 json=${payload}
    ...                 headers=${header_dict}
    Status Should Be    200    ${put_response}

Tentar Editar Reserva Sem Token
    [Arguments]    ${booking_id}    ${payload}
    ${header_dict}=     Create Dictionary
    ...                 Content-Type=application/json
    ...                 Accept=application/json
    PUT On Session
    ...                 Restful-booker
    ...                 /booking/${booking_id}
    ...                 json=${payload}
    ...                 headers=${header_dict}
    ...                 expected_status=403

Editar Parcialmente Reserva
    [Arguments]    ${booking_id}    ${payload}
    ${headers}=         Create Dictionary
    ...                 Content-Type=application/json
    ...                 Accept=application/json
    ...                 Cookie=token=${TOKEN}
    ${patch_response}=  PATCH On Session
    ...                 Restful-booker
    ...                 /booking/${booking_id}
    ...                 json=${payload}
    ...                 headers=${headers}
    Status Should Be    200    ${patch_response}

Tentar Editar Parcialmente Sem Token
    [Arguments]    ${booking_id}    ${payload}
    ${header_dict}=     Create Dictionary
    ...                 Content-Type=application/json
    ...                 Accept=application/json
    PATCH On Session
    ...                 Restful-booker
    ...                 /booking/${booking_id}
    ...                 json=${payload}
    ...                 headers=${header_dict}
    ...                 expected_status=403

Deletar Reserva
    [Arguments]    ${booking_id}    ${expected_status}
    ${headers}=         Create Dictionary    Cookie=token=${TOKEN}
    ${delete_response}=    DELETE On Session
    ...                 Restful-booker
    ...                 /booking/${booking_id}
    ...                 headers=${headers}
    ...                 expected_status=${expected_status}
    RETURN    ${delete_response}

Tentar Deletar Reserva Sem Token
    [Arguments]    ${booking_id}
    DELETE On Session
    ...                 Restful-booker
    ...                 /booking/${booking_id}
    ...                 expected_status=403

Consultar Reserva por ID
    [Arguments]    ${booking_id}    ${expected_status}
    GET On Session
    ...                 Restful-booker
    ...                 /booking/${booking_id}
    ...                 expected_status=${expected_status}
