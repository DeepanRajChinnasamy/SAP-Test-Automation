*** Settings ***
Resource    ../Resource/ObjectRepositories/CustomVariables.robot
Library    ../TestSuites/CustomLib.py
Library    ../TestSuites/Response.py
Suite Setup     Open Excel and DBS    ${PPInputExcelPath}    ${PPURL}    ${username}    ${password}
#Suite Teardown   Close Excel and Browser
#Test Setup    ReLaunch DBS    ${PPURL}    ${username}    ${password}


*** Variables ***
${file}    \\UploadExcel\\JsonTemplates\\
${SubId}    24ef<<RandomNum>>-<<Randomt3digit>>b-4808-9127-af8e42410<<RandonDynId>>
${PPURL}     #https://wileyas.qa2.viax.io/price-proposals
${QA2_Graphql}    https://api.wileyas.stage.viax.io/graphql
${PPInputExcelPath}    ${execdir}\\UploadExcel\\TD_Inputs.xlsx


*** Test Cases ***

Create PP with Society discount
    [Tags]    id=NC_OP_01
    log to console    ${PPInputExcelPath}
    ${ListIndexIterator}    set variable    0
    ${DataIndexIterator}    set variable    0
    ${JournalIDCount}=    get length    ${JournalIDList}
    ${RowCounter}    set variable    2
#    open sap logon window    ${SAPGUIPATH}    ${SAPUSERNAME}    ${SAPPASSWORD}    ${ENTERBUTTON}    ${CONNECTION}    ${continuebutton}
#    Launch and Login DBS    ${QA2_Viax}    ${username}    ${password}
    FOR    ${ScenarioIterator}    IN RANGE    ${JournalIDCount}
        ${ExecutionFlag}=    get from list    ${ExecutionFlagList}    ${ListIndexIterator}
        ${ScenarioName}=    get from list    ${ScenarioList}   ${ListIndexIterator}
        IF    '${ScenarioName}' == 'Create PP with Society discount'
            ${JSONFileName}=    get from list    ${JSONFileNameList}    ${ListIndexIterator}
            ${JsonResp}=     get from list    ${jsonreslist}    ${ListIndexIterator}
            ${JournalID}=    get from list    ${JournalIDList}    ${ListIndexIterator}
            ${Environment}=    get from list    ${EnvironmentList}    ${ListIndexIterator}
            ${discountType1}=  get from list   ${DiscountType1List}   ${ListIndexIterator}
            ${discountType2}=  get from list   ${DiscountType2List}   ${ListIndexIterator}
            ${discountcondition1}=  get from list    ${DiscountCondition1List}   ${ListIndexIterator}
            ${discountcondition2}=  get from list    ${DiscountCondition2List}    ${ListIndexIterator}
            ${discountpercentage1}=     get from list   ${DiscountPercentage1List}   ${ListIndexIterator}
            ${discountpercentage2}=     get from list       ${DiscountPercentage2List}  ${ListIndexIterator}
            ${appliedyes1}=    get from list   ${AppliedYes1List}   ${ListIndexIterator}
            ${appliedyes2}=  get from list  ${AppliedYes2List}      ${ListIndexIterator}
            ${json_content}=  Get File  ${execdir}${file}${JSONFileName}.json
#            ${json_content}=    Generate the JSON file PP    ${json_content}    ${JournalID}
#            Write Output Excel    PriceProposal    JSONText    ${RowCounter}    ${json_content}
#            Switch Case    ${Environment}
#            create session    order_session    ${PPURL}    verify=True
#            ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${AuthToken}
#            ${response}=     post on session    order_session    url=${GraphqlURL}     data=${json_content}     headers=${headers}
#            # Getting the content value
#            Log    Status Code: ${response.status_code}
#            Log    Response Content: ${response.content}
#            ${response.status_code}=  convert to string    ${response.status_code}
#            Validate the content and update the excel    200    ${response.status_code}    PriceProposal    ResponseStatusCode    ${RowCounter}
#            set variable    ${response.content}
#            set variable    ${response.json()}
#            ${response_text}=    convert to string    ${response.content}
#            ${response.json()}=    convert to string    ${response.json()}
#            Write Output Excel    PriceProposal    Response    ${RowCounter}    ${response.json()}
#            ${JsonResp}=  Evaluate  ${response.text}
            # Fetch the values from the result Json File
            @{list}=     CustomLib.Get Value From Json    ${JsonResp}    $.data.testFunction.data
