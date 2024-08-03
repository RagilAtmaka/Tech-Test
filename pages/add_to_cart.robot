*** Settings ***
Library         SeleniumLibrary
Library         Collections
Resource        ../base/base.robot
Variables       ../resources/locators/add_to_cart_locator.py
Variables        ../resources/data/testdata.py

*** Keywords ***
To Register page
    Wait Until Element Is Visible With Long Time   ${SESAAkun}
    Click Element    ${SESAAkun}
    Click Element    ${SESADaftar}

Fill Register Data
    Wait Until Element Is Visible With Long Time    ${SESADaftarNamaDepan}
    Click Element    ${SESADaftarNamaDepan}
    Input Text    ${SESADaftarNamaDepan}    ${DaftarDepan}
    Click Element    ${SESADaftarNamaBelakang}
    Input Text    ${SESADaftarNamaBelakang}    ${DaftarBelakan}
    ${randomEmail}=    Generate Random Email
    Click Element    ${SESADaftarPassword}
    Input Text    ${SESADaftarPassword}    ${DaftarPassword}
    Click Element    ${SESADaftarKirim}

Validate Registered 
    Wait Until Element Is Visible With Long Time    ${SESAAkunSaya}

Logout
    Wait Until Element Is Visible    ${SESAKeluar}
    Click Element    ${SESAKeluar}

To Login Page
    Wait Until Element Is Visible    ${SESAAkun}
    Click Element    ${SESAAkun}

Do Login
    Wait Until Element Is Visible    ${SESALoginEmail}
    Click Element    ${SESALoginEmail}
    Input Text    ${SESALoginEmail}    ${LoginEmail}
    Click Element    ${SESALoginPassword}
    Input Text    ${SESALoginPassword}    ${LoginPassword}
    Click Element    ${SESALoginMasuk}

Generate Random Email
    ${randomString}=    Generate Random String    8    [LOWER]
    ${randomEmail}=    Set Variable    ${randomString}@yopmail.com
    RETURN    ${randomEmail}

Go To PDP Product By Index
    [Arguments]    ${index}
    Wait Until Element Is Visible With Long Time    ${ProductItemCardName.format(${index})}
    Click Element    ${ProductItemCardName.format(${index})}

Check If On Product Detail Page
    ${IsOnProductDetailPage} =    Run Keyword And Return Status    Element Should Be Visible    ${SESAPDPProductName}
    RETURN    ${IsOnProductDetailPage}

Validate Search Product And Go To PDP
    [Arguments]    ${keyword}
    Search Product result Validation    ${keyword}
    ${IsOnProductDetailPage} =    Check If On Product Detail Page
    IF    not ${IsOnProductDetailPage}    Go To PDP Product By Index    1

Open MiniCart
    Wait Until Element Is Visible With Long Time    ${SESAMinicart}
    Click Element    ${SESAMinicart}

Get Product Name From Minicart
    Wait Until Element Is Visible With Long Time    ${SESAProductItemCartName}
    ${totalItem}=    Get Element Count    ${SESAProductItemCartName}
    ${MiniCartItemList}=    Create List
    FOR    ${Item}    IN RANGE    1    ${totalItem+1}
        ${MinicartItemName}=    Get Text    ${SESAProductItemCartName.format(${Item})}
        Append To List    ${MiniCartItemList}    ${MinicartItemName}
    END
    RETURN    ${MiniCartItemList}

Open And Validate Product on Minicart
    [Arguments]    ${keyword}
    Click Element    ${SESAMinicart}
    Wait Until Element Is Visible    ${SESAProductItemCartName}
        ${txtProductresult}    Get Text    ${SESAProductItemCartName.format(1)}
        ${txtProductresult}    Convert To Lower Case    ${txtProductresult}
        ${validasiProduct_name}    Run Keyword And Return Status
        ...    Should Contain
        ...    ${txtProductresult}
        ...    ${keyword}
        IF    '${validasiProduct_name}'=='False'
            Run Keyword And Continue On Failure    Search Product Not Match    ${keyword}    ${txtProductresult}
        END

Close The Minicart
    Wait Until Element Is Visible    ${SESACloseMiniCart}
    Click Element    ${SESACloseMiniCart}

