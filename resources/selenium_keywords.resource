*** Settings ***
Library    SeleniumLibrary
Resource    variables.resource

*** Keywords ***
Open Browser And Login With No Password Check
    IF    "${HEADLESS}" == "True"
        Open Browser    ${BASE_URL}    chrome
        ...    options=add_argument("--headless=new");add_argument("--no-sandbox");add_argument("--disable-dev-shm-usage");add_argument("--disable-gpu");add_argument("--window-size=1920,1080")
        Set Selenium Timeout    30s
    ELSE
        Open Browser    ${BASE_URL}    chrome
        ...    options=add_experimental_option("prefs", {"credentials_enable_service": False, "profile.password_manager_leak_detection": False})
        Set Selenium Timeout    10s
    END
    Wait Until Element Is Visible    id=user-name

Login With Standard User
    Input Text    id=user-name    ${USERNAME}
    Input Text    id=password    ${PASSWORD}
    Click Button    id=login-button
    Wait Until Location Contains    inventory
