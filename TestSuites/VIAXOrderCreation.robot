*** Settings ***
Resource    ../Resource/ObjectRepositories/CustomVariables.robot
Library    CustomLib.py
Library    Response.py
Suite Setup    Read All Input Values From OrderCreationCases    ${InputFilePath}    OrderCreationCases

*** Variables ***
${json_file_path}    \\UploadExcel\\JsonTemplates_New\\UnPaidNewCustomer.json
${InputFilePath}    ${execdir}\\UploadExcel\\TD_Inputs.xlsx
${file}    \\UploadExcel\\JsonTemplates_New\\
${URL}
${GraphqlURL}

*** Test Cases ***

TC_01 Trigger Invoice Order with New Customer
    [Documentation]      This case will create a VIAX Invoice Order Via API and Validate in DBS
    [Tags]    id=AU_OC_01
    ${ListIndexIterator}    set variable    0
    ${RowCounter}    set variable    2
    ${TestCaseIDCount}=   get length    ${TesctCaseNameList}
    FOR    ${ScenarioIterator}    IN RANGE    ${TestCaseIDCount}
        ${ScenarioName}=    get from list    ${TesctCaseNameList}   ${ListIndexIterator}
        IF    '${ScenarioName}' == 'Trigger Invoice Order with New Customer'
            ${EnironmentValue}=    get from list    ${ExecutionEnvironmentList}     ${ListIndexIterator}
            Get DBS Orders Link    ${EnironmentValue}
            ${JSONFileName}=    get from list    ${JSONFileNameList}    ${ListIndexIterator}
            ${today}=     get current date
            Write Output Excel    OrderCreationCases    ExecutionDate    ${RowCounter}    ${today}
            ${UniqueOrderId}=    Convert Date    ${today}    result_format=%Y%m%d%H%M%S
            ${FirstName}=  set variable     ${UniqueOrderId}Test
            ${LastName}=  set variable     ${UniqueOrderId}Auto
            ${MailId}=  set variable     ${UniqueOrderId}@Wiley.com
            Write Output Excel    OrderCreationCases    FirstName    ${RowCounter}    ${FirstName}
            Write Output Excel    OrderCreationCases    LastName    ${RowCounter}    ${LastName}
            Write Output Excel    OrderCreationCases    MailId    ${RowCounter}    ${MailId}
            ${json_content}=  Get File  ${execdir}${file}${JSONFileName}.json
            ${json_content}=    Create JSON File    ${json_content}   ${FirstName}    ${LastName}    ${MailId}
            Write Output Excel    OrderCreationCases    JSONText    ${RowCounter}    ${json_content}
            create session    order_session    ${URL}    verify=True
            ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${AuthToken}
            ${response}=     post on session    order_session    url=${GraphqlURL}    data=${json_content}     headers=${headers}
            # Getting the content value
            Log    Status Code: ${response.status_code}
            Log    Response Content: ${response.content}
            set variable    ${response.content}
            set variable    ${response.json()}
            ${response_text}=    convert to string    ${response.content}
            ${response.json()}=    convert to string    ${response.json()}
            Write Output Excel    OrderCreationCases    Response    ${RowCounter}    ${response.json()}
            Validate the content and update the excel    200    ${response.status_code}    OrderCreationCases    ResponseStatusCode    ${RowCounter}
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
                Write Output Excel    OrderCreationCases    OrderId    ${RowCounter}    ${error_code}
                Write Output Excel    OrderCreationCases    OrderStatus    ${RowCounter}    ${OrderStatus}
                ${OrderID}=    set variable    ${error_code}
                set variable    ${error_code}
                set variable    ${OrderStatus}
            ELSE
                ${errortext}=  Set Variable  ${json_dict['message']}
                ${errortext}=    convert to string    ${errortext}
                Write Output Excel    OrderCreationCases    OrderStatus    ${RowCounter}    Error-${errortext}
                set variable   ${errortext}
            END
        END
        ${ListIndexIterator}=    evaluate    ${ListIndexIterator} + int(${1})
        ${RowCounter}=    evaluate    ${RowCounter} + int(${1})
    END
    save excel document    ${InputFilePath}

