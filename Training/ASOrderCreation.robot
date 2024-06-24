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
Library    ImageHorizonLibrary
Library    Pdf2TextLibrary



*** Variables ***
#-----------------JSON------------------------------------------------
${json_file_path}  C:\\Users\\dchinnasam\\OneDrive\\Documents\\VIAXDocs\\NewPara.json
${inputExcelPath}    C:\\Users\\dchinnasam\\OneDrive\\Documents\\VIAXDocs\\TD_Inputs.xlsx
${SheetName}    Inputs
#---------------------General Variables-------------------------------
${BASE_URL}       https://api.wileyas.qa2.viax.io/graphql
${EMPTY}
${Token1}   eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICIyczVNbG80eUZVRC1kMzlseXZMUHhYOWJYc2NCZ3ZiaHVLWHpNNU53b3hrIn0.eyJleHAiOjE3MDM2Njg4MjIsImlhdCI6MTcwMzY2MTYyMiwianRpIjoiYTNmMWIxYjEtMmIyNi00ZmE0LWFjNGEtNzVjNjUzMjk2ZTU4IiwiaXNzIjoiaHR0cHM6Ly9hdXRoLndpbGV5YXMucWEyLnZpYXguaW8vcmVhbG1zL3dpbGV5YXMiLCJhdWQiOiJhY2NvdW50Iiwic3ViIjoiNmJmOTUzYjYtZDlhNS00MjdlLTgzNjItMjlmZjM1YTQ2MWIzIiwidHlwIjoiQmVhcmVyIiwiYXpwIjoidmlheC11aSIsInNlc3Npb25fc3RhdGUiOiI3NzMxM2JlMy1mNDMwLTQyMTUtYTZkNS1iNDBkYWQ1MGZkZmIiLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsiZGVmYXVsdC1yb2xlcy13aWxleWFzIiwib2ZmbGluZV9hY2Nlc3MiLCJhZG1pbiIsInVtYV9hdXRob3JpemF0aW9uIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsIm1hbmFnZS1hY2NvdW50LWxpbmtzIiwidmlldy1wcm9maWxlIl19fSwic2NvcGUiOiJyZWFsbSBwcm9maWxlIGVtYWlsIiwic2lkIjoiNzczMTNiZTMtZjQzMC00MjE1LWE2ZDUtYjQwZGFkNTBmZGZiIiwidWlkIjoiYjZlNGUxZjctY2E1Yy00MTU2LWIzNmItODNhMjA2ZTFmMmMyIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsInJlYWxtIjoid2lsZXlhcyIsInByZWZlcnJlZF91c2VybmFtZSI6InJyYXZpcGF0aUB3aWxleS5jb20iLCJlbWFpbCI6InJyYXZpcGF0aUB3aWxleS5jb20ifQ.B_WH7J7NIdgqO2kI37t--iYKmjF93AcINyITTpPPasnFxeG3mfE4hMlMUa0PByi2n5eLi1hbfGdZDVd4b1No1_46AEOV_nzVkzyWUxdEsUua2oaxdhAUyGBgTcA0HfegF3m8wAShE2l-BZ5fPCSmuhwGgrh7Q0fKL9t19ehOcDm0GB6k0vGknrCgJcFia2oyx8gxkV632UdYqhzRxMN6tRyEze_V4lr4B24MiS4fu1clzTRFy0z1vhsZVZRTPkmdx3RN3Vho6_zFpeGEwpVXFmea4Z1I9EokSKeVYz9L8kDDXV0a6en8hMH-WDNeR-8a3qsX3te0VbTAEp0kZFoSmQ
${response_text}
${True}    True
${END}    END
${LastNameList}
${MailIdList}
${IdocNumber}
${Submission}    11ca99f1-8a00-4cb3-123e-222f<<RandonSub>>
${DynamicId}    df1e950b-a1d7-45bf-acab-42f7ed3e<<RandonDynId>>a
${DhId}    e0c<<RandomDhid>>c-ba2c-401d-b2a6-3fb3a59b3c00
${TAXList}
${AmountList}
${DiscountCodeList}
${DiscountTypeList}
${CountryCodeList}
${CurrencyList}
${AppliedDiscountList}
${APCList}
${CreditCardTypeList}
${CreditCardTypeIDList}
${VatNumberList}
${green}    00FF00
${red}    FF0000
#--------------------------Chrome---------------------------------------
${URL}            https://wileyas.qa2.viax.io/orders
${Browser}        chrome
${username}     dchinnasam@wiley.com
${password}     VIRapr@678
${SearchBox}    //html//body//div[1]//div//div//div//div[2]//div//label//div[1]//input
${statustext}    xpath=/html/body/div[1]/div/div/div/div[2]/div/div[2]/div[1]/div/div/div/div/div[5]/div/span
${ordercheck}    xpath=/html/body/div[1]/div/div/div/div[2]/div/div[1]/div[1]
${wileyorderdetails}    xpath=/html/body/div[1]/div/div/div[1]/div[2]/div[2]/div/div/div[1]
${wileyordersearchbox}    xpath=/html/body/div[1]/div/div/div[1]/div[2]/div[2]/div/div[2]/div/div/div/div/div[4]/div/label/span/input
${wileyinvoicetab}    xpath=/html/body/div[1]/div/div/div[1]/div[2]/div[2]/div/div[2]/div/div/div/div[2]/div/div[2]/div/div/div[2]
${wileyinvoicelink}    xpath=/html/body/div[1]/div/div/div[1]/div[2]/div[2]/div/div[2]/div/div/div/div/div[5]/div/button/span
${pdfsave}    xpath=/html/body/div[1]/div/div/div[1]/div[2]/div[2]/div/div[2]/div/div/div/div[2]/div/div[2]/div/div/div[2]
${saveicon}    xpath=/html/body/pdf-viewer//viewer-toolbar//div/div[3]/viewer-download-controls//cr-icon-button//div/iron-icon
${ordercheck}    xpath=/html/body/div[1]/div/div/div/div[2]/div/div[1]/div[1]
${editicon}      xpath=/html/body/div[1]/div/div/div/div[2]/div/div[2]/div[1]/div/div/div/div/div[6]/div
${basicslink}    xpath=/html/body/div[1]/div/div/div/div[2]/div/div[2]/div[1]/div/div/div/div/div[6]/div
${partylink}    xpath=/html/body/div[1]/div/div/div[1]/div[2]/div[2]/div/div/div[1]
${wileyorderdetails}    xpath=/html/body/div[1]/div/div/div[1]/div[2]/div[2]/div/div/div[1]
${wileyordersearchbox}    xpath=/html/body/div[1]/div/div/div[1]/div[2]/div[2]/div/div[2]/div/div/div/div/div[4]/div/label/span/input
${wileyinvoicetab}    xpath=/html/body/div[1]/div/div/div[1]/div[2]/div[2]/div/div[2]/div/div/div/div[2]/div/div[2]/div/div/div[2]
${wileyinvoicelink}    xpath=/html/body/div[1]/div/div/div[1]/div[2]/div[2]/div/div[2]/div/div/div/div/div[5]/div/button/span
${pdfsave}    xpath=/html/body/div[1]/div/div/div[1]/div[2]/div[2]/div/div[2]/div/div/div/div[2]/div/div[2]/div/div/div[2]
${saveicon}    xpath=/html/body/pdf-viewer//viewer-toolbar//div/div[3]/viewer-download-controls//cr-icon-button//div/iron-icon
${wileyorderidpath}    xpath=/html/body/div[1]/div/div/div[1]/div[2]/div[2]/div/div[2]/div/div/div/div/div[1]/div[1]/div[2]
${saporderpath}    xpath=/html/body/div[1]/div/div/div[1]/div[2]/div[2]/div/div[2]/div/div/div/div/div[2]/div[4]/div[2]
${billinglabelpath}    xpath=/html/body/div[1]/div/div/div[1]/div[2]/div[5]/div/div/div[2]/div[2]/span[2]
${namelink}    xpath=/html/body/div[3]/div/div/div/div[2]/div/div/div[2]/div/div[1]/div/p
${billnumpath}    xpath=/html/body/div[3]/div/div/div/div[2]/div/div/div[2]/div[2]/div/div/div/div/div/div[1]/p[2]
${paymentstatuspath}    xpath=/html/body/div[3]/div/div/div/div[2]/div/div/div[2]/div[2]/div/div/div/div/div/div[4]/div/span
#---------------------------ExcelPath-----------------------------------
${InputExcelPath}    C:\\Users\\dchinnasam\\OneDrive\\Documents\\VIAXDocs\\TD_Inputs.xlsx
${InputExcelSheet}      Inputs
${pathtosave}    C:\\Users\\dchinnasam\\OneDrive\\Documents\\VIAXDocs\\
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
${UniqueOrderIdList}
${CreditPath}    CreditPath
${paid}    Paid
${unpaid}    Unpaid
${FlagList}
${separator}    _


