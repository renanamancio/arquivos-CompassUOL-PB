*** Settings ***
Library           Libs/database.py
Library           Browser
Resource          ../resources/env.resource
Resource          pages/SignupPage.resource
Resource          pages/LoginPage.resource

*** Variables ***

*** Keywords ***
Start Session
    New Browser       browser=chromium            headless=False
    New Page          ${BASE_URL}

Short password
    [Arguments]    ${short_pass}

    ${user}                  Create Dictionary
    ...                      name=Renan
    ...                      email=renan@email.com.br
    ...                      password=${short_pass}

    Go to signup page
    Submit signup form           ${user}

    Alert should be              Informe uma senha com pelo menos 6 digitos
