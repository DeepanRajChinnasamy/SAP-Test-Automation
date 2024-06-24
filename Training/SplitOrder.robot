*** Settings ***
Resource    ../Resource/ObjectRepositories/CustomVariables.robot

*** Variables ***
*** Test Cases ***
Creata Order via JSON File and Fetch the Status
#    ${ExistingMailIdDict}=    get mailid for existing users    ${InputExcelPath}    ExistingUsers
    Read All Input Values From DataExcel    ${InputExcelPath}    HappyFlowData
    close all excel documents
    open excel document    ${InputExcelPath}    docID
    log to console    ${InputExcelPath}
    log    ${InputExcelPath}
    ${ListIndexIterator}    set variable    0
    ${DataIndexIterator}    set variable    0
    ${OrderTypeCount}=    get length    ${FlagList}
    ${RowCounter}    set variable    2
    log to console    ${EXECDIR}
    log    ${EXECDIR}
#    open sap logon window    ${SAPGUIPATH}    ${SAPUSERNAME}    ${SAPPASSWORD}    ${ENTERBUTTON}    ${CONNECTION}
#    Launch and Login DBS    ${URL}    ${username}    ${password}
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
            log to console    ${execdir}${json_file_path}
            ${NumbersofIteration}=    set variable    2
            FOR    ${TestIterator}    IN RANGE    0    ${NumbersofIteration}
#                ${today}=     get current date
#                ${UniqueOrderId}=    Convert Date    ${today}    result_format=%Y%m%d%H%M%S
#                ${FirstName}=  set variable     ${UniqueOrderId}Test
#                ${LastName}=  set variable     ${UniqueOrderId}Auto
#                ${MailId}=  set variable     ${UniqueOrderId}@Wiley.com
                IF    '${TestIterator}' != '0'
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
                Write Output Excel   HappyFlowInputs    JSON    ${RowCounter}    ${json_content}
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
                Write Output Excel   HappyFlowInputs    Response    ${RowCounter}    ${response.json()}
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
            END
        END
        ${ListIndexIterator}=    evaluate    ${ListIndexIterator} + int(${1})
    END
    save excel document    ${InputExcelPath}
    close current excel document
    close all excel documents


#Validate the DBS status and IDoc status in SAP
#    Read the Order Values from Excel    ${inputExcelPath}     HappyFlowInputs
#    ${ListIndexIterator}    set variable    0
#    ${DataIndexIterator}    set variable    0
#    ${OrderTypeCount}=    get length    ${OrderIDList}
#    ${RowCounter}    set variable    2
#    open sap logon window    ${SAPGUIPATH}    ${SAPUSERNAME}    ${SAPPASSWORD}    ${ENTERBUTTON}    ${CONNECTION}
#    Launch and Login DBS    ${URL}    ${username}    ${password}
#    FOR    ${dataIterator}    IN RANGE    ${OrderTypeCount}
#        ${OrderID}    get from list    ${OrderIDList}    ${ListIndexIterator}
#        ${MailId}    get from list    ${MailIdList}    ${ListIndexIterator}
#        ${ViaxOrderStatus}=    VIAX Order Status    ${OrderID}
#        ${ViaxOrderStatusCheckFlag}=   run keyword and return status    should not contain    ${ViaxOrderStatus}    Not
#        IF    '${ViaxOrderStatusCheckFlag}' == 'True'
#            Write Output Excel    HappyFlowInputs    OrderPresenceStatus    ${RowCounter}    YES
#            Write Output Excel    HappyFlowInputs    FetchCustomerCreationStatus    ${RowCounter}    ${ViaxOrderStatus}
#            save excel document    ${InputExcelPath}
#            #Idoc Validations in SAP
#            ${InboundIdocStatus}=    Validate Status and Process IDoc    ${BD87nodelink}    ${MailId}    1    ORDERS05   #${TestIterator}
#            IF    '${InboundIdocStatus}' == '03' or '${InboundIdocStatus}' == '53'
#                open browser if closed    ${URL}
#                ${ViaxOrderStatus}=    VIAX Order Status    ${OrderID}
#                Write Output Excel    HappyFlowInputs    FetchCustomerCreationStatus    ${RowCounter}    ${ViaxOrderStatus}
#                Write Output Excel    HappyFlowInputs    SAPOrderOutbound    ${RowCounter}    ${IdocNumber}
#                ${OutboundIdocStatus}=    Validate Status and Process IDoc    ${BD87nodelink}    ${MailId}    2    ORDERS05    #${TestIterator}
#                log to console    ${OutboundIdocStatus}
#                log    ${OutboundIdocStatus}
#                IF    '${OutboundIdocStatus}' == '03' or '${OutboundIdocStatus}' == '53'
#                   open browser if closed    ${URL}
#                   ${ViaxOrderStatus}=    VIAX Order Status    ${OrderID}
#                   Write Output Excel    HappyFlowInputs    SAPOrderInbound    ${RowCounter}    ${IdocNumber}
#                   ${InvoiceIdocStatus}=    Validate Status and Process IDoc    ${BD87nodelink}    ${MailId}    1    INVOIC02    #${TestIterator}
#                   Write Output Excel    HappyFlowInputs    FetchSentToSAPStatus    ${RowCounter}    ${ViaxOrderStatus}
#                    IF    '${InvoiceIdocStatus}' == '03' or '${InvoiceIdocStatus}' == '53'
#                       open browser if closed    ${URL}
#                       ${ViaxOrderStatus}=    VIAX Order Status    ${OrderID}
#                       Write Output Excel    HappyFlowInputs    FecthInvoiceStatus    ${RowCounter}    ${ViaxOrderStatus}
#                       Write Output Excel    HappyFlowInputs    InvoiceIDocNumber    ${RowCounter}    ${IdocNumber}
#                    ELSE
#                       Write Output Excel    HappyFlowInputs    InvoiceIDocNumber    ${RowCounter}    Issue In Idoc or No Idoc Found
#                    END
#                ELSE
#                    Write Output Excel     HappyFlowInputs    SAPOrderInbound    ${RowCounter}    Issue In Idoc or No Idoc Found
#                END
#            ELSE
#                Write Output Excel    HappyFlowInputs    SAPOrderOutbound    ${RowCounter}    Issue In Idoc or No Idoc Found
#            END
#        ELSE
#            Write Output Excel    HappyFlowInputs    FetchCustomerCreationStatus    ${RowCounter}    ${ViaxOrderStatus}
#        END
#        ${RowCounter}=    evaluate    ${RowCounter} + int(${1})
#        save excel document    ${InputExcelPath}
#        ${ListIndexIterator}=    evaluate    ${ListIndexIterator} + int(${1})
#    END
#    save excel document    ${InputExcelPath}
#    close current excel document
#    close all excel documents
#    close browser
#    close sap connection

