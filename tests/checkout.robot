*** Settings ***
Resource    ../resources/saucedemo_keywords.resource
Test Teardown    Close Browser

*** Test Cases ***
Checkout Successfully
    Login And Add N Products To Cart    1
    Complete Checkout
    Get Text    css=.complete-header    ==    Thank you for your order!

Checkout Failed With No Firstname
    Login And Add N Products To Cart    1
    Click    css=.shopping_cart_link
    Click    css=[data-test="checkout"]
    Click    css=[data-test="continue"]
    Get Text    css=[data-test="error"]    contains    First Name is required