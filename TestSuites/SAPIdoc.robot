*** Settings ***
Resource    ../Resource/ObjectRepositories/CustomVariables.robot
#Library    Browser
Library    ScreenCapLibrary
Library    CustomLib.py
Library    Response.py

*** Variables ***
${file}    \\UploadExcel\\JsonTemplates\\
${SubId}    24ef<<RandomNum>>-<<Randomt3digit>>b-4808-9127-af8e42410<<RandonDynId>>
${QA2_Viax}     https://wileyas.qa2.viax.io/price-proposals
${QA2_Graphql}    https://api.wileyas.stage.viax.io/graphql
${PPInputExcelPath}    ${execdir}\\UploadExcel\\TD_Inputs.xlsx
${Var_SalesATab}    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_ITEM/tabpT\\01
${Var_SalesBTab}    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_ITEM/tabpT\\02
${Var_ContractData}    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_ITEM/tabpT\\03
${Var_Shipping}    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_ITEM/tabpT\\04
${Var_Billing}    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_ITEM/tabpT\\05
${Var_Conditions}    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_ITEM/tabpT\\06
${Var_AccountAssign}    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_ITEM/tabpT\\07
${Var_Media}    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_ITEM/tabpT\\08
${Var_Partners}    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_ITEM/tabpT\\09
${Var_Texts}    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_ITEM/tabpT\\10
${Var_OrderData}    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_ITEM/tabpT\\11
${Var_status}    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_ITEM/tabpT\\12
${Var_Structure}    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_ITEM/tabpT\\13
${Var_DataA}    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_ITEM/tabpT\\14
${Var_DataB}    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_ITEM/tabpT\\15
${Var_HeaderSalesATab}    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_HEAD/tabpT\\01
${Var_HeaderContractData}    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_HEAD/tabpT\\02
${Var_HeaderShipping}    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_HEAD/tabpT\\03
${Var_HeaderBilling}    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_HEAD/tabpT\\04
${Var_HeaderAccount}    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_HEAD/tabpT\\05
${Var_HeaderConditions}    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_HEAD/tabpT\\06
${Var_HeaderAccountAssign}    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_HEAD/tabpT\\07
${Var_HeaderPartners}    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_HEAD/tabpT\\08
${Var_HeaderTexts}    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_HEAD/tabpT\\09
${Var_HeaderOrderData}    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_HEAD/tabpT\\10
${Var_Headerstatus}    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_HEAD/tabpT\\11
${Var_HeaderDataA}    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_HEAD/tabpT\\12
${Var_HeaderDataB}    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_HEAD/tabpT\\13
${Var_ItemOverview}    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_OVERVIEW/tabpT\\02
${Var_ItemOverviewTableId}    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_OVERVIEW/tabpT\\02/ssubSUBSCREEN_BODY:SAPMV45A:4401/subSUBSCREEN_TC:SAPMV45A:4900/tblSAPMV45ATCTRL_U_ERF_AUFTRAG
${Var_OpenItem}    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_OVERVIEW/tabpT\\02/ssubSUBSCREEN_BODY:SAPMV45A:4401/subSUBSCREEN_TC:SAPMV45A:4900/subSUBSCREEN_BUTTONS:SAPMV45A:4050/btnBT_ITEM
${Var_InvoiceElement}    /app/con[0]/ses[0]/wnd[0]/usr/shell/shellcont[1]/shell[1]
${Var_OrderIDTextbox}    /app/con[0]/ses[0]/wnd[0]/usr/ctxtVBAK-VBELN

