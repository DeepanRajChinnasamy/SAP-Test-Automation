*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${OrderId}    8000029806

*** Test Case ***
GetPaymentTerms

    open sap logon window    ${SAPGUIPATH}    ${SAPUSERNAME}    ${SAPPASSWORD}    ${ENTERBUTTON}    ${CONNECTION}    ${continuebutton}
    run transaction    /nVA03
    sapguilibrary.input text    ${Var_OrderIDTextbox}      ${saporderId}
    sapguilibrary.click element    /app/con[0]/ses[0]/wnd[0]/tbar[0]/btn[0]
    sapguilibrary.click element    ${Var_ItemOverview}









#*** Settings ***
#Resource    ../Resource/ObjectRepositories/CustomVariables.robot
#Library    ../TestSuites/CustomLib.py
#Library    ../TestSuites/Response.py
##Suite Setup     Open Excel and DBS    ${PPInputExcelPath}    ${PPURL}    ${username}    ${password}
###Suite Teardown   Close Excel and Browser
###Test Setup    ReLaunch DBS    ${PPURL}    ${username}    ${password}
##
##
#*** Variables ***
##${file}    \\UploadExcel\\JsonTemplates\\
##${SubId}    24ef<<RandomNum>>-<<Randomt3digit>>b-4808-9127-af8e42410<<RandonDynId>>
##${PPURL}     #https://wileyas.qa2.viax.io/price-proposals
##${QA2_Graphql}    https://api.wileyas.stage.viax.io/graphql
##${PPInputExcelPath}    ${execdir}\\UploadExcel\\TD_Inputs.xlsx
#${UITax}    1,990.00 USD
#
#
#*** Test Cases ***

