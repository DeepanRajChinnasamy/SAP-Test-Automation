*** Settings ***
Resource    ../Resource/ObjectRepositories/CustomVariables.robot
Library     ../Resource/ObjectRepositories/CustomLib.py
Library     ../Resource/ObjectRepositories/Response.py
Suite Setup     Open Excel and DBS    ${PPInputExcelPath}    ${PPURL}    ${username}    ${password}
Suite Teardown   Close Excel and Browser
#Test Setup    ReLaunch DBS    ${PPURL}    ${username}    ${password}


*** Variables ***
${file}    \\UploadExcel\\JsonTemplates\\
${SubId}    24ef<<RandomNum>>-<<Randomt3digit>>b-4808-9127-af8e42410<<RandonDynId>>
${PPURL}
${QA2_Graphql}    https://api.wileyas.stage.viax.io/graphql
${PPInputExcelPath}    ${execdir}\\UploadExcel\\TD_Inputs.xlsx
${Screenshotfolder}    ${execdir}\\\Screenshots\\

*** Test Cases ***

Create PP with Society discount
    [Tags]    id=AP_PP_01
#    set screenshot folder
    log to console    ${PPInputExcelPath}
    ${ListIndexIterator}    set variable    0
    ${DataIndexIterator}    set variable    0
    ${JournalIDCount}=    get length    ${JournalIDList}
    ${RowCounter}    set variable    2
    FOR    ${ScenarioIterator}    IN RANGE    ${JournalIDCount}
        ${ExecutionFlag}=    get from list    ${ExecutionFlagList}    ${ListIndexIterator}
        ${ScenarioName}=    get from list    ${ScenarioList}   ${ListIndexIterator}
        IF    '${ScenarioName}' == 'Create PP with Society discount'
            ${JSONFileName}=    get from list    ${JSONFileNameList}    ${ListIndexIterator}
            ${JournalID}=    get from list    ${JournalIDList}    ${ListIndexIterator}
            ${Environment}=    get from list    ${EnvironmentList}    ${ListIndexIterator}
            ${discountType1}=  get from list   ${DiscountType1List}   ${ListIndexIterator}
#            ${discountType2}=  get from list   ${DiscountType2List}   ${ListIndexIterator}
            ${discountcondition1}=  get from list    ${DiscountCondition1List}   ${ListIndexIterator}
#            ${discountcondition2}=  get from list    ${DiscountCondition2List}    ${ListIndexIterator}
            ${discountpercentage1}=     get from list   ${DiscountPercentage1List}   ${ListIndexIterator}
#            ${discountpercentage2}=     get from list       ${DiscountPercentage2List}  ${ListIndexIterator}
            ${appliedyes1}=    get from list   ${AppliedYes1List}   ${ListIndexIterator}
#            ${appliedyes2}=  get from list  ${AppliedYes2List}      ${ListIndexIterator}
            ${json_content}=  Get File  ${execdir}${file}${JSONFileName}.json
            ${json_content}=    Generate the JSON file PP    ${json_content}    ${JournalID}
            Write Output Excel    PriceProposal    JSONText    ${RowCounter}    ${json_content}
            Switch Case    ${Environment}
            create session    order_session    ${PPURL}    verify=True
            ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${AuthToken}
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
            log to console    @{list}
            ${NumberofList}=    get length    ${list}
            set variable    ${JsonResp}
            ${check}=    run keyword and return status    should contain    ${list}[0]    SUCCESS
            ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
            IF    '${check}' == '${True}'
                ${error_code}=  Set Variable  ${json_dict['message']}
                ${OrderID}=  Set Variable  ${json_dict['viaxPriceProposalId']}
#                ${SubmissionID}=     set variable    ${json_dict['priceProposal']['wAsSubmissionId']}
                log to console   ${OrderID}
                ${error_code}=    convert to string    ${error_code}
#                ${SubmissionID}=    convert to string     ${SubmissionID}
                ${OrderStatus}=    convert to string    ${OrderID}
                Write Output Excel    PriceProposal    OrderStatus    ${RowCounter}    ${error_code}
                Write Output Excel    PriceProposal    OrderStatus    ${RowCounter}    ${error_code}
                Write Output Excel    PriceProposal    OrderID    ${RowCounter}    ${OrderID}
#                ${errormessage}=    set variable    ${json_dict['priceProposal']['bpStatus']['code']}
                ${errormessage}=    set variable    ${json_dict['priceProposal']['bpStatus']['code']}
                ${errormessage}=    convert to string    ${errormessage}
                write output excel    PriceProposal    PriceProposalStatus    ${RowCounter}    ${errormessage}
                should contain    ${errormessage}    PriceDetermined
                IF    '${errormessage}' == 'PriceDetermined' or '${errormessage}' == 'ManualOverrideRequired'
                    write and color excel    PriceProposal    PriceProposalStatus    ${RowCounter}    ${errormessage}    00FF00
                    save excel document    ${PPInputExcelPath}
                ELSE
                    write and color excel    PriceProposal    PriceProposalStatus    ${RowCounter}    ${errormessage}    FF0000
                    save excel document    ${PPInputExcelPath}
                END
            ELSE
                ${error_code}=  Set Variable  ${json_dict['errors']}
                ${error_code}=    convert to string    ${error_code}
                write and color excel    PriceProposal    OrderStatus    ${RowCounter}    Error in Response    FF0000
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

Create PP with Promotional discount
    [Tags]    id=AP_PP_02
    ${ListIndexIterator}    set variable    0
    ${DataIndexIterator}    set variable    0
    ${JournalIDCount}=    get length    ${JournalIDList}
    ${RowCounter}    set variable    2
#    open sap logon window    ${SAPGUIPATH}    ${SAPUSERNAME}    ${SAPPASSWORD}    ${ENTERBUTTON}    ${CONNECTION}    ${continuebutton}
#    Launch and Login DBS    ${QA2_Viax}    ${username}    ${password}
    FOR    ${ScenarioIterator}    IN RANGE    ${JournalIDCount}
        ${ExecutionFlag}=    get from list    ${ExecutionFlagList}    ${ListIndexIterator}
        ${ScenarioName}=    get from list    ${ScenarioList}   ${ListIndexIterator}
        IF    '${ScenarioName}' == 'Create PP with Promotional discount'
            ${JSONFileName}=    get from list    ${JSONFileNameList}    ${ListIndexIterator}
            ${JournalID}=    get from list   ${JournalIDList}    ${ListIndexIterator}
            ${Environment}=    get from list    ${EnvironmentList}    ${ListIndexIterator}
            ${discountType1}=  get from list   ${DiscountType1List}   ${ListIndexIterator}
            ${discountType2}=  get from list   ${DiscountType2List}   ${ListIndexIterator}
            ${discountcondition1}=  get from list    ${DiscountCondition1List}   ${ListIndexIterator}
#            ${discountcondition2}=  get from list    ${DiscountCondition2List}    ${ListIndexIterator}
            ${discountpercentage1}=     get from list   ${DiscountPercentage1List}   ${ListIndexIterator}
#            ${discountpercentage2}=     get from list       ${DiscountPercentage2List}  ${ListIndexIterator}
            ${appliedyes1}=    get from list   ${AppliedYes1List}   ${ListIndexIterator}
#            ${appliedyes2}=  get from list  ${AppliedYes2List}      ${ListIndexIterator}
            ${json_content}=  Get File  ${execdir}${file}${JSONFileName}.json
            ${json_content}=    Generate the JSON file PP    ${json_content}    ${JournalID}
            Write Output Excel    PriceProposal    JSONText    ${RowCounter}    ${json_content}
            Switch Case    ${Environment}
            create session    order_session    ${PPURL}    verify=True
            ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${AuthToken}
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
            ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
            ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
            IF    '${check}' == '${True}'
#                ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
#                ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
                ${error_code}=  Set Variable  ${json_dict['message']}
                ${OrderID}=  Set Variable  ${json_dict['viaxPriceProposalId']}
                ${error_code}=    convert to string    ${error_code}
                ${OrderStatus}=    convert to string    ${OrderID}.
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
                should contain any   ${errormessage}    PriceDetermined    ManualOverrideRequired
            ELSE
                ${error_code}=  Set Variable  ${json_dict['errors']}
                ${error_code}=    convert to string    ${error_code}
                write and color excel    PriceProposal    OrderStatus    ${RowCounter}    Error in Response    FF0000
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


Create PP with Institutional discount
    [Tags]    id=AP_PP_03
    ${ListIndexIterator}    set variable    0
    ${DataIndexIterator}    set variable    0
    ${JournalIDCount}=    get length    ${JournalIDList}
    ${RowCounter}    set variable    2
#    open sap logon window    ${SAPGUIPATH}    ${SAPUSERNAME}    ${SAPPASSWORD}    ${ENTERBUTTON}    ${CONNECTION}    ${continuebutton}
#    Launch and Login DBS    ${QA2_Viax}    ${username}    ${password}
    FOR    ${ScenarioIterator}    IN RANGE    ${JournalIDCount}
        ${ExecutionFlag}=    get from list    ${ExecutionFlagList}    ${ListIndexIterator}
        ${ScenarioName}=    get from list    ${ScenarioList}   ${ListIndexIterator}
        IF    '${ScenarioName}' == 'Create PP with Institutional discount'
            ${JSONFileName}=    get from list    ${JSONFileNameList}    ${ListIndexIterator}
            ${JournalID}=    get from list    ${JournalIDList}    ${ListIndexIterator}
            ${Environment}=    get from list    ${EnvironmentList}    ${ListIndexIterator}
            ${JSONFileName}=    get from list    ${JSONFileNameList}    ${ListIndexIterator}
            ${JournalID}=    get from list    ${JournalIDList}    ${ListIndexIterator}
            ${Environment}=    get from list    ${EnvironmentList}    ${ListIndexIterator}
            ${discountType1}=  get from list   ${DiscountType1List}   ${ListIndexIterator}
#            ${discountType2}=  get from list   ${DiscountType2List}   ${ListIndexIterator}
            ${discountcondition1}=  get from list    ${DiscountCondition1List}   ${ListIndexIterator}
#            ${discountcondition2}=  get from list    ${DiscountCondition2List}    ${ListIndexIterator}
            ${discountpercentage1}=     get from list   ${DiscountPercentage1List}   ${ListIndexIterator}