*** Test Cases ***
Creata Order via JSON File and Fetch the Status
    ${ExistingMailIdDict}=    get mailid for existing users    ${InputExcelPath}    ExistingUsers
    Read All Input Values From DataExcel    ${InputExcelPath}    Data
    close all excel documents
    open excel document    ${InputExcelPath}    docID
    ${ListIndexIterator}    set variable    0
    ${DataIndexIterator}    set variable    0
    ${OrderTypeCount}=    get length    ${FlagList}
    ${RowCounter}    set variable    2
    FOR    ${dataIterator}    IN RANGE    ${OrderTypeCount}
        ${NumbersofIteration}=    get from list    ${NumofOrderList}    ${ListIndexIterator}
        ${Flag}=    get from list    ${FlagList}    ${ListIndexIterator}
        ${OrderType}=    get from list    ${OrderTypeList}    ${ListIndexIterator}
        ${CountryCode}=    get from list    ${CountryCodeList}    ${ListIndexIterator}
        ${CustomerTypeFlag}=    run keyword and return status    should not contain    ${OrderType}    Existing
#        log to console    ${CustomerTypeFlag}
        IF    '${Flag}' != 'N'
#            ${json_file_path}=    Get the JSON Path    ${OrderType}
            ${json_file_path}=    get from list    ${JsonPathList}    ${ListIndexIterator}
            log to console    ${json_file_path}
            FOR    ${TestIterator}    IN RANGE    ${NumbersofIteration}
                ${strtowrite}=    remove string    ${OrderType}${separator}${CountryCode}    _None
                Write Output Excel    ${SheetName}    ScenarioName    ${RowCounter}    ${strtowrite}
                ${json_content}=  Get File  ${json_file_path}
                ${json_content}=    Generate the JSON file to create order    ${json_content}    ${RowCounter}    ${InputExcelPath}    ${ListIndexIterator}    ${CustomerTypeFlag}    ${strtowrite}    ${ExistingMailIdDict}
                log     ${json_content}
                create session    order_session    ${URL}    verify=True
                ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${Token1}
                ${response}=     post on session    order_session    url=${BASE_URL}    data=${json_content}     headers=${headers}
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
                    Log  Error Code: ${error_code}
    #                log to console    ${error_code}
                    ${error_code}=    convert to string    ${error_code}
                    ${OrderStatus}=    convert to string    ${OrderStatus}
                    Write Output Excel    ${SheetName}    OrderId    ${RowCounter}    ${error_code}
                    Write Output Excel    ${SheetName}    OrderStatus    ${RowCounter}    ${OrderStatus}
                    set variable    ${error_code}
                    set variable    ${OrderStatus}
                ELSE

                    ${errortext}=  Set Variable  ${json_dict['message']}
                    ${errortext}=    convert to string    ${errortext}
    #                log to console    ${errortext}
                    Write Output Excel    ${SheetName}    OrderStatus    ${RowCounter}    ${errortext}
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