Empty the items in MiniCart
    Go To Home Page
    Click Element    ${SESAMiniCartLogin}
    ${present}=    Run Keyword and Return Status    Wait Until Page Contains Element    ${SESADeleteItemMiniCart}
    WHILE    ${present}
        Click Element    ${SESADeleteItemMiniCart}
        Wait Until Element Is Not Visible    ${Loader}
        ${present}=    Run Keyword and Return Status    Wait Until Page Contains Element    ${SESADeleteItemMiniCart}
    END
    Close The Minicart
    Go To Home Page

Search Product by Keyword in Searchbox
    [Arguments]    ${keyword}
    Click Element    ${SESASearchIcon}
    Click Element    ${SESASearchBox}
    Input Text    ${SESASearchBox}    ${keyword}
    Wait Until Element Is Visible With Long Time    ${SESASugestedProduct}
    Search Product Suggestion Validation    ${keyword}
    Click Element    ${SESASugestedProduct}

Search Product Suggestion Validation
    [Arguments]    ${keyword}
    ${txtProductSuggestion}    Get Text    ${SESASugestedProduct}
    ${keyword}    Convert To Lower Case    ${keyword}
    ${txtProductSuggestion}    Convert To Lower Case    ${txtProductSuggestion}
    ${validasiProduct_name}    Run Keyword And Return Status    Should Contain    ${txtProductSuggestion}    ${keyword}
    IF    '${validasiProduct_name}'=='False'
        Run Keyword And Continue On Failure    Search Product Not Match    ${keyword}    ${txtProductSuggestion}
    END

Search Product result Validation
    [Arguments]    ${keyword}
    ${ShowPDP}    Run Keyword And Return Status    Wait Until Element Is Visible in 10s    ${SESAPDPProductName}
    ${keyword}    Convert To Lower Case    ${keyword}
    IF    ${ShowPDP}
        Wait Until Element Is Visible    ${SESAPDPProductName}
        ${txtProductresult}    Get Text    ${SESAPDPProductName}
        ${txtProductresult}    Convert To Lower Case    ${txtProductresult}
        ${validasiProduct_name}    Run Keyword And Return Status
        ...    Should Contain
        ...    ${txtProductresult}
        ...    ${keyword}
        IF    '${validasiProduct_name}'=='False'
            Run Keyword And Continue On Failure    Search Product Not Match    ${keyword}    ${txtProductresult}
        END
    ELSE
        ${txtProductresult}    Get Text    ${SESAProductItemCartName.format(1)}
        ${txtProductresult}    Convert To Lower Case    ${txtProductresult}
        ${validasiProduct_name}    Run Keyword And Return Status
        ...    Should Contain
        ...    ${txtProductresult}
        ...    ${keyword}
        IF    '${validasiProduct_name}'=='False'
            Run Keyword And Continue On Failure    Search Product Not Match    ${keyword}    ${txtProductresult}
        END
    END


Add To Cart
    [Arguments]    ${Qty}
    ${SESAPDPProductName} =    Get Product Name From PDP
    ${ProductNameList} =    Create List
    Append To List    ${ProductNameList}    ${SESAPDPProductName}
    Scroll Down To Element    ${SESAAddKeranjang}
    Click Element    ${SESAAddKeranjang}
    RETURN    ${ProductNameList}

View Cart Page
    Wait Until Element Is Visible With Long Time    ${SESALihatKeranjang}
    Click Element    ${SESALihatKeranjang}

Go To Checkout Page
    Wait Until Element Is Visible    ${SESAProsesPesanan}
    Scroll Down To Element    ${SESAProsesPesanan}
    Click Element    ${SESAProsesPesanan}

Get Product Name From PDP
    Wait Until Element Is Visible With Long Time    ${SESAPDPProductName}
    ${PDPProductNameValue} =    Get Text    ${SESAPDPProductName}
    RETURN    ${PDPProductNameValue}

Error Item Added To Cart Not Match
    Fail
    ...    Data Nama Product yang ditambahkan ke kerangjang, tidak sesuai dengan data product dikeranjang

Validate The Similarity Of Item Added To Cart
    [Arguments]    &{Argument}
    ${Argument1}=    Set Variable    ${Argument['productName']}
    ${Argument2}=    Set Variable    ${Argument['MinicartProductNameValue']}
    Log    productName----: ${Argument1}
    Log    MinicartProductNameValue---: ${Argument2}
    ${TotalItem}=    Get Length    ${Argument2}
    IF    ${TotalItem} > 1
        Sort List    ${Argument1}
        Sort List    ${Argument2}
    END
    ${ValidateResult}=    Lists Should Be Equal    ${Argument1}    ${Argument2}
    IF    '${ValidateResult}'=='False'
        Run Keyword And Continue On Failure    Error Item Added To Cart Not Match
    END

