*** Settings ***
Library    Browser
Library    Collections
Suite Setup    Open Browser To Saucedemo
Suite Teardown    Close Browser

*** Variables ***
${BASE_URL}    https://www.saucedemo.com
${USERNAME}    standard_user
${PASSWORD}    secret_sauce

*** Test Cases ***
Add Product To Cart And Check Cart Badge
    Fill Text    id=user-name    ${USERNAME}
    Fill Text    id=password    ${PASSWORD}
    Click    id=login-button

    Click    css=.inventory_item:nth-child(1) >> css=button
    Get Text    css=.shopping_cart_badge    ==    1

    Click    css=.inventory_item:nth-child(2) >> css=button
    Get Text    css=.shopping_cart_badge    ==    2

*** Keywords ***
Open Browser To Saucedemo
    New Browser    chromium    headless=False
    New Page    ${BASE_URL}
    