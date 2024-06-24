##*** Settings ***
##Library    DateTime
##Library    Collections
##Library    JSONLibrary
##Library    OperatingSystem
##Library    String
##Library    RequestsLibrary
##Library    SeleniumLibrary
##Library    SapGuiLibrary
##Library    ExcelLibrary
##Library    Process
##Library    DateTime
##Library    ImageHorizonLibrary
##Library    Pdf2TextLibrary
##
##*** Variables ***
##${pathtosave}    C:\\Users\\dchinnasam\\OneDrive\\Documents\\VIAXDocs\\
##${URL}       https://wileyas.qa2.viax.io/orders
##${username}     dchinnasam@wiley.com
##${password}     VIRapr@678
##*** Test Cases ***
##Get Current Date and Time
##    ${current_date}=    Get Current Date    result_format=%Y%m%d
##    ${current_datetime}=    Get Current Date    result_format=%Y%m%d%H%M%S
##    ${pathtosave} =    catenate  SEPARATOR=   ${pathtosave}    \
##    log to console    ${pathtosave}
##    Launch and Login DBS    ${URL}    #${username}    ${password}
##    ${titles} =    Get Window Titles
##    Log    List of Window Titles: ${titles}
##    ${new_tab_title} =    Set Variable    ${titles}[0]
##    ${browsercheck}=    run keyword and return status    should contain any    ${new_tab_title}    Sign
##    IF    '${browsercheck}' == 'True'
##        sleep    5s
##        SeleniumLibrary.input text      id=username    ${username}
##        SeleniumLibrary.input password    id=password    ${password}
##        SeleniumLibrary.click element    name=login
##    ELSE
##        log to console    browser opened
##    END
##    ${titles} =    Get Window Titles
##    Log    List of Window Titles: ${titles}
##    ${new_tab_title} =    Set Variable    ${titles}[0]
##    ${browsercheck}=    run keyword and return status    should contain any    ${new_tab_title}    Sign
##     IF    '${browsercheck}' == 'True'
##        sleep    5s
##        SeleniumLibrary.input text      id=username    ${username}
##        SeleniumLibrary.input password    id=password    ${password}
##        SeleniumLibrary.click element    name=login
##    ELSE
##        log to console    browser opened
##    END
##    ${OutboundIdocNumberStatus}    set variable     ${EMPTY}
##    ${OutboundIdocNumberStatus}=    run keyword and return status    should contain    ${OutboundIdocNumberStatus}    IDocs were found
##        IF    '${OutboundIdocNumberStatus}' == 'True'
##            ${IdocCheckFlag}=    set variable    True
##            log to console    Okay
##        ELSE
##            log to console    Yes
##        END
#*** Settings ***
#Library    OperatingSystem
#Library    Process
#Library    SeleniumLibrary
#Library    String
#
#*** Variables ***
#${browser_process_name}    chrome.exe   # Change this to the process name of your browser
#${status}
#${fail keyword}
#${URL}            https://wileyas.qa2.viax.io/orders
#${Browser}        chrome
#${username}     dchinnasam@wiley.com
#${password}     VIRapr@678
#
#*** Test Cases ***
#Check Browser Status
##    Open Browser     https://api.wileyas.qa2.viax.io/graphql    chrome    options=add_experimental_option("detach", True)
##    ${is_browser_running}=    Run Keyword And Return Status    Check Browser Running    ${browser_process_name}
##    log to console    ${is_browser_running}
###    Run Keyword If    ${is_browser_running}    Log    The browser is open.
###    Run Keyword Unless    ${is_browser_running}    Log    The browser is closed.
##    Launch and Login DBS    ${URL}    ${username}    ${password}
##    sleep    90s
###    open browser if closed    ${URL}
##    close tab by title
#
##*** Keywords ***
##Check Browser Running
##    [Arguments]    ${browser_process_name}
##    ${process_count}=    Run Process    tasklist /FI "IMAGENAME eq ${browser_process_name}*"    RETURN RC
##    ${is_running}=    Evaluate    int(${process_count}) > 0
##    [Return]    ${is_running}
#
#    ${strA}=    set variable    First 1 orders • Total found 1 • 8003 in total
#    ${split_result}=    Split String    ${strA}    •
#    Log    ${split_result[0]}
#    Log    ${split_result[1]}
#    Log    ${split_result[2]}
#    ${proceedflag}=    run keyword and return status    should contain    ${split_result[1]}    Total found 0
#    log to console    ${proceedflag}
#
#
#
#*** Keywords ***
#
#Launch and Login DBS
#    [Arguments]    ${URL}    ${username}    ${password}
#    Open Browser    ${URL}    chrome    options=add_experimental_option("detach", True)
#    Maximize Browser Window
#    set selenium speed    3s
#    SeleniumLibrary.input text      id=username    ${username}
#    SeleniumLibrary.input password    id=password    ${password}
#    SeleniumLibrary.click element    name=login
#
#
#open browser if closed
#    [Arguments]    ${URL}
#    ${status}=  run keyword and return status  Get Window Identifiers
#    IF    '${status}' == 'False'
#        Open browser  ${URL}  chrome    options=add_experimental_option("detach", True)
#    END
#
#Close Invoice Tab
#    ${current_window}=    Get Window Handles
#    FOR    ${window}    IN    @{current_window}
#       switch window    ${window}
#       ${title}=    Execute Javascript    return document.title
#       Run Keyword If    '${title}' == '${EMPTY}'    Close Window
#    END
#
#
##*** Keywords ***
#
##Launch and Login DBS
##    [Arguments]    ${URL}    #${username}    ${password}
##    Open Browser    ${URL}    chrome    options=add_experimental_option("detach", True)
##    Maximize Browser Window
##    set selenium speed    3s
##    SeleniumLibrary.input text      id=username    ${username}
##    SeleniumLibrary.input password    id=password    ${password}
##    SeleniumLibrary.click element    name=login


*** Settings ***
Library    Collections

*** Test Cases ***
Check if List is Empty
    ${my_list}=    Create List    # Create an empty list
    Length Should Be    ${my_list}    0    # Check if the list is empty

Check if List is Empty
    ${my_list}=    Create List    # Create an empty list
    Should Be Empty    ${my_list}   # Check if the list is empty
