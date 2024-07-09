*** Settings ***
Resource    ../Resource/ObjectRepositories/CustomVariables.robot
Library    CustomLib.py
Library    Response.py
Suite Setup     Open Excel and DBS    ${PPInputExcelPath}    ${QA2_Viax}    ${username}    ${password}
Suite Teardown   Close Excel and Browser
Test Setup    ReLaunch DBS    ${PPURL}    ${username}    ${password}


*** Variables ***
${file}    \\UploadExcel\\JsonTemplates\\
${SubId}    24ef<<RandomNum>>-<<Randomt3digit>>b-4808-9127-af8e42410<<RandonDynId>>
${QA2_Viax}     https://wileyas.qa2.viax.io/price-proposals
${QA2_Graphql}    https://api.wileyas.stage.viax.io/graphql
${PPInputExcelPath}    ${execdir}\\UploadExcel\\TD_Inputs.xlsx

*** Test Cases ***

Create PP with Society discount
    [Tags]    id=NC_OP_01
    log to console    ${PPInputExcelPath}
    ${ListIndexIterator}    set variable    0
    ${DataIndexIterator}    set variable    0
    ${JournalIDCount}=    get length    ${JournalIDList}
    ${RowCounter}    set variable    2
#    open sap logon window    ${SAPGUIPATH}    ${SAPUSERNAME}    ${SAPPASSWORD}    ${ENTERBUTTON}    ${CONNECTION}    ${continuebutton}
#    Launch and Login DBS    ${QA2_Viax}    ${username}    ${password}
    FOR    ${ScenarioIterator}    IN RANGE    ${JournalIDCount}
        ${ExecutionFlag}=    get from list    ${ExecutionFlagList}    ${ListIndexIterator}
        ${ScenarioName}=    get from list    ${ScenarioList}   ${ListIndexIterator}
        IF    '${ScenarioName}' == 'Create PP with Society discount'
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
#                ${json_dict}=  Evaluate  json.loads('''${list}[0]WileyPromoCode''')  modules=json
#                ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
                ${error_code}=  Set Variable  ${json_dict['message']}
                ${OrderID}=  Set Variable  ${json_dict['priceProposal']['biId']}
                ${error_code}=    convert to string    ${error_code}
                ${OrderStatus}=    convert to string    ${OrderID}
                Write Output Excel    PriceProposal    OrderStatus    ${RowCounter}    ${error_code}
                Write Output Excel    PriceProposal    OrderID    ${RowCounter}    ${OrderID}
                ${errormessage}=    set variable    ${json_dict['priceProposal']['bpStatus']['code']}
                ${errormessage}=    convert to string    ${errormessage}
                should contain any   ${errormessage}    PriceDetermined    ManualOverrideRequired

                SeleniumLibrary.input text    ${SearchBox}   ${OrderId}
                sleep    5s
                seleniumlibrary.click element    //*[@title="#${OrderID}"]
                sleep    5s
                ${UIStatus}=    SeleniumLibrary.get text    //*[@class="x-order-details__status-wrapper"]
                ${Typeofpayment}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//span)[1]
                should be equal    ${UIStatus}    PRICE DETERMINED
                should be equal    ${Typeofpayment}    AuthorPaid
#                ${elementid}=    Get WebElement    //*[@class="x-icon x-accordion__icon"]
#                ${CheckArrowbutton}=  run keyword and return status    element should be present    ${elementid}
#                IF    '${CheckArrowbutton}' == 'True'
                    seleniumlibrary.click element    //*[@class="x-icon x-accordion__icon"]
#                END
                ${Discounttype1}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[1]/td[1])[1]
                should be equal    ${Discounttype1}    ArticleType
                ${Discounttype2}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[2]/td[1])[1]
                should be equal    ${Discounttype2}    Society
                ${DisountCondition1}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[1]/td[2])[1]
                should be equal    ${DisountCondition1}    Research Article
                ${DisountCondition2}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[2]/td[2])[1]
                should be equal    ${DisountCondition2}    JCASP
                ${Percentagevalue1}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[1]/td[3])[1]
                should be equal    ${Percentagevalue1}    75%
                ${Percentagevalue2}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[2]/td[3])[1]
                should be equal    ${Percentagevalue2}    5%
                ${AppliedYes1}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[1]/td[6])[1]
                should be equal    ${AppliedYes1}    Yes
                ${AppliedYes2}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[2]/td[6])[1]
                should be equal    ${AppliedYes2}    Yes
                ${TaxValue}=    SeleniumLibrary.get text    //*[contains(@id,"single-spa-application:parcel")]/div/div/div/div[6]/div[2]
                ${TaxValue}=    replace string    ${TaxValue}    ${SPACE}    ${EMPTY}
                should be equal    ${TaxValue}    0.00USD

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
        END
        save excel document    ${PPInputExcelPath}
        ${ListIndexIterator}=    evaluate    ${ListIndexIterator} + int(${1})
        ${RowCounter}=    evaluate    ${RowCounter} + int(${1})
    END
    save excel document    ${PPInputExcelPath}

