*** Settings ***
Library    SeleniumLibrary
Resource    ../resources/selenium_keywords.resource
Test Teardown    Close Browser

*** Test Cases ***
Add Product To Cart And Check Cart Badge
    Open Browser And Login With No Password Check
    Login With Standard User
    Wait Until Element Is Visible    css=.inventory_item:nth-of-type(1) .btn_inventory
    Wait Until Element Is Enabled    css=.inventory_item:nth-of-type(1) .btn_inventory
    Click Element    css=.inventory_item:nth-of-type(1) .btn_inventory
    Wait Until Element Contains    css=.shopping_cart_badge    1

    Wait Until Element Is Visible    css=.inventory_item:nth-of-type(2) .btn_inventory
    Wait Until Element Is Enabled    css=.inventory_item:nth-of-type(2) .btn_inventory
    Click Element    css=.inventory_item:nth-of-type(2) .btn_inventory
    Wait Until Element Contains    css=.shopping_cart_badge    2   

Remove Product In Cart And Check Cart Badge
    Open Browser And Login With No Password Check
    Login With Standard User
    Wait Until Element Is Visible    css=[data-test="add-to-cart-sauce-labs-backpack"]
    Wait Until Element Is Enabled    css=[data-test="add-to-cart-sauce-labs-backpack"]
    Click Element    css=[data-test="add-to-cart-sauce-labs-backpack"]
    Wait Until Element Contains    css=.shopping_cart_badge    1

    Wait Until Element Is Visible    css=[data-test="remove-sauce-labs-backpack"]
    Wait Until Element Is Enabled    css=[data-test="remove-sauce-labs-backpack"]
    Click Element    css=[data-test="remove-sauce-labs-backpack"]
    Wait Until Page Does Not Contain Element    css=.shopping_cart_badge    timeout=30s

