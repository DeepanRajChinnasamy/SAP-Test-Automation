*** Settings ***
Resource    ../Resource/ObjectRepositories/CustomVariables.robot
Library     ../Resource/ObjectRepositories/CustomLib.py
Library     ../Resource/ObjectRepositories/Response.py
Suite Setup     Open Excel and DBS    ${DealsInputExcelPath}    ${DealURL}    ${username}    ${password}
Suite Teardown   Close Excel and Browser
Test Setup    ReLaunch DBS    ${DealURL}    ${username}    ${password}

*** Variables ***
${file}    \\UploadExcel\\E2E_JsonTemplates\\
${SubId}    24ef<<RandomNum>>-<<Randomt3digit>>b-4808-9127-af8e42410<<RandonDynId>>
${DealURL}
${QA2_Graphql}    https://api.wileyas.stage.viax.io/graphql
${DealsInputExcelPath}    ${execdir}\\UploadExcel\\TD_DealCreation.xlsx
${Screenshotfolder}    ${execdir}\\\Screenshots\\

*** Test Cases ***
ScreenShot
    [Tags]    id=SS_01
    ${ListIndexIterator}    set variable    0
    ${DataIndexIterator}    set variable    0
    ${ScenarioIDCount}=    get length    ${ScenarioList}
    ${RowCounter}    set variable    2
    FOR    ${ScenarioIterator}    IN RANGE    ${ScenarioIDCount}
        ${ExecutionFlag}=    get from list    ${ExecutionFlagList}    ${ListIndexIterator}
        ${ScenarioName}=    get from list    ${ScenarioList}   ${ListIndexIterator}
        ${biId}=    get from list    ${DealIDList}    ${ListIndexIterator}
        SeleniumLibrary.input text    ${SearchBox}   ${biId}
        sleep    3s
        wait until element is visible     //*[@title="${biId}"]
        seleniumlibrary.click element    //*[@title="${biId}"]
        sleep    3s
        customvariables.save screenshot    ${Screenshotdir}    ${biId}
        ${ListIndexIterator}=    evaluate    ${ListIndexIterator} + int(${1})
        ${RowCounter}=    evaluate    ${RowCounter} + int(${1})
        go back
        sleep    2s
    END
    save excel document    ${DealsInputExcelPath}

