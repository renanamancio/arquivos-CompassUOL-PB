*** Settings ***
Resource          ../resources/api_testing_booking.resource

*** Test Cases ***

Cenário 01: Verificar se a API está em execução
    Criar Sessão
    PING
    Checar Status Code "201"

