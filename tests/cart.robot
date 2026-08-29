*** Settings ***
Library    Browser
Library    Collections
Task Setup    Open Browser To Saucedemo
Test Teardown    Close Browser

*** Variables ***
${BASE_URL}    https://www.saucedemo.com
${USERNAME}    standard_user
${PASSWORD}    secret_sauce

*** Test Cases ***
Check Cart With 3 Products
    Login And Add N Products To Cart    3
    ${badge}=    Get Cart Badge Count
    Should Be Equal As Strings    ${badge}    3

Add Product To Cart And Check Cart Badge
    Fill Text    id=user-name    ${USERNAME}
    Fill Text    id=password    ${PASSWORD}
    Click    id=login-button

    Get Element Count    css=.inventory_item    ==    6

    Click    css=.inventory_item:nth-child(1) >> css=button
    ${badge}=    Get Cart Badge Count
    Should Be Equal As Strings    ${badge}    1

    Click    css=.inventory_item:nth-child(2) >> css=button
    ${badge}=     Get Cart Badge Count
    Should Be Equal As Strings    ${badge}    2

Remove Product In Cart And Check Cart Badge
    Fill Text    id=user-name    ${USERNAME}
    Fill Text    id=password    ${PASSWORD}
    Click    id=login-button

    Click    css=[data-test="add-to-cart-sauce-labs-backpack"]
    Get Text    css=.shopping_cart_badge    ==    1

    Click    css=[data-test="remove-sauce-labs-backpack"]
    Get Element Count    css=.shopping_cart_badge    ==    0

*** Keywords ***
Open Browser To Saucedemo
    New Browser    chromium    headless=False
    New Page    ${BASE_URL}

Login As Standard User
    [Arguments]    ${username}    ${password}
    Fill Text    id=user-name    ${username}
    Fill Text    id=password    ${password}
    Click    id=login-button

Get Cart Badge Count
    ${count}=    Get Text    css=.shopping_cart_badge
    RETURN    ${count}

Add N Products To Cart
    [Arguments]    ${count: int}=1
    FOR    ${index}    IN RANGE    1    ${count + 1}
        Add Product To Cart By Index    ${index}
    END
    
Add Product To Cart By Index
    [Arguments]    ${index}=1
    Click    css=.inventory_item:nth-of-type(${index}) .btn_inventory

Login And Add N Products To Cart
    [Arguments]    ${product_count}=1
    Login As Standard User    ${USERNAME}    ${PASSWORD}
    Add N Products To Cart    ${product_count}


    