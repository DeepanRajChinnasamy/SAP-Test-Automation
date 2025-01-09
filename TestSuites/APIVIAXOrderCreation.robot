*** Settings ***
Resource    ../Resource/ObjectRepositories/CustomVariables.robot
Library     ../Resource/ObjectRepositories/CustomLib.py
Library     ../Resource/ObjectRepositories/Response.py
Suite Setup    Read All Input Values From OrderCreationCases    ${InputFilePath}    Data

*** Variables ***
${InputFilePath}    ${execdir}\\UploadExcel\\TD_RegOrderCreation.xlsx
${file}    \\UploadExcel\\OrderCreationAPI\\
${URL}
${GraphqlURL}
${Var_OrderType}    (//*[contains(@id,"single-spa-application:parcel")]//*[@class="x-order-basics-view__value"])[2]
${Var_DiscountType}    (//*[contains(@id,"single-spa-application:parcel")]//*[@class="x-order-basics-view__value"])[3]
${Var_DiscountCode}    (//*[contains(@id,"single-spa-application:parcel")]//*[@class="x-order-basics-view__value"])[4]
${Var_Price}    (//*[contains(@class,"x-col x-col_3 x-pricing-view__col x-")])[1]
${Var_Discount}    (//*[contains(@class,"x-col x-col_3 x-pricing-view__col x-")])[2]
${Var_Subtotal}    (//*[contains(@class,"x-col x-col_3 x-pricing-view__col x-")])[3]
${Var_Tax}    (//*[contains(@class,"x-col x-col_3 x-pricing-view__col x-")])[4]
${Var_Total}    (//*[contains(@class,"x-col x-col_3 x-pricing-view__col x-")])[5]

*** Test Cases ***

Create Alipay Order for New Customer with Article discount GOA Order Type
    [Tags]    id=AP_OC_01
    Create Order    Create Alipay Order for New Customer with Article discount GOA Order Type

CreateCC Order with New Customer P1 with Society Discounts with GOA
     [Tags]    id=AP_OC_02
    Create Order    CreateCC Order with New Customer P1 with Society Discounts with GOA

CreateCC Order with New Customer P2 with Promo Discounts with GOA
     [Tags]    id=AP_OC_03
    Create Order    CreateCC Order with New Customer P2 with Promo Discounts with GOA

CreateCC Order with New Customer P3 with Editorial Discounts without VAT ID with GOA
     [Tags]    id=AP_OC_04
    Create Order    CreateCC Order with New Customer P3 with Editorial Discounts without VAT ID with GOA

CreateCC Order with New Customer P3 with Editorial Discounts with VAT ID with GOA
     [Tags]    id=AP_OC_05
    Create Order    CreateCC Order with New Customer P3 with Editorial Discounts with VAT ID with GOA

CreateCC Order with New Customer P4 with Institutional Discounts with GOA
     [Tags]    id=AP_OC_06
    Create Order    CreateCC Order with New Customer P4 with Institutional Discounts with GOA

CreateCC Order with New Customer P4 with Article Type Discounts with GOA
     [Tags]    id=AP_OC_07
    Create Order    CreateCC Order with New Customer P4 with Article Type Discounts with GOA

Create Invoice Order with New Customer P1 with Promo Discounts with GOA
     [Tags]    id=AP_OC_08
    Create Order    Create Invoice Order with New Customer P1 with Promo Discounts with GOA

Create Invoice Order with New Customer P2 with Society Discounts with GOA
     [Tags]    id=AP_OC_09
    Create Order    Create Invoice Order with New Customer P2 with Society Discounts with GOA
Create Invoice Order with New Customer P3 with Editorial Discounts without VAT and with GOA
    [Tags]    id=AP_OC_10
    Create Order    Create Invoice Order with New Customer P3 with Editorial Discounts without VAT and with GOA
Create Invoice Order with New Customer P3 with Editorial Discounts with VAT and with GOA
    [Tags]    id=AP_OC_11
    Create Order    Create Invoice Order with New Customer P3 with Editorial Discounts with VAT and with GOA
Create Invoice Order with New Customer P4 with Institutonal Discounts with GOA
     [Tags]    id=AP_OC_12
    Create Order    Create Invoice Order with New Customer P4 with Institutonal Discounts with GOA
Create Invoice Order with New Customer P4 with Article Discounts with GOA
    [Tags]    id=AP_OC_13
    Create Order    Create Invoice Order with New Customer P4 with Article Discounts with GOA
Create Proforma Order with New Customer P1 with Society Discounts with GOA
    [Tags]    id=AP_OC_14
    Create Order    Create Proforma Order with New Customer P1 with Society Discounts with GOA
Create Proforma Order with New Customer P2 with Promo Discounts with GOA
    [Tags]    id=AP_OC_15
    Create Order    Create Proforma Order with New Customer P2 with Promo Discounts with GOA
Create Proforma Order with New Customer P3 with Editorial Discounts with VAT and with GOA
    [Tags]    id=AP_OC_16
    Create Order    Create Proforma Order with New Customer P3 with Editorial Discounts with VAT and with GOA
Create Proforma Order with New Customer P3 with Editorial Discounts without VAT and with GOA
    [Tags]    id=AP_OC_17
    Create Order    Create Proforma Order with New Customer P3 with Editorial Discounts without VAT and with GOA
Create Proforma Order with New Customer P4 with Institutonal Discounts with GOA
    [Tags]    id=AP_OC_18
    Create Order    Create Proforma Order with New Customer P4 with Institutonal Discounts with GOA
Create Proforma Order with New Customer P4 with Article Discounts with GOA
    [Tags]    id=AP_OC_19
    Create Order    Create Proforma Order with New Customer P4 with Article Discounts with GOA
Create Order with Society Discount (%) P1 with CC HOA Order
    [Tags]    id=AP_OC_20
    Create Order    Create Order with Society Discount (%) P1 with CC HOA Order
Create Order with Promo Discount (%) P2 with CC HOA Order
    [Tags]    id=AP_OC_21
    Create Order    Create Order with Promo Discount (%) P2 with CC HOA Order
Create Order with Society Discount (Value) P3 with CC HOA Order with VAT ID
    [Tags]    id=AP_OC_22
    Create Order    Create Order with Society Discount (Value) P3 with CC HOA Order with VAT ID
Create Order with Promo Discount (Value) P3 with CC HOA Order without VAT ID
    [Tags]    id=AP_OC_23
    Create Order    Create Order with Promo Discount (Value) P3 with CC HOA Order without VAT ID
Create Order with Institutional Discount P4 with CC HOA Order
    [Tags]    id=AP_OC_24
    Create Order    Create Order with Institutional Discount P4 with CC HOA Order
Create Order with Custom Discount P4 with CC HOA Order
    [Tags]    id=AP_OC_25
    Create Order    Create Order with Custom Discount P4 with CC HOA Order
Create Order with Society Discount (Value) P1 with Invoice HOA Order
    [Tags]    id=AP_OC_26
    Create Order    Create Order with Society Discount (Value) P1 with Invoice HOA Order
Create Order with Promo Discount (Value) P2 with Invoice HOA Order
    [Tags]    id=AP_OC_27
    Create Order    Create Order with Promo Discount (Value) P2 with Invoice HOA Order
Create Order with Society Discount (%) P3 with Invoice HOA Order with VAT ID
    [Tags]    id=AP_OC_28
    Create Order    Create Order with Society Discount (%) P3 with Invoice HOA Order with VAT ID
Create Order with Promo Discount (%) P3 with Invoice HOA Order without VAT ID
    [Tags]    id=AP_OC_29
    Create Order    Create Order with Promo Discount (%) P3 with Invoice HOA Order without VAT ID
Create Order with Custom Discount P4 with Invoice HOA Order
    [Tags]    id=AP_OC_30
    Create Order    Create Order with Custom Discount P4 with Invoice HOA Order
Create Order with Institutional Discount P4 with Invoice HOA Order
    [Tags]    id=AP_OC_31
    Create Order    Create Order with Institutional Discount P4 with Invoice HOA Order
Create Order with Society Discount Value P4 with Alipay HOA Order
    [Tags]    id=AP_OC_32
    Create Order    Create Order with Society Discount Value P4 with Alipay HOA Order
    close all excel documents



*** Keywords ***
Create Order
    [Arguments]    ${TestCaseName}
    [Documentation]      This case will create a VIAX Invoice Order Via API and Validate in DBS
    ${ListIndexIterator}    set variable    0
    ${RowCounter}    set variable    2
    ${TestCaseIDCount}=   get length    ${TesctCaseNameList}
    FOR    ${ScenarioIterator}    IN RANGE    ${TestCaseIDCount}
        ${ScenarioName}=    get from list    ${TesctCaseNameList}   ${ListIndexIterator}
#        ${Flag}=    get from list    ${FlagList}    ${ListIndexIterator}
        IF    '${TestCaseName}' == '${ScenarioName}'
            ${EnironmentValue}=    get from list    ${ExecutionEnvironmentList}     ${ListIndexIterator}
            Get DBS Orders Link    ${EnironmentValue}
            ${JSONFileName}=    get from list    ${JSONFileNameList}    ${ListIndexIterator}
            ${TotalAmount}=    get from list    ${TotalAmountList}    ${ListIndexIterator}
            ${Currency}=    get from list    ${CurrencyList}    ${ListIndexIterator}
            ${countrycode}=    get from list    ${CountryList}    ${ListIndexIterator}
            ${JournalID}=    get from list   ${JournalIDList}    ${ListIndexIterator}
            ${today}=     get current date
            Write Output Excel    Data    ExecutionDate    ${RowCounter}    ${today}
            ${UniqueOrderId}=    Convert Date    ${today}    result_format=%Y%m%d%H%M%S
            ${FirstName}=  set variable     ${UniqueOrderId}Test
            ${LastName}=  set variable     ${UniqueOrderId}Auto
            ${MailId}=  set variable     ${UniqueOrderId}@Wiley.com
#            ${FirstName}=  set variable     20240919155523Test
#            ${LastName}=  set variable     20240919155523Auto
#            ${MailId}=  set variable     20240919155523@Wiley.com
            Write Output Excel    Data    FirstName    ${RowCounter}    ${FirstName}
            Write Output Excel    Data    LastName    ${RowCounter}    ${LastName}
            Write Output Excel    Data    MailId    ${RowCounter}    ${MailId}
            ${json_content}=  Get File  ${execdir}${file}${JSONFileName}.json
            ${json_content}=    Create JSON File    ${json_content}   ${FirstName}    ${LastName}    ${MailId}
            ${TotalAmount}=    get from list    ${TotalAmountList}    ${ListIndexIterator}
            ${Currency}=    get from list    ${CurrencyList}    ${ListIndexIterator}
            ${countrycode}=    get from list    ${CountryList}    ${ListIndexIterator}
            ${JournalID}=    get from list   ${JournalIDList}    ${ListIndexIterator}
            ${APC}=    get from list    ${APCList}    ${ListIndexIterator}
            ${DiscountType}=    get from list    ${DiscountTypeList}    ${ListIndexIterator}
            ${Discount}=    get from list    ${DiscountList}    ${ListIndexIterator}
            ${Tax}=    get from list    ${TaxList}    ${ListIndexIterator}
            ${VATID}=    get from list    ${VATIDList}    ${ListIndexIterator}
            ${DiscountCode}=    get from list    ${DiscountCodeList}    ${ListIndexIterator}
            ${DiscountCode}=    get from list    ${DiscountCodeList}    ${ListIndexIterator}
            ${PostalCode}=    get from list    ${PostalCodeList}    ${ListIndexIterator}
            ${AddressRegion}=    get from list    ${AddressRegionList}    ${ListIndexIterator}
            ${AddressRegion}=    convert to string    ${AddressRegion}
            ${PostalCode}=    convert to string    ${PostalCode}
            IF    '${DiscountCode}'=='None'
                ${DiscountCode}=    set variable    ${EMPTY}
            END
            IF    '${VATID}'=='None'
                ${VATID}=    set variable    ${EMPTY}
            END
            IF    '${DiscountType}'=='None'
                ${DiscountType}=    set variable    ${EMPTY}
            END
            ${OrderType}=     get from list    ${OrderTypeList}    ${ListIndexIterator}
            ${json_content}=    replace string    ${json_content}    <<AddressRegion>>    ${AddressRegion}
            ${json_content}=    replace string    ${json_content}    <<DiscountCode>>    ${DiscountCode}
            ${json_content}=    replace string    ${json_content}    <<OrderType>>    ${OrderType}
            ${json_content}=    replace string    ${json_content}    <<PostalCode>>    ${PostalCode}
            ${json_content}=    replace string    ${json_content}    <<APC>>    ${APC}
            ${json_content}=    replace string    ${json_content}    <<Tax>>    ${Tax}
            ${json_content}=    replace string    ${json_content}    <<AppliedDiscount>>    ${Discount}
            ${json_content}=    replace string    ${json_content}    <<DiscountType>>    ${DiscountType}
            ${json_content}=    replace string    ${json_content}    <<Currency>>    ${Currency}
            ${json_content}=    replace string    ${json_content}    <<TotalAmount>>    ${TotalAmount}
            ${json_content}=    replace string     ${json_content}    <<journalId>>    ${JournalID}
            ${json_content}=    replace string     ${json_content}    <<countrycode>>    ${countrycode}
            ${json_content}=    replace string     ${json_content}    <<VATID>>    ${VATID}
            Write Output Excel    Data    JSONText    ${RowCounter}    ${json_content}
            Write Output Excel    Data    SubmissionID    ${RowCounter}    ${SubmissionId}
            create session    order_session    ${URL}    verify=True
            ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${AuthToken}
            ${response}=     post on session    order_session    url=${GraphqlURL}    data=${json_content}     headers=${headers}
            ${response_text}=    convert to string    ${response.content}
            ${response.json()}=    convert to string    ${response.json()}
            Validate the content and update the excel    200    ${response.status_code}    Data    ResponseStatusCode    ${RowCounter}
            ${JsonResp}=  Evaluate  ${response.text}
#            log to console   ${JsonResp}
            # Fetch the values from the result Json File
            @{list}=    CustomLib.Get Value From Json    ${JsonResp}    $.data.testFunction.data
#            log to console    @{list}
            set variable    ${JsonResp}
            ${JsonResp}=    convert to string    ${JsonResp}
            Write Output Excel    Data    Response    ${RowCounter}    ${JsonResp}
            ${check}=    run keyword and return status    should contain    ${list}[0]    SUCCESS
            run keyword    should contain    ${list}[0]    SUCCESS
            ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
            save excel document    ${InputFilePath}
            IF    '${check}' == '${True}'
                ${error_code}=  Set Variable  ${json_dict['result']['biId']}
                ${OrderStatus}=  Set Variable  ${json_dict['result']['message']}
                ${error_code}=    convert to string    ${error_code}
                ${OrderStatus}=    convert to string    ${OrderStatus}
                Write Output Excel    Data    OrderId    ${RowCounter}    ${error_code}
                Write Output Excel    Data    OrderStatus    ${RowCounter}    ${OrderStatus}
                ${OrderID}=    set variable    ${error_code}
                set variable    ${error_code}
                set variable    ${OrderStatus}
                save excel document    ${InputFilePath}
            ELSE
                ${errortext}=  Set Variable  ${json_dict['message']}
                ${errortext}=    convert to string    ${errortext}
                Write Output Excel    Data    OrderStatus    ${RowCounter}    Error-${errortext}
                set variable   ${errortext}
            END
        END
        ${ListIndexIterator}=    evaluate    ${ListIndexIterator} + int(${1})
        ${RowCounter}=    evaluate    ${RowCounter} + int(${1})
        save excel document    ${InputFilePath}
    END
    save excel document    ${InputFilePath}
#    close all excel documents

Create JSON File
    [Arguments]    ${json_content}   ${FirstName}    ${LastName}    ${MailId}
    ${random_3_digit_number}=    Evaluate    random.randint(100, 999)
    ${random_3_digit_number}=    convert to string    ${random_3_digit_number}
    ${Id}=    replace string    ${DynamicId}    <<RandonDynId>>    ${random_3_digit_number}
    ${random_4_digit_number}=    Evaluate    random.randint(1000, 9999)
    ${random_4_digit_number}=    convert to string    ${random_4_digit_number}
    ${Dhid}=    replace string    ${DhId}    <<RandomDhid>>    ${random_4_digit_number}
    ${random_8_digit_number}=    Evaluate    random.randint(10000000, 99999999)
    ${random_8_digit_number}=    convert to string    ${random_8_digit_number}
    ${submission}=    convert to string    ${submission}
    ${SubmissionId}=    replace string    ${submission}    <<RandonSub>>    ${random_8_digit_number}
    ${today}=     get current date
    ${UniqueOrderId}=    Convert Date    ${today}    result_format=%Y%m%d%H%M%S
    ${FromDate}=    Convert Date    ${today}    result_format=%Y-%m-%d
    ${UniqueOrderId}=    convert to string    ${UniqueOrderId}
    ${SubmissionId}=    convert to string    ${SubmissionId}
#    set suite variable    ${SubmissionId}    ${SubmissionId}
    ${FisrtName}=    convert to string    ${FirstName}
    ${LastName}=    convert to string    ${LastName}
    ${MailId}=    convert to string    ${MailId}
    ${Id}=     convert to string   ${Id}
    ${Dhid}=    convert to string    ${Dhid}
    ${FromDate}=    convert to string    ${FromDate}
    # Replace the Values in JSON File
    ${json_content}=    replace string    ${json_content}    <<OrderId>>    ${UniqueOrderId}
    ${json_content}=    replace string    ${json_content}    <<Sub>>    ${SubmissionId}
    set suite variable    ${SubmissionId}    ${SubmissionId}
    ${json_content}=    replace string    ${json_content}    <<FIRSTNAME>>    ${FisrtName}
    ${json_content}=    replace string    ${json_content}    <<LASTNAME>>    ${LastName}
    ${json_content}=    replace string    ${json_content}    <<MailId>>    ${MailId}
    ${json_content}=    replace string    ${json_content}    <<ID>>    ${Id}
    ${json_content}=    replace string    ${json_content}    <<DHID>>    ${Dhid}
    ${json_content}=    replace string    ${json_content}    <<DATE>>    ${FromDate}
    RETURN    ${json_content}



Read All Input Values From OrderCreationCases
    [Arguments]    ${InputExcel}    ${InputSheet}
    ${ExcelDictionary}    ReadAllValuesFromExcel    ${InputExcel}    ${InputSheet}
    ${TesctCaseNameList}    get from dictionary    ${ExcelDictionary}    TesctCaseName
    ${SapOrderIdList}    get from dictionary    ${ExcelDictionary}    SAPOrderID
    ${OrderStatusList}    get from dictionary    ${ExcelDictionary}    OrderStatus
    set suite variable    ${OrderStatusList}     ${OrderStatusList}
    ${ExecutionEnvironmentList}    get from dictionary    ${ExcelDictionary}    ExecutionEnvironment
    ${CountryList}   get from dictionary    ${ExcelDictionary}    Country
    ${JSONFileNameList}    get from dictionary     ${ExcelDictionary}    JSONFileName
    ${FirstNameList}    get from dictionary     ${ExcelDictionary}    FirstName
    ${LastNameList}    get from dictionary     ${ExcelDictionary}    LastName
    ${MailList}    get from dictionary     ${ExcelDictionary}    MailId
    ${JournalIDList}    get from dictionary    ${ExcelDictionary}    JournalID
    ${CountryList}    get from dictionary    ${ExcelDictionary}    Country
    ${CurrencyList}    get from dictionary    ${ExcelDictionary}    Currency
    ${TaxList}    get from dictionary    ${ExcelDictionary}    Tax
    ${TotalAmountList}    get from dictionary    ${ExcelDictionary}    TotalAmount
    ${DiscountList}    get from dictionary    ${ExcelDictionary}    Discount
    ${DiscountTypeList}    get from dictionary    ${ExcelDictionary}    DiscountType
    ${DiscountCodeList}    get from dictionary    ${ExcelDictionary}    DiscountCode
    ${APCList}    get from dictionary    ${ExcelDictionary}    APC
    ${VATIDList}    get from dictionary    ${ExcelDictionary}    VATID
#    ${FlagList}    get from dictionary    ${ExcelDictionary}    Flag
    ${PostalCodeList}    get from dictionary    ${ExcelDictionary}    PostalCode
    ${OrderIdList}    get from dictionary    ${ExcelDictionary}    OrderId
    ${OrderTypeList}    get from dictionary    ${ExcelDictionary}    OrderType
    ${AddressRegionList}    get from dictionary    ${ExcelDictionary}    AddressRegion
    ${SubmissionIDList}    get from dictionary    ${ExcelDictionary}    SubmissionID
    set suite variable    ${SubmissionIDList}    ${SubmissionIDList}
    set suite variable    ${OrderIdList}    ${OrderIdList}
    set suite variable    ${OrderTypeList}    ${OrderTypeList}
    set suite variable    ${AddressRegionList}    ${AddressRegionList}
    set suite variable    ${DiscountCodeList}    ${DiscountCodeList}
#    set suite variable    ${FlagList}     ${FlagList}
    set suite variable    ${VATIDList}    ${VATIDList}
    set suite variable    ${APCList}     ${APCList}
    set suite variable    ${DiscountTypeList}  ${DiscountTypeList}
    set suite variable    ${DiscountList}  ${DiscountList}
    set suite variable    ${TesctCaseNameList}   ${TesctCaseNameList}
    set suite variable    ${JournalIDList}    ${JournalIDList}
    set suite variable    ${CountryList}    ${CountryList}
    set suite variable    ${CurrencyList}    ${CurrencyList}
    set suite variable    ${TaxList}    ${TaxList}
    set suite variable    ${TotalAmountList}     ${TotalAmountList}
    set suite variable    ${ExecutionEnvironmentList}    ${ExecutionEnvironmentList}
    set suite variable    ${CountryList}    ${CountryList}
    set suite variable    ${JSONFileNameList}    ${JSONFileNameList}
    set suite variable    ${FirstNameList}    ${FirstNameList}
    set suite variable    ${LastNameList}    ${LastNameList}
    set suite variable    ${MailList}    ${MailList}
    set suite variable    ${PostalCodeList}    ${PostalCodeList}
    set suite variable    ${SapOrderIdList}    ${SapOrderIdList}
    ${Environment}=    get from list    ${ExecutionEnvironmentList}    0
    ${Environment}=    convert to upper case    ${Environment}
    Get DBS Orders Link    ${Environment}
#    Launch and Login DBS    ${PPURL}    ${username}    ${password}
    ${Environment}=    convert to lower case      ${Environment}
    ${token}=    get token    auth.wileyas.${Environment}.viax.io
    ${JsonResp}=  Evaluate  ${token}
    @{list}=     CustomLib.Get Value From Json    ${JsonResp}    $.access_token
    ${AuthToken}=    set variable    ${list}[0]
    set suite variable    ${AuthToken}    ${AuthToken}
    open excel document    ${InputExcel}    docID


Switch Case
    [Arguments]    ${value}
    Run Keyword If    '${value}' == 'QA2'    set suite variable    ${PPURL}     https://wileyas.qa2.viax.io/price-proposals
    Run Keyword If    '${value}' == 'QA2'    set suite variable    ${GraphqlURL}      https://api.wileyas.qa2.viax.io/graphql
    Run Keyword If    '${value}' == 'STAGE'    set suite variable     ${GraphqlURL}    https://api.wileyas.stage.viax.io/graphql
    Run Keyword If    '${value}' == 'STAGE'    set suite variable     ${PPURL}    https://wileyas.stage.viax.io/price-proposals
    Run Keyword If    '${value}' == 'QA3'    set suite variable    ${PPURL}     https://wileyas.qa3.viax.io/orders
    Run Keyword If    '${value}' == 'QA3'    set suite variable    ${GraphqlURL}      https://api.wileyas.qa3.viax.io/graphql
    Run Keyword If    '${value}' == '4'    Log    Case 4
    ...    ELSE    Log    Default Case



Get DBS Orders Link
    [Arguments]    ${value}
    Run Keyword If    '${value}' == 'QA2'    set suite variable    ${DBSURL}     https://wileyas.qa2.viax.io/orders
    Run Keyword If    '${value}' == 'QA2'    set suite variable    ${GraphqlURL}      https://api.wileyas.qa2.viax.io/graphql
    Run Keyword If    '${value}' == 'STAGE'    set suite variable     ${GraphqlURL}    https://api.wileyas.stage.viax.io/graphql
    Run Keyword If    '${value}' == 'QA3'    set suite variable    ${PPURL}     https://wileyas.qa3.viax.io/orders
    Run Keyword If    '${value}' == 'QA3'    set suite variable    ${GraphqlURL}      https://api.wileyas.qa3.viax.io/graphql
    Run Keyword If    '${value}' == 'STAGE'    set suite variable     ${DBSURL}    https://wileyas.stage.viax.io/orders
    ...    ELSE    Log    Default Case



