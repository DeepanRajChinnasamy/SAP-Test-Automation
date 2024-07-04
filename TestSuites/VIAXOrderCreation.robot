*** Settings ***
Resource    ../Resource/ObjectRepositories/CustomVariables.robot
Suite Setup    Read All Input Values From OrderCreationCases    ${InputFilePath}    OrderCreationCases

*** Variables ***
${json_file_path}    \\UploadExcel\\JsonTemplates_New\\UnPaidNewCustomer.json
${InputFilePath}    ${execdir}\\UploadExcel\\TD_Inputs.xlsx
${URL}
${GraphqlURL}


*** Test Cases ***

TC_01 Trigger Invoice Order with New Customer IS
    [Documentation]      This case will create a VIAX Invoice Order Via API and Validate in DBS
    [Tags]    AU_OC_01
    ${ListIndexIterator}    set variable    0
    ${RowCounter}    set variable    2
    ${TestCaseIDCount}=   get length    ${TesctCaseNameList}
    FOR    ${ScenarioIterator}    IN RANGE    ${TestCaseIDCount}
        ${ScenarioName}=    get from list    ${TesctCaseNameList}   ${ListIndexIterator}
        IF    '${ScenarioName}' == 'Trigger Invoice Order with New Customer IS'
            ${EnironmentValue}=    get from list    ${ExecutionEnvironmentList}     ${ListIndexIterator}
            Get Environmet   ${EnironmentValue}
            ${today}=     get current date
            ${UniqueOrderId}=    Convert Date    ${today}    result_format=%Y%m%d%H%M%S
            ${FirstName}=  set variable     ${UniqueOrderId}Test
            ${LastName}=  set variable     ${UniqueOrderId}Auto
            ${MailId}=  set variable     ${UniqueOrderId}@Wiley.com
            ${json_content}=  Get File  ${execdir}${json_file_path}
            ${json_content}=    Create JSON File    ${json_content}   ${FirstName}    ${LastName}    ${MailId}
            create session    order_session    ${URL}    verify=True
            ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${Token1}
            ${response}=     post on session    order_session    url=${GraphqlURL}    data=${json_content}     headers=${headers}
            # Getting the content value
            Log    Status Code: ${response.status_code}
            Log    Response Content: ${response.content}
            set variable    ${response.content}
            set variable    ${response.json()}
            ${response_text}=    convert to string    ${response.content}
            ${response.json()}=    convert to string    ${response.json()}
            ${JsonResp}=  Evaluate  ${response.text}
            # Fetch the values from the result Json File
            @{list}=    get value from json    ${JsonResp}    $.data.testFunction.data
            set variable    ${JsonResp}
            log to console    ${list}[0]
            ${check}=    run keyword and return status    should contain    ${list}[0]    Created
            ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
            ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
        END
        ${ListIndexIterator}=    evaluate    ${ListIndexIterator} + int(${1})
        ${RowCounter}=    evaluate    ${RowCounter} + int(${1})
    END





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
    set suite variable   ${TesctCaseNameList}   ${TesctCaseNameList}
    set suite variable    ${ExecutionEnvironmentList}    ${ExecutionEnvironmentList}
    set suite variable    ${CountryList}    ${CountryList}


Get Environmet
    [Arguments]    ${value}
    Run Keyword If    '${value}' == 'QA2'    set suite variable    ${URL}     https://wileyas.qa2.viax.io/orders
    Run Keyword If    '${value}' == 'QA2'    set suite variable    ${GraphqlURL}      https://api.wileyas.qa2.viax.io/graphql
    Run Keyword If    '${value}' == 'QA'    set suite variable     ${GraphqlURL}    https://api.wileyas.qa.viax.io/graphql
    Run Keyword If    '${value}' == 'QA'    set suite variable     ${URL}    https://wileyas.qa.viax.io/orders
    ...    ELSE    Log    Default Case