#            @{list}=    Get Key Value    ${JsonResp}    $.data.testFunction.data
            log to console    ${JsonResp}
            ${NumberofList}=    get length    ${list}
            set variable    ${JsonResp}
            ${check}=    run keyword and return status    should contain    ${list}[0]    SUCCESS
            ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
            ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
#            log to console    ${json_dict}
            IF    '${check}' == '${True}'

                ${error_code}=  Set Variable  ${json_dict['message']}
                ${OrderID}=  Set Variable  ${json_dict['priceProposal']['biId']}
                ${error_code}=    convert to string    ${error_code}
                ${OrderStatus}=    convert to string    ${OrderID}
                Write Output Excel    PriceProposal    OrderStatus    ${RowCounter}    ${error_code}
                Write Output Excel    PriceProposal    OrderID    ${RowCounter}    ${OrderID}
                ${errormessage}=    set variable    ${json_dict['priceProposal']['bpStatus']['code']}
                ${submsID}=    set variable    ${json_dict['priceProposal']['wAsPriceProposalPayload']['societyCodes']}
                ${countrycode}=    set variable    ${json_dict['priceProposal']['wAsPriceProposalPayload']['authors'][0]['affiliations'][0]['countryCode']}
#                ${errormessage}=    convert to string    ${errormessage}
                ${dis}=    set variable    ${json_dict['wAsDiscountCodes']['discountCode]}
                log to console    ${dis}
#                should contain any   ${errormessage}    PriceDetermined    ManualOverrideRequired

#                SeleniumLibrary.input text    ${SearchBox}   ${OrderId}
#                sleep    5s
#                seleniumlibrary.click element    //*[@title="#${OrderID}"]
#                sleep    5s
#                ${UIStatus}=    SeleniumLibrary.get text    //*[@class="x-order-details__status-wrapper"]
#                ${Typeofpayment}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//span)[1]
#                run keyword and continue on failure    should be equal    ${UIStatus}    PRICE DETERMINED
#                run keyword and continue on failure    should be equal    ${Typeofpayment}    AuthorPaid
#                ${elementid}=    Get WebElement    //*[@class="x-icon x-accordion__icon"]
#                ${CheckArrowbutton}=  run keyword and return status    element should be present    ${elementid}
#                IF    '${CheckArrowbutton}' == 'True'
#                    seleniumlibrary.click element    //*[@class="x-icon x-accordion__icon"]
#                END
#                ${Discounttype1}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[1]/td[1])[1]
#
#                run keyword and continue on failure    should be equal    ${Discounttype1}    ${discountType1}
#                ${Discounttype2}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[2]/td[1])[1]
#                run keyword and continue on failure    should be equal    ${Discounttype2}    ${discountType2}
#                ${DisountCondition1}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[1]/td[2])[1]
#                run keyword and continue on failure    should be equal    ${DisountCondition1}    ${discountcondition1}
#                ${DisountCondition2}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[2]/td[2])[1]
#                run keyword and continue on failure    should be equal    ${DisountCondition2}    ${discountcondition2}
#                ${Percentagevalue1}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[1]/td[3])[1]
#                run keyword and continue on failure    should be equal    ${Percentagevalue1}    ${discountpercentage1}%
#                ${Percentagevalue2}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[2]/td[3])[1]
#                run keyword and continue on failure    should be equal    ${Percentagevalue2}    ${discountpercentage2}%
#                ${AppliedYes1}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[1]/td[6])[1]
#                run keyword and continue on failure    should be equal    ${AppliedYes1}    ${appliedyes1}
#                ${AppliedYes2}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[2]/td[6])[1]
#                run keyword and continue on failure    should be equal    ${AppliedYes2}    ${appliedyes2}
#                ${TaxValue}=    SeleniumLibrary.get text    //*[contains(@id,"single-spa-application:parcel")]/div/div/div/div[6]/div[2]
#                ${TaxValue}=    replace string    ${TaxValue}    ${SPACE}    ${EMPTY}
#                run keyword and continue on failure    should be equal    ${TaxValue}    0.00USD

#                IF    '${errormessage}' == 'PriceDetermined' or '${errormessage}' == 'ManualOverrideRequired'
#                    write and color excel    PriceProposal    PriceProposalStatus    ${RowCounter}    ${errormessage}    00FF00
#                    save excel document    ${PPInputExcelPath}
#                ELSE
#                    write and color excel    PriceProposal    PriceProposalStatus    ${RowCounter}    ${errormessage}    FF0000
#                    save excel document    ${PPInputExcelPath}
#                END
            ELSE
                ${error_code}=  Set Variable  ${json_dict['errors']}
                ${error_code}=    convert to string    ${error_code}
                write and color excel    PriceProposal    OrderStatus    ${RowCounter}    Error in Response    FF0000
                save excel document    ${PPInputExcelPath}
                should contain    ${list}[0]    SUCCESS
            END
            exit for loop
        END
        save excel document    ${PPInputExcelPath}
        ${ListIndexIterator}=    evaluate    ${ListIndexIterator} + int(${1})
        ${RowCounter}=    evaluate    ${RowCounter} + int(${1})
    END
    save excel document    ${PPInputExcelPath}


*** Keywords ***

Generate the JSON file PP
    [Arguments]    ${json_content}    ${JournalID}
    ${random_3_digit_number}=    Evaluate    random.randint(100, 999)
    ${randomnum3digit}=   evaluate    random.randint(100, 999)
    ${randomnum3digit}=     convert to string    ${randomnum3digit}
    ${random_3_digit_number}=    convert to string    ${random_3_digit_number}
    ${Id}=    replace string    ${SubId}    <<RandonDynId>>    ${random_3_digit_number}
    ${Id}=    replace string    ${Id}    <<Randomt3digit>>    ${randomnum3digit}
    ${json_content}=    replace string    ${json_content}    <<Id>>    ${Id}
    ${json_content}=    replace string    ${json_content}    <<JournalID>>    ${JournalID}
    ${random_4_digit_number}=    Evaluate    random.randint(1000, 9999)
    ${random_4_digit_number}=    convert to string    ${random_4_digit_number}
    ${json_content}=    replace string    ${json_content}    <<RandomNum>>    ${random_4_digit_number}
    ${json_content}=    replace string    ${json_content}    <<scriptId>>    ${random_4_digit_number}
    ${Formatted_Date}   getdate    %Y-%m-%d
    ${json_content}=    replace string    ${json_content}    <<CurrentDate>>    ${Formatted_Date}
    RETURN    ${json_content}


Read All Input Values From PPExcel
    [Arguments]    ${InputExcel}
    ${ExcelDictionary}    ReadAllValuesFromPPExcel    ${InputExcel}    PriceProposal
    ${EnvironmentList}    get from dictionary    ${ExcelDictionary}    VIAXEnvironment
    ${ExecutionFlagList}    get from dictionary    ${ExcelDictionary}    ExecutionFlag
    ${JSONFileNameList}    get from dictionary    ${ExcelDictionary}  JSONFileName
    ${JournalIDList}    get from dictionary    ${ExcelDictionary}    JournalID
    ${ScenarioList}    get from dictionary    ${ExcelDictionary}    ScenarioList
    ${DiscountType1List}    get from dictionary    ${ExcelDictionary}   DiscountType1
    ${DiscountType2List}    get from dictionary    ${ExcelDictionary}   DiscountType2
    ${DiscountType3List}    get from dictionary    ${ExcelDictionary}   DiscountType3
    ${DiscountType4List}    get from dictionary    ${ExcelDictionary}   DiscountType4
    ${DiscountType5List}    get from dictionary    ${ExcelDictionary}   DiscountType5
    ${DiscountType6List}    get from dictionary    ${ExcelDictionary}   DiscountType6
    ${DiscountCondition1List}   get from dictionary     ${ExcelDictionary}    DiscountCondition1
    ${DiscountCondition2List}   get from dictionary     ${ExcelDictionary}  DiscouontCondition2
    ${DiscountCondition3List}   get from dictionary     ${ExcelDictionary}  DiscountCondition3
    ${DiscountCondition4List}   get from dictionary     ${ExcelDictionary}  DiscountCondition4
    ${DiscountCondition5List}   get from dictionary     ${ExcelDictionary}  DiscountCondition5
    ${DiscountCondition6List}   get from dictionary     ${ExcelDictionary}  DiscountCondition6
    ${DiscountPercentage1List}  get from dictionary  ${ExcelDictionary}     DiscountPercentage1
    ${DiscountPercentage2List}  get from dictionary     ${ExcelDictionary}      DiscountPercentage2
    ${DiscountPercentage3List}  get from dictionary     ${ExcelDictionary}      DiscountPercentage3
    ${DiscountPercentage4List}  get from dictionary  ${ExcelDictionary}     DiscountPercentage4
    ${DiscountPercentage5List}  get from dictionary  ${ExcelDictionary}     DiscountPercentage5
    ${DiscountPercentage6List}  get from dictionary  ${ExcelDictionary}     DiscountPercentage6
    ${AppliedYes1List}      get from dictionary      ${ExcelDictionary}     AppliedYes1
    ${AppliedYes2List}      get from dictionary     ${ExcelDictionary}      AppliedYes2
    ${AppliedYes3List}      get from dictionary      ${ExcelDictionary}     AppliedYes3
    ${AppliedYes4List}      get from dictionary      ${ExcelDictionary}     AppliedYes4
    ${AppliedYes5List}      get from dictionary      ${ExcelDictionary}     AppliedYes5
    ${AppliedYes6List}      get from dictionary      ${ExcelDictionary}     AppliedYes6
    ${jsonreslist}    get from dictionary    ${ExcelDictionary}    Response
#    ${InvoicedStatusList}    get from dictionary    ${ExcelDictionary}    FecthInvoiceStatus
    set suite variable    ${EnvironmentList}    ${EnvironmentList}
    set suite variable   ${JournalIDList}   ${JournalIDList}
    set suite variable    ${ExecutionFlagList}    ${ExecutionFlagList}
    set suite variable    ${JSONFileNameList}    ${JSONFileNameList}
    set suite variable    ${ScenarioList}    ${ScenarioList}
    set suite variable    ${DiscountType1List}   ${DiscountType1List}
    set suite variable    ${DiscountType2List}   ${DiscountType2List}
    set suite variable    ${DiscountType3List}   ${DiscountType3List}
    set suite variable    ${DiscountType4List}   ${DiscountType4List}
    set suite variable    ${DiscountType5List}   ${DiscountType5List}
    set suite variable    ${DiscountType6List}   ${DiscountType6List}
    set suite variable    ${jsonreslist}    ${jsonreslist}

    set suite variable    ${DiscountCondition1List}   ${DiscountCondition1List}
    set suite variable    ${DiscountCondition2List}   ${DiscountCondition2List}
    set suite variable    ${DiscountCondition3List}   ${DiscountCondition3List}
    set suite variable    ${DiscountCondition4List}   ${DiscountCondition4List}
    set suite variable    ${DiscountCondition5List}   ${DiscountCondition5List}
    set suite variable    ${DiscountCondition6List}   ${DiscountCondition6List}

    set suite variable    ${DiscountPercentage1List}   ${DiscountPercentage1List}
    set suite variable    ${DiscountPercentage2List}  ${DiscountPercentage2List}
    set suite variable    ${DiscountPercentage3List}  ${DiscountPercentage3List}
    set suite variable    ${DiscountPercentage4List}  ${DiscountPercentage4List}
    set suite variable    ${DiscountPercentage5List}  ${DiscountPercentage5List}
    set suite variable    ${DiscountPercentage6List}  ${DiscountPercentage6List}

    set suite variable    ${AppliedYes1List}    ${AppliedYes1List}
    set suite variable    ${AppliedYes2List}       ${AppliedYes2List}
    set suite variable    ${AppliedYes3List}       ${AppliedYes3List}
    set suite variable    ${AppliedYes4List}       ${AppliedYes4List}
    set suite variable    ${AppliedYes5List}       ${AppliedYes5List}
    set suite variable    ${AppliedYes6List}       ${AppliedYes6List}


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
    Run Keyword If    '${value}' == '4'    Log    Case 4
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
#     Launch and Login DBS    ${PPURL}    ${username}    ${password}
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
    [Return]       ${Formatted_Date}