Validate The Similarity Of Item On Cart Page
    [Arguments]    &{Arguments}
    ${Argument1}=    Set Variable    ${Arguments['productName']}
    ${Argument3}=    Set Variable    ${Arguments['CartPageProductNameValue']}
    Log    productName----: ${Argument1}
    Log    CartPageProductNameValue---: ${Argument3}
    ${TotalItem}=    Get Length    ${Argument3}
    IF    ${TotalItem} > 1
        Sort List    ${Argument1}
        Sort List    ${Argument3}
    END
    ${ValidateResult}=    Lists Should Be Equal    ${Argument1}    ${Argument3}
    IF    '${ValidateResult}'=='False'
        Run Keyword And Continue On Failure    Error Item Added To Cart Not Match
    END


Get Product Name From Cart Page
    Wait Until Element Is Visible With Long Time    ${SESAProdukShoppingCart}
    ${totalItem}=    Get Element Count    ${SESAProdukShoppingCart}
    ${CartPageItemList}=    Create List
    FOR    ${Item}    IN RANGE    1    ${totalItem+1}
        ${CartPageItemName}=    Get Text    ${SESAProdukShoppingCart.format(${Item})}
        Append To List    ${CartPageItemList}    ${CartPageItemName}
    END

Validate The Similarity Of Item On Checkout Page
    [Arguments]    &{Argument}
    ${Argument1}=    Set Variable    ${Argument['MinicartProductNameValue']}
    ${Argument2}=    Set Variable    ${Argument['CheckoutProductName']}
    Log    MinicartProductNameValue----: ${Argument1}
    Log    CheckoutProductName---: ${Argument2}
    ${TotalItem}=    Get Length    ${Argument2}
    IF    ${TotalItem} > 1
        Sort List    ${Argument1}
        Sort List    ${Argument2}
    END
    ${ValidateResult}=    Lists Should Be Equal    ${Argument1}    ${Argument2}
    IF    '${ValidateResult}'=='False'
        Run Keyword And Continue On Failure    Error Item Added To Cart Not Match
    END

Error Item Added To Compare Not Match
    [Arguments]    ${Argument1}    ${Argument2}
    Fail
    ...    Data Nama Product yang ditambahkan dari pdp : -'${Argument1}'- tidak sesuai dengan data product di halaman Compare : -'${Argument2}'-

Fill Checkout Data Guest
    Wait Until Element Is Visible    ${SESAEmail}
    Click Element    ${SESAEmail}
    Input Text    ${SESAEmail}    ${EmailAddress}
    Click Element    ${SESANamaDepan}
    Input Text    ${SESANamaDepan}    ${NamaDepan}
    Click Element    ${SESANamaBelakang}
    Input Text    ${SESANamaBelakang}    ${NamaBelakang}
    Click Element    ${SESAAlamat}
    Input Text    ${SESAAlamat}    ${Alamat}
    Click Element    ${SESAAlamat}
    Input Text    ${SESAKecamatan}    ${Kecamatan}
    Click Element    ${SESAKota}
    Input Text    ${SESAKota}    ${Kota}
    Click Element    ${SESAKodePos}
    Input Text    ${SESAKodePos}    ${KodePos}

Fill Checkout Data Login
    Wait Until Element Is Visible    ${SESANamaDepan}
    Click Element    ${SESANamaDepan}
    Input Text    ${SESANamaDepan}    ${NamaDepan}
    Click Element    ${SESANamaBelakang}
    Input Text    ${SESANamaBelakang}    ${NamaBelakang}
    Click Element    ${SESAAlamat}
    Input Text    ${SESAAlamat}    ${Alamat}
    Click Element    ${SESAAlamat}
    Input Text    ${SESAKecamatan}    ${Kecamatan}
    Click Element    ${SESAKota}
    Input Text    ${SESAKota}    ${Kota}
    Click Element    ${SESAKodePos}
    Input Text    ${SESAKodePos}    ${KodePos}
    