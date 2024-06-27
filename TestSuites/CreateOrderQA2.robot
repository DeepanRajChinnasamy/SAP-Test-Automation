*** Settings ***
Resource    ../Resource/ObjectRepositories/CustomVariables.robot


*** Test Cases ***
Creata Order via JSON File and Fetch the Status
    [Tags]    id=VA_CO_01
#    ${ExistingMailIdDict}=    get mailid for existing users    ${InputExcelPath}    ExistingUsers
    Read All Input Values From DataExcel    ${InputExcelPath}    HappyFlowData
    close all excel documents
    open excel document    ${InputExcelPath}    docID
    ${ListIndexIterator}    set variable    0
    ${DataIndexIterator}    set variable    0
    ${OrderTypeCount}=    get length    ${FlagList}
    ${RowCounter}    set variable    2
    open sap logon window    ${SAPGUIPATH}    ${SAPUSERNAME}    ${SAPPASSWORD}    ${ENTERBUTTON}    ${CONNECTION}    ${continuebutton}
    Launch and Login DBS    ${URLQA2}    ${username}    ${password}
    FOR    ${dataIterator}    IN RANGE    ${OrderTypeCount}
        ${Flag}=    get from list    ${FlagList}    ${ListIndexIterator}
        ${NewOrdercancellFlag}=   get from list     ${NewOrderCancellationFlagList}    ${ListIndexIterator}
        ${ExistingOrderCancellationFlag}=    get from list    ${ExistingOrderCancellationFlagList}    ${ListIndexIterator}
        ${OrderType}=    get from list    ${OrderTypeList}    ${ListIndexIterator}
        ${CountryCode}=    get from list    ${CountryCodeList}    ${ListIndexIterator}
        IF    '${Flag}' != 'N'
            ${today}=     get current date
            ${UniqueOrderId}=    Convert Date    ${today}    result_format=%Y%m%d%H%M%S
            ${FirstName}=  set variable     ${UniqueOrderId}Test
            ${LastName}=  set variable     ${UniqueOrderId}Auto
            ${MailId}=  set variable     ${UniqueOrderId}@Wiley.com
            ${json_file_path}=    get from list    ${JsonPathList}    ${ListIndexIterator}
            log to console    ${json_file_path}
            ${NumbersofIteration}=    set variable    2
            FOR    ${TestIterator}    IN RANGE    0    ${NumbersofIteration}
                IF    '${TestIterator}' == '1'
                    ${strtowrite}=    catenate    ${OrderType}Existing${separator}${CountryCode}
                    ${strtowrite}=  set variable     ${strtowrite}
                    Write Output Excel   HappyFlowInputs    ScenarioName    ${RowCounter}    ${strtowrite}
                    Write Output Excel   HappyFlowInputs    CancellationFlag    ${RowCounter}    ${ExistingOrderCancellationFlag}
                ELSE
                     ${strtowrite}=    catenate    ${OrderType}${separator}${CountryCode}
                     ${strtowrite}=  set variable      ${strtowrite}
                     Write Output Excel    HappyFlowInputs    ScenarioName    ${RowCounter}    ${strtowrite}
                     Write Output Excel   HappyFlowInputs    CancellationFlag    ${RowCounter}    ${NewOrdercancellFlag}
                END
                ${json_content}=  Get File  ${execdir}${json_file_path}
                ${json_content}=    Generate the JSON file to create order    ${json_content}    ${RowCounter}    ${InputExcelPath}    ${ListIndexIterator}    ${FirstName}    ${LastName}    ${MailId}
                log     ${json_content}

                create session    order_session    ${URLQA2}    verify=True
                ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${Token1}
                ${response}=     post on session    order_session    url=${BASE_URLQA2}    data=${json_content}     headers=${headers}
                # Getting the content value
                Log    Status Code: ${response.status_code}
                Log    Response Content: ${response.content}
                #add Token Verification
                # Converting the files to string
                set variable    ${response.content}
                set variable    ${response.json()}
                ${response_text}=    convert to string    ${response.content}
                ${response.json()}=    convert to string    ${response.json()}
                ${JsonResp}=  Evaluate  ${response.text}
                log    ${JsonResp}
                # Fetch the values from the result Json File
                @{list}=    get value from json    ${JsonResp}    $.data.testFunction.data
                set variable    ${JsonResp}
                log    ${list}[0]
                ${check}=    run keyword and return status    should contain    ${list}[0]    Created
                ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
                ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
                IF    '${check}' == '${True}'
                    ${error_code}=  Set Variable  ${json_dict['result']['biId']}
                    ${OrderStatus}=  Set Variable  ${json_dict['result']['message']}
                    ${error_code}=    convert to string    ${error_code}
                    ${OrderStatus}=    convert to string    ${OrderStatus}
                    Write Output Excel    HappyFlowInputs    OrderId    ${RowCounter}    ${error_code}
                    Write Output Excel    HappyFlowInputs    OrderStatus    ${RowCounter}    ${OrderStatus}
                    ${OrderID}=    set variable    ${error_code}
                    set variable    ${error_code}
                    set variable    ${OrderStatus}