Validate Order Status in VIAX and IDoc Status in ECC
    #Read all Values in Input Excel
    Read All Input Values From OutputExcel    ${InputExcelPath}    ${InputExcelSheet}
    ${ListIndexIterator}    set variable    0
    ${OrderIDListCount}=    get length    ${OrderIDList}
    ${RowCounter}    set variable    2
    #Lauch and Login SAP and DBS
    open sap logon window    ${SAPGUIPATH}    ${SAPUSERNAME}    ${SAPPASSWORD}    ${ENTERBUTTON}    ${CONNECTION}
    Launch and Login DBS    ${URL}    ${username}    ${password}
    FOR    ${OrderIdIterator}    IN    @{OrderIDList}
        ${OrderID}    get from list    ${OrderIDList}    ${ListIndexIterator}
        #Verify Order Status and proceed
        IF    '${OrderIdIterator}' != 'None' and '${OrderIdIterator}' != '${EMPTY}'
            ${MailId}    get from list     ${MailIdList}    ${ListIndexIterator}
            ${ViaxOrderStatus}=    VIAX Order Status    ${OrderID}
            ${ViaxOrderStatusCheckFlag}=   run keyword and return status    should not contain    ${ViaxOrderStatus}    Not
            IF    '${ViaxOrderStatusCheckFlag}' == 'True'
                close browser
                Write Output Excel    Inputs    OrderPresenceStatus    ${RowCounter}    ${ViaxOrderStatus}
                save excel document    ${InputExcelPath}
