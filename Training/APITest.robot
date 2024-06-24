*** Settings ***
Library    Collections
Library    JSONLibrary
Library    OperatingSystem
Library    String
Library    RequestsLibrary
Library    SeleniumLibrary
Library    SapGuiLibrary
Library    ExcelLibrary
Library    Process
Library    DateTime


*** Variables ***
#-----------------JSON------------------------------------------------
${json_file_path}  C:\\Users\\dchinnasam\\OneDrive\\Documents\\VIAXDocs\\NewPara.json
${inputExcelPath}    C:\\Users\\dchinnasam\\OneDrive\\Documents\\VIAXDocs\\TD_Inputs.xlsx
${SheetName}    Inputs
#---------------------General Variables-------------------------------
${BASE_URL}       https://api.wileyas.qa2.viax.io/graphql
${EMPTY}
${Token1}    eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICIyczVNbG80eUZVRC1kMzlseXZMUHhYOWJYc2NCZ3ZiaHVLWHpNNU53b3hrIn0.eyJleHAiOjE3MDE2MTM5OTYsImlhdCI6MTcwMTYwNjc5NiwianRpIjoiNTgxZjJmYjctMDEzNC00YzAwLWI1YWMtNDdhNzZlNzk3OWMyIiwiaXNzIjoiaHR0cHM6Ly9hdXRoLndpbGV5YXMucWEyLnZpYXguaW8vcmVhbG1zL3dpbGV5YXMiLCJhdWQiOiJhY2NvdW50Iiwic3ViIjoiNmJmOTUzYjYtZDlhNS00MjdlLTgzNjItMjlmZjM1YTQ2MWIzIiwidHlwIjoiQmVhcmVyIiwiYXpwIjoidmlheC11aSIsInNlc3Npb25fc3RhdGUiOiJiZDgzYmFlMi03YzgwLTQ4MmMtOGE5OS1iM2JjMDA4Yjc1ZTgiLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsiZGVmYXVsdC1yb2xlcy13aWxleWFzIiwib2ZmbGluZV9hY2Nlc3MiLCJhZG1pbiIsInVtYV9hdXRob3JpemF0aW9uIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsIm1hbmFnZS1hY2NvdW50LWxpbmtzIiwidmlldy1wcm9maWxlIl19fSwic2NvcGUiOiJyZWFsbSBwcm9maWxlIGVtYWlsIiwic2lkIjoiYmQ4M2JhZTItN2M4MC00ODJjLThhOTktYjNiYzAwOGI3NWU4IiwidWlkIjoiYjZlNGUxZjctY2E1Yy00MTU2LWIzNmItODNhMjA2ZTFmMmMyIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsInJlYWxtIjoid2lsZXlhcyIsInByZWZlcnJlZF91c2VybmFtZSI6InJyYXZpcGF0aUB3aWxleS5jb20iLCJlbWFpbCI6InJyYXZpcGF0aUB3aWxleS5jb20ifQ.A2V18LzBgYknVSoJ-81_Z5ZGWpShkrradl5ZT-jfQJywdaiWJL8fCbbpTGti584-4NUbIR7q_cP1KtsIzpTiDhBvAPcKcICTtnTmkpzoqP1kGaCHkJkTXXUSPLkXxZFjdwVz2GS_oJ32YIqRZ0s602qULDYW2-mttJn6TBeJdxvwVkDShGxE12ZTHTgkLN4Y71SEWE51zhVhIW303U9WnFEPq2eD8qY4me7JiQ9fsmRTmJhRR3o1O9UmY5_hHt6Ed3SzQsddD9fZqL-MdaDB2CT-SJdoR5FcdidqtuK9zwczALzqPgt0pAch7tXNMuxMxQR_0fJ8EpGRi4lrMXx4Ug
${response_text}
${True}    True
${END}    END
${LastNameList}
${MailIdList}
${IdocNumber}
#--------------------------Chrome---------------------------------------
${URL}            https://wileyas.qa2.viax.io/orders
${Browser}        chrome
${username}     dchinnasam@wiley.com
${password}     VIRapr@678
${SearchBox}    //html//body//div[1]//div//div//div//div[2]//div//label//div[1]//input
${statustext}    xpath=/html/body/div[1]/div/div/div/div[2]/div/div[2]/div[1]/div/div/div/div/div[5]/div/span
${ordercheck}    xpath=/html/body/div[1]/div/div/div/div[2]/div/div[1]/div[1]
#---------------------------ExcelPath-----------------------------------
${InputExcelPath}    C:\\Users\\dchinnasam\\OneDrive\\Documents\\VIAXDocs\\TD_Inputs.xlsx
${InputExcelSheet}      Inputs
#---------------------------SAPLogo on-------------------------------
${SAPGUIPATH}    C:/Program Files (x86)/SAP/FrontEnd/SAPgui/saplogon.exe
${CONNECTION}    EQ2-Load Balancer
${SAPCLIENT}      100
${SAPUSERNAME}    SAPQA_APP1
${SAPPASSWORD}    Quality75#
${ENTERBUTTON}    /app/con[0]/ses[0]/wnd[0]/tbar[0]/btn[0]
#---------------------------WE09-------------------------------------
${idocnumberwe09}    /app/con[0]/ses[0]/wnd[0]/usr/txtDOCNUM-LOW
${EMPTY}
${direcctiontextbox}    /app/con[0]/ses[0]/wnd[0]/usr/ctxtDIRECT-LOW
${basictypetextbox}    /app/con[0]/ses[0]/wnd[0]/usr/ctxtIDOCTP-LOW
${segmenttextbox}    /app/con[0]/ses[0]/wnd[0]/usr/ctxtSEGMENT1
${filedtextbox}    /app/con[0]/ses[0]/wnd[0]/usr/ctxtFIELD1_1
${searchvaluetextbox}    /app/con[0]/ses[0]/wnd[0]/usr/txtVALUE1_1
${fromdatetextbox}    /app/con[0]/ses[0]/wnd[0]/usr/ctxtCREDAT-LOW
${todatetextbox}    /app/con[0]/ses[0]/wnd[0]/usr/ctxtCREDAT-HIGH
${popyesbutton}    /app/con[0]/ses[0]/wnd[1]/usr/btnBUTTON_1
${statusbar}    /app/con[0]/ses[0]/wnd[0]/sbar/pane[0]
${unsuccessfulyesbutton}    /app/con[0]/ses[0]/wnd[1]/tbar[0]/btn[0]
${unsuccessfulpopup}    /app/con[0]/ses[0]/wnd[1]/usr/txtMESSTXT1
${idoclabelindex}    /app/con[0]/ses[0]/wnd[0]/usr/lbl[4,4]
${idocstatusvalue}    /app/con[0]/ses[0]/wnd[0]/usr/ctxtEDIDC-STATUS
#-------------------------BD87---------------------------------------
${idocvaluetextbox}    /app/con[0]/ses[0]/wnd[0]/usr/ctxtSX_DOCNU-LOW
${BD87nodelink}    /app/con[0]/ses[0]/wnd[0]/usr/cntlTREE_CONTAINER/shellcont/shell
${bd87createdon}    /app/con[0]/ses[0]/wnd[0]/usr/ctxtSX_CREDA-LOW
${bd87createdhigh}    /app/con[0]/ses[0]/wnd[0]/usr/ctxtSX_CREDA-HIGH
${bd87changedlow}     /app/con[0]/ses[0]/wnd[0]/usr/ctxtSX_UPDDA-LOW
${bd87changedhigh}     /app/con[0]/ses[0]/wnd[0]/usr/ctxtSX_UPDDA-HIGH
${today}


