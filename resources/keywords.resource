*** Settings ***
Library           RequestsLibrary
Library           Collections
Library           OperatingSystem
Library           JSONLibrary
Library           libs/cpf.py

Resource          auth.resource
Resource          variables.resource

*** Keywords ***
Save Evidence
    [Arguments]    ${name}    ${request}=${None}    ${response}=${None}
    ${ts}=    Get Time    epoch
    ${file}=    Set Variable    ${EVIDENCE_DIR}/${ts}_${name}.txt
    ${lines}=    Create List
    Append To List    ${lines}    === ${name} ===
    Run Keyword If    '${request}' != '${None}'    Append To List    ${lines}    REQUEST: ${request}
    Run Keyword If    '${response}' != '${None}'    Append To List    ${lines}    STATUS: ${response.status_code}
    Run Keyword If    '${response}' != '${None}'    Append To List    ${lines}    HEADERS: ${response.headers}
    Run Keyword If    '${response}' != '${None}'    Append To List    ${lines}    BODY: ${response.text}
    ${content}=    Catenate    SEPARATOR=\n    @{lines}
    Create File    ${file}    ${content}
    Log To Console    Saved evidence -> ${file}

Register User
    [Arguments]    ${cpf}    ${full_name}    ${email}    ${password}=${DEFAULT_PASSWORD}
    ${payload}=    Create Dictionary
    ...    cpf=${cpf}
    ...    full_name=${full_name}
    ...    email=${email}
    ...    password=${password}
    ...    confirmPassword=${password}
    ${resp}=    POST On Session    ${SESSION}    /cadastro    json=${payload}
    Save Evidence    register_user    ${payload}    ${resp}
    [Return]    ${resp}

Confirm Email
    [Arguments]    ${confirm_token}
    ${resp}=    GET On Session    ${SESSION}    /confirm-email?token=${confirm_token}
    Save Evidence    confirm_email    ${None}    ${resp}
    [Return]    ${resp}

Login
    [Arguments]    ${email}    ${password}=${DEFAULT_PASSWORD}
    ${payload}=    Create Dictionary    email=${email}    password=${password}
    ${resp}=    POST On Session    ${SESSION}    /login    json=${payload}
    Save Evidence    login    ${payload}    ${resp}
    [Return]    ${resp}

Delete Account
    [Arguments]    ${password}=${DEFAULT_PASSWORD}
    ${payload}=    Create Dictionary    password=${password}
    ${resp}=    Authorized DELETE    /account    ${payload}
    Save Evidence    delete_account    ${payload}    ${resp}
    [Return]    ${resp}

Send Points
    [Arguments]    ${recipient_cpf}    ${amount}
    ${payload}=    Create Dictionary    recipientCpf=${recipient_cpf}    amount=${amount}
    ${resp}=    Authorized POST    /points/send    ${payload}
    Save Evidence    points_send    ${payload}    ${resp}
    [Return]    ${resp}

Get Points Extrato
    ${resp}=    Authorized GET    /points/extrato
    Save Evidence    points_extrato    ${None}    ${resp}
    [Return]    ${resp}

Piggy Deposit
    [Arguments]    ${amount}
    ${payload}=    Create Dictionary    amount=${amount}
    ${resp}=    Authorized POST    /caixinha/deposit    ${payload}
    Save Evidence    piggy_deposit    ${payload}    ${resp}
    [Return]    ${resp}

Piggy Withdraw
    [Arguments]    ${amount}
    ${payload}=    Create Dictionary    amount=${amount}
    ${resp}=    Authorized POST    /caixinha/withdraw    ${payload}
    Save Evidence    piggy_withdraw    ${payload}    ${resp}
    [Return]    ${resp}

Piggy Extrato
    ${resp}=    Authorized GET    /caixinha/extrato
    Save Evidence    piggy_extrato    ${None}    ${resp}
    [Return]    ${resp}

Get General Balance
    ${resp}=    Authorized GET    /points/saldo
    Save Evidence    points_saldo    ${None}    ${resp}
    [Return]    ${resp}