Create PP with Promotional discount
    [Tags]    id=NC_OP_02
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
                ${OrderID}=  Set Variable  ${json_dict['priceProposal']['biId']}
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

                SeleniumLibrary.input text    ${SearchBox}   ${OrderId}
                sleep    5s
                seleniumlibrary.click element    //*[@title="#${OrderID}"]
                sleep    5s
               ${UIStatus}=    SeleniumLibrary.get text    //*[@class="x-order-details__status-wrapper"]
                ${Typeofpayment}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//span)[1]
                should be equal    ${UIStatus}    PRICE DETERMINED
                should be equal    ${Typeofpayment}    AuthorPaid
                seleniumlibrary.click element    //*[@class="x-icon x-accordion__icon"]
                ${Discounttype1}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[1]/td[1])[1]
                should be equal    ${Discounttype1}    ArticleType
                ${Discounttype2}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[2]/td[1])[1]
                should be equal    ${Discounttype2}    WileyPromoCode
               ${DisountCondition1}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[1]/td[2])[1]
               should be equal    ${DisountCondition1}    Research Article
                ${DisountCondition2}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[2]/td[2])[1]
                should be equal    ${DisountCondition2}    PROMO50
                ${Percentagevalue1}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[1]/td[3])[1]
                should be equal    ${Percentagevalue1}    75%
                ${Percentagevalue2}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[2]/td[3])[1]
                should be equal    ${Percentagevalue2}    20%
                ${AppliedYes1}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[1]/td[6])[1]
                should be equal    ${AppliedYes1}    Yes
                ${AppliedYes2}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[2]/td[6])[1]
                should be equal    ${AppliedYes2}    Yes
                ${TaxValue}=    SeleniumLibrary.get text    //*[contains(@id,"single-spa-application:parcel")]/div/div/div/div[6]/div[2]
                log to console  ${TaxValue}
                ${TaxValue}=    replace string    ${TaxValue}    ${SPACE}    ${EMPTY}
                should be equal    ${TaxValue}    0.00USD


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


Create PP with Institutional discount
    [Tags]    id=NC_OP_03
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
                ${OrderID}=  Set Variable  ${json_dict['priceProposal']['biId']}
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

                SeleniumLibrary.input text    ${SearchBox}   ${OrderId}
                sleep    5s
                seleniumlibrary.click element    //*[@title="#${OrderID}"]
                sleep    5s
               ${UIStatus}=    SeleniumLibrary.get text    //*[@class="x-order-details__status-wrapper"]
                ${Typeofpayment}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//span)[1]
                should be equal    ${UIStatus}    PRICE DETERMINED
                should be equal    ${Typeofpayment}    AuthorPaid
                seleniumlibrary.click element    //*[@class="x-icon x-accordion__icon"]
                ${Discounttype1}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[1]/td[1])[1]
                should be equal    ${Discounttype1}    ArticleType
                ${Discounttype2}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[2]/td[1])[1]
                should be equal    ${Discounttype2}    Institutional
               ${DisountCondition1}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[1]/td[2])[1]
               should be equal    ${DisountCondition1}    Research Article
                ${DisountCondition2}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[2]/td[2])[1]
                should be equal    ${DisountCondition2}    E O Lawrence Berkeley National Laboratory
                ${Percentagevalue1}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[1]/td[3])[1]
                should be equal    ${Percentagevalue1}    75%
                ${Percentagevalue2}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[2]/td[3])[1]
                should be equal    ${Percentagevalue2}  NA
                ${AppliedYes1}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[1]/td[6])[1]
                should be equal    ${AppliedYes1}    Yes
                ${AppliedYes2}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[2]/td[6])[1]
                should be equal    ${AppliedYes2}    Yes
                ${TaxValue}=    SeleniumLibrary.get text    //*[contains(@id,"single-spa-application:parcel")]/div/div/div/div[6]/div[2]
                log to console  ${TaxValue}
                ${TaxValue}=    replace string    ${TaxValue}    ${SPACE}    ${EMPTY}
                should be equal    ${TaxValue}    0.00USD

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