*** Test Cases ***
#Creata Order via JSON File and Fetch the Status
#
#    #Read all values from the input excel doccument
#    Read All Input Values From Excel    ${InputExcelPath}    Inputs
#    ${ListIndexIterator}    set variable    0
#    ${UniqueOrderIdCount}=    get length    ${UniqueOrderIdList}
#    ${RowCounter}    set variable    2
#    FOR    ${TestIterator}    IN    @{UniqueOrderIdList}
#        IF    '${TestIterator}' != 'None' and '${TestIterator}' != '${EMPTY}'    #and '${TestIterator}' != '${END}'
#            ${json_content}=  Get File  ${json_file_path}
#            ${json_content}=    convert to string    ${json_content}
#            ${UniqueOrderId}=    get from list    ${UniqueOrderIdList}    ${ListIndexIterator}
#            ${SubmissionId}=    get from list    ${SubmissionIdList}    ${ListIndexIterator}
#            ${FisrtName}=    get from list    ${FirstNameList}    ${ListIndexIterator}
#            ${LastName}=    get from list    ${LastNameList}    ${ListIndexIterator}
#            ${MailId}=    get from list    ${MailIdList}    ${ListIndexIterator}
#            ${Id}=    get from list    ${IDlist}    ${ListIndexIterator}
#            ${Dhid}=    get from list    ${DhIdlist}    ${ListIndexIterator}
#            ${UniqueOrderId}=    convert to string    ${UniqueOrderId}
#            ${SubmissionId}=    convert to string    ${SubmissionId}
#            ${FisrtName}=    convert to string    ${FisrtName}
#            ${LastName}=    convert to string    ${LastName}
#            ${MailId}=    convert to string    ${MailId}
#            ${Id}=     convert to string   ${Id}
#            ${Dhid}=    convert to string    ${Dhid}
#            # Replace the Values in JSON File
#            ${json_content}=    replace string    ${json_content}    <<OrderId>>    ${UniqueOrderId}
#            ${json_content}=    replace string    ${json_content}    <<Sub>>    ${SubmissionId}
#            ${json_content}=    replace string    ${json_content}    <<FirstName>>    ${FisrtName}
#            ${json_content}=    replace string    ${json_content}    <<LastName>>    ${LastName}
#            ${json_content}=    replace string    ${json_content}    <<MailId>>    ${MailId}
#            ${json_content}=    replace string    ${json_content}    <<ID>>    ${Id}
#            ${json_content}=    replace string    ${json_content}    <<DHID>>    ${Dhid}
##            log to console    ${json_content}
#            log     ${json_content}
#            create session    order_session    https://api.wileyas.qa2.viax.io
#            ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${Token1}
##            set variable    ${response}
#            ${response}=     post on session    order_session    url=${BASE_URL}    data=${json_content}     headers=${headers}
#            # Getting the content value
#            Log    Status Code: ${response.status_code}
#            Log    Response Content: ${response.content}
#            #add Token Verification
#            # Converting the files to string
#            set variable    ${response.content}
#            set variable    ${response.json()}
#            ${response_text}=    convert to string    ${response.content}
#            ${response.json()}=    convert to string    ${response.json()}
#            ${JsonResp}=  Evaluate  ${response.text}
#            log    ${JsonResp}
#            # Fetch the values from the result Json File
#            @{list}=    get value from json    ${JsonResp}    $.data.testFunction.data
#            set variable    ${JsonResp}
#            log    ${list}[0]
##            log to console    ${list}[0]
#            ${check}=    run keyword and return status    should not contain    ${list}[0]    errorCode
##            log to console    ${check}
#            ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
#            IF    '${check}' == '${True}'
#
#                ${error_code}=  Set Variable  ${json_dict['result']['biId']}
#                ${OrderStatus}=  Set Variable  ${json_dict['result']['message']}
#                Log  Error Code: ${error_code}
##                log to console    ${error_code}
#                ${error_code}=    convert to string    ${error_code}
#                ${OrderStatus}=    convert to string    ${OrderStatus}
#                write and color excel cell    ${SheetName}    OrderId    ${RowCounter}    ${error_code}
#                write and color excel cell    ${SheetName}    OrderStatus    ${RowCounter}    ${OrderStatus}
#                set variable    ${error_code}
#                set variable    ${OrderStatus}
#            ELSE
#
#                ${errortext}=  Set Variable  ${json_dict['message']}
#                ${errortext}=    convert to string    ${errortext}
##                log to console    ${errortext}
#                write and color excel cell    ${SheetName}    OrderStatus    ${RowCounter}    ${errortext}
#                set variable   ${errortext}
#            END
#        ELSE
#            save excel document    ${InputExcelPath}
#            exit for loop
#        END
#        ${RowCounter}=    evaluate    ${RowCounter} + int(${1})
#        ${ListIndexIterator}=    evaluate    ${ListIndexIterator} + int(${1})
#        save excel document    ${InputExcelPath}
#        set variable    ${json_dict}
#        set variable    ${JsonResp}
#    END
#    save excel document    ${InputExcelPath}
#    close current excel document
#    close all excel documents

