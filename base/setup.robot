*** Settings ***
Library     SeleniumLibrary
Library     String
Variables   ../resources/data/testdata.py

*** Variables ***
${BROWSER}    Chrome
${CromeDriverPath}    ${CURDIR}/../../chromedriver/chromedriver    #Mendefinisikan variabel ${CromeDriverPath} yang berisi path ke executable ChromeDriver. ${CURDIR} adalah variabel built-in Robot Framework yang menunjuk ke direktori kerja saat ini.
${EdgeDriverPath}     ${CURDIR}/../../edgedriver/msedgedriver      #Mendefinisikan variabel ${EdgeDriverPath} yang berisi path ke executable EdgeDriver.


*** Keywords ***
Start Test Case    
    ${OS}=    Evaluate    platform.system()    platform    #Mengevaluasi dan menyimpan nama sistem operasi ke dalam variabel ${OS} menggunakan library Python platform.
    Log    "running on ${OS}-${BROWSER}"                   #Mencetak log yang menunjukkan sistem operasi dan browser yang digunakan.
    @{Browser_id}=    Get Browser Ids                      #Mengambil ID browser yang sedang aktif dan menyimpannya dalam daftar ${Browser_id}.
    Run Keyword if    @{Browser_id}==[]    Start Test      #Menjalankan keyword Start Test jika daftar ${Browser_id} kosong.

Start Test
    ${OS}=    Evaluate    platform.system()    platform
    IF  '${OS}'=="Linux"
        IF  '${BROWSER}'=='Chrome'
            Log To Console    "running on Linux - Chrome"
            ${BrowserConfiguration}    Set Variable    chrome_options
            ${ExecutablePath}    Set Variable    ${CromeDriverPath}
            Setup Browser Option Configuration    ${BrowserConfiguration}    ${ExecutablePath}
        ELSE IF  '${BROWSER}'=='Edge'
            Log To Console    "running on Linux - Edge"
            ${BrowserConfiguration}    Set Variable    options
            ${ExecutablePath}    Set Variable    ${EdgeDriverPath}
            Setup Browser Option Configuration    ${BrowserConfiguration}    ${ExecutablePath}
        END
        
    ELSE IF    '${OS}'=="Windows"
        IF  '${BROWSER}'=='Chrome'
            Log To Console    "running on Windows - Chrome"
            ${BrowserConfiguration}    Set Variable    chrome_options
            ${ExecutablePath}    Set Variable    ${CromeDriverPath}
            Setup Browser Option Configuration    ${BrowserConfiguration}    ${ExecutablePath}
       ELSE IF  '${BROWSER}'=='Edge'
            Log To Console    "running on Windows - Edge"
            ${BrowserConfiguration}    Set Variable    options
            ${ExecutablePath}    Set Variable    ${EdgeDriverPath}
            Setup Browser Option Configuration    ${BrowserConfiguration}    ${ExecutablePath}
        END
     ELSE IF    '${OS}'=="Darwin"
            IF  '${BROWSER}'=='Chrome'
                Log To Console    "running on MacOS - Chrome"
                ${BrowserConfiguration}    Set Variable    chrome_options
                ${ExecutablePath}    Set Variable    ${CromeDriverPath}
                Setup Browser Option Configuration    ${BrowserConfiguration}    ${ExecutablePath}
            ELSE IF  '${BROWSER}'=='Edge'
                Log To Console    "running on MacOS - Edge"
                ${BrowserConfiguration}    Set Variable    options
                ${ExecutablePath}    Set Variable    ${EdgeDriverPath}
                Setup Browser Option Configuration    ${BrowserConfiguration}    ${ExecutablePath}
            ELSE IF  '${BROWSER}'=='Safari'
                Log To Console    "running on MacOS - Safari"
                ${BrowserConfiguration}    Set Variable    options
                Create WebDriver    ${BROWSER}
            END
    END
    Maximize Browser Window
    Go to   ${URLWEB}
    Execute JavaScript    document.body.style.zoom = "100%"
    Set selenium speed  1

Setup Browser Option Configuration
    [Arguments]    ${BrowserConfiguration}    ${ExecutablePath}
    ${options}=  Evaluate  sys.modules['selenium.webdriver'].${BROWSER}Options()  sys, selenium.webdriver
    Call Method    ${options}    add_argument    --disable-extensions
    Call Method    ${options}    add_argument    --disable-gpu
    Call Method    ${options}    add_argument    window-size\=1920,1080
    ${options.prefs}    Create Dictionary    profile.default_content_setting_values.geolocation     1
    Call Method    ${options}    add_experimental_option    prefs       ${options.prefs}
    Create WebDriver    ${BROWSER}    ${BrowserConfiguration}=${options}   executable_path=${ExecutablePath}