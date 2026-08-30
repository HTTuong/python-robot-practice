*** Settings ***
Library    Browser
Library    Collections
Resource    ../resources/saucedemo_keywords.resource
Test Teardown    Close Browser

*** Test Cases ***
Sort product in ascending price
    Open Browser To Saucedemo
    Login With Dynamic User    # robotcode: ignore
    Select Options By    css=[data-test="product-sort-container"]    value    lohi

    ${count}=    Get Element Count    css=.inventory_item_price
    @{prices}=    Create List

    FOR    ${index}    IN RANGE    1    ${count + 1}
        ${price_text}=    Get Text    css=:nth-match(.inventory_item_price, ${index})
        Append To List    ${prices}    ${price_text}
    END
    Log    ${prices}