Validate Order Status in VIAX and IDoc Status in ECC
    #Read all Values in Input Excel
    Read All Input Values From OutputExcel    ${InputExcelPath}    ${InputExcelSheet}
    ${ListIndexIterator}    set variable    0
    ${OrderIDListCount}=    get length    ${OrderIDList}
    ${RowCounter}    set variable    2
    FOR    ${OrderIdIterator}    IN    @{OrderIDList}
        ${OrderID}    get from list    ${OrderIDList}    ${ListIndexIterator}
#        ${OrderIDNueric}=    should not contain any
        IF    '${OrderIdIterator}' != 'None' and '${OrderIdIterator}' != '${EMPTY}'
            ${MailId}    get from list     ${MailIdList}    ${ListIndexIterator}
            ${ViaxOrderStatus}=    VIAX Order Status    ${OrderID}
            ${ViaxOrderStatusCheckFlag}=   run keyword and return status    should not contain    ${ViaxOrderStatus}    Not
            IF    '${ViaxOrderStatusCheckFlag}' == 'True'
                close browser
                Write And Color Excel Cell    Inputs    OrderPresenceStatus    ${RowCounter}    ${ViaxOrderStatus}
                save excel document    ${InputExcelPath}
                open sap logon window    ${SAPGUIPATH}    ${SAPUSERNAME}    ${SAPPASSWORD}    ${ENTERBUTTON}    ${CONNECTION}
                #Idoc Validations in SAP
                ${InboundIdocStatus}=    Validate Status and Process IDoc    ${BD87nodelink}    ${MailId}    1    ORDERS05    #E1EDPT2
                IF    '${InboundIdocStatus}' == '03' or '${InboundIdocStatus}' == '53'
                    ${ViaxOrderStatus}=    VIAX Order Status    ${OrderID}
                    close browser
                    Write And Color Excel Cell    Inputs    SentToSAPStatus    ${RowCounter}    ${ViaxOrderStatus}
                    Write And Color Excel Cell    Inputs    InboundIdocNumber    ${RowCounter}    ${IdocNumber}
                    ${OutboundIdocStatus}=    Validate Status and Process IDoc    ${BD87nodelink}    ${MailId}    2    ORDERS05    #E1EDPT2
                    log to console    ${OutboundIdocStatus}
                    log    ${OutboundIdocStatus}
                    IF    '${OutboundIdocStatus}' == '03' or '${OutboundIdocStatus}' == '53'
                       ${ViaxOrderStatus}=    VIAX Order Status    ${OrderID}
                       close browser
                       Write And Color Excel Cell    Inputs    OutBoundIdocNumber    ${RowCounter}    ${IdocNumber}
                       ${InvoiceIdocStatus}=    Validate Status and Process IDoc    ${BD87nodelink}    ${MailId}    1    INVOIC02    #E1EDPT2
                       Write And Color Excel Cell    Inputs    CreatingCustomer    ${RowCounter}    ${ViaxOrderStatus}
                        IF    '${InvoiceIdocStatus}' == '03' or '${InvoiceIdocStatus}' == '53'
                           ${ViaxOrderStatus}=    VIAX Order Status    ${OrderID}
                           Write And Color Excel Cell    Inputs    InvoicedStatus    ${RowCounter}    ${ViaxOrderStatus}
                           Write And Color Excel Cell    Inputs    InvoiceIDocNumber    ${RowCounter}    ${IdocNumber}
                        ELSE
                            Write And Color Excel Cell    Inputs    InvoiceIDocNumber    ${RowCounter}    Issue In Idoc or No Idoc Found
                        END
                    ELSE
                        Write And Color Excel Cell    Inputs    OutBoundIdocNumber    ${RowCounter}    Issue In Idoc or No Idoc Found
                    END
                ELSE
                    Write And Color Excel Cell    Inputs    InboundIdocNumber    ${RowCounter}    Issue In Idoc or No Idoc Found
                END
            ELSE
                Write And Color Excel Cell    Inputs    SentToStatus    ${RowCounter}    ${ViaxOrderStatus}
            END
            ${RowCounter}=    evaluate    ${RowCounter} + int(${1})
            ${ListIndexIterator}=    evaluate    ${ListIndexIterator} + int(${1})
            save excel document    ${InputExcelPath}
        END
    END
    save excel document    ${InputExcelPath}
    close current excel document
    close browser
    close sap connection


