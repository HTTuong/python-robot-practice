*** Settings ***
Library    RequestsLibrary
Resource    variables.resource

*** Keywords ***
Create JSONPlaceholder Session
    Create Session    jsonplaceholder    https://jsonplaceholder.typicode.com

