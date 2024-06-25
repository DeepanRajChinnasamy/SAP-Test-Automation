*** Settings ***
Resource    ../Resource/ObjectRepositories/CustomVariables.robot
Library    CustomLib.py

*** Variables ***
${file}    \\UploadExcel\\JsonTemplates\\
${SubId}    24ef<<RandomNum>>-783b-4808-9127-af8e42410<<RandonDynId>>
${QA2_Viax}     https://wileyas.qa2.viax.io/price-proposals
${QA2_Graphql}    https://api.wileyas.qa2.viax.io/graphql
${PPInputExcelPath}    ${execdir}\\UploadExcel\\TD_Inputs.xlsx
*** Test Cases ***
PriceProposal
    [Tags]    id=NC_OP_08
    Read All Input Values From PPExcel    ${PPInputExcelPath}
    log to console    ${PPInputExcelPath}
    ${ListIndexIterator}    set variable    0
    ${DataIndexIterator}    set variable    0
    ${JournalIDCount}=    get length    ${JournalIDList}
    ${RowCounter}    set variable    2
#    open sap logon window    ${SAPGUIPATH}    ${SAPUSERNAME}    ${SAPPASSWORD}    ${ENTERBUTTON}    ${CONNECTION}    ${continuebutton}
#    Launch and Login DBS    ${QA2_Viax}    ${username}    ${password}
    FOR    ${ScenarioIterator}    IN RANGE    ${JournalIDCount}
        ${ExecutionFlag}=    get from list    ${ExecutionFlagList}    ${ListIndexIterator}
        IF    '${ExecutionFlag}' == 'Y'
            ${JSONFileName}=    get from list    ${JSONFileNameList}    ${ListIndexIterator}
            ${JournalID}=    get from list    ${JournalIDList}    ${ListIndexIterator}
            ${Environment}=    get from list    ${EnvironmentList}    ${ListIndexIterator}
            ${json_content}=  Get File  ${execdir}${file}${JSONFileName}.json
            ${json_content}=    Generate the JSON file PP    ${json_content}    ${JournalID}
            Write Output Excel    PriceProposal    JSONText    ${RowCounter}    ${json_content}
            Switch Case    ${Environment}
            create session    order_session    ${PPURL}    verify=True
            ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${Token1}
            ${response}=     post on session    order_session    url=${GraphqlURL}     data=${json_content}     headers=${headers}
            # Getting the content value
            Log    Status Code: ${response.status_code}
            Log    Response Content: ${response.content}
            ${response.status_code}=  convert to string    ${response.status_code}
            Validate the content and update the excel    200    ${response.status_code}    PriceProposal    ResponseStatusCode    ${RowCounter}
            set variable    ${response.content}
            set variable    ${response.json()}
            ${response_text}=    convert to string    ${response.content}
            ${response.json()}=    convert to string    ${response.json()}
            Write Output Excel    PriceProposal    Response    ${RowCounter}    ${response.json()}
            ${JsonResp}=  Evaluate  ${response.text}
            # Fetch the values from the result Json File
            @{list}=     CustomLib.Get Value From Json    ${JsonResp}    $.data.testFunction.data
#            @{list}=    Get Key Value    ${JsonResp}    $.data.testFunction.data
            #log to console    @{list}
            ${NumberofList}=    get length    ${list}
            set variable    ${JsonResp}
            ${check}=    run keyword and return status    should contain    ${list}[0]    SUCCESS
#            ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
#            ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
            IF    '${check}' == '${True}'
                ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
                ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
                ${error_code}=  Set Variable  ${json_dict['message']}
                ${OrderID}=  Set Variable  ${json_dict['priceProposal']['biId']}
                ${error_code}=    convert to string    ${error_code}
                ${OrderStatus}=    convert to string    ${OrderID}
                Write Output Excel    PriceProposal    OrderStatus    ${RowCounter}    ${error_code}
                Write Output Excel    PriceProposal    OrderID    ${RowCounter}    ${OrderID}
                ${errormessage}=    set variable    ${json_dict['priceProposal']['bpStatus']['code']}
                ${errormessage}=    convert to string    ${errormessage}
                IF    '${errormessage}' == 'PriceDetermined' or '${errormessage}' == 'ManualOverrideRequired'
                    write and color excel    PriceProposal    PriceProposalStatus    ${RowCounter}    ${errormessage}    00FF00
                    save excel document    ${PPInputExcelPath}
                ELSE
                    write and color excel    PriceProposal    PriceProposalStatus    ${RowCounter}    ${errormessage}    FF0000
                    save excel document    ${PPInputExcelPath}
                END
            ELSE
