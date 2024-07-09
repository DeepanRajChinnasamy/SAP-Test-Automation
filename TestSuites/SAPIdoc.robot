*** Settings ***
Resource    ../Resource/ObjectRepositories/CustomVariables.robot
#Library    Browser
Library    ScreenCapLibrary
Library    CustomLib.py
Library    Response.py

*** Variables ***
${envi}    stage
*** Test Cases ***
ValidatSAP
#     open sap logon window    ${SAPGUIPATH}    ${SAPUSERNAME}    ${SAPPASSWORD}    ${ENTERBUTTON}    ${CONNECTION}    ${continuebutton}
#     run transaction    /nVA03
#     sapguilibrary.input text    /app/con[0]/ses[0]/wnd[0]/usr/ctxtVBAK-VBELN    60081314
#     send vkey    0
##     sapguilibrary.input text     ${idocnumberwe02}    135317794
##     sapguilibrary.input text    /app/con[0]/ses[0]/wnd[0]/usr/tabsTABSTRIP_IDOCTABBL/tabpSOS_TAB/ssub%_SUBSCREEN_IDOCTABBL:RSEIDOC2:1100/ctxtCREDAT-LOW    ${EMPTY}
##     send vkey    8
#     send vkey    5
##     select node link    /app/con[0]/ses[0]/wnd[0]/usr/shell/shellcont[1]/shell[1]    000001    Spalte1
##     ${ItemId}=    convert to string    "          5","&Hierarchy"
###     set suite variable    ${ItemId}    ("          5", "&Hierarchy")
#     slectTree    /app/con[0]/ses[0]/wnd[0]/usr/shell/shellcont[1]/shell[1]
##     select node link    /app/con[0]/ses[0]/wnd[0]/usr/shell/shellcont[1]/shell[1]     "          5"    "&Hierarchy"
    ${envi}=    convert to lower case    ${envi}
    ${token}=    get token    auth.wileyas.${envi}.viax.io
    ${JsonResp}=  Evaluate  ${token}
    @{list}=     CustomLib.Get Value From Json    ${JsonResp}    $.access_token
    log to console    ${list}[0]
    log    ${list}[0]









#     sapguilibrary.select node    /app/con[0]/ses[0]/wnd[0]/shellcont/shell    Datarecords    expand=True
#     sapguilibrary.select node    /app/con[0]/ses[0]/wnd[0]/shellcont/shell    000001    expand=True
#     sapguilibrary.select node    /app/con[0]/ses[0]/wnd[0]/shellcont/shell    000002    expand=True
#     sapguilibrary.select node link    /app/con[0]/ses[0]/wnd[0]/shellcont/shell   000003   Spalte1
#     ${val}=    SapGuiLibrary.Get Value    /app/con[0]/ses[0]/wnd[0]/usr/tblIDOC_TREE_CONTROLINT_SEG_CONTROL/txtINT_SEG-STRING[1,1]
#     ${val1}=    SapGuiLibrary.Get Value    /app/con[0]/ses[0]/wnd[0]/usr/tblIDOC_TREE_CONTROLINT_SEG_CONTROL/txtINT_SEG-STRING[1,1]
#     ${val2}=    SapGuiLibrary.Get Value    /app/con[0]/ses[0]/wnd[0]/usr/tblIDOC_TREE_CONTROLINT_SEG_CONTROL/txtINT_SEG-STRING[1,1]
#     log to console    ${val}


