*** Settings ***
Library    Browser
Resource    ../resources/saucedemo_keywords.resource
Resource    ../resources/locators.resource
Test Teardown    Close Browser

*** Test Cases ***
Login Successfully with Standard User
    Open Browser To Saucedemo
    Login With Dynamic User     # robotcode: ignore
    Get Url    contains    inventory

Login With Wrong Password 
    Open Browser To Saucedemo
    Login With Dynamic User    ${USERNAME}    wrong_passsword
    Get Text    ${ERROR}    contains    do not match   

Login With Locked Out User
    Open Browser To Saucedemo
    Login With Dynamic User    locked_out_user    secret_sauce
    Get Text       ${ERROR}    contains    locked out


