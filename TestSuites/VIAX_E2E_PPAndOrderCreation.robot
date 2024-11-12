*** Settings ***
Resource    ../Resource/ObjectRepositories/CustomVariables.robot
Library     ../Resource/ObjectRepositories/CustomLib.py
Library     ../Resource/ObjectRepositories/Response.py
Suite Setup     Open Excel and DBS    ${PPInputExcelPath}    ${PPURL}    ${username}    ${password}
Suite Teardown   Close Excel and Browser
Test Setup    ReLaunch DBS    ${PPURL}    ${username}    ${password}

*** Variables ***
${file}    \\UploadExcel\\E2E_JsonTemplates\\
${SubId}    24ef<<RandomNum>>-<<Randomt3digit>>b-4808-9127-af8e42410<<RandonDynId>>
${PPURL}
${QA2_Graphql}    https://api.wileyas.stage.viax.io/graphql
${PPInputExcelPath}    ${execdir}\\UploadExcel\\TD_E2E.xlsx


*** Test Cases ***

E2E_01 Create a PP without any discounts and create an invoice order with P1 Sales Area
    [Tags]    id=EE_OP_01
    ${ListIndexIterator}    set variable    0
    ${DataIndexIterator}    set variable    0
    ${JournalIDCount}=    get length    ${JournalIDList}
    ${RowCounter}    set variable    2
    FOR    ${ScenarioIterator}    IN RANGE    ${JournalIDCount}
        ${ScenarioName}=    get from list    ${ScenarioList}   ${ListIndexIterator}
#        ${EnironmentValue}=    get from list    ${ExecutionEnvironmentList}     ${ListIndexIterator}
#        ${EnironmentValue}=    convert to upper case    ${EnironmentValue}
#        Get DBS Orders Link    ${EnironmentValue}
        IF    '${ScenarioName}' == 'Create a PP without any discounts and create an invoice order with P1 sales ares, Verify the order got completed succesfully in Viax'
            ${PPJsonName}=    get from list    ${PPJsonList}    ${ListIndexIterator}
            ${OrderJson}=    get from list    ${OrderJsonList}    ${ListIndexIterator}
            ${Country}=    get from list    ${CountryList}    ${ListIndexIterator}
            ${Currency}=    get from list    ${CurrencyList}    ${ListIndexIterator}
            ${JournalID}=    get from list   ${JournalIDList}    ${ListIndexIterator}
            ${Tax}=    get from list   ${TaxList}    ${ListIndexIterator}
            ${APC}=    get from list   ${APCList}    ${ListIndexIterator}
            ${ArtDiscount}=    get from list    ${BaseArticleTypeList}    ${ListIndexIterator}
            ${Environment}=    get from list    ${EnvironmentList}    ${ListIndexIterator}
            ${json_content}=  Get File  ${execdir}${file}${PPJsonName}.json
            ${json_content}=    Generate the JSON file PP    ${json_content}    ${JournalID}
#            Write Output Excel    PriceProposal    JSONText    ${RowCounter}    ${json_content}
            Switch Case    ${Environment}
            create session    order_session    ${PPURL}    verify=True
            ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${AuthToken}
            ${response}=     post on session    order_session    url=${GraphqlURL}     data=${json_content}     headers=${headers}
            # Getting the content value
            Log    Status Code: ${response.status_code}
            Log    Response Content: ${response.content}
            ${response.status_code}=  convert to string    ${response.status_code}
#            Validate the content and update the excel    200    ${response.status_code}    PriceProposal    ResponseStatusCode    ${RowCounter}
            set variable    ${response.content}
            set variable    ${response.json()}
            ${response_text}=    convert to string    ${response.content}
            ${response.json()}=    convert to string    ${response.json()}