#                open sap logon window    ${SAPGUIPATH}    ${SAPUSERNAME}    ${SAPPASSWORD}    ${ENTERBUTTON}    ${CONNECTION}
                #Idoc Validations in SAP
                ${InboundIdocStatus}=    Validate Status and Process IDoc    ${BD87nodelink}    ${MailId}    1    ORDERS05    #E1EDPT2
                IF    '${InboundIdocStatus}' == '03' or '${InboundIdocStatus}' == '53'
                    ${ViaxOrderStatus}=    VIAX Order Status    ${OrderID}
                    close browser
                    Write Output Excel    Inputs    SentToSAPStatus    ${RowCounter}    ${ViaxOrderStatus}
                    Write Output Excel    Inputs    InboundIdocNumber    ${RowCounter}    ${IdocNumber}
                    ${OutboundIdocStatus}=    Validate Status and Process IDoc    ${BD87nodelink}    ${MailId}    2    ORDERS05    #E1EDPT2
                    log to console    ${OutboundIdocStatus}
                    log    ${OutboundIdocStatus}
                    IF    '${OutboundIdocStatus}' == '03' or '${OutboundIdocStatus}' == '53'
                       ${ViaxOrderStatus}=    VIAX Order Status    ${OrderID}
                       close browser
                       Write Output Excel    Inputs    OutBoundIdocNumber    ${RowCounter}    ${IdocNumber}
                       ${InvoiceIdocStatus}=    Validate Status and Process IDoc    ${BD87nodelink}    ${MailId}    1    INVOIC02    #E1EDPT2
                       Write Output Excel    Inputs    CreatingCustomer    ${RowCounter}    ${ViaxOrderStatus}
                        IF    '${InvoiceIdocStatus}' == '03' or '${InvoiceIdocStatus}' == '53'
                           ${ViaxOrderStatus}=    VIAX Order Status    ${OrderID}
                           Write Output Excel    Inputs    InvoicedStatus    ${RowCounter}    ${ViaxOrderStatus}
                           Write Output Excel    Inputs    InvoiceIDocNumber    ${RowCounter}    ${IdocNumber}
                        ELSE
                            Write Output Excel    Inputs    InvoiceIDocNumber    ${RowCounter}    Issue In Idoc or No Idoc Found
                        END
                    ELSE
                        Write Output Excel    Inputs    OutBoundIdocNumber    ${RowCounter}    Issue In Idoc or No Idoc Found
                    END
                ELSE
                    Write Output Excel    Inputs    InboundIdocNumber    ${RowCounter}    Issue In Idoc or No Idoc Found
                END
            ELSE
                Write Output Excel    Inputs    SentToStatus    ${RowCounter}    ${ViaxOrderStatus}
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