*** Keywords ***

Read All Input Values From Excel
    [Arguments]    ${InputExcel}    ${InputSheet}
    ${ExcelDictionary}    ReadAllValuesFromExcel    ${InputExcel}    ${InputSheet}
    ${FirstNameList}    get from dictionary    ${ExcelDictionary}    FirstName
    ${UniqueOrderIdList}    get from dictionary    ${ExcelDictionary}    UniqueOrderId
    ${SubmissionIdList}    get from dictionary    ${ExcelDictionary}    SubmissionId
    ${LastNameList}    get from dictionary    ${ExcelDictionary}    LastName
    ${MailIdList}    get from dictionary    ${ExcelDictionary}    MailId
    ${IDlist}    get from dictionary    ${ExcelDictionary}    DynamicID
    ${DhIdlist}    get from dictionary    ${ExcelDictionary}    RandomDhid
    set suite variable   ${FirstNameList}   ${FirstNameList}
    set suite variable    ${SubmissionIdList}    ${SubmissionIdList}
    set suite variable    ${UniqueOrderIdList}    ${UniqueOrderIdList}
    set suite variable    ${LastNameList}    ${LastNameList}
    set suite variable    ${IDlist}    ${IDlist}
    set suite variable    ${DhIdlist}    ${DhIdlist}
    set suite variable    ${MailIdList}    ${MailIdList}
    open excel document    ${inputExcelPath}    docID


