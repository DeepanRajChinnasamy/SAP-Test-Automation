*** Settings ***
Resource    ../Resource/ObjectRepositories/CustomVariables.robot

*** Test Cases ***
Jouranl Creation Via Handoverform
    Lanch and Login STEP      ${Var_STEPWebLink}    ${Var_UserName}   ${Var_Password}
    Read All Input Values HandoverForm    ${Var_Handoverformfile}    PDMUseOnly
    Upload the Handoverform    ${Var_Handoverformfile}
    ${ListIndexIterator}    set variable    0
    FOR    ${Productcount}  IN    @{ProductTitleList}
        ${AutomationJouranlName}    get from list    ${ProductTitleList}    ${ListIndexIterator}
        Navigate to Journal    ${AutomationJouranlName}
        ${Percentage}=    Get ManualEnrichment Percentage
        IF    '${Percentage}'=='100%'
            click homescreenbutton
            Submit Media in ManualEnrichment    ${AutomationJouranlName}
            click homescreenbutton
            sleep    3s
            Submit Media in Journal Complete    ${AutomationJouranlName}
            click homescreenbutton
            sleep    5s
            Ready to Publish    ${AutomationJouranlName}
        END
        ${ListIndexIterator}=    evaluate    ${ListIndexIterator} + int(${1})
    END
    close all excel documents



*** Keywords ***

Submit Media in Journal Complete
    [Arguments]    ${AutomationJouranlName}
    JS Click Element    ${Var_JournalCompleteLink}
    Execute Javascript    window.scrollBy(0, 1000);
    sleep    5s
    ${LinksCount}=    get element count    (//*[@class="sheet-header-cell sheet-header-horizontal"])
    set suite variable    ${LinksCount}    ${LinksCount}
    FOR   ${Iterator}    IN RANGE    1    ${LinksCount}
        ${text}=    get text    (//*[@class="sheet-header-cell sheet-header-horizontal"])[${Iterator}]
        IF    '${text}'== '${AutomationJouranlName}'
            JS Click Element    (//*[@class="sheet-header-cell sheet-header-horizontal"])[${Iterator}]
            ${IndexPostition}=    Evaluate    ${Iterator} + 1
            JS Click Element    (//*[@class="sheet-header-cell sheet-header-horizontal"])[${IndexPostition}]
            exit for loop
        END
    END
    set selenium speed    2s
    JS Click Element    ${Var_SubmitMedia}
    seleniumlibrary.input text    ${Var_Popuptextbox}    Test
    JS Click Element    ${Var_JouranalBasePopOkayButton}

Submit Media in ManualEnrichment
    [Arguments]    ${AutomationJouranlName}
    sleep    3s
    SeleniumLibrary.click element    ${Var_ManualEnrichMentLink}
    sleep    2s
    JS Click Element    //*[@title="${AutomationJouranlName}"]
    JS Click Element    ${Var_SubmitMedia}
    seleniumlibrary.input text    ${Var_Popuptextbox}    Test
    JS Click Element    ${Var_JouranalBasePopOkayButton}
    sleep    2s

Click HomescreenButton
    JS Click Element    ${Var_HomeScreenButton}

Get ManualEnrichment Percentage
    Wait Until Page Contains Element    ${Var_Spiltter1}
    ${splitter_element}=    Get Webelement    ${Var_Spiltter1}
    Drag And Drop By Offset    ${splitter_element}    0   200
    FOR    ${reloaditerator}    IN RANGE    25
        reload page
        sleep    4s
        ${Percentage}=    get text    ${Var_Percentagetext}
        IF    '${Percentage}'=='100%'
            exit for loop
        END
        sleep    2s
    END
    set variable    ${Percentage}    ${Percentage}
    [Return]    ${Percentage}