#Create PP with Society discount
#    @{UITaxValue}=    split string    ${UITax}    ${SPACE}
#    ${UITax}=    set variable    ${UITaxValue}[0]
#    ${UITax}=    replace string    ${UITax}    ,    ${EMPTY}
#    log to console    ${UITax}
#    [Tags]    id=NC_OP_01
#    log to console    ${PPInputExcelPath}
#    ${ListIndexIterator}    set variable    0
#    ${DataIndexIterator}    set variable    0
#    ${JournalIDCount}=    get length    ${JournalIDList}
#    ${RowCounter}    set variable    2
#
##    open sap logon window    ${SAPGUIPATH}    ${SAPUSERNAME}    ${SAPPASSWORD}    ${ENTERBUTTON}    ${CONNECTION}    ${continuebutton}
##    Launch and Login DBS    ${QA2_Viax}    ${username}    ${password}
#    FOR    ${ScenarioIterator}    IN RANGE    ${JournalIDCount}
#        ${ExecutionFlag}=    get from list    ${ExecutionFlagList}    ${ListIndexIterator}
#        ${ScenarioName}=    get from list    ${ScenarioList}   ${ListIndexIterator}
#        IF    '${ScenarioName}' == 'Create PP with Society discount'
#            ${JSONFileName}=    get from list    ${JSONFileNameList}    ${ListIndexIterator}
#            ${JsonResp}=     get from list    ${jsonreslist}    ${ListIndexIterator}
#            ${JournalID}=    get from list    ${JournalIDList}    ${ListIndexIterator}
#            ${Environment}=    get from list    ${EnvironmentList}    ${ListIndexIterator}
#            ${discountType1}=  get from list   ${DiscountType1List}   ${ListIndexIterator}
#            ${discountType2}=  get from list   ${DiscountType2List}   ${ListIndexIterator}
#            ${discountcondition1}=  get from list    ${DiscountCondition1List}   ${ListIndexIterator}
#            ${discountcondition2}=  get from list    ${DiscountCondition2List}    ${ListIndexIterator}
#            ${discountpercentage1}=     get from list   ${DiscountPercentage1List}   ${ListIndexIterator}
#            ${discountpercentage2}=     get from list       ${DiscountPercentage2List}  ${ListIndexIterator}
#            ${appliedyes1}=    get from list   ${AppliedYes1List}   ${ListIndexIterator}
#            ${appliedyes2}=  get from list  ${AppliedYes2List}      ${ListIndexIterator}
#            ${json_content}=  Get File  ${execdir}${file}${JSONFileName}.json
##            ${json_content}=    Generate the JSON file PP    ${json_content}    ${JournalID}
##            Write Output Excel    PriceProposal    JSONText    ${RowCounter}    ${json_content}
##            Switch Case    ${Environment}
##            create session    order_session    ${PPURL}    verify=True
##            ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${AuthToken}
##            ${response}=     post on session    order_session    url=${GraphqlURL}     data=${json_content}     headers=${headers}
##            # Getting the content value
##            Log    Status Code: ${response.status_code}
##            Log    Response Content: ${response.content}
##            ${response.status_code}=  convert to string    ${response.status_code}
##            Validate the content and update the excel    200    ${response.status_code}    PriceProposal    ResponseStatusCode    ${RowCounter}
##            set variable    ${response.content}
##            set variable    ${response.json()}
##            ${response_text}=    convert to string    ${response.content}
##            ${response.json()}=    convert to string    ${response.json()}
##            Write Output Excel    PriceProposal    Response    ${RowCounter}    ${response.json()}
##            ${JsonResp}=  Evaluate  ${response.text}
#            # Fetch the values from the result Json File
#            @{list}=     CustomLib.Get Value From Json    ${JsonResp}    $.data.testFunction.data
##            @{list}=    Get Key Value    ${JsonResp}    $.data.testFunction.data
#            log to console    ${JsonResp}
#            ${NumberofList}=    get length    ${list}
#            set variable    ${JsonResp}
#            ${check}=    run keyword and return status    should contain    ${list}[0]    SUCCESS
#            ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
#            ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
##            log to console    ${json_dict}
#            IF    '${check}' == '${True}'
#
#                ${error_code}=  Set Variable  ${json_dict['message']}
#                ${OrderID}=  Set Variable  ${json_dict['priceProposal']['biId']}
#                ${error_code}=    convert to string    ${error_code}
#                ${OrderStatus}=    convert to string    ${OrderID}
#                Write Output Excel    PriceProposal    OrderStatus    ${RowCounter}    ${error_code}
#                Write Output Excel    PriceProposal    OrderID    ${RowCounter}    ${OrderID}
#                ${errormessage}=    set variable    ${json_dict['priceProposal']['bpStatus']['code']}
#                ${submsID}=    set variable    ${json_dict['priceProposal']['wAsPriceProposalPayload']['societyCodes']}
#                ${countrycode}=    set variable    ${json_dict['priceProposal']['wAsPriceProposalPayload']['authors'][0]['affiliations'][0]['countryCode']}
##                ${errormessage}=    convert to string    ${errormessage}
#                ${dis}=    set variable    ${json_dict['wAsDiscountCodes']['discountCode]}
#                log to console    ${dis}
##                should contain any   ${errormessage}    PriceDetermined    ManualOverrideRequired
#
##                SeleniumLibrary.input text    ${SearchBox}   ${OrderId}
##                sleep    5s
##                seleniumlibrary.click element    //*[@title="#${OrderID}"]
##                sleep    5s
##                ${UIStatus}=    SeleniumLibrary.get text    //*[@class="x-order-details__status-wrapper"]
##                ${Typeofpayment}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//span)[1]
##                run keyword and continue on failure    should be equal    ${UIStatus}    PRICE DETERMINED
##                run keyword and continue on failure    should be equal    ${Typeofpayment}    AuthorPaid
##                ${elementid}=    Get WebElement    //*[@class="x-icon x-accordion__icon"]
##                ${CheckArrowbutton}=  run keyword and return status    element should be present    ${elementid}
##                IF    '${CheckArrowbutton}' == 'True'
##                    seleniumlibrary.click element    //*[@class="x-icon x-accordion__icon"]
##                END
##                ${Discounttype1}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[1]/td[1])[1]
##
##                run keyword and continue on failure    should be equal    ${Discounttype1}    ${discountType1}
##                ${Discounttype2}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[2]/td[1])[1]
##                run keyword and continue on failure    should be equal    ${Discounttype2}    ${discountType2}
##                ${DisountCondition1}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[1]/td[2])[1]
##                run keyword and continue on failure    should be equal    ${DisountCondition1}    ${discountcondition1}
##                ${DisountCondition2}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[2]/td[2])[1]
##                run keyword and continue on failure    should be equal    ${DisountCondition2}    ${discountcondition2}
##                ${Percentagevalue1}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[1]/td[3])[1]
##                run keyword and continue on failure    should be equal    ${Percentagevalue1}    ${discountpercentage1}%
##                ${Percentagevalue2}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[2]/td[3])[1]
##                run keyword and continue on failure    should be equal    ${Percentagevalue2}    ${discountpercentage2}%
##                ${AppliedYes1}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[1]/td[6])[1]
##                run keyword and continue on failure    should be equal    ${AppliedYes1}    ${appliedyes1}
##                ${AppliedYes2}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[2]/td[6])[1]
##                run keyword and continue on failure    should be equal    ${AppliedYes2}    ${appliedyes2}
##                ${TaxValue}=    SeleniumLibrary.get text    //*[contains(@id,"single-spa-application:parcel")]/div/div/div/div[6]/div[2]
##                ${TaxValue}=    replace string    ${TaxValue}    ${SPACE}    ${EMPTY}
##                run keyword and continue on failure    should be equal    ${TaxValue}    0.00USD
#
##                IF    '${errormessage}' == 'PriceDetermined' or '${errormessage}' == 'ManualOverrideRequired'
##                    write and color excel    PriceProposal    PriceProposalStatus    ${RowCounter}    ${errormessage}    00FF00
##                    save excel document    ${PPInputExcelPath}
##                ELSE
##                    write and color excel    PriceProposal    PriceProposalStatus    ${RowCounter}    ${errormessage}    FF0000
##                    save excel document    ${PPInputExcelPath}
##                END
#            ELSE
#                ${error_code}=  Set Variable  ${json_dict['errors']}
#                ${error_code}=    convert to string    ${error_code}
#                write and color excel    PriceProposal    OrderStatus    ${RowCounter}    Error in Response    FF0000
#                save excel document    ${PPInputExcelPath}
#                should contain    ${list}[0]    SUCCESS
#            END
#            exit for loop
#        END
#        save excel document    ${PPInputExcelPath}
#        ${ListIndexIterator}=    evaluate    ${ListIndexIterator} + int(${1})
#        ${RowCounter}=    evaluate    ${RowCounter} + int(${1})
#    END
#    save excel document    ${PPInputExcelPath}