#            ${discountpercentage2}=     get from list       ${DiscountPercentage2List}  ${ListIndexIterator}
            ${appliedyes1}=    get from list   ${AppliedYes1List}   ${ListIndexIterator}
#            ${appliedyes2}=  get from list  ${AppliedYes2List}      ${ListIndexIterator}

            ${json_content}=  Get File  ${execdir}${file}${JSONFileName}.json
            ${json_content}=    Generate the JSON file PP    ${json_content}    ${JournalID}
            Write Output Excel    PriceProposal    JSONText    ${RowCounter}    ${json_content}
            Switch Case    ${Environment}
            create session    order_session    ${PPURL}    verify=True
            ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${AuthToken}
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
            ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
            ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
            IF    '${check}' == '${True}'
#                ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
#                ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
                ${error_code}=  Set Variable  ${json_dict['message']}
                ${OrderID}=  Set Variable  ${json_dict['viaxPriceProposalId']}
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
                should contain any   ${errormessage}    PriceDetermined    ManualOverrideRequired

            ELSE
                ${error_code}=  Set Variable  ${json_dict['errors']}
                ${error_code}=    convert to string    ${error_code}
                write and color excel    PriceProposal    OrderStatus    ${RowCounter}    Error in Response    FF0000
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


Create PP with Editorial discount
    [Tags]    id=AP_PP_04
    ${ListIndexIterator}    set variable    0
    ${DataIndexIterator}    set variable    0
    ${JournalIDCount}=    get length    ${JournalIDList}
    ${RowCounter}    set variable    2
#    open sap logon window    ${SAPGUIPATH}    ${SAPUSERNAME}    ${SAPPASSWORD}    ${ENTERBUTTON}    ${CONNECTION}    ${continuebutton}
#    Launch and Login DBS    ${QA2_Viax}    ${username}    ${password}
    FOR    ${ScenarioIterator}    IN RANGE    ${JournalIDCount}
        ${ExecutionFlag}=    get from list    ${ExecutionFlagList}    ${ListIndexIterator}
        ${ScenarioName}=    get from list    ${ScenarioList}   ${ListIndexIterator}
        IF    '${ScenarioName}' == 'Create PP with Editorial discount'
            ${JSONFileName}=    get from list    ${JSONFileNameList}    ${ListIndexIterator}
            ${JournalID}=    get from list    ${JournalIDList}    ${ListIndexIterator}
            ${Environment}=    get from list    ${EnvironmentList}    ${ListIndexIterator}
            ${discountType1}=  get from list   ${DiscountType1List}   ${ListIndexIterator}
            ${discountType2}=  get from list   ${DiscountType2List}   ${ListIndexIterator}
            ${discountcondition1}=  get from list    ${DiscountCondition1List}   ${ListIndexIterator}
            ${discountcondition2}=  get from list    ${DiscountCondition2List}    ${ListIndexIterator}
            ${discountpercentage1}=     get from list   ${DiscountPercentage1List}   ${ListIndexIterator}
            ${discountpercentage2}=     get from list       ${DiscountPercentage2List}  ${ListIndexIterator}
            ${appliedyes1}=    get from list   ${AppliedYes1List}   ${ListIndexIterator}
            ${appliedyes2}=  get from list  ${AppliedYes2List}      ${ListIndexIterator}

            ${json_content}=  Get File  ${execdir}${file}${JSONFileName}.json
            ${json_content}=    Generate the JSON file PP    ${json_content}    ${JournalID}
            Write Output Excel    PriceProposal    JSONText    ${RowCounter}    ${json_content}
            Switch Case    ${Environment}
            create session    order_session    ${PPURL}    verify=True
            ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${AuthToken}
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
            ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
            ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
            IF    '${check}' == '${True}'
#                ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
#                ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
                ${error_code}=  Set Variable  ${json_dict['message']}
                ${OrderID}=  Set Variable  ${json_dict['viaxPriceProposalId']}
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
                should contain any   ${errormessage}    PriceDetermined    ManualOverrideRequired


            ELSE
                ${error_code}=  Set Variable  ${json_dict['errors']}
                ${error_code}=    convert to string    ${error_code}
                write and color excel    PriceProposal    OrderStatus    ${RowCounter}    Error in Response    FF0000
                save excel document    ${PPInputExcelPath}
                should contain    ${list}[0]    SUCCESS

            END
        END

        save excel document    ${PPInputExcelPath}
        ${ListIndexIterator}=    evaluate    ${ListIndexIterator} + int(${1})
        ${RowCounter}=    evaluate    ${RowCounter} + int(${1})
    END
    save excel document    ${PPInputExcelPath}

Create PP with Referral discount
    [Tags]    id=AP_PP_05
    ${ListIndexIterator}    set variable    0
    ${DataIndexIterator}    set variable    0
    ${JournalIDCount}=    get length    ${JournalIDList}
    ${RowCounter}    set variable    2
#    open sap logon window    ${SAPGUIPATH}    ${SAPUSERNAME}    ${SAPPASSWORD}    ${ENTERBUTTON}    ${CONNECTION}    ${continuebutton}
#    Launch and Login DBS    ${QA2_Viax}    ${username}    ${password}
    FOR    ${ScenarioIterator}    IN RANGE    ${JournalIDCount}
        ${ExecutionFlag}=    get from list    ${ExecutionFlagList}    ${ListIndexIterator}
        ${ScenarioName}=    get from list    ${ScenarioList}   ${ListIndexIterator}
        IF    '${ScenarioName}' == 'Create PP with Referral discount'
            ${JSONFileName}=    get from list    ${JSONFileNameList}    ${ListIndexIterator}
            ${JournalID}=    get from list    ${JournalIDList}    ${ListIndexIterator}
            ${Environment}=    get from list    ${EnvironmentList}    ${ListIndexIterator}
            ${discountType1}=  get from list   ${DiscountType1List}   ${ListIndexIterator}
            ${discountType2}=  get from list   ${DiscountType2List}   ${ListIndexIterator}
            ${discountcondition1}=  get from list    ${DiscountCondition1List}   ${ListIndexIterator}
            ${discountcondition2}=  get from list    ${DiscountCondition2List}    ${ListIndexIterator}
            ${discountpercentage1}=     get from list   ${DiscountPercentage1List}   ${ListIndexIterator}
            ${discountpercentage2}=     get from list       ${DiscountPercentage2List}  ${ListIndexIterator}
            ${appliedyes1}=    get from list   ${AppliedYes1List}   ${ListIndexIterator}
            ${appliedyes2}=  get from list  ${AppliedYes2List}      ${ListIndexIterator}



            ${json_content}=  Get File  ${execdir}${file}${JSONFileName}.json
            ${json_content}=    Generate the JSON file PP    ${json_content}    ${JournalID}
            Write Output Excel    PriceProposal    JSONText    ${RowCounter}    ${json_content}
            Switch Case    ${Environment}
            create session    order_session    ${PPURL}    verify=True
            ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${AuthToken}
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
            ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
            ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
            IF    '${check}' == '${True}'
#                ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
#                ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
                ${error_code}=  Set Variable  ${json_dict['message']}
                ${OrderID}=  Set Variable  ${json_dict['viaxPriceProposalId']}
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
                should contain any   ${errormessage}    PriceDetermined    ManualOverrideRequired


            ELSE
                ${error_code}=  Set Variable  ${json_dict['errors']}
                ${error_code}=    convert to string    ${error_code}
                write and color excel    PriceProposal    OrderStatus    ${RowCounter}    Error in Response    FF0000
                save excel document    ${PPInputExcelPath}
                should contain    ${list}[0]    SUCCESS


            END
        END
        save excel document    ${PPInputExcelPath}
        ${ListIndexIterator}=    evaluate    ${ListIndexIterator} + int(${1})
        ${RowCounter}=    evaluate    ${RowCounter} + int(${1})
    END
    save excel document    ${PPInputExcelPath}


Create PP with Geographical discount
    [Tags]    id=AP_PP_06
    ${ListIndexIterator}    set variable    0
    ${DataIndexIterator}    set variable    0
    ${JournalIDCount}=    get length    ${JournalIDList}
    ${RowCounter}    set variable    2
    FOR    ${ScenarioIterator}    IN RANGE    ${JournalIDCount}
        ${ExecutionFlag}=    get from list    ${ExecutionFlagList}    ${ListIndexIterator}
        ${ScenarioName}=    get from list    ${ScenarioList}   ${ListIndexIterator}
        IF    '${ScenarioName}' == 'Create PP with Geographical discount'
            ${JSONFileName}=    get from list    ${JSONFileNameList}    ${ListIndexIterator}
            ${JournalID}=    get from list    ${JournalIDList}    ${ListIndexIterator}
            ${Environment}=    get from list    ${EnvironmentList}    ${ListIndexIterator}
            ${discountType1}=  get from list   ${DiscountType1List}   ${ListIndexIterator}
            ${discountType2}=  get from list   ${DiscountType2List}   ${ListIndexIterator}
            ${discountcondition1}=  get from list    ${DiscountCondition1List}   ${ListIndexIterator}
            ${discountcondition2}=  get from list    ${DiscountCondition2List}    ${ListIndexIterator}
            ${discountpercentage1}=     get from list   ${DiscountPercentage1List}   ${ListIndexIterator}
            ${discountpercentage2}=     get from list       ${DiscountPercentage2List}  ${ListIndexIterator}
            ${appliedyes1}=    get from list   ${AppliedYes1List}   ${ListIndexIterator}
            ${appliedyes2}=  get from list  ${AppliedYes2List}      ${ListIndexIterator}
            ${json_content}=  Get File  ${execdir}${file}${JSONFileName}.json
            ${json_content}=    Generate the JSON file PP    ${json_content}    ${JournalID}
            Write Output Excel    PriceProposal    JSONText    ${RowCounter}    ${json_content}
            Switch Case    ${Environment}
            create session    order_session    ${PPURL}    verify=True
            ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${AuthToken}
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
            ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
            ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
            IF    '${check}' == '${True}'
