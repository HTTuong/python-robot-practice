*** Settings ***
Resource    ../resources/saucedemo_keywords.resource
Test Teardown    Close Browser

*** Test Cases ***
Checkout Successfully
    Login And Add N Products To Cart    1
    Complete Checkout
    Get Text    css=.complete-header    ==    Thank you for your order!