*** Test Cases ***
ValidatSAP
     open sap logon window    ${SAPGUIPATH}    ${SAPUSERNAME}    ${SAPPASSWORD}    ${ENTERBUTTON}    ${CONNECTION}    ${continuebutton}
     run transaction    /nVA03
     sapguilibrary.input text    ${Var_OrderIDTextbox}      8000042395
     send vkey    0
     ${Curreny}=    SapGuiLibrary.get value    /app/con[0]/ses[0]/wnd[0]/usr/subSUBSCREEN_HEADER:SAPMV45A:4021/ctxtVBAK-WAERK
     sapguilibrary.click element    ${Var_ItemOverview}
     select table row   ${Var_ItemOverviewTableId}       0
     sapguilibrary.click element    ${Var_OpenItem}
     sapguilibrary.click element    ${Var_SalesATab}
     ${Material}=    SapGuiLibrary.Get Value    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_ITEM/tabpT\\01/ssubSUBSCREEN_BODY:SAPMV45A:4451/ctxtVBAP-MATWA
     sapguilibrary.click element    ${Var_SalesBTab}
     ${MaterialGroup}=    SapGuiLibrary.Get Value    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_ITEM/tabpT\\02/ssubSUBSCREEN_BODY:SAPMV45A:4458/ctxtVBAP-MATKL
     ${Division}=     SapGuiLibrary.Get Value    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_ITEM/tabpT\\02/ssubSUBSCREEN_BODY:SAPMV45A:4458/ctxtVBAP-SPART
     sapguilibrary.click element    ${Var_Shipping}
     ${Plant}=    SapGuiLibrary.Get Value    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_ITEM/tabpT\\04/ssubSUBSCREEN_BODY:SAPMV45A:4452/ctxtVBAP-WERKS
     SapGuiLibrary.click element    ${Var_Conditions}
     ${NetPrice}=    SapGuiLibrary.Get Value    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_ITEM/tabpT\\06/ssubSUBSCREEN_BODY:SAPLV69A:6201/txtKOMP-NETWR
     ${TaxValue}=   SapGuiLibrary.Get Value    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_ITEM/tabpT\\06/ssubSUBSCREEN_BODY:SAPLV69A:6201/txtKOMP-MWSBP
     sapguilibrary.click element    ${Var_OrderData}
     ${ReferenceID}=    SapGuiLibrary.Get Value    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_ITEM/tabpT\\11/ssubSUBSCREEN_BODY:SAPMV45A:4454/txtVBKD-IHREZ
     ${DBSOrderID}=    SapGuiLibrary.Get Value    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_ITEM/tabpT\\11/ssubSUBSCREEN_BODY:SAPMV45A:4454/txtVBKD-IHREZ_E
     sapguilibrary.click element    ${Var_DataB}
     ${ArticleNumber}=    SapGuiLibrary.Get Value    /app/con[0]/ses[0]/wnd[0]/usr/tabsTAXI_TABSTRIP_ITEM/tabpT\\15/ssubSUBSCREEN_BODY:SAPMV45A:4462/subKUNDEN-SUBSCREEN_8459:SAPMV45A:8459/txtVBAP-ZZARTNO
     send vkey    3
     send vkey    5
     slectInvoiceTree        ${Var_InvoiceElement}
     send vkey    8
     ${InvoiceNumber}=    SapGuiLibrary.get value    /app/con[0]/ses[0]/wnd[0]/usr/ctxtVBRK-VBELN
     sapguilibrary.click element    /app/con[0]/ses[0]/wnd[0]/usr/btnTC_OUTPUT
     sapguilibrary.select table row    /app/con[0]/ses[0]/wnd[0]/usr/tblSAPDV70ATC_NAST3    0
     send vkey    5
     send vkey    3


#    ${value}=    set variable    1robot
#     WHILE    ${value} != 2
#        log to console    ${value}
#        ${value}=    evaluate    ${value} + 1
#     END