Create PP with Editorial discount
    [Tags]    id=NC_OP_04
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
                ${OrderID}=  Set Variable  ${json_dict['priceProposal']['biId']}
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

                SeleniumLibrary.input text    ${SearchBox}   ${OrderId}
                sleep    5s
                seleniumlibrary.click element    //*[@title="#${OrderID}"]
                sleep    5s
               ${UIStatus}=    SeleniumLibrary.get text    //*[@class="x-order-details__status-wrapper"]
                ${Typeofpayment}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//span)[1]
                should be equal    ${UIStatus}    PRICE DETERMINED
                should be equal    ${Typeofpayment}    AuthorPaid
                seleniumlibrary.click element    //*[@class="x-icon x-accordion__icon"]
                ${Discounttype1}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[1]/td[1])[1]
                should be equal    ${Discounttype1}    ArticleType
                ${Discounttype2}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[2]/td[1])[1]
                should be equal    ${Discounttype2}    EditorialDiscount
               ${DisountCondition1}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[1]/td[2])[1]
               should be equal    ${DisountCondition1}    OPINION
                ${DisountCondition2}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[2]/td[2])[1]
                should be equal    ${DisountCondition2}    CCCAM424
                ${Percentagevalue1}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[1]/td[3])[1]
                should be equal    ${Percentagevalue1}    20%
                ${Percentagevalue2}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[2]/td[3])[1]
                should be equal    ${Percentagevalue2}  90%
                ${AppliedYes1}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[1]/td[6])[1]
                should be equal    ${AppliedYes1}    Yes
                ${AppliedYes2}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[2]/td[6])[1]
                should be equal    ${AppliedYes2}    Yes
                ${TaxValue}=    SeleniumLibrary.get text    //*[contains(@id,"single-spa-application:parcel")]/div/div/div/div[6]/div[2]
                log to console  ${TaxValue}
                ${TaxValue}=    replace string    ${TaxValue}    ${SPACE}    ${EMPTY}
                should be equal    ${TaxValue}    0.00USD


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
    [Tags]    id=NC_OP_05
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
                ${OrderID}=  Set Variable  ${json_dict['priceProposal']['biId']}
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
                SeleniumLibrary.input text    ${SearchBox}   ${OrderId}
                sleep    5s
                seleniumlibrary.click element    //*[@title="#${OrderID}"]
                sleep    5s
               ${UIStatus}=    SeleniumLibrary.get text    //*[@class="x-order-details__status-wrapper"]
                ${Typeofpayment}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//span)[1]
                should be equal    ${UIStatus}    PRICE DETERMINED
                should be equal    ${Typeofpayment}    AuthorPaid
                seleniumlibrary.click element    //*[@class="x-icon x-accordion__icon"]
                ${Discounttype1}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[1]/td[1])[1]
                should be equal    ${Discounttype1}    ArticleType
                ${Discounttype2}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[2]/td[1])[1]
                should be equal    ${Discounttype2}    ReferralDiscount
               ${DisountCondition1}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[1]/td[2])[1]
               should be equal    ${DisountCondition1}    Research Article
#                ${DisountCondition2}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[2]/td[2])[1]
#                should be equal    ${DisountCondition2}    E O Lawrence Berkeley National Laboratory
                ${Percentagevalue1}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[1]/td[3])[1]
                should be equal    ${Percentagevalue1}    10%
                ${Percentagevalue2}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[2]/td[3])[1]
                should be equal    ${Percentagevalue2}  15.25%
                ${AppliedYes1}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[1]/td[6])[1]
                should be equal    ${AppliedYes1}    Yes
                ${AppliedYes2}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[2]/td[6])[1]
                should be equal    ${AppliedYes2}    Yes
                ${TaxValue}=    SeleniumLibrary.get text    //*[contains(@id,"single-spa-application:parcel")]/div/div/div/div[6]/div[2]
                log to console  ${TaxValue}
                ${TaxValue}=    replace string    ${TaxValue}    ${SPACE}    ${EMPTY}
                should be equal    ${TaxValue}    0.00USD


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
    [Tags]    id=NC_OP_06
    ${ListIndexIterator}    set variable    0
    ${DataIndexIterator}    set variable    0
    ${JournalIDCount}=    get length    ${JournalIDList}
    ${RowCounter}    set variable    2
