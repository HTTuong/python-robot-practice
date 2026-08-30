*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource    ../resources/api_keywords.resource
Test Setup    Create JSONPlaceholder Session

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

POST Create A New Post And Return Status 201
    &{data}=    Create Dictionary    title=Learn Robot Framework    body=Day 41 - RequestsLibrary    userId=${1}
    ${response}=    POST On Session    jsonplaceholder    /posts    json=${data}    expected_status=201
    ${body}=    Set Variable    ${response.json()}
    Should Be Equal As Strings    ${body}[title]    Learn Robot Framework
    Should Contain    ${body}    id

PUT Update Post And Return Status 200
    &{data}=    Create Dictionary    id=${1}    title=Updated Title    body=New Content    userId=${1}
    ${response}=    PUT On Session    jsonplaceholder    /posts/1    json=${data}    expected_status=200
    Should Be Equal As Strings    ${response.json()}[title]    Updated Title  

DELETE Post And Return Status 200
    ${response}=    DELETE On Session    jsonplaceholder    /posts/1    expected_status=200

GET User Verify Nested Object
    ${response}=    GET On Session    jsonplaceholder    /users/1    expected_status=200
    ${body}=    Set Variable    ${response.json()}
    Should Be Equal As Strings    ${body}[address][city]    Gwenborough 

Verify Response Content Type Header
    ${response}=     GET On Session    jsonplaceholder    /posts/1    expected_status=200
    Should Be Equal As Strings    ${response.headers}[Content-Type]    application/json; charset=utf-8

POST Wrong Data but Still Return 201
    &{data}=    Create Dictionary    title=${123}    body=Test    userId=${1}
    ${response}=    POST On Session    jsonplaceholder    /posts    json=${data}    expected_status=201

*** Keywords ***
PATCH Update A Part of Post
    &{data}=    Create Dictionary    title=Only update title
    ${response}=    PATCH On Session    jsonplaceholder    /posts/1    json=${data}    expected_status=200
    Should Be Equal As Strings    ${response.json()}[title]    Only update title
    Should Not Be Empty    ${response.json()}[body]