TC_02 Trigger CreditCard Order with New Customer
    [Documentation]      This case will create a VIAX Invoice Order Via API and Validate in DBS
    [Tags]    id=AU_OC_02
    ${ListIndexIterator}    set variable    0
    ${RowCounter}    set variable    2
    ${TestCaseIDCount}=   get length    ${TesctCaseNameList}
    FOR    ${ScenarioIterator}    IN RANGE    ${TestCaseIDCount}
        ${ScenarioName}=    get from list    ${TesctCaseNameList}   ${ListIndexIterator}
        IF    '${ScenarioName}' == 'Trigger CreditCard Order with New Customer'
            ${EnironmentValue}=    get from list    ${ExecutionEnvironmentList}     ${ListIndexIterator}
            Get DBS Orders Link    ${EnironmentValue}
            ${JSONFileName}=    get from list    ${JSONFileNameList}    ${ListIndexIterator}
            ${today}=     get current date
            Write Output Excel    OrderCreationCases    ExecutionDate    ${RowCounter}    ${today}
            ${UniqueOrderId}=    Convert Date    ${today}    result_format=%Y%m%d%H%M%S
            ${FirstName}=  set variable     ${UniqueOrderId}Test
            ${LastName}=  set variable     ${UniqueOrderId}Auto
            ${MailId}=  set variable     ${UniqueOrderId}@Wiley.com
            Write Output Excel    OrderCreationCases    FirstName    ${RowCounter}    ${FirstName}
            Write Output Excel    OrderCreationCases    LastName    ${RowCounter}    ${LastName}
            Write Output Excel    OrderCreationCases    MailId    ${RowCounter}    ${MailId}
            ${json_content}=  Get File  ${execdir}${file}${JSONFileName}.json
            ${json_content}=    Create JSON File    ${json_content}   ${FirstName}    ${LastName}    ${MailId}
            Write Output Excel    OrderCreationCases    JSONText    ${RowCounter}    ${json_content}
            create session    order_session    ${DBSURL}    verify=True
            ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${AuthToken}
            ${response}=     post on session    order_session    url=${GraphqlURL}    data=${json_content}     headers=${headers}
            # Getting the content value
            Log    Status Code: ${response.status_code}
            Log    Response Content: ${response.content}
            set variable    ${response.content}
            set variable    ${response.json()}
            ${response_text}=    convert to string    ${response.content}
            ${response.json()}=    convert to string    ${response.json()}
            Write Output Excel    OrderCreationCases    Response    ${RowCounter}    ${response.json()}
            Validate the content and update the excel    200    ${response.status_code}    OrderCreationCases    ResponseStatusCode    ${RowCounter}
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
                Write Output Excel    OrderCreationCases    OrderId    ${RowCounter}    ${error_code}
                Write Output Excel    OrderCreationCases    OrderStatus    ${RowCounter}    ${OrderStatus}
                ${OrderID}=    set variable    ${error_code}
                set variable    ${error_code}
                set variable    ${OrderStatus}
            ELSE
                ${errortext}=  Set Variable  ${json_dict['message']}
                ${errortext}=    convert to string    ${errortext}
                Write Output Excel    OrderCreationCases    OrderStatus    ${RowCounter}    Error-${errortext}
                set variable   ${errortext}
            END
        END
        ${ListIndexIterator}=    evaluate    ${ListIndexIterator} + int(${1})
        ${RowCounter}=    evaluate    ${RowCounter} + int(${1})
    END
    save excel document    ${InputFilePath}