#    open sap logon window    ${SAPGUIPATH}    ${SAPUSERNAME}    ${SAPPASSWORD}    ${ENTERBUTTON}    ${CONNECTION}    ${continuebutton}
#    Launch and Login DBS    ${QA2_Viax}    ${username}    ${password}
    FOR    ${ScenarioIterator}    IN RANGE    ${JournalIDCount}
        ${ExecutionFlag}=    get from list    ${ExecutionFlagList}    ${ListIndexIterator}
        ${ScenarioName}=    get from list    ${ScenarioList}   ${ListIndexIterator}
        IF    '${ScenarioName}' == 'Create PP with Geographical discount'
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
                ${OrderID}=  Set Variable  ${json_dict['priceProposal']['biId']}
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

                SeleniumLibrary.input text    ${SearchBox}   ${OrderId}
                sleep    5s
                seleniumlibrary.click element    //*[@title="#${OrderID}"]
                sleep    5s
               ${UIStatus}=    SeleniumLibrary.get text    //*[@class="x-order-details__status-wrapper"]
                ${Typeofpayment}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//span)[1]
                should be equal    ${UIStatus}    PRICE DETERMINED
                should be equal    ${Typeofpayment}    AuthorPaid
                seleniumlibrary.click element    //*[@class="x-icon x-accordion__icon"]
                ${Discounttype1}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[1]/td[1])[1]
                should be equal    ${Discounttype1}    ArticleType
                ${Discounttype2}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[2]/td[1])[1]
                should be equal    ${Discounttype2}    GeographicalDiscount
               ${DisountCondition1}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[1]/td[2])[1]
               should be equal    ${DisountCondition1}    Research Article
                ${DisountCondition2}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[2]/td[2])[1]
                should be equal    ${DisountCondition2}   MH - Marshall Islands
                ${Percentagevalue1}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[1]/td[3])[1]
                should be equal    ${Percentagevalue1}    30%
                ${Percentagevalue2}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[2]/td[3])[1]
                should be equal    ${Percentagevalue2}  100%
                ${AppliedYes1}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[1]/td[6])[1]
                should be equal    ${AppliedYes1}    Yes
                ${AppliedYes2}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[2]/td[6])[1]
                should be equal    ${AppliedYes2}    Yes
                ${TaxValue}=    SeleniumLibrary.get text    //*[contains(@id,"single-spa-application:parcel")]/div/div/div/div[6]/div[2]
                log to console  ${TaxValue}
                ${TaxValue}=    replace string    ${TaxValue}    ${SPACE}    ${EMPTY}
                should be equal    ${TaxValue}    0.00USD


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
    [Tags]    id=NC_OP_07
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
                ${OrderID}=  Set Variable  ${json_dict['priceProposal']['biId']}
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
                SeleniumLibrary.input text    ${SearchBox}   ${OrderId}
                sleep    5s
                seleniumlibrary.click element    //*[@title="#${OrderID}"]
                sleep    5s
               ${UIStatus}=    SeleniumLibrary.get text    //*[@class="x-order-details__status-wrapper"]
                ${Typeofpayment}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//span)[1]
                should be equal    ${UIStatus}    PRICE DETERMINED
                should be equal    ${Typeofpayment}    AuthorPaid
                ${Discounttype1}=    SeleniumLibrary.get text   //*[contains(@id,"single-spa-application:parcel")]/div/div/div/div[2]/table/tbody/tr/td[1]
                should be equal    ${Discounttype1}    ArticleType
                ${DisountCondition1}=    SeleniumLibrary.get text    //*[contains(@id,"single-spa-application:parcel")]/div/div/div/div[2]/table/tbody/tr/td[2]
                should be equal    ${DisountCondition1}    RESEARCH ARTICLE
                ${Percentagevalue1}=    SeleniumLibrary.get text    //*[contains(@id,"single-spa-application:parcel")]/div/div/div/div[2]/table/tbody/tr/td[3]
                should be equal    ${Percentagevalue1}    75%
                ${AppliedYes1}=    SeleniumLibrary.get text    //*[contains(@id,"single-spa-application:parcel")]/div/div/div/div[2]/table/tbody/tr/td[5]
                should be equal    ${AppliedYes1}    Yes
#                ${TaxValue}=    SeleniumLibrary.get text    //*[contains(@id,"single-spa-application:parcel")]/div/div/div/div[6]/div[2]
##                ${TaxValue}=    replace string    ${TaxValue}    ${SPACE}    ${EMPTY}
#                should be equal    ${TaxValue}    0.00USD
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
    [Tags]    id=NC_OP_08
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
                ${OrderID}=  Set Variable  ${json_dict['priceProposal']['biId']}
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

                SeleniumLibrary.input text    ${SearchBox}   ${OrderId}
                sleep    5s
                seleniumlibrary.click element    //*[@title="#${OrderID}"]
                sleep    5s
                ${UIStatus}=    SeleniumLibrary.get text    //*[@class="x-order-details__status-wrapper"]
                ${Typeofpayment}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//span)[1]
                should be equal    ${UIStatus}    PRICE DETERMINED
                should be equal    ${Typeofpayment}    AuthorPaid
#                ${elementid}=    Get WebElement    //*[@class="x-icon x-accordion__icon"]
#                ${CheckArrowbutton}=  run keyword and return status    element should be present    ${elementid}
#                IF    '${CheckArrowbutton}' == 'True'
                    seleniumlibrary.click element    //*[@class="x-icon x-accordion__icon"]
#                END
                ${Discounttype1}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[1]/td[1])[1]
                should be equal    ${Discounttype1}    ArticleType
                ${Discounttype2}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[2]/td[1])[1]
                should be equal    ${Discounttype2}    Institutional
                ${DisountCondition1}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[1]/td[2])[1]
                should be equal    ${DisountCondition1}    Research Article
                ${DisountCondition2}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[2]/td[2])[1]
                should be equal    ${DisountCondition2}    E O Lawrence Berkeley National Laboratory
                ${Percentagevalue1}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[1]/td[3])[1]
                should be equal    ${Percentagevalue1}    75%
                ${Percentagevalue2}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[2]/td[3])[1]
                should be equal    ${Percentagevalue2}    NA
                ${AppliedYes1}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[1]/td[6])[1]
                should be equal    ${AppliedYes1}    Yes
                ${AppliedYes2}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[2]/td[6])[1]
                should be equal    ${AppliedYes2}    Yes
                ${TaxValue}=    SeleniumLibrary.get text    //*[contains(@id,"single-spa-application:parcel")]/div/div/div/div[6]/div[2]
                ${TaxValue}=    replace string    ${TaxValue}    ${SPACE}    ${EMPTY}
                should be equal    ${TaxValue}    0.00GBP


