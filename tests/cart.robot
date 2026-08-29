*** Settings ***
Library    Browser
Library    Collections
Resource    ../resources/saucedemo_keywords.resource
Test Teardown    Close Browser

*** Test Cases ***
Check Cart With 3 Products
    Open Browser To Saucedemo
    Login And Add N Products To Cart    3
    ${badge}=    Get Cart Badge Count
    Should Be Equal As Strings    ${badge}    3

Add Product To Cart And Check Cart Badge
    Open Browser To Saucedemo
    Login With Dynamic User    # robotcode: ignore

    Get Element Count    css=.inventory_item    ==    6

    Click    css=.inventory_item:nth-child(1) >> css=button
    ${badge}=    Get Cart Badge Count
    Should Be Equal As Strings    ${badge}    1

    Click    css=.inventory_item:nth-child(2) >> css=button
    ${badge}=     Get Cart Badge Count
    Should Be Equal As Strings    ${badge}    2
    Verify Cart Badge Or Empty    2

Remove Product In Cart And Check Cart Badge
    Open Browser To Saucedemo
    Login With Dynamic User    # robotcode: ignore

    Click    css=[data-test="add-to-cart-sauce-labs-backpack"]
    Get Text    css=.shopping_cart_badge    ==    1

    Click    css=[data-test="remove-sauce-labs-backpack"]
    Get Element Count    css=.shopping_cart_badge    ==    0




    