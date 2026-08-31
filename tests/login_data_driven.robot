*** Settings ***
Library    Browser
Resource    ../resources/saucedemo_keywords.resource
Resource    ../resources/locators.resource
Test Template    Login With Invalid Credential Should Fail
Test Teardown    Close Browser

*** Test Cases ***                       USERNAME              PASSWORD             ERROR_MESSAGE                             TAGS
Wrong Username And Password              wrong_user            wrong_pass           Username and password do not match        regression,login   
Wrong Password                           standard_user         wrong_pass           Username and password do not match        regression,login
Locked Account                           locked_out_user       secret_sauce         locked out                                edge-case
Missing Username                         ${EMPTY}              secret_sauce         Username is required                      regression,login


*** Keywords ***
Login With Invalid Credential Should Fail
    [Arguments]    ${username}    ${password}    ${error_message}    ${tags}=${EMPTY}
    IF    $tags
        Set Tags    ${tags}
    END
    Open Browser To Saucedemo
    Login With Dynamic User    ${username}    ${password}
    Get Text    ${ERROR}    contains    ${error_message}