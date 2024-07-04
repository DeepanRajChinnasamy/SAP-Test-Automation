*** Settings ***
Resource    ../Resource/ObjectRepositories/CustomVariables.robot
#Library    Browser
Library    ScreenCapLibrary


*** Test Cases ***
Journal Creation in STEP
    [Tags]    JC_CO_01
#    start video recording     #alias=None    name=Demo    fps=None    screen_percentage=1    embed=True    embed_width=100px  monitor=1
    Read All Input Values From STEP Input    ${Var_STEPInput}    Inputs
    ${GroupCodeCount}=    get length    ${GroupCodeList}
    ${RowCounter}    set variable    2
    ${ListIndexIterator}    set variable    0
    Lanch and Login STEP      ${Var_STEPWebLink}    ${Var_UserName}   ${Var_Password}
    FOR    ${GroupCodeIteratotr}    IN    @{GroupCodeList}
        ${GrpCode}    get from list    ${GroupCodeList}    ${ListIndexIterator}
        close all excel documents
        open excel document    ${execdir}${Var_ExcelForm}    docID2
        Write Output Excel    Upload    JournalGroupCode    2    ${GrpCode}
        save excel document    ${execdir}${Var_ExcelForm}
        close all excel documents
        open excel document    ${Var_STEPInput}    docID
        ${PrintIssn}    get from list    ${PrintISSNList}    ${ListIndexIterator}
        ${DigitalISSN}    get from list    ${DigitalISSNList}    ${ListIndexIterator}
        ${EditorialApprover}    get from list    ${EditorialApproverList}    ${ListIndexIterator}
        ${DigitalCode}    get from list    ${DigitalCodeList}    ${ListIndexIterator}
        ${FIApprover}    get from list    ${FIApproverList}    ${ListIndexIterator}
        ${SAPCC}    get from list    ${SAPCCList}    ${ListIndexIterator}
        ${EditCategory}    get from list    ${EditCategoryList}    ${ListIndexIterator}
        ${VCHIdentifier}    get from list    ${VCHIdentifierList}    ${ListIndexIterator}
        ${PrintCode}    get from list    ${PrintCodeList}    ${ListIndexIterator}
        ${JouranType}    get from list    ${JournalTypeList}    ${ListIndexIterator}
        ${RandomString}=    generate random string    4    [UPPER]
        ${AutomationJouranlName}    catenate    SEPARATOR=-    Automation    ${RandomString}
#        ${AutomationJouranlName}=    set variable    Automation-SFRO
        Intiate Journal    ${AutomationJouranlName}
        JS Click Element    ${Var_HomeScreenButton}
        wait until element is visible    ${Var_JournalBaseLineInfoLink}
        sleep    2s
#        ${DataCheckFlag}=    set variable    False
        ${DataCheckFlag}=    Enter Data in JournalBaseLine    ${GrpCode}    ${DigitalISSN}    ${DigitalCode}    ${PrintIssn}    ${PrintCode}
        IF    '${DataCheckFlag}'=='False'
            Navigate to Journal    ${AutomationJouranlName}
            Navigate to Manual Enrichment and Update details
            IF   '${JouranType}'=='VCH'
                Update VCH Identifier    ${RandomString}        ${VCHIdentifier}
            END
            Adding Reference in Finance Controls    ${FIApprover}
            sleep    3s
            save screenshot
            Add Reference in Editorial    ${EditCategory}    ${EditorialApprover}
            sleep    5s
            Add Reference In SAPCostCentre    ${SAPCC}
            sleep    5s
            JS Click Element    ${Var_SaveButton}
            sleep    3s
            JS Click Element    ${Var_HomeScreenButton}
            sleep    25s
            Upload the form    ${execdir}${Var_ExcelForm}
            sleep    2s
            Navigate to Journal    ${AutomationJouranlName}
            Wait Until Page Contains Element    ${Var_Spiltter1}
            ${splitter_element}=    Get Webelement    ${Var_Spiltter1}
            Drag And Drop By Offset    ${splitter_element}    0   200
            save screenshot
            FOR    ${reloaditerator}    IN RANGE    25
                reload page
                sleep    4s
                ${Percentage}=    get text    ${Var_Percentagetext}
                IF    '${Percentage}'=='100%'
                    exit for loop
                END
                sleep    2s
            END
