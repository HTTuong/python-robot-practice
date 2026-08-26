*** Settings ***
Library    Browser

*** Variables ***
${BASE_URL}    https://www.saucedemo.com
${USERNAME}    standard_user
${PASSWORD}    secret_sauce

*** Test Cases ***
Login Successfully with Standard User
    New Browser    chromium    headless=False
    New Page    ${BASE_URL}
    Fill Text    id=user-name    ${USERNAME}
    Fill Text    id=password    ${PASSWORD}
    Click    id=login-button
    Get Url    contains    inventory
    Close Browser