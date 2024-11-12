*** Settings ***
Resource    ../Resource/ObjectRepositories/CustomVariables.robot
Library     ../Resource/ObjectRepositories/CustomLib.py
Library     ../Resource/ObjectRepositories/Response.py
Suite Setup     Open Excel and DBS    ${PPUIValidationExcelPath}    ${PPURL}    ${username}    ${password}
Suite Teardown   Close Excel and Browser
Test Setup    ReLaunch DBS    ${PPURL}    ${username}    ${password}

*** Variables ***
${file}    \\UploadExcel\\JsonTemplates\\
${SubId}    24ef<<RandomNum>>-<<Randomt3digit>>b-4808-9127-af8e42410<<RandonDynId>>
${PPURL}
${QA2_Graphql}    https://api.wileyas.stage.viax.io/graphql
${PPUIValidationExcelPath}    ${execdir}\\UploadExcel\\TD_PPUIValidations.xlsx



*** Test Cases ***

Create PP with Funder Paid with UI Validations
    [Tags]    id=UI_VA_01
    ${journalId}=    Get Value from excel columnwise    FunderPaid    JournalID
    ${JSONFileName}=    Get Value from excel columnwise    FunderPaid    JSONFileName
    ${json_content}=  Get File  ${execdir}${file}${JSONFileName}.json
    ${json_content}=    Generate the JSON file PP    ${json_content}    ${journalId}
    ${Environment}=    Get Value from excel columnwise    FunderPaid    ExeEnvironment
    Switch Case    ${Environment}
    create session    order_session    ${PPURL}    verify=True
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${AuthToken}
    ${response}=     post on session    order_session    url=${GraphqlURL}     data=${json_content}     headers=${headers}
    # Getting the content value
    Log    Status Code: ${response.status_code}
    Log    Response Content: ${response.content}
    ${response.status_code}=  convert to string    ${response.status_code}
    ${Rownum}=    Get excel row number   ${Rowcount}    ResponseCode
    Validate the content and update the excel    200    ${response.status_code}    UIValidations    FunderPaid    ${Rownum}
    set variable    ${response.content}
    set variable    ${response.json()}
    ${response_text}=    convert to string    ${response.content}
    ${response.json()}=    convert to string    ${response.json()}
    ${JsonResp}=  Evaluate  ${response.text}
    # Fetch the values from the result Json File
    @{list}=     CustomLib.Get Value From Json    ${JsonResp}    $.data.testFunction.data
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
        ${Rownum}=    Get excel row number   ${Rowcount}    OrderStatus
        Write Output Excel    UIValidations    FunderPaid    ${Rownum}    ${error_code}
        ${Rownum}=    Get excel row number   ${Rowcount}    OrderID
        Write Output Excel    UIValidations    FunderPaid    ${Rownum}    ${OrderID}
        ${errormessage}=    set variable    ${json_dict['priceProposal']['bpStatus']['code']}
        ${errormessage}=    convert to string    ${errormessage}
        should contain any   ${errormessage}    PriceDetermined    ManualOverrideRequired
        #Validation in UI
        SeleniumLibrary.input text    ${SearchBox}   ${OrderId}
        sleep    5s
        customvariables.save screenshot    ${Screenshotdir}
        seleniumlibrary.click element    //*[@title="#${OrderID}"]
        sleep    7s
        customvariables.save screenshot    ${Screenshotdir}
        ${Rownum}=    Get excel row number   ${Rowcount}    BaseArticleType
        ${BaseArticleType}=    Get Value from excel columnwise    FunderPaid    BaseArticleType
        ${UIBaseArticleType}=    seleniumlibrary.get text    (//*[@class="x-order-basics-view__value"])[3]
        validate the content and update the excel   ${BaseArticleType}    ${UIBaseArticleType}    UIValidations    FunderPaid    ${Rownum}

    #    ${DisplayArticleType}=    Get Value from excel columnwise    FunderPaid    DisplayArticleType
        ${Rownum}=    Get excel row number   ${Rowcount}    SubmissionDate
#        ${SubmissionDate}=    Get Value from excel columnwise    FunderPaid    SubmissionDate
        ${SubmissionDate}=    getdate    %m-%d-%Y
        ${UISubmissionDate}=    seleniumlibrary.get text    (//*[@class="submitted-details"]//*[@class="x-order-basics-view__value"])[1]
        validate the content and update the excel   ${SubmissionDate}    ${UISubmissionDate}    UIValidations    FunderPaid    ${Rownum}

        ${ArticleTitle}=    Get Value from excel columnwise    FunderPaid    ArticleTitle
        ${UIArticleTitle}=    SeleniumLibrary.get text    (//*[@class="x-order-basics-view__value"])[5]
        ${Rownum}=    Get excel row number   ${Rowcount}    ArticleTitle
        validate the content and update the excel   ${ArticleTitle}    ${UIArticleTitle}    UIValidations    FunderPaid    ${Rownum}

        ${FirstName}=    Get Value from excel columnwise    FunderPaid    FirstName
        ${LastName}=    Get Value from excel columnwise    FunderPaid    LastName
        customvariables.save screenshot    ${Screenshotdir}
        ${Name}=    Set Variable    ${FirstName} ${LastName}
        ${UIName}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//p[2])[1]
        @{namelist}=    split string    ${UIName}    ${SPACE}
        ${UIFirstName}=    get from list  ${namelist}    0
        ${UILastName}=    get from list  ${namelist}    1
        ${Rownum}=    Get excel row number   ${Rowcount}    FirstName
        validate the content and update the excel   ${FirstName}    ${UIFirstName}    UIValidations    FunderPaid    ${Rownum}
        ${Rownum}=    Get excel row number   ${Rowcount}    LastName
        validate the content and update the excel   ${LastName}    ${UILastName}    UIValidations    FunderPaid    ${Rownum}
        ${Rownum}=    Get excel row number   ${Rowcount}    Name
        validate the content and update the excel   ${Name}    ${UIName}    UIValidations    FunderPaid    ${Rownum}

        ${EmailID}=    Get Value from excel columnwise    FunderPaid    EmailID
        ${UIEmailID}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//p[2])[2]
        ${Rownum}=    Get excel row number   ${Rowcount}    EmailID
        validate the content and update the excel   ${EmailID}    ${UIEmailID}    UIValidations    FunderPaid    ${Rownum}

        ${InstitutionIdType}=    Get Value from excel columnwise    FunderPaid    InstitutionIdType
        ${UIInstitutionIdType}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//p[2])[11]
        ${Rownum}=    Get excel row number   ${Rowcount}    InstitutionIdType
        validate the content and update the excel   ${InstitutionIdType}    ${UIInstitutionIdType}    UIValidations    FunderPaid    ${Rownum}
    #    ${InstitutionId}=    Get Value from excel columnwise    FunderPaid    InstitutionId
        ${Institution}=    Get Value from excel columnwise    FunderPaid    Institution
        ${UIInstitution}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//p[2])[9]
        ${Rownum}=    Get excel row number   ${Rowcount}    Institution
        validate the content and update the excel   ${Institution}    ${UIInstitution}    UIValidations    FunderPaid    ${Rownum}

        ${CountryCode}=    Get Value from excel columnwise    FunderPaid    CountryCode
        ${UICountry}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//p[2])[10]
        ${Rownum}=    Get excel row number   ${Rowcount}    CountryCode
        validate the content and update the excel   ${CountryCode}    ${UICountry}    UIValidations    FunderPaid    ${Rownum}

        ${PublishedIn}=    Get Value from excel columnwise    FunderPaid    PublishedIn
        ${UIPublishedIn}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//p[2])[5]
        ${Rownum}=    Get excel row number   ${Rowcount}    PublishedIn
        validate the content and update the excel   ${PublishedIn}    ${UIPublishedIn}    UIValidations    FunderPaid    ${Rownum}
        customvariables.save screenshot    ${Screenshotdir}
#        ${MauScriptId}=    Get Value from excel columnwise    FunderPaid    MauScriptId
        ${MauScriptId}=    set variable    CAM4-2024-04-${random_4_digit_number}
        ${UIMauscriptID}=    seleniumlibrary.get text    (//*[@class="x-order-basics-view__value"])[1]
        ${Rownum}=    Get excel row number   ${Rowcount}    MauScriptId
        validate the content and update the excel   ${MauScriptId}    ${UIMauScriptId}    UIValidations    FunderPaid    ${Rownum}

        ${SubmittedBy}=    Get Value from excel columnwise    FunderPaid    SubmittedBy
        ${Rownum}=    Get excel row number   ${Rowcount}    SubmittedBy
        validate the content and update the excel   ${SubmittedBy}    ${Name}    UIValidations    FunderPaid    ${Rownum}
        ${FunderName}=    Get Value from excel columnwise    FunderPaid    FunderName
        ${UIFunderName}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//p[2])[13]
        ${Rownum}=    Get excel row number   ${Rowcount}    FunderName
        validate the content and update the excel   ${FunderName}    ${UIFunderName}    UIValidations    FunderPaid    ${Rownum}

        ${FunderId}=    Get Value from excel columnwise    FunderPaid    FunderId
        ${UIFunderID}=    SeleniumLibrary.get text     (//*[contains(@id, "single-spa-application:parcel")]//p[2])[14]
        ${Rownum}=    Get excel row number   ${Rowcount}    FunderId
        validate the content and update the excel   ${FunderId}    ${UIFunderID}    UIValidations    FunderPaid    ${Rownum}

        ${EditorialStatus}=    Get Value from excel columnwise    FunderPaid    EditorialStatus
        ${UIEditorialStatus}=    seleniumlibrary.get text    (//*[@class="x-order-basics-view__value"])[7]
        ${Rownum}=    Get excel row number   ${Rowcount}    EditorialStatus
        validate the content and update the excel   ${EditorialStatus}    ${UIEditorialStatus}    UIValidations    FunderPaid    ${Rownum}

        ${JournalGroupCode}=    Get Value from excel columnwise    FunderPaid    JournalGroupCode
        ${UIJournalGroupCode}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//p[2])[6]
        ${Rownum}=    Get excel row number   ${Rowcount}    JournalGroupCode
        validate the content and update the excel   ${JournalGroupCode}    ${UIJournalGroupCode}    UIValidations    FunderPaid    ${Rownum}

        ${BaseAPCPrice}=    Get Value from excel columnwise    FunderPaid    BaseAPCPrice
        ${UIBaseAPCPrice}=    seleniumlibrary.get text    (//*[contains(@class," x-pricing-view__col x-price-proposal__value")])[3]
        ${Rownum}=    Get excel row number   ${Rowcount}    BaseAPCPrice
        validate the content and update the excel   ${BaseAPCPrice}    ${UIBaseAPCPrice}    UIValidations    FunderPaid    ${Rownum}

        ${BaseArticleTypeDiscount}=    Get Value from excel columnwise    FunderPaid    BaseArticleTypeDiscount
        ${UIBaseArticleTypeDiscount}=    seleniumlibrary.get text    (//*[contains(@class," x-pricing-view__col x-price-proposal__value")])[2]
        ${Rownum}=    Get excel row number   ${Rowcount}    BaseArticleTypeDiscount
        validate the content and update the excel   ${BaseArticleTypeDiscount}    ${UIBaseArticleTypeDiscount}    UIValidations    FunderPaid    ${Rownum}

        ${BaseAPCCharge}=    Get Value from excel columnwise    FunderPaid    BaseAPCCharge
        ${UIAPICharge}=    seleniumlibrary.get text    (//*[contains(@class," x-pricing-view__col x-price-proposal__value")])[1]
        ${Rownum}=    Get excel row number   ${Rowcount}    BaseAPCCharge
        validate the content and update the excel   ${BaseAPCCharge}    ${UIAPICharge}    UIValidations    FunderPaid    ${Rownum}

        ${FinalNetPrice}=    Get Value from excel columnwise    FunderPaid    FinalNetPrice
        ${UIFinalNetPrice}=    seleniumlibrary.get text    (//*[contains(@class," x-pricing-view__col x-price-proposal__value")])[4]
        ${Rownum}=    Get excel row number   ${Rowcount}    FinalNetPrice
        validate the content and update the excel   ${BaseAPCCharge}    ${UIAPICharge}    UIValidations    FunderPaid    ${Rownum}


        ${Tax}=    Get Value from excel columnwise    FunderPaid    Tax
        ${UITax}=    seleniumlibrary.get text    (//*[contains(@class," x-pricing-view__col x-price-proposal__value")])[5]
        ${Rownum}=    Get excel row number   ${Rowcount}    Tax
        validate the content and update the excel   ${Tax}    ${UITax}    UIValidations    FunderPaid    ${Rownum}

        ${TotalCharge}=    Get Value from excel columnwise    FunderPaid    TotalCharge
        ${UITotalCharge}=    seleniumlibrary.get text    (//*[contains(@class," x-pricing-view__col x-price-proposal__value")])[6]
        ${Rownum}=    Get excel row number   ${Rowcount}    TotalCharge
        customvariables.save screenshot    ${Screenshotdir}
        validate the content and update the excel   ${TotalCharge}    ${UITotalCharge}    UIValidations    FunderPaid    ${Rownum}
        run keyword and continue on failure    should be equal   ${TotalCharge}    ${UITotalCharge}
        run keyword and continue on failure    should be equal   ${Tax}    ${UITax}
        run keyword and continue on failure    should be equal   ${BaseAPCCharge}    ${UIAPICharge}
        run keyword and continue on failure    should be equal   ${BaseArticleTypeDiscount}    ${UIBaseArticleTypeDiscount}
        run keyword and continue on failure    should be equal   ${BaseAPCPrice}    ${UIBaseAPCPrice}
        run keyword and continue on failure    should be equal   ${BaseAPCCharge}    ${UIAPICharge}
        run keyword and continue on failure    should be equal   ${JournalGroupCode}    ${UIJournalGroupCode}
        run keyword and continue on failure    should be equal   ${EditorialStatus}    ${UIEditorialStatus}
        run keyword and continue on failure    should be equal   ${FunderId}    ${UIFunderID}
        run keyword and continue on failure    should be equal   ${FunderName}    ${UIFunderName}
        run keyword and continue on failure    should be equal   ${MauScriptId}    ${UIMauScriptId}
        run keyword and continue on failure    should be equal   ${PublishedIn}    ${UIPublishedIn}
        run keyword and continue on failure    should be equal   ${CountryCode}    ${UICountry}
        run keyword and continue on failure    should be equal   ${Institution}    ${UIInstitution}
        run keyword and continue on failure    should be equal   ${InstitutionIdType}    ${UIInstitutionIdType}
        run keyword and continue on failure    should be equal   ${EmailID}    ${UIEmailID}
        run keyword and continue on failure    should be equal   ${Name}    ${UIName}
        run keyword and continue on failure    should be equal   ${ArticleTitle}    ${UIArticleTitle}
        run keyword and continue on failure    should be equal   ${SubmissionDate}    ${UISubmissionDate}
        run keyword and continue on failure    should be equal   ${BaseArticleType}    ${UIBaseArticleType}
    ELSE
        ${Rownum}=    Get excel row number   ${Rowcount}    OrderID
        Write Output Excel    UIValidations    FunderPaid    ${Rownum}    ${list}[0]
        should contain    ${list}[0]    SUCCESS
    END
    save excel document    ${PPUIValidationExcelPath}

Create PP with Society discount with UI Validations
    [Tags]    id=UI_VA_02
    ${journalId}=    Get Value from excel columnwise    Society    JournalID
    ${JSONFileName}=    Get Value from excel columnwise    Society    JSONFileName
    ${json_content}=  Get File  ${execdir}${file}${JSONFileName}.json
    ${json_content}=    Generate the JSON file PP    ${json_content}    ${journalId}
    ${Environment}=    Get Value from excel columnwise    Society    ExeEnvironment
    Switch Case    ${Environment}
    create session    order_session    ${PPURL}    verify=True
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${AuthToken}
    ${response}=     post on session    order_session    url=${GraphqlURL}     data=${json_content}     headers=${headers}
    # Getting the content value
    Log    Status Code: ${response.status_code}
    Log    Response Content: ${response.content}
    ${response.status_code}=  convert to string    ${response.status_code}
    ${Rownum}=    Get excel row number   ${Rowcount}    ResponseCode
    Validate the content and update the excel    200    ${response.status_code}    UIValidations    Society    ${Rownum}
    set variable    ${response.content}
    set variable    ${response.json()}
    ${response_text}=    convert to string    ${response.content}
    ${response.json()}=    convert to string    ${response.json()}
    ${JsonResp}=  Evaluate  ${response.text}
    # Fetch the values from the result Json File
    @{list}=     CustomLib.Get Value From Json    ${JsonResp}    $.data.testFunction.data
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
        ${Rownum}=    Get excel row number   ${Rowcount}    OrderStatus
        Write Output Excel    UIValidations    Society    ${Rownum}    ${error_code}
        ${Rownum}=    Get excel row number   ${Rowcount}    OrderID
        Write Output Excel    UIValidations    Society    ${Rownum}    ${OrderID}
        ${errormessage}=    set variable    ${json_dict['priceProposal']['bpStatus']['code']}
        ${errormessage}=    convert to string    ${errormessage}
        should contain any   ${errormessage}    PriceDetermined    ManualOverrideRequired
        #Validation in UI
        SeleniumLibrary.input text    ${SearchBox}   ${OrderId}
        sleep    5s
        customvariables.save screenshot    ${Screenshotdir}
        seleniumlibrary.click element    //*[@title="#${OrderID}"]
        sleep    7s
        customvariables.save screenshot    ${Screenshotdir}
        seleniumlibrary.click element    //*[@class="x-icon x-accordion__icon"]
        ${Rownum}=    Get excel row number   ${Rowcount}    BaseArticleType
        ${BaseArticleType}=    Get Value from excel columnwise    Society    BaseArticleType
        ${UIBaseArticleType}=    seleniumlibrary.get text    (//*[@class="x-order-basics-view__value"])[3]
        validate the content and update the excel   ${BaseArticleType}    ${UIBaseArticleType}    UIValidations    Society    ${Rownum}
        ${Rownum}=    Get excel row number   ${Rowcount}    SubmissionDate
        ${SubmissionDate}=    getdate    %m-%d-%Y
        ${UISubmissionDate}=    seleniumlibrary.get text    (//*[@class="submitted-details"]//*[@class="x-order-basics-view__value"])[1]
        validate the content and update the excel   ${SubmissionDate}    ${UISubmissionDate}    UIValidations    Society    ${Rownum}

        ${ArticleTitle}=    Get Value from excel columnwise    Society    ArticleTitle
        ${UIArticleTitle}=    SeleniumLibrary.get text    (//*[@class="x-order-basics-view__value"])[5]
        ${Rownum}=    Get excel row number   ${Rowcount}    ArticleTitle
        validate the content and update the excel   ${ArticleTitle}    ${UIArticleTitle}    UIValidations    Society    ${Rownum}

        ${FirstName}=    Get Value from excel columnwise    Society    FirstName
        ${LastName}=    Get Value from excel columnwise    Society    LastName
        customvariables.save screenshot    ${Screenshotdir}
        ${Name}=    Set Variable    ${FirstName} ${LastName}
        ${UIName}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//p[2])[1]
        @{namelist}=    split string    ${UIName}    ${SPACE}
        ${UIFirstName}=    get from list  ${namelist}    0
        ${UILastName}=    get from list  ${namelist}    1
        ${Rownum}=    Get excel row number   ${Rowcount}    FirstName
        validate the content and update the excel   ${FirstName}    ${UIFirstName}    UIValidations    Society    ${Rownum}
        ${Rownum}=    Get excel row number   ${Rowcount}    LastName
        validate the content and update the excel   ${LastName}    ${UILastName}    UIValidations    Society    ${Rownum}
        ${Rownum}=    Get excel row number   ${Rowcount}    Name
        validate the content and update the excel   ${Name}    ${UIName}    UIValidations    Society    ${Rownum}

        ${EmailID}=    Get Value from excel columnwise    Society    EmailID
        ${UIEmailID}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//p[2])[2]
        ${Rownum}=    Get excel row number   ${Rowcount}    EmailID
        validate the content and update the excel   ${EmailID}    ${UIEmailID}    UIValidations    Society    ${Rownum}

        ${InstitutionIdType}=    Get Value from excel columnwise    Society    InstitutionIdType
        ${UIInstitutionIdType}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//p[2])[11]
        ${Rownum}=    Get excel row number   ${Rowcount}    InstitutionIdType
        validate the content and update the excel   ${InstitutionIdType}    ${UIInstitutionIdType}    UIValidations    Society    ${Rownum}


    #    ${InstitutionId}=    Get Value from excel columnwise    Society    InstitutionId
        ${Institution}=    Get Value from excel columnwise    Society    Institution
        ${UIInstitution}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//p[2])[9]
        ${Rownum}=    Get excel row number   ${Rowcount}    Institution
        validate the content and update the excel   ${Institution}    ${UIInstitution}    UIValidations    Society    ${Rownum}
        customvariables.save screenshot    ${Screenshotdir}


        ${CountryCode}=    Get Value from excel columnwise    Society    CountryCode
        ${UICountry}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//p[2])[10]
        ${Rownum}=    Get excel row number   ${Rowcount}    CountryCode
        validate the content and update the excel   ${CountryCode}    ${UICountry}    UIValidations    Society    ${Rownum}

        ${PublishedIn}=    Get Value from excel columnwise    Society    PublishedIn
        ${UIPublishedIn}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//p[2])[5]
        ${Rownum}=    Get excel row number   ${Rowcount}    PublishedIn
        validate the content and update the excel   ${PublishedIn}    ${UIPublishedIn}    UIValidations    Society    ${Rownum}

#        ${MauScriptId}=    Get Value from excel columnwise    Society    MauScriptId
        ${MauScriptId}=    set variable    ACN3-2023-06-${random_4_digit_number}
        ${UIMauscriptID}=    seleniumlibrary.get text    (//*[@class="x-order-basics-view__value"])[1]
        ${Rownum}=    Get excel row number   ${Rowcount}    MauScriptId
        validate the content and update the excel   ${MauScriptId}    ${UIMauScriptId}    UIValidations    Society    ${Rownum}

        ${SubmittedBy}=    Get Value from excel columnwise    Society    SubmittedBy
        ${Rownum}=    Get excel row number   ${Rowcount}    SubmittedBy
        validate the content and update the excel   ${SubmittedBy}    ${Name}    UIValidations    Society    ${Rownum}
        ${FunderName}=    Get Value from excel columnwise    Society    FunderName
        ${UIFunderName}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//p[2])[13]
        ${Rownum}=    Get excel row number   ${Rowcount}    FunderName
        validate the content and update the excel   ${FunderName}    ${UIFunderName}    UIValidations    Society    ${Rownum}

        ${FunderId}=    Get Value from excel columnwise    Society    FunderId
        ${UIFunderID}=    SeleniumLibrary.get text     (//*[contains(@id, "single-spa-application:parcel")]//p[2])[14]
        ${Rownum}=    Get excel row number   ${Rowcount}    FunderId
        validate the content and update the excel   ${FunderId}    ${UIFunderID}    UIValidations    Society    ${Rownum}

        ${EditorialStatus}=    Get Value from excel columnwise    Society    EditorialStatus
        ${UIEditorialStatus}=    seleniumlibrary.get text    (//*[@class="x-order-basics-view__value"])[7]
        ${Rownum}=    Get excel row number   ${Rowcount}    EditorialStatus
        validate the content and update the excel   ${EditorialStatus}    ${UIEditorialStatus}    UIValidations    Society    ${Rownum}

        ${JournalGroupCode}=    Get Value from excel columnwise    Society    JournalGroupCode
        ${UIJournalGroupCode}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//p[2])[6]
        ${Rownum}=    Get excel row number   ${Rowcount}    JournalGroupCode
        validate the content and update the excel   ${JournalGroupCode}    ${UIJournalGroupCode}    UIValidations    Society    ${Rownum}


        ${BaseAPCPrice}=    Get Value from excel columnwise    Society    BaseAPCPrice
        ${UIBaseAPCPrice}=    seleniumlibrary.get text    (//*[contains(@class," x-pricing-view__col x-price-proposal__value")])[3]
        ${Rownum}=    Get excel row number   ${Rowcount}    BaseAPCPrice
        validate the content and update the excel   ${BaseAPCPrice}    ${UIBaseAPCPrice}    UIValidations    Society    ${Rownum}


        ${BaseArticleTypeDiscount}=    Get Value from excel columnwise    Society    BaseArticleTypeDiscount
        ${UIBaseArticleTypeDiscount}=    seleniumlibrary.get text    (//*[contains(@class," x-pricing-view__col x-price-proposal__value")])[2]
        ${Rownum}=    Get excel row number   ${Rowcount}    BaseArticleTypeDiscount
        validate the content and update the excel   ${BaseArticleTypeDiscount}    ${UIBaseArticleTypeDiscount}    UIValidations    Society    ${Rownum}

        ${BaseAPCCharge}=    Get Value from excel columnwise    Society    BaseAPCCharge
        ${UIAPICharge}=    seleniumlibrary.get text    (//*[contains(@class," x-pricing-view__col x-price-proposal__value")])[1]
        ${Rownum}=    Get excel row number   ${Rowcount}    BaseAPCCharge
        validate the content and update the excel   ${BaseAPCCharge}    ${UIAPICharge}    UIValidations    Society    ${Rownum}


        ${FinalNetPrice}=    Get Value from excel columnwise    Society    FinalNetPrice
        ${UIFinalNetPrice}=    seleniumlibrary.get text    (//*[contains(@class," x-pricing-view__col x-price-proposal__value")])[4]
        ${Rownum}=    Get excel row number   ${Rowcount}    FinalNetPrice
        validate the content and update the excel   ${BaseAPCCharge}    ${UIAPICharge}    UIValidations    Society    ${Rownum}


        ${Tax}=    Get Value from excel columnwise    Society    Tax
        ${UITax}=    seleniumlibrary.get text    (//*[contains(@class," x-pricing-view__col x-price-proposal__value")])[5]
        ${Rownum}=    Get excel row number   ${Rowcount}    Tax
        validate the content and update the excel   ${Tax}    ${UITax}    UIValidations    Society    ${Rownum}
        customvariables.save screenshot    ${Screenshotdir}

        ${TotalCharge}=    Get Value from excel columnwise    Society    TotalCharge
        ${UITotalCharge}=    seleniumlibrary.get text    (//*[contains(@class," x-pricing-view__col x-price-proposal__value")])[6]
        ${Rownum}=    Get excel row number   ${Rowcount}    TotalCharge
        validate the content and update the excel   ${TotalCharge}    ${UITotalCharge}    UIValidations    Society    ${Rownum}

		${DiscountType1}=    Get Value from excel columnwise    Society    DiscountType1
	    ${UIDiscounttype1}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[1]/td[1])[1]
	    ${Rownum}=    Get excel row number   ${Rowcount}    DiscountType1
	    validate the content and update the excel   ${DiscountType1}    ${UIDiscountType1}    UIValidations    Society    ${Rownum}
	#
#	    ${DiscountType2}=    Get Value from excel columnwise    Society    DiscountType2
#	    ${UIDiscounttype2}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[2]/td[1])[1]
#	    ${Rownum}=    Get excel row number   ${Rowcount}    DiscountType2
#	    validate the content and update the excel   ${DiscountType2}    ${UIDiscountType2}    UIValidations    Society    ${Rownum}

	    ${DiscountCondition1}=    Get Value from excel columnwise    Society    DiscountCondition1
	    ${UIDisountCondition1}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[1]/td[2])[1]
	    ${Rownum}=    Get excel row number   ${Rowcount}    DiscountCondition1
	    validate the content and update the excel   ${DiscountCondition1}    ${UIDisountCondition1}    UIValidations    Society    ${Rownum}
        customvariables.save screenshot     ${Screenshotdir}
#	    ${DiscountCondition2}=    Get Value from excel columnwise    Society    DiscountCondition2
#	    ${UIDisountCondition2}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[2]/td[2])[1]
#	    ${Rownum}=    Get excel row number   ${Rowcount}    DiscountCondition2
#	    validate the content and update the excel   ${DiscountCondition2}    ${UIDisountCondition2}    UIValidations    Society    ${Rownum}

	    ${Value1}=    Get Value from excel columnwise    Society    Value1
	    ${UIValue1}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[1]/td[4])[1]
	    ${Rownum}=    Get excel row number   ${Rowcount}    Value1
	    validate the content and update the excel   ${Value1}    ${UIValue1}    UIValidations    Society    ${Rownum}

#	    ${UIValue2}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[2]/td[4])[1]
#	    ${Value2}=    Get Value from excel columnwise    Society    Value2
#
#	    ${Rownum}=    Get excel row number   ${Rowcount}    Value2
#	    validate the content and update the excel   ${Value2}    ${UIValue2}    UIValidations    Society    ${Rownum}

	    ${Percentage1}=    Get Value from excel columnwise    Society    Percentage1
	    ${UIPercentage1}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[1]/td[3])[1]

#	    ${Percentage2}=    Get Value from excel columnwise    Society    Percentage2
#	    ${UIPercentage2}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[2]/td[3])[1]

	    ${Rownum}=    Get excel row number   ${Rowcount}    Percentage1
	    validate the content and update the excel   ${Percentage1}    ${UIPercentage1}    UIValidations    Society    ${Rownum}
#	    ${Rownum}=    Get excel row number   ${Rowcount}    Percentage2
#	    validate the content and update the excel   ${Percentage2}    ${UIPercentage2}    UIValidations    Society    ${Rownum}

	    ${Applied1}=    Get Value from excel columnwise    Society    Applied1
	    customvariables.save screenshot    ${Screenshotdir}
	    ${UIApplied1}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[1]/td[6])[1]
#	    ${UIApplied2}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[2]/td[6])[1]
#
#	    ${Applied2}=    Get Value from excel columnwise    Society    Applied2

	    ${Rownum}=    Get excel row number   ${Rowcount}    Applied1
	    customvariables.save screenshot    ${Screenshotdir}
	    validate the content and update the excel   ${Applied1}    ${UIApplied1}    UIValidations    Society    ${Rownum}
#	    ${Rownum}=    Get excel row number   ${Rowcount}    Applied2
#	    validate the content and update the excel   ${Applied2}    ${UIApplied2}    UIValidations    Society    ${Rownum}
	    run keyword and continue on failure    should be equal   ${Applied1}    ${UIApplied1}
#        run keyword and continue on failure    should be equal   ${Applied2}    ${UIApplied2}
#        run keyword and continue on failure    should be equal   ${Percentage2}    ${UIPercentage2}
        run keyword and continue on failure    should be equal   ${Percentage1}    ${UIPercentage1}
#        run keyword and continue on failure    should be equal   ${Value2}    ${UIValue2}
        run keyword and continue on failure    should be equal   ${Value1}    ${UIValue1}
        run keyword and continue on failure    should be equal   ${DiscountCondition1}    ${UIDisountCondition1}
#        run keyword and continue on failure    should be equal   ${DiscountCondition2}    ${UIDisountCondition2}
        run keyword and continue on failure    should be equal   ${DiscountType1}    ${UIDiscountType1}
#        run keyword and continue on failure    should be equal   ${DiscountType2}    ${UIDiscountType2}
        run keyword and continue on failure    should be equal   ${TotalCharge}    ${UITotalCharge}
        run keyword and continue on failure    should be equal   ${Tax}    ${UITax}
        run keyword and continue on failure    should be equal   ${BaseAPCCharge}    ${UIAPICharge}
        run keyword and continue on failure    should be equal   ${BaseArticleTypeDiscount}    ${UIBaseArticleTypeDiscount}
        run keyword and continue on failure    should be equal   ${BaseAPCPrice}    ${UIBaseAPCPrice}
        run keyword and continue on failure    should be equal   ${BaseAPCCharge}    ${UIAPICharge}
        run keyword and continue on failure    should be equal   ${JournalGroupCode}    ${UIJournalGroupCode}
        run keyword and continue on failure    should be equal   ${EditorialStatus}    ${UIEditorialStatus}
        run keyword and continue on failure    should be equal   ${FunderId}    ${UIFunderID}
        run keyword and continue on failure    should be equal   ${FunderName}    ${UIFunderName}
        run keyword and continue on failure    should be equal   ${MauScriptId}    ${UIMauScriptId}
        run keyword and continue on failure    should be equal   ${PublishedIn}    ${UIPublishedIn}
        run keyword and continue on failure    should be equal   ${CountryCode}    ${UICountry}
        run keyword and continue on failure    should be equal   ${Institution}    ${UIInstitution}
        run keyword and continue on failure    should be equal   ${InstitutionIdType}    ${UIInstitutionIdType}
        run keyword and continue on failure    should be equal   ${EmailID}    ${UIEmailID}
        run keyword and continue on failure    should be equal   ${Name}    ${UIName}
        run keyword and continue on failure    should be equal   ${ArticleTitle}    ${UIArticleTitle}
        run keyword and continue on failure    should be equal   ${SubmissionDate}    ${UISubmissionDate}
        run keyword and continue on failure    should be equal   ${BaseArticleType}    ${UIBaseArticleType}
	ELSE
        ${Rownum}=    Get excel row number   ${Rowcount}    OrderID
        Write Output Excel    UIValidations    FunderPaid    ${Rownum}    ${list}[0]
        should contain    ${list}[0]    SUCCESS
    END
    save excel document    ${PPUIValidationExcelPath}

Create PP with Multiple discount with UI Validations
    [Tags]    id=UI_VA_03
    ${journalId}=    Get Value from excel columnwise    Multiple    JournalID
    ${JSONFileName}=    Get Value from excel columnwise    Multiple    JSONFileName
    ${json_content}=  Get File  ${execdir}${file}${JSONFileName}.json
    ${json_content}=    Generate the JSON file PP    ${json_content}    ${journalId}
    ${Environment}=    Get Value from excel columnwise    Multiple    ExeEnvironment
    Switch Case    ${Environment}
    create session    order_session    ${PPURL}    verify=True
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${AuthToken}
    ${response}=     post on session    order_session    url=${GraphqlURL}     data=${json_content}     headers=${headers}
    # Getting the content value
    Log    Status Code: ${response.status_code}
    Log    Response Content: ${response.content}
    ${response.status_code}=  convert to string    ${response.status_code}
    ${Rownum}=    Get excel row number   ${Rowcount}    ResponseCode
    Validate the content and update the excel    200    ${response.status_code}    UIValidations    Multiple    ${Rownum}
    set variable    ${response.content}
    set variable    ${response.json()}
    ${response_text}=    convert to string    ${response.content}
    ${response.json()}=    convert to string    ${response.json()}
    ${JsonResp}=  Evaluate  ${response.text}
    # Fetch the values from the result Json File
    @{list}=     CustomLib.Get Value From Json    ${JsonResp}    $.data.testFunction.data
    ${NumberofList}=    get length    ${list}
    set variable    ${JsonResp}
    ${check}=    run keyword and return status    should contain    ${list}[0]    SUCCESS
    ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
    ${json_dict}=  Evaluate  json.loads('''${list}[0]''')  modules=json
    IF    '${check}' == '${True}'
        ${error_code}=  Set Variable  ${json_dict['message']}
        ${OrderID}=  Set Variable   ${json_dict['viaxPriceProposalId']}
        ${error_code}=    convert to string    ${error_code}
        ${OrderStatus}=    convert to string    ${OrderID}
        ${Rownum}=    Get excel row number   ${Rowcount}    OrderStatus
        Write Output Excel    UIValidations    Multiple    ${Rownum}    ${error_code}
        ${Rownum}=    Get excel row number   ${Rowcount}    OrderID
        Write Output Excel    UIValidations    Multiple    ${Rownum}    ${OrderID}
        ${errormessage}=    set variable    ${json_dict['priceProposal']['bpStatus']['code']}
        ${errormessage}=    convert to string    ${errormessage}
        should contain any   ${errormessage}    PriceDetermined    ManualOverrideRequired
        #Validation in UI
        SeleniumLibrary.input text    ${SearchBox}   ${OrderId}
        sleep    5s
        customvariables.save screenshot    ${Screenshotdir}
        seleniumlibrary.click element    //*[@title="#${OrderID}"]
        sleep    7s
        customvariables.save screenshot    ${Screenshotdir}
        seleniumlibrary.click element    //*[@class="x-icon x-accordion__icon"]
        ${Rownum}=    Get excel row number   ${Rowcount}    BaseArticleType
        ${BaseArticleType}=    Get Value from excel columnwise    Multiple    BaseArticleType
        ${UIBaseArticleType}=    seleniumlibrary.get text    (//*[@class="x-order-basics-view__value"])[3]
        validate the content and update the excel   ${BaseArticleType}    ${UIBaseArticleType}    UIValidations    Multiple    ${Rownum}
        run keyword and continue on failure    should be equal   ${BaseArticleType}    ${UIBaseArticleType}
        ${Rownum}=    Get excel row number   ${Rowcount}    SubmissionDate
#        ${SubmissionDate}=    Get Value from excel columnwise    Multiple    SubmissionDate
        ${SubmissionDate}=    getdate    %m-%d-%Y
        ${UISubmissionDate}=    seleniumlibrary.get text    (//*[@class="submitted-details"]//*[@class="x-order-basics-view__value"])[1]
        validate the content and update the excel   ${SubmissionDate}    ${UISubmissionDate}    UIValidations    Multiple    ${Rownum}
        run keyword and continue on failure    should be equal   ${SubmissionDate}    ${UISubmissionDate}

        ${ArticleTitle}=    Get Value from excel columnwise    Multiple    ArticleTitle
        ${UIArticleTitle}=    SeleniumLibrary.get text    (//*[@class="x-order-basics-view__value"])[5]
        ${Rownum}=    Get excel row number   ${Rowcount}    ArticleTitle
        validate the content and update the excel   ${ArticleTitle}    ${UIArticleTitle}    UIValidations    Multiple    ${Rownum}
        run keyword and continue on failure    should be equal   ${ArticleTitle}    ${UIArticleTitle}
        customvariables.save screenshot    ${Screenshotdir}
        ${FirstName}=    Get Value from excel columnwise    Multiple    FirstName
        ${LastName}=    Get Value from excel columnwise    Multiple    LastName
        ${Name}=    Set Variable    ${FirstName} ${LastName}
        ${UIName}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//p[2])[1]
        @{namelist}=    split string    ${UIName}    ${SPACE}
        ${UIFirstName}=    get from list  ${namelist}    0
        ${UILastName}=    get from list  ${namelist}    1
        ${Rownum}=    Get excel row number   ${Rowcount}    FirstName
        validate the content and update the excel   ${FirstName}    ${UIFirstName}    UIValidations    Multiple    ${Rownum}
        ${Rownum}=    Get excel row number   ${Rowcount}    LastName
        validate the content and update the excel   ${LastName}    ${UILastName}    UIValidations    Multiple    ${Rownum}
        ${Rownum}=    Get excel row number   ${Rowcount}    Name
        validate the content and update the excel   ${Name}    ${UIName}    UIValidations    Multiple    ${Rownum}
        run keyword and continue on failure    should be equal   ${Name}    ${UIName}
        customvariables.save screenshot    ${Screenshotdir}

        ${EmailID}=    Get Value from excel columnwise    Multiple    EmailID
        ${UIEmailID}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//p[2])[2]
        ${Rownum}=    Get excel row number   ${Rowcount}    EmailID
        validate the content and update the excel   ${EmailID}    ${UIEmailID}    UIValidations    Multiple    ${Rownum}
        run keyword and continue on failure    should be equal   ${EmailID}    ${UIEmailID}

        ${InstitutionIdType}=    Get Value from excel columnwise    Multiple    InstitutionIdType
        ${UIInstitutionIdType}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//p[2])[11]
        ${Rownum}=    Get excel row number   ${Rowcount}    InstitutionIdType
        validate the content and update the excel   ${InstitutionIdType}    ${UIInstitutionIdType}    UIValidations    Multiple    ${Rownum}
        run keyword and continue on failure    should be equal   ${InstitutionIdType}    ${UIInstitutionIdType}

        ${Institution}=    Get Value from excel columnwise    Multiple    Institution
        ${UIInstitution}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//p[2])[9]
        ${Rownum}=    Get excel row number   ${Rowcount}    Institution
        validate the content and update the excel   ${Institution}    ${UIInstitution}    UIValidations    Multiple    ${Rownum}
        run keyword and continue on failure    should be equal   ${Institution}    ${UIInstitution}
        customvariables.save screenshot    ${Screenshotdir}
        ${CountryCode}=    Get Value from excel columnwise    Multiple    CountryCode
        ${UICountry}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//p[2])[10]
        ${Rownum}=    Get excel row number   ${Rowcount}    CountryCode
        validate the content and update the excel   ${CountryCode}    ${UICountry}    UIValidations    Multiple    ${Rownum}
        run keyword and continue on failure    should be equal   ${CountryCode}    ${UICountry}

        ${PublishedIn}=    Get Value from excel columnwise    Multiple    PublishedIn
        ${UIPublishedIn}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//p[2])[5]
        ${Rownum}=    Get excel row number   ${Rowcount}    PublishedIn
        validate the content and update the excel   ${PublishedIn}    ${UIPublishedIn}    UIValidations    Multiple    ${Rownum}
        run keyword and continue on failure    should be equal   ${PublishedIn}    ${UIPublishedIn}
        customvariables.save screenshot    ${Screenshotdir}
#        ${MauScriptId}=    Get Value from excel columnwise    Multiple    MauScriptId
        ${MauScriptId}=    set variable    ACN3-2023-06-${random_4_digit_number}
        ${UIMauscriptID}=    seleniumlibrary.get text    (//*[@class="x-order-basics-view__value"])[1]
        ${Rownum}=    Get excel row number   ${Rowcount}    MauScriptId
        validate the content and update the excel   ${MauScriptId}    ${UIMauScriptId}    UIValidations    Multiple    ${Rownum}
        run keyword and continue on failure    should be equal   ${MauScriptId}    ${UIMauScriptId}
        customvariables.save screenshot    ${Screenshotdir}
        ${SubmittedBy}=    Get Value from excel columnwise    Multiple    SubmittedBy
        ${Rownum}=    Get excel row number   ${Rowcount}    SubmittedBy
        validate the content and update the excel   ${SubmittedBy}    ${Name}    UIValidations    Multiple    ${Rownum}


        ${FunderName}=    Get Value from excel columnwise    Multiple    FunderName
        ${UIFunderName}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//p[2])[13]
        ${Rownum}=    Get excel row number   ${Rowcount}    FunderName
        validate the content and update the excel   ${FunderName}    ${UIFunderName}    UIValidations    Multiple    ${Rownum}
        run keyword and continue on failure    should be equal   ${FunderName}    ${UIFunderName}

        ${FunderId}=    Get Value from excel columnwise    Multiple    FunderId
        ${UIFunderID}=    SeleniumLibrary.get text     (//*[contains(@id, "single-spa-application:parcel")]//p[2])[14]
        ${Rownum}=    Get excel row number   ${Rowcount}    FunderId
        validate the content and update the excel   ${FunderId}    ${UIFunderID}    UIValidations    Multiple    ${Rownum}
        run keyword and continue on failure    should be equal   ${FunderId}    ${UIFunderID}

        ${EditorialStatus}=    Get Value from excel columnwise    Multiple    EditorialStatus
        ${UIEditorialStatus}=    seleniumlibrary.get text    (//*[@class="x-order-basics-view__value"])[7]
        ${Rownum}=    Get excel row number   ${Rowcount}    EditorialStatus
        validate the content and update the excel   ${EditorialStatus}    ${UIEditorialStatus}    UIValidations    Multiple    ${Rownum}
        run keyword and continue on failure    should be equal   ${EditorialStatus}    ${UIEditorialStatus}

        ${JournalGroupCode}=    Get Value from excel columnwise    Multiple    JournalGroupCode
        ${UIJournalGroupCode}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//p[2])[6]
        ${Rownum}=    Get excel row number   ${Rowcount}    JournalGroupCode
        validate the content and update the excel   ${JournalGroupCode}    ${UIJournalGroupCode}    UIValidations    Multiple    ${Rownum}
        run keyword and continue on failure    should be equal   ${JournalGroupCode}    ${UIJournalGroupCode}

        ${BaseAPCPrice}=    Get Value from excel columnwise    Multiple    BaseAPCPrice
        ${UIBaseAPCPrice}=    seleniumlibrary.get text    (//*[contains(@class," x-pricing-view__col x-price-proposal__value")])[3]
        ${Rownum}=    Get excel row number   ${Rowcount}    BaseAPCPrice
        validate the content and update the excel   ${BaseAPCPrice}    ${UIBaseAPCPrice}    UIValidations    Multiple    ${Rownum}
        run keyword and continue on failure    should be equal   ${BaseAPCPrice}    ${UIBaseAPCPrice}

        ${BaseArticleTypeDiscount}=    Get Value from excel columnwise    Multiple    BaseArticleTypeDiscount
        ${UIBaseArticleTypeDiscount}=    seleniumlibrary.get text    (//*[contains(@class," x-pricing-view__col x-price-proposal__value")])[2]
        ${Rownum}=    Get excel row number   ${Rowcount}    BaseArticleTypeDiscount
        validate the content and update the excel   ${BaseArticleTypeDiscount}    ${UIBaseArticleTypeDiscount}    UIValidations    Multiple    ${Rownum}
        run keyword and continue on failure    should be equal   ${BaseArticleTypeDiscount}    ${UIBaseArticleTypeDiscount}

        ${BaseAPCCharge}=    Get Value from excel columnwise    Multiple    BaseAPCCharge
        ${UIAPICharge}=    seleniumlibrary.get text    (//*[contains(@class," x-pricing-view__col x-price-proposal__value")])[1]
        ${Rownum}=    Get excel row number   ${Rowcount}    BaseAPCCharge
        validate the content and update the excel   ${BaseAPCCharge}    ${UIAPICharge}    UIValidations    Multiple    ${Rownum}
        run keyword and continue on failure    should be equal   ${BaseAPCCharge}    ${UIAPICharge}


        ${FinalNetPrice}=    Get Value from excel columnwise    Multiple    FinalNetPrice
        ${UIFinalNetPrice}=    seleniumlibrary.get text    (//*[contains(@class," x-pricing-view__col x-price-proposal__value")])[4]
        ${Rownum}=    Get excel row number   ${Rowcount}    FinalNetPrice
        validate the content and update the excel   ${BaseAPCCharge}    ${UIAPICharge}    UIValidations    Multiple    ${Rownum}
        run keyword and continue on failure    should be equal   ${BaseAPCCharge}    ${UIAPICharge}
        customvariables.save screenshot    ${Screenshotdir}
        ${Tax}=    Get Value from excel columnwise    Multiple    Tax
        ${UITax}=    seleniumlibrary.get text    (//*[contains(@class," x-pricing-view__col x-price-proposal__value")])[5]
        ${Rownum}=    Get excel row number   ${Rowcount}    Tax
        validate the content and update the excel   ${Tax}    ${UITax}    UIValidations    Multiple    ${Rownum}
        run keyword and continue on failure    should be equal   ${Tax}    ${UITax}

        ${TotalCharge}=    Get Value from excel columnwise    Multiple    TotalCharge
        ${UITotalCharge}=    seleniumlibrary.get text    (//*[contains(@class," x-pricing-view__col x-price-proposal__value")])[6]
        ${Rownum}=    Get excel row number   ${Rowcount}    TotalCharge
        validate the content and update the excel   ${TotalCharge}    ${UITotalCharge}    UIValidations    Multiple    ${Rownum}
        run keyword and continue on failure    should be equal   ${TotalCharge}    ${UITotalCharge}

		${DiscountType1}=    Get Value from excel columnwise    Multiple    DiscountType1
	    ${UIDiscounttype1}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[1]/td[1])[1]
	    ${Rownum}=    Get excel row number   ${Rowcount}    DiscountType1
	    validate the content and update the excel   ${DiscountType1}    ${UIDiscountType1}    UIValidations    Multiple    ${Rownum}
	    run keyword and continue on failure    should be equal   ${DiscountType1}    ${UIDiscountType1}
	#
#	    ${DiscountType2}=    Get Value from excel columnwise    Multiple    DiscountType2
#	    ${UIDiscounttype2}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[2]/td[1])[1]
#	    ${Rownum}=    Get excel row number   ${Rowcount}    DiscountType2
#	    validate the content and update the excel   ${DiscountType2}    ${UIDiscountType2}    UIValidations    Multiple    ${Rownum}
#	    run keyword and continue on failure    should be equal   ${DiscountType2}    ${UIDiscountType2}
#	#
#	    ${DiscountType3}=    Get Value from excel columnwise    Multiple    DiscountType3
#	    ${UIDiscounttype3}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[3]/td[1])[1]
#	    ${Rownum}=    Get excel row number   ${Rowcount}    DiscountType3
#	    validate the content and update the excel   ${DiscountType3}    ${UIDiscountType3}    UIValidations    Multiple    ${Rownum}
#	    run keyword and continue on failure    should be equal   ${DiscountType3}    ${UIDiscountType3}

	    ${DiscountCondition1}=    Get Value from excel columnwise    Multiple    DiscountCondition1
	    ${UIDisountCondition1}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[1]/td[2])[1]
	    ${Rownum}=    Get excel row number   ${Rowcount}    DiscountCondition1
	    validate the content and update the excel   ${DiscountCondition1}    ${UIDisountCondition1}    UIValidations    Multiple    ${Rownum}
	    run keyword and continue on failure    should be equal   ${DiscountCondition1}    ${UIDisountCondition1}

#	    ${DiscountCondition2}=    Get Value from excel columnwise    Multiple    DiscountCondition2
#	    ${UIDisountCondition2}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[2]/td[2])[1]
#	    ${Rownum}=    Get excel row number   ${Rowcount}    DiscountCondition2
#	    validate the content and update the excel   ${DiscountCondition2}    ${UIDisountCondition2}    UIValidations    Multiple    ${Rownum}
#	    run keyword and continue on failure    should be equal   ${DiscountCondition2}    ${UIDisountCondition2}
#
#
#
#	    ${DiscountCondition3}=    Get Value from excel columnwise    Multiple    DiscountCondition3
#	    ${UIDisountCondition3}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[3]/td[2])[1]
#	    ${Rownum}=    Get excel row number   ${Rowcount}    DiscountCondition3
#	    validate the content and update the excel   ${DiscountCondition3}    ${UIDisountCondition3}    UIValidations    Multiple    ${Rownum}
#	    run keyword and continue on failure    should be equal   ${DiscountCondition3}    ${UIDisountCondition3}

	    ${Value1}=    Get Value from excel columnwise    Multiple    Value1
	    ${UIValue1}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[1]/td[4])[1]
	    ${Rownum}=    Get excel row number   ${Rowcount}    Value1
	    validate the content and update the excel   ${Value1}    ${UIValue1}    UIValidations    Multiple    ${Rownum}
	    run keyword and continue on failure    should be equal   ${Value1}    ${UIValue1}
#	    ${UIValue2}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[2]/td[4])[1]
#	    ${UIValue3}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[3]/td[4])[1]
#	    ${Value2}=    Get Value from excel columnwise    Multiple    Value2
#	    ${Value3}=    Get Value from excel columnwise    Multiple    Value3
#	    ${Rownum}=    Get excel row number   ${Rowcount}    Value2
#	    validate the content and update the excel   ${Value2}    ${UIValue2}    UIValidations    Multiple    ${Rownum}
#	    run keyword and continue on failure    should be equal   ${Value2}    ${UIValue2}
#	    ${Rownum}=    Get excel row number   ${Rowcount}    Value3
#	    validate the content and update the excel   ${Value3}    ${UIValue3}    UIValidations    Multiple    ${Rownum}
#	    run keyword and continue on failure    should be equal   ${Value3}    ${UIValue3}

	    ${Percentage1}=    Get Value from excel columnwise    Multiple    Percentage1
	    ${UIPercentage1}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[1]/td[3])[1]
#	    ${UIPercentage3}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[3]/td[3])[1]
#	    ${Percentage2}=    Get Value from excel columnwise    Multiple    Percentage2
#	    ${UIPercentage2}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[2]/td[3])[1]
#	    ${Percentage3}=    Get Value from excel columnwise    Multiple    Percentage3
	    ${Rownum}=    Get excel row number   ${Rowcount}    Percentage1
	    validate the content and update the excel   ${Percentage1}    ${UIPercentage1}    UIValidations    Multiple    ${Rownum}

#	    ${Rownum}=    Get excel row number   ${Rowcount}    Percentage2
#	    validate the content and update the excel   ${Percentage2}    ${UIPercentage2}    UIValidations    Multiple    ${Rownum}
#	    ${Rownum}=    Get excel row number   ${Rowcount}    Percentage3
#	    validate the content and update the excel   ${Percentage3}    ${UIPercentage3}    UIValidations    Multiple    ${Rownum}
#	    run keyword and continue on failure    should be equal   ${Percentage3}    ${UIPercentage3}
#	    run keyword and continue on failure    should be equal   ${Percentage2}    ${UIPercentage2}
	    run keyword and continue on failure    should be equal   ${Percentage1}    ${UIPercentage1}
	    ${Applied1}=    Get Value from excel columnwise    Multiple    Applied1
	    ${UIApplied1}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[1]/td[6])[1]
#	    ${UIApplied2}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[2]/td[6])[1]
#	    ${UIApplied3}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[3]/td[6])[1]
#	    ${Applied2}=    Get Value from excel columnwise    Multiple    Applied2
#	    ${Applied3}=    Get Value from excel columnwise    Multiple    Applied3
	    ${Rownum}=    Get excel row number   ${Rowcount}    Applied1
	    validate the content and update the excel   ${Applied1}    ${UIApplied1}    UIValidations    Multiple    ${Rownum}
#	    ${Rownum}=    Get excel row number   ${Rowcount}    Applied2
#	    validate the content and update the excel   ${Applied2}    ${UIApplied2}    UIValidations    Multiple    ${Rownum}
#	    ${Rownum}=    Get excel row number   ${Rowcount}    Applied3
#	    validate the content and update the excel   ${Applied3}    ${UIApplied3}    UIValidations    Multiple    ${Rownum}
	    run keyword and continue on failure    should be equal   ${Applied1}    ${UIApplied1}
	    customvariables.save screenshot    ${Screenshotdir}
#	    run keyword and continue on failure    should be equal   ${Applied2}    ${UIApplied2}
#	    run keyword and continue on failure    should be equal   ${Applied3}    ${UIApplied3}
	ELSE
        ${Rownum}=    Get excel row number   ${Rowcount}    OrderID
        Write Output Excel    UIValidations    FunderPaid    ${Rownum}    ${list}[0]
        should contain    ${list}[0]    SUCCESS
    END
    save excel document    ${PPUIValidationExcelPath}



*** Keywords ***
Read excel values in columnwise
    [Documentation]    Read all Values from the input excel and return dictionary values will
       ...             have all column values as a list and set the dictionary value
    [Arguments]    ${PPUIValidationExcelPath}
    open excel document    ${PPUIValidationExcelPath}    docID
    log to console    ${PPUIValidationExcelPath}
    ${FirstRow}=    read excel row    1    sheet_name=UIValidations
    ${Columncount}=    get length   ${FirstRow}
    ${Rowcount}=    read excel column    1    sheet_name=UIValidations
    ${Rowcount}=    get length    ${Rowcount}
    set suite variable    ${Columncount}    ${Columncount}
    set suite variable    ${Rowcount}    ${Rowcount}

Get Value from excel columnwise
    [Arguments]    ${ColumnName}    ${HeaderName}
    FOR    ${rowiterator}    IN RANGE    0    ${Columncount}
        ${rowiterator}=    evaluate    ${rowiterator}+int(${1})
        ${ColumnNameinExcel}=    read excel cell    1    ${rowiterator}
        IF    '${ColumnNameinExcel}' == '${ColumnName}'
            FOR    ${FirstRow1iter}    IN RANGE    0    ${Rowcount}
                ${FirstRow1iter}=    evaluate    ${FirstRow1iter}+int(${1})
                ${Header}=    read excel cell   ${FirstRow1iter}    1
                IF    '${Header}' == '${HeaderName}'
                    ${columnnum}=    set variable    ${rowiterator}
                    ${Excelvalue}=    read excel cell    ${FirstRow1iter}    ${columnnum}
                    ${Excelvalue}=    set variable    ${Excelvalue}
                    log to console    ${Excelvalue}
                    exit for loop
                END
            END
        END
    END
    RETURN    ${Excelvalue}

Get excel row number
    [Arguments]    ${Rowcount}    ${RowValue}
    FOR    ${rowiterator}    IN RANGE    0    ${Rowcount}
        ${rowiterator}=    evaluate    ${rowiterator}+int(${1})
        ${Header}=    read excel cell   ${rowiterator}    1
        IF    '${Header}' == '${RowValue}'
            ${rownumber}=    set variable    ${rowiterator}
            exit for loop
        END
    END
    RETURN    ${rownumber}






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
    set suite variable    ${random_4_digit_number}    ${random_4_digit_number}
    ${Formatted_Date}=   getdate    %Y-%m-%d
    ${json_content}=    replace string    ${json_content}    <<CurrentDate>>    ${Formatted_Date}
    RETURN    ${json_content}


Switch Case
    [Arguments]    ${value}
    Run Keyword If    '${value}' == 'QA2'    set suite variable    ${PPURL}     https://wileyas.qa2.viax.io/price-proposals
    Run Keyword If    '${value}' == 'QA2'    set suite variable    ${GraphqlURL}      https://api.wileyas.qa2.viax.io/graphql
    Run Keyword If    '${value}' == 'STAGE'    set suite variable     ${GraphqlURL}    https://api.wileyas.stage.viax.io/graphql
    Run Keyword If    '${value}' == 'STAGE'    set suite variable     ${PPURL}    https://wileyas.stage.viax.io/price-proposals
    Run Keyword If    '${value}' == '4'    Log    Case 4
    ...    ELSE    Log    Default Case



Open Excel and DBS
    [Arguments]    ${PPUIValidationExcelPath}    ${PPURL}    ${username}    ${password}
     Read excel values in columnwise    ${PPUIValidationExcelPath}
     ${Environment}=    Get Value from excel columnwise    FunderPaid    ExeEnvironment
#     ${Environment}=    get from list    ${EnvironmentList}    0
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