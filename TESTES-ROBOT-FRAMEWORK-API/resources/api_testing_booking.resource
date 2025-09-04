*** Settings ***
Library         RequestsLibrary
Library         Collections

*** Variables ***
${url_base}       https://restful-booker.herokuapp.com

*** Keywords ***
Criar Sessão
    Create Session    alias=API-Reservas    url=${url_base}

Checar Status Code "${status_code}"
    Status Should Be    ${resposta.status_code}    ${status_code}
  
GET AUTH
    [Arguments]    ${username}    ${password}
    ${payload}=    Create Dictionary    username=${username}    password=${password}
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${resposta}=    POST On Session    API-Reservas    /auth    json=${payload}    headers=${headers}
    Set Global Variable    ${resposta}
    ${token}=    Convert To Dictionary    ${resposta.json()}
    Set Global Variable    ${token['token']}

PING
    ${resposta}=    GET On Session    API-Reservas    /ping
    Set Global Variable    ${resposta}

GET BOOKING
    [Arguments]
    ${resposta}=    GET On Session    API-Reservas    /booking
    Set Global Variable    ${resposta}
    Log To Console    ${resposta}