Read All Input Values From OutputExcel
    [Arguments]    ${InputExcel}    ${InputSheet}
    ${ExcelDictionary}    ReadAllValuesFromExcel    ${InputExcel}    ${InputSheet}
    ${MailIdList}    get from dictionary    ${ExcelDictionary}    MailId
    ${OrderIDList}    get from dictionary    ${ExcelDictionary}    OrderId
    set suite variable   ${MailIdList}   ${MailIdList}
    set suite variable    ${OrderIDList}    ${OrderIDList}
    open excel document    ${inputExcelPath}    docID


ReadAllValuesFromExcel
    [Documentation]    Read all Values from the input excel and return dictionary values will
       ...             have all column values as a list and set the dictionary value
    [Arguments]    ${inputExcelPath}    ${Sheetname}
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

GetColumnIndexInExcelSheet
    [Arguments]    ${sheetname}    ${columnName}
    ${getallColumnnames}=    read excel row    1    sheet_name=${sheetname}
    ${columnindex}=    get index from list   ${getallColumnnames}    ${columnName}
    ${columnindex}=    evaluate    ${columnindex} + int(${1})
    [Return]    ${columnindex}

Write And Color Excel Cell
    [Arguments]    ${sheetname}    ${columnname}    ${excelrownumber}    ${writevalue}    #${colorCode}
    ${columnIndex}=    GetColumnIndexInExcelSheet    ${sheetname}    ${columnname}
    IF    '${columnIndex}' != '${EMPTY}' and '${columnIndex}' != 'None'
        write excel cell    ${excelrownumber}    ${columnIndex}    ${writeValue}    sheet_name=${sheetname}