#    Read excel values in columnwise    ${PPInputExcelPath}     MasterData
#
#    ${journalId}=    Get Value from excel columnwise    FunderPaid    JournalID
#    ${JSONFileName}=    Get Value from excel columnwise    FunderPaid    JSONFileName
#
#    ${Rownum}=    Get excel row number   ${Rowcount}    BaseArticleType
#    ${BaseArticleType}=    Get Value from excel columnwise    FunderPaid    BaseArticleType
#    ${UIBaseArticleType}=    seleniumlibrary.get text    (//*[@class="x-order-basics-view__value"])[3]
#    validate the content and update the excel   ${BaseArticleType}    ${UIBaseArticleType}    ${sheetname}    BaseArticleType    ${Rownum}
#
##    ${DisplayArticleType}=    Get Value from excel columnwise    FunderPaid    DisplayArticleType
#
#    ${Rownum}=    Get excel row number   ${Rowcount}    SubmissionDate
#    ${SubmissionDate}=    Get Value from excel columnwise    FunderPaid    SubmissionDate
#    ${UISubmissionDate}=    seleniumlibrary.get text    (//*[@class="x-order-basics-view__value"])[9]
#    validate the content and update the excel   ${SubmissionDate}    ${UISubmissionDate}    ${sheetname}    SubmissionDate    ${Rownum}
#
#    ${ArticleTitle}=    Get Value from excel columnwise    FunderPaid    ArticleTitle
#    ${UIArticleTitle}=    SeleniumLibrary.get text    (//*[@class="x-order-basics-view__value"])[5]
#    ${Rownum}=    Get excel row number   ${Rowcount}    ArticleTitle
#    validate the content and update the excel   ${ArticleTitle}    ${UIArticleTitle}    ${sheetname}    ArticleTitle    ${Rownum}
#
#    ${FirstName}=    Get Value from excel columnwise    FunderPaid    FirstName
#    ${LastName}=    Get Value from excel columnwise    FunderPaid    LastName
#    ${Name}=    evaluate    ${FirstName}${SPACE}${LastName}
#    ${UIName}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//p[2])[1]
#    ${Rownum}=    Get excel row number   ${Rowcount}    Name
#    validate the content and update the excel   ${Name}    ${UIName}    ${sheetname}    Name    ${Rownum}
#
#    ${EmailID}=    Get Value from excel columnwise    FunderPaid    EmailID
#    ${UIEmailID}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//p[2])[2]
#    ${Rownum}=    Get excel row number   ${Rowcount}    EmailID
#    validate the content and update the excel   ${EmailID}    ${UIEmailID}    ${sheetname}    EmailID    ${Rownum}
#
#    ${InstitutionIdType}=    Get Value from excel columnwise    FunderPaid    InstitutionIdType
#    ${UIInstitutionIdType}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//p[2])[11]
#    ${Rownum}=    Get excel row number   ${Rowcount}    InstitutionIdType
#    validate the content and update the excel   ${InstitutionIdType}    ${UIInstitutionIdType}    ${sheetname}    InstitutionIdType    ${Rownum}
#
#
##    ${InstitutionId}=    Get Value from excel columnwise    FunderPaid    InstitutionId
#    ${Institution}=    Get Value from excel columnwise    FunderPaid    Institution
#    ${UIInstitution}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//p[2])[9]
#    ${Rownum}=    Get excel row number   ${Rowcount}    Institution
#    validate the content and update the excel   ${Institution}    ${UIInstitution}    ${sheetname}    Institution    ${Rownum}
#
#
#
#    ${CountryCode}=    Get Value from excel columnwise    FunderPaid    CountryCode
#    ${UICountry}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//p[2])[10]
#    ${Rownum}=    Get excel row number   ${Rowcount}    CountryCode
#    validate the content and update the excel   ${CountryCode}    ${UICountry}    ${sheetname}    CountryCode    ${Rownum}
#
#    ${PublishedIn}=    Get Value from excel columnwise    FunderPaid    PublishedIn
#    ${UIPublishedIn}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//p[2])[5]
#    ${Rownum}=    Get excel row number   ${Rowcount}    PublishedIn
#    validate the content and update the excel   ${PublishedIn}    ${UIPublishedIn}    ${sheetname}    PublishedIn    ${Rownum}
#
#    ${MauScriptId}=    Get Value from excel columnwise    FunderPaid    MauScriptId
#    ${UIMauscriptID}=    seleniumlibrary.get text    (//*[@class="x-order-basics-view__value"])[1]
#    ${Rownum}=    Get excel row number   ${Rowcount}    MauScriptId
#    validate the content and update the excel   ${MauScriptId}    ${UIMauScriptId}    ${sheetname}    MauScriptId    ${Rownum}
#
##    ${SubmittedBy}=    Get Value from excel columnwise    FunderPaid    SubmittedBy
#    ${FunderName}=    Get Value from excel columnwise    FunderPaid    FunderName
#    ${UIFunderName}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//p[2])[13]
#    ${Rownum}=    Get excel row number   ${Rowcount}    FunderName
#    validate the content and update the excel   ${FunderName}    ${UIFunderName}    ${sheetname}    FunderName    ${Rownum}
#
#    ${FunderId}=    Get Value from excel columnwise    FunderPaid    FunderId
#    ${UIFunderID}=    SeleniumLibrary.get text     (//*[contains(@id, "single-spa-application:parcel")]//p[2])[14]
#    ${Rownum}=    Get excel row number   ${Rowcount}    FunderId
#    validate the content and update the excel   ${FunderId}    ${UIFunderID}    ${sheetname}    FunderId    ${Rownum}
#
#    ${EditorialStatus}=    Get Value from excel columnwise    FunderPaid    EditorialStatus
#    ${UIEditorialStatus}=    seleniumlibrary.get text    (//*[@class="x-order-basics-view__value"])[7]
#    ${Rownum}=    Get excel row number   ${Rowcount}    EditorialStatus
#    validate the content and update the excel   ${EditorialStatus}    ${UIEditorialStatus}    ${sheetname}    EditorialStatus    ${Rownum}
#
#    ${JournalGroupCode}=    Get Value from excel columnwise    FunderPaid    JournalGroupCode
#    ${UIJournalGroupCode}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//p[2])[6]
#    ${Rownum}=    Get excel row number   ${Rowcount}    JournalGroupCode
#    validate the content and update the excel   ${JournalGroupCode}    ${UIJournalGroupCode}    ${sheetname}    JournalGroupCode    ${Rownum}
#
#
#    ${BaseAPCPrice}=    Get Value from excel columnwise    FunderPaid    BaseAPCPrice
#    ${UIBaseAPCPrice}=    seleniumlibrary.get text    (//*[contains(@class," x-pricing-view__col x-price-proposal__value")])[3]
#    ${Rownum}=    Get excel row number   ${Rowcount}    BaseAPCPrice
#    validate the content and update the excel   ${BaseAPCPrice}    ${UIBaseAPCPrice}    ${sheetname}    BaseAPCPrice    ${Rownum}
#
#
#    ${BaseArticleTypeDiscount}=    Get Value from excel columnwise    FunderPaid    BaseArticleTypeDiscount
#    ${UIBaseArticleTypeDiscount}=    seleniumlibrary.get text    (//*[contains(@class," x-pricing-view__col x-price-proposal__value")[2]
#    ${Rownum}=    Get excel row number   ${Rowcount}    BaseArticleTypeDiscount
#    validate the content and update the excel   ${BaseArticleTypeDiscount}    ${UIBaseArticleTypeDiscount}    ${sheetname}    BaseArticleTypeDiscount    ${Rownum}
#
#    ${BaseAPCCharge}=    Get Value from excel columnwise    FunderPaid    BaseAPCCharge
#    ${UIAPICharge}=    seleniumlibrary.get text    (//*[contains(@class," x-pricing-view__col x-price-proposal__value")])[1]
#    ${Rownum}=    Get excel row number   ${Rowcount}    BaseAPCCharge
#    validate the content and update the excel   ${BaseAPCCharge}    ${UIAPICharge}    ${sheetname}    BaseAPCCharge    ${Rownum}
#
#
#    ${FinalNetPrice}=    Get Value from excel columnwise    FunderPaid    FinalNetPrice
#    ${UIFinalNetPrice}=    seleniumlibrary.get text    (//*[contains(@class," x-pricing-view__col x-price-proposal__value")])[4]
#    ${Rownum}=    Get excel row number   ${Rowcount}    FinalNetPrice
#    validate the content and update the excel   ${BaseAPCCharge}    ${UIAPICharge}    ${sheetname}    FinalNetPrice    ${Rownum}
#
#
#    ${Tax}=    Get Value from excel columnwise    FunderPaid    Tax
#    ${UITax}=    seleniumlibrary.get text    (//*[contains(@class," x-pricing-view__col x-price-proposal__value")])[5]
#    ${Rownum}=    Get excel row number   ${Rowcount}    Tax
#    validate the content and update the excel   ${Tax}    ${UITax}    ${sheetname}    Tax    ${Rownum}
#
#    ${TotalCharge}=    Get Value from excel columnwise    FunderPaid    TotalCharge
#    ${UITotalCharge}=    seleniumlibrary.get text    (//*[contains(@class," x-pricing-view__col x-price-proposal__value")])[6]
#    ${Rownum}=    Get excel row number   ${Rowcount}    TotalCharge
#    validate the content and update the excel   ${TotalCharge}    ${UITotalCharge}    ${sheetname}    TotalCharge    ${Rownum}
#