TC_03 Trigger Alipay Order with New Customer
    [Documentation]      This case will create a VIAX Invoice Order Via API and Validate in DBS
    [Tags]    id=AU_OC_03
    ${ListIndexIterator}    set variable    0
    ${RowCounter}    set variable    2
    ${TestCaseIDCount}=   get length    ${TesctCaseNameList}
    FOR    ${ScenarioIterator}    IN RANGE    ${TestCaseIDCount}
        ${ScenarioName}=    get from list    ${TesctCaseNameList}   ${ListIndexIterator}
        IF    '${ScenarioName}' == 'Trigger Alipay Order with New Customer'
            ${EnironmentValue}=    get from list    ${ExecutionEnvironmentList}     ${ListIndexIterator}
            Get DBS Orders Link    ${EnironmentValue}
            ${JSONFileName}=    get from list    ${JSONFileNameList}    ${ListIndexIterator}
            ${today}=     get current date
            Write Output Excel    OrderCreationCases    ExecutionDate    ${RowCounter}    ${today}
            ${UniqueOrderId}=    Convert Date    ${today}    result_format=%Y%m%d%H%M%S
            ${FirstName}=  set variable     ${UniqueOrderId}Test
            ${LastName}=  set variable     ${UniqueOrderId}Auto
            ${MailId}=  set variable     ${UniqueOrderId}@Wiley.com
            Write Output Excel    OrderCreationCases    FirstName    ${RowCounter}    ${FirstName}
            Write Output Excel    OrderCreationCases    LastName    ${RowCounter}    ${LastName}
            Write Output Excel    OrderCreationCases    MailId    ${RowCounter}    ${MailId}
            ${json_content}=  Get File  ${execdir}${file}${JSONFileName}.json
            ${json_content}=    Create JSON File    ${json_content}   ${FirstName}    ${LastName}    ${MailId}
            Write Output Excel    OrderCreationCases    JSONText    ${RowCounter}    ${json_content}
            create session    order_session    ${URL}    verify=True
            ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${AuthToken}
            ${response}=     post on session    order_session    url=${GraphqlURL}    data=${json_content}     headers=${headers}
            # Getting the content value
            Log    Status Code: ${response.status_code}
            Log    Response Content: ${response.content}
            set variable    ${response.content}
            set variable    ${response.json()}
            ${response_text}=    convert to string    ${response.content}
            ${response.json()}=    convert to string    ${response.json()}
            Write Output Excel    OrderCreationCases    Response    ${RowCounter}    ${response.json()}
            Validate the content and update the excel    200    ${response.status_code}    OrderCreationCases    ResponseStatusCode    ${RowCounter}
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
                Write Output Excel    OrderCreationCases    OrderId    ${RowCounter}    ${error_code}
                Write Output Excel    OrderCreationCases    OrderStatus    ${RowCounter}    ${OrderStatus}
                ${OrderID}=    set variable    ${error_code}
                set variable    ${error_code}
                set variable    ${OrderStatus}
            ELSE
                ${errortext}=  Set Variable  ${json_dict['message']}
                ${errortext}=    convert to string    ${errortext}
                Write Output Excel    OrderCreationCases    OrderStatus    ${RowCounter}    Error-${errortext}
                set variable   ${errortext}
            END
        END
        ${ListIndexIterator}=    evaluate    ${ListIndexIterator} + int(${1})
        ${RowCounter}=    evaluate    ${RowCounter} + int(${1})
    END
    save excel document    ${InputFilePath}

