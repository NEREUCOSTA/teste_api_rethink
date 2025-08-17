*** Settings ***
Library           RequestsLibrary
Library           Collections
Library           OperatingSystem
Library           JSONLibrary
Library           ../libs/cpf.py

Resource          auth.resource
Resource          variables.resource

*** Keywords ***
Consultar Saldo Pontos
    [Arguments]    ${headers}
    ${response}=    Get On Session    api    /points/saldo    headers=${headers}
    RETURN    ${response}

Authorized GET
    [Arguments]    ${headers}
    ${resp}=    Consultar Saldo Pontos    ${headers}
    RETURN    ${resp}

Enviar Pontos
    [Arguments]    ${headers}    ${payload}
    ${response}=    Post On Session    api    /points/send    headers=${headers}    json=${payload}
    RETURN    ${response}

Send Points
    [Arguments]    ${cpf}    ${pontos}    ${headers}
    ${payload}=    Create Dictionary    cpf=${cpf}    pontos=${pontos}
    ${resp}=       Enviar Pontos    ${headers}    ${payload}
    RETURN         ${resp}


Consultar Extrato
    [Arguments]    ${headers}
    ${response}=    Get On Session    api    /points/extrato    headers=${headers}
    RETURN    ${response}

Consultar Caixinha
    [Arguments]    ${headers}
    ${response}=    Get On Session    api    /caixinha    headers=${headers}
    RETURN    ${response}

Depositar Caixinha
    [Arguments]    ${headers}    ${payload}
    ${response}=   Post On Session    api    /caixinha/depositar    headers=${headers}    json=${payload}
    RETURN    ${response}

Sacar Caixinha
    [Arguments]    ${headers}    ${payload}
    ${response}=   Post On Session    api    /caixinha/sacar    headers=${headers}    json=${payload}
    RETURN    ${response}

Save Evidence
    [Arguments]    ${filename}    ${request}=None    ${response}=None
    ${lines}=    Create List
    Run Keyword If    ${request}    Append To List    ${lines}    REQUEST: ${request}
    Run Keyword If    ${response}    Append To List    ${lines}    STATUS: ${response.status_code}
    Run Keyword If    ${response}    Append To List    ${lines}    HEADERS: ${response.headers}
    Run Keyword If    ${response}    Append To List    ${lines}    BODY: ${response.text}
    Create File    evidence/${filename}.txt    ${lines}
    Log To Console    Saved evidence -> evidence/${filename}.txt
