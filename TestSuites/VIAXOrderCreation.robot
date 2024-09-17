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
    [Tags]    id=CO_NW_01
    Create Order    Create Alipay Order for New Customer with Article discount GOA Order Type

CreateCC Order with New Customer P1 with Society Discounts with GOA
     [Tags]    id=CO_NW_02
    Create Order    CreateCC Order with New Customer P1 with Society Discounts with GOA

CreateCC Order with New Customer P2 with Promo Discounts with GOA
     [Tags]    id=CO_NW_03
    Create Order    CreateCC Order with New Customer P2 with Promo Discounts with GOA

CreateCC Order with New Customer P3 with Editorial Discounts without VAT ID with GOA
     [Tags]    id=CO_NW_04
    Create Order    CreateCC Order with New Customer P3 with Editorial Discounts without VAT ID with GOA

CreateCC Order with New Customer P3 with Editorial Discounts with VAT ID with GOA
     [Tags]    id=CO_NW_05
    Create Order    CreateCC Order with New Customer P3 with Editorial Discounts with VAT ID with GOA

CreateCC Order with New Customer P4 with Institutional Discounts with GOA
     [Tags]    id=CO_NW_06
    Create Order    CreateCC Order with New Customer P4 with Institutional Discounts with GOA

CreateCC Order with New Customer P4 with Article Type Discounts with GOA
     [Tags]    id=CO_NW_07
    Create Order    CreateCC Order with New Customer P4 with Article Type Discounts with GOA

Create Invoice Order with New Customer P1 with Promo Discounts with GOA
     [Tags]    id=CO_NW_08
    Create Order    Create Invoice Order with New Customer P1 with Promo Discounts with GOA

Create Invoice Order with New Customer P2 with Society Discounts with GOA
     [Tags]    id=CO_NW_09
    Create Order    Create Invoice Order with New Customer P2 with Society Discounts with GOA
Create Invoice Order with New Customer P3 with Editorial Discounts without VAT and with GOA
    [Tags]    id=CO_NW_10
    Create Order    Create Invoice Order with New Customer P3 with Editorial Discounts without VAT and with GOA
Create Invoice Order with New Customer P3 with Editorial Discounts with VAT and with GOA
    [Tags]    id=CO_NW_11
    Create Order    Create Invoice Order with New Customer P3 with Editorial Discounts with VAT and with GOA
Create Invoice Order with New Customer P4 with Institutonal Discounts with GOA
     [Tags]    id=CO_NW_12
    Create Order    Create Invoice Order with New Customer P4 with Institutonal Discounts with GOA
Create Invoice Order with New Customer P4 with Article Discounts with GOA
    [Tags]    id=CO_NW_13
    Create Order    Create Invoice Order with New Customer P4 with Article Discounts with GOA
Create Proforma Order with New Customer P1 with Society Discounts with GOA
    [Tags]    id=CO_NW_14
    Create Order    Create Proforma Order with New Customer P1 with Society Discounts with GOA
Create Proforma Order with New Customer P2 with Promo Discounts with GOA
    [Tags]    id=CO_NW_15
    Create Order    Create Proforma Order with New Customer P2 with Promo Discounts with GOA
Create Proforma Order with New Customer P3 with Editorial Discounts with VAT and with GOA
    [Tags]    id=CO_NW_16
    Create Order    Create Proforma Order with New Customer P3 with Editorial Discounts with VAT and with GOA
Create Proforma Order with New Customer P3 with Editorial Discounts without VAT and with GOA
    [Tags]    id=CO_NW_17
    Create Order    Create Proforma Order with New Customer P3 with Editorial Discounts without VAT and with GOA
Create Proforma Order with New Customer P4 with Institutonal Discounts with GOA
    [Tags]    id=CO_NW_18
    Create Order    Create Proforma Order with New Customer P4 with Institutonal Discounts with GOA
Create Proforma Order with New Customer P4 with Article Discounts with GOA
    [Tags]    id=CO_NW_19
    Create Order    Create Proforma Order with New Customer P4 with Article Discounts with GOA
Create Order with Society Discount (%) P1 with CC HOA Order
    [Tags]    id=CO_NW_20
    Create Order    Create Order with Society Discount (%) P1 with CC HOA Order
