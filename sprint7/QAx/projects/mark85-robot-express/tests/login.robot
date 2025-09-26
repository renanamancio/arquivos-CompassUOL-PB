*** Settings ***
Documentation        Cenários de autenticação do usuário

Resource        ../resources/base.resource

Test Setup           Start Session
Test Teardown        Take Screenshot

*** Test Cases ***

Deve poder logar com um usuário pré-cadastrado
    
    ${user}    Create Dictionary
    ...        name=Henrique Teste
    ...        email=henrique.teste@gmail.com
    ...        password=123456

    Submit login form        ${user}
    User should be logged in    ${user}[name]