TC_04 Trigger Alipay Order with Existing Customer
    [Documentation]      This case will create a VIAX Invoice Order Via API and Validate in DBS
    [Tags]    id=AU_OC_04
    ${ListIndexIterator}    set variable    0
    ${RowCounter}    set variable    2
    ${TestCaseIDCount}=   get length    ${TesctCaseNameList}
    FOR    ${ScenarioIterator}    IN RANGE    ${TestCaseIDCount}
        ${ScenarioName}=    get from list    ${TesctCaseNameList}   ${ListIndexIterator}
        IF    '${ScenarioName}' == 'Trigger Alipay Order with Existing Customer'
            ${EnironmentValue}=    get from list    ${ExecutionEnvironmentList}     ${ListIndexIterator}
            Get DBS Orders Link    ${EnironmentValue}
            ${JSONFileName}=    get from list    ${JSONFileNameList}    ${ListIndexIterator}
            ${today}=     get current date
            Write Output Excel    OrderCreationCases    ExecutionDate    ${RowCounter}    ${today}
            ${UniqueOrderId}=    Convert Date    ${today}    result_format=%Y%m%d%H%M%S
            ${FirstName}=  get from list    ${FirstNameList}     ${ListIndexIterator}
            ${LastName}=  get from list    ${LastNameList}     ${ListIndexIterator}
            ${MailId}=  get from list    ${MailList}     ${ListIndexIterator}
            ${json_content}=  Get File  ${execdir}${file}${JSONFileName}.json
            ${json_content}=    Create JSON File    ${json_content}   ${FirstName}    ${LastName}    ${MailId}
            Write Output Excel    OrderCreationCases    JSONText    ${RowCounter}    ${json_content}
            create session    order_session    ${URL}    verify=True
            ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${AuthToken}
            ${response}=     post on session    order_session    url=${GraphqlURL}    data=${json_content}     headers=${headers}
            # Getting the content value
            Log    Status Code: ${response.status_code}
            Log    Response Content: ${response.content}
            set variable    ${response.content}
            set variable    ${response.json()}
            ${response_text}=    convert to string    ${response.content}
            ${response.json()}=    convert to string    ${response.json()}
            Write Output Excel    OrderCreationCases    Response    ${RowCounter}    ${response.json()}
            Validate the content and update the excel    200    ${response.status_code}    OrderCreationCases    ResponseStatusCode    ${RowCounter}
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
                Write Output Excel    OrderCreationCases    OrderId    ${RowCounter}    ${error_code}
                Write Output Excel    OrderCreationCases    OrderStatus    ${RowCounter}    ${OrderStatus}
                ${OrderID}=    set variable    ${error_code}
                set variable    ${error_code}
                set variable    ${OrderStatus}
            ELSE
                ${errortext}=  Set Variable  ${json_dict['message']}
                ${errortext}=    convert to string    ${errortext}
                Write Output Excel    OrderCreationCases    OrderStatus    ${RowCounter}    Error-${errortext}
                set variable   ${errortext}
            END
        END
        ${ListIndexIterator}=    evaluate    ${ListIndexIterator} + int(${1})
        ${RowCounter}=    evaluate    ${RowCounter} + int(${1})
    END
    save excel document    ${InputFilePath}

TC_05 Trigger CreditCard Order with Existing Customer
    [Documentation]      This case will create a VIAX Invoice Order Via API and Validate in DBS
    [Tags]    id=AU_OC_05
    ${ListIndexIterator}    set variable    0
    ${RowCounter}    set variable    2
    ${TestCaseIDCount}=   get length    ${TesctCaseNameList}
    FOR    ${ScenarioIterator}    IN RANGE    ${TestCaseIDCount}
        ${ScenarioName}=    get from list    ${TesctCaseNameList}   ${ListIndexIterator}
        IF    '${ScenarioName}' == 'Trigger CreditCard Order with Existing Customer'
            ${EnironmentValue}=    get from list    ${ExecutionEnvironmentList}     ${ListIndexIterator}
            Get DBS Orders Link    ${EnironmentValue}
            ${JSONFileName}=    get from list    ${JSONFileNameList}    ${ListIndexIterator}
            ${today}=     get current date
            Write Output Excel    OrderCreationCases    ExecutionDate    ${RowCounter}    ${today}
            ${UniqueOrderId}=    Convert Date    ${today}    result_format=%Y%m%d%H%M%S
            ${FirstName}=  get from list    ${FirstNameList}     ${ListIndexIterator}
            ${LastName}=  get from list    ${LastNameList}     ${ListIndexIterator}
            ${MailId}=  get from list    ${MailList}     ${ListIndexIterator}
            ${json_content}=  Get File  ${execdir}${file}${JSONFileName}.json
            ${json_content}=    Create JSON File    ${json_content}   ${FirstName}    ${LastName}    ${MailId}
            Write Output Excel    OrderCreationCases    JSONText    ${RowCounter}    ${json_content}
            create session    order_session    ${URL}    verify=True
            ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${AuthToken}
            ${response}=     post on session    order_session    url=${GraphqlURL}    data=${json_content}     headers=${headers}
            # Getting the content value
            Log    Status Code: ${response.status_code}
            Log    Response Content: ${response.content}
            set variable    ${response.content}
            set variable    ${response.json()}
            ${response_text}=    convert to string    ${response.content}
            ${response.json()}=    convert to string    ${response.json()}
            Write Output Excel    OrderCreationCases    Response    ${RowCounter}    ${response.json()}
            Validate the content and update the excel    200    ${response.status_code}    OrderCreationCases    ResponseStatusCode    ${RowCounter}
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
                Write Output Excel    OrderCreationCases    OrderId    ${RowCounter}    ${error_code}
                Write Output Excel    OrderCreationCases    OrderStatus    ${RowCounter}    ${OrderStatus}
                ${OrderID}=    set variable    ${error_code}
                set variable    ${error_code}
                set variable    ${OrderStatus}
            ELSE
                ${errortext}=  Set Variable  ${json_dict['message']}
                ${errortext}=    convert to string    ${errortext}
                Write Output Excel    OrderCreationCases    OrderStatus    ${RowCounter}    Error-${errortext}
                set variable   ${errortext}
            END
        END
        ${ListIndexIterator}=    evaluate    ${ListIndexIterator} + int(${1})
        ${RowCounter}=    evaluate    ${RowCounter} + int(${1})
    END
    save excel document    ${InputFilePath}