Valiadte the Values in DBS and download the PDF
    Launch and Login DBS    ${URL}    ${username}    ${password}
    Read All Input Values From OutputExcel    ${InputExcelPath}    ${InputExcelSheet}
    ${ListIndexIterator}    set variable    0
    ${OrderIDListCount}=    get length    ${OrderIDList}
    ${RowCounter}    set variable    2
    open sap logon window    ${SAPGUIPATH}    ${SAPUSERNAME}    ${SAPPASSWORD}    ${ENTERBUTTON}    ${CONNECTION}
    FOR    ${OrderIdIterator}    IN    @{OrderIDList}
        ${OrderID}    get from list    ${OrderIDList}    ${ListIndexIterator}
        ${InvoiceStatus}    get from list    ${InvoicedStatusList}    ${ListIndexIterator}
        IF    '${InvoiceStatus}' = 'Invoiced' and '${InvoiceStatus}' != '${EMPTY}'
            SeleniumLibrary.input text    ${SearchBox}   ${OrderID}
            sleep    5s
            wait until element is visible    ${editicon}
            SeleniumLibrary.click element    ${editicon}
            sleep    5s
            wait until element is visible    ${wileyorderdetails}
            seleniumlibrary.click element    ${wileyorderdetails}
            sleep    5s
            wait until element is visible    ${wileyordersearchbox}
            seleniumlibrary.click element    ${wileyordersearchbox}
            sleep    5s
            wait until element is visible    ${wileyinvoicetab}
            SeleniumLibrary.click element    ${wileyinvoicetab}
            sleep    5s
            wait until element is visible    ${wileyinvoicelink}
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
            type    ${pathtosave}${OrderID}.pdf
            sleep    2s
            press combination    Key.ALT    Key.S
            sleep    3s
            ${current_datetime}=    Get Current Date    result_format=%Y%m%d%H%M%S
            ${pathtosave} =    set variable    ${pathtosave}${current_datetime}
            create directory    ${pathtosave}
            ${pathtosave} =    catenate  SEPARATOR=   ${pathtosave}    \\
            type    ${pathtosave}${OrderID}.pdf
            sleep    2s
            press combination    Key.ALT    Key.S
            sleep    3s
            ${content}=    convert pdf to txt    ${pathtosave}${OrderID}.pdf
            create file    ${pathtosave}${OrderID}.txt    content=${content}
            ${MailFlag}=    run keyword and return status    should contain    ${content}    someotctesting2@wileyqe.com
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
            Write Output Excel    ${SheetName}    WileyOrderNumber    ${RowCounter}    ${wileyorderId}
            Write Output Excel    ${SheetName}    BillNumber    ${RowCounter}    ${billnumber}
            Write Output Excel    ${SheetName}    SAPOrderID    ${RowCounter}    ${saporderId}
            Write Output Excel    ${SheetName}    PaymentStatus    ${RowCounter}    ${paymentstatus}
            validate the content and update the excel    ${MailFlag}    True    ${sheetname}    MailId    ${RowCounter}
        END
        ${RowCounter}=    evaluate    ${RowCounter} + int(${1})
        save excel document    ${InputExcelPath}
    END
    close all excel documents


*** Keywords ***

Read All Input Values From OutputExcel
    [Arguments]    ${InputExcel}    ${InputSheet}
    ${ExcelDictionary}    ReadAllValuesFromExcel    ${InputExcel}    ${InputSheet}
    ${MailIdList}    get from dictionary    ${ExcelDictionary}    MailId
    ${OrderIDList}    get from dictionary    ${ExcelDictionary}    OrderId
    ${InvoicedStatusList}    get from dictionary    ${ExcelDictionary}    InvoicedStatus
    set suite variable    ${InvoicedStatusList}    ${InvoicedStatusList}
    set suite variable   ${MailIdList}   ${MailIdList}
    set suite variable    ${OrderIDList}    ${OrderIDList}
    open excel document    ${inputExcelPath}    docID

Read All Input Values From DataExcel
    [Arguments]    ${InputExcel}    ${InputSheet}
    ${ExcelDictionary}    ReadAllValuesFromExcel    ${InputExcel}    ${InputSheet}
    ${FlagList}    get from dictionary    ${ExcelDictionary}    ExecutionFlag
    ${OrderTypeList}    get from dictionary    ${ExcelDictionary}    OrderType
    ${NumofOrderList}    get from dictionary    ${ExcelDictionary}    NumberOrderToCreate
    ${JsonPathList}     get from dictionary    ${ExcelDictionary}    JsonPath
    ${APCList}    get from dictionary    ${ExcelDictionary}    APC
    ${AppliedDiscountList}    get from dictionary    ${ExcelDictionary}    AppliedDiscount
    ${CurrencyList}    get from dictionary    ${ExcelDictionary}    Currency
    ${TAXList}    get from dictionary    ${ExcelDictionary}     Tax
    ${CountryCodeList}    get from dictionary    ${ExcelDictionary}    CountryCode
    ${DiscountTypeList}    get from dictionary    ${ExcelDictionary}    DiscountType
    ${DiscountCodeList}    get from dictionary    ${ExcelDictionary}    DiscountCode
    ${AmountList}    get from dictionary    ${ExcelDictionary}    Amount
    ${CreditCardTypeList}    get from dictionary    ${ExcelDictionary}    CreditCardType
    ${CreditCardTypeIDList}    get from dictionary    ${ExcelDictionary}    CreditCardTypeID
    ${VatNumberList}    get from dictionary    ${ExcelDictionary}    VatNumber
    set suite variable   ${FlagList}   ${FlagList}
    set suite variable    ${OrderTypeList}    ${OrderTypeList}
    set suite variable    ${NumofOrderList}    ${NumofOrderList}
    set suite variable    ${JsonPathList}    ${JsonPathList}
    set suite variable    ${APCList}    ${APCList}
    set suite variable    ${AppliedDiscountList}    ${AppliedDiscountList}
    set suite variable    ${CurrencyList}    ${CurrencyList}
    set suite variable    ${TAXList}    ${TAXList}
    set suite variable    ${CountryCodeList}    ${CountryCodeList}
    set suite variable    ${DiscountTypeList}    ${DiscountTypeList}
    set suite variable    ${DiscountCodeList}    ${DiscountCodeList}
    set suite variable    ${AmountList}    ${AmountList}
    set suite variable    ${CreditCardTypeList}    ${CreditCardTypeList}
    set suite variable    ${CreditCardTypeIDList}    ${CreditCardTypeIDList}
    set suite variable    ${VatNumberList}    ${VatNumberList}
