*** Settings ***
Library    SeleniumLibrary
Resource    variables.resource

*** Keywords ***
Open Browser And Login With No Password Check
    IF    "${HEADLESS}" == "True"
        Open Browser    ${BASE_URL}    chrome    options=add_argument("--headless=new")
    ELSE
        Open Browser    ${BASE_URL}    chrome
        ...    options=add_experimental_option("prefs", {"credentials_enable_service": False, "profile.password_manager_leak_detection": False})
    END
    Set Selenium Timeout    10s

Login With Standard User
    Input Text    id=user-name    ${USERNAME}
    Input Text    id=password    ${PASSWORD}
    Click Button    id=login-button
    Wait Until Location Contains    inventory