TC_06 Trigger Invoice Order with Existing Customer
    [Documentation]      This case will create a VIAX Invoice Order Via API and Validate in DBS
    [Tags]    id=AU_OC_06
    ${ListIndexIterator}    set variable    0
    ${RowCounter}    set variable    2
    ${TestCaseIDCount}=   get length    ${TesctCaseNameList}
    FOR    ${ScenarioIterator}    IN RANGE    ${TestCaseIDCount}
        ${ScenarioName}=    get from list    ${TesctCaseNameList}   ${ListIndexIterator}
        IF    '${ScenarioName}' == 'Trigger Invoice Order with Existing Customer'
            ${EnironmentValue}=    get from list    ${ExecutionEnvironmentList}     ${ListIndexIterator}
            Get DBS Orders Link    ${EnironmentValue}
            ${JSONFileName}=    get from list    ${JSONFileNameList}    ${ListIndexIterator}
            ${today}=     get current date
            Write Output Excel    OrderCreationCases    ExecutionDate    ${RowCounter}    ${today}
            ${UniqueOrderId}=    Convert Date    ${today}    result_format=%Y%m%d%H%M%S
            ${FirstName}=  get from list    ${FirstNameList}     ${ListIndexIterator}
            ${LastName}=  get from list    ${LastNameList}     ${ListIndexIterator}
            ${MailId}=  get from list    ${MailList}     ${ListIndexIterator}
            ${json_content}=  Get File  ${execdir}${file}${JSONFileName}.json
            ${json_content}=    Create JSON File    ${json_content}   ${FirstName}    ${LastName}    ${MailId}
            Write Output Excel    OrderCreationCases    JSONText    ${RowCounter}    ${json_content}
            create session    order_session    ${URL}    verify=True
            ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${AuthToken}
            ${response}=     post on session    order_session    url=${GraphqlURL}    data=${json_content}     headers=${headers}
            # Getting the content value
            Log    Status Code: ${response.status_code}
            Log    Response Content: ${response.content}
            set variable    ${response.content}
            set variable    ${response.json()}
            ${response_text}=    convert to string    ${response.content}
            ${response.json()}=    convert to string    ${response.json()}
            Write Output Excel    OrderCreationCases    Response    ${RowCounter}    ${response.json()}
            Validate the content and update the excel    200    ${response.status_code}    OrderCreationCases    ResponseStatusCode    ${RowCounter}
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
                Write Output Excel    OrderCreationCases    OrderId    ${RowCounter}    ${error_code}
                Write Output Excel    OrderCreationCases    OrderStatus    ${RowCounter}    ${OrderStatus}
                ${OrderID}=    set variable    ${error_code}
                set variable    ${error_code}
                set variable    ${OrderStatus}
            ELSE
                ${errortext}=  Set Variable  ${json_dict['message']}
                ${errortext}=    convert to string    ${errortext}
                Write Output Excel    OrderCreationCases    OrderStatus    ${RowCounter}    Error-${errortext}
                set variable   ${errortext}
            END
        END
        ${ListIndexIterator}=    evaluate    ${ListIndexIterator} + int(${1})
        ${RowCounter}=    evaluate    ${RowCounter} + int(${1})
    END
    save excel document    ${InputFilePath}

