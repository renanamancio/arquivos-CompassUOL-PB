*** Settings ***
Documentation     Cenários de testes do cadastro de usuários
Resource          ../resources/base.resource

Suite Setup      Log         Tudo aqui ocorre antes da Suite (antes de todos os teste)
Suite Teardown   Log         Tudo aqui ocorre depois da Suite (depois de todos os testes)

Test Setup       Start Session
Test Teardown    Take Screenshot

*** Test Cases ***
Deve poder cadastrar um novo usuário

    ${user}                  Create Dictionary
    ...        name=Renan Henrique
    ...        email=renan@gmail.com
    ...        password=teste123

    Remove user from database    ${user}[email]

    Go to signup page
    Submit signup form           ${user}
    Notice should be             Boas vindas ao Mark85, o seu gerenciador de tarefas.

Não deve permitir o cadastro com email duplicado
    [Tags]    dup

    ${user}                  Create Dictionary
    ...        name=Renan Henrique
    ...        email=henrique@gmail.com
    ...        password=teste123

    Remove user from database        ${user}[email]
    Insert user from database        ${user}

    Go to signup page
    Submit signup form               ${user}
    Notice should be                 Oops! Já existe uma conta com o e-mail informado.

Campos obrigatórios
    [Tags]    required

    ${user}                  Create Dictionary
    ...                      name=${EMPTY}
    ...                      email=${EMPTY}
    ...                      password=${EMPTY}

    Go to signup page
    Submit signup form           ${user}

    Alert should be              Informe seu nome completo
    Alert should be              Informe seu e-email
    Alert should be              Informe uma senha com pelo menos 6 digitos

Não deve cadastrar com email incorreto
    [Tags]    inv_email

    ${user}                  Create Dictionary
    ...        name=Renan Henrique
    ...        email=renanhenrique.com.br
    ...        password=teste123
    
    Go to signup page
    Submit signup form           ${user}
    Alert should be              Digite um e-mail válido

Não deve cadastrar com senha muito curta
    [Tags]    temp

    @{password_list}    Create List    1    12    123    1234    12345
    
    FOR    ${password}    IN    @{password_list}
        Short password    ${password}
        
    END