#                ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
#                ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
#                ${error_code}=  Set Variable  ${json_dict['errors']}
#                ${error_code}=    convert to string    ${error_code}
                write and color excel    PriceProposal    OrderStatus    ${RowCounter}    Error in Response    FF0000
                save excel document    ${PPInputExcelPath}
            END
        END
        save excel document    ${PPInputExcelPath}
        ${ListIndexIterator}=    evaluate    ${ListIndexIterator} + int(${1})
        ${RowCounter}=    evaluate    ${RowCounter} + int(${1})
    END
    save excel document    ${PPInputExcelPath}
    close all excel documents

*** Keywords ***
Generate the JSON file PP
    [Arguments]    ${json_content}    ${JournalID}
    ${random_3_digit_number}=    Evaluate    random.randint(100, 999)
    ${random_3_digit_number}=    convert to string    ${random_3_digit_number}
    ${Id}=    replace string    ${SubId}    <<RandonDynId>>    ${random_3_digit_number}
    ${json_content}=    replace string    ${json_content}    <<Id>>    ${Id}
    ${json_content}=    replace string    ${json_content}    <<JournalID>>    ${JournalID}
    ${random_4_digit_number}=    Evaluate    random.randint(1000, 9999)
    ${random_4_digit_number}=    convert to string    ${random_4_digit_number}
    ${json_content}=    replace string    ${json_content}    <<RandomNum>>    ${random_4_digit_number}
