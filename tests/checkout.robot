*** Settings ***
Resource    ../resources/saucedemo_keywords.resource
Resource    ../resources/locators.resource
Test Teardown    Close Browser

*** Test Cases ***
Checkout Successfully
    Open Browser To Saucedemo
    Login And Add N Products To Cart    1
    Complete Checkout
    Get Text    css=.complete-header    ==    Thank you for your order!

Checkout Failed With No Firstname
    Open Browser To Saucedemo
    Login And Add N Products To Cart    1
    Click    css=.shopping_cart_link
    Click    css=[data-test="checkout"]
    Click    css=[data-test="continue"]
    Get Text    ${ERROR}    contains    First Name is required

Sort Product From Z To A
    Open Browser To Saucedemo
    Login And Add N Products To Cart    0
    Select Options By    css=[data-test="product-sort-container"]    value    az
    Get Text    css=:nth-match(.inventory_item_name, 1)    ==    Sauce Labs Backpack

Check Continue Button In Checkout Page
    Open Browser To Saucedemo
    Login And Add N Products To Cart    1
    Click    css=.shopping_cart_link
    Click    css=[data-test="continue-shopping"]
    Get Url    contains    inventory.html

Logout Successfull
    Open Browser To Saucedemo
    Login And Add N Products To Cart    0
    Click    css=#react-burger-menu-btn
    Click    css=#logout_sidebar_link
    Get Url    ==    https://www.saucedemo.com/