#                ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
#                ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
                ${error_code}=  Set Variable  ${json_dict['message']}
                ${OrderID}=  Set Variable  ${json_dict['viaxPriceProposalId']}
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
                should contain any   ${errormessage}    PriceDetermined    ManualOverrideRequired


            ELSE
                ${error_code}=  Set Variable  ${json_dict['errors']}
                ${error_code}=    convert to string    ${error_code}
                write and color excel    PriceProposal    OrderStatus    ${RowCounter}    Error in Response    FF0000
                save excel document    ${PPInputExcelPath}
                should contain    ${list}[0]    SUCCESS
            END
        END

        save excel document    ${PPInputExcelPath}
        ${ListIndexIterator}=    evaluate    ${ListIndexIterator} + int(${1})
        ${RowCounter}=    evaluate    ${RowCounter} + int(${1})
    END
    save excel document    ${PPInputExcelPath}

Create PP with Article type discount
    [Tags]    id=AP_PP_07
    ${ListIndexIterator}    set variable    0
    ${DataIndexIterator}    set variable    0
    ${JournalIDCount}=    get length    ${JournalIDList}
    ${RowCounter}    set variable    2
#    open sap logon window    ${SAPGUIPATH}    ${SAPUSERNAME}    ${SAPPASSWORD}    ${ENTERBUTTON}    ${CONNECTION}    ${continuebutton}
#    Launch and Login DBS    ${QA2_Viax}    ${username}    ${password}
    FOR    ${ScenarioIterator}    IN RANGE    ${JournalIDCount}
        ${ExecutionFlag}=    get from list    ${ExecutionFlagList}    ${ListIndexIterator}
        ${ScenarioName}=    get from list    ${ScenarioList}   ${ListIndexIterator}
        IF    '${ScenarioName}' == 'Create PP with Article type discount'
            ${JSONFileName}=    get from list    ${JSONFileNameList}    ${ListIndexIterator}
            ${JournalID}=    get from list    ${JournalIDList}    ${ListIndexIterator}
            ${Environment}=    get from list    ${EnvironmentList}    ${ListIndexIterator}
            ${discountType1}=  get from list   ${DiscountType1List}   ${ListIndexIterator}
            ${discountcondition1}=  get from list    ${DiscountCondition1List}   ${ListIndexIterator}
            ${discountpercentage1}=     get from list   ${DiscountPercentage1List}   ${ListIndexIterator}
            ${appliedyes1}=    get from list   ${AppliedYes1List}   ${ListIndexIterator}

            ${json_content}=  Get File  ${execdir}${file}${JSONFileName}.json
            ${json_content}=    Generate the JSON file PP    ${json_content}    ${JournalID}
            Write Output Excel    PriceProposal    JSONText    ${RowCounter}    ${json_content}
            Switch Case    ${Environment}
            create session    order_session    ${PPURL}    verify=True
            ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${AuthToken}
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
            ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
            ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
            IF    '${check}' == '${True}'
#                ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
#                ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
                ${error_code}=  Set Variable  ${json_dict['message']}
                ${OrderID}=  Set Variable  ${json_dict['viaxPriceProposalId']}
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
                should contain any   ${errormessage}    PriceDetermined    ManualOverrideRequired
#                SeleniumLibrary.input text    ${SearchBox}   ${OrderId}
#                sleep    5s
#                customvariables.save screenshot    ${Screenshotfolder}
#                seleniumlibrary.click element    //*[@title="#${OrderID}"]
#                sleep    5s
#                customvariables.save screenshot    ${Screenshotfolder}
#                ${UIStatus}=    SeleniumLibrary.get text   //*[contains(@class, "x-button x-button_type_primary x-")]
#                ${Typeofpayment}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//span)[1]
#                run keyword and continue on failure    should be equal    ${UIStatus}    PRICE DETERMINED
#                run keyword and continue on failure    should be equal    ${Typeofpayment}    AuthorPaid
#                customvariables.save screenshot    ${Screenshotfolder}
##                ${Discounttype1}=    SeleniumLibrary.get text   //*[contains(@id,"single-spa-application:parcel")]/div/div/div/div[2]/table/tbody/tr/td[1]
#                run keyword and continue on failure    should be equal    ${Discounttype1}    ${discountType1}
#                ${DisountCondition1}=    SeleniumLibrary.get text    //*[contains(@id,"single-spa-application:parcel")]/div/div/div/div[2]/table/tbody/tr/td[2]
#                run keyword and continue on failure    should be equal    ${DisountCondition1}    ${discountcondition1}
#                ${Percentagevalue1}=    SeleniumLibrary.get text    //*[contains(@id,"single-spa-application:parcel")]/div/div/div/div[2]/table/tbody/tr/td[3]
#                run keyword and continue on failure    should be equal    ${Percentagevalue1}    ${discountpercentage1}%
#                ${AppliedYes1}=    SeleniumLibrary.get text    //*[contains(@id,"single-spa-application:parcel")]/div/div/div/div[2]/table/tbody/tr/td[5]
#                run keyword and continue on failure    should be equal    ${AppliedYes1}    ${appliedyes1}
#                ${TaxValue}=    SeleniumLibrary.get text    //*[contains(@id,"single-spa-application:parcel")]/div/div/div/div[6]/div[2]
##                ${TaxValue}=    replace string    ${TaxValue}    ${SPACE}    ${EMPTY}
#                run keyword and continue on failure    should be equal    ${TaxValue}    0.00USD
#                should contain  ${check}  True
            ELSE
                ${error_code}=  Set Variable  ${json_dict['errors']}
                ${error_code}=    convert to string    ${error_code}
                write and color excel    PriceProposal    OrderStatus    ${RowCounter}    Error in Response    FF0000
                save excel document    ${PPInputExcelPath}
#                 should contain any   ${errormessage}    PriceDetermined    ManualOverrideRequired
                should contain    ${list}[0]    SUCCESS
            END
        END
        save excel document    ${PPInputExcelPath}
        ${ListIndexIterator}=    evaluate    ${ListIndexIterator} + int(${1})
        ${RowCounter}=    evaluate    ${RowCounter} + int(${1})
    END
    save excel document    ${PPInputExcelPath}

Create PP with Stacked Institutional discount
    [Tags]    id=AP_PP_08
    ${ListIndexIterator}    set variable    0
    ${DataIndexIterator}    set variable    0
    ${JournalIDCount}=    get length    ${JournalIDList}
    ${RowCounter}    set variable    2
#    open sap logon window    ${SAPGUIPATH}    ${SAPUSERNAME}    ${SAPPASSWORD}    ${ENTERBUTTON}    ${CONNECTION}    ${continuebutton}
#    Launch and Login DBS    ${QA2_Viax}    ${username}    ${password}
    FOR    ${ScenarioIterator}    IN RANGE    ${JournalIDCount}
        ${ExecutionFlag}=    get from list    ${ExecutionFlagList}    ${ListIndexIterator}
        ${ScenarioName}=    get from list    ${ScenarioList}   ${ListIndexIterator}
        IF    '${ScenarioName}' == 'Create PP with Stacked Institutional discount'
            ${JSONFileName}=    get from list    ${JSONFileNameList}    ${ListIndexIterator}
            ${JournalID}=    get from list    ${JournalIDList}    ${ListIndexIterator}
            ${Environment}=    get from list    ${EnvironmentList}    ${ListIndexIterator}
            ${discountType1}=  get from list   ${DiscountType1List}   ${ListIndexIterator}
            ${discountType2}=  get from list   ${DiscountType2List}   ${ListIndexIterator}
            ${discountcondition1}=  get from list    ${DiscountCondition1List}   ${ListIndexIterator}
            ${discountcondition2}=  get from list    ${DiscountCondition2List}    ${ListIndexIterator}
            ${discountpercentage1}=     get from list   ${DiscountPercentage1List}   ${ListIndexIterator}
            ${discountpercentage2}=     get from list       ${DiscountPercentage2List}  ${ListIndexIterator}
            ${appliedyes1}=    get from list   ${AppliedYes1List}   ${ListIndexIterator}
            ${appliedyes2}=  get from list  ${AppliedYes2List}      ${ListIndexIterator}


            ${json_content}=  Get File  ${execdir}${file}${JSONFileName}.json
            ${json_content}=    Generate the JSON file PP    ${json_content}    ${JournalID}
            Write Output Excel    PriceProposal    JSONText    ${RowCounter}    ${json_content}
            Switch Case    ${Environment}
            create session    order_session    ${PPURL}    verify=True
            ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${AuthToken}
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
            ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
            ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
            IF    '${check}' == '${True}'
#                ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
#                ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
                ${error_code}=  Set Variable  ${json_dict['message']}
                ${OrderID}=  Set Variable  ${json_dict['viaxPriceProposalId']}
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
                should contain any   ${errormessage}    PriceDetermined    ManualOverrideRequired


            ELSE
                ${error_code}=  Set Variable  ${json_dict['errors']}
                ${error_code}=    convert to string    ${error_code}
                write and color excel    PriceProposal    OrderStatus    ${RowCounter}    Error in Response    FF0000
                save excel document    ${PPInputExcelPath}
#                 should contain any   ${errormessage}    PriceDetermined    ManualOverrideRequired
                should contain    ${list}[0]    SUCCESS
            END
        END
        save excel document    ${PPInputExcelPath}
        ${ListIndexIterator}=    evaluate    ${ListIndexIterator} + int(${1})
        ${RowCounter}=    evaluate    ${RowCounter} + int(${1})
    END
    save excel document    ${PPInputExcelPath}

Create PP with multiple Society and Promotional discounts
    [Tags]    id=AP_PP_09
    ${ListIndexIterator}    set variable    0
    ${DataIndexIterator}    set variable    0
    ${JournalIDCount}=    get length    ${JournalIDList}
    ${RowCounter}    set variable    2