#                    open browser if closed    ${URLQA2}
                    ${ViaxOrderStatus}=    VIAX Order Status    ${error_code}
                    ${ViaxOrderStatusCheckFlag}=   run keyword and return status    should not contain    ${ViaxOrderStatus}    Not
                    IF    '${ViaxOrderStatusCheckFlag}' == 'True'
#                        close browser
                        Write Output Excel    HappyFlowInputs    OrderPresenceStatus    ${RowCounter}    YES
                        Write Output Excel    HappyFlowInputs    FetchCustomerCreationStatus    ${RowCounter}    ${ViaxOrderStatus}
                        save excel document    ${InputExcelPath}
                        #Idoc Validations in SAP
                        ${InboundIdocStatus}=    Validate Status and Process IDoc    ${BD87nodelink}    ${MailId}    1    ORDERS05   #${TestIterator}
                        IF    '${InboundIdocStatus}' == '03' or '${InboundIdocStatus}' == '53'
                            open browser if closed    ${URLQA2}
                            ${ViaxOrderStatus}=    VIAX Order Status    ${OrderID}
#                            close browser
                            Write Output Excel    HappyFlowInputs    FetchCustomerCreationStatus    ${RowCounter}    ${ViaxOrderStatus}
                            Write Output Excel    HappyFlowInputs    SAPOrderOutbound    ${RowCounter}    ${IdocNumber}
                            ${OutboundIdocStatus}=    Validate Status and Process IDoc    ${BD87nodelink}    ${MailId}    2    ORDERS05    #${TestIterator}
                            log to console    ${OutboundIdocStatus}
                            log    ${OutboundIdocStatus}
                            IF    '${OutboundIdocStatus}' == '03' or '${OutboundIdocStatus}' == '53'
#                               open browser if closed    ${URLQA2}
                               ${ViaxOrderStatus}=    VIAX Order Status    ${OrderID}
#                               close browser
                               Write Output Excel    HappyFlowInputs    SAPOrderInbound    ${RowCounter}    ${IdocNumber}
                               ${InvoiceIdocStatus}=    Validate Status and Process IDoc    ${BD87nodelink}    ${MailId}    1    INVOIC02    #${TestIterator}
                               Write Output Excel    HappyFlowInputs    FetchSentToSAPStatus    ${RowCounter}    ${ViaxOrderStatus}
                                IF    '${InvoiceIdocStatus}' == '03' or '${InvoiceIdocStatus}' == '53'
                                   open browser if closed    ${URLQA2}
                                   ${ViaxOrderStatus}=    VIAX Order Status    ${OrderID}
#                                   close browser
                                   Write Output Excel    HappyFlowInputs    FecthInvoiceStatus    ${RowCounter}    ${ViaxOrderStatus}
                                   Write Output Excel    HappyFlowInputs    InvoiceIDocNumber    ${RowCounter}    ${IdocNumber}
                                ELSE
                                   Write Output Excel    HappyFlowInputs    InvoiceIDocNumber    ${RowCounter}    Issue In Idoc or No Idoc Found
                                END
                            ELSE
                                Write Output Excel     HappyFlowInputs    SAPOrderInbound    ${RowCounter}    Issue In Idoc or No Idoc Found
                            END
                        ELSE
                            Write Output Excel    HappyFlowInputs    SAPOrderOutbound    ${RowCounter}    Issue In Idoc or No Idoc Found
                        END
                    ELSE
                        Write Output Excel    HappyFlowInputs    FetchCustomerCreationStatus    ${RowCounter}    ${ViaxOrderStatus}
                    END
