*** Settings ***
Library    Browser
Resource    ../resources/saucedemo_keywords.resource
Test Teardown    Close Browser

*** Test Cases ***
Login Successfully with Standard User
    Open Browser To Saucedemo
    Login With Dynamic User     # robotcode: ignore
    Get Url    contains    inventory

Login With Wrong Password 
    Open Browser To Saucedemo
    Login With Dynamic User    ${USERNAME}    wrong_passsword
    Get Text    [data-test="error"]    contains    do not match   

Login With Locked Out User
    Open Browser To Saucedemo
    Login With Dynamic User    locked_out_user    secret_sauce
    Get Text       [data-test="error"]    contains    locked out