#        should contain  ${check}  True
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
    [Tags]    id=NC_OP_09
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
                ${OrderID}=  Set Variable  ${json_dict['priceProposal']['biId']}
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

                SeleniumLibrary.input text    ${SearchBox}   ${OrderId}
                sleep    5s
                seleniumlibrary.click element    //*[@title="#${OrderID}"]
                sleep    5s
                ${UIStatus}=    SeleniumLibrary.get text    //*[@class="x-order-details__status-wrapper"]
                ${Typeofpayment}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//span)[1]
                should be equal    ${UIStatus}    PRICE DETERMINED
                should be equal    ${Typeofpayment}    AuthorPaid
                seleniumlibrary.click element    //*[@class="x-icon x-accordion__icon"]
                ${Discounttype1}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[1]/td[1])[1]
                should be equal    ${Discounttype1}    ArticleType
                ${Discounttype2}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[2]/td[1])[1]
                should be equal    ${Discounttype2}    WileyPromoCode
                ${Discounttype3}=    SeleniumLibrary.get text    //*[contains(@id,"single-spa-application:parcel-59")]/div/div/div/div[4]/div/div/div[2]/div/table/tbody/tr[3]/td[1]
                should be equal    ${Discounttype3}    Society
                ${DisountCondition1}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[1]/td[2])[1]
                should be equal    ${DisountCondition1}    Research Article
                ${DisountCondition2}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[2]/td[2])[1]
                should be equal    ${DisountCondition2}    PROMO50
                ${DisountCondition3}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[3]/td[2])[1]
                should be equal    ${DisountCondition3}    JCASP
                ${Percentagevalue1}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[1]/td[3])[1]
                should be equal    ${Percentagevalue1}    75%
                ${Percentagevalue2}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[2]/td[3])[1]
                should be equal    ${Percentagevalue2}    20%
                ${Percentagevalue3}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[3]/td[3])[1]
                should be equal    ${Percentagevalue3}    5%
                ${AppliedYes1}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[1]/td[6])[1]
                should be equal    ${AppliedYes1}    Yes
                ${AppliedYes2}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[2]/td[6])[1]
                should be equal    ${AppliedYes2}    Yes
                ${AppliedYes3}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[3]/td[6])[1]
                should be equal    ${AppliedYes3}    No
                ${TaxValue}=    SeleniumLibrary.get text    //*[contains(@id,"single-spa-application:parcel")]/div/div/div/div[6]/div[2]
                ${TaxValue}=    replace string    ${TaxValue}    ${SPACE}    ${EMPTY}
                should be equal    ${TaxValue}    0.00USD
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
    [Tags]    id=NC_OP_10
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
                ${OrderID}=  Set Variable  ${json_dict['priceProposal']['biId']}
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

                SeleniumLibrary.input text    ${SearchBox}   ${OrderId}
                sleep    5s
                seleniumlibrary.click element    //*[@title="#${OrderID}"]
                sleep    7s
                ${elemId}=    SeleniumLibrary.Get WebElement    //*[@class="x-order-details__status-wrapper"]
                wait until element is visible    ${elemId}
                ${UIStatus}=    SeleniumLibrary.get text    //*[@class="x-order-details__status-wrapper"]
                ${Typeofpayment}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//span)[1]
                should be equal    ${UIStatus}    PRICE DETERMINED
                should be equal    ${Typeofpayment}    AuthorPaid
                seleniumlibrary.click element    //*[@class="x-icon x-accordion__icon"]
                ${Discounttype1}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[1]/td[1])[1]
                should be equal    ${Discounttype1}    GeographicalDiscount
                ${Discounttype2}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[2]/td[1])[1]
                should be equal    ${Discounttype2}    Society
                 ${DisountCondition1}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[1]/td[2])[1]
                should be equal    ${DisountCondition1}    BO - Bolivia
                ${DisountCondition2}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[2]/td[2])[1]
                should be equal    ${DisountCondition2}    EANM9
                ${Percentagevalue1}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[1]/td[3])[1]
                should be equal    ${Percentagevalue1}    50%
                ${Percentagevalue2}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[2]/td[3])[1]
                should be equal    ${Percentagevalue2}    50%
                ${AppliedYes1}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[1]/td[6])[1]
                should be equal    ${AppliedYes1}    Yes
                ${AppliedYes2}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[2]/td[6])[1]
                should be equal    ${AppliedYes2}    No

                ${TaxValue}=    SeleniumLibrary.get text    //*[contains(@id,"single-spa-application:parcel")]/div/div/div/div[6]/div[2]
                ${TaxValue}=    replace string    ${TaxValue}    ${SPACE}    ${EMPTY}
                should be equal    ${TaxValue}    0.00USD

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
    [Tags]    id=NC_OP_11
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
                ${OrderID}=  Set Variable  ${json_dict['priceProposal']['biId']}
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

                SeleniumLibrary.input text    ${SearchBox}   ${OrderId}
                sleep    5s
                seleniumlibrary.click element    //*[@title="#${OrderID}"]
                sleep    5s
                ${UIStatus}=    SeleniumLibrary.get text    //*[@class="x-order-details__status-wrapper"]
                ${Typeofpayment}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//span)[1]
                should be equal    ${UIStatus}    PRICE DETERMINED
                should be equal    ${Typeofpayment}    AuthorPaid
                seleniumlibrary.click element    //*[@class="x-icon x-accordion__icon"]
                ${Discounttype1}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[1]/td[1])[1]
                should be equal    ${Discounttype1}    ArticleType
                ${Discounttype2}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[2]/td[1])[1]
                should be equal    ${Discounttype2}    EditorialDiscount
                ${Discounttype3}=    SeleniumLibrary.get text    //*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[3]/td[1]
                should be equal    ${Discounttype3}    GeographicalDiscount
                ${Discounttype4}=    SeleniumLibrary.get text    //*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[4]/td[1]
                should be equal    ${Discounttype4}    ReferralDiscount
                ${Discounttype5}=    SeleniumLibrary.get text    //*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[5]/td[1]
                should be equal    ${Discounttype5}    Society
                ${Discounttype5}=    SeleniumLibrary.get text    //*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[6]/td[1]
                should be equal    ${Discounttype5}    WileyPromoCode
                ${DisountCondition1}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[1]/td[2])[1]
                should be equal    ${DisountCondition1}    RESEARCH ARTICLE
                ${DisountCondition2}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[2]/td[2])[1]
                should be equal    ${DisountCondition2}    CCCAM424
                ${DisountCondition3}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[3]/td[2])[1]
                should be equal    ${DisountCondition3}    PE - Peru
