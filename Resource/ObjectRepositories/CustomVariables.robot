*** Settings ***

Library    Process
Library    DateTime
Library    Collections
Library    JSONLibrary
Library    OperatingSystem
Library    String
Library    RequestsLibrary
Library    SeleniumLibrary
Library    SapGuiLibrary
Library    ExcelLibrary
Library    Process
Library    ImageHorizonLibrary
Library    Pdf2TextLibrary


*** Variables ***
#-----------------JSON------------------------------------------------
${cancellation_json_file_path}  C:\\Users\\dchinnasam\\OneDrive\\Documents\\VIAXDocs\\JsonTemplates\\Cancellation.json
${inputExcelPath}    ${execdir}\\UploadExcel\\TD_Inputs.xlsx
#${inputExcelPath}     \\AUS-WNASCRMP-03\\Share\\02.TestAutomation\\VIAX\\TD_Inputs.xlsx
${SheetName}    Inputs
#---------------------General Variables-------------------------------
${BASE_URLQA2}       https://api.wileyas.qa2.viax.io/graphql
${BASE_URLQA}    https://api.wileyas.qa2.viax.io/graphql
#${BASE_URL}       https://api.wileyas.qa.viax.io/graphql
${EMPTY}
${Token1}   eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICIyczVNbG80eUZVRC1kMzlseXZMUHhYOWJYc2NCZ3ZiaHVLWHpNNU53b3hrIn0.eyJleHAiOjE3MTkyNTQ5MDMsImlhdCI6MTcxOTI0NzcwMywianRpIjoiOTI1ZGUyNjAtYzA5NC00ODdiLTkyMWYtYzQ4YjE0ODQzZDFlIiwiaXNzIjoiaHR0cHM6Ly9hdXRoLndpbGV5YXMucWEyLnZpYXguaW8vcmVhbG1zL3dpbGV5YXMiLCJhdWQiOiJhY2NvdW50Iiwic3ViIjoiNmJmOTUzYjYtZDlhNS00MjdlLTgzNjItMjlmZjM1YTQ2MWIzIiwidHlwIjoiQmVhcmVyIiwiYXpwIjoidmlheC11aSIsInNlc3Npb25fc3RhdGUiOiJkN2RkNWUzYS0yMDUyLTRhMjctOWI3Ny04MDg0YjJlMzg5ZWUiLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsiZGVmYXVsdC1yb2xlcy13aWxleWFzIiwib2ZmbGluZV9hY2Nlc3MiLCJhZG1pbiIsInVtYV9hdXRob3JpemF0aW9uIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsIm1hbmFnZS1hY2NvdW50LWxpbmtzIiwidmlldy1wcm9maWxlIl19fSwic2NvcGUiOiJyZWFsbSBwcm9maWxlIGVtYWlsIiwic2lkIjoiZDdkZDVlM2EtMjA1Mi00YTI3LTliNzctODA4NGIyZTM4OWVlIiwidWlkIjoiYjZlNGUxZjctY2E1Yy00MTU2LWIzNmItODNhMjA2ZTFmMmMyIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsInJlYWxtIjoid2lsZXlhcyIsInByZWZlcnJlZF91c2VybmFtZSI6InJyYXZpcGF0aUB3aWxleS5jb20iLCJlbWFpbCI6InJyYXZpcGF0aUB3aWxleS5jb20ifQ.OUvUSFjysJbE2qIiE4tjNcAC_AqSUW0prHUBor7qzi6BaqHLyq4T9H_9WF4SvFCt-96wfsCZVT22bxWWmY2smLDXr_SqLph-7fAmisY6--1jhpOfCSTGRdor01YajEuk_2NPspM-Ws1tAL_Sp_F9fwegb5-VbWXiV-kXE1tmqezd8L9a9yJZG7LhECxbIwZ9LN7uuuI7hD4HPddeSHZCrsne3usKA09LbbccghzdhxRDgIpaapvHStlFIDde5oZFnRBryx5hN4mpewLvRFTB590LlcigOa1asc9kU4J8I0h4XvkYHB7XF4rb6HVEBYVNtC9jcw1hluaFbEYYJp5kPw
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
${URLQA2}            https://wileyas.qa2.viax.io/orders
#${URLQA}            https://wileyas.stage.viax.io/orders
${URLQA}       https://wileyas.qa2.viax.io/orders
${Browser}        chrome
${username}     dchinnasam@wiley.com
${password}     VIRapr@678
${SearchBox}    //*[@class="x-search-input__field"]
${statustext}    xpath=/html/body/div[1]/div/div/div/div[2]/div/div[2]/div[1]/div/div/div/div/div[5]/div/span
${ordercheck}    xpath=/html/body/div[1]/div/div/div/div[2]/div/div[1]/div[1]
${wileyorderdetails}    xpath=/html/body/div[1]/div/div/div[1]/div[2]/div[2]/div/div/div[1]
${wileyordersearchbox}    xpath=/html/body/div[1]/div/div/div[1]/div[2]/div[2]/div/div[2]/div/div/div/div/div[4]/div/label/span/input
${wileypaymentreceipt}    xpath=/html/body/div[1]/div/div/div[1]/div[2]/div[2]/div/div[2]/div/div/div/div[2]/div/div[2]/div/div/div[2]
${wileyinvoicetab}    xpath=/html/body/div[1]/div/div/div[1]/div[2]/div[2]/div/div[2]/div/div/div/div[2]/div/div[2]/div/div/div[2]
${wileyinvoicelink}    xpath=/html/body/div[1]/div/div/div[1]/div[2]/div[2]/div/div[2]/div/div/div/div/div[5]/div/button/span
${pdfsave}    xpath=/html/body/div[1]/div/div/div[1]/div[2]/div[2]/div/div[2]/div/div/div/div[2]/div/div[2]/div/div/div[2]
${saveicon}    xpath=/html/body/pdf-viewer//viewer-toolbar//div/div[3]/viewer-download-controls//cr-icon-button//div/iron-icon
${ordercheck}    xpath=/html/body/div[1]/div/div/div/div[2]/div/div[1]/div[1]
${editicon}      xpath=/html/body/div[1]/div/div/div/div[2]/div/div[2]/div[1]/div/div/div/div/div[6]/div
${basicslink}    xpath=/html/body/div[1]/div/div/div/div[2]/div/div[2]/div[1]/div/div/div/div/div[6]/div
${partylink}    xpath=/html/body/div[1]/div/div/div[1]/div[2]/div[2]/div/div/div[1]
${wileyorderdetails}    xpath=/html/body/div[1]/div/div/div[1]/div[2]/div[2]/div/div/div[1]
${wileyordersearchbox}    //*[@class="x-search__field"]
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
${continuebutton}    /app/con[0]/ses[0]/wnd[1]/usr/radMULTI_LOGON_OPT2
#---------------------------WE09-------------------------------------
${idocnumberwe09}    /app/con[0]/ses[0]/wnd[0]/usr/txtDOCNUM-LOW
${idocnumberwe02}    /app/con[0]/ses[0]/wnd[0]/usr/tabsTABSTRIP_IDOCTABBL/tabpSOS_TAB/ssub%_SUBSCREEN_IDOCTABBL:RSEIDOC2:1100/txtDOCNUM-LOW
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
${descendingbutton}    /app/con[0]/ses[0]/wnd[0]/tbar[1]/btn[40]
${timelabel}    /app/con[0]/ses[0]/wnd[0]/usr/lbl[32,1]
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
${TotalAmtText}    (//*[@class="x-col x-col_3 x-pricing-view__col x-pricing-view__value"])[5]
${TaxAmtText}    (//*[@class="x-col x-col_3 x-pricing-view__col x-pricing-view__value"])[4]
${DiscountTypeText}    (//*[@class="x-order-basics-view__value"])[9]
${DiscountcodeText}    (//*[@class="x-order-basics-view__value"])[10]
#******************************************END OF VIAX***********************************************
                                      #STEP VARIABLES
#******************************LAUNCH AND LOGIN VARIABLES*********************************************
${Var_STEPWebLink}    https://wiley-test-step.mdm.stibosystems.com/     #https://wiley-qa-step.mdm.stibosystems.com/
${Var_UserName}    dchinnasam@wileyqa.com
${Var_Password}    Testauto@123
${Var_MicrosoftLoginLink}    //*[contains(@id, "social")]//span[@class=""]    #//*[@id="social-wiley-qa-idp"]//span[@class=""]
${Var_UserNameTextInput}    //*[@name="loginfmt" and @type="email"]
${Var_NextandSignButton}     //*[@data-report-event="Signin_Submit" and @type="submit"]
${Var_PasswordTextInput}    //*[@name="passwd" and @type="password"]
${Var_WileyQALink}    //*[contains(@title,"Wiley")]     #//*[@title="Wiley QA Web UI"]
${Var_AssignedtomeLink}    (//*[@class="material-icons"])[31]
${Var_HomeScreenButton}    //*[@class="navbar-logo-small"]
${Var_STEPInput}    ${execdir}\\UploadExcel\\TD_STEP-JC.xlsx
${Var_Handoverformfile}    ${execdir}\\UploadExcel\\TD_HandoverForm.xlsx
${NumberofVolumes}    1


#******************************INTIATE JOURANAL VARIABLES*****************************************************
${Var_InitaiteJournalLink}     (//*[@class="stibo-GraphicsButton initiate-button"])[1]    #(//div[@class="gwt-Label status-selector__initiate-link-wrapper"])[1]
${Var_JournalTitleTextBox}    //input[@class="gwt-TextBox stibo-NameValue"]
${Var_InitiateJournalSaveButton}    //div//span[@class="text"]

#*****************************JOURANAL BASELINE INFO VARIABLES************************************************
${Var_JournalBaseLineInfoLink}    //*[@title="Journal Baseline Info"]
${Var_JouranlGrpCodeTextBox}    xpath=//*[@id="PropertySheetTable"]/div/div[1]/div[2]/div[4]/div[3]/div/div/table/tbody/tr/td[3]
${Var_MediaTypeTextBox}    xpath=//*[@id="PropertySheetTable"]/div/div[1]/div[2]/div[4]/div[3]/div/div/table/tbody/tr/td[4]
${Var_DigitalISSNTextBox}    //table[contains(@class,"last-row-horizontal-content-page")]//td[5]
${Var_DigitalCodeTextBox}    //table[contains(@class,"last-row-horizontal-content-page")]//td[6]
${Var_PrintISSNTextBox}    //table[contains(@class,"last-row-horizontal-content-page")]//td[7]
${Var_PrintCodeTextBox}    //table[contains(@class,"last-row-horizontal-content-page")]//td[5]
${Var_SaveIcon}    //*[@title="Save" and @type="button"]
${Var_SelectAll}    //*[@id="toolbar_button_Select_all"]
${Var_JouranlBaselineSubmitButtom}    //*[@id="toolbar_button_Submit_Event"]
${Var_SubmitMessage}     //*[@class="gwt-TextBox FormFieldWidget" and @type="text"]
${Var_JouranalBasePopOkayButton}     //*[@class="stibo-GraphicsButton" and @type="button"]
${Var_Popuptextbox}    //*[@class="gwt-TextArea FormFieldWidget"]     #//*[@type="text" and @class="gwt-TextBox FormFieldWidget"]
${Var_ErrorText}    //*[@class="multi-editor-sp-marginals-title"]

#*****************************MANUAL ENRICHMENT INFO VARIABLES************************************************
${Var_ManualEnrichMentLink}    //*[@title="Manual Enrichment"]
${Var_MainSearch}    (//*[@class="material-icons"])[1]
${Var_JournalSerach}   (//*[@class="gwt-Label"])[2]
${Var_JournalSerachBox}    //*[@class="gwt-SuggestBox stb-SuggestField stibo-Value" and @type="text"]
${Var_SearchIconInTextBox}    //*[@class="material-icons search-icon"]
${Var_IDLink}    //span[@class="menulink"]
${Var_shorttitletextbox}    //*[@id="Short_Title"]//*[@class="gwt-TextArea"]
${Var_JournalOriginal}    //*[@id="Journal_Original_Company"]//select
${Var_JournalOwnedBy}    //*[@id="Journal_Owned_by"]//*[@class="gwt-TextArea"]
${Var_Ownershipped}    //*[@id="Ownership_Status"]//select
${Var_Copyright}    //*[@id="Copyright_Line"]//*[@class="gwt-TextArea"]
${Var_LauchYear}    //*[@id="Journal_Launch_Year" ]//*[@type="text"]
${Var_TrueCheckbox}     (//*[@class="stibo-Value validator-text mandatory-for-approval stibo-Value-Text mandatory-RadioButtons RadioButtonsContainer"]//span[@class="gwt-RadioButton radioBoxOption"])[2]
${Var_JouranlProductTypeCheckBox}    (//*[@class="stibo-Value validator-text mandatory-for-approval stibo-Value-Text mandatory-RadioButtons RadioButtonsContainer"]//span[@class="gwt-RadioButton radioBoxOption"])[3]
${Var_ProductType}    //*[@id="Product_Type"]//select
${Var_MediaType}    //*[@id="Media_Type"]//select
${Var_RevenueModel}    //*[@id="Revenue_Model"]//select
${Var_BillingModel}    //*[@id="Billing_Model"]//select
${var_ReneSubsType}    //*[@id="Renewal_Subscription_Type"]//select
${Var_Spiltter1}    (//*[@class="gwt-SplitLayoutPanel-VDragger"])[1]
${Var_Spiltter2}    (//*[@class="gwt-SplitLayoutPanel-VDragger"])[2]
${Var_selectfile}    //*[@id="Journal_Subject_Code_Sequence_Upload"]//*[@class="button-secondary"]       #xpath=//*[.='Journal Handover Form']/..//span[text()='Select file']
${Var_ExcelForm}    \\UploadExcel\\JournalUpload.xlsx

#*****************************REFERENCE INFO VARIABLES************************************************

${Var_FIRefernceButton}    (//*[@title="Create a new reference" ])[2]
${Var_EditorialRefernceButton}    (//*[@title="Create a new reference" ])[4]
${Var_RefAddIcon}    //*[@class="material-icons add-reference"]
${Var_RefSerach}    //*[@class="gwt-TabBarItem-wrapper"]//div//div
${Var_RefTextbox}    //*[@class="gwt-SuggestBox" and @type="text"]
${Var_RefTextSearch}    //td//*[@class="stibo-GraphicsButton material SearchButton"]     #//*[@class="material-icons"]//..//*[@class="text"]
${Var_RefPopupOkay}    //*[@class="stibo-GraphicsButton"]     #//*[@class="stibo-GraphicsButton material RunBusinessActionButton"]//span[@class="text"]
${Var_SaveButton}    (//*[@class="stibo-GraphicsButton material RunBusinessActionButton"])
#${popupOkay}    xpath=/html/body/div[13]/div/table/tbody/tr[2]/td[2]/div/div/table/tbody/tr[2]/td/div/button[2]
${popupOkay}    //*[@class="stibo-GraphicsButton"]

#**************************************** SAPCC*************************************************
${Var_SAPCCLink}    //*[@id="stibo_tab_SAP_Cost_Center"]//span[@class="gwt-InlineLabel"]
${Var_SAPCCAddRefLink}     (//*[@id="toolbar_button_Create_a_new_reference"]//div)[5]

#**************************************** JOURNAL COMPLETE***********************************************
${Var_JournalCompleteLink}    //*[@title="Journal Complete"]
${Var_DigitalJournalDetailsTab}    (//*[@id="stibo_tab_Digital_Journal_Details"])
${Var_PrintJournalDetailsTab}    (//*[@id="stibo_tab_Print_Journal_Details"])
${Var_SelectIcon}    (//span[@class="stb-NodeDetails-unselected"])[2]
${Var_JouranlCompletedStatus}    //*[@id="Status"]//select
${Var_JournalCompletedFI}    (//*[@id="stibo_tab_SAP_Finance"])[1]
${Var_JournalCompletedFISub}    (//*[@id="stibo_tab_SAP_Finance"])[2]
${Var_MaterialNumber}     //*[@id="SAP_Material_Number"]//*[@class="gwt-TextArea"]
${Var_JournalIDCode}    //*[@id="Journal_ID_Code"]//*[@class="gwt-TextArea"]
${Var_PublicationType}    //*[@id="Publication_Type"]//select
${Var_JournalMediaProduct}    //*[@id="Higher_Level_Media_Product"]//*[@class="gwt-TextArea"]
${Var_CtaegoryRadioButton}    (//*[contains(@class,"Text mandatory-RadioButtons RadioButtonsContainer")]//span[@class="gwt-RadioButton radioBoxOption"])[3]
${Var_FIDivision}    //*[@id="Finance_Division"]//select
${Var_ExternalMatGrp}    //*[@id="External_Material_Group"]//*[@class="gwt-TextArea"]
${Var_EntitledForm}     //*[@id="Entitlement_Platform"]//select      #( //*[@title="Entitlement Platform"])[2]
${Var_HomeWarehouseForm}    //*[@id="Home_Warehouse"]//select
${Var_OneSourceCodeTax}    //*[@id="One_Source_Tax_Code"]//select
${Var_SaveButton}    (//span[@class="text"])[1]
${Var_Percentagetext}    //*[@class="completenessMeterLabel completenessMeterLabelColor98"]
${Var_SelectAllinJC}    //*[@id="toolbar_button_Select_all"]
${Var_SubmitMedia}    //*[@class="material-icons SubmitButton toolbar-button__icon"]
#//*[@id="PropertySheetTable"]//div//*[@title="Automation-MMHU" and @class="sheet-header-cell sheet-header-horizontal"]
# (//*[@id="PropertySheetTable"]//table//thead//tr)

${Var_ProductIdentifier}    //*[@id="Production_Identifier"]//div//div//*[@class="gwt-TextArea"]
${Var_VCHIdentifier}    //*[@id="VCH_Identifier"]//div//div//*[@class="gwt-TextArea"]
${Var_AlternateTitle}    //*[@id="Alternate_Title"]//div//div//*[@class="gwt-TextArea"]
${Var_FutureTitle}    //*[@id="Future_Title"]//div//div//*[@class="gwt-TextArea"]
${Var_CopytoOnline}    //*[@class="BulkUpdateTemplatePanelField"]//select

${Var-JournalOfferings}     //*[@id="stibo_tab_Journal_Offerings"]


#******************************************Sales and Marketing ********************************
${Var_SalesTab}    //*[@id="stibo_tab_Sales/Marketing_Criteria"]
${Var_SalesWileyRadio}     (//*[@class="gwt-RadioButton radioBoxOption"]//*[contains(@id,"gwt-uid")])[19]



#******************************************END***************************************************

*** Keywords ***

Read All Input Values From OutputExcel
    [Arguments]    ${InputExcel}    ${InputSheet}
    ${ExcelDictionary}    ReadAllValuesFromExcel    ${InputExcel}    ${InputSheet}
    ${MailIdList}    get from dictionary    ${ExcelDictionary}    MailId
    ${OrderIDList}    get from dictionary    ${ExcelDictionary}    OrderId
    ${InvoicedStatusList}    get from dictionary    ${ExcelDictionary}    FecthInvoiceStatus
    set suite variable    ${InvoicedStatusList}    ${InvoicedStatusList}
    set suite variable   ${MailIdList}   ${MailIdList}
    set suite variable    ${OrderIDList}    ${OrderIDList}
    open excel document    ${inputExcelPath}    docID1

Read All Input Values From DataExcel
    [Arguments]    ${InputExcel}    ${InputSheet}
    ${ExcelDictionary}    ReadAllValuesFromExcel    ${InputExcel}    ${InputSheet}
    ${FlagList}    get from dictionary    ${ExcelDictionary}    ExecutionFlag
    ${OrderTypeList}    get from dictionary    ${ExcelDictionary}    OrderType
    ${EnvironmentList}   get from dictionary    ${ExcelDictionary}    ExecutionEnvironment
#    ${NumofOrderList}    get from dictionary    ${ExcelDictionary}    NumberOrderToCreate
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
    ${NewOrderCancellationFlagList}    get from dictionary    ${ExcelDictionary}    NewOrderCancellationFlag
    ${ExistingOrderCancellationFlagList}    get from dictionary    ${ExcelDictionary}    ExistingOrderCancellationFlag
    set suite variable   ${FlagList}   ${FlagList}
    set suite variable    ${NewOrderCancellationFlagList}    ${NewOrderCancellationFlagList}
    set suite variable    ${ExistingOrderCancellationFlagList}    ${ExistingOrderCancellationFlagList}
    set suite variable    ${OrderTypeList}    ${OrderTypeList}
#    set suite variable    ${NumofOrderList}    ${NumofOrderList}
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
    set suite variable    ${EnvironmentList}    ${EnvironmentList}
#    open excel document    ${inputExcelPath}    docID


ReadAllValuesFromExcel
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
    [Return]    ${ExcelDict}

#Get the JSON Path
#    [Arguments]    ${OrderType}
#    IF    '${OrderType}' == 'CC'
#        ${JsonPath}=   set variable    ${json_file_path}
#    END
#    IF    '${OrderType}' == 'Unpaid'
#        ${JsonPath}=     set variable    ${json_file_path}
#    END
#    IF    '${OrderType}' == 'Paid'
#        ${JsonPath}=     set variable    ${json_file_path}
#    END
#    set suite variable    ${JsonPath}    ${JsonPath}
#    [Return]    ${JsonPath}

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
    [Arguments]    ${SAPGUIPATH}    ${SAPUSERNAME}    ${SAPPASSWORD}    ${ENTERBUTTON}    ${CONNECTION}    ${continuebutton}
    Start Process    ${SAPGUIPATH}    saplogon
    sleep    5s
    connect to session
    open connection    ${CONNECTION}
    sapguilibrary.input text      /app/con[0]/ses[0]/wnd[0]/usr/txtRSYST-BNAME    ${SAPUSERNAME}
    sleep    2s
    sapguilibrary.input password    /app/con[0]/ses[0]/wnd[0]/usr/pwdRSYST-BCODE    ${SAPPASSWORD}
    sapguilibrary.click element    ${ENTERBUTTON}
    Click SAP PopUp Button If Present    ${continuebutton}
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
    SeleniumLibrary.click element    /app/con[0]/ses[0]/wnd[1]/tbar[0]/btn[0]
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
    run transaction    /nWE02
    sapguilibrary.input text     ${idocnumberwe02}    ${IdocNumber}
    send vkey    8
#    set focus to element    ${idoclabelindex}
#    send vkey    2
    ${IdocStatus}=    SapGuiLibrary.Get Value    ${idocstatusvalue}
    set suite variable    ${IdocStatus}    ${IdocStatus}
    [Return]    ${IdocStatus}

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
    ${split_result}=    Split String    ${orderexists}    •
#    ${proceedflag}=    run keyword and return status    should not contain    ${orderexists}    0
    ${proceedflag}=    run keyword and return status    should contain    ${split_result[1]}    Total found 0
    IF    '${proceedflag}' == 'False'
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
    [Arguments]    ${json_content}    ${excelrownumber}    ${InputExcelPath}    ${ListIndexIterator}     ${FirstName}    ${LastName}    ${MailId}
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
#    ${FirstName}=  set variable     ${UniqueOrderId}Test
#    ${LastName}=  set variable     ${UniqueOrderId}Auto
#    ${MailId}=  set variable     ${UniqueOrderId}Mail@Wiley.com
#    ${today}=    Get Current Date
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
    Write Output Excel    HappyFlowInputs    NewOrder    ${excelrownumber}    ${UniqueOrderId}
    Write Output Excel    HappyFlowInputs    SubmissionId    ${excelrownumber}    ${SubmissionId}
#    IF    '${CustomerTypeFlag}' == 'True'
    Write Output Excel    HappyFlowInputs    FirstName    ${excelrownumber}    ${FisrtName}
    Write Output Excel    HappyFlowInputs    LastName    ${excelrownumber}    ${LastName}
    Write Output Excel    HappyFlowInputs    MailId    ${excelrownumber}    ${MailId}
#    ELSE
#        ${mailid}=    get from dictionary    ${ExistingMailIdDict}    ${strtowrite}
#        Write Output Excel    Inputs    FirstName    ${excelrownumber}    Refer ExistingUsers Sheet
#        Write Output Excel    Inputs    LastName    ${excelrownumber}    Refer ExistingUsers Sheet
#        Write Output Excel    Inputs    MailId    ${excelrownumber}    ${mailid}
#    END
    Write Output Excel    HappyFlowInputs    DynamicID    ${excelrownumber}    ${Id}
    Write Output Excel    HappyFlowInputs    RandomDhid    ${excelrownumber}    ${Dhid}
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
            write excel cell    ${excelrownumber}    ${columnIndex}    ${value1}    sheet_name=${sheetname}
            excel color cell    ${excelrownumber}    ${columnIndex}    00FF00    ${sheetname}
        ELSE
            write excel cell    ${excelrownumber}    ${columnIndex}    ${value1}::${value2}    sheet_name=${sheetname}
            excel color cell    ${excelrownumber}    ${columnIndex}    FF0000    ${sheetname}
        END
    END

open browser if closed
    [Arguments]    ${URL}
    ${status}=  run keyword and return status  Get Window Identifiers
    IF    '${status}' == 'False'
        Open browser  ${URL}  chrome    options=add_experimental_option("detach", True)
    END
    sleep    7s

Close Invoice Tab
    ${current_window}=    Get Window Handles
    FOR    ${window}    IN    @{current_window}
       switch window    ${window}
       ${title}=    Execute Javascript    return document.title
       Run Keyword If    '${title}' == '${EMPTY}'    Close Window
    END

#***************************************** STEP KEYWORDS************************************
Add Details in Journal Complete
#    JS Click Element    ${Var_JournalCompleteLink}
#    Execute Javascript    window.scrollBy(0, 1000);
#    set selenium speed    3s
##    JS Click Element    ${Var_SelectIcon}
    Wait Until Page Contains Element    ${Var_Spiltter1}
    ${splitter_element}=    Get Webelement    ${Var_Spiltter1}
    Drag And Drop By Offset    ${splitter_element}    0   -500
#    zoom out page
    sleep  3s
    ${strCheckPrint}=    run keyword and return status    element should be visible   ${Var_DigitalJournalDetailsTab}
    IF    '${strCheckPrint}'=='True'
        JS Click Element    ${Var_DigitalJournalDetailsTab}
    ELSE
        JS Click Element    ${Var_PrintJournalDetailsTab}
    END
    sleep  5s
    select from list by value    ${Var_JouranlCompletedStatus}    P
    JS Click Element    ${Var_JournalCompletedFI}
    JS Click Element    ${Var_JournalCompletedFISub}
    ${strCheckFlag}=    run keyword and return status    element should be visible   ${Var_MaterialNumber}
    IF    '${strCheckFlag}'=='True'
        seleniumlibrary.input text    ${Var_MaterialNumber}    ${GrpCode}
    END
#    ${JournalIDCode}=    get text    ${Var_JournalIDCode}
#    IF  '${JournalIDCode}'== '${EMPTY}'
#        ${RandomString}=    generate random string    4    [UPPER]
##        SeleniumLibrary.input text    ${Var_JournalIDCode}    ${GrpCode}-0000-0000-P
#    END
    select from list by value    ${Var_publicationtype}    PR

    Execute Javascript    window.scrollBy(0, 1000);
    JS Click Element    //*[@id="Content_Category"]//*[contains(@id,"gwt-uid-")]
    select from list by value    ${Var_FIDivision}    RE
#    seleniumlibrary.input text    ${Var_ExternalMatGrp}    ${GrpCode}
    ${strCheckHomewarehouse}=    run keyword and return status    element should be visible   (//*[@title="Entitlement Platform"])[2]
    IF    '${strCheckHomewarehouse}'=='True'
        select from list by value    ${Var_EntitledForm}    NA
        select from list by value    ${Var_OneSourceCodeTax}    JU
#        seleniumlibrary.input text    ${Var_JournalMediaProduct}    ${GrpCode}D
    ELSE
        select from list by value    ${Var_HomeWarehouseForm}    P
        select from list by value    ${Var_OneSourceCodeTax}    JO
#        seleniumlibrary.input text    ${Var_JournalMediaProduct}    ${GrpCode}P
    END

    sleep    3s
    JS Click Element    ${Var_SaveButton}
    sleep    3s
    JS Click Element    ${Var_HomeScreenButton}

Add Reference In SAPCostCentre
    [Arguments]    ${SAPCC}
    JS Click Element    ${Var_SAPCCLink}
    set selenium speed    2s
    wait until element is visible    ${Var_SAPCCAddRefLink}
    JS Click Element    ${Var_SAPCCAddRefLink}
    wait until element is visible     ${Var_RefAddIcon}
    JS Click Element    ${Var_RefAddIcon}
    wait until element is visible    ${Var_RefSerach}
    JS Click Element    ${Var_RefSerach}
    seleniumlibrary.input text    ${Var_RefTextbox}    ${SAPCC}
    JS Click Element    ${Var_RefTextSearch}
    JS Click Element    ${Var_RefPopupOkay}
    JS Click Element    ${popupOkay}
    JS Click Element    ${Var_SaveButton}
#    JS Click Element    ${Var_HomeScreenButton}
    set selenium speed    0s

Add Reference in Editorial
    [Arguments]    ${EditCategory}    ${EditApprover}
    JS Click Element    //span[text()="Editorial"]

    wait until element is visible    ${Var_EditorialRefernceButton}
    JS Click Element    ${Var_EditorialRefernceButton}
    set selenium speed    2s
    SeleniumLibrary.select from list by value    //*//table/tbody/tr[1]/td[2]/select    ${EditCategory}
    JS Click Element    ${Var_RefAddIcon}
    JS Click Element    ${Var_RefSerach}
    seleniumlibrary.input text    ${Var_RefTextbox}    ${EditApprover}
    JS Click Element    ${Var_RefTextSearch}
    JS Click Element    ${Var_RefPopupOkay}
    JS Click Element    ${popupOkay}
    JS Click Element    ${Var_SaveButton}
    sleep    5s
#    JS Click Element    (//div[@title="Select all"])[4]
    sleep    5s
    js click element    //table[contains(@class,"first-row-horizontal-content-page last-row-horizontal-content-page")]//tr//td[6]  #(//table[contains(@class,"first-row-horizontal-content-page last-row-horizontal-content-page")])[2]//td[6]
    press combination    key.Y
    sleep    2s
    JS Click Element    (//*[@id="toolbar_button_Create_a_new_reference"])[4]
    sleep    2s
    JS Click Element    //*[@class="gwt-Button button-secondary"]
    SeleniumLibrary.double click element    //table[contains(@class,"first-row-horizontal-content-page last-row-horizontal-content-page")]//tr//td[3]
    JS Click Element    ${Var_SaveButton}
    set selenium speed    0s

Navigate to Journal
    [Arguments]    ${JournalName}
    set selenium speed    2s
    JS Click Element    ${Var_MainSearch}
    JS Click Element    ${Var_JournalSerach}
    seleniumlibrary.input text    ${Var_JournalSerachBox}    ${JournalName}
    JS Click Element    ${Var_SearchIconInTextBox}
    sleep    3s
#    JS Click Element    (//*[@class="material-icons"])[33]
#    JS Click Element    (//*[@class="material-icons"])[33]
    ${splitter_element}=    Get Webelement    xpath=/html/body/div[3]/div[2]/div/div/div[2]/div/div[4]/div/div[2]/div/div[2]/div[4]
    Drag And Drop By Offset    ${splitter_element}    0   -250
    sleep    2s
    wait until element is visible   ${Var_IDLink}
    JS Click Element    ${Var_IDLink}
    JS Click Element    ${Var_MainSearch}
    Wait Until Page Contains Element    ${Var_Spiltter1}
    ${splitter_element}=    Get Webelement    ${Var_Spiltter1}
    Drag And Drop By Offset    ${splitter_element}    0   -200
    sleep    3s
    set selenium speed    0s
    JS Click Element    (//*[@class="material-icons"])[1]

Intiate Journal
    [Arguments]    ${JournalName}
#    Save ScreenShot
    wait until element is visible    ${Var_InitaiteJournalLink}
    JS Click Element    ${Var_InitaiteJournalLink}
    set selenium speed    2s
    wait until element is visible    ${Var_JournalTitleTextBox}
    Save ScreenShot
    seleniumlibrary.input text    ${Var_JournalTitleTextBox}    ${JournalName}
    JS Click Element   ${Var_InitiateJournalSaveButton}
    Save ScreenShot
    sleep    2s

JS Click Element
    [Documentation]    Can be used to click hidden elements
	[Arguments]     ${element_xpath}
    Log    ${element_xpath}
	${ele}    Get WebElement    ${element_xpath}
	${eleFound}=    Run keyword and return status    Wait until page contains element    ${ele}    9s
    Execute Javascript    arguments[0].focus();     ARGUMENTS    ${ele}
    Execute Javascript    arguments[0].click();     ARGUMENTS    ${ele}




Upload the form
    [Arguments]    ${ExcelForm}
    seleniumlibrary.click element    ${Var_selectfile}
    sleep    3s
    type    ${ExcelForm}
    press combination    Key.TAB
    press combination    Key.TAB
    press combination    Key.ENTER

Upload the Handoverform
    [Arguments]    ${ExcelForm}
    seleniumlibrary.click element    //*[@id="Journal_Handover_Import"]//*[@class="button-secondary"]
    sleep    3s
    type    ${ExcelForm}
    press combination    Key.TAB
    press combination    Key.TAB
    press combination    Key.ENTER

Lanch and Login STEP
    [Arguments]    ${STEPURL}    ${UserID}   ${Passkey}
    open browser    ${STEPURL}     Chrome    options=add_experimental_option("detach", True)
    maximize browser window
    wait until element is visible    ${Var_MicrosoftLoginLink}
    SeleniumLibrary.click element    ${Var_MicrosoftLoginLink}
    wait until element is visible    ${Var_UserNameTextInput}
    SeleniumLibrary.input text    ${Var_UserNameTextInput}    ${UserID}
    SeleniumLibrary.click element    ${Var_NextandSignButton}
    wait until element is visible    ${Var_PasswordTextInput}
    SeleniumLibrary.input password    ${Var_PasswordTextInput}    ${Passkey}
    SeleniumLibrary.click element    ${Var_NextandSignButton}
    wait until element is visible    ${Var_NextandSignButton}
    SeleniumLibrary.click element    ${Var_NextandSignButton}
    SeleniumLibrary.click element    ${Var_WileyQALink}
    wait until element is visible    ${Var_AssignedtomeLink}
    SeleniumLibrary.click element    ${Var_AssignedtomeLink}
    JS Click Element    (//*[@class="material-icons"])[1]
#    set selenium speed    0s

Navigate to Manual Enrichment and Update details
#    JS Click Element    (//*[@class="material-icons"])[1]
    set selenium speed    1s
    SeleniumLibrary.input text    ${Var_shorttitletextbox}    TestAutomation
    wait until element is visible    ${Var_JournalOriginal}
    select from list by index    ${Var_JournalOriginal}     3
    wait until element is visible    ${Var_ProductType}
    select from list by index     ${Var_ProductType}    3
    SeleniumLibrary.input text    ${var_journalownedby}    Wiley
    #ownership status
    select from list by index    ${Var_Ownershipped}    4
    #copyright
    SeleniumLibrary.input text    ${Var_Copyright}    Wiley
    #Launch year
    SeleniumLibrary.input text    ${Var_LauchYear}    2024
    #media type
    select from list by index    ${Var_MediaType}    1
    #Revenue mode
    select from list by index    ${Var_RevenueModel}    4
    #Reneval subs type
    select from list by index    ${var_ReneSubsType}    1
    #billing Model
    save screenshot
    select from list by index    ${Var_BillingModel}    2
    SeleniumLibrary.Click Element    ${Var_TrueCheckbox}
    SeleniumLibrary.Click Element    ${Var_JouranlProductTypeCheckBox}
    JS Click Element    ${Var_SaveButton}
    sleep    3s
    JS Click Element    ${Var_SalesTab}
    JS Click Element    ${Var_SalesWileyRadio}
    save screenshot
    JS Click Element    ${Var_SaveButton}
    sleep    3s

Update VCH Identifier
    [Arguments]    ${ProductIdentifier}    ${VCHIdentifier}
    JS Click Element    //*[@id="stibo_tab_Identifiers_and_Descriptions"]
    ${todaydate}    get current date
    ${todaydate}    Convert Date    ${todaydate}    result_format=%Y-%m-%d
    ${todaydate}    Add Time To Date    ${todaydate}    2 days
    ${todaydate}    Convert Date    ${todaydate}    result_format=%Y-%m-%d
    seleniumlibrary.input text    ${Var_ProductIdentifier}      ${ProductIdentifier}
    seleniumlibrary.input text    ${Var_VCHIdentifier}     ${VCHIdentifier}
    seleniumlibrary.input text    ${Var_AlternateTitle}    Test
    seleniumlibrary.input text    ${Var_FutureTitle}    Test
    seleniumlibrary.input text    //*[@class="gwt-TextBox stibo-Value-ISO-Date stibo-Value validator-isodate"]    ${todaydate}
    JS Click Element    ${Var_SaveButton}



Adding Reference in Finance Controls
    [Arguments]    ${FIApprover}
    set selenium speed    0s
    set selenium speed    2s
    JS Click Element    (//*[@class="material-icons"])[1]
    seleniumlibrary.click element    (//span[text()="Finance Controls"])[1]     #/span[text()="Finance Controls"]
    wait until element is visible    ${Var_FIRefernceButton}
    seleniumlibrary.click element     ${Var_FIRefernceButton}
    wait until element is visible    ${Var_RefAddIcon}
    SeleniumLibrary.click element    ${Var_RefAddIcon}
    JS Click Element    ${Var_RefSerach}
    SeleniumLibrary.input text     ${Var_RefTextbox}    ${FIApprover}
    JS Click Element    ${Var_RefTextSearch}
    JS Click Element    ${Var_RefPopupOkay}
    seleniumlibrary.click element    ${popupOkay}
    JS Click Element    ${Var_SaveButton}
    set selenium speed    0s

Enter Data in JournalBaseLine
    [Arguments]    ${JournalGrpCode}    ${digitalIssnCode}    ${JournalDigitalGrpCode}    ${PrintIssn}    ${PrintCode}
    JS Click Element    ${Var_JournalBaseLineInfoLink}
    sleep    5s
    SeleniumLibrary.double click element      ${Var_JouranlGrpCodeTextBox}
    press keys    ${Var_JouranlGrpCodeTextBox}    ${JournalGrpCode}
    press keys    ${None}    TAB
    press keys    ${None}    TAB
    press keys    ${None}    ENTER
    press combination    Key.B
    press keys    ${None}    TAB
    press keys    ${None}    TAB
    press keys    ${None}    ENTER
    press keys    ${Var_DigitalISSNTextBox}    ${digitalIssnCode}
    press keys    ${None}    TAB
    press keys    ${None}    TAB
    press keys    ${None}    ENTER
    press keys    ${Var_DigitalCodeTextBox}    ${JournalDigitalGrpCode}
    press keys    ${None}    TAB
    press keys    ${None}    TAB
    press keys    ${None}    ENTER
    press keys    ${Var_PrintISSNTextBox}    ${PrintIssn}
    press keys    ${None}    TAB
    press keys    ${None}    TAB
    press keys    ${None}    ENTER
    press keys    ${None}     ${PrintCode}
#    sleep    2s
    press keys    ${None}    TAB
    JS Click Element    ${Var_SelectAll}
    JS Click Element    ${Var_SaveIcon}
    sleep    2s
    ${DataCheckFlag}=    run keyword and return status    element should be visible    //*[@class="multi-editor-sp-marginals-title"]
    IF    '${DataCheckFlag}'=='False'
        JS Click Element    ${Var_JouranlBaselineSubmitButtom}
    #    sleep    3s
        wait until element is visible    ${Var_Popuptextbox}
        seleniumlibrary.input text    ${Var_Popuptextbox}    Test
        JS Click Element    ${Var_JouranalBasePopOkayButton}
    #    sleep    3s
        JS Click Element    ${Var_HomeScreenButton}
    END
    [Return]    ${DataCheckFlag}


Zoom Out Page
    Execute Javascript    document.body.style.zoom = "80%";

Zoom Normal
    Execute Javascript    document.body.style.zoom = "100%";      # Adjust zoom level as needed


#Read All Input Values From STEP Input
#    [Arguments]    ${InputExcel}    ${InputSheet}
#    ${ExcelDictionary}    ReadAllValuesFromExcel    ${InputExcel}    ${InputSheet}
#    ${GroupCodeList}    get from dictionary    ${ExcelDictionary}    GroupCode
#    ${PrintISSNList}    get from dictionary    ${ExcelDictionary}    PrintISSN
#    ${DigitalISSNList}    get from dictionary    ${ExcelDictionary}    DigitalISSN
#    ${EditorialApproverList}    get from dictionary    ${ExcelDictionary}    EditorialApprover
#    ${DigitalCodeList}    get from dictionary    ${ExcelDictionary}    DigitalCode
#    ${FIApproverList}    get from dictionary    ${ExcelDictionary}    FIApprover
#    ${SAPCCList}    get from dictionary    ${ExcelDictionary}    SAPCC
#    set suite variable    ${GroupCodeList}    ${GroupCodeList}
#    set suite variable   ${PrintISSNList}   ${PrintISSNList}
#    set suite variable    ${DigitalISSNList}    ${DigitalISSNList}
#    set suite variable    ${EditorialApproverList}    ${EditorialApproverList}
#    set suite variable    ${FIApproverList}    ${FIApproverList}
#    set suite variable    ${DigitalCodeList}    ${DigitalCodeList}
#    set suite variable    ${SAPCCList}    ${SAPCCList}
#    open excel document    ${inputExcelPath}    docID


Read All Input Values For Cancel
    [Arguments]    ${InputExcel}    ${InputSheet}
    ${ExcelDictionary}    ReadAllValuesFromExcel    ${InputExcel}    ${InputSheet}
    ${MailIdList}    get from dictionary    ${ExcelDictionary}    MailId
    ${OrderIDList}    get from dictionary    ${ExcelDictionary}    OrderId
    ${InvoicedStatusList}    get from dictionary    ${ExcelDictionary}    FecthInvoiceStatus
    ${NewOrderList}     get from dictionary    ${ExcelDictionary}    NewOrder
    ${DynamicIdList}    get from dictionary    ${ExcelDictionary}    DynamicID
    ${RandomIdList}    get from dictionary    ${ExcelDictionary}    RandomDhid
    ${SubmissionIDList}    get from dictionary    ${ExcelDictionary}    SubmissionId
    ${TaxList}    get from dictionary    ${ExcelDictionary}    Tax
    ${TotalAmountList}    get from dictionary    ${ExcelDictionary}    TotalAmount
    ${CancellationFlagList}    get from dictionary    ${ExcelDictionary}    CancellationFlag
    set suite variable    ${InvoicedStatusList}    ${InvoicedStatusList}
    set suite variable    ${MailIdList}   ${MailIdList}
    set suite variable    ${OrderIDList}    ${OrderIDList}
    set suite variable    ${NewOrderList}    ${NewOrderList}
    set suite variable    ${TaxList}    ${TaxList}
    set suite variable    ${TotalAmountList}    ${TotalAmountList}
    set suite variable    ${DynamicIdList}    ${DynamicIdList}
    set suite variable    ${RandomIdList}    ${RandomIdList}
    set suite variable    ${SubmissionIDList}     ${SubmissionIDList}
    open excel document    ${inputExcelPath}    docID1

Ready to Publish
    [Arguments]    ${JournalName}
    JS Click Element    //*[@title="Ready for PubYear/Volume/Issue Creation"]
    sleep    3s
    ${LinksCount}=    get element count    (//*[@class="sheet-header-cell sheet-header-horizontal"])
    FOR   ${Iter}    IN RANGE    1    ${LinksCount} + 1
        ${text}=    get text    (//*[@class="sheet-header-cell sheet-header-horizontal"])[${Iter}]
        IF    '${text}'== '${JournalName}'
            ${Printtext}=    get text    (//*[contains(@class,"extra-local")])[${Iter}]
            IF    '${Printtext}'=='Print'
                JS Click Element    (//*[@class="sheet-header-cell sheet-header-horizontal"])[${Iter}]
                exit for loop
            END
        END
    END
    set selenium speed    2s
    JS Click Element    //*[@class="material-icons RunBusinessActionButton toolbar-button__icon"]
    JS Click Element    //*[@class="text"]
    select from list by value    //*[@class="BulkUpdateTemplatePanelField"]//select    Y
    wait until element is visible    //*[@class="stibo-GraphicsButton"]
    JS Click Element    //*[@class="stibo-GraphicsButton"]
    seleniumlibrary.input text    //*[@class="gwt-TextBox validator-number stibo-Value stibo-Value-Number mandatory"]    ${NumberofVolumes}
    JS Click Element    //*[@class="text"]
    ${rowcount}=    get element count    //*[@class="empty sheet-coll"]
    sleep    7s
    FOR   ${testIter}    IN RANGE    0    ${NumberofVolumes}
        SeleniumLibrary.double click element    (//*[@id="PropertySheetTable"]//*[@class="sheet-container"]//td[2])[${testIter} + 1]
        press keys    ${None}    1
        press keys    ${None}    ENTER
    END
    JS Click Element    //*[@class="text"]

Read All Input Values From STEP Input
    [Arguments]    ${InputExcel}    ${InputSheet}
    ${ExcelDictionary}    ReadAllValuesFromExcel    ${InputExcel}    ${InputSheet}
    ${GroupCodeList}    get from dictionary    ${ExcelDictionary}    GroupCode
    ${PrintISSNList}    get from dictionary    ${ExcelDictionary}    PrintISSN
    ${DigitalISSNList}    get from dictionary    ${ExcelDictionary}    DigitalISSN
    ${EditorialApproverList}    get from dictionary    ${ExcelDictionary}    EditorialApprover
    ${DigitalCodeList}    get from dictionary    ${ExcelDictionary}    DigitalCode
    ${FIApproverList}    get from dictionary    ${ExcelDictionary}    FIApprover
    ${SAPCCList}    get from dictionary    ${ExcelDictionary}    SAPCC
    ${PrintCodeList}    get from dictionary    ${ExcelDictionary}    PrintCode
    ${EditCategoryList}    get from dictionary    ${ExcelDictionary}    EditorialCategory
    ${VCHIdentifierList}    get from dictionary    ${ExcelDictionary}       VCHIdentifier
    ${JournalTypeList}    get from dictionary    ${ExcelDictionary}    JournalType
    set suite variable    ${GroupCodeList}    ${GroupCodeList}
    set suite variable    ${VCHIdentifierList}    ${VCHIdentifierList}
    set suite variable    ${PrintCodeList}    ${PrintCodeList}
    set suite variable    ${EditCategoryList}    ${EditCategoryList}
    set suite variable    ${PrintISSNList}   ${PrintISSNList}
    set suite variable    ${DigitalISSNList}    ${DigitalISSNList}
    set suite variable    ${EditorialApproverList}    ${EditorialApproverList}
    set suite variable    ${FIApproverList}    ${FIApproverList}
    set suite variable    ${DigitalCodeList}    ${DigitalCodeList}
    set suite variable    ${SAPCCList}    ${SAPCCList}
    set suite variable    ${JournalTypeList}    ${JournalTypeList}
#    open excel document    ${Var_STEPInput}    docID

Save ScreenShot
    ${screenshotname}=   get time
    ${screenshotname}=    replace string   ${screenshotname}    -    ${EMPTY}
    ${screenshotname}=    replace string   ${screenshotname}    :    ${EMPTY}
    ${screenshotname}=    replace string   ${screenshotname}    ${SPACE}    ${EMPTY}
    capture page screenshot    ${execdir}\\Screenshots\\${screenshotname}.png


Read All Input Values HandoverForm
    [Arguments]    ${InputExcel}    ${InputSheet}
    ${ExcelDictionary}    ReadAllValuesFromExcel    ${InputExcel}    ${InputSheet}
    ${ProductTitleList}    get from dictionary    ${ExcelDictionary}    ProductTitle
    set suite variable    ${ProductTitleList}    ${ProductTitleList}