NonTAPostpaid
    [Tags]    id=DC_01
    ${ListIndexIterator}    set variable    0
    ${DataIndexIterator}    set variable    0
    ${ScenarioIDCount}=    get length    ${ScenarioList}
    ${RowCounter}    set variable    2
    FOR    ${ScenarioIterator}    IN RANGE    ${ScenarioIDCount}
        ${ExecutionFlag}=    get from list    ${ExecutionFlagList}    ${ListIndexIterator}
        ${ScenarioName}=    get from list    ${ScenarioList}   ${ListIndexIterator}
        IF    '${ScenarioName}' == 'NonTAPostpaid'
            ${Environment}=    get from list    ${EnvironmentList}    ${ListIndexIterator}
            ${json_content}=  Get File  ${execdir}${file}NONTAPostpaid.json
            ${BPID}=    get from list    ${BPIDList}    ${ListIndexIterator}
            set suite variable   ${BPID}    ${BPID}
            ${Currency}=    get from list    ${CurrencyList}    ${ListIndexIterator}
            set suite variable   ${Currency}    ${Currency}
            ${json_content}=    Generate the JSON file PP    ${json_content}
            Write Output Excel    DealCreation    Code    ${RowCounter}   ${code}${randomnum2digit}
            Write Output Excel    DealCreation    ID    ${RowCounter}    ${random_4_digit_number}7890
            Switch Case    ${Environment}
            create session    order_session    ${DealURL}    verify=True
            ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${AuthToken}
            ${response}=     post on session    order_session    url=${GraphqlURL}     data=${json_content}     headers=${headers}
            # Getting the content value
            Log    Status Code: ${response.status_code}
            Log    Response Content: ${response.content}
            ${response.status_code}=  convert to string    ${response.status_code}
            Validate the content and update the excel    200    ${response.status_code}    DealCreation    ResponseStatusCode    ${RowCounter}
            set variable    ${response.content}
            set variable    ${response.json()}
            ${response_text}=    convert to string    ${response.content}
            ${response.json()}=    convert to string    ${response.json()}
            ${text}    set variable   ${response_text}
            ${text}=    replace string    ${text}    null    None
            ${text}    Replace String    ${text}    false    False
            ${text}    Replace String    ${text}    true    True
            ${JsonResp}    Evaluate    ${text}    json
            ${status}    CustomLib.Get Value From Json    ${JsonResp}    $.data.wAsHandleVersionEvent.status
            ${status}=    convert to string    ${status}
            should contain    ${status}    SUCCESS
            ${biId}    CustomLib.Get Value From Json    ${JsonResp}    $.data.wAsHandleVersionEvent.data.versionId
            ${biId}    convert to string    ${biId}
            ${biId}    remove string    ${biId}    [
            ${biId}    remove string    ${biId}    ]
            ${biId}    remove string    ${biId}    '

            SeleniumLibrary.input text    ${SearchBox}   ${biId}
            sleep    5s
            wait until element is visible     //*[@title="#${biId}"]
            seleniumlibrary.click element    //*[@title="#${biId}"]
            sleep    7s
            ${UIStatus}=    SeleniumLibrary.get text   //*[@class="deal-status-button"]
            Write Output Excel    DealCreation    UIDealStatus   ${RowCounter}    ${UIStatus}
            ${UICode}=    seleniumlibrary.get text    //*[@class="detail-value"][3]
            Validate the content and update the excel    ${code}${randomnum2digit}    ${UICode}    DealCreation    Code    ${RowCounter}
            ${description}=    seleniumlibrary.get text    xpath=//*[@class="deal-desc"]
            ${dealId}=    seleniumlibrary.get text    (//*[@class="x-expand-card__main-title"])[1]
            Write Output Excel    DealCreation    DealId    ${RowCounter}    ${dealId}
            @{description}=    split string    ${description}    •
            ${ID}=    get from list    ${description}    1
            ${ID}=    remove string    ${ID}    ${SPACE}
            ${date} =    get from list    ${description}    2
            @{date}=    split string    ${date}    ${SPACE}
            ${date1}=    get from list    ${date}    1
            ${Bpid}=    seleniumlibrary.get text    xpath=//*[@class="detail-value"][4]
            Validate the content and update the excel    ${Bpid}    ${BPID}     DealCreation    UIBPID    ${RowCounter}
            Validate the content and update the excel    ${random_4_digit_number}7890    ${ID}    DealCreation    ID    ${RowCounter}
            Write Output Excel    DealCreation    BPID   ${RowCounter}    ${Bpid}
            Write Output Excel    DealCreation    UIDealStatus   ${RowCounter}    ${UIStatus}
            Write Output Excel    DealCreation    Date   ${RowCounter}    ${date1}
            save excel document    ${DealsInputExcelPath}
        END
        save excel document    ${DealsInputExcelPath}
        ${ListIndexIterator}=    evaluate    ${ListIndexIterator} + int(${1})
        ${RowCounter}=    evaluate    ${RowCounter} + int(${1})
    END
    save excel document    ${DealsInputExcelPath}

NonTAPrepaid
    [Tags]    id=DC_02
    ${ListIndexIterator}    set variable    0
    ${DataIndexIterator}    set variable    0
    ${ScenarioIDCount}=    get length    ${ScenarioList}
    ${RowCounter}    set variable    2
    FOR    ${ScenarioIterator}    IN RANGE    ${ScenarioIDCount}
        ${ExecutionFlag}=    get from list    ${ExecutionFlagList}    ${ListIndexIterator}
        ${ScenarioName}=    get from list    ${ScenarioList}   ${ListIndexIterator}
        IF    '${ScenarioName}' == 'NONTAPrepaid'
            ${Environment}=    get from list    ${EnvironmentList}    ${ListIndexIterator}
            ${json_content}=  Get File  ${execdir}${file}NONTAPrepaid.json
            ${BPID}=    get from list    ${BPIDList}    ${ListIndexIterator}
            set suite variable   ${BPID}    ${BPID}
            ${Currency}=    get from list    ${CurrencyList}    ${ListIndexIterator}
            set suite variable   ${Currency}    ${Currency}
            ${json_content}=    Generate the JSON file PP    ${json_content}
            Write Output Excel    DealCreation    Code    ${RowCounter}   ${code}${randomnum2digit}
            Write Output Excel    DealCreation    ID    ${RowCounter}    ${random_4_digit_number}7890
            Switch Case    ${Environment}
            create session    order_session    ${DealURL}    verify=True
            ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${AuthToken}
            ${response}=     post on session    order_session    url=${GraphqlURL}     data=${json_content}     headers=${headers}
            # Getting the content value
            Log    Status Code: ${response.status_code}
            Log    Response Content: ${response.content}
            ${response.status_code}=  convert to string    ${response.status_code}
            Validate the content and update the excel    200    ${response.status_code}    DealCreation    ResponseStatusCode    ${RowCounter}
            set variable    ${response.content}
            set variable    ${response.json()}
            ${response_text}=    convert to string    ${response.content}
            ${response.json()}=    convert to string    ${response.json()}
            ${text}    set variable   ${response_text}
            ${text}=    replace string    ${text}    null    None
            ${text}    Replace String    ${text}    false    False
            ${text}    Replace String    ${text}    true    True
            ${JsonResp}    Evaluate    ${text}    json
            ${status}    CustomLib.Get Value From Json    ${JsonResp}    $.data.wAsHandleVersionEvent.status
            ${status}=    convert to string    ${status}
            should contain    ${status}    SUCCESS
            ${biId}    CustomLib.Get Value From Json    ${JsonResp}    $.data.wAsHandleVersionEvent.data.versionId
            ${biId}    convert to string    ${biId}
            ${biId}    remove string    ${biId}    [
            ${biId}    remove string    ${biId}    ]
            ${biId}    remove string    ${biId}    '
            Write Output Excel    DealCreation    DealId    ${RowCounter}    ${biId}
            SeleniumLibrary.input text    ${SearchBox}   ${biId}
            sleep    5s
            wait until element is visible     //*[@title="#${biId}"]
            seleniumlibrary.click element    //*[@title="#${biId}"]
            sleep    7s
            ${UIStatus}=    SeleniumLibrary.get text   //*[@class="deal-status-button"]
            Write Output Excel    DealCreation    UIDealStatus   ${RowCounter}    ${UIStatus}
            ${UICode}=    seleniumlibrary.get text    //*[@class="detail-value"][3]
            Validate the content and update the excel    ${code}${randomnum2digit}    ${UICode}    DealCreation    Code    ${RowCounter}
            ${description}=    seleniumlibrary.get text    xpath=//*[@class="deal-desc"]
            ${dealId}=    seleniumlibrary.get text    (//*[@class="x-expand-card__main-title"])[1]
            Write Output Excel    DealCreation    DealId    ${RowCounter}    ${dealId}
            @{description}=    split string    ${description}    •
            ${ID}=    get from list    ${description}    1
            ${ID}=    remove string    ${ID}    ${SPACE}
            ${date} =    get from list    ${description}    2
            @{date}=    split string    ${date}    ${SPACE}
            ${date1}=    get from list    ${date}    1
            ${Bpid}=    seleniumlibrary.get text    xpath=//*[@class="detail-value"][4]
            Validate the content and update the excel    ${random_4_digit_number}7890    ${ID}    DealCreation    ID    ${RowCounter}
            Write Output Excel    DealCreation    BPID   ${RowCounter}    ${Bpid}
            Write Output Excel    DealCreation    UIDealStatus   ${RowCounter}    ${UIStatus}
            Validate the content and update the excel    ${Bpid}    ${BPID}     DealCreation    UIBPID    ${RowCounter}
            Write Output Excel    DealCreation    Date   ${RowCounter}    ${date1}
            save excel document    ${DealsInputExcelPath}
        END
        save excel document    ${DealsInputExcelPath}
        ${ListIndexIterator}=    evaluate    ${ListIndexIterator} + int(${1})
        ${RowCounter}=    evaluate    ${RowCounter} + int(${1})
    END
    save excel document    ${DealsInputExcelPath}

TAPOSTPAID_Tier1
    [Tags]    id=DC_03
    ${ListIndexIterator}    set variable    0
    ${DataIndexIterator}    set variable    0
    ${ScenarioIDCount}=    get length    ${ScenarioList}
    ${RowCounter}    set variable    2
    FOR    ${ScenarioIterator}    IN RANGE    ${ScenarioIDCount}
        ${ExecutionFlag}=    get from list    ${ExecutionFlagList}    ${ListIndexIterator}
        ${ScenarioName}=    get from list    ${ScenarioList}   ${ListIndexIterator}
        IF    '${ScenarioName}' == 'TAPOSTPAID_Tier1'
            ${Environment}=    get from list    ${EnvironmentList}    ${ListIndexIterator}
            ${json_content}=  Get File  ${execdir}${file}TAPOSTPAID_Tier1.json
            ${BPID}=    get from list    ${BPIDList}    ${ListIndexIterator}
            set suite variable   ${BPID}    ${BPID}
            ${Currency}=    get from list    ${CurrencyList}    ${ListIndexIterator}
            set suite variable   ${Currency}    ${Currency}
            ${json_content}=    Generate the JSON file PP    ${json_content}
            Write Output Excel    DealCreation    Code    ${RowCounter}   ${code}${randomnum2digit}
            Write Output Excel    DealCreation    ID    ${RowCounter}    ${random_4_digit_number}7890
            Switch Case    ${Environment}
            create session    order_session    ${DealURL}    verify=True
            ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${AuthToken}
            ${response}=     post on session    order_session    url=${GraphqlURL}     data=${json_content}     headers=${headers}
            # Getting the content value
            Log    Status Code: ${response.status_code}
            Log    Response Content: ${response.content}
            ${response.status_code}=  convert to string    ${response.status_code}
            Validate the content and update the excel    200    ${response.status_code}    DealCreation    ResponseStatusCode    ${RowCounter}
            set variable    ${response.content}
            set variable    ${response.json()}
            ${response_text}=    convert to string    ${response.content}
            ${response.json()}=    convert to string    ${response.json()}
            ${text}    set variable   ${response_text}
            ${text}=    replace string    ${text}    null    None
            ${text}    Replace String    ${text}    false    False
            ${text}    Replace String    ${text}    true    True
            ${JsonResp}    Evaluate    ${text}    json
            ${status}    CustomLib.Get Value From Json    ${JsonResp}    $.data.wAsHandleVersionEvent.status
            ${status}=    convert to string    ${status}
            should contain    ${status}    SUCCESS
            ${biId}    CustomLib.Get Value From Json    ${JsonResp}    $.data.wAsHandleVersionEvent.data.versionId
            ${biId}    convert to string    ${biId}
            ${biId}    remove string    ${biId}    [
            ${biId}    remove string    ${biId}    ]
            ${biId}    remove string    ${biId}    '
            Write Output Excel    DealCreation    DealId    ${RowCounter}    ${biId}
            SeleniumLibrary.input text    ${SearchBox}   ${biId}
            sleep    5s
            wait until element is visible     //*[@title="#${biId}"]
            seleniumlibrary.click element    //*[@title="#${biId}"]
            sleep    7s
            ${UIStatus}=    SeleniumLibrary.get text   //*[@class="deal-status-button"]
            Write Output Excel    DealCreation    UIDealStatus   ${RowCounter}    ${UIStatus}
            ${UICode}=    seleniumlibrary.get text    //*[@class="detail-value"][3]
            Validate the content and update the excel    ${code}${randomnum2digit}    ${UICode}    DealCreation    Code    ${RowCounter}
            ${description}=    seleniumlibrary.get text    xpath=//*[@class="deal-desc"]
            ${dealId}=    seleniumlibrary.get text    (//*[@class="x-expand-card__main-title"])[1]
            Write Output Excel    DealCreation    DealId    ${RowCounter}    ${dealId}
            @{description}=    split string    ${description}    •
            ${ID}=    get from list    ${description}    1
            ${ID}=    remove string    ${ID}    ${SPACE}
            ${date} =    get from list    ${description}    2
            @{date}=    split string    ${date}    ${SPACE}
            ${date1}=    get from list    ${date}    1
            ${Bpid}=    seleniumlibrary.get text    xpath=//*[@class="detail-value"][4]
            Validate the content and update the excel    ${random_4_digit_number}7890    ${ID}    DealCreation    ID    ${RowCounter}
            Write Output Excel    DealCreation    BPID   ${RowCounter}    ${Bpid}
            Write Output Excel    DealCreation    UIDealStatus   ${RowCounter}    ${UIStatus}
            Write Output Excel    DealCreation    Date   ${RowCounter}    ${date1}
            Validate the content and update the excel    ${Bpid}    ${BPID}     DealCreation    UIBPID    ${RowCounter}
            save excel document    ${DealsInputExcelPath}
        END
        save excel document    ${DealsInputExcelPath}
        ${ListIndexIterator}=    evaluate    ${ListIndexIterator} + int(${1})
        ${RowCounter}=    evaluate    ${RowCounter} + int(${1})
    END
    save excel document    ${DealsInputExcelPath}

TAAmountSpent
    [Tags]    id=DC_04
    ${ListIndexIterator}    set variable    0
    ${DataIndexIterator}    set variable    0
    ${ScenarioIDCount}=    get length    ${ScenarioList}
    ${RowCounter}    set variable    2
    FOR    ${ScenarioIterator}    IN RANGE    ${ScenarioIDCount}
        ${ExecutionFlag}=    get from list    ${ExecutionFlagList}    ${ListIndexIterator}
        ${ScenarioName}=    get from list    ${ScenarioList}   ${ListIndexIterator}
        IF    '${ScenarioName}' == 'TAAmountSpent'
            ${Environment}=    get from list    ${EnvironmentList}    ${ListIndexIterator}
            ${json_content}=  Get File  ${execdir}${file}TAAmountSpent.json
            ${BPID}=    get from list    ${BPIDList}    ${ListIndexIterator}
            set suite variable   ${BPID}    ${BPID}
            ${Currency}=    get from list    ${CurrencyList}    ${ListIndexIterator}
            set suite variable   ${Currency}    ${Currency}
            ${json_content}=    Generate the JSON file PP    ${json_content}
            Write Output Excel    DealCreation    Code    ${RowCounter}   ${code}${randomnum2digit}
            Write Output Excel    DealCreation    ID    ${RowCounter}    ${random_4_digit_number}7890
            Switch Case    ${Environment}
            create session    order_session    ${DealURL}    verify=True
            ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${AuthToken}
            ${response}=     post on session    order_session    url=${GraphqlURL}     data=${json_content}     headers=${headers}
            # Getting the content value
            Log    Status Code: ${response.status_code}
            Log    Response Content: ${response.content}
            ${response.status_code}=  convert to string    ${response.status_code}
            Validate the content and update the excel    200    ${response.status_code}    DealCreation    ResponseStatusCode    ${RowCounter}
            set variable    ${response.content}
            set variable    ${response.json()}
            ${response_text}=    convert to string    ${response.content}
            ${response.json()}=    convert to string    ${response.json()}
            ${text}    set variable   ${response_text}
            ${text}=    replace string    ${text}    null    None
            ${text}    Replace String    ${text}    false    False
            ${text}    Replace String    ${text}    true    True
            ${JsonResp}    Evaluate    ${text}    json
            ${status}    CustomLib.Get Value From Json    ${JsonResp}    $.data.wAsHandleVersionEvent.status
            ${status}=    convert to string    ${status}
            should contain    ${status}    SUCCESS
            ${biId}    CustomLib.Get Value From Json    ${JsonResp}    $.data.wAsHandleVersionEvent.data.versionId
            ${biId}    convert to string    ${biId}
            ${biId}    remove string    ${biId}    [
            ${biId}    remove string    ${biId}    ]
            ${biId}    remove string    ${biId}    '
            Write Output Excel    DealCreation    DealId    ${RowCounter}    ${biId}
            SeleniumLibrary.input text    ${SearchBox}   ${biId}
            sleep    5s
            wait until element is visible     //*[@title="#${biId}"]
            seleniumlibrary.click element    //*[@title="#${biId}"]
            sleep    7s
            ${UIStatus}=    SeleniumLibrary.get text   //*[@class="deal-status-button"]
            Write Output Excel    DealCreation    UIDealStatus   ${RowCounter}    ${UIStatus}
            ${UICode}=    seleniumlibrary.get text    //*[@class="detail-value"][3]
            Validate the content and update the excel    ${code}${randomnum2digit}    ${UICode}    DealCreation    Code    ${RowCounter}
            ${description}=    seleniumlibrary.get text    xpath=//*[@class="deal-desc"]
            ${dealId}=    seleniumlibrary.get text    (//*[@class="x-expand-card__main-title"])[1]
            Write Output Excel    DealCreation    DealId    ${RowCounter}    ${dealId}
            @{description}=    split string    ${description}    •
            ${ID}=    get from list    ${description}    1
            ${ID}=    remove string    ${ID}    ${SPACE}
            ${date} =    get from list    ${description}    2
            @{date}=    split string    ${date}    ${SPACE}
            ${date1}=    get from list    ${date}    1
            ${Bpid}=    seleniumlibrary.get text    xpath=//*[@class="detail-value"][4]
            Validate the content and update the excel    ${random_4_digit_number}7890    ${ID}    DealCreation    ID    ${RowCounter}
            Write Output Excel    DealCreation    BPID   ${RowCounter}    ${Bpid}
            Write Output Excel    DealCreation    UIDealStatus   ${RowCounter}    ${UIStatus}
            Write Output Excel    DealCreation    Date   ${RowCounter}    ${date1}
            Validate the content and update the excel    ${Bpid}    ${BPID}     DealCreation    UIBPID    ${RowCounter}
            save excel document    ${DealsInputExcelPath}
        END
        save excel document    ${DealsInputExcelPath}
        ${ListIndexIterator}=    evaluate    ${ListIndexIterator} + int(${1})
        ${RowCounter}=    evaluate    ${RowCounter} + int(${1})
    END
    save excel document    ${DealsInputExcelPath}

TAArticelSpent
    [Tags]    id=DC_05
    ${ListIndexIterator}    set variable    0
    ${DataIndexIterator}    set variable    0
    ${ScenarioIDCount}=    get length    ${ScenarioList}
    ${RowCounter}    set variable    2
    FOR    ${ScenarioIterator}    IN RANGE    ${ScenarioIDCount}
        ${ExecutionFlag}=    get from list    ${ExecutionFlagList}    ${ListIndexIterator}
        ${ScenarioName}=    get from list    ${ScenarioList}   ${ListIndexIterator}
        IF    '${ScenarioName}' == 'TAArticelSpent'
            ${Environment}=    get from list    ${EnvironmentList}    ${ListIndexIterator}
            ${json_content}=  Get File  ${execdir}${file}TAArticelSpent.json
            ${BPID}=    get from list    ${BPIDList}    ${ListIndexIterator}
            set suite variable   ${BPID}    ${BPID}
            ${Currency}=    get from list    ${CurrencyList}    ${ListIndexIterator}
            set suite variable   ${Currency}    ${Currency}
            ${json_content}=    Generate the JSON file PP    ${json_content}
            Write Output Excel    DealCreation    Code    ${RowCounter}   ${code}${randomnum2digit}
            Write Output Excel    DealCreation    ID    ${RowCounter}    ${random_4_digit_number}7890
            Switch Case    ${Environment}
            create session    order_session    ${DealURL}    verify=True
            ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${AuthToken}
            ${response}=     post on session    order_session    url=${GraphqlURL}     data=${json_content}     headers=${headers}
            # Getting the content value
            Log    Status Code: ${response.status_code}
            Log    Response Content: ${response.content}
            ${response.status_code}=  convert to string    ${response.status_code}
            Validate the content and update the excel    200    ${response.status_code}    DealCreation    ResponseStatusCode    ${RowCounter}
            set variable    ${response.content}
            set variable    ${response.json()}
            ${response_text}=    convert to string    ${response.content}
            ${response.json()}=    convert to string    ${response.json()}
            ${text}    set variable   ${response_text}
            ${text}=    replace string    ${text}    null    None
            ${text}    Replace String    ${text}    false    False
            ${text}    Replace String    ${text}    true    True
            ${JsonResp}    Evaluate    ${text}    json
            ${status}    CustomLib.Get Value From Json    ${JsonResp}    $.data.wAsHandleVersionEvent.status
            ${status}=    convert to string    ${status}
            should contain    ${status}    SUCCESS
            ${biId}    CustomLib.Get Value From Json    ${JsonResp}    $.data.wAsHandleVersionEvent.data.versionId
            ${biId}    convert to string    ${biId}
            ${biId}    remove string    ${biId}    [
            ${biId}    remove string    ${biId}    ]
            ${biId}    remove string    ${biId}    '
            Write Output Excel    DealCreation    DealId    ${RowCounter}    ${biId}
            SeleniumLibrary.input text    ${SearchBox}   ${biId}
            sleep    5s
            wait until element is visible     //*[@title="#${biId}"]
            seleniumlibrary.click element    //*[@title="#${biId}"]
            sleep    7s
            ${UIStatus}=    SeleniumLibrary.get text   //*[@class="deal-status-button"]
            Write Output Excel    DealCreation    UIDealStatus   ${RowCounter}    ${UIStatus}
            ${UICode}=    seleniumlibrary.get text    //*[@class="detail-value"][3]
            Validate the content and update the excel    ${code}${randomnum2digit}    ${UICode}    DealCreation    Code    ${RowCounter}
            ${description}=    seleniumlibrary.get text    xpath=//*[@class="deal-desc"]
            ${dealId}=    seleniumlibrary.get text    (//*[@class="x-expand-card__main-title"])[1]
            Write Output Excel    DealCreation    DealId    ${RowCounter}    ${dealId}
            @{description}=    split string    ${description}    •
            ${ID}=    get from list    ${description}    1
            ${ID}=    remove string    ${ID}    ${SPACE}
            ${date} =    get from list    ${description}    2
            @{date}=    split string    ${date}    ${SPACE}
            ${date1}=    get from list    ${date}    1
            ${Bpid}=    seleniumlibrary.get text    xpath=//*[@class="detail-value"][4]
            Validate the content and update the excel    ${random_4_digit_number}7890    ${ID}    DealCreation    ID    ${RowCounter}
            Write Output Excel    DealCreation    BPID   ${RowCounter}    ${Bpid}
            Write Output Excel    DealCreation    UIDealStatus   ${RowCounter}    ${UIStatus}
            Write Output Excel    DealCreation    Date   ${RowCounter}    ${date1}
            Validate the content and update the excel    ${Bpid}    ${BPID}     DealCreation    UIBPID    ${RowCounter}
            save excel document    ${DealsInputExcelPath}
        END
        save excel document    ${DealsInputExcelPath}
        ${ListIndexIterator}=    evaluate    ${ListIndexIterator} + int(${1})
        ${RowCounter}=    evaluate    ${RowCounter} + int(${1})
    END
    save excel document    ${DealsInputExcelPath}







*** Keywords ***

Generate the JSON file PP
    [Arguments]    ${json_content}
    ${random_2_digit_number}=    Evaluate    random.randint(10, 99)
    ${randomnum2digit}=   evaluate    random.randint(10, 99)
    ${randomnum2digit}=     convert to string    ${randomnum2digit}
    set suite variable    ${randomnum2digit}    ${randomnum2digit}
    ${code}=    generate random string   2    [UPPER]
    set suite variable    ${code}    ${code}
    ${random_2_digit_number}=    convert to string    ${random_2_digit_number}
    ${json_content}=    replace string    ${json_content}    <<Code>>    ${code}${randomnum2digit}
    ${random_4_digit_number}=    Evaluate    random.randint(1000, 9999)
    ${random_4_digit_number}=    convert to string    ${random_4_digit_number}
    set suite variable    ${random_4_digit_number}    ${random_4_digit_number}
    ${json_content}=    replace string    ${json_content}    <<ID>>    ${random_4_digit_number}
#    ${json_content}=    replace string    ${json_content}    <<scriptId>>    ${random_4_digit_number}
    ${Formatted_Date}   getdate    %Y-%m-%d
    ${json_content}=    replace string    ${json_content}    <<CurrentDate>>    ${Formatted_Date}
    ${json_content}=    replace string    ${json_content}    <<BPID>>    ${BPID}
    ${json_content}=    replace string    ${json_content}    <<Currency>>    ${Currency}
    RETURN    ${json_content}


Read All Input Values From PPExcel
    [Arguments]    ${InputExcel}
    ${ExcelDictionary}    ReadAllValuesFromPPExcel    ${InputExcel}    DealCreation
    ${EnvironmentList}    get from dictionary    ${ExcelDictionary}    Environment
    ${ExecutionFlagList}    get from dictionary    ${ExcelDictionary}    ExecutionFlag
    ${ScenarioList}    get from dictionary     ${ExcelDictionary}    Scenario
    ${BPIDList}    get from dictionary     ${ExcelDictionary}    BPID
    ${CurrencyList}    get from dictionary     ${ExcelDictionary}    Currency
    set suite variable    ${EnvironmentList}    ${EnvironmentList}
#    ${DealIDList}    get from dictionary     ${ExcelDictionary}    DealID
    set suite variable    ${BPIDList}    ${BPIDList}
#    set suite variable    ${DealIDList}    ${DealIDList}
    set suite variable    ${CurrencyList}    ${CurrencyList}
    set suite variable   ${ScenarioList}   ${ScenarioList}
    set suite variable    ${ExecutionFlagList}    ${ExecutionFlagList}
    open excel document    ${InputExcel}    docID

ReadAllValuesFromPPExcel
    [Documentation]    Read all Values from the input excel and return dictionary values will
       ...             have all column values as a list and set the dictionary value
    [Arguments]    ${inputExcelPath}    ${Sheetname}
    Log  ${inputExcelPath}
    open excel document    ${inputExcelPath}    docID
    ${FirstRow}=    read excel row    1    sheet_name=${Sheetname}
    ${Columncount}=    get length   ${FirstRow}
    ${ExcelDict}    create dictionary
    FOR    ${itrFirstRow}    IN RANGE    0    ${Columncount}
        ${currentColumnIndexForExcel}=    evaluate    ${itrFirstRow} +int(${1})
        #Get all Column Values to a List
        ${excelCurrentColumnValues}=    read excel column     ${currentColumnIndexForExcel}    sheet_name=${Sheetname}
        #Removes the column Name from Column Values List in index 0
        remove from list    ${excelCurrentColumnValues}    0
        #Current    Column Name as current key
        ${currentKey}=    get from List    ${FirstRow}    ${itrFirstRow}
        #set column name as key and the column values as value in the form of List
        set to dictionary    ${ExcelDict}    ${currentKey}    ${excelCurrentColumnValues}
    END
    # set the ExcelDictionary to use it across the test suite
    set suite variable    ${excelValues}    ${ExcelDict}
    close current excel document
    RETURN    ${ExcelDict}


Switch Case
    [Arguments]    ${value}
    Run Keyword If    '${value}' == 'QA2'    set suite variable    ${PPURL}     https://wileyas.qa2.viax.io/price-proposals
    Run Keyword If    '${value}' == 'QA2'    set suite variable    ${GraphqlURL}      https://api.wileyas.qa2.viax.io/graphql
    Run Keyword If    '${value}' == 'STAGE'    set suite variable     ${GraphqlURL}    https://api.wileyas.stage.viax.io/graphql
    Run Keyword If    '${value}' == 'STAGE'    set suite variable     ${PPURL}    https://wileyas.stage.viax.io/price-proposals
    Run Keyword If    '${value}' == 'QA3'    set suite variable    ${PPURL}     https://wileyas.qa3.viax.io/price-proposals
    Run Keyword If    '${value}' == 'QA3'    set suite variable    ${GraphqlURL}      https://api.wileyas.qa3.viax.io/graphql
    run keyword if    '${Value}' == 'QA2'    set suite variable    ${DealURL}     https://wileyas.qa2.viax.io/deals
    ...    ELSE    Log    Default Case


Convert List To Dictionary
    [Arguments]    @{my_list}
    ${dict}=    Create Dictionary
    ${length}=    get length    @{my_list}
    FOR    ${index}    IN RANGE    0    ${length}
       Set To Dictionary    ${dict}    @{my_list}[${index}]    @{my_list}[${index+1}]
    END
    RETURN    ${dict}

Get Key Value
    [Arguments]  ${json_data}  ${key}
    ${parsed_json}=  Evaluate  json.loads('${json_data}')  json
    ${value}=  Get From Dictionary  ${parsed_json}  ${key}
    RETURN  ${value}

Open Excel and DBS
    [Arguments]    ${PPInputExcelPath}    ${PPURL}    ${username}    ${password}
     Read All Input Values From PPExcel    ${PPInputExcelPath}
     ${Environment}=    get from list    ${EnvironmentList}    0
     ${Environment}=    convert to upper case    ${Environment}
     Switch Case    ${Environment}
     Launch and Login DBS    ${PPURL}    ${username}    ${password}
     ${Environment}=    convert to lower case      ${Environment}
     ${token}=    get token    auth.wileyas.${Environment}.viax.io
     ${JsonResp}=  Evaluate  ${token}
     @{list}=     CustomLib.Get Value From Json    ${JsonResp}    $.access_token
     ${AuthToken}=    set variable    ${list}[0]
     set suite variable    ${AuthToken}    ${AuthToken}


Close Excel and Browser
    close all excel documents
    close browser

ReLaunch DBS
    [Arguments]    ${PPURL}    ${username}    ${password}
    go to    ${PPURL}
    sleep    5s
    ${LoginCheck}=    run keyword and return status    element text should be    //*[@id="kc-page-title"]    Sign In
    IF    '${LoginCheck}' == 'True'
        Launch and Login DBS    ${PPURL}    ${username}    ${password}
        sleep    5s
    END


getdate
    [Arguments]   ${date_format}
    ${Formatted_Date}       Get Current Date     result_format=${date_format}
    RETURN       ${Formatted_Date}