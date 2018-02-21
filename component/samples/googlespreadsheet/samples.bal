import wso2.googlespreadsheet;
import ballerina.net.http;

function main (string[] args) {
    endpoint<googlespreadsheet:GoogleSpreadsheetClientConnector> googlespreadsheetConnector {
        create googlespreadsheet:GoogleSpreadsheetClientConnector(args[1], args[2], args[3], args[4]);
    }

    googlespreadsheet:Error e = {};
    json googlespreadsheetJSONResponse;

    if (args[0] == "copyTo") {
        googlespreadsheet:SheetProperties googlespreadsheetResponse = {};
        googlespreadsheetResponse, e = googlespreadsheetConnector.copyTo(args[5], args[6], args[7], args[8]);
        if(e == null) {
            println(googlespreadsheetResponse);
        } else {
            println(e);
        }
    } else if (args[0] == "getSpreadSheetValues") {
        googlespreadsheet:ValueRange sheetValuesResponse = {};
        sheetValuesResponse, e = googlespreadsheetConnector.getSpreadSheetValues(args[5], args[6], args[7], args[8], args[9], args[10]);
        if(e == null) {
            println(sheetValuesResponse);
        } else {
            println(e);
        }
    } else if (args[0] == "createSpreadsheet") {
        println("---------Calling createSpreadsheet-----------");
        googlespreadsheet:SpreadsheetProperties spreadsheetProperties = {title:"TestBal",autoRecalc:"ON_CHANGE"};
        googlespreadsheet:Spreadsheet spreadsheetRequestStruct = {};
        spreadsheetRequestStruct.properties = spreadsheetProperties;
        println("####spreadsheetRequestStruct###");
        println(spreadsheetRequestStruct);

        googlespreadsheet:Spreadsheet spreadsheetResponse = {};
        spreadsheetResponse, e = googlespreadsheetConnector.createSpreadsheet(spreadsheetRequestStruct, args[5]);
        println(spreadsheetResponse);
        if(e == null) {
            println(spreadsheetResponse);
        } else {
            println(e);
        }
    }
}
