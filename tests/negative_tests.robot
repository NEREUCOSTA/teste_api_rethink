*** Settings ***
Documentation     Testes negativos e de segurança/autorização.
Resource          ../resources/keywords.resource
Resource          ../resources/auth.resource
Suite Setup       Create API Session

*** Test Cases ***
Cadastro - CPF inválido
    ${resp}=    Register User    11111111111    Fulano da Silva    invalido+cpf@example.com
    Should Not Be Equal As Integers    ${resp.status_code}    201

Cadastro - Email duplicado
    ${cpf}=    Gen
    ${email}=    Set Variable    dup+${cpf}@example.com
    ${resp}=    Register User    ${cpf}    Teste Duplicado    ${email}
    Should Be Equal As Integers    ${resp.status_code}    201
    ${token}=    Get From Dictionary    ${resp.json()}    confirmToken
    Confirm Email    ${token}
    # tentativa com mesmo email
    ${cpf2}=    Gen
    ${resp}=    Register User    ${cpf2}    Outro Nome    ${email}
    Should Not Be Equal As Integers    ${resp.status_code}    201

Login - senha errada
    ${cpf}=    Gen
    ${email}=    Set Variable    user.badpass+${cpf}@example.com
    ${resp}=    Register User    ${cpf}    User Bad Pass    ${email}
    ${token}=    Get From Dictionary    ${resp.json()}    confirmToken
    Confirm Email    ${token}
    ${resp}=    Login    ${email}    wrongPass@123
    Should Not Be Equal As Integers    ${resp.status_code}    200

Autorização - sem token
    ${resp}=    Authorized GET    /points/saldo
    Should Not Be Equal As Integers    ${resp.status_code}    200

Autorização - token inválido
    Set Suite Variable    ${AUTH_TOKEN}    invalid.token.here
    ${resp}=    Authorized GET    /points/saldo
    Should Not Be Equal As Integers    ${resp.status_code}    200

Enviar pontos - saldo insuficiente
    # Usuário A (100 pontos) tenta enviar 200
    ${cpf}=    Gen
    ${email}=    Set Variable    user.low+${cpf}@example.com
    ${resp}=    Register User    ${cpf}    User Low    ${email}
    ${token}=    Get From Dictionary    ${resp.json()}    confirmToken
    Confirm Email    ${token}
    ${resp}=    Login    ${email}
    ${token}=    Get From Dictionary    ${resp.json()}    token
    Set Auth Token    ${token}

    # Destinatário
    ${cpf_b}=    Gen
    ${email_b}=    Set Variable    user.low.dest+${cpf_b}@example.com
    ${resp}=    Register User    ${cpf_b}    User Dest    ${email_b}
    ${token_b}=    Get From Dictionary    ${resp.json()}    confirmToken
    Confirm Email    ${token_b}

    ${resp}=    Send Points    ${cpf_b}    200
    Should Not Be Equal As Integers    ${resp.status_code}    200