#    open sap logon window    ${SAPGUIPATH}    ${SAPUSERNAME}    ${SAPPASSWORD}    ${ENTERBUTTON}    ${CONNECTION}    ${continuebutton}
#    Launch and Login DBS    ${QA2_Viax}    ${username}    ${password}
    FOR    ${ScenarioIterator}    IN RANGE    ${JournalIDCount}
        ${ExecutionFlag}=    get from list    ${ExecutionFlagList}    ${ListIndexIterator}
        ${ScenarioName}=    get from list    ${ScenarioList}   ${ListIndexIterator}
        IF    '${ScenarioName}' == 'Create PP with multiple Society and Promotional discounts'
            ${JSONFileName}=    get from list    ${JSONFileNameList}    ${ListIndexIterator}
            ${JournalID}=    get from list    ${JournalIDList}    ${ListIndexIterator}
            ${Environment}=    get from list    ${EnvironmentList}    ${ListIndexIterator}
            ${discountType1}=  get from list   ${DiscountType1List}   ${ListIndexIterator}
            ${discountType2}=  get from list   ${DiscountType2List}   ${ListIndexIterator}
            ${discountType3}=  get from list   ${DiscountType3List}   ${ListIndexIterator}
            ${discountcondition1}=  get from list    ${DiscountCondition1List}   ${ListIndexIterator}
            ${discountcondition2}=  get from list    ${DiscountCondition2List}    ${ListIndexIterator}
            ${discountcondition3}=  get from list    ${DiscountCondition3List}   ${ListIndexIterator}
            ${discountpercentage1}=     get from list       ${DiscountPercentage1List}  ${ListIndexIterator}
            ${discountpercentage2}=     get from list       ${DiscountPercentage2List}  ${ListIndexIterator}
            ${discountpercentage3}=     get from list   ${DiscountPercentage3List}   ${ListIndexIterator}
            ${appliedyes1}=    get from list   ${AppliedYes1List}   ${ListIndexIterator}
            ${appliedyes2}=  get from list  ${AppliedYes2List}      ${ListIndexIterator}
            ${appliedyes3}=    get from list   ${AppliedYes3List}   ${ListIndexIterator}


            ${json_content}=  Get File  ${execdir}${file}${JSONFileName}.json
            ${json_content}=    Generate the JSON file PP    ${json_content}    ${JournalID}
            Write Output Excel    PriceProposal    JSONText    ${RowCounter}    ${json_content}
            Switch Case    ${Environment}
            create session    order_session    ${PPURL}    verify=True
            ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${AuthToken}
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
            ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
            ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
            IF    '${check}' == '${True}'
#                ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
#                ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
                ${error_code}=  Set Variable  ${json_dict['message']}
                ${OrderID}=  Set Variable  ${json_dict['viaxPriceProposalId']}
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
                should contain any   ${errormessage}    PriceDetermined    ManualOverrideRequired


            ELSE
                ${error_code}=  Set Variable  ${json_dict['errors']}
                ${error_code}=    convert to string    ${error_code}
                write and color excel    PriceProposal    OrderStatus    ${RowCounter}    Error in Response    FF0000
                save excel document    ${PPInputExcelPath}
#                should contain any   ${errormessage}    PriceDetermined    ManualOverrideRequired
                should contain    ${list}[0]    SUCCESS
            END
        END
        save excel document    ${PPInputExcelPath}
        ${ListIndexIterator}=    evaluate    ${ListIndexIterator} + int(${1})
        ${RowCounter}=    evaluate    ${RowCounter} + int(${1})
    END
    save excel document    ${PPInputExcelPath}

Create PP with same discount Geographical Editorial and Society discounts
    [Tags]    id=AP_PP_10
    ${ListIndexIterator}    set variable    0
    ${DataIndexIterator}    set variable    0
    ${JournalIDCount}=    get length    ${JournalIDList}
    ${RowCounter}    set variable    2
#    open sap logon window    ${SAPGUIPATH}    ${SAPUSERNAME}    ${SAPPASSWORD}    ${ENTERBUTTON}    ${CONNECTION}    ${continuebutton}
#    Launch and Login DBS    ${QA2_Viax}    ${username}    ${password}
    FOR    ${ScenarioIterator}    IN RANGE    ${JournalIDCount}
        ${ExecutionFlag}=    get from list    ${ExecutionFlagList}    ${ListIndexIterator}
        ${ScenarioName}=    get from list    ${ScenarioList}   ${ListIndexIterator}
        IF    '${ScenarioName}' == 'Create PP with same discount Geographical Editorial and Society discounts'
            ${JSONFileName}=    get from list    ${JSONFileNameList}    ${ListIndexIterator}
            ${JournalID}=    get from list    ${JournalIDList}    ${ListIndexIterator}
            ${Environment}=    get from list    ${EnvironmentList}    ${ListIndexIterator}
            ${discountType1}=  get from list   ${DiscountType1List}   ${ListIndexIterator}
            ${discountType2}=  get from list   ${DiscountType2List}   ${ListIndexIterator}
            ${discountcondition1}=  get from list    ${DiscountCondition1List}   ${ListIndexIterator}
            ${discountcondition2}=  get from list    ${DiscountCondition2List}    ${ListIndexIterator}
            ${discountpercentage1}=     get from list   ${DiscountPercentage1List}   ${ListIndexIterator}
            ${discountpercentage2}=     get from list       ${DiscountPercentage2List}  ${ListIndexIterator}
            ${appliedyes1}=    get from list   ${AppliedYes1List}   ${ListIndexIterator}
            ${appliedyes2}=  get from list  ${AppliedYes2List}      ${ListIndexIterator}


            ${json_content}=  Get File  ${execdir}${file}${JSONFileName}.json
            ${json_content}=    Generate the JSON file PP    ${json_content}    ${JournalID}
            Write Output Excel    PriceProposal    JSONText    ${RowCounter}    ${json_content}
            Switch Case    ${Environment}
            create session    order_session    ${PPURL}    verify=True
            ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${AuthToken}
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
            ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
            ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
            IF    '${check}' == '${True}'
#                ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
#                ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
                ${error_code}=  Set Variable  ${json_dict['message']}
                ${OrderID}=  Set Variable  ${json_dict['viaxPriceProposalId']}
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
                should contain any   ${errormessage}    PriceDetermined    ManualOverrideRequired



            ELSE
                ${error_code}=  Set Variable  ${json_dict['errors']}
                ${error_code}=    convert to string    ${error_code}
                write and color excel    PriceProposal    OrderStatus    ${RowCounter}    Error in Response    FF0000
                save excel document    ${PPInputExcelPath}
#                should contain any   ${errormessage}    PriceDetermined    ManualOverrideRequired
                should contain    ${list}[0]    SUCCESS
            END
        END
        save excel document    ${PPInputExcelPath}
        ${ListIndexIterator}=    evaluate    ${ListIndexIterator} + int(${1})
        ${RowCounter}=    evaluate    ${RowCounter} + int(${1})
    END
    save excel document    ${PPInputExcelPath}

Create PP with Society Promotional Geographical Editorial Article type and Referral discounts
    [Tags]    id=AP_PP_11
    ${ListIndexIterator}    set variable    0
    ${DataIndexIterator}    set variable    0
    ${JournalIDCount}=    get length    ${JournalIDList}
    ${RowCounter}    set variable    2
#    open sap logon window    ${SAPGUIPATH}    ${SAPUSERNAME}    ${SAPPASSWORD}    ${ENTERBUTTON}    ${CONNECTION}    ${continuebutton}
#    Launch and Login DBS    ${QA2_Viax}    ${username}    ${password}
    FOR    ${ScenarioIterator}    IN RANGE    ${JournalIDCount}
        ${ExecutionFlag}=    get from list    ${ExecutionFlagList}    ${ListIndexIterator}
        ${ScenarioName}=    get from list    ${ScenarioList}   ${ListIndexIterator}
        IF    '${ScenarioName}' == 'Create PP with Society Promotional Geographical Editorial Article type and Referral discounts'
            ${JSONFileName}=    get from list    ${JSONFileNameList}    ${ListIndexIterator}
            ${JournalID}=    get from list    ${JournalIDList}    ${ListIndexIterator}
            ${Environment}=    get from list    ${EnvironmentList}    ${ListIndexIterator}
            ${discountType1}=  get from list   ${DiscountType1List}   ${ListIndexIterator}
            ${discountType2}=  get from list   ${DiscountType2List}   ${ListIndexIterator}
            ${discountType3}=  get from list   ${DiscountType3List}   ${ListIndexIterator}
            ${discountType4}=  get from list   ${DiscountType4List}   ${ListIndexIterator}
            ${discountType5}=  get from list   ${DiscountType5List}   ${ListIndexIterator}
            ${discountType6}=  get from list   ${DiscountType6List}   ${ListIndexIterator}
            ${discountcondition1}=  get from list    ${DiscountCondition1List}   ${ListIndexIterator}
            ${discountcondition2}=  get from list    ${DiscountCondition2List}    ${ListIndexIterator}
            ${discountcondition3}=  get from list    ${DiscountCondition3List}   ${ListIndexIterator}
            ${discountcondition4}=  get from list    ${DiscountCondition4List}   ${ListIndexIterator}
            ${discountcondition5}=  get from list    ${DiscountCondition5List}   ${ListIndexIterator}
            ${discountcondition6}=  get from list    ${DiscountCondition6List}   ${ListIndexIterator}
            ${discountpercentage1}=     get from list   ${DiscountPercentage1List}   ${ListIndexIterator}
            ${discountpercentage2}=     get from list   ${DiscountPercentage2List}  ${ListIndexIterator}
            ${discountpercentage3}=     get from list   ${DiscountPercentage3List}   ${ListIndexIterator}
            ${discountpercentage4}=     get from list   ${DiscountPercentage4List}   ${ListIndexIterator}
            ${discountpercentage5}=     get from list   ${DiscountPercentage5List}   ${ListIndexIterator}
            ${discountpercentage6}=     get from list   ${DiscountPercentage6List}   ${ListIndexIterator}
            ${appliedyes1}=    get from list   ${AppliedYes1List}   ${ListIndexIterator}
            ${appliedyes2}=  get from list  ${AppliedYes2List}      ${ListIndexIterator}
            ${appliedyes3}=  get from list  ${AppliedYes3List}      ${ListIndexIterator}
            ${appliedyes4}=  get from list  ${AppliedYes4List}      ${ListIndexIterator}
            ${appliedyes5}=  get from list  ${AppliedYes5List}      ${ListIndexIterator}
            ${appliedyes6}=  get from list  ${AppliedYes6List}      ${ListIndexIterator}



            ${json_content}=  Get File  ${execdir}${file}${JSONFileName}.json
            ${json_content}=    Generate the JSON file PP    ${json_content}    ${JournalID}
            Write Output Excel    PriceProposal    JSONText    ${RowCounter}    ${json_content}
            Switch Case    ${Environment}
            create session    order_session    ${PPURL}    verify=True
            ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${AuthToken}
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
            ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
            ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
            IF    '${check}' == '${True}'
