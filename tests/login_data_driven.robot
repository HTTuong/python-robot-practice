*** Settings ***
Library    Browser
Resource    ../resources/saucedemo_keywords.resource
Resource    ../resources/locators.resource
Test Template    Login With Invalid Credential Should Fail
Test Teardown    Close Browser

*** Test Cases ***
Wrong Username And Password              sai_user              sai_pass           Username and password do not match
Wrong Password                          standard_user         sai_pass           Username and password do not match
Locked Account                     locked_out_user       secret_sauce       locked out
Missing Username                        ${EMPTY}              secret_sauce       Username is required


*** Keywords ***
Login With Invalid Credential Should Fail
    [Arguments]    ${username}    ${password}    ${error_message}
    Open Browser To Saucedemo
    Login With Dynamic User    ${username}    ${password}
    Get Text    ${ERROR}    contains    ${error_message}