#            ${Percentage}=    set variable    100%
            IF    '${Percentage}'=='100%'
                Validate the content and update the excel    ${Percentage}    100%    Inputs    ManualEnrichmentStatus    ${RowCounter}
                Write Output Excel    Inputs    ManualEnrichmentStatus    ${RowCounter}    ${Percentage}
                JS Click Element    ${Var_HomeScreenButton}
                sleep    3s
                SeleniumLibrary.click element    ${Var_ManualEnrichMentLink}
                sleep    2s
                JS Click Element    //*[@title="${AutomationJouranlName}"]
                JS Click Element    ${Var_SubmitMedia}
                seleniumlibrary.input text    ${Var_Popuptextbox}    Test
                JS Click Element    ${Var_JouranalBasePopOkayButton}
                sleep    2s
                JS Click Element    ${Var_HomeScreenButton}
                sleep    3s
                JS Click Element    ${Var_JournalCompleteLink}
                Execute Javascript    window.scrollBy(0, 1000);
                sleep    5s
                ${LinksCount}=    get element count    (//*[@class="sheet-header-cell sheet-header-horizontal"])
                set suite variable    ${LinksCount}    ${LinksCount}
                FOR   ${Iter}    IN RANGE    1    ${LinksCount}
                    ${text}=    get text    (//*[@class="sheet-header-cell sheet-header-horizontal"])[${Iter}]
                    IF    '${text}'== '${AutomationJouranlName}'
                        JS Click Element    (//*[@class="stb-NodeDetails-unselected"])[${Iter}]
    #                    set suite variable    ${Iter}    ${Iter}
                        exit for loop
                    END
                END
#    #            # For Print Type
                sleep    25s
                Add Details in Journal Complete
                save screenshot
                sleep    3s
                JS Click Element    ${Var_JournalCompleteLink}
                Execute Javascript    window.scrollBy(0, 1000);
                sleep    3s
                FOR   ${intIter}    IN RANGE    1    ${LinksCount}
                    ${text}=    get text    (//*[@class="sheet-header-cell sheet-header-horizontal"])[${intIter}]
                    IF    '${text}'== '${AutomationJouranlName}'
                        ${intIndexPostition}=    Evaluate    ${intIter} + 1
                        JS Click Element    (//*[@class="stb-NodeDetails-unselected"])[${intIndexPostition}]
                        exit for loop
                    END
                END
    #            # For Digital Type
                sleep    4s
                Add Details in Journal Complete
                JS Click Element    ${Var_HomeScreenButton}
                sleep    3s
                JS Click Element    ${Var_JournalCompleteLink}
                sleep    3s
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
               JS Click Element    ${Var_HomeScreenButton}
               ###Adding the details in Journal Offerings####
               Navigate to Journal    ${AutomationJouranlName}
               JS Click Element    (//*[@class="material-icons"])[1]
               JS Click Element    //*[@id="stibo_tab_Journal_Offerings"]//div
               set selenium speed    0s
               sleep    3s
               set selenium speed    2s
               JS Click Element    (//*[@class="menulink"])[1]
               ${strCheckFlag}=    run keyword and return status    element should be visible   //*[@id="stibo_tab_Digital_Journal_Details"]
               IF    '${strCheckFlag}'=='True'
                    JS Click Element    //*[@id="stibo_tab_Digital_Journal_Details"]
                    JS Click Element    (//*[@id="Available_in_PQ"]//*[contains(@id,"gwt-uid")])[2]
               ELSE
                    JS Click Element    //*[@class="material-icons navigation-panel-BackToList"]
                    JS Click Element    (//*[@class="menulink"])[2]
                    JS Click Element    //*[@id="stibo_tab_Digital_Journal_Details"]
                    JS Click Element    (//*[@id="Available_in_PQ"]//*[contains(@id,"gwt-uid")])[2]
               END
               set selenium speed    0s
               JS Click Element    ${Var_SaveButton}
               sleep    3s
               JS Click Element    (//*[@class="material-icons"])[1]
               sleep    3s
               wait until element is visible    ${Var_HomeScreenButton}
               JS Click Element    ${Var_HomeScreenButton}
               sleep    3s
               Ready to Publish    ${AutomationJouranlName}
            ELSE
                Write Output Excel    Inputs    ManualEnrichmentStatus    ${RowCounter}    ${Percentage}
            END
        ELSE
            Write Output Excel    Inputs    ManualEnrichmentStatus    ${RowCounter}    Data_Already_Used
        END
        ${RowCounter}=    evaluate    ${RowCounter} + int(${1})
        ${ListIndexIterator}=    evaluate    ${ListIndexIterator} + int(${1})
        save excel document   ${Var_STEPInput}
        save screenshot
    END
    close all excel documents
#    close browser
#    stop video recording

