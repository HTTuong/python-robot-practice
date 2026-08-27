*** Settings ***
Library    Browser
Library    Collections

*** Variables ***
${BASE_URL}    https://www.saucedemo.com
${USERNAME}    standard_user
${PASSWORD}    secret_sauce

*** Test Cases ***
Sort product in ascending price
    New Browser    chromium    headless=False
    New Page    ${BASE_URL}   
    Fill Text    id=user-name    ${USERNAME}
    Fill Text    id=password    ${PASSWORD}
    Click    id=login-button

    Select Options By    css=[data-test="product-sort-container"]    value    lohi

    ${count}=    Get Element Count    css=.inventory_item_price
    @{prices}=    Create List

    FOR    ${index}    IN RANGE    1    ${count + 1}
        ${price_text}=    Get Text    css=:nth-match(.inventory_item_price, ${index})
        Append To List    ${prices}    ${price_text}
    END

    Log    ${prices}

    Close Browser