#    open excel document    ${inputExcelPath}    docID


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

Get the JSON Path
    [Arguments]    ${OrderType}
    IF    '${OrderType}' == 'CC'
        ${JsonPath}=   set variable    ${json_file_path}
    END
    IF    '${OrderType}' == 'Unpaid'
        ${JsonPath}=     set variable    ${json_file_path}
    END
    IF    '${OrderType}' == 'Paid'
        ${JsonPath}=     set variable    ${json_file_path}
    END
    set suite variable    ${JsonPath}    ${JsonPath}
    [Return]    ${JsonPath}

GetColumnIndexInExcelSheet
    [Arguments]    ${sheetname}    ${columnName}
    ${getallColumnnames}=    read excel row    1    sheet_name=${sheetname}
    ${columnindex}=    get index from list   ${getallColumnnames}    ${columnName}
    ${columnindex}=    evaluate    ${columnindex} + int(${1})
    [Return]    ${columnindex}

Write and Color Excel
     [Arguments]    ${sheetname}    ${columnname}    ${excelrownumber}    ${writevalue}    ${colorCode}
    ${columnIndex}=    GetColumnIndexInExcelSheet    ${sheetname}    ${columnname}
    IF    '${columnIndex}' != '${EMPTY}' and '${columnIndex}' != 'None'
        write excel cell    ${excelrownumber}    ${columnIndex}    ${writeValue}    sheet_name=${sheetname}
        excel color cell    ${excelrownumber}    ${columnIndex}    ${colorCode}    ${sheetname}
    END


Write Output Excel
     [Arguments]    ${sheetname}    ${columnname}    ${excelrownumber}    ${writevalue}
    ${columnIndex}=    GetColumnIndexInExcelSheet    ${sheetname}    ${columnname}
    IF    '${columnIndex}' != '${EMPTY}' and '${columnIndex}' != 'None'
        write excel cell    ${excelrownumber}    ${columnIndex}    ${writeValue}    sheet_name=${sheetname}
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


Launch and Login DBS
    [Arguments]    ${URL}    ${username}    ${password}
    Open Browser    ${URL}    chrome    options=add_experimental_option("detach", True)
    Maximize Browser Window
    set selenium speed    3s
    SeleniumLibrary.input text      id=username    ${username}
    SeleniumLibrary.input password    id=password    ${password}
    SeleniumLibrary.click element    name=login


VIAX Order Status
    [Arguments]    ${OrderID}
    ${titles} =    Get Window Titles
    Log    List of Window Titles: ${titles}
    ${new_tab_title} =    Set Variable    ${titles}[0]
    ${browsercheck}=    run keyword and return status    should contain any    ${new_tab_title}    Sign
    IF    '${browsercheck}' == 'True'
        sleep    5s
        SeleniumLibrary.input text      id=username    ${username}
        SeleniumLibrary.input password    id=password    ${password}
        SeleniumLibrary.click element    name=login
    END
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

