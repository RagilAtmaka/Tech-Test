*** Settings ***
Library         SeleniumLibrary
Library         Collections
Resource        ../pages/add_to_cart.robot
Variables       ../resources/locators/add_to_cart_locator.py
Resource        ../base/setup.robot
Resource         ../base/base.robot
Variables        ../resources/data/testdata.py

Test Setup       Start Test Case
#Test Teardown    End Test Case

*** Test Cases ***

Guest User Add To Cart
    Search Product by Keyword in Searchbox    ${SESASimpleProduk}
    Validate Search Product And Go To PDP    ${SESASimpleProduk}
    @{productName} =    Add To Cart    Qty=1
    Open MiniCart
    @{MinicartProductNameValue}    Get Product Name From Minicart
    &{Arguments}    Create Dictionary
    ...    productName=@{productName}
    ...    MinicartProductNameValue=@{MinicartProductNameValue}
    Validate The Similarity Of Item Added To Cart    &{Arguments}
    View Cart Page
    Go To Checkout Page
    Fill Checkout Data Guest
    
#Register Account
#    Go To Home Page
#    To Register page
#    Fill Register Data
#    Validate Registered
#    Logout

Logged In User Add To Cart
    Go To Home Page
    Empty the items in MiniCart
    To Login Page
    Do Login
    Go To Home Page
    Search Product by Keyword in Searchbox    ${SESASimpleProduk}
    Validate Search Product And Go To PDP    ${SESASimpleProduk}
    @{productName} =    Add To Cart    Qty=1
    Open MiniCart
    @{MinicartProductNameValue}    Get Product Name From Minicart
    &{Arguments}    Create Dictionary
    ...    productName=@{productName}
    ...    MinicartProductNameValue=@{MinicartProductNameValue}
    Validate The Similarity Of Item Added To Cart    &{Arguments}
    View Cart Page
    Go To Checkout Page
    Fill Checkout Data Login