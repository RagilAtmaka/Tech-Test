*** Settings ***
Library         SeleniumLibrary
Library         String
Variables       ../resources/data/testdata.py

*** Keywords ***
Go To Home Page
    Go To    ${URLWEB}

Search Product Not Match
    [Arguments]    ${Keyword}    ${Result}
    Fail    Data Nama Product '${Result}' tidak sesuai dengan katakunci : ${Keyword}

Scroll Down To Element
    [Arguments]    ${locator}
    ${x}=    Get Horizontal Position    ${locator}
    ${y}=    Get Vertical Position    ${locator}
    Execute Javascript    window.scrollTo(${x}, ${y}-100)

Validate Similarity Of 2 Arguments
    [Arguments]    ${Argument1}    ${Argument2}
    ${Argument1}=    Convert To Lower Case    ${Argument1}
    ${Argument2}=    Convert To Lower Case    ${Argument2}
    ${ValidateSimilarity}=    Run Keyword And Return Status    Should Be Equal    ${Argument1}    ${Argument2}
    RETURN    ${ValidateSimilarity}

Generate Random PhoneNumber
    ${randomString}=                    Generate Random String      10   [NUMBERS]
    ${PhoneNumber}=                     Set Variable                ${randomString}
    RETURN                            ${PhoneNumber}

Generate Random Name
    ${randomString}=                    Generate Random String      5   [LETTERS]
    ${Name}=                     Set Variable                ${randomString}
    RETURN                            ${SPACE}${Name}

Generate Random Keyword
    ${randomString}    Generate Random String      5   [LETTERS]
    ${Name}    Set Variable    ${randomString}
    RETURN  ${Name}${SPACE}Automation
    
Generate Random Invalid Email
    ${randomString}=    Generate Random String    8    [LOWER]
    ${randomEmail}=    Set Variable    ${randomString}gmail.com
    RETURN    ${randomEmail}

Convert Price String To Integer
    #format string example: 	Rp 40,000.00
    [Arguments]  ${value}
    ${cleaned_string}  Replace String  ${value}  Rp    replace_with=
    ${cleaned_string}  Replace String  ${cleaned_string}  ,    replace_with=
    ${cleaned_string}  Replace String  ${cleaned_string}  .00    replace_with=
    ${integer_value}=  Evaluate  int(${cleaned_string})
    RETURN  ${integer_value}

Wait Until Element Is Visible With Long Time
    [Arguments]    ${Element}
    Wait Until Element Is Visible    ${Element}    45

Wait Until Element Is Visible in 10s
    [Arguments]    ${Element}
    Wait Until Element Is Visible    ${Element}    10

Wait Until Element Is Not Visible With Long Time
    [Arguments]    ${Element}
    Wait Until Element Is Not Visible    ${Element}    45

Alert Warning Validation Register
    [Arguments]    ${AlertMessage}
    Wait Until Element Is Visible    ${AlertMessage}