TC_07 Trigger Proforma Order with New Customer
    [Documentation]      This case will create a VIAX Invoice Order Via API and Validate in DBS
    [Tags]    id=AU_OC_07
    ${ListIndexIterator}    set variable    0
    ${RowCounter}    set variable    2
    ${TestCaseIDCount}=   get length    ${TesctCaseNameList}
    FOR    ${ScenarioIterator}    IN RANGE    ${TestCaseIDCount}
        ${ScenarioName}=    get from list    ${TesctCaseNameList}   ${ListIndexIterator}
        IF    '${ScenarioName}' == 'Trigger Proforma Order with New Customer'
            ${EnironmentValue}=    get from list    ${ExecutionEnvironmentList}     ${ListIndexIterator}
            Get DBS Orders Link    ${EnironmentValue}
            ${JSONFileName}=    get from list    ${JSONFileNameList}    ${ListIndexIterator}
            ${today}=     get current date
            Write Output Excel    OrderCreationCases    ExecutionDate    ${RowCounter}    ${today}
            ${UniqueOrderId}=    Convert Date    ${today}    result_format=%Y%m%d%H%M%S
            ${FirstName}=  set variable     ${UniqueOrderId}Test
            ${LastName}=  set variable     ${UniqueOrderId}Auto
            ${MailId}=  set variable     ${UniqueOrderId}@Wiley.com
            Write Output Excel    OrderCreationCases    FirstName    ${RowCounter}    ${FirstName}
            Write Output Excel    OrderCreationCases    LastName    ${RowCounter}    ${LastName}
            Write Output Excel    OrderCreationCases    MailId    ${RowCounter}    ${MailId}
            ${json_content}=  Get File  ${execdir}${file}${JSONFileName}.json
            ${json_content}=    Create JSON File    ${json_content}   ${FirstName}    ${LastName}    ${MailId}
            Write Output Excel    OrderCreationCases    JSONText    ${RowCounter}    ${json_content}
            create session    order_session    ${URL}    verify=True
            ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${AuthToken}
            ${response}=     post on session    order_session    url=${GraphqlURL}    data=${json_content}     headers=${headers}
            # Getting the content value
            Log    Status Code: ${response.status_code}
            Log    Response Content: ${response.content}
            set variable    ${response.content}
            set variable    ${response.json()}
            ${response_text}=    convert to string    ${response.content}
            ${response.json()}=    convert to string    ${response.json()}
            Write Output Excel    OrderCreationCases    Response    ${RowCounter}    ${response.json()}
            Validate the content and update the excel    200    ${response.status_code}    OrderCreationCases    ResponseStatusCode    ${RowCounter}
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
                Write Output Excel    OrderCreationCases    OrderId    ${RowCounter}    ${error_code}
                Write Output Excel    OrderCreationCases    OrderStatus    ${RowCounter}    ${OrderStatus}
                ${OrderID}=    set variable    ${error_code}
                set variable    ${error_code}
                set variable    ${OrderStatus}
            ELSE
                ${errortext}=  Set Variable  ${json_dict['message']}
                ${errortext}=    convert to string    ${errortext}
                Write Output Excel    OrderCreationCases    OrderStatus    ${RowCounter}    Error-${errortext}
                set variable   ${errortext}
            END
        END
        ${ListIndexIterator}=    evaluate    ${ListIndexIterator} + int(${1})
        ${RowCounter}=    evaluate    ${RowCounter} + int(${1})
    END
    save excel document    ${InputFilePath}

