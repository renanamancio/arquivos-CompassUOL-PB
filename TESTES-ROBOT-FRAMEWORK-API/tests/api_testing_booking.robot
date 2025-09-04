*** Settings ***
Resource          ../resources/api_testing_booking.resource

*** Test Cases ***

Cenário 01: Verificar se a API está em execução 201
    Criar Sessão
    PING
    Checar Status Code "201"

Cenário 02: Gera token de autenticação 200
    Criar Sessão
    GET AUTH    admin    password123
    Checar Status Code "200"

Cenário 03: Retornar todos os IDs 200
    Criar Sessão
    GET BOOKING
    Checar Status Code "200"
Cenário 04: Retornar IDs por nome 200
    Criar Sessão
    GET BOOKING NOME     Fulano
    Checar Status Code "200"

Cenário 05: Retornar IDs por sobrenome 200
    Criar Sessão
    GET BOOKING SOBRENOME    Silva
    Checar Status Code "200"
Cenário 06: Retornar IDs por nome e sobrenome 200
    Criar Sessão
    GET BOOKING NOME&SOBRENOME    Fulano    Silva
    Checar Status Code "200"
Cenário 07: Retornar IDs por checkin 200
    Criar Sessão
    GET BOOKING CHECKIN    2024-01-01
    Checar Status Code "200"
Cenário 08: Retornar IDs por checkout 200
    Criar Sessão
    GET BOOKING CHECKOUT    2024-01-01
    Checar Status Code "200"
Cenário 09: Retornar IDs por checkin e checkout 200
    Criar Sessão
    GET BOOKING CHECKIN&CHECKOUT    2024-01-01    2024-01-01
    Checar Status Code "200"
Cenário 10: Retornar Reserva Específica por ID 200
    Criar Sessão
    GET BOOKING ID    1
    Checar Status Code "200"
Cenário 11: Criar Reserva 200
    Criar Sessão
    POST BOOKING    Fulano    Silva    123456789    true    2024-01-01    2024-01-02    Breakfast    None
    Checar Status Code "200"
Cenário 12: Atualizar Reserva 200
    Criar Sessão
    PUT BOOKING    1    Fulanoatualizado    Silvaatualizado    123456789    true    2024-01-01    2024-01-02    Breakfast    None
    Checar Status Code "200"
Cenário 13: Atualizar Reserva parcialmente (nome e sobrenome) com Basic Auth 200
    Criar Sessão
    PATCH BOOKING BASIC AUTH    1    Fulanoatualizado    Silvaatualizado
    Checar Status Code "200"
Cenário 14: Atualizar Reserva parcialmente (nome e sobrenome) com Cookie 200
    Criar Sessão
    GET AUTH    admin    password123
    PATCH BOOKING COOKIE    1    Fulanoatualizado    Silvaatualizado
    Checar Status Code "200"
Cenário 15: Deletar Reserva 201
    Criar Sessão
    GET AUTH    admin    password123
    DELETE BOOKING    1
    Checar Status Code "201"