#    ${random_8_digit_number}=    Evaluate    random.randint(10000000, 99999999)
#    ${random_8_digit_number}=    convert to string    ${random_8_digit_number}
#    ${submission}=    convert to string    ${submission}
#    ${SubmissionId}=    replace string    ${submission}    <<RandonSub>>    ${random_8_digit_number}
#    ${today}=     get current date
#    ${UniqueOrderId}=    Convert Date    ${today}    result_format=%Y%m%d%H%M%S
##    ${FirstName}=  set variable     ${UniqueOrderId}Test
##    ${LastName}=  set variable     ${UniqueOrderId}Auto
##    ${MailId}=  set variable     ${UniqueOrderId}Mail@Wiley.com
##    ${today}=    Get Current Date
#    ${FromDate}=    Convert Date    ${today}    result_format=%Y-%m-%d
#    ${TAX}=    get from list    ${TAXList}    ${ListIndexIterator}
#    ${Amount}=    get from list    ${AmountList}    ${ListIndexIterator}
#    ${DiscountCode}=    get from list    ${DiscountCodeList}    ${ListIndexIterator}
#    ${DiscountType}=    get from list    ${DiscountTypeList}    ${ListIndexIterator}
#    ${Amount}=    get from list    ${AmountList}    ${ListIndexIterator}
#    ${CountryCode}=    get from list    ${CountryCodeList}    ${ListIndexIterator}
#    ${Currency}=    get from list    ${CurrencyList}    ${ListIndexIterator}
#    ${AppliedDiscount}=    get from list    ${AppliedDiscountList}    ${ListIndexIterator}
#    ${APC}=    get from list    ${APCList}    ${ListIndexIterator}
#    ${CreditCardType}=    get from list    ${CreditCardTypeList}    ${ListIndexIterator}
#    ${CreditCardTypeID}=    get from list    ${CreditCardTypeIDList}    ${ListIndexIterator}
#    ${VatNumber}=    get from list    ${VatNumberList}    ${ListIndexIterator}
#    ${TAX}=    convert to string    ${TAX}
#    ${Amount}=    convert to string    ${Amount}
#    ${DiscountCode}=    convert to string    ${DiscountCode}
#    ${Currency}=    convert to string    ${Currency}
#    ${DiscountType}=    convert to string    ${DiscountType}
#    ${Amount}=    convert to string    ${Amount}
#    ${CountryCode}=    convert to string    ${CountryCode}
#    ${AppliedDiscount}=    convert to string    ${AppliedDiscount}
#    ${APC}=    convert to string    ${APC}
#    ${CreditCardType}=    convert to string    ${CreditCardType}
#    ${CreditCardTypeID}=    convert to string    ${CreditCardTypeID}
#    ${VatNumber}=    convert to string   ${VatNumber}
#    ${json_content}=    replace string    ${json_content}    <<APC>>    ${APC}
#    ${json_content}=    replace string    ${json_content}    <<TAX>>    ${TAX}
#    ${json_content}=    replace string    ${json_content}    <<TOTALAMT>>    ${Amount}
#    ${json_content}=    replace string    ${json_content}    <<CURRENCY>>    ${Currency}
#    ${json_content}=    replace string    ${json_content}    <<APPLIEDDISCOUNT>>    ${AppliedDiscount}
#    ${json_content}=    replace string    ${json_content}    <<DISCOUNTTYPE>>    ${DiscountType}
#    ${json_content}=    replace string    ${json_content}    <<DISCOUNTCODE>>    ${DiscountCode}
#    ${json_content}=    replace string    ${json_content}    <<COUNTRYCODE>>     ${CountryCode}
#    ${json_content}=    replace string    ${json_content}    <<VATCODE>>     ${VatNumber}
#    ${json_content}=    replace string    ${json_content}    <<CREDITCARDID>>     ${CreditCardTypeID}
#    ${json_content}=    replace string    ${json_content}    <<CREDITCARDTYPE>>     ${CreditCardType}
#    ${UniqueOrderId}=    convert to string    ${UniqueOrderId}
#    ${SubmissionId}=    convert to string    ${SubmissionId}
#    ${FisrtName}=    convert to string    ${FirstName}
#    ${LastName}=    convert to string    ${LastName}
#    ${MailId}=    convert to string    ${MailId}
#    ${Id}=     convert to string   ${Id}
#    ${Dhid}=    convert to string    ${Dhid}
#    ${FromDate}=    convert to string    ${FromDate}
#    # Replace the Values in JSON File
#    ${json_content}=    replace string    ${json_content}    <<OrderId>>    ${UniqueOrderId}
#    ${json_content}=    replace string    ${json_content}    <<Sub>>    ${SubmissionId}
#    ${json_content}=    replace string    ${json_content}    <<FIRSTNAME>>    ${FisrtName}
#    ${json_content}=    replace string    ${json_content}    <<LASTNAME>>    ${LastName}
#    ${json_content}=    replace string    ${json_content}    <<MailId>>    ${MailId}
#    ${json_content}=    replace string    ${json_content}    <<ID>>    ${Id}
#    ${json_content}=    replace string    ${json_content}    <<DHID>>    ${Dhid}
#    ${json_content}=    replace string    ${json_content}    <<DATE>>    ${FromDate}
#    Write Output Excel    HappyFlowInputs    NewOrder    ${excelrownumber}    ${UniqueOrderId}
#    Write Output Excel    HappyFlowInputs    SubmissionId    ${excelrownumber}    ${SubmissionId}
##    IF    '${CustomerTypeFlag}' == 'True'
#    Write Output Excel    HappyFlowInputs    FirstName    ${excelrownumber}    ${FisrtName}
#    Write Output Excel    HappyFlowInputs    LastName    ${excelrownumber}    ${LastName}
#    Write Output Excel    HappyFlowInputs    MailId    ${excelrownumber}    ${MailId}
##    ELSE
##        ${mailid}=    get from dictionary    ${ExistingMailIdDict}    ${strtowrite}
##        Write Output Excel    Inputs    FirstName    ${excelrownumber}    Refer ExistingUsers Sheet
##        Write Output Excel    Inputs    LastName    ${excelrownumber}    Refer ExistingUsers Sheet
##        Write Output Excel    Inputs    MailId    ${excelrownumber}    ${mailid}
##    END
#    Write Output Excel    HappyFlowInputs    DynamicID    ${excelrownumber}    ${Id}
#    Write Output Excel    HappyFlowInputs    RandomDhid    ${excelrownumber}    ${Dhid}
#    excellibrary.save excel document    ${InputExcelPath}
    [Return]    ${json_content}


Read All Input Values From PPExcel
    [Arguments]    ${InputExcel}
    ${ExcelDictionary}    ReadAllValuesFromPPExcel    ${InputExcel}    PriceProposal
    ${EnvironmentList}    get from dictionary    ${ExcelDictionary}    VIAXEnvironment
    ${ExecutionFlagList}    get from dictionary    ${ExcelDictionary}    ExecutionFlag
    ${JSONFileNameList}    get from dictionary    ${ExcelDictionary}  JSONFileName
    ${JournalIDList}    get from dictionary    ${ExcelDictionary}    JournalID
    ${ScenarioList}    get from dictionary    ${ExcelDictionary}    ScenarioList
#    ${InvoicedStatusList}    get from dictionary    ${ExcelDictionary}    FecthInvoiceStatus
    set suite variable    ${EnvironmentList}    ${EnvironmentList}
    set suite variable   ${JournalIDList}   ${JournalIDList}
    set suite variable    ${ExecutionFlagList}    ${ExecutionFlagList}
    set suite variable    ${JSONFileNameList}    ${JSONFileNameList}
    set suite variable    ${ScenarioList}    ${ScenarioList}
#    set suite variable    ${OrderIDList}    ${OrderIDList}
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
    [Return]    ${ExcelDict}