#        excel color cell    ${excelrownumber}    ${columnIndex}    ${colorCode}    ${sheetname}
    END


Open SAP Logon Window
    [Arguments]    ${SAPGUIPATH}    ${SAPUSERNAME}    ${SAPPASSWORD}    ${ENTERBUTTON}    ${CONNECTION}
    Start Process    ${SAPGUIPATH}    saplogon
    sleep    5s
    connect to session
    open connection    ${CONNECTION}
    sapguilibrary.input text      /app/con[0]/ses[0]/wnd[0]/usr/txtRSYST-BNAME    ${SAPUSERNAME}
    sleep    2s
    sapguilibrary.input password    /app/con[0]/ses[0]/wnd[0]/usr/pwdRSYST-BCODE    ${SAPPASSWORD}
    sapguilibrary.click element    ${ENTERBUTTON}

Click SAP PopUp Button If Present
    [Arguments]    ${elementId}
    ${popupvisible}=    run keyword and return status    sapguilibrary.element should be present    ${elementid}
    IF    '${popupvisible}' == 'True'
        sapguilibrary.click element    ${elementid}
    END

Find and Enter Value in Tableview
    [Arguments]    ${FiledNameinTable}    ${ValueToBeSerached}
    input text    /app/con[0]/ses[0]/wnd[0]/usr/ctxtGD-TAB    /IDT/D_TAX_DATA
    send vkey    0
    send vkey    71
    input text    /app/con[0]/ses[0]/wnd[1]/usr/sub:SAPLSPO4:0300/txtSVALD-VALUE[0,21]    ${FiledNameinTable}
    click element    /app/con[0]/ses[0]/wnd[1]/tbar[0]/btn[0]
    input text    /app/con[0]/ses[0]/wnd[0]/usr/tblSAPLSE16NSELFIELDS_TC/ctxtGS_SELFIELDS-LOW[2,1]    ${ValueToBeSerached}

Calculate TAX Percentage
    [Arguments]    ${TotalAmount}    ${TAXPercentage}
    set suite variable    ${TotalAmount}    ${TotalAmount}
    set suite variable    ${TAXPercentage}    ${TAXPercentage}
    ${TotalAmountSAP}    replace string    ${TotalAmount}    ,    ${EMPTY}
    ${TAXAmount}    evaluate    (${TotalAmountSAP} / 100) * ${TAXPercentage}
    set suite variable    ${TAXAmount}    ${TAXAmount}
    [Return]    ${TAXAmount}



Search IDoc in WE09
    [Arguments]    ${MailId}    ${Direction}    ${BasicType}    #${SerachSegement}
    run transaction    /nWE09
    ${today}=    Get Current Date
    ${FromDate}=    Convert Date    ${today}    result_format=%m/%d/%Y
    ${ToDate}=    convert date    ${today}    result_format=%m/%d/%Y
    SapGuiLibrary.input text    ${fromdatetextbox}    ${FromDate}
    SapGuiLibrary.input text    ${todatetextbox}    ${ToDate}
    SapGuiLibrary.input text    ${direcctiontextbox}    ${Direction}
    sapguilibrary.input text    ${basictypetextbox}   ${BasicType}
#    sapguilibrary.input text    ${segmenttextbox}    ${SerachSegement}
    sapguilibrary.input text    ${filedtextbox}    TDLINE
    SapGuiLibrary.input text    ${searchvaluetextbox}    ${MailId}
    send vkey    8
    click sap popup button if present   ${popyesbutton}
    click sap popup button if present   ${unsuccessfulyesbutton}
    ${statusbarvalue}=     SapGuiLibrary.Get Value    ${statusbar}
    set suite variable    ${statusbarvalue}    ${statusbarvalue}
    [Return]    ${statusbarvalue}


