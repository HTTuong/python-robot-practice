*** Settings ***
Library    Browser
Resource    variables.resource
Resource    locators.resource

*** Keywords ***
Open Browser To Saucedemo
    New Browser    chromium    headless=False
    New Page    ${BASE_URL}

Login With Dynamic User
    [Arguments]    ${login_username}=${USERNAME}    ${login_password}=${PASSWORD}
    Fill Text    id=user-name    ${login_username}
    Fill Text    id=password    ${login_password}
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
    Login With Dynamic User    ${USERNAME}    ${PASSWORD}
    Add N Products To Cart    ${product_count}

Verify Cart Badge Or Empty
    [Arguments]    ${expected_count}
    IF    ${expected_count} == 0
        Get Element States    css=.shopping_cart_badge    contains    hidden
    ELSE
        Get Text    css=.shopping_cart_badge    ==    ${expected_count}
    END

Complete Checkout
    [Arguments]    ${first_name}=Tuong    ${last_name}=Hoang    ${postal_code}=00760
    Click    css=.shopping_cart_link
    Click    css=[data-test="checkout"]
    Fill Text    css=[data-test="firstName"]    ${first_name}
    Fill Text    css=[data-test="lastName"]    ${last_name}
    Fill Text    css=[data-test="postalCode"]    ${postal_code}
    Click    css=[data-test="continue"]
    Click    css=[data-test="finish"]

# Template
Login With Invalid Credential Should Fail
    [Arguments]    ${username}    ${password}    ${error_message}    ${tags}=${EMPTY}
    IF    $tags
        Set Tags    ${tags}
    END
    Open Browser To Saucedemo
    Login With Dynamic User    ${username}    ${password}
    Get Text    ${ERROR}    contains    ${error_message}

Checkout With Invalid Info Should Show Error
    [Arguments]    ${firstname}    ${lastname}    ${postal_code}    ${error_message}
    Open Browser To Saucedemo
    Login With Dynamic User
    Click    css=.shopping_cart_link
    Click    css=[data-test="checkout"]
    Fill Text    css=[data-test="firstName"]    ${first_name}
    Fill Text    css=[data-test="lastName"]    ${last_name}
    Fill Text    css=[data-test="postalCode"]    ${postal_code}
    Click    css=[data-test="continue"]
    Get Text    ${ERROR}    contains    ${error_message}

    