*** Keywords ***

Read the Order Values from Excel
    [Arguments]    ${InputExcel}    ${InputSheet}
    ${ExcelDictionary}    ReadAllValuesFromExcel    ${InputExcel}    ${InputSheet}
    ${MailIdList}    get from dictionary    ${ExcelDictionary}    MailId
    ${OrderIDList}    get from dictionary    ${ExcelDictionary}    OrderId
    ${OrderStatusList}    get from dictionary    ${ExcelDictionary}    OrderStatus
    set suite variable    ${OrderStatusList}    ${OrderStatusList}
    set suite variable   ${MailIdList}   ${MailIdList}
    set suite variable    ${OrderIDList}    ${OrderIDList}
    open excel document    ${inputExcelPath}    docID1


Validate Status and Process IDoc
    [Arguments]     ${BD87nodelink}    ${MailId}    ${Direction}    ${BasicType}    #${SerachSegement}
    ${OutboundIdocNumberStatus}=    Search IDoc in WE09    ${MailId}    ${Direction}    ${BasicType}    #${SerachSegement}
    FOR    ${idocIterator}    IN RANGE    90
        sleep    3s
        ${OutboundIdocNumberStatus}=    run keyword and return status    should contain    ${OutboundIdocNumberStatus}    IDocs were found
        IF    '${OutboundIdocNumberStatus}' == 'True'
            ${IdocCheckFlag}=    set variable    True
            exit for loop
        ELSE
            send vkey    8
            click sap popup button if present   ${popyesbutton}
            click sap popup button if present   ${unsuccessfulyesbutton}
            ${statusbarvalue}=    SapGuiLibrary.Get Value    ${statusbar}
            IF    '${statusbarvalue}' == '${EMPTY}'
                ${IdocCheckFlag}=    set variable    False
            ELSE
                ${IdocCheckFlag}=    set variable    True
                exit for loop
            END
        END
    END
    IF    '${IdocCheckFlag}' == 'True'
        SapGuiLibrary.set focus    ${timelabel}
        send vkey    2
        SapGuiLibrary.click element   ${descendingbutton}
        sleep    2s
        ${IdocNumber}=    SapGuiLibrary.Get Value    ${idoclabelindex}
        set suite variable   ${IdocNumber}    ${IdocNumber}
        sapguilibrary.set focus    ${idoclabelindex}
        send vkey    2
        ${IdocStatus}=    SapGuiLibrary.Get Value    ${idocstatusvalue}
        IF    '${IdocStatus}' == '03' or '${IdocStatus}' == '53'
            ${IdocValidationStatus}=    set variable    ${IdocStatus}
            set suite variable    ${IdocValidationStatus}     ${IdocValidationStatus}
            #write excellibrary
         ELSE
             Process IDoc in BD87    ${IdocNumber}    ${BD87nodelink}
             ${IdocValidationStatus}=    Get IDoc Status in WE09    ${IdocNumber}
             set suite variable    ${IdocValidationStatus}     ${IdocValidationStatus}
         END
    ELSE
        set suite variable    ${IdocNumber}     No Idoc Found
        set suite variable    ${IdocValidationStatus}    No Idoc Found
    END
    [Return]    ${IdocValidationStatus}