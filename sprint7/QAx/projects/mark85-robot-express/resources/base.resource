*** Settings ***
Library           Libs/database.py
Library           Browser
Library           JSONLibrary

Resource          ../resources/env.resource

Resource          pages/components/Notice.resource
Resource          pages/components/Alert.resource
Resource          pages/components/Header.resource

Resource          pages/SignupPage.resource
Resource          pages/LoginPage.resource
Resource          pages/TaskCreatePage.resource
Resource          pages/TasksPage.resource

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

Get fixture
    [Arguments]    ${file_name}    ${scenario}

    ${data}    Load Json From File    
    ...    ${EXECDIR}/resources/fixtures/${file_name}.json
    ...    encoding=utf-8
    
    [Return]    ${data}[${scenario}]