Process IDoc in BD87
    [Arguments]    ${IDocNumber}    ${BD87nodelink}
    run transaction    /nBd87
    sapguilibrary.input text    ${idocvaluetextbox}    ${IdocNumber}
    sapguilibrary.input text    ${bd87changedhigh}    ${EMPTY}
    SapGuiLibrary.input text    ${bd87changedlow}    ${EMPTY}
    sapguilibrary.input text    ${bd87createdhigh}   ${EMPTY}
    sapguilibrary.input text    ${bd87createdon}    ${EMPTY}
    send vkey    8
    sapguilibrary.select node link    ${BD87nodelink}     N5    Column1
    send vkey    8

Get Idoc Number in We09
    [Arguments]    ${MailId}    ${Direction}    ${BasicType}    #${SerachSegement}
    run transaction    /nWE09
    ${today}=    Get Current Date
    ${FromDate}=    Convert Date    ${today}    result_format=%m/%d/%Y
    ${ToDate}=    convert date    ${today}    result_format=%m/%d/%Y
    SapGuiLibrary.input text    ${fromdatetextbox}    ${FromDate}
    SapGuiLibrary.input text    ${todatetextbox}    ${ToDate}
    SapGuiLibrary.input text    ${direcctiontextbox}    ${Direction}
    sapguilibrary.input text    ${basictypetextbox}    ${BasicType}
#    sapguilibrary.input text    ${segmenttextbox}    ${SerachSegement}
    sapguilibrary.input text    ${filedtextbox}    TDLINE
    SapGuiLibrary.input text    ${searchvaluetextbox}    ${MailId}
    send vkey    8
    click sap popup button if present   ${popyesbutton}
    ${IdocNumber}=    SapGuiLibrary.Get Value    ${idoclabelindex}
    set suite variable    ${IdocNumber}    ${IdocNumber}
    [Return]    ${IdocNumber}

Get IDoc Status in WE09
    [Arguments]    ${IdocNumber}
    run transaction    /nWE09
    sapguilibrary.input text     ${idocnumberwe09}    ${IdocNumber}
    send vkey    8
    set focus to element    ${idoclabelindex}
    send vkey    2
    ${IdocStatus}=    SapGuiLibrary.Get Value    ${idocstatusvalue}
    set suite variable    ${IdocStatus}    ${IdocStatus}
    [Return]    ${IdocStatus}

Validate Status and Process IDoc
    [Arguments]     ${BD87nodelink}    ${MailId}    ${Direction}    ${BasicType}    #${SerachSegement}
    ${OutboundIdocNumberStatus}=    Search IDoc in WE09    ${MailId}    ${Direction}    ${BasicType}    #${SerachSegement}
    FOR    ${idocIterator}    IN RANGE    30
        sleep    3s
        IF    '${OutboundIdocNumberStatus}' == '1 IDocs were found'
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
            END
        END
    END
    IF    '${IdocCheckFlag}' == 'True'
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





VIAX Order Status
    [Arguments]    ${OrderID}
    Open Browser    ${URL}    ${Browser}    options=add_experimental_option("detach", True)
    Maximize Browser Window
    set selenium speed    3s
    SeleniumLibrary.input text      id=username    ${username}
    SeleniumLibrary.input password    id=password    ${password}
    SeleniumLibrary.click element    name=login
    sleep    5s
#    SeleniumLibrary.click element    ${SearchBox}
    SeleniumLibrary.input text    ${SearchBox}   ${OrderId}
    sleep    3s
    ${orderexists}=    SeleniumLibrary.get text     ${ordercheck}
    ${proceedflag}=    run keyword and return status    should not contain    ${orderexists}    0
    IF    '${proceedflag}' == 'True'
        ${text}=    SeleniumLibrary.get text    ${statustext}
        ${ViaxOrderStatus}=    set variable     ${text}
    ELSE
        ${ViaxOrderStatus}=    set variable     ${OrderId}:Order Not Found in DBS
    END
    [Return]    ${ViaxOrderStatus}


Close SAP Connection
    #Process to close SAP
    run transaction    /nex