#    ${DiscountType1}=    Get Value from excel columnwise    FunderPaid    DiscountType1
#    ${UIDiscounttype1}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[1]/td[1])[1]
#    ${Rownum}=    Get excel row number   ${Rowcount}    DiscountType1
#    validate the content and update the excel   ${DiscountType1}    ${UIDiscountType1}    ${sheetname}    DiscountType1    ${Rownum}
#
#    ${DiscountType2}=    Get Value from excel columnwise    FunderPaid    DiscountType2
#    ${UIDiscounttype2}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[2]/td[1])[1]
#    ${Rownum}=    Get excel row number   ${Rowcount}    DiscountType2
#    validate the content and update the excel   ${DiscountType2}    ${UIDiscountType2}    ${sheetname}    DiscountType2    ${Rownum}
#
#    ${DiscountType3}=    Get Value from excel columnwise    FunderPaid    DiscountType3
#    ${UIDiscounttype3}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[3]/td[1])[1]
#    ${Rownum}=    Get excel row number   ${Rowcount}    DiscountType3
#    validate the content and update the excel   ${DiscountType3}    ${UIDiscountType3}    ${sheetname}    DiscountType3    ${Rownum}
#
#
#
#    ${DiscountCondition1}=    Get Value from excel columnwise    FunderPaid    DiscountCondition1
#    ${UIDisountCondition1}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[1]/td[2])[1]
#    ${Rownum}=    Get excel row number   ${Rowcount}    DiscountCondition1
#    validate the content and update the excel   ${DiscountCondition1}    ${UIDisountCondition1}    ${sheetname}    DiscountCondition1    ${Rownum}
#
#    ${DiscountCondition2}=    Get Value from excel columnwise    FunderPaid    DiscountCondition2
#    ${UIDisountCondition2}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[2]/td[2])[1]
#    ${Rownum}=    Get excel row number   ${Rowcount}    DiscountCondition2
#    validate the content and update the excel   ${DiscountCondition2}    ${UIDiscountCondition2}    ${sheetname}    DiscountCondition2    ${Rownum}
#
#    ${DiscountCondition3}=    Get Value from excel columnwise    FunderPaid    DiscountCondition3
#    ${UIDisountCondition3}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[3]/td[2])[1]
#    ${Rownum}=    Get excel row number   ${Rowcount}    DiscountCondition3
#    validate the content and update the excel   ${DiscountCondition3}    ${UIDiscountCondition3}    ${sheetname}    DiscountCondition3    ${Rownum}
#
#
#    ${Value1}=    Get Value from excel columnwise    Society    Value1
#    ${UIValue1}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[1]/td[4])[1]
#    ${Rownum}=    Get excel row number   ${Rowcount}    Value1
#    validate the content and update the excel   ${Value1}    ${UIValue1}    ${sheetname}    Value1    ${Rownum}
#
#    ${UIValue2}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[2]/td[4])[1]
#    ${UIValue3}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[3]/td[4])[1]
#    ${Value2}=    Get Value from excel columnwise    Society    Value2
#    ${Value3}=    Get Value from excel columnwise    FunderPaid    Value3
#    ${Rownum}=    Get excel row number   ${Rowcount}    Value2
#    validate the content and update the excel   ${Value2}    ${UIValue2}    ${sheetname}    Value2    ${Rownum}
#    ${Rownum}=    Get excel row number   ${Rowcount}    Value3
#    validate the content and update the excel   ${Value3}    ${UIValue3}    ${sheetname}    Value3    ${Rownum}
#
#    ${Percentage1}=    Get Value from excel columnwise    FunderPaid    Percentage1
#    ${UIPercentage1}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[1]/td[3])[1]
#    ${UIPercentage3}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[3]/td[3])[1]
#    ${Percentage2}=    Get Value from excel columnwise    FunderPaid    Percentage2
#    ${UIPercentage2}=    SeleniumLibrary.get text    (//*[contains(@id,"single-spa-application:parcel")]//table/tbody/tr[2]/td[3])[1]
#    ${Percentage3}=    Get Value from excel columnwise    FunderPaid    Percentage3
#    ${Rownum}=    Get excel row number   ${Rowcount}    Percentage1
#    validate the content and update the excel   ${Percentage1}    ${UIPercentage1}    ${sheetname}    Percentage1    ${Rownum}
#    ${Rownum}=    Get excel row number   ${Rowcount}    Percentage2
#    validate the content and update the excel   ${Percentage2}    ${UIPercentage2}    ${sheetname}    Percentage2    ${Rownum}
#    ${Rownum}=    Get excel row number   ${Rowcount}    Percentage3
#    validate the content and update the excel   ${Percentage3}    ${UIPercentage3}    ${sheetname}    Percentage3    ${Rownum}
#
#
#
#    ${Applied1}=    Get Value from excel columnwise    FunderPaid    Applied1
#    ${UIApplied1}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[1]/td[6])[1]
#    ${UIApplied2}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[2]/td[6])[1]
#    ${UIApplied3}=    SeleniumLibrary.get text    (//*[contains(@id, "single-spa-application:parcel")]//table/tbody/tr[3]/td[6])[1]
#    ${Applied2}=    Get Value from excel columnwise    FunderPaid    Applied2
#    ${Applied3}=    Get Value from excel columnwise    FunderPaid    Applied3
#    ${Rownum}=    Get excel row number   ${Rowcount}    Applied1
#    validate the content and update the excel   ${Applied1}    ${UIApplied1}    ${sheetname}    Applied1    ${Rownum}
#    ${Rownum}=    Get excel row number   ${Rowcount}    Applied2
#    validate the content and update the excel   ${Applied2}    ${UIApplied2}    ${sheetname}    Applied2    ${Rownum}
#    ${Rownum}=    Get excel row number   ${Rowcount}    Applied3
#    validate the content and update the excel   ${Applied3}    ${UIApplied3}    ${sheetname}    Applied3    ${Rownum}