Create Order with Promo Discount (%) P2 with CC HOA Order
    [Tags]    id=CO_NW_21
    Create Order    Create Order with Promo Discount (%) P2 with CC HOA Order
Create Order with Society Discount (Value) P3 with CC HOA Order with VAT ID
    [Tags]    id=CO_NW_22
    Create Order    Create Order with Society Discount (Value) P3 with CC HOA Order with VAT ID
Create Order with Promo Discount (Value) P3 with CC HOA Order without VAT ID
    [Tags]    id=CO_NW_23
    Create Order    Create Order with Promo Discount (Value) P3 with CC HOA Order without VAT ID
Create Order with Institutional Discount P4 with CC HOA Order
    [Tags]    id=CO_NW_24
    Create Order    Create Order with Institutional Discount P4 with CC HOA Order
Create Order with Custom Discount P4 with CC HOA Order
    [Tags]    id=CO_NW_25
    Create Order    Create Order with Custom Discount P4 with CC HOA Order
Create Order with Society Discount (Value) P1 with Invoice HOA Order
    [Tags]    id=CO_NW_26
    Create Order    Create Order with Society Discount (Value) P1 with Invoice HOA Order
Create Order with Promo Discount (Value) P2 with Invoice HOA Order
    [Tags]    id=CO_NW_27
    Create Order    Create Order with Promo Discount (Value) P2 with Invoice HOA Order
Create Order with Society Discount (%) P3 with Invoice HOA Order with VAT ID
    [Tags]    id=CO_NW_28
    Create Order    Create Order with Society Discount (%) P3 with Invoice HOA Order with VAT ID
Create Order with Promo Discount (%) P3 with Invoice HOA Order without VAT ID
    [Tags]    id=CO_NW_29
    Create Order    Create Order with Promo Discount (%) P3 with Invoice HOA Order without VAT ID
Create Order with Custom Discount P4 with Invoice HOA Order
    [Tags]    id=CO_NW_30
    Create Order    Create Order with Custom Discount P4 with Invoice HOA Order
Create Order with Institutional Discount P4 with Invoice HOA Order
    [Tags]    id=CO_NW_31
    Create Order    Create Order with Institutional Discount P4 with Invoice HOA Order
Create Order with Society Discount Value P4 with Alipay HOA Order
    [Tags]    id=CO_NW_32
    Create Order    Create Order with Society Discount Value P4 with Alipay HOA Order
    close all excel documents
Validate the Order Status in DBS
    [Tags]    id=CO_NW_33
    sleep    400
    close all excel documents
    Read All Input Values From OrderCreationCases    ${InputFilePath}    Data
    ${ListIndexIterator}    set variable    0
    ${EnironmentValue}=    get from list    ${ExecutionEnvironmentList}     ${ListIndexIterator}
    ${EnironmentValue}=    convert to upper case    ${EnironmentValue}
    Get DBS Orders Link    ${EnironmentValue}
    Launch and Login DBS    ${DBSURL}    ${username}    ${password}
    ${OrderIdCount}=    get length    ${OrderIdList}
    ${RowCounter}    set variable    2
    FOR    ${ScenarioIterator}    IN RANGE    ${OrderIdCount}