#                ${DisountCondition4}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[4]/td[2])[1]
#                should be equal    ${DisountCondition4}
                ${DisountCondition5}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[5]/td[2])[1]
                should be equal    ${DisountCondition5}    JCASP
                ${DisountCondition6}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[6]/td[2])[1]
                should be equal    ${DisountCondition6}    PROMO50
                ${Percentagevalue1}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[1]/td[3])[1]
                should be equal    ${Percentagevalue1}    75%
                ${Percentagevalue2}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[2]/td[3])[1]
                should be equal    ${Percentagevalue2}    90%
                ${Percentagevalue3}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[3]/td[3])[1]
                should be equal    ${Percentagevalue3}    50%
                ${Percentagevalue4}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[4]/td[3])[1]
                should be equal    ${Percentagevalue4}    50%
                ${Percentagevalue5}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[5]/td[3])[1]
                should be equal    ${Percentagevalue5}    5%
                ${Percentagevalue6}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[6]/td[3])[1]
                should be equal    ${Percentagevalue6}    20%
                ${AppliedYes1}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[1]/td[6])[1]
                should be equal    ${AppliedYes1}    Yes
                ${AppliedYes2}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[2]/td[6])[1]
                should be equal    ${AppliedYes2}    Yes
                ${AppliedYes3}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[3]/td[6])[1]
                should be equal    ${AppliedYes3}    No
                ${AppliedYes4}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[4]/td[6])[1]
                should be equal    ${AppliedYes4}    No
                ${AppliedYes5}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[5]/td[6])[1]
                should be equal    ${AppliedYes5}    No
                ${AppliedYes6}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[6]/td[6])[1]
                should be equal    ${AppliedYes6}    No
                ${TaxValue}=    SeleniumLibrary.get text    //*[contains(@id,"single-spa-application:parcel")]/div/div/div/div[6]/div[2]
                ${TaxValue}=    replace string    ${TaxValue}    ${SPACE}    ${EMPTY}
                should be equal    ${TaxValue}    0.00USD

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
    [Tags]    id=NC_OP_12
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
                ${OrderID}=  Set Variable  ${json_dict['priceProposal']['biId']}
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
                SeleniumLibrary.input text    ${SearchBox}   ${OrderId}
                sleep    5s
                seleniumlibrary.click element    //*[@title="#${OrderID}"]
                sleep    5s
                ${UIStatus}=    SeleniumLibrary.get text    //*[@class="x-order-details__status-wrapper"]
                ${Typeofpayment}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//span)[1]
                should be equal    ${UIStatus}    PRICE DETERMINED
                should be equal    ${Typeofpayment}    AuthorPaid
