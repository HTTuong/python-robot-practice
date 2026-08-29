*** Settings ***
Library    Browser
Test Setup    Open Saucedemo Page
Test Teardown    Close Browser

*** Variables ***
${BASE_URL}    https://www.saucedemo.com
${USERNAME}    standard_user
${PASSWORD}    secret_sauce

*** Test Cases ***
Login Successfully with Standard User
    Login With Dynamic User    ${USERNAME}    ${PASSWORD}
    Get Url    contains    inventory

Login With Wrong Password 
    Login With Dynamic User    ${USERNAME}    wrong_passsword
    Get Text    [data-test="error"]    contains    do not match   

Login With Locked Out User
    Login With Dynamic User    locked_out_user    secret_sauce
    Get Text       [data-test="error"]    contains    locked out

*** Keywords ***
Open Saucedemo Page 
    New Browser    chromium   headless=False
    New Page    ${BASE_URL}

Login With Dynamic User
    [Arguments]    ${username}    ${password}
    Fill Text    id=user-name    ${username}
    Fill Text    id=password    ${password}
    Click    id=login-button 