#                    close sap connection
                ELSE
                    ${errortext}=  Set Variable  ${json_dict['message']}
                    ${errortext}=    convert to string    ${errortext}
                    Write Output Excel    HappyFlowInputs    OrderStatus    ${RowCounter}    Error-${errortext}
                    set variable   ${errortext}
                END
                ${RowCounter}=    evaluate    ${RowCounter} + int(${1})
                save excel document    ${InputExcelPath}
                set variable    ${json_dict}
                set variable    ${JsonResp}
#                close browser
            END
        END
        ${ListIndexIterator}=    evaluate    ${ListIndexIterator} + int(${1})
    END
    save excel document    ${InputExcelPath}
    close current excel document
    close all excel documents
#    close browser
    close sap connection

Valiadte the Values in DBS and download the PDF
    [Tags]    id=VA_CO_02
#    close browser
    close all excel documents
#    Launch and Login DBS    ${URLQA2}    ${username}    ${password}
    Read All Input Values From OutputExcel    ${InputExcelPath}    HappyFlowInputs
    ${ListIndexIterator}    set variable    0
    ${OrderIDListCount}=    get length    ${OrderIDList}
    ${RowCounter}    set variable    2
#    open sap logon window    ${SAPGUIPATH}    ${SAPUSERNAME}    ${SAPPASSWORD}    ${ENTERBUTTON}    ${CONNECTION}
    FOR    ${OrderIdIterator}    IN    @{OrderIDList}
        ${OrderID}    get from list    ${OrderIDList}    ${ListIndexIterator}
        ${InvoiceStatus}    get from list    ${InvoicedStatusList}    ${ListIndexIterator}
        ${MailId}    get from list    ${MailIdList}    ${ListIndexIterator}
        IF    '${InvoiceStatus}' == 'Invoiced' or '${InvoiceStatus}' == 'Completed'
            sleep    5s
            SeleniumLibrary.input text    ${SearchBox}   ${OrderID}
            sleep    5s
#            wait until element is visible    ${editicon}
            SeleniumLibrary.click element    ${editicon}
            sleep    5s
            ${TaxAmount}=    seleniumlibrary.get text    ${TaxAmtText}
            Write Output Excel    HappyFlowInputs    Tax    ${RowCounter}    ${TaxAmount}
            ${TotalAmount}=    seleniumlibrary.get text    ${TotalAmtText}
            Write Output Excel    HappyFlowInputs    TotalAmount    ${RowCounter}    ${TotalAmount}
#            wait until element is visible    ${wileyorderdetails}
            seleniumlibrary.click element    ${wileyorderdetails}
            sleep    5s
#            wait until element is visible    ${wileyordersearchbox}
            seleniumlibrary.click element    ${wileyordersearchbox}
            sleep    5s
            IF    '${InvoiceStatus}' == 'Invoiced'
#                wait until element is visible    ${wileyinvoicetab}
                SeleniumLibrary.click element    ${wileyinvoicetab}
            END
             IF    '${InvoiceStatus}' == 'Completed'
                wait until element is visible    ${wileypaymentreceipt}
                SeleniumLibrary.click element    ${wileypaymentreceipt}
            END
            sleep    5s