Generate the JSON file to create order
    [Arguments]    ${json_content}    ${excelrownumber}    ${InputExcelPath}    ${ListIndexIterator}    ${CustomerTypeFlag}    ${strtowrite}    ${ExistingMailIdDict}
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
    ${FirstName}=  set variable     ${UniqueOrderId}Test
    ${LastName}=  set variable     ${UniqueOrderId}Auto
    ${MailId}=  set variable     ${UniqueOrderId}Mail@Wiley.com
    ${today}=    Get Current Date
    ${FromDate}=    Convert Date    ${today}    result_format=%Y-%m-%d
    ${TAX}=    get from list    ${TAXList}    ${ListIndexIterator}
    ${Amount}=    get from list    ${AmountList}    ${ListIndexIterator}
    ${DiscountCode}=    get from list    ${DiscountCodeList}    ${ListIndexIterator}
    ${DiscountType}=    get from list    ${DiscountTypeList}    ${ListIndexIterator}
    ${Amount}=    get from list    ${AmountList}    ${ListIndexIterator}
    ${CountryCode}=    get from list    ${CountryCodeList}    ${ListIndexIterator}
    ${Currency}=    get from list    ${CurrencyList}    ${ListIndexIterator}
    ${AppliedDiscount}=    get from list    ${AppliedDiscountList}    ${ListIndexIterator}
    ${APC}=    get from list    ${APCList}    ${ListIndexIterator}
    ${CreditCardType}=    get from list    ${CreditCardTypeList}    ${ListIndexIterator}
    ${CreditCardTypeID}=    get from list    ${CreditCardTypeIDList}    ${ListIndexIterator}
    ${VatNumber}=    get from list    ${VatNumberList}    ${ListIndexIterator}
    ${TAX}=    convert to string    ${TAX}
    ${Amount}=    convert to string    ${Amount}
    ${DiscountCode}=    convert to string    ${DiscountCode}
    ${Currency}=    convert to string    ${Currency}
    ${DiscountType}=    convert to string    ${DiscountType}
    ${Amount}=    convert to string    ${Amount}
    ${CountryCode}=    convert to string    ${CountryCode}
    ${AppliedDiscount}=    convert to string    ${AppliedDiscount}
    ${APC}=    convert to string    ${APC}
    ${CreditCardType}=    convert to string    ${CreditCardType}
    ${CreditCardTypeID}=    convert to string    ${CreditCardTypeID}
    ${VatNumber}=    convert to string   ${VatNumber}
    ${json_content}=    replace string    ${json_content}    <<APC>>    ${APC}
    ${json_content}=    replace string    ${json_content}    <<TAX>>    ${TAX}
    ${json_content}=    replace string    ${json_content}    <<TOTALAMT>>    ${Amount}
    ${json_content}=    replace string    ${json_content}    <<CURRENCY>>    ${Currency}
    ${json_content}=    replace string    ${json_content}    <<APPLIEDDISCOUNT>>    ${AppliedDiscount}
    ${json_content}=    replace string    ${json_content}    <<DISCOUNTTYPE>>    ${DiscountType}
    ${json_content}=    replace string    ${json_content}    <<DISCOUNTCODE>>    ${DiscountCode}
    ${json_content}=    replace string    ${json_content}    <<COUNTRYCODE>>     ${CountryCode}
    ${json_content}=    replace string    ${json_content}    <<VATCODE>>     ${VatNumber}
    ${json_content}=    replace string    ${json_content}    <<CREDITCARDID>>     ${CreditCardTypeID}
    ${json_content}=    replace string    ${json_content}    <<CREDITCARDTYPE>>     ${CreditCardType}
    ${UniqueOrderId}=    convert to string    ${UniqueOrderId}
    ${SubmissionId}=    convert to string    ${SubmissionId}
    ${FisrtName}=    convert to string    ${FirstName}
    ${LastName}=    convert to string    ${LastName}
    ${MailId}=    convert to string    ${MailId}
    ${Id}=     convert to string   ${Id}
    ${Dhid}=    convert to string    ${Dhid}
    ${FromDate}=    convert to string    ${FromDate}
    # Replace the Values in JSON File
    ${json_content}=    replace string    ${json_content}    <<OrderId>>    ${UniqueOrderId}
    ${json_content}=    replace string    ${json_content}    <<Sub>>    ${SubmissionId}
    ${json_content}=    replace string    ${json_content}    <<FIRSTNAME>>    ${FisrtName}
    ${json_content}=    replace string    ${json_content}    <<LASTNAME>>    ${LastName}
    ${json_content}=    replace string    ${json_content}    <<MailId>>    ${MailId}
    ${json_content}=    replace string    ${json_content}    <<ID>>    ${Id}
    ${json_content}=    replace string    ${json_content}    <<DHID>>    ${Dhid}
    ${json_content}=    replace string    ${json_content}    <<DATE>>    ${FromDate}
    Write Output Excel    Inputs    NewOrder    ${excelrownumber}    ${UniqueOrderId}
    Write Output Excel    Inputs    SubmissionId    ${excelrownumber}    ${SubmissionId}
    IF    '${CustomerTypeFlag}' == 'True'
        Write Output Excel    Inputs    FirstName    ${excelrownumber}    ${FisrtName}
        Write Output Excel    Inputs    LastName    ${excelrownumber}    ${LastName}
        Write Output Excel    Inputs    MailId    ${excelrownumber}    ${MailId}
    ELSE
        ${mailid}=    get from dictionary    ${ExistingMailIdDict}    ${strtowrite}
        Write Output Excel    Inputs    FirstName    ${excelrownumber}    Refer ExistingUsers Sheet
        Write Output Excel    Inputs    LastName    ${excelrownumber}    Refer ExistingUsers Sheet
        Write Output Excel    Inputs    MailId    ${excelrownumber}    ${mailid}
    END
    Write Output Excel    Inputs    DynamicID    ${excelrownumber}    ${Id}
    Write Output Excel    Inputs    RandomDhid    ${excelrownumber}    ${Dhid}
    excellibrary.save excel document    ${InputExcelPath}

    [Return]    ${json_content}