#            Write Output Excel    PriceProposal    Response    ${RowCounter}    ${response.json()}
            ${JsonResp}=  Evaluate  ${response.text}
            # Fetch the values from the result Json File
            @{list}=     CustomLib.Get Value From Json    ${JsonResp}    $.data.testFunction.data
            log to console    @{list}
            ${NumberofList}=    get length    ${list}
            set variable    ${JsonResp}
            ${check}=    run keyword and return status    should contain    ${list}[0]    SUCCESS
            ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
            IF    '${check}' == '${True}'
                ${error_code}=  Set Variable  ${json_dict['message']}
                ${PPOrderID}=  Set Variable  ${json_dict['viaxPriceProposalId']}
                ${SubmissionID}=     set variable    ${json_dict['priceProposal']['wAsSubmissionId']}
                log to console   ${PPOrderID}
                ${error_code}=    convert to string    ${error_code}
                ${SubmissionID}=    convert to string     ${SubmissionID}
                ${OrderStatus}=    convert to string    ${PPOrderID}
                Write Output Excel    E2E    PPID    ${RowCounter}    ${PPOrderID}
                Write Output Excel    E2E    SubmissionID    ${RowCounter}    ${SubmissionID}
                ${errormessage}=    set variable    ${json_dict['priceProposal']['bpStatus']['code']}
                ${errormessage}=    convert to string    ${errormessage}
                should contain    ${errormessage}    PriceDetermined
                SeleniumLibrary.input text    ${SearchBox}   ${PPOrderID}
                sleep    5s
                seleniumlibrary.click element    //*[@title="#${PPOrderID}"]
                sleep    5s
                ${UIStatus}=    SeleniumLibrary.get text    //*[@class="x-order-details__status-wrapper"]
                ${Typeofpayment}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//span)[1]
                run keyword and continue on failure    should be equal    ${UIStatus}    PRICE DETERMINED
                run keyword and continue on failure    should be equal    ${Typeofpayment}    AuthorPaid
#                seleniumlibrary.click element    //*[@class="x-icon x-accordion__icon"]
                ${TaxValue}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]/div/div/div/div[5]/div[2])[2]
                ${TaxValue}=    replace string    ${TaxValue}    ${SPACE}    ${EMPTY}
                run keyword and continue on failure    should be equal    ${TaxValue}    0.00USD
                IF    '${errormessage}' == 'PriceDetermined' or '${errormessage}' == 'ManualOverrideRequired'
#                    write and color excel    PriceProposal    PriceProposalStatus    ${RowCounter}    ${errormessage}    00FF00
                    save excel document    ${PPInputExcelPath}
                ELSE
#                    write and color excel    PriceProposal    PriceProposalStatus    ${RowCounter}    ${errormessage}    FF0000
                    save excel document    ${PPInputExcelPath}
                END
                IF    '${errormessage}' == 'PriceDetermined'
                    Get DBS Orders Link    ${Environment}
                    go to     ${DBSURL}
                    ${JSONFileName}=    get from list    ${OrderJsonList}    ${ListIndexIterator}
                    ${today}=     get current date
                    ${UniqueOrderId}=    Convert Date    ${today}    result_format=%Y%m%d%H%M%S
                    ${FirstName}=  set variable     ${UniqueOrderId}Test
                    ${LastName}=  set variable     ${UniqueOrderId}Auto
                    ${MailId}=  set variable     ${UniqueOrderId}@Wiley.com
                    ${APC}=    get from list    ${APCList}    ${ListIndexIterator}
                    ${Currency}=    get from list    ${CurrencyList}    ${ListIndexIterator}
#                    ${TotalAmount}=    get from list    ${TotalAmountList}    ${ListIndexIterator}
                    ${json_content}=  Get File  ${execdir}${file}${JSONFileName}.json
                    ${json_content}=    Create JSON File    ${json_content}   ${FirstName}    ${LastName}    ${MailId}
                    ${json_content}=    replace string    ${json_content}    <<Sub>>    ${SubmissionID}
                    ${json_content}=    replace string    ${json_content}    <<APC>>    ${APC}
                    ${json_content}=    replace string    ${json_content}    <<Currency>>    ${Currency}
                    ${json_content}=    replace string    ${json_content}    <<TotalAmount>>    ${APC}
                    ${json_content}=    replace string     ${json_content}    <<journalId>>    ${JournalID}
                    log to console    ${json_content}
