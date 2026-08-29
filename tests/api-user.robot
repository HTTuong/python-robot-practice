*** Settings ***
Library    RequestsLibrary
Library    Collections
Suite Setup    Create Session    jsonplaceholder    https://jsonplaceholder.typicode.com

*** Test Cases ***
GET users, verify 10 users
    ${response}=    GET On Session    jsonplaceholder    /users    expected_status=200
    Should Be Equal As Integers    ${response.status_code}    200    

GET commets With
    ${response}=    GET On Session    jsonplaceholder    /comments    expected_status=200
    Should Be Equal As Integers    ${response.status_code}    200  

GET comments With query param postId=1
    &{query_params}=    Create Dictionary    postId=${1}
    ${response}=    GET On Session    jsonplaceholder    /comments    params=${query_params}    expected_status=200
    ${comments}=    Set Variable    ${response.json()}
    Should Not Be Empty    ${comments}