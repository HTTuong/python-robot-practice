*** Settings ***
Library    RequestsLibrary
Library    Collections
Suite Setup    Create Session    jsonplaceholder    https://jsonplaceholder.typicode.com

*** Test Cases ***
GET Posts And Return Status 200
    ${response}=    GET On Session    jsonplaceholder    /posts    expected_status=200
    Should Be Equal As Integers    ${response.status_code}    200

GET 1 Post BY Id
    ${response}=    GET On Session    jsonplaceholder    /posts/1    expected_status=200
    ${body}=    Set Variable    ${response.json()}
    Should Be Equal As Integers    ${body}[id]    1
    Should Not Be Empty    ${body}[title]

GET Not Found Post And Return 404
    ${response}=    GET On Session    jsonplaceholder    /posts/9999    expected_status=404