#                    Write Output Excel    OrderCreationCases    JSONText    ${RowCounter}    ${json_content}
                    create session    order_session    ${DBSURL}    verify=True
                    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${AuthToken}
                    ${response}=     post on session    order_session    url=${GraphqlURL}    data=${json_content}     headers=${headers}
                    Log    Status Code: ${response.status_code}
                    Log    Response Content: ${response.content}
                    set variable    ${response.content}
                    set variable    ${response.json()}
                    ${response_text}=    convert to string    ${response.content}
                    ${response.json()}=    convert to string    ${response.json()}
                    Write Output Excel    E2E    Response    ${RowCounter}    ${response.json()}
                    Validate the content and update the excel    200    ${response.status_code}    E2E    ResponseStatusCode    ${RowCounter}
                    ${JsonResp}=  Evaluate  ${response.text}
                    # Fetch the values from the result Json File
                    @{list}=    CustomLib.Get Value From Json    ${JsonResp}    $.data.testFunction.data
                    set variable    ${JsonResp}
                    ${check}=    run keyword and return status    should contain    ${list}[0]    SUCCESS
                    ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
                    IF    '${check}' == '${True}'
                        ${error_code}=  Set Variable  ${json_dict['result']['biId']}
                        ${OrderStatus}=  Set Variable  ${json_dict['result']['message']}
                        ${error_code}=    convert to string    ${error_code}
                        ${OrderStatus}=    convert to string    ${OrderStatus}
                        Write Output Excel    E2E    OrderID    ${RowCounter}    ${error_code}
                        save excel document    ${PPInputExcelPath}
                        ${OrderID}=    set variable    ${error_code}
                        set variable    ${error_code}
                        set variable    ${OrderStatus}
                        go to    ${PPURL}
                        SeleniumLibrary.input text    ${SearchBox}   ${PPOrderID}
                        sleep    5s
                        seleniumlibrary.click element    //*[@title="#${PPOrderID}"]
                        sleep    10s
                        ${UIStatus}=    SeleniumLibrary.get text    //*[@class="x-order-details__status-wrapper"]
                        ${Typeofpayment}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//span)[1]
                        run keyword and continue on failure    should be equal    ${UIStatus}    CLOSED WITH ORDER
                        run keyword and continue on failure    should be equal    ${Typeofpayment}    AuthorPaid
                        Write Output Excel    E2E    PPStatus    ${RowCounter}    ${UIStatus}
                        go to    ${DBSURL}
                        sleep    5s
                        SeleniumLibrary.input text    ${SearchBox}   ${OrderId}
                        sleep    5s
                        ${text}=    SeleniumLibrary.get text    ${statustext}
                        FOR    ${waitIterator}    IN RANGE    1    150
                            IF    '${text}' != 'Invoiced' or '${text}' != 'Completed' or '${text}' == 'Proforma Created'
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
                        run keyword    should contain any    ${text}    Invoiced    Completed
                        Write Output Excel    E2E    OrderStatus    ${RowCounter}    ${text}
                        IF    '${text}' == 'Invoiced' or '${text}' == 'Completed' or '${text}' == 'Proforma Created'
                            sleep    10s
                            seleniumlibrary.click element    //*[contains(@id,"single-spa-application:parcel")]//*[@class="x-order-list-item__title"]
                            sleep    5s
                            ${wileyorderId}=    seleniumlibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//*[@class="x-order-basics-view__value"])[1]
                            sleep    5s
                            ${saporderId}=    seleniumlibrary.get text   (//*[contains(@id,"single-spa-application:parcel")]//*[@class="x-order-basics-view__value"])[8]
                            Write Output Excel    E2E    WileyOrderId    ${RowCounter}    ${wileyorderId}
                            Write Output Excel    E2E    SAPOrderID    ${RowCounter}    ${saporderId}
                            save excel document    ${PPInputExcelPath}
#                            go back
                            open sap logon window    ${SAPGUIPATH}    ${SAPUSERNAME}    ${SAPPASSWORD}    ${ENTERBUTTON}    ${CONNECTION}    ${continuebutton}
                            run transaction    /nVA03
                            sapguilibrary.input text    ${Var_OrderIDTextbox}      ${saporderId}
                            send vkey    0
                            ${SAPCurreny}=    SapGuiLibrary.get value    /app/con[0]/ses[0]/wnd[0]/usr/subSUBSCREEN_HEADER:SAPMV45A:4021/ctxtVBAK-WAERK
                            Validate the content and update the excel    ${Currency}    ${SAPCurreny}    E2E    Currency    ${RowCounter}
                            sapguilibrary.click element    ${Var_ItemOverview}
                            select table row   ${Var_ItemOverviewTableId}       0
                            sapguilibrary.click element    ${Var_OpenItem}
                            sapguilibrary.click element    ${Var_SalesATab}
                            ${Material}=    SapGuiLibrary.Get Value    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_ITEM/tabpT\\01/ssubSUBSCREEN_BODY:SAPMV45A:4451/ctxtVBAP-MATWA
                            sapguilibrary.click element    ${Var_SalesBTab}
                            ${MaterialGroup}=    SapGuiLibrary.Get Value    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_ITEM/tabpT\\02/ssubSUBSCREEN_BODY:SAPMV45A:4458/ctxtVBAP-MATKL
                            ${Division}=     SapGuiLibrary.Get Value    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_ITEM/tabpT\\02/ssubSUBSCREEN_BODY:SAPMV45A:4458/ctxtVBAP-SPART
                            sapguilibrary.click element    ${Var_Shipping}
                            ${Plant}=    SapGuiLibrary.Get Value    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_ITEM/tabpT\\04/ssubSUBSCREEN_BODY:SAPMV45A:4452/ctxtVBAP-WERKS
                            SapGuiLibrary.click element    ${Var_Conditions}
                            ${NetPrice}=    SapGuiLibrary.Get Value    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_ITEM/tabpT\\06/ssubSUBSCREEN_BODY:SAPLV69A:6201/txtKOMP-NETWR
                            ${TaxValue}=   SapGuiLibrary.Get Value    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_ITEM/tabpT\\06/ssubSUBSCREEN_BODY:SAPLV69A:6201/txtKOMP-MWSBP
                            sapguilibrary.click element    ${Var_OrderData}
                            ${ReferenceID}=    SapGuiLibrary.Get Value    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_ITEM/tabpT\\11/ssubSUBSCREEN_BODY:SAPMV45A:4454/txtVBKD-IHREZ

                            ${DBSOrderID}=    SapGuiLibrary.Get Value    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_ITEM/tabpT\\11/ssubSUBSCREEN_BODY:SAPMV45A:4454/txtVBKD-IHREZ_E
                            Validate the content and update the excel    ${DBSOrderID}    ${OrderId}    E2E    OrderID    ${RowCounter}
                            sapguilibrary.click element    ${Var_DataB}
                            ${ArticleNumber}=    SapGuiLibrary.Get Value    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_ITEM/tabpT\\15/ssubSUBSCREEN_BODY:SAPMV45A:4462/subKUNDEN-SUBSCREEN_8459:SAPMV45A:8459/txtVBAP-ZZARTNO
                            Validate the content and update the excel    ${ArticleNumber}    ${SubmissionID}    E2E    SubmissionID    ${RowCounter}
                            send vkey    3
                            send vkey    5
                            selectInvoiceTree        ${Var_InvoiceElement}
                            send vkey    8
                            ${InvoiceNumber}=    SapGuiLibrary.get value    /app/con[0]/ses[0]/wnd[0]/usr/ctxtVBRK-VBELN
                            write output excel    E2E    InvoiceNumber    ${RowCounter}    ${InvoiceNumber}
                            sapguilibrary.click element    /app/con[0]/ses[0]/wnd[0]/usr/btnTC_OUTPUT
                            sapguilibrary.select table row    /app/con[0]/ses[0]/wnd[0]/usr/tblSAPDV70ATC_NAST3    0
                            send vkey    5
                            send vkey    3
                        END
                    ELSE
                        ${errortext}=  Set Variable  ${json_dict['message']}
                        ${errortext}=    convert to string    ${errortext}
                        Write Output Excel    E2E    OrderID    ${RowCounter}    Error-${errortext}
                        set variable   ${errortext}
                    END
                END
            ELSE
                ${error_code}=  Set Variable  ${json_dict['errors']}
                ${error_code}=    convert to string    ${error_code}
#                write and color excel    PriceProposal    OrderStatus    ${RowCounter}    Error in Response    FF0000
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
    Close SAP Connection

#    close all excel documents
#    Read All Input Values From OrderCreationCases    ${PPInputExcelPath}    Data
#    ${ListIndexIterator}    set variable    0
#    ${EnironmentValue}=    get from list    ${ExecutionEnvironmentList}     ${ListIndexIterator}
#    ${EnironmentValue}=    convert to upper case    ${EnironmentValue}
#    Get DBS Orders Link    ${EnironmentValue}
#    Launch and Login DBS    ${DBSURL}    ${username}    ${password}
#    ${OrderIdCount}=    get length    ${OrderIdList}
#    ${RowCounter}    set variable    2
#    FOR    ${ScenarioIterator}    IN RANGE    ${OrderIdCount}
#        ${Flag}=    get from list    ${FlagList}    ${ListIndexIterator}
#        IF    '${Flag}' == 'Yes'
#            ${OrderId}=    get from list    ${OrderIdList}    ${ListIndexIterator}
#            IF  '${OrderId}' != 'None'
#                sleep    5s
#                SeleniumLibrary.input text    ${SearchBox}   ${OrderId}
#                sleep    5s
#                ${text}=    SeleniumLibrary.get text    ${statustext}
#                Write Output Excel    Data    OrderStatus    ${RowCounter}    ${text}
#                 seleniumlibrary.click element    //*[contains(@id,"single-spa-application:parcel")]//*[@class="x-order-list-item__title"]
#                sleep    5s
#                ${wileyorderId}=    seleniumlibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//*[@class="x-order-basics-view__value"])[1]
#                sleep    3s
#                ${saporderId}=    seleniumlibrary.get text   (//*[contains(@id,"single-spa-application:parcel")]//*[@class="x-order-basics-view__value"])[8]
#                Write Output Excel    Data    WileyOrderId    ${RowCounter}    ${wileyorderId}
#                Write Output Excel    Data    SAPOrderID    ${RowCounter}    ${saporderId}
#                save excel document    ${PPInputExcelPath}
#                go back
#            END
#        END
#        ${ListIndexIterator}=    evaluate    ${ListIndexIterator} + int(${1})
#        ${RowCounter}=    evaluate    ${RowCounter} + int(${1})
#        save excel document    ${PPInputExcelPath}
#        sleep    5s
#    END
#    save excel document    ${PPInputExcelPath}
#    open sap logon window    ${SAPGUIPATH}    ${SAPUSERNAME}    ${SAPPASSWORD}    ${ENTERBUTTON}    ${CONNECTION}    ${continuebutton}
#    run transaction    /nVA03
#    sapguilibrary.input text    ${Var_OrderIDTextbox}      8000042395
#    send vkey    0
#    ${Curreny}=    SapGuiLibrary.get value    /app/con[0]/ses[0]/wnd[0]/usr/subSUBSCREEN_HEADER:SAPMV45A:4021/ctxtVBAK-WAERK
#    sapguilibrary.click element    ${Var_ItemOverview}
#    select table row   ${Var_ItemOverviewTableId}       0
#    sapguilibrary.click element    ${Var_OpenItem}
#    sapguilibrary.click element    ${Var_SalesATab}
#    ${Material}=    SapGuiLibrary.Get Value    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_ITEM/tabpT\\01/ssubSUBSCREEN_BODY:SAPMV45A:4451/ctxtVBAP-MATWA
#    sapguilibrary.click element    ${Var_SalesBTab}
#    ${MaterialGroup}=    SapGuiLibrary.Get Value    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_ITEM/tabpT\\02/ssubSUBSCREEN_BODY:SAPMV45A:4458/ctxtVBAP-MATKL     ${Division}=     SapGuiLibrary.Get Value    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_ITEM/tabpT\\02/ssubSUBSCREEN_BODY:SAPMV45A:4458/ctxtVBAP-SPART
#    sapguilibrary.click element    ${Var_Shipping}
#    ${Plant}=    SapGuiLibrary.Get Value    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_ITEM/tabpT\\04/ssubSUBSCREEN_BODY:SAPMV45A:4452/ctxtVBAP-WERKS
#    SapGuiLibrary.click element    ${Var_Conditions}
#    ${NetPrice}=    SapGuiLibrary.Get Value    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_ITEM/tabpT\\06/ssubSUBSCREEN_BODY:SAPLV69A:6201/txtKOMP-NETWR
#    ${TaxValue}=   SapGuiLibrary.Get Value    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_ITEM/tabpT\\06/ssubSUBSCREEN_BODY:SAPLV69A:6201/txtKOMP-MWSBP     sapguilibrary.click element    ${Var_OrderData}
#    ${ReferenceID}=    SapGuiLibrary.Get Value    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_ITEM/tabpT\\11/ssubSUBSCREEN_BODY:SAPMV45A:4454/txtVBKD-IHREZ
#    ${DBSOrderID}=    SapGuiLibrary.Get Value    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_ITEM/tabpT\\11/ssubSUBSCREEN_BODY:SAPMV45A:4454/txtVBKD-IHREZ_E
#    sapguilibrary.click element    ${Var_DataB}
#    ${ArticleNumber}=    SapGuiLibrary.Get Value    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_ITEM/tabpT\\15/ssubSUBSCREEN_BODY:SAPMV45A:4462/subKUNDEN-SUBSCREEN_8459:SAPMV45A:8459/txtVBAP-ZZARTNO
#    send vkey    3
#    send vkey    5
#    selectInvoiceTree        ${Var_InvoiceElement}
#    send vkey    8
#    ${InvoiceNumber}=    SapGuiLibrary.get value    /app/con[0]/ses[0]/wnd[0]/usr/ctxtVBRK-VBELN
#    sapguilibrary.click element    /app/con[0]/ses[0]/wnd[0]/usr/btnTC_OUTPUT
#    sapguilibrary.select table row    /app/con[0]/ses[0]/wnd[0]/usr/tblSAPDV70ATC_NAST3    0
#    send vkey    5
#    send vkey    3



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
    ${ExcelDictionary}    ReadAllValuesFromPPExcel    ${InputExcel}    E2E
    ${TestScenarioList}     get from dictionary    ${ExcelDictionary}    TestScenario
    ${PPJsonList}    get from dictionary    ${ExcelDictionary}    PPJson
    ${OrderJsonList}    get from dictionary    ${ExcelDictionary}    OrderJson
    ${JournalIDList}    get from dictionary    ${ExcelDictionary}    JournalID
    ${CountryList}    get from dictionary    ${ExcelDictionary}    Country
    ${CurrencyList}    get from dictionary    ${ExcelDictionary}    Currency
    ${TaxList}    get from dictionary    ${ExcelDictionary}    Tax
    ${APCList}    get from dictionary    ${ExcelDictionary}    APC
    ${BaseArticleTypeList}    get from dictionary    ${ExcelDictionary}    BaseArticleDiscount
    ${EnvironmentList}    get from dictionary    ${ExcelDictionary}    Environment
    ${ScenarioList}    get from dictionary    ${ExcelDictionary}    TestScenario
    set suite variable    ${TestScenarioList}    ${TestScenarioList}
    set suite variable    ${PPJsonList}    ${PPJsonList}
    set suite variable    ${OrderJsonList}    ${OrderJsonList}
    set suite variable    ${CountryList}      ${CountryList}
    set suite variable    ${CurrencyList}    ${CurrencyList}
    set suite variable    ${TaxList}    ${TaxList}
    set suite variable    ${APCList}    ${APCList}
    set suite variable    ${BaseArticleTypeList}    ${BaseArticleTypeList}
    set suite variable    ${EnvironmentList}    ${EnvironmentList}
    set suite variable    ${JournalIDList}    ${JournalIDList}
    set suite variable    ${ScenarioList}    ${ScenarioList}
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
#    ${LoginCheck}=    run keyword and return status    element text should be    //*[@id="kc-page-title"]    Sign In
#    IF    '${LoginCheck}' == 'True'
#        Launch and Login DBS    ${PPURL}    ${username}    ${password}
#        sleep    5s
#    END


getdate
    [Arguments]   ${date_format}
    ${Formatted_Date}       Get Current Date     result_format=${date_format}
    RETURN       ${Formatted_Date}

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
#    ${SubmissionId}=    replace string    ${submission}    <<RandonSub>>    ${random_8_digit_number}
    ${today}=     get current date
    ${UniqueOrderId}=    Convert Date    ${today}    result_format=%Y%m%d%H%M%S
    ${FromDate}=    Convert Date    ${today}    result_format=%Y-%m-%d
    ${UniqueOrderId}=    convert to string    ${UniqueOrderId}
#    ${SubmissionId}=    convert to string    ${SubmissionId}
    ${FisrtName}=    convert to string    ${FirstName}
    ${LastName}=    convert to string    ${LastName}
    ${MailId}=    convert to string    ${MailId}
    ${Id}=     convert to string   ${Id}
    ${Dhid}=    convert to string    ${Dhid}
    ${FromDate}=    convert to string    ${FromDate}
    # Replace the Values in JSON File
    ${json_content}=    replace string    ${json_content}    <<OrderId>>    ${UniqueOrderId}
#    ${json_content}=    replace string    ${json_content}    <<Sub>>    ${SubmissionId}
    ${json_content}=    replace string    ${json_content}    <<FIRSTNAME>>    ${FisrtName}
    ${json_content}=    replace string    ${json_content}    <<LASTNAME>>    ${LastName}
    ${json_content}=    replace string    ${json_content}    <<MailId>>    ${MailId}
    ${json_content}=    replace string    ${json_content}    <<ID>>    ${Id}
    ${json_content}=    replace string    ${json_content}    <<DHID>>    ${Dhid}
    ${json_content}=    replace string    ${json_content}    <<DATE>>    ${FromDate}
    RETURN    ${json_content}

Get DBS Orders Link
    [Arguments]    ${value}
    Run Keyword If    '${value}' == 'QA2'    set suite variable    ${DBSURL}     https://wileyas.qa2.viax.io/orders
    Run Keyword If    '${value}' == 'QA2'    set suite variable    ${GraphqlURL}      https://api.wileyas.qa2.viax.io/graphql
    Run Keyword If    '${value}' == 'STAGE'    set suite variable     ${GraphqlURL}    https://api.wileyas.stage.viax.io/graphql
    Run Keyword If    '${value}' == 'STAGE'    set suite variable     ${DBSURL}    https://wileyas.stage.viax.io/price-proposals
    ...    ELSE    Log    Default Case