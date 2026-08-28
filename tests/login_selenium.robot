*** Settings ***
Library    SeleniumLibrary
Test Setup       Open Browser To Saucedemo
Test Teardown    Close Browser

*** Variables ***
${BASE_URL}    https://www.saucedemo.com
${BROWSER}     chrome

*** Test Cases ***
Login Successfully with Standard User
    Input Text    id=user-name    standard_user
    Input Text    id=password    secret_sauce
    Click Button    id=login-button
    Wait Until Location Contains    inventory
    Title Should Be    Swag Labs

Login With Wrong Password
    Input Text    id=user-name    standard_user
    Input Text    id=password    sai_password
    Click Button    id=login-button
    Wait Until Element Is Visible    css=[data-test="error"]
    Element Should Contain    css=[data-test="error"]    do not match

*** Keywords ***
Open Browser To Saucedemo
    Open Browser    ${BASE_URL}    ${BROWSER}
    Set Selenium Timeout    10s