#                ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
#                ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
                ${error_code}=  Set Variable  ${json_dict['message']}
                ${OrderID}=  Set Variable  ${json_dict['viaxPriceProposalId']}
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
                should contain any   ${errormessage}    PriceDetermined    ManualOverrideRequired


            ELSE
                ${error_code}=  Set Variable  ${json_dict['errors']}
                ${error_code}=    convert to string    ${error_code}
                write and color excel    PriceProposal    OrderStatus    ${RowCounter}    Error in Response    FF0000
                save excel document    ${PPInputExcelPath}
#                should contain any   ${errormessage}    PriceDetermined    ManualOverrideRequired
                should contain    ${list}[0]    SUCCESS
            END
        END
        save excel document    ${PPInputExcelPath}
        ${ListIndexIterator}=    evaluate    ${ListIndexIterator} + int(${1})
        ${RowCounter}=    evaluate    ${RowCounter} + int(${1})
    END
    save excel document    ${PPInputExcelPath}

Create PP with Multiple Insitutional discounts
    [Tags]    id=AP_PP_12
    ${ListIndexIterator}    set variable    0
    ${DataIndexIterator}    set variable    0
    ${JournalIDCount}=    get length    ${JournalIDList}
    ${RowCounter}    set variable    2
#    open sap logon window    ${SAPGUIPATH}    ${SAPUSERNAME}    ${SAPPASSWORD}    ${ENTERBUTTON}    ${CONNECTION}    ${continuebutton}
#    Launch and Login DBS    ${QA2_Viax}    ${username}    ${password}
    FOR    ${ScenarioIterator}    IN RANGE    ${JournalIDCount}
        ${ExecutionFlag}=    get from list    ${ExecutionFlagList}    ${ListIndexIterator}
        ${ScenarioName}=    get from list    ${ScenarioList}   ${ListIndexIterator}
        IF    '${ScenarioName}' == 'Create PP with Multiple Insitutional discounts'
            ${JSONFileName}=    get from list    ${JSONFileNameList}    ${ListIndexIterator}
            ${JournalID}=    get from list    ${JournalIDList}    ${ListIndexIterator}
            ${Environment}=    get from list    ${EnvironmentList}    ${ListIndexIterator}
            ${json_content}=  Get File  ${execdir}${file}${JSONFileName}.json
            ${json_content}=    Generate the JSON file PP    ${json_content}    ${JournalID}
            Write Output Excel    PriceProposal    JSONText    ${RowCounter}    ${json_content}
            Switch Case    ${Environment}
            create session    order_session    ${PPURL}    verify=True
            ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${AuthToken}
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
            ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
            ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
            IF    '${check}' == '${True}'
#                ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
#                ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
                ${error_code}=  Set Variable  ${json_dict['message']}
                ${OrderID}=  Set Variable  ${json_dict['viaxPriceProposalId']}
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
                should contain any   ${errormessage}    PriceDetermined    ManualOverrideRequired

            ELSE
                ${error_code}=  Set Variable  ${json_dict['errors']}
                ${error_code}=    convert to string    ${error_code}
                write and color excel    PriceProposal    OrderStatus    ${RowCounter}    Error in Response    FF0000
                save excel document    ${PPInputExcelPath}
#                should contain any   ${errormessage}    PriceDetermined    ManualOverrideRequired
                should contain    ${list}[0]    SUCCESS
            END
        END
        save excel document    ${PPInputExcelPath}
        ${ListIndexIterator}=    evaluate    ${ListIndexIterator} + int(${1})
        ${RowCounter}=    evaluate    ${RowCounter} + int(${1})
    END
    save excel document    ${PPInputExcelPath}

Create PP with Funder details
    [Tags]    id=AP_PP_13
    ${ListIndexIterator}    set variable    0
    ${DataIndexIterator}    set variable    0
    ${JournalIDCount}=    get length    ${JournalIDList}
    ${RowCounter}    set variable    2
#    open sap logon window    ${SAPGUIPATH}    ${SAPUSERNAME}    ${SAPPASSWORD}    ${ENTERBUTTON}    ${CONNECTION}    ${continuebutton}
#    Launch and Login DBS    ${QA2_Viax}    ${username}    ${password}
    FOR    ${ScenarioIterator}    IN RANGE    ${JournalIDCount}
        ${ExecutionFlag}=    get from list    ${ExecutionFlagList}    ${ListIndexIterator}
        ${ScenarioName}=    get from list    ${ScenarioList}   ${ListIndexIterator}
        IF    '${ScenarioName}' == 'Create PP with Funder details'
            ${JSONFileName}=    get from list    ${JSONFileNameList}    ${ListIndexIterator}
            ${JournalID}=    get from list    ${JournalIDList}    ${ListIndexIterator}
            ${Environment}=    get from list    ${EnvironmentList}    ${ListIndexIterator}

            ${json_content}=  Get File  ${execdir}${file}${JSONFileName}.json
            ${json_content}=    Generate the JSON file PP    ${json_content}    ${JournalID}
            Write Output Excel    PriceProposal    JSONText    ${RowCounter}    ${json_content}
            Switch Case    ${Environment}
            create session    order_session    ${PPURL}    verify=True
            ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${AuthToken}
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
            ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
            ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
            IF    '${check}' == '${True}'
#                ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
#                ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
                ${error_code}=  Set Variable  ${json_dict['message']}
                ${OrderID}=  Set Variable  ${json_dict['viaxPriceProposalId']}
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
                should contain any   ${errormessage}    PriceDetermined    ManualOverrideRequired


            ELSE
                ${error_code}=  Set Variable  ${json_dict['errors']}
                ${error_code}=    convert to string    ${error_code}
                write and color excel    PriceProposal    OrderStatus    ${RowCounter}    Error in Response    FF0000
                save excel document    ${PPInputExcelPath}
#                should contain any   ${errormessage}    PriceDetermined    ManualOverrideRequired
                should contain    ${list}[0]    SUCCESS
            END
        END
        save excel document    ${PPInputExcelPath}
        ${ListIndexIterator}=    evaluate    ${ListIndexIterator} + int(${1})
        ${RowCounter}=    evaluate    ${RowCounter} + int(${1})
    END
    save excel document    ${PPInputExcelPath}

Create PP with Invalid Promotional discount code
    [Tags]    id=AP_PP_14
    ${ListIndexIterator}    set variable    0
    ${DataIndexIterator}    set variable    0
    ${JournalIDCount}=    get length    ${JournalIDList}
    ${RowCounter}    set variable    2
    FOR    ${ScenarioIterator}    IN RANGE    ${JournalIDCount}
        ${ExecutionFlag}=    get from list    ${ExecutionFlagList}    ${ListIndexIterator}
        ${ScenarioName}=    get from list    ${ScenarioList}   ${ListIndexIterator}
        IF    '${ScenarioName}' == 'Create PP with Invalid Promotional discount code'
            ${JSONFileName}=    get from list    ${JSONFileNameList}    ${ListIndexIterator}
            ${JournalID}=    get from list    ${JournalIDList}    ${ListIndexIterator}
            ${Environment}=    get from list    ${EnvironmentList}    ${ListIndexIterator}
            ${discountType1}=  get from list   ${DiscountType1List}   ${ListIndexIterator}
            ${discountType2}=  get from list   ${DiscountType2List}   ${ListIndexIterator}
            ${discountcondition1}=  get from list    ${DiscountCondition1List}   ${ListIndexIterator}
            ${discountcondition2}=  get from list    ${DiscountCondition2List}    ${ListIndexIterator}
            ${discountpercentage1}=     get from list   ${DiscountPercentage1List}   ${ListIndexIterator}
            ${discountpercentage2}=     get from list       ${DiscountPercentage2List}  ${ListIndexIterator}
            ${appliedyes1}=    get from list   ${AppliedYes1List}   ${ListIndexIterator}
            ${appliedyes2}=  get from list  ${AppliedYes2List}      ${ListIndexIterator}


            ${json_content}=  Get File  ${execdir}${file}${JSONFileName}.json
            ${json_content}=    Generate the JSON file PP    ${json_content}    ${JournalID}
            Write Output Excel    PriceProposal    JSONText    ${RowCounter}    ${json_content}
            Switch Case    ${Environment}
            create session    order_session    ${PPURL}    verify=True
            ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${AuthToken}
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
            ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
            ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
            IF    '${check}' == '${True}'
#                ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
#                ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
                ${error_code}=  Set Variable  ${json_dict['message']}
                ${OrderID}=  Set Variable  ${json_dict['viaxPriceProposalId']}
                ${error_code}=    convert to string    ${error_code}
                ${OrderStatus}=    convert to string    ${OrderID}
                Write Output Excel    PriceProposal    OrderStatus    ${RowCounter}    ${error_code}
                Write Output Excel    PriceProposal    OrderID    ${RowCounter}    ${OrderID}
                ${errormessage}=    set variable    ${json_dict['priceProposal']['bpStatus']['code']}
                ${errormessage}=    convert to string    ${errormessage}
                IF    '${errormessage}' == 'DataCorrectionRequired' or '${errormessage}' == 'DataCorrectionRequired'
                    write and color excel    PriceProposal    PriceProposalStatus    ${RowCounter}    ${errormessage}    00FF00
                    save excel document    ${PPInputExcelPath}
                ELSE
                    write and color excel    PriceProposal    PriceProposalStatus    ${RowCounter}    ${errormessage}    FF0000
                    save excel document    ${PPInputExcelPath}
                END
                should contain any   ${errormessage}    DataCorrectionRequired    DataCorrectionRequired




            ELSE
                ${error_code}=  Set Variable  ${json_dict['errors']}
                ${error_code}=    convert to string    ${error_code}
                write and color excel    PriceProposal    OrderStatus    ${RowCounter}    Error in Response    FF0000
                save excel document    ${PPInputExcelPath}
#                should contain any   ${errormessage}    PriceDetermined    ManualOverrideRequired
                should contain    ${list}[0]    SUCCESS
            END
        END
        save excel document    ${PPInputExcelPath}
        ${ListIndexIterator}=    evaluate    ${ListIndexIterator} + int(${1})
        ${RowCounter}=    evaluate    ${RowCounter} + int(${1})
    END
    save excel document    ${PPInputExcelPath}

