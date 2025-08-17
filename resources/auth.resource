*** Settings ***
Library           RequestsLibrary
Library           Collections
Library           OperatingSystem
Library           DateTime

*** Variables ***
${SESSION}        api
${AUTH_TOKEN}     
${TOKEN_TS}       

*** Keywords ***
Create API Session
    [Arguments]    ${base_url}=${BASE_URL}
    Create Session    ${SESSION}    ${base_url}    verify=${False}

Set Auth Token
    [Arguments]    ${token}
    Set Suite Variable    ${AUTH_TOKEN}    ${token}
    ${now}=    Get Current Date    result_format=epoch
    Set Suite Variable    ${TOKEN_TS}    ${now}

Get Auth Header
    [Documentation]    Retorna header Authorization atual (Bearer) se existir.
    ${headers}=    Create Dictionary    Content-Type=application/json
    IF    '${AUTH_TOKEN}' != ''
        Set To Dictionary    ${headers}    Authorization=Bearer ${AUTH_TOKEN}
    END
    [Return]    ${headers}

Login And Store Token
    [Arguments]    ${email}    ${password}
    ${body}=    Create Dictionary    email=${email}    password=${password}
    ${resp}=    POST On Session    ${SESSION}    /login    json=${body}
    Should Be Equal As Integers    ${resp.status_code}    200
    ${token}=    Get From Dictionary    ${resp.json()}    token
    Set Auth Token    ${token}
    [Return]    ${token}

Maybe Renew Token
    [Documentation]    Renova o token se estiver próximo do prazo (heurística simples).
    ${now}=    Get Current Date    result_format=epoch
    ${elapsed}=    Evaluate    int(${now} - ${TOKEN_TS}) if ${TOKEN_TS} else 0
    ${needs}=    Evaluate    ${elapsed} > (600 - int(${AUTH_RENEW_BEFORE}))
    Return From Keyword If    not ${needs}
    # Não há endpoint de refresh; re-logar deve ser feito no teste conforme necessidade.
    Log    Token próximo de expirar — renove manualmente no cenário se necessário.

Authorized GET
    [Arguments]    ${path}
    ${headers}=    Get Auth Header
    ${resp}=    GET On Session    ${SESSION}    ${path}    headers=${headers}
    [Return]    ${resp}

Authorized POST
    [Arguments]    ${path}    ${payload}
    ${headers}=    Get Auth Header
    ${resp}=    POST On Session    ${SESSION}    ${path}    headers=${headers}    json=${payload}
    [Return]    ${resp}

Authorized DELETE
    [Arguments]    ${path}    ${payload}={}
    ${headers}=    Get Auth Header
    ${resp}=    DELETE On Session    ${SESSION}    ${path}    headers=${headers}    json=${payload}
    [Return]    ${resp}
