*** Settings ***
Documentation    Robot Framework test suite for Jira API testing with JQL queries and Excel export
Library    Collections
Library    RequestsLibrary
Library    DateTime
Library    OperatingSystem
Library    Outlook.py
Library    ExcelExporter.py
Library    JiraAPIKeywords.py
Library    RPA.Excel.Application

*** Variables ***
${JIRA_BASE_URL}           https://wiley.atlassian.net
${JIRA_API_ENDPOINT}       /rest/api/3/search
${JIRA_USERNAME}           dchinnasam@wiley.com
${EMAIL_TO}       dchinnasam@wiley.com    #;hkbonam@wiley.com;smally@wiley.com;kcdodda@wiley.com
${JIRA_TOKEN}              ATATT3xFfGF0uhdYyaPbFOzZSqcKtQcXwY6CuwP34NbeLBGUHxnCBhvSCQp4aaAwbveMd_QtqklLB6QgZl3BpJnoGznjcaLxq_YmzKF5vxmKfrLg7fDePzdsxswecQUzRfwOc0WmyjSTR5Q3FjaLbOkudCb9VkLBDygb2vMYH3vsBnyBZ6T5aXU=D88328FC
${EXCEL_OUTPUT_DIR}        ${CURDIR}/results
${EXCEL_FILENAME}          Jeffsdaily_report
${EMAIL_SUBJECT}     Automated Daily Jeff_Report
${EMAIL_BODY}        Hello team,\n\nPlease find the latest report attached.\n\nBest regards\n\n DeepanRaj
${EMAIL_USER}        dchinnasam@wiley.com

# Default JQL queries for different scenarios
${JQL_ALL_OPEN_ISSUES}   status IN ("Work in progress", "Open", "Pending", "Pending with customer", "Pending with developer", "Pending with vendor", "New", "Implement", "Review", "Authorized", "Pending Release")
...            AND "assignment group[group picker (single group)]" IN ("AMS Gcore Run", "AMS Ecore Run", "AMS eBusiness Run", "AMS CampsProfval Run", "AMS GlobalRights Run", "AMS UKCore Run", "AMS_SAP_ IntelliDocX_RUN", "AMS_SAP_ IntelliDocX_RUN", "AMS_SAP_ABAP", "AMS_SAP_BPC", "AMS_SAP_FICO-PTP", "AMS_SAP_FICO-RTR", "AMS_SAP_FICO_AR", "AMS_SAP_FICO_RAR", "AMS_SAP_Notifications", "AMS_SAP_PDM_MM", "AMS_SAP_PS", "AMS_SAP_QTC_Renewals", "AMS_SAP_QTC_SCM", "AMS_SAP_QTC_SD", "AMS_SAP_QTC_Subs", "AMS_SAP_SECURITY_GRC", "AMS_SAP_SNAPPAY_RUN", "AMS_SAP_TIBCO", "AMS_SAP_VISTEX", "AMS GOI Run", "AMS GBPM Run", "Onesource", "Winshuttle", "AMS_STEP_MDM", "AMS Payment Gateway Run", "AMS_AS_VIAX", "Onesource")
...            AND created >= -2d AND type IN ("[System] Incident", "[System] Service request")


*** Test Cases ***

Export Issues With All Fields To Excel
    [Documentation]    Export issues with comprehensive field set to Excel
    [Tags]             functional    export    comprehensive

    Initialize Jira Connection    ${JIRA_BASE_URL}    ${JIRA_USERNAME}    ${JIRA_TOKEN}

    Create Directory    ${EXCEL_OUTPUT_DIR}

    ${jql_query}=     Set Variable    ${JQL_ALL_OPEN_ISSUES}
    ${fields}=        Create List    key    summary    status    assignee    reporter    created    updated    priority    description    issuetype    components    labels

    ${issues_data}=   Fetch Jira Issues With JQL    ${jql_query}    ${fields}
    Should Not Be Empty    ${issues_data}

    ${timestamp}=     Get Current Date    result_format=%Y%m%d_%H%M%S
    ${excel_file}=    Set Variable    ${EXCEL_OUTPUT_DIR}/${EXCEL_FILENAME}_${timestamp}.xlsx

    Export Issues To Excel With All Fields    ${issues_data['issues']}    ${excel_file}
    File Should Exist    ${excel_file}
    Log    Comprehensive export completed: ${excel_file}
    ${filepath}=    send latest excel via outlook    ${EXCEL_OUTPUT_DIR}     ${EMAIL_TO}   ${EMAIL_SUBJECT}   ${EMAIL_BODY}