Create PP with Manual override required value as Yes
    [Tags]    id=AP_PP_15
    ${ListIndexIterator}    set variable    0
    ${DataIndexIterator}    set variable    0
    ${JournalIDCount}=    get length    ${JournalIDList}
    ${RowCounter}    set variable    2
#    open sap logon window    ${SAPGUIPATH}    ${SAPUSERNAME}    ${SAPPASSWORD}    ${ENTERBUTTON}    ${CONNECTION}    ${continuebutton}
#    Launch and Login DBS    ${QA2_Viax}    ${username}    ${password}
    FOR    ${ScenarioIterator}    IN RANGE    ${JournalIDCount}
        ${ExecutionFlag}=    get from list    ${ExecutionFlagList}    ${ListIndexIterator}
        ${ScenarioName}=    get from list    ${ScenarioList}   ${ListIndexIterator}
        IF    '${ScenarioName}' == 'Create PP with Manual override required value as Yes'
            ${JSONFileName}=    get from list    ${JSONFileNameList}    ${ListIndexIterator}
            ${JournalID}=    get from list    ${JournalIDList}    ${ListIndexIterator}
            ${Environment}=    get from list    ${EnvironmentList}    ${ListIndexIterator}
            ${JSONFileName}=    get from list    ${JSONFileNameList}    ${ListIndexIterator}
            ${JournalID}=    get from list    ${JournalIDList}    ${ListIndexIterator}
            ${Environment}=    get from list    ${EnvironmentList}    ${ListIndexIterator}
            ${discountType1}=  get from list   ${DiscountType1List}   ${ListIndexIterator}
            ${discountcondition1}=  get from list    ${DiscountCondition1List}   ${ListIndexIterator}
            ${discountpercentage1}=     get from list   ${DiscountPercentage1List}   ${ListIndexIterator}
            ${appliedyes1}=    get from list   ${AppliedYes1List}   ${ListIndexIterator}

            ${json_content}=  Get File  ${execdir}${file}${JSONFileName}.json
            ${json_content}=    Generate the JSON file PP    ${json_content}    ${JournalID}
            Write Output Excel    PriceProposal    JSONText    ${RowCounter}    ${json_content}
            Switch Case    ${Environment}
            create session    order_session    ${PPURL}    verify=True
            ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${AuthToken}
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
            ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
            ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
            IF    '${check}' == '${True}'
#                ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
#                ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
                ${error_code}=  Set Variable  ${json_dict['message']}
                ${OrderID}=  Set Variable  ${json_dict['viaxPriceProposalId']}
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
                should contain any   ${errormessage}    PriceDetermined    ManualOverrideRequired



            ELSE
                ${error_code}=  Set Variable  ${json_dict['errors']}
                ${error_code}=    convert to string    ${error_code}
                write and color excel    PriceProposal    OrderStatus    ${RowCounter}    Error in Response    FF0000
                save excel document    ${PPInputExcelPath}
#                should contain any   ${errormessage}    PriceDetermined    ManualOverrideRequired
                should contain    ${list}[0]    SUCCESS
            END
        END
        save excel document    ${PPInputExcelPath}
        ${ListIndexIterator}=    evaluate    ${ListIndexIterator} + int(${1})
        ${RowCounter}=    evaluate    ${RowCounter} + int(${1})
    END
    save excel document    ${PPInputExcelPath}

Create PP with Invalid Society
    [Tags]    id=AP_PP_16
    ${ListIndexIterator}    set variable    0
    ${DataIndexIterator}    set variable    0
    ${JournalIDCount}=    get length    ${JournalIDList}
    ${RowCounter}    set variable    2

#    open sap logon window    ${SAPGUIPATH}    ${SAPUSERNAME}    ${SAPPASSWORD}    ${ENTERBUTTON}    ${CONNECTION}    ${continuebutton}
#    Launch and Login DBS    ${QA2_Viax}    ${username}    ${password}
    FOR    ${ScenarioIterator}    IN RANGE    ${JournalIDCount}
        ${ExecutionFlag}=    get from list    ${ExecutionFlagList}    ${ListIndexIterator}
        ${ScenarioName}=    get from list    ${ScenarioList}   ${ListIndexIterator}
        IF    '${ScenarioName}' == 'Create PP with Invalid Society'
            ${JSONFileName}=    get from list    ${JSONFileNameList}    ${ListIndexIterator}
            ${JournalID}=    get from list    ${JournalIDList}    ${ListIndexIterator}
            ${Environment}=    get from list    ${EnvironmentList}    ${ListIndexIterator}
            ${json_content}=  Get File  ${execdir}${file}${JSONFileName}.json
            ${json_content}=    Generate the JSON file PP    ${json_content}    ${JournalID}
            Write Output Excel    PriceProposal    JSONText    ${RowCounter}    ${json_content}
            Switch Case    ${Environment}
            create session    order_session    ${PPURL}    verify=True
            ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${AuthToken}
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

            ${NumberofList}=    get length    ${list}
            set variable    ${JsonResp}
            ${check}=    run keyword and return status    should contain    ${list}[0]    SUCCESS
            ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
            ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
            IF    '${check}' == '${True}'
#                ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
#                ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
                ${error_code}=  Set Variable  ${json_dict['message']}
                ${OrderID}=  Set Variable  ${json_dict['viaxPriceProposalId']}
                ${error_code}=    convert to string    ${error_code}
                ${OrderStatus}=    convert to string    ${OrderID}
                Write Output Excel    PriceProposal    OrderStatus    ${RowCounter}    ${error_code}
                Write Output Excel    PriceProposal    OrderID    ${RowCounter}    ${OrderID}
                ${errormessage}=    set variable    ${json_dict['priceProposal']['bpStatus']['code']}
                ${errormessage}=    convert to string    ${errormessage}
                IF    '${errormessage}' == 'DataCorrectionRequired'
                    write and color excel    PriceProposal    PriceProposalStatus    ${RowCounter}    ${errormessage}    00FF00
                    save excel document    ${PPInputExcelPath}
                ELSE
                    write and color excel    PriceProposal    PriceProposalStatus    ${RowCounter}    ${errormessage}    FF0000
                    save excel document    ${PPInputExcelPath}
                END
                should contain any   ${errormessage}    DataCorrectionRequired    DataCorrectionRequired

#                should contain  ${check}  True
            ELSE
                ${error_code}=  Set Variable  ${json_dict['errors']}
                ${error_code}=    convert to string    ${error_code}
                write and color excel    PriceProposal    OrderStatus    ${RowCounter}    Error in Response    FF0000
                save excel document    ${PPInputExcelPath}
#                should contain any   ${errormessage}    PriceDetermined    ManualOverrideRequired
                should contain    ${list}[0]    SUCCESS
            END
        END
        save excel document    ${PPInputExcelPath}
        ${ListIndexIterator}=    evaluate    ${ListIndexIterator} + int(${1})
        ${RowCounter}=    evaluate    ${RowCounter} + int(${1})
    END
    save excel document    ${PPInputExcelPath}

Create PP with Invalid Article Type
    [Tags]    id=AP_PP_17
    ${ListIndexIterator}    set variable    0
    ${DataIndexIterator}    set variable    0
    ${JournalIDCount}=    get length    ${JournalIDList}
    ${RowCounter}    set variable    2

#    open sap logon window    ${SAPGUIPATH}    ${SAPUSERNAME}    ${SAPPASSWORD}    ${ENTERBUTTON}    ${CONNECTION}    ${continuebutton}
#    Launch and Login DBS    ${QA2_Viax}    ${username}    ${password}
    FOR    ${ScenarioIterator}    IN RANGE    ${JournalIDCount}
        ${ExecutionFlag}=    get from list    ${ExecutionFlagList}    ${ListIndexIterator}
        ${ScenarioName}=    get from list    ${ScenarioList}   ${ListIndexIterator}
        IF    '${ScenarioName}' == 'Create PP with Invalid Article Type'
            ${JSONFileName}=    get from list    ${JSONFileNameList}    ${ListIndexIterator}
            ${JournalID}=    get from list    ${JournalIDList}    ${ListIndexIterator}
            ${Environment}=    get from list    ${EnvironmentList}    ${ListIndexIterator}
            ${json_content}=  Get File  ${execdir}${file}${JSONFileName}.json
            ${json_content}=    Generate the JSON file PP    ${json_content}    ${JournalID}
            Write Output Excel    PriceProposal    JSONText    ${RowCounter}    ${json_content}
            Switch Case    ${Environment}
            create session    order_session    ${PPURL}    verify=True
            ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${AuthToken}
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

            ${NumberofList}=    get length    ${list}
            set variable    ${JsonResp}
            ${check}=    run keyword and return status    should contain    ${list}[0]    SUCCESS
            ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
            ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
            IF    '${check}' == '${True}'
#                ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
#                ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
                ${error_code}=  Set Variable  ${json_dict['message']}
                ${OrderID}=  Set Variable  ${json_dict['viaxPriceProposalId']}
                ${error_code}=    convert to string    ${error_code}
                ${OrderStatus}=    convert to string    ${OrderID}
                Write Output Excel    PriceProposal    OrderStatus    ${RowCounter}    ${error_code}
                Write Output Excel    PriceProposal    OrderID    ${RowCounter}    ${OrderID}
                ${errormessage}=    set variable    ${json_dict['priceProposal']['bpStatus']['code']}
                ${errormessage}=    convert to string    ${errormessage}
                IF    '${errormessage}' == 'DataCorrectionRequired'
                    write and color excel    PriceProposal    PriceProposalStatus    ${RowCounter}    ${errormessage}    00FF00
                    save excel document    ${PPInputExcelPath}
                ELSE
                    write and color excel    PriceProposal    PriceProposalStatus    ${RowCounter}    ${errormessage}    FF0000
                    save excel document    ${PPInputExcelPath}
                END
                should contain any   ${errormessage}    DataCorrectionRequired    DataCorrectionRequired

#                should contain  ${check}  True
            ELSE
                ${error_code}=  Set Variable  ${json_dict['errors']}
                ${error_code}=    convert to string    ${error_code}
                write and color excel    PriceProposal    OrderStatus    ${RowCounter}    Error in Response    FF0000
                save excel document    ${PPInputExcelPath}