#                seleniumlibrary.click element    //*[@class="x-icon x-accordion__icon"]
#                ${Discounttype1}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[1]/td[1])[1]
#                should be equal    ${Discounttype1}    GeographicalDiscount
#                ${Discounttype2}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[2]/td[1])[1]
#                should be equal    ${Discounttype2}    Society
#                 ${DisountCondition1}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[1]/td[2])[1]
#                should be equal    ${DisountCondition1}    BO - Bolivia
#                ${DisountCondition2}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[2]/td[2])[1]
#                should be equal    ${DisountCondition2}    EANM9
#                ${Percentagevalue1}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[1]/td[3])[1]
#                should be equal    ${Percentagevalue1}    50%
#                ${Percentagevalue2}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[2]/td[3])[1]
#                should be equal    ${Percentagevalue2}    50%
#                ${AppliedYes1}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[1]/td[6])[1]
#                should be equal    ${AppliedYes1}    Yes
#                ${AppliedYes2}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[2]/td[6])[1]
#                should be equal    ${AppliedYes2}    No
#
#                ${TaxValue}=    SeleniumLibrary.get text    //*[contains(@id,"single-spa-application:parcel")]/div/div/div/div[6]/div[2]
#                ${TaxValue}=    replace string    ${TaxValue}    ${SPACE}    ${EMPTY}
#                should be equal    ${TaxValue}    0.00USD
#
#

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
    [Tags]    id=NC_OP_13
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
                ${OrderID}=  Set Variable  ${json_dict['priceProposal']['biId']}
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

                SeleniumLibrary.input text    ${SearchBox}   ${OrderId}
                sleep    5s
                seleniumlibrary.click element    //*[@title="#${OrderID}"]
                sleep    5s
               ${UIStatus}=    SeleniumLibrary.get text    //*[@class="x-order-details__status-wrapper"]
                ${Typeofpayment}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//span)[1]
                should be equal    ${UIStatus}    PRICE DETERMINED
                should be equal    ${Typeofpayment}    FunderPaid

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
    [Tags]    id=NC_OP_14
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
                ${OrderID}=  Set Variable  ${json_dict['priceProposal']['biId']}
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

                SeleniumLibrary.input text    ${SearchBox}   ${OrderId}
                sleep    5s
                seleniumlibrary.click element    //*[@title="#${OrderID}"]
                sleep    5s
                ${UIStatus}=    SeleniumLibrary.get text    //*[@class="x-order-details__status-wrapper"]
                ${Typeofpayment}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//span)[1]
                should be equal    ${UIStatus}    DATA CORRECTION REQUIRED
                should be equal    ${Typeofpayment}    Undefined
                seleniumlibrary.click element    //*[@class="x-icon x-accordion__icon"]
                ${Discounttype1}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[1]/td[1])[1]
                should be equal    ${Discounttype1}    ArticleType
                ${Discounttype2}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[2]/td[1])[1]
                should be equal    ${Discounttype2}    WileyPromoCode
                 ${DisountCondition1}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[1]/td[2])[1]
                should be equal    ${DisountCondition1}    Research Article
                ${DisountCondition2}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[2]/td[2])[1]
                should be equal    ${DisountCondition2}    PRKMO50
                ${Percentagevalue1}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[1]/td[3])[1]
                should be equal    ${Percentagevalue1}    75%
                ${Percentagevalue2}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[2]/td[3])[1]
                should be equal    ${Percentagevalue2}    NA
                ${AppliedYes1}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[1]/td[6])[1]
                should be equal    ${AppliedYes1}    Yes
                ${AppliedYes2}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[2]/td[6])[1]
                should be equal    ${AppliedYes2}    No

                ${TaxValue}=    SeleniumLibrary.get text    //*[contains(@id,"single-spa-application:parcel")]/div/div/div/div[6]/div[2]
                ${TaxValue}=    replace string    ${TaxValue}    ${SPACE}    ${EMPTY}
                should be equal    ${TaxValue}    0.00USD


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
    [Tags]    id=NC_OP_15
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
                ${OrderID}=  Set Variable  ${json_dict['priceProposal']['biId']}
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

                SeleniumLibrary.input text    ${SearchBox}   ${OrderId}
                sleep    5s
                seleniumlibrary.click element    //*[@title="#${OrderID}"]
                sleep    5s
                ${UIStatus}=    SeleniumLibrary.get text    //*[@class="x-order-details__status-wrapper"]
                ${Typeofpayment}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//span)[1]
                should be equal    ${UIStatus}    MANUAL OVERRIDE REQUIRED
                should be equal    ${Typeofpayment}    Undefined
                ${Discounttype1}=    SeleniumLibrary.get text   //*[contains(@id,"single-spa-application:parcel")]/div/div/div/div[2]/table/tbody/tr/td[1]
                should be equal    ${Discounttype1}    ArticleType
                ${DisountCondition1}=    SeleniumLibrary.get text    //*[contains(@id,"single-spa-application:parcel")]/div/div/div/div[2]/table/tbody/tr/td[2]
                should be equal    ${DisountCondition1}    Research Article
                ${Percentagevalue1}=    SeleniumLibrary.get text    //*[contains(@id,"single-spa-application:parcel")]/div/div/div/div[2]/table/tbody/tr/td[3]
                should be equal    ${Percentagevalue1}    75%
                ${AppliedYes1}=    SeleniumLibrary.get text    //*[contains(@id,"single-spa-application:parcel")]/div/div/div/div[2]/table/tbody/tr/td[5]
                should be equal    ${AppliedYes1}    Yes

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
    [Tags]    id=NC_OP_16
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
                ${OrderID}=  Set Variable  ${json_dict['priceProposal']['biId']}
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
                SeleniumLibrary.input text    ${SearchBox}   ${OrderId}
                sleep    5s
                seleniumlibrary.click element    //*[@title="#${OrderID}"]
                sleep    5s
                ${UIStatus}=    SeleniumLibrary.get text    //*[@class="x-order-details__status-wrapper"]
                ${Typeofpayment}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//span)[1]
                should be equal    ${UIStatus}    DATA CORRECTION REQUIRED
                should be equal    ${Typeofpayment}    Undefined
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
    [Tags]    id=NC_OP_17
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
                ${OrderID}=  Set Variable  ${json_dict['priceProposal']['biId']}
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
                SeleniumLibrary.input text    ${SearchBox}   ${OrderId}
                sleep    5s
                seleniumlibrary.click element    //*[@title="#${OrderID}"]
                sleep    5s
                ${UIStatus}=    SeleniumLibrary.get text    //*[@class="x-order-details__status-wrapper"]
                ${Typeofpayment}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//span)[1]
                should be equal    ${UIStatus}    DATA CORRECTION REQUIRED
                should be equal    ${Typeofpayment}    Undefined
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
    [Tags]    id=NC_OP_18
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
                ${OrderID}=  Set Variable  ${json_dict['priceProposal']['biId']}
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
                SeleniumLibrary.input text    ${SearchBox}   ${OrderId}
                sleep    5s
                seleniumlibrary.click element    //*[@title="#${OrderID}"]
                sleep    5s
                ${UIStatus}=    SeleniumLibrary.get text    //*[@class="x-order-details__status-wrapper"]
                ${Typeofpayment}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//span)[1]
                should be equal    ${UIStatus}    DATA CORRECTION REQUIRED
                should be equal    ${Typeofpayment}    Undefined
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
    [Tags]    id=NC_OP_19
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
                ${OrderID}=  Set Variable  ${json_dict['priceProposal']['biId']}
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
                SeleniumLibrary.input text    ${SearchBox}   ${OrderId}
                sleep    5s
                seleniumlibrary.click element    //*[@title="#${OrderID}"]
                sleep    5s
                ${UIStatus}=    SeleniumLibrary.get text    //*[@class="x-order-details__status-wrapper"]
                ${Typeofpayment}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//span)[1]
                should be equal    ${UIStatus}    RE SEND
                should be equal    ${Typeofpayment}    Undefined
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
    [Tags]    id=NC_OP_20
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
                ${OrderID}=  Set Variable  ${json_dict['priceProposal']['biId']}
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
                SeleniumLibrary.input text    ${SearchBox}   ${OrderId}
                sleep    5s
                seleniumlibrary.click element    //*[@title="#${OrderID}"]
                sleep    5s
                ${UIStatus}=    SeleniumLibrary.get text    //*[@class="x-order-details__status-wrapper"]
                ${Typeofpayment}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//span)[1]
                should be equal    ${UIStatus}    RE SEND
                should be equal    ${Typeofpayment}    Undefined
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
    [Tags]    id=NC_OP_21
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
#                ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
#                ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
                ${error_code}=  Set Variable  ${json_dict['message']}
                ${OrderID}=  Set Variable  ${json_dict['priceProposal']['biId']}
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
                SeleniumLibrary.input text    ${SearchBox}   ${OrderId}
                sleep    5s
                seleniumlibrary.click element    //*[@title="#${OrderID}"]
                sleep    5s
                ${UIStatus}=    SeleniumLibrary.get text    //*[@class="x-order-details__status-wrapper"]
                ${Typeofpayment}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//span)[1]
                should be equal    ${UIStatus}    RE SEND
                should be equal    ${Typeofpayment}    Undefined
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
    RETURN    ${json_content}


