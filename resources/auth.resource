*** Settings ***
Library           RequestsLibrary
Library           Collections
Library           OperatingSystem
Library           DateTime

*** Variables ***
${BASE_URL}    https://points-app-backend.vercel.app

*** Keywords ***
Criar Sessão
    Create Session    api    ${BASE_URL}    disable_warnings=1

Fazer Cadastro
    [Arguments]    ${payload}
    ${response}=    Post On Session    api    /cadastro    json=${payload}
    RETURN    ${response}

Register User
    [Arguments]    ${cpf}    ${email}    ${senha}
    ${payload}=    Create Dictionary    cpf=${cpf}    email=${email}    senha=${senha}
    ${resp}=       Fazer Cadastro    ${payload}
    RETURN         ${resp}



Fazer Login
    [Arguments]    ${payload}
    ${response}=    Post On Session    api    /login    json=${payload}
    RETURN    ${response}

Gerar Token
    [Arguments]    ${payload}
    ${resp}=    Fazer Login    ${payload}
    ${json}=    To Json    ${resp.content}
    ${token}=    Get From Dictionary    ${json}    token
    RETURN    ${token}

Token Header
    [Arguments]    ${token}
    ${headers}=    Create Di
