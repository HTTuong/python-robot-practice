*** Settings ***
Library    SeleniumLibrary
Test Setup     Open Browser And Login
Test Teardown    Close Browser

*** Variables ***
${BASE_URL}    https://www.saucedemo.com
${BROWSER}     chrome

*** Test Cases ***
Add Product To Cart And Check Cart Badge
    Click Element    css=.inventory_item:nth-of-type(1) .btn_inventory
    Wait Until Element Contains    css=.shopping_cart_badge    1

    Click Element    css=.inventory_item:nth-of-type(2) .btn_inventory
    Wait Until Element Contains    css=.shopping_cart_badge    2   

Remove Product In Cart And Check Cart Badge
    Click Element    css=[data-test="add-to-cart-sauce-labs-backpack"]
    Wait Until Element Contains    css=.shopping_cart_badge    1

    Click Element    css=[data-test="remove-sauce-labs-backpack"]
    Wait Until Page Does Not Contain Element    css=.shopping_cart_badge    timeout=5s

*** Keywords ***
Open Browser And Login
    Open Browser    ${BASE_URL}    ${BROWSER}
    ...    options=add_experimental_option("prefs", {"credentials_enable_service": False, "profile.password_manager_leak_detection": False})
    Set Selenium Timeout    10s
    Input Text    id=user-name    standard_user
    Input Text    id=password    secret_sauce
    Click Button    id=login-button
    Wait Until Location Contains    inventory