#                should contain any   ${errormessage}    PriceDetermined    ManualOverrideRequired
                should contain    ${list}[0]    SUCCESS
            END
        END
        save excel document    ${PPInputExcelPath}
        ${ListIndexIterator}=    evaluate    ${ListIndexIterator} + int(${1})
        ${RowCounter}=    evaluate    ${RowCounter} + int(${1})
    END
    save excel document    ${PPInputExcelPath}

Create PP with Invalid Editorial
    [Tags]    id=AP_PP_18
    ${ListIndexIterator}    set variable    0
    ${DataIndexIterator}    set variable    0
    ${JournalIDCount}=    get length    ${JournalIDList}
    ${RowCounter}    set variable    2
#    open sap logon window    ${SAPGUIPATH}    ${SAPUSERNAME}    ${SAPPASSWORD}    ${ENTERBUTTON}    ${CONNECTION}    ${continuebutton}
#    Launch and Login DBS    ${QA2_Viax}    ${username}    ${password}
    FOR    ${ScenarioIterator}    IN RANGE    ${JournalIDCount}
        ${ExecutionFlag}=    get from list    ${ExecutionFlagList}    ${ListIndexIterator}
        ${ScenarioName}=    get from list    ${ScenarioList}   ${ListIndexIterator}
        IF    '${ScenarioName}' == 'Create PP with Invalid Editorial'
            ${JSONFileName}=    get from list    ${JSONFileNameList}    ${ListIndexIterator}
            ${JournalID}=    get from list    ${JournalIDList}    ${ListIndexIterator}
            ${Environment}=    get from list    ${EnvironmentList}    ${ListIndexIterator}
            ${json_content}=  Get File  ${execdir}${file}${JSONFileName}.json
            ${json_content}=    Generate the JSON file PP    ${json_content}    ${JournalID}
            Write Output Excel    PriceProposal    JSONText    ${RowCounter}    ${json_content}
            Switch Case    ${Environment}
            create session    order_session    ${PPURL}    verify=True
            ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${AuthToken}
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

            ${NumberofList}=    get length    ${list}
            set variable    ${JsonResp}
            ${check}=    run keyword and return status    should contain    ${list}[0]    SUCCESS
            ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
            ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
            IF    '${check}' == '${True}'
#                ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
#                ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
                ${error_code}=  Set Variable  ${json_dict['message']}
                ${OrderID}=  Set Variable  ${json_dict['viaxPriceProposalId']}
                ${error_code}=    convert to string    ${error_code}
                ${OrderStatus}=    convert to string    ${OrderID}
                Write Output Excel    PriceProposal    OrderStatus    ${RowCounter}    ${error_code}
                Write Output Excel    PriceProposal    OrderID    ${RowCounter}    ${OrderID}
                ${errormessage}=    set variable    ${json_dict['priceProposal']['bpStatus']['code']}
                ${errormessage}=    convert to string    ${errormessage}
                IF    '${errormessage}' == 'DataCorrectionRequired'
                    write and color excel    PriceProposal    PriceProposalStatus    ${RowCounter}    ${errormessage}    00FF00
                    save excel document    ${PPInputExcelPath}
                ELSE
                    write and color excel    PriceProposal    PriceProposalStatus    ${RowCounter}    ${errormessage}    FF0000
                    save excel document    ${PPInputExcelPath}
                END
                should contain any   ${errormessage}    DataCorrectionRequired    DataCorrectionRequired

#                should contain  ${check}  True
            ELSE
                ${error_code}=  Set Variable  ${json_dict['errors']}
                ${error_code}=    convert to string    ${error_code}
                write and color excel    PriceProposal    OrderStatus    ${RowCounter}    Error in Response    FF0000
                save excel document    ${PPInputExcelPath}
#                should contain any   ${errormessage}    PriceDetermined    ManualOverrideRequired
                should contain    ${list}[0]    SUCCESS
            END
        END
        save excel document    ${PPInputExcelPath}
        ${ListIndexIterator}=    evaluate    ${ListIndexIterator} + int(${1})
        ${RowCounter}=    evaluate    ${RowCounter} + int(${1})
    END
    save excel document    ${PPInputExcelPath}

Create PP with Invalid Referal
    [Tags]    id=AP_PP_19
    ${ListIndexIterator}    set variable    0
    ${DataIndexIterator}    set variable    0
    ${JournalIDCount}=    get length    ${JournalIDList}
    ${RowCounter}    set variable    2
    FOR    ${ScenarioIterator}    IN RANGE    ${JournalIDCount}
        ${ExecutionFlag}=    get from list    ${ExecutionFlagList}    ${ListIndexIterator}
        ${ScenarioName}=    get from list    ${ScenarioList}   ${ListIndexIterator}
        IF    '${ScenarioName}' == 'Create PP with Invalid Referal'
            ${JSONFileName}=    get from list    ${JSONFileNameList}    ${ListIndexIterator}
            ${JournalID}=    get from list    ${JournalIDList}    ${ListIndexIterator}
            ${Environment}=    get from list    ${EnvironmentList}    ${ListIndexIterator}
            ${json_content}=  Get File  ${execdir}${file}${JSONFileName}.json
            ${json_content}=    Generate the JSON file PP    ${json_content}    ${JournalID}
            Write Output Excel    PriceProposal    JSONText    ${RowCounter}    ${json_content}
            Switch Case    ${Environment}
            create session    order_session    ${PPURL}    verify=True
            ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${AuthToken}
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

            ${NumberofList}=    get length    ${list}
            set variable    ${JsonResp}
            ${check}=    run keyword and return status    should contain    ${list}[0]    SUCCESS
            ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
            ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
            IF    '${check}' == '${True}'
#                ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
#                ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
                ${error_code}=  Set Variable  ${json_dict['message']}
                ${OrderID}=  Set Variable  ${json_dict['viaxPriceProposalId']}
                ${error_code}=    convert to string    ${error_code}
                ${OrderStatus}=    convert to string    ${OrderID}
                Write Output Excel    PriceProposal    OrderStatus    ${RowCounter}    ${error_code}
                Write Output Excel    PriceProposal    OrderID    ${RowCounter}    ${OrderID}
                ${errormessage}=    set variable    ${json_dict['priceProposal']['bpStatus']['code']}
                ${errormessage}=    convert to string    ${errormessage}
                IF    '${errormessage}' == 'ReSend'
                    write and color excel    PriceProposal    PriceProposalStatus    ${RowCounter}    ${errormessage}    00FF00
                    save excel document    ${PPInputExcelPath}
                ELSE
                    write and color excel    PriceProposal    PriceProposalStatus    ${RowCounter}    ${errormessage}    FF0000
                    save excel document    ${PPInputExcelPath}
                END
                should contain any   ${errormessage}    ReSend    ReSend

#                should contain  ${check}  True
            ELSE
                ${error_code}=  Set Variable  ${json_dict['errors']}
                ${error_code}=    convert to string    ${error_code}
                write and color excel    PriceProposal    OrderStatus    ${RowCounter}    Error in Response    FF0000
                save excel document    ${PPInputExcelPath}
#                should contain any   ${errormessage}    PriceDetermined    ManualOverrideRequired
                should contain    ${list}[0]    SUCCESS
            END
        END
        save excel document    ${PPInputExcelPath}
        ${ListIndexIterator}=    evaluate    ${ListIndexIterator} + int(${1})
        ${RowCounter}=    evaluate    ${RowCounter} + int(${1})
    END
    save excel document    ${PPInputExcelPath}

Create PP with Invalid CountryCode
    [Tags]    id=AP_PP_20
    ${ListIndexIterator}    set variable    0
    ${DataIndexIterator}    set variable    0
    ${JournalIDCount}=    get length    ${JournalIDList}
    ${RowCounter}    set variable    2
    FOR    ${ScenarioIterator}    IN RANGE    ${JournalIDCount}
        ${ExecutionFlag}=    get from list    ${ExecutionFlagList}    ${ListIndexIterator}
        ${ScenarioName}=    get from list    ${ScenarioList}   ${ListIndexIterator}
        IF    '${ScenarioName}' == 'Create PP with Invalid CountryCode'
            ${JSONFileName}=    get from list    ${JSONFileNameList}    ${ListIndexIterator}
            ${JournalID}=    get from list    ${JournalIDList}    ${ListIndexIterator}
            ${Environment}=    get from list    ${EnvironmentList}    ${ListIndexIterator}
            ${json_content}=  Get File  ${execdir}${file}${JSONFileName}.json
            ${json_content}=    Generate the JSON file PP    ${json_content}    ${JournalID}
            Write Output Excel    PriceProposal    JSONText    ${RowCounter}    ${json_content}
            Switch Case    ${Environment}
            create session    order_session    ${PPURL}    verify=True
            ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${AuthToken}
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

            ${NumberofList}=    get length    ${list}
            set variable    ${JsonResp}
            ${check}=    run keyword and return status    should contain    ${list}[0]    SUCCESS
            ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
            ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
            IF    '${check}' == '${True}'
#                ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
#                ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
                ${error_code}=  Set Variable  ${json_dict['message']}
                ${OrderID}=  Set Variable  ${json_dict['viaxPriceProposalId']}
                ${error_code}=    convert to string    ${error_code}
                ${OrderStatus}=    convert to string    ${OrderID}
                Write Output Excel    PriceProposal    OrderStatus    ${RowCounter}    ${error_code}
                Write Output Excel    PriceProposal    OrderID    ${RowCounter}    ${OrderID}
                ${errormessage}=    set variable    ${json_dict['priceProposal']['bpStatus']['code']}
                ${errormessage}=    convert to string    ${errormessage}
                IF    '${errormessage}' == 'ReSend'
                    write and color excel    PriceProposal    PriceProposalStatus    ${RowCounter}    ${errormessage}    00FF00
                    save excel document    ${PPInputExcelPath}
                ELSE
                    write and color excel    PriceProposal    PriceProposalStatus    ${RowCounter}    ${errormessage}    FF0000
                    save excel document    ${PPInputExcelPath}
                END
                should contain any   ${errormessage}    ReSend    ReSend

