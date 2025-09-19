*** Settings ***
Documentation     Cenários de testes do cadastro de usuários
Library           Browser

*** Test Cases ***
Deve poder cadastrar um novo usuário
    
    New Browser    browser=chromium                 headless=False
    New Page       http://localhost:3000/signup
    
    # Checkpoint
    Wait For Elements State      xpath=//h1       visible     5
    Get Text                     xpath=//h1       equal       Faça seu cadastro 
   
   Sleep          10
