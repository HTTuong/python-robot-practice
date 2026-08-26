*** Settings ***
Library    Browser

*** Variables ***
${BASE_URL}    https://www.saucedemo.com
${USERNAME}    standard_user
${PASSWORD}    secret_sauce

*** Test Cases ***
Login Successfully with Standard User
    Open Saucedemo And Login    ${USERNAME}    ${PASSWORD}
    Get Url    contains    inventory
    Close Browser

Login With Wrong Password
    Open Saucedemo And Login    ${USERNAME}    wrong_passsword
    Get Text    [data-test="error"]    contains    do not match   
    Close Browser

Login With Locked Out User
    Open Saucedemo And Login    locked_out_user    secret_sauce
    Get Text       [data-test="error"]    contains    locked out
    Close Browser

*** Keywords ***
Open Saucedemo And Login
    [Arguments]    ${username}    ${password}
    New Browser    chromium   headless=False
    New Page    ${BASE_URL}
    Fill Text    id=user-name    ${username}
    Fill Text    id=password    ${password}
    Click    id=login-button 