#Read All Input Values From DataExcel
#    [Arguments]    ${InputExcel}    ${InputSheet}
#    ${ExcelDictionary}    ReadAllValuesFromExcel    ${InputExcel}    ${InputSheet}
#    ${FlagList}    get from dictionary    ${ExcelDictionary}    ExecutionFlag
#    ${OrderTypeList}    get from dictionary    ${ExcelDictionary}    OrderType
##    ${NumofOrderList}    get from dictionary    ${ExcelDictionary}    NumberOrderToCreate
#    ${JsonPathList}     get from dictionary    ${ExcelDictionary}    JsonPath
#    ${APCList}    get from dictionary    ${ExcelDictionary}    APC
#    ${AppliedDiscountList}    get from dictionary    ${ExcelDictionary}    AppliedDiscount
#    ${CurrencyList}    get from dictionary    ${ExcelDictionary}    Currency
#    ${TAXList}    get from dictionary    ${ExcelDictionary}     Tax
#    ${CountryCodeList}    get from dictionary    ${ExcelDictionary}    CountryCode
#    ${DiscountTypeList}    get from dictionary    ${ExcelDictionary}    DiscountType
#    ${DiscountCodeList}    get from dictionary    ${ExcelDictionary}    DiscountCode
#    ${AmountList}    get from dictionary    ${ExcelDictionary}    Amount
#    ${CreditCardTypeList}    get from dictionary    ${ExcelDictionary}    CreditCardType
#    ${CreditCardTypeIDList}    get from dictionary    ${ExcelDictionary}    CreditCardTypeID
#    ${VatNumberList}    get from dictionary    ${ExcelDictionary}    VatNumber
#    ${NewOrderCancellationFlagList}    get from dictionary    ${ExcelDictionary}    NewOrderCancellationFlag
#    ${ExistingOrderCancellationFlagList}    get from dictionary    ${ExcelDictionary}    ExistingOrderCancellationFlag
#    set suite variable   ${FlagList}   ${FlagList}
#    set suite variable    ${NewOrderCancellationFlagList}    ${NewOrderCancellationFlagList}
#    set suite variable    ${ExistingOrderCancellationFlagList}    ${ExistingOrderCancellationFlagList}
#    set suite variable    ${OrderTypeList}    ${OrderTypeList}
##    set suite variable    ${NumofOrderList}    ${NumofOrderList}
#    set suite variable    ${JsonPathList}    ${JsonPathList}
#    set suite variable    ${APCList}    ${APCList}
#    set suite variable    ${AppliedDiscountList}    ${AppliedDiscountList}
#    set suite variable    ${CurrencyList}    ${CurrencyList}
#    set suite variable    ${TAXList}    ${TAXList}
#    set suite variable    ${CountryCodeList}    ${CountryCodeList}
#    set suite variable    ${DiscountTypeList}    ${DiscountTypeList}
#    set suite variable    ${DiscountCodeList}    ${DiscountCodeList}
#    set suite variable    ${AmountList}    ${AmountList}
#    set suite variable    ${CreditCardTypeList}    ${CreditCardTypeList}
#    set suite variable    ${CreditCardTypeIDList}    ${CreditCardTypeIDList}
#    set suite variable    ${VatNumberList}    ${VatNumberList}
#    open excel document    ${inputExcelPath}    docID

Switch Case
    [Arguments]    ${value}
    Run Keyword If    '${value}' == 'QA2'    set suite variable    ${PPURL}     https://wileyas.qa2.viax.io/price-proposals
    Run Keyword If    '${value}' == 'QA2'    set suite variable    ${GraphqlURL}      https://api.wileyas.qa2.viax.io/graphql
    Run Keyword If    '${value}' == 'QA'    set suite variable     ${GraphqlURL}    https://api.wileyas.qa.viax.io/graphql
    Run Keyword If    '${value}' == 'QA'    set suite variable     ${PPURL}    https://wileyas.qa.viax.io/price-proposals
    Run Keyword If    '${value}' == '4'    Log    Case 4
    ...    ELSE    Log    Default Case


Convert List To Dictionary
    [Arguments]    @{my_list}
    ${dict}=    Create Dictionary
    ${length}=    get length    @{my_list}
    FOR    ${index}    IN RANGE    0    ${length}
       Set To Dictionary    ${dict}    @{my_list}[${index}]    @{my_list}[${index+1}]
    END
    [Return]    ${dict}

Get Key Value
    [Arguments]  ${json_data}  ${key}
    ${parsed_json}=  Evaluate  json.loads('${json_data}')  json
    ${value}=  Get From Dictionary  ${parsed_json}  ${key}
    [Return]  ${value}
