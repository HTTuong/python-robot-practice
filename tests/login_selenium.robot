*** Settings ***
Library    SeleniumLibrary
Resource    ../resources/selenium_keywords.resource
Test Teardown    Close Browser

*** Test Cases ***
Login Successfully with Standard User
    Open Browser And Login With No Password Check
    Login With Standard User    #robotcode: ignore
    Wait Until Location Contains    inventory
    Title Should Be    Swag Labs

Login With Wrong Password
    Open Browser And Login With No Password Check
    Input Text    id=user-name    ${USERNAME}
    Input Text    id=password    sai_password
    Click Button    id=login-button
    Wait Until Element Is Visible    css=[data-test="error"]
    Element Should Contain    css=[data-test="error"]    do not match


