*** Settings ***
Resource    ../Resource/ObjectRepositories/CustomVariables.robot
Resource    ../Resource/Keywords/Keywords.robot

*** Variables ***
${first_name}      Jim
${last_name}       Tesson

*** Test Cases ***
Concatenate Names
    ${full_name}=    Set Variable    ${first_name} ${last_name}
    log to console              ${full_name}