#            wait until element is visible    ${wileyinvoicelink}
            seleniumlibrary.click element    ${wileyinvoicelink}
            sleep    3s
            ${titles} =    Get Window Titles
            Log    List of Window Titles: ${titles}
            ${new_tab_title} =    Set Variable    ${titles}[1]
            ${mainwindow} =    Set Variable    ${titles}[0]
            Switch Window    title=${new_tab_title}
            sleep    5s
            press combination    Key.CTRL    Key.S
            sleep    3s
            ${current_datetime}=    Get Current Date    result_format=%Y%m%d%H%M%S
            ${folderpathtosave} =    set variable    ${pathtosave}${current_datetime}
            create directory    ${folderpathtosave}
            ${temppathtosave} =    catenate  SEPARATOR=   ${folderpathtosave}    \\
            type    ${temppathtosave}${OrderID}.pdf
            sleep    2s
            press combination    Key.ALT    Key.S
            sleep    3s
            ${content}=    convert pdf to txt    ${temppathtosave}${OrderID}.pdf
            create file    ${temppathtosave}${OrderID}.txt    content=${content}
            ${MailFlag}=    run keyword and return status    should contain    ${content}    ${MailId}
            close invoice tab
            switch window    title=${mainwindow}
            sleep    5s
            ${wileyorderId}=    seleniumlibrary.get text    ${wileyorderidpath}
            sleep    3s
            ${saporderId}=    seleniumlibrary.get text    ${saporderpath}
            seleniumlibrary.click element    ${billinglabelpath}
            sleep    3s
            seleniumlibrary.click element    ${namelink}
            sleep    3s
            ${billnumber}=    seleniumlibrary.get text    ${billnumpath}
            ${paymentstatus}=    seleniumlibrary.get text    ${paymentstatuspath}
            Write Output Excel    HappyFlowInputs    WileyOrderNumber    ${RowCounter}    ${wileyorderId}
            Write Output Excel    HappyFlowInputs    BillNumber    ${RowCounter}    ${billnumber}
            Write Output Excel    HappyFlowInputs    SAPOrderID    ${RowCounter}    ${saporderId}
            Write Output Excel    HappyFlowInputs    PaymentStatus    ${RowCounter}    ${paymentstatus}
            validate the content and update the excel    ${MailFlag}    True    HappyFlowInputs    MailId    ${RowCounter}
            go to    ${URLQA2}
        END
        ${RowCounter}=    evaluate    ${RowCounter} + int(${1})
        ${ListIndexIterator}=    evaluate    ${ListIndexIterator} + int(${1})
        save excel document    ${InputExcelPath}
    END
    close all excel documents
    close browser

Cancelling Order via JSON File and Fetch the Status
    [Tags]    id=VA_CO_03
    Read All Input Values For Cancel    ${InputExcelPath}    HappyFlowInputs
    Launch and Login DBS    ${URLQA2}    ${username}    ${password}
    ${ListIndexIterator}    set variable    0
    ${OrderIDListCount}=    get length    ${OrderIDList}
    ${RowCounter}    set variable    2
#    open sap logon window    ${SAPGUIPATH}    ${SAPUSERNAME}    ${SAPPASSWORD}    ${ENTERBUTTON}    ${CONNECTION}
    FOR    ${OrderIdIterator}    IN    @{OrderIDList}
        ${OrderID}    get from list    ${OrderIDList}    ${ListIndexIterator}
        ${CancellationFlag}    get from list    ${CancellationFlagList}    ${ListIndexIterator}
        IF    '${CancellationFlag}'=='Y'
#            ${InvoiceStatus}    get from list    ${InvoicedStatusList}    ${ListIndexIterator}
            ${MailId}    get from list    ${MailIdList}    ${ListIndexIterator}
