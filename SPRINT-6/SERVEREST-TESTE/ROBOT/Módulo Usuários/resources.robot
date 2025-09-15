*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    String

*** Variables ***
${BASE_URL}         http://localhost:3000
${USERS_ENDPOINT}    /usuarios
${CART_ENDPOINT}     /carrinhos
${CONTENT_TYPE}     application/json
${user_id}          ${EMPTY}

*** Keywords ***
Setup Test
    Create Session    serverest    ${BASE_URL}

Teardown Test
    Delete All Sessions

Criar Usuario
    [Arguments]    ${nome}    ${email}    ${password}    ${administrador}
    ${headers}    Create Dictionary    Content-Type=${CONTENT_TYPE}
    ${data}    Create Dictionary    nome=${nome}    email=${email}    password=${password}    administrador=${administrador}
    ${response}    POST On Session    serverest    ${USERS_ENDPOINT}    json=${data}    headers=${headers}
    [Return]    ${response}

Listar Usuarios
    ${response}    GET On Session    serverest    ${USERS_ENDPOINT}
    [Return]    ${response}

Buscar Usuario Por ID
    [Arguments]    ${user_id}
    ${response}    GET On Session    serverest    ${USERS_ENDPOINT}/${user_id}
    [Return]    ${response}

Atualizar Usuario
    [Arguments]    ${user_id}    ${nome}    ${email}    ${password}    ${administrador}
    ${headers}    Create Dictionary    Content-Type=${CONTENT_TYPE}
    ${data}    Create Dictionary    nome=${nome}    email=${email}    password=${password}    administrador=${administrador}
    ${response}    PUT On Session    serverest    ${USERS_ENDPOINT}/${user_id}    json=${data}    headers=${headers}
    [Return]    ${response}

Excluir Usuario
    [Arguments]    ${user_id}
    ${response}    DELETE On Session    serverest    ${USERS_ENDPOINT}/${user_id}
    [Return]    ${response}

Criar Carrinho
    [Arguments]    ${user_id}
    ${headers}    Create Dictionary    Content-Type=${CONTENT_TYPE}
    ${data}    Create Dictionary    idUsuario=${user_id}    produtos=@{EMPTY}
    ${response}    POST On Session    serverest    ${CART_ENDPOINT}    json=${data}    headers=${headers}
    [Return]    ${response}

Gerar Email Randomico
    ${random}    Generate Random String    8    [LETTERS][NUMBERS]
    [Return]    teste${random}@example.com

Verificar Response Sucesso
    [Arguments]    ${response}
    Should Be Equal As Strings    ${response.status_code}    201
    Should Contain    ${response.json()}[message]    sucesso

Verificar Response Lista
    [Arguments]    ${response}
    Should Be Equal As Strings    ${response.status_code}    200
    Should Be True    ${response.json()}[quantidade] >= 0

Verificar Response Conflito
    [Arguments]    ${response}
    Should Be Equal As Strings    ${response.status_code}    400
    Should Contain    ${response.json()}[message]    já existe