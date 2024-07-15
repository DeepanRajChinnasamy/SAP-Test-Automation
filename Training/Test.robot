*** Settings ***
Resource    ../Resource/ObjectRepositories/CustomVariables.robot
Library    ../TestSuites/CustomLib.py
Library    ../TestSuites/Response.py

*** Variables ***
${first_name}      Jim
${last_name}       Tesson

*** Test Cases ***
Concatenate Names
    Launch and Login DBS    https://wileyas.qa2.viax.io/price-proposals    ${username}    ${password}
    sleep    15s
#    select from list by index    //*[@class="x-drop-down__field x-drop-down__field_none-left-shift"]
    JS Click Element    //*[contains(@id,"single-spa-application:parcel")]//Span//div
    sleep    5s
    JS Click Element    (//*[contains(@id,"single-spa-application:parcel")]//div[2]/div/div[1]/div)[3]
    JS Click Element    //*[@class="x-button x-button_type_primary"]