Connect to New Connection
    [Arguments]     ${SAPUSERNAME}    ${SAPPASSWORD}    ${ENTERBUTTON}    ${CONNECTION}
    open connection    ${CONNECTION}
    sapguilibrary.input text      /app/con[0]/ses[0]/wnd[0]/usr/txtRSYST-BNAME    ${SAPUSERNAME}
    sleep    2s
    sapguilibrary.input password    /app/con[0]/ses[0]/wnd[0]/usr/pwdRSYST-BCODE    ${SAPPASSWORD}
    sapguilibrary.click element    ${ENTERBUTTON}

Get MailID for Existing users
    [Arguments]    ${inputExcelPath}    ${ExistingUsersSheet}
    open excel document    ${inputExcelPath}    ${ExistingUsersSheet}
    ${scenarioColindex}=    GetColumnIndexInExcelSheet      ${ExistingUsersSheet}    ScenarioName
    ${mailColindex}=    GetColumnIndexInExcelSheet     ${ExistingUsersSheet}    MailID
    ${scenariovalues}=    read excel column    ${scenarioColindex}    sheet_name=${ExistingUsersSheet}
    ${mailidvalues}=    read excel column    ${mailColindex}    sheet_name=${ExistingUsersSheet}
    ${rowcount}=    get length    ${scenariovalues}
    ${mailiddict}    create dictionary
    FOR    ${itrFirstRow}    IN RANGE    1    ${rowcount}
        ${currentKey}=    get from List    ${scenariovalues}    ${itrFirstRow}
        ${currentmailid}=    get from List    ${mailidvalues}    ${itrFirstRow}
        set to dictionary    ${mailiddict}     ${currentKey}    ${currentmailid}
    END
#    ${mailid}=    get from dictionary    ${mailiddict}     ${Scenarioname}
    set suite variable    ${mailiddict}    ${mailiddict}
    close all excel documents
    [Return]    ${mailiddict}

Validate the content and update the excel
    [Arguments]    ${value1}    ${value2}    ${sheetname}    ${columnname}    ${excelrownumber}
    ${columnIndex}=    GetColumnIndexInExcelSheet    ${sheetname}    ${columnname}
    IF    '${columnIndex}' != '${EMPTY}' and '${columnIndex}' != 'None'
#        write excel cell    ${excelrownumber}    ${columnIndex}    ${value1}    sheet_name=${sheetname}
        IF    '${value1}' == '${value2}'
            excel color cell    ${excelrownumber}    ${columnIndex}    00FF00    ${sheetname}
        ELSE
            excel color cell    ${excelrownumber}    ${columnIndex}    FF0000    ${sheetname}
        END
    END