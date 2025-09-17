*** Settings ***
Resource    ./resources.robot
Suite Setup    Setup Test
Suite Teardown    Teardown Test

*** Test Cases ***
US001-CE1-CT1: Cadastro de usuário comum
    ${email}    Gerar Email Randomico
    ${response}    Criar Usuario    Usuario Teste    ${email}    teste123    true
    Verificar Response Sucesso    ${response}
    Set Suite Variable    ${user_id}    ${response.json()}[_id]

US001-CE2-CT2: Listar usuários
    ${response}    Listar Usuarios
    Verificar Response Lista    ${response}

US001-CE2-CT3: Buscar usuário por ID
    ${response}    Buscar Usuario Por ID    ${user_id}
    Should Be Equal As Strings    ${response.status_code}    200
    Should Be Equal    ${response.json()}[_id]    ${user_id}

US001-CE3-CT1: Atualizar usuário existente
    ${novo_email}    Gerar Email Randomico
    ${response}    Atualizar Usuario    ${user_id}    Usuario Atualizado    ${novo_email}    novasenha    true
    Verificar Response Sucesso    ${response}

US001-CE4-CT1: Excluir usuário
    ${response}    Excluir Usuario    ${user_id}
    Should Be Equal As Strings    ${response.status_code}    200
    Should Contain    ${response.json()}[message]    sucesso

US001-CE1-CT3: Tentativa de cadastro com e-mail duplicado
    ${email}    Gerar Email Randomico
    
    ${response1}    Criar Usuario    Usuario 1    ${email}    senha123    false
    Verificar Response Sucesso    ${response1}
    
    ${response2}    Criar Usuario    Usuario 2    ${email}    senha456    true
    Verificar Response Conflito    ${response2}

US001-CE3-CT3: Criação de usuário via PUT
    ${email}    Gerar Email Randomico
    ${response}    Atualizar Usuario    123abc    Usuario PUT    ${email}    put123    false
    Log    Response PUT: ${response.status_code} - ${response.text}

US001-CE4-CT3: Tentativa de exclusão de usuário com carrinho
    ${email}    Gerar Email Randomico
    
    ${response_user}    Criar Usuario    Usuario Carrinho    ${email}    senha123    false
    Verificar Response Sucesso    ${response_user}
    ${user_id_cart}    Set Variable    ${response_user.json()}[_id]
    
    ${response_cart}    Criar Carrinho    ${user_id_cart}
    Log    Carrinho criado: ${response_cart.status_code}
    
    ${response_delete}    Excluir Usuario    ${user_id_cart}
    Log    Exclusão: ${response_delete.status_code} - ${response_delete.text}