#                should contain  ${check}  True
            ELSE
                ${error_code}=  Set Variable  ${json_dict['errors']}
                ${error_code}=    convert to string    ${error_code}
                write and color excel    PriceProposal    OrderStatus    ${RowCounter}    Error in Response    FF0000
                save excel document    ${PPInputExcelPath}
#                should contain any   ${errormessage}    PriceDetermined    ManualOverrideRequired
                should contain    ${list}[0]    SUCCESS
            END
        END
        save excel document    ${PPInputExcelPath}
        ${ListIndexIterator}=    evaluate    ${ListIndexIterator} + int(${1})
        ${RowCounter}=    evaluate    ${RowCounter} + int(${1})
    END
    save excel document    ${PPInputExcelPath}

Create PP with Invalid MailId
    [Tags]    id=AP_PP_21
    ${ListIndexIterator}    set variable    0
    ${DataIndexIterator}    set variable    0
    ${JournalIDCount}=    get length    ${JournalIDList}
    ${RowCounter}    set variable    2
    FOR    ${ScenarioIterator}    IN RANGE    ${JournalIDCount}
        ${ExecutionFlag}=    get from list    ${ExecutionFlagList}    ${ListIndexIterator}
        ${ScenarioName}=    get from list    ${ScenarioList}   ${ListIndexIterator}
        IF    '${ScenarioName}' == 'Create PP with Invalid MailId'
            ${JSONFileName}=    get from list    ${JSONFileNameList}    ${ListIndexIterator}
            ${JournalID}=    get from list    ${JournalIDList}    ${ListIndexIterator}
            ${Environment}=    get from list    ${EnvironmentList}    ${ListIndexIterator}
            ${json_content}=  Get File  ${execdir}${file}${JSONFileName}.json
            ${json_content}=    Generate the JSON file PP    ${json_content}    ${JournalID}
            Write Output Excel    PriceProposal    JSONText    ${RowCounter}    ${json_content}
            Switch Case    ${Environment}
            create session    order_session    ${PPURL}    verify=True
            ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${AuthToken}
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

            ${NumberofList}=    get length    ${list}
            set variable    ${JsonResp}
            ${check}=    run keyword and return status    should contain    ${list}[0]    SUCCESS
            ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
            ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
            IF    '${check}' == '${True}'
                ${error_code}=  Set Variable  ${json_dict['message']}
                ${OrderID}=  Set Variable  ${json_dict['viaxPriceProposalId']}
                ${error_code}=    convert to string    ${error_code}
                ${OrderStatus}=    convert to string    ${OrderID}
                Write Output Excel    PriceProposal    OrderStatus    ${RowCounter}    ${error_code}
                Write Output Excel    PriceProposal    OrderID    ${RowCounter}    ${OrderID}
                ${errormessage}=    set variable    ${json_dict['priceProposal']['bpStatus']['code']}
                ${errormessage}=    convert to string    ${errormessage}
                IF    '${errormessage}' == 'ReSend'
                    write and color excel    PriceProposal    PriceProposalStatus    ${RowCounter}    ${errormessage}    00FF00
                    save excel document    ${PPInputExcelPath}
                ELSE
                    write and color excel    PriceProposal    PriceProposalStatus    ${RowCounter}    ${errormessage}    FF0000
                    save excel document    ${PPInputExcelPath}
                END
                should contain any   ${errormessage}    ReSend    ReSend

#                should contain  ${check}  True
            ELSE
                ${error_code}=  Set Variable  ${json_dict['errors']}
                ${error_code}=    convert to string    ${error_code}
                write and color excel    PriceProposal    OrderStatus    ${RowCounter}    Error in Response    FF0000
                save excel document    ${PPInputExcelPath}
#                should contain any   ${errormessage}    PriceDetermined    ManualOverrideRequired
                should contain    ${list}[0]    SUCCESS
            END
        END
        save excel document    ${PPInputExcelPath}
        ${ListIndexIterator}=    evaluate    ${ListIndexIterator} + int(${1})
        ${RowCounter}=    evaluate    ${RowCounter} + int(${1})
    END
    save excel document    ${PPInputExcelPath}


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
    ${ExcelDictionary}    ReadAllValuesFromPPExcel    ${InputExcel}    PriceProposal
    ${EnvironmentList}    get from dictionary    ${ExcelDictionary}    VIAXEnvironment
    ${ExecutionFlagList}    get from dictionary    ${ExcelDictionary}    ExecutionFlag
    ${JSONFileNameList}    get from dictionary    ${ExcelDictionary}  JSONFileName
    ${JournalIDList}    get from dictionary    ${ExcelDictionary}    JournalID
    ${ScenarioList}    get from dictionary    ${ExcelDictionary}    ScenarioList
    ${DiscountType1List}    get from dictionary    ${ExcelDictionary}   DiscountType1
    ${DiscountType2List}    get from dictionary    ${ExcelDictionary}   DiscountType2
    ${DiscountType3List}    get from dictionary    ${ExcelDictionary}   DiscountType3
    ${DiscountType4List}    get from dictionary    ${ExcelDictionary}   DiscountType4
    ${DiscountType5List}    get from dictionary    ${ExcelDictionary}   DiscountType5
    ${DiscountType6List}    get from dictionary    ${ExcelDictionary}   DiscountType6
    ${DiscountCondition1List}   get from dictionary     ${ExcelDictionary}    DiscountCondition1
    ${DiscountCondition2List}   get from dictionary     ${ExcelDictionary}  DiscouontCondition2
    ${DiscountCondition3List}   get from dictionary     ${ExcelDictionary}  DiscountCondition3
    ${DiscountCondition4List}   get from dictionary     ${ExcelDictionary}  DiscountCondition4
    ${DiscountCondition5List}   get from dictionary     ${ExcelDictionary}  DiscountCondition5
    ${DiscountCondition6List}   get from dictionary     ${ExcelDictionary}  DiscountCondition6
    ${DiscountPercentage1List}  get from dictionary  ${ExcelDictionary}     DiscountPercentage1
    ${DiscountPercentage2List}  get from dictionary     ${ExcelDictionary}      DiscountPercentage2
    ${DiscountPercentage3List}  get from dictionary     ${ExcelDictionary}      DiscountPercentage3
    ${DiscountPercentage4List}  get from dictionary  ${ExcelDictionary}     DiscountPercentage4
    ${DiscountPercentage5List}  get from dictionary  ${ExcelDictionary}     DiscountPercentage5
    ${DiscountPercentage6List}  get from dictionary  ${ExcelDictionary}     DiscountPercentage6
    ${AppliedYes1List}      get from dictionary      ${ExcelDictionary}     AppliedYes1
    ${AppliedYes2List}      get from dictionary     ${ExcelDictionary}      AppliedYes2
    ${AppliedYes3List}      get from dictionary      ${ExcelDictionary}     AppliedYes3
    ${AppliedYes4List}      get from dictionary      ${ExcelDictionary}     AppliedYes4
    ${AppliedYes5List}      get from dictionary      ${ExcelDictionary}     AppliedYes5
    ${AppliedYes6List}      get from dictionary      ${ExcelDictionary}     AppliedYes6

#    ${InvoicedStatusList}    get from dictionary    ${ExcelDictionary}    FecthInvoiceStatus
    set suite variable    ${EnvironmentList}    ${EnvironmentList}
    set suite variable   ${JournalIDList}   ${JournalIDList}
    set suite variable    ${ExecutionFlagList}    ${ExecutionFlagList}
    set suite variable    ${JSONFileNameList}    ${JSONFileNameList}
    set suite variable    ${ScenarioList}    ${ScenarioList}
    set suite variable    ${DiscountType1List}   ${DiscountType1List}
    set suite variable    ${DiscountType2List}   ${DiscountType2List}
    set suite variable    ${DiscountType3List}   ${DiscountType3List}
    set suite variable    ${DiscountType4List}   ${DiscountType4List}
    set suite variable    ${DiscountType5List}   ${DiscountType5List}
    set suite variable    ${DiscountType6List}   ${DiscountType6List}

    set suite variable    ${DiscountCondition1List}   ${DiscountCondition1List}
    set suite variable    ${DiscountCondition2List}   ${DiscountCondition2List}
    set suite variable    ${DiscountCondition3List}   ${DiscountCondition3List}
    set suite variable    ${DiscountCondition4List}   ${DiscountCondition4List}
    set suite variable    ${DiscountCondition5List}   ${DiscountCondition5List}
    set suite variable    ${DiscountCondition6List}   ${DiscountCondition6List}

    set suite variable    ${DiscountPercentage1List}   ${DiscountPercentage1List}
    set suite variable    ${DiscountPercentage2List}  ${DiscountPercentage2List}
    set suite variable    ${DiscountPercentage3List}  ${DiscountPercentage3List}
    set suite variable    ${DiscountPercentage4List}  ${DiscountPercentage4List}
    set suite variable    ${DiscountPercentage5List}  ${DiscountPercentage5List}
    set suite variable    ${DiscountPercentage6List}  ${DiscountPercentage6List}

    set suite variable    ${AppliedYes1List}    ${AppliedYes1List}
    set suite variable    ${AppliedYes2List}       ${AppliedYes2List}
    set suite variable    ${AppliedYes3List}       ${AppliedYes3List}
    set suite variable    ${AppliedYes4List}       ${AppliedYes4List}
    set suite variable    ${AppliedYes5List}       ${AppliedYes5List}
    set suite variable    ${AppliedYes6List}       ${AppliedYes6List}
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
    Run Keyword If    '${value}' == 'QA3'    set suite variable    ${PPURL}     https://wileyas.qa3.viax.io/price-proposals
    Run Keyword If    '${value}' == 'QA3'    set suite variable    ${GraphqlURL}      https://api.wileyas.qa3.viax.io/graphql
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
#     Launch and Login DBS    ${PPURL}    ${username}    ${password}
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
    ${LoginCheck}=    run keyword and return status    element text should be    //*[@id="kc-page-title"]    Sign In
    IF    '${LoginCheck}' == 'True'
        Launch and Login DBS    ${PPURL}    ${username}    ${password}
        sleep    5s
    END


getdate
    [Arguments]   ${date_format}
    ${Formatted_Date}       Get Current Date     result_format=${date_format}
    RETURN       ${Formatted_Date}

