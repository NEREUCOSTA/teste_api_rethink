*** Settings ***
Documentation     Jornadas ponta-a-ponta seguindo a documentação oficial.
Resource          ../resources/keywords.resource
Resource          ../resources/auth.resource
Suite Setup       Create API Session
Test Setup        Set Test Variable    ${NOW}    ${None}

*** Test Cases ***
E2E - Cadastro→Confirmação→Login→Enviar pontos→Caixinha→Extratos→Saldo→Excluir
    [Documentation]    Cria 2 usuários, confirma email, autentica e executa a jornada completa.
    # Usuário A
    ${cpf_a}=    Gen
    ${email_a}=    Set Variable    user.a+${cpf_a}@example.com
    ${resp}=    Register User    ${cpf_a}    User A Teste    ${email_a}
    Should Be Equal As Integers    ${resp.status_code}    201
    ${confirm_token_a}=    Get From Dictionary    ${resp.json()}    confirmToken
    ${resp}=    Confirm Email    ${confirm_token_a}
    Should Be Equal As Integers    ${resp.status_code}    200

    # Login A
    ${resp}=    Login    ${email_a}
    Should Be Equal As Integers    ${resp.status_code}    200
    ${token}=    Get From Dictionary    ${resp.json()}    token
    Set Auth Token    ${token}

    # Usuário B (destinatário)
    ${cpf_b}=    Gen
    ${email_b}=    Set Variable    user.b+${cpf_b}@example.com
    ${resp}=    Register User    ${cpf_b}    User B Teste    ${email_b}
    Should Be Equal As Integers    ${resp.status_code}    201
    ${confirm_token_b}=    Get From Dictionary    ${resp.json()}    confirmToken
    ${resp}=    Confirm Email    ${confirm_token_b}
    Should Be Equal As Integers    ${resp.status_code}    200

    # Enviar 30 pontos de A → B
    ${resp}=    Send Points    ${cpf_b}    30
    Should Be Equal As Integers    ${resp.status_code}    200

    # Depositar 20 na caixinha, sacar 5
    ${resp}=    Piggy Deposit    20
    Should Be Equal As Integers    ${resp.status_code}    200
    ${resp}=    Piggy Withdraw    5
    Should Be Equal As Integers    ${resp.status_code}    200

    # Extratos e Saldo
    ${resp}=    Get Points Extrato
    Should Be Equal As Integers    ${resp.status_code}    200
    Length Should Be Greater Than    ${resp.json()}    0
    ${resp}=    Piggy Extrato
    Should Be Equal As Integers    ${resp.status_code}    200
    Length Should Be Greater Than    ${resp.json()}    0
    ${resp}=    Get General Balance
    Should Be Equal As Integers    ${resp.status_code}    200
    Dictionary Should Contain Key    ${resp.json()}    normal_balance
    Dictionary Should Contain Key    ${resp.json()}    piggy_bank_balance

    # Exclusão de conta A
    ${resp}=    Delete Account
    Should Be Equal As Integers    ${resp.status_code}    200