TC_08 Trigger Proforma Order with Existing Customer
    [Documentation]      This case will create a VIAX Invoice Order Via API and Validate in DBS
    [Tags]    id=AU_OC_08
    ${ListIndexIterator}    set variable    0
    ${RowCounter}    set variable    2
    ${TestCaseIDCount}=   get length    ${TesctCaseNameList}
    FOR    ${ScenarioIterator}    IN RANGE    ${TestCaseIDCount}
        ${ScenarioName}=    get from list    ${TesctCaseNameList}   ${ListIndexIterator}
        IF    '${ScenarioName}' == 'Trigger Proforma Order with Existing Customer'
            ${EnironmentValue}=    get from list    ${ExecutionEnvironmentList}     ${ListIndexIterator}
            Get DBS Orders Link    ${EnironmentValue}
            ${JSONFileName}=    get from list    ${JSONFileNameList}    ${ListIndexIterator}
            ${today}=     get current date
            Write Output Excel    OrderCreationCases    ExecutionDate    ${RowCounter}    ${today}
            ${UniqueOrderId}=    Convert Date    ${today}    result_format=%Y%m%d%H%M%S
            ${FirstName}=  get from list    ${FirstNameList}     ${ListIndexIterator}
            ${LastName}=  get from list    ${LastNameList}     ${ListIndexIterator}
            ${MailId}=  get from list    ${MailList}     ${ListIndexIterator}
            ${json_content}=  Get File  ${execdir}${file}${JSONFileName}.json
            ${json_content}=    Create JSON File    ${json_content}   ${FirstName}    ${LastName}    ${MailId}
            Write Output Excel    OrderCreationCases    JSONText    ${RowCounter}    ${json_content}
            create session    order_session    ${URL}    verify=True
            ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${AuthToken}
            ${response}=     post on session    order_session    url=${GraphqlURL}    data=${json_content}     headers=${headers}
            # Getting the content value
            Log    Status Code: ${response.status_code}
            Log    Response Content: ${response.content}
            set variable    ${response.content}
            set variable    ${response.json()}
            ${response_text}=    convert to string    ${response.content}
            ${response.json()}=    convert to string    ${response.json()}
            Write Output Excel    OrderCreationCases    Response    ${RowCounter}    ${response.json()}
            Validate the content and update the excel    200    ${response.status_code}    OrderCreationCases    ResponseStatusCode    ${RowCounter}
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
                Write Output Excel    OrderCreationCases    OrderId    ${RowCounter}    ${error_code}
                Write Output Excel    OrderCreationCases    OrderStatus    ${RowCounter}    ${OrderStatus}
                ${OrderID}=    set variable    ${error_code}
                set variable    ${error_code}
                set variable    ${OrderStatus}
            ELSE
                ${errortext}=  Set Variable  ${json_dict['message']}
                ${errortext}=    convert to string    ${errortext}
                Write Output Excel    OrderCreationCases    OrderStatus    ${RowCounter}    Error-${errortext}
                set variable   ${errortext}
            END
        END
        ${ListIndexIterator}=    evaluate    ${ListIndexIterator} + int(${1})
        ${RowCounter}=    evaluate    ${RowCounter} + int(${1})
    END
    save excel document    ${InputFilePath}


*** Keywords ***

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
    RETURN    ${json_content}



Read All Input Values From OrderCreationCases
    [Arguments]    ${InputExcel}    ${InputSheet}
    ${ExcelDictionary}    ReadAllValuesFromExcel    ${InputExcel}    ${InputSheet}
    ${TesctCaseNameList}    get from dictionary    ${ExcelDictionary}    TesctCaseName
    ${ExecutionEnvironmentList}    get from dictionary    ${ExcelDictionary}    ExecutionEnvironment
    ${CountryList}   get from dictionary    ${ExcelDictionary}    Country
    ${JSONFileNameList}    get from dictionary     ${ExcelDictionary}    JSONFileName
    ${FirstNameList}    get from dictionary     ${ExcelDictionary}    FirstName
    ${LastNameList}    get from dictionary     ${ExcelDictionary}    LastName
    ${MailList}    get from dictionary     ${ExcelDictionary}    MailId
    set suite variable   ${TesctCaseNameList}   ${TesctCaseNameList}
    set suite variable    ${ExecutionEnvironmentList}    ${ExecutionEnvironmentList}
    set suite variable    ${CountryList}    ${CountryList}
    set suite variable    ${JSONFileNameList}    ${JSONFileNameList}
    set suite variable    ${FirstNameList}    ${FirstNameList}
    set suite variable    ${LastNameList}    ${LastNameList}
    set suite variable    ${MailList}    ${MailList}
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






Get DBS Orders Link
    [Arguments]    ${value}
    Run Keyword If    '${value}' == 'QA2'    set suite variable    ${DBSURL}     https://wileyas.qa2.viax.io/orders
    Run Keyword If    '${value}' == 'QA2'    set suite variable    ${GraphqlURL}      https://api.wileyas.qa2.viax.io/graphql
    Run Keyword If    '${value}' == 'STAGE'    set suite variable     ${GraphqlURL}    https://api.wileyas.stage.viax.io/graphql
    Run Keyword If    '${value}' == 'STAGE'    set suite variable     ${DBSURL}    https://wileyas.stage.viax.io/price-proposals
    ...    ELSE    Log    Default Case