Read All Input Values From PPExcel
    [Arguments]    ${InputExcel}
    ${ExcelDictionary}    ReadAllValuesFromPPExcel    ${InputExcel}    PriceProposal
    ${EnvironmentList}    get from dictionary    ${ExcelDictionary}    VIAXEnvironment
    ${ExecutionFlagList}    get from dictionary    ${ExcelDictionary}    ExecutionFlag
    ${JSONFileNameList}    get from dictionary    ${ExcelDictionary}  JSONFileName
    ${JournalIDList}    get from dictionary    ${ExcelDictionary}    JournalID
    ${ScenarioList}    get from dictionary    ${ExcelDictionary}    ScenarioList
#    ${InvoicedStatusList}    get from dictionary    ${ExcelDictionary}    FecthInvoiceStatus
    set suite variable    ${EnvironmentList}    ${EnvironmentList}
    set suite variable   ${JournalIDList}   ${JournalIDList}
    set suite variable    ${ExecutionFlagList}    ${ExecutionFlagList}
    set suite variable    ${JSONFileNameList}    ${JSONFileNameList}
    set suite variable    ${ScenarioList}    ${ScenarioList}
#    set suite variable    ${OrderIDList}    ${OrderIDList}
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
    ${LoginCheck}=    run keyword and return status    element text should be    //*[@id="kc-page-title"]    Sign In
    IF    '${LoginCheck}' == 'True'
        Launch and Login DBS    ${PPURL}    ${username}    ${password}
        sleep    5s
    END