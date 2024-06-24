*** Settings ***
Resource    ../Resource/ObjectRepositories/CustomVariables.robot
Resource    ../Resource/Keywords/Keywords.robot

*** Test Cases ***
Openn

    open browser    https://www.google.com    chrome
