*** Settings ***
Library         RequestsLibrary
Library         Collections

*** Keywords ***
Criar Sessão
    Create Session    alias=API-Reservas    url=https://restful-booker.herokuapp.com

PING
    ${resposta}=    GET On Session    API-Reservas    /ping
    Set Global Variable    ${resposta}

Checar Status Code "${status_code}"
    Status Should Be     ${status_code}    ${resposta}
  