#        ${Flag}=    get from list    ${FlagList}    ${ListIndexIterator}
#        IF    '${Flag}' == 'Yes'
            ${OrderId}=    get from list    ${OrderIdList}    ${ListIndexIterator}
            IF  '${OrderId}' != 'None'
                sleep    5s
                SeleniumLibrary.input text    ${SearchBox}   ${OrderId}
                sleep    5s
                ${text}=    SeleniumLibrary.get text    ${statustext}
                FOR    ${waitIterator}    IN RANGE    1    50
                    IF    '${text}' != 'Invoiced' or '${text}' != 'Completed' or '${text}' != 'Proforma Created'
                        reload page
                        sleep    10s
                        ${text}=    SeleniumLibrary.get text    ${statustext}
                        ${text}=    set variable   ${text}
                        IF    '${text}' == 'Invoiced' or '${text}' == 'Completed' or '${text}' == 'Proforma Created'
                            sleep    10s
                            exit for loop
                        END
                    ELSE
                       exit for loop
                    END
                END
                run keyword and continue on failure    should contain any    ${text}    Invoiced    Completed    Proforma Created
                IF    '${text}' == 'Invoiced' or '${text}' == 'Completed' or '${text}' == 'Proforma Created'
                    Write Output Excel    Data    OrderStatus    ${RowCounter}    ${text}
                    sleep    10s
                    seleniumlibrary.click element    //*[contains(@id,"single-spa-application:parcel")]//*[@class="x-order-list-item__title"]
                    sleep    7s
                    ${UITax}=    seleniumlibrary.get text    (//*[contains(@class,"x-col x-col_3 x-pricing-view__col x-")])[4]
                    ${UIDiscount}=    seleniumlibrary.get text    (//*[contains(@class,"x-col x-col_3 x-pricing-view__col x-")])[2]
                    ${UIAPC}=    seleniumlibrary.get text    (//*[contains(@class,"x-col x-col_3 x-pricing-view__col x-")])[1]
                    ${UITotal}=    seleniumlibrary.get text    (//*[contains(@class,"x-col x-col_3 x-pricing-view__col x-")])[5]
                    @{UITaxValue}=    split string    ${UITax}    ${SPACE}
                    ${UITax}=    set variable    ${UITaxValue}[0]
                    ${UICurrency}=    set variable    ${UITaxValue}[1]
                    ${UITax}=    replace string    ${UITax}    ,    ${EMPTY}
                    ${UITax}=    convert to string    ${UITax}
                    @{UIDiscountValue}=    split string    ${UIDiscount}    ${SPACE}
                    ${UIDiscount}=    set variable    ${UIDiscountValue}[0]
                    ${UIDiscount}=    replace string    ${UIDiscount}    ,    ${EMPTY}
                    ${UIDiscount}=    replace string    ${UIDiscount}    (    ${EMPTY}
                    ${UIDiscount}=    replace string    ${UIDiscount}    )    ${EMPTY}
                    ${UIDiscount}=    convert to string    ${UIDiscount}
                    @{UIAPCValue}=    split string    ${UIAPC}    ${SPACE}
                    ${UIAPC}=    set variable    ${UIAPCValue}[0]
                    ${UIAPC}=    replace string    ${UIAPC}    ,    ${EMPTY}
                    ${UIAPC}=    convert to string    ${UIAPC}
                    @{UITotalValue}=    split string    ${UITotal}    ${SPACE}
                    ${UITotal}=    set variable    ${UITotalValue}[0]
                    ${UITotal}=    replace string    ${UITotal}    ,    ${EMPTY}
                    ${UITotal}=    convert to string    ${UITotal}
                    ${TotalAmount}=    get from list    ${TotalAmountList}    ${ListIndexIterator}
                    ${APC}=    get from list    ${APCList}    ${ListIndexIterator}
                    ${Tax}=    get from list    ${TaxList}    ${ListIndexIterator}
                    ${Discount}=    get from list    ${DiscountList}    ${ListIndexIterator}
                    ${DiscountCode}=    get from list    ${DiscountCodeList}    ${ListIndexIterator}
                    ${UIDiscountType}=    seleniumlibrary.get text    ${Var_DiscountType}
                    ${DiscountType}=    get from list    ${DiscountTypeList}    ${ListIndexIterator}
                    ${Currency}=    get from list    ${CurrencyList}    ${ListIndexIterator}
                    run keyword and continue on failure    should be equal    ${Currency}   ${UICurrency}
                    run keyword and continue on failure    should be equal    ${UIDiscountType}   ${DiscountType}
                    Validate the content and update the excel   ${Currency}   ${UICurrency}    Data    Currency    ${RowCounter}
                    Validate the content and update the excel   ${UIDiscountType}   ${DiscountType}    Data    DiscountType  ${RowCounter}
                    IF    '${DiscountCode}' != 'None'
                       ${UIDiscountCode}=    seleniumlibrary.get text    ${Var_DiscountCode}
                       run keyword and continue on failure    should be equal    ${UIDiscountCode}   ${DiscountCode}
                       Validate the content and update the excel   ${UIDiscountCode}   ${DiscountCode}    Data    DiscountCode  ${RowCounter}
                    END
                    run keyword and continue on failure    should be equal    ${Tax}    ${UITax}
                    run keyword and continue on failure    should be equal    ${TotalAmount}    ${UITotal}
                    run keyword and continue on failure    should be equal    ${APC}    ${UIAPC}
                    run keyword and continue on failure    should be equal    ${Discount}    ${UIDiscount}
                    Validate the content and update the excel    ${Tax}    ${UITax}    Data    Tax    ${RowCounter}
                    Validate the content and update the excel    ${TotalAmount}    ${UITotal}    Data    TotalAmount    ${RowCounter}
                    Validate the content and update the excel    ${APC}    ${UIAPC}    Data    APC    ${RowCounter}
                    Validate the content and update the excel    ${Discount}    ${UIDiscount}    Data    Discount    ${RowCounter}
                    ${wileyorderId}=    seleniumlibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//*[@class="x-order-basics-view__value"])[1]
                    sleep    3s
                    ${saporderId}=    seleniumlibrary.get text   (//*[contains(@id,"single-spa-application:parcel")]//*[@class="x-order-basics-view__value"])[8]
                    Write Output Excel    Data    WileyOrderId    ${RowCounter}    ${wileyorderId}
                    Write Output Excel    Data    SAPOrderID    ${RowCounter}    ${saporderId}
                    save excel document    ${InputFilePath}
                    go back
                END
            END
#        END
        ${ListIndexIterator}=    evaluate    ${ListIndexIterator} + int(${1})
        ${RowCounter}=    evaluate    ${RowCounter} + int(${1})
        save excel document    ${InputFilePath}
    END
    save excel document    ${InputFilePath}
    close all excel documents
SAPValidations
    [Tags]    id=CO_NW_34
    close all excel documents
    Read All Input Values From OrderCreationCases    ${InputFilePath}    Data
    ${ListIndexIterator}    set variable    0
    ${EnironmentValue}=    get from list    ${ExecutionEnvironmentList}     ${ListIndexIterator}
    ${EnironmentValue}=    convert to upper case    ${EnironmentValue}
    Get DBS Orders Link    ${EnironmentValue}
#    Launch and Login DBS    ${DBSURL}    ${username}    ${password}
    ${OrderIdCount}=    get length    ${OrderIdList}
    ${RowCounter}    set variable    2
    open sap logon window    ${SAPGUIPATH}    ${SAPUSERNAME}    ${SAPPASSWORD}    ${ENTERBUTTON}    ${CONNECTION}    ${continuebutton}
    FOR    ${ScenarioIterator}    IN RANGE    ${OrderIdCount}
        ${OrderId}=    get from list    ${OrderIdList}    ${ListIndexIterator}
        ${OrderStatus}=    get from list    ${OrderStatusList}    ${ListIndexIterator}
        IF    '${OrderStatus}' == 'Invoiced' or '${OrderStatus}' == 'Completed' or '${OrderStatus}' == 'Proforma Created'
            ${saporderId}=    get from list    ${SapOrderIdList}    ${ListIndexIterator}
            ${SubmissionID}=    get from list    ${SubmissionIDList}    ${ListIndexIterator}
            run transaction    /nVA03
            sapguilibrary.input text    ${Var_OrderIDTextbox}      ${saporderId}
            sapguilibrary.click element    /app/con[0]/ses[0]/wnd[0]/tbar[0]/btn[0]
            sapguilibrary.click element    ${Var_ItemOverview}
            select table row   ${Var_ItemOverviewTableId}       0
            sapguilibrary.click element    ${Var_OpenItem}
            SapGuiLibrary.click element    ${Var_Conditions}
            ${TotalAmount}=    get from list    ${TotalAmountList}    ${ListIndexIterator}
            ${NetPrice}=    SapGuiLibrary.Get Value    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_ITEM/tabpT\\06/ssubSUBSCREEN_BODY:SAPLV69A:6201/txtKOMP-NETWR
            ${TaxValue}=   SapGuiLibrary.Get Value    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_ITEM/tabpT\\06/ssubSUBSCREEN_BODY:SAPLV69A:6201/txtKOMP-MWSBP
            @{NetPrice}=    split string    ${NetPrice}    ${SPACE}
            ${NetPrice}=    set variable    ${NetPrice}[0]
            ${NetPrice}=    replace string    ${NetPrice}    ,    ${EMPTY}
            @{TaxValue}=    split string    ${TaxValue}    ${SPACE}
            ${TaxValue}=    set variable    ${TaxValue}[0]
            ${TaxValue}=    replace string    ${TaxValue}    ,    ${EMPTY}
            ${NetPrice}=    evaluate  ${NetPrice} + ${TaxValue}
            ${NetPrice}=    Evaluate    "{:.2f}".format(${NetPrice})
            ${NetPrice}=    convert to string    ${NetPrice}
            run keyword and continue on failure    should be equal    ${NetPrice}    ${TotalAmount}
            Validate the content and update the excel    ${NetPrice}    ${TotalAmount}    Data    SAPPrice    ${RowCounter}
            sapguilibrary.click element    ${Var_OrderData}
            ${ReferenceID}=    SapGuiLibrary.Get Value    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_ITEM/tabpT\\11/ssubSUBSCREEN_BODY:SAPMV45A:4454/txtVBKD-IHREZ
            ${DBSOrderID}=    SapGuiLibrary.Get Value    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_ITEM/tabpT\\11/ssubSUBSCREEN_BODY:SAPMV45A:4454/txtVBKD-IHREZ_E
            run keyword and continue on failure    should be equal    ${DBSOrderID}    ${OrderId}
            Validate the content and update the excel    ${DBSOrderID}    ${OrderId}    Data    OrderId    ${RowCounter}
            sapguilibrary.click element    ${Var_DataB}
            ${ArticleNumber}=    SapGuiLibrary.Get Value    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_ITEM/tabpT\\15/ssubSUBSCREEN_BODY:SAPMV45A:4462/subKUNDEN-SUBSCREEN_8459:SAPMV45A:8459/txtVBAP-ZZARTNO
            run keyword and continue on failure    should be equal    ${ArticleNumber}    ${SubmissionID}
            Validate the content and update the excel    ${ArticleNumber}    ${SubmissionID}    Data    SubmissionID    ${RowCounter}
            sapguilibrary.click element    /app/con[0]/ses[0]/wnd[0]/tbar[0]/btn[3]
            sapguilibrary.click element    /app/con[0]/ses[0]/wnd[0]/tbar[1]/btn[5]
            SapGuiLibrary.selectInvoiceTree     ${Var_InvoiceElement}
            sapguilibrary.click element    /app/con[0]/ses[0]/wnd[0]/tbar[1]/btn[8]
            ${InvoiceNumber}=    SapGuiLibrary.get value    /app/con[0]/ses[0]/wnd[0]/usr/ctxtVBRK-VBELN
            write output excel    Data    InvoiceNumber    ${RowCounter}    ${InvoiceNumber}
            sapguilibrary.click element    /app/con[0]/ses[0]/wnd[0]/usr/btnTC_OUTPUT
            sapguilibrary.select table row    /app/con[0]/ses[0]/wnd[0]/usr/tblSAPDV70ATC_NAST3    0
            sapguilibrary.click element    /app/con[0]/ses[0]/wnd[0]/tbar[1]/btn[5]
            sapguilibrary.click element    /app/con[0]/ses[0]/wnd[0]/tbar[0]/btn[3]
        END
        ${ListIndexIterator}=    evaluate    ${ListIndexIterator} + int(${1})
        ${RowCounter}=    evaluate    ${RowCounter} + int(${1})
        save excel document    ${InputFilePath}
    END
    save excel document    ${InputFilePath}
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
    Run Keyword If    '${value}' == '4'    Log    Case 4
    ...    ELSE    Log    Default Case



Get DBS Orders Link
    [Arguments]    ${value}
    Run Keyword If    '${value}' == 'QA2'    set suite variable    ${DBSURL}     https://wileyas.qa2.viax.io/orders
    Run Keyword If    '${value}' == 'QA2'    set suite variable    ${GraphqlURL}      https://api.wileyas.qa2.viax.io/graphql
    Run Keyword If    '${value}' == 'STAGE'    set suite variable     ${GraphqlURL}    https://api.wileyas.stage.viax.io/graphql
    Run Keyword If    '${value}' == 'STAGE'    set suite variable     ${DBSURL}    https://wileyas.stage.viax.io/price-proposals
    ...    ELSE    Log    Default Case