#            sleep    5s
            SeleniumLibrary.input text    //*[@class="x-search-input__field"]   ${OrderID}
            ${InvoiceStatus}=    get text    //*[@class="x-pill__text"]
            IF    '${InvoiceStatus}' == 'Invoiced' or '${InvoiceStatus}' == 'Completed'
                ${Tax}    get from list    ${TaxList}    ${ListIndexIterator}
                ${Tax}=    convert to string    ${Tax}
                ${Tax}    set variable    ${Tax}
                ${Tax}=    split string    ${Tax}    ${SPACE}
                ${Tax}=    replace string    ${Tax}[0]    ,    ${EMPTY}
                ${TotalAmount}    get from list    ${TotalAmountList}    ${ListIndexIterator}
                ${TotalAmount}=    convert to string    ${TotalAmount}
                ${TotalAmount}    set variable    ${TotalAmount}
                ${TotalAmount}=    split string    ${TotalAmount}    ${SPACE}
                ${TotalAmount}=    replace string    ${TotalAmount}[0]    ,    ${EMPTY}
                ${NewOrder}    get from list    ${NewOrderList}    ${ListIndexIterator}
                ${NewOrder}=    convert to string    ${NewOrder}
                ${DynamicId}    get from list    ${DynamicIdList}    ${ListIndexIterator}
                ${SubmissionID}    get from list    ${SubmissionIDList}    ${ListIndexIterator}
                ${RandomId}    get from list    ${RandomIdList}    ${ListIndexIterator}
                ${today}=     get current date
                ${today}    Convert Date    ${today}    result_format=%Y-%m-%d
                ${future_date}=    Add Time To Date    ${today}    5 days
                ${future_date}    Convert Date    ${future_date}    result_format=%Y-%m-%d
                ${json_content}=  Get File  ${cancellation_json_file_path}
                ${json_content}=    replace string    ${json_content}    <<ID>>    ${RandomId}
                ${json_content}=    replace string    ${json_content}    <<ORDERID>>    ${NewOrder}
                ${json_content}=    replace string    ${json_content}    <<CDATE>>    ${today}
                ${json_content}=    replace string    ${json_content}    <<RDATE>>    ${future_date}
                ${json_content}=    replace string    ${json_content}    <<DHID>>    ${DynamicId}
                ${json_content}=    replace string    ${json_content}    <<Sub>>    ${SubmissionID}
                ${json_content}=    replace string    ${json_content}    <<TOTALAMT>>    ${TotalAmount}
                ${json_content}=    replace string    ${json_content}    <<TAXAMT>>    ${Tax}
                log     ${json_content}
                create session    order_session    ${URLQA2}    verify=True
                ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${Token1}
                ${response}=     post on session    order_session    url=${BASE_URLQA2}    data=${json_content}     headers=${headers}
                # Getting the content value
                Log    Status Code: ${response.status_code}
                Log    Response Content: ${response.content}
                #add Token Verification
                # Converting the files to string
                set variable    ${response.content}
                set variable    ${response.json()}
                ${response_text}=    convert to string    ${response.content}
                ${response.json()}=    convert to string    ${response.json()}
                ${JsonResp}=  Evaluate  ${response.text}
                log    ${JsonResp}
                # Fetch the values from the result Json File
                @{list}=    get value from json    ${JsonResp}    $.data.testFunction.data
                set variable    ${JsonResp}
                log    ${list}[0]
                ${check}=    run keyword and return status    should contain    ${list}[0]    cancelled
                ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
                IF    '${check}' == '${True}'
                    ${error_code}=  Set Variable  ${json_dict['result']['biId']}
                    ${OrderStatus}=  Set Variable  ${json_dict['message']}
                    ${error_code}=    convert to string    ${error_code}
                    ${OrderStatus}=    convert to string    ${OrderStatus}
                END
                ${CancellStatus}=    get text    //*[@class="x-pill__text"]
                Write Output Excel    HappyFlowInputs    CancellationStatus    ${RowCounter}    ${CancellStatus}
                Write Output Excel    HappyFlowInputs    CancellationResponse    ${RowCounter}    ${OrderStatus}
            END
        END
        ${RowCounter}=    evaluate    ${RowCounter} + int(${1})
        ${ListIndexIterator}=    evaluate    ${ListIndexIterator} + int(${1})
        save excel document    ${InputExcelPath}
    END
    close all excel documents
    close browser




***Keywords ***
Switch Case
    [Arguments]    ${value}
    Run Keyword If    '${value}' == 'QA2'    set suite variable    ${PPURL}     https://wileyas.qa2.viax.io/orders
    Run Keyword If    '${value}' == 'QA2'    set suite variable    ${GraphqlURL}      https://api.wileyas.qa2.viax.io/graphql
    Run Keyword If    '${value}' == 'QA'    set suite variable     ${GraphqlURL}    https://api.wileyas.qa.viax.io/graphql
    Run Keyword If    '${value}' == 'QA'    set suite variable     ${PPURL}    https://wileyas.qa.viax.io/orders

    ...    ELSE    Log    Default Case