#     sapguilibrary.select node    /app/con[0]/ses[0]/wnd[0]/shellcont/shell    Datarecords    expand=True
#     sapguilibrary.select node    /app/con[0]/ses[0]/wnd[0]/shellcont/shell    000001    expand=True
#     sapguilibrary.select node    /app/con[0]/ses[0]/wnd[0]/shellcont/shell    000002    expand=True
#     sapguilibrary.select node link    /app/con[0]/ses[0]/wnd[0]/shellcont/shell   000003   Spalte1
#     ${val}=    SapGuiLibrary.Get Value    /app/con[0]/ses[0]/wnd[0]/usr/tblIDOC_TREE_CONTROLINT_SEG_CONTROL/txtINT_SEG-STRING[1,1]
#     ${val1}=    SapGuiLibrary.Get Value    /app/con[0]/ses[0]/wnd[0]/usr/tblIDOC_TREE_CONTROLINT_SEG_CONTROL/txtINT_SEG-STRING[1,1]
#     ${val2}=    SapGuiLibrary.Get Value    /app/con[0]/ses[0]/wnd[0]/usr/tblIDOC_TREE_CONTROLINT_SEG_CONTROL/txtINT_SEG-STRING[1,1]
#     log to console    ${val}


#*** Keywords ***
#Read excel values in columnwise
#    [Documentation]    Read all Values from the input excel and return dictionary values will
#       ...             have all column values as a list and set the dictionary value
#    [Arguments]    ${inputExcelPath}    ${Sheetname}
#    open excel document    ${inputExcelPath}    docID
#    log to console    ${inputExcelPath}
#    ${FirstRow}=    read excel row    1    sheet_name=${Sheetname}
#    ${Columncount}=    get length   ${FirstRow}
#    ${Rowcount}=    read excel column    1    sheet_name=${Sheetname}
#    ${Rowcount}=    get length    ${Rowcount}
#    set suite variable    ${Columncount}    ${Columncount}
#    set suite variable    ${Rowcount}    ${Rowcount}
#
#Get Value from excel columnwise
#    [Arguments]    ${ColumnName}    ${HeaderName}
#    FOR    ${rowiterator}    IN RANGE    0    ${Columncount}
#        ${rowiterator}=    evaluate    ${rowiterator}+int(${1})
#        ${ColumnNameinExcel}=    read excel cell    1    ${rowiterator}
#        IF    '${ColumnNameinExcel}' == '${ColumnName}'
#            FOR    ${FirstRow1iter}    IN RANGE    0    ${Rowcount}
#                ${FirstRow1iter}=    evaluate    ${FirstRow1iter}+int(${1})
#                ${Header}=    read excel cell   ${FirstRow1iter}    1
#                IF    '${Header}' == '${HeaderName}'
#                    ${columnnum}=    evaluate    ${rowiterator}+int(${1})
#                    ${Excelvalue}=    read excel cell    ${FirstRow1iter}    ${columnnum}
#                    ${Excelvalue}=    set variable    ${Excelvalue}
#                END
#            END
#        END
#    END
#    RETURN    ${Excelvalue}
#
#Get excel row number
#    [Arguments]    ${Rowcount}    ${RowValue}
#    FOR    ${rowiterator}    IN RANGE    0    ${Rowcount}
#        ${rowiterator}=    evaluate    ${rowiterator}+int(${1})
#        ${Header}=    read excel cell   ${rowiterator}    1
#        IF    '${Header}' == '${RowValue}'
#            ${rownumber}=    set variable    ${rowiterator}
#            exit for loop
#        END
#    END
#    RETURN    ${rownumber}






