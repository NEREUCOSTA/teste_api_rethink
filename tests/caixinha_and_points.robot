*** Settings ***
Documentation     Cobertura específica de pontos e caixinha.
Resource          ../resources/keywords.resource
Resource          ../resources/auth.resource
Suite Setup    Criar Sessão



*** Test Cases ***
Caixinha - depósito e saque inválidos
    ${cpf}=    Gen
    ${email}=    Set Variable    user.caixinha+${cpf}@example.com
    ${r}=    Register User    ${cpf}    User Pig    ${email}
    ${t}=    Get From Dictionary    ${r.json()}    confirmToken
    Confirm Email    ${t}
    ${login}=    Login    ${email}
    ${token}=    Get From Dictionary    ${login.json()}    token
    Set Auth Token    ${token}

    # valores inválidos
    ${r}=    Piggy Deposit    -10
    Should Not Be Equal As Integers    ${r.status_code}    200
    ${r}=    Piggy Withdraw    -5
    Should Not Be Equal As Integers    ${r.status_code}    200

Enviar pontos - CPF inexistente
    ${r}=    Send Points    00000000191    10
    Should Not Be Equal As Integers    ${r.status_code}    200
