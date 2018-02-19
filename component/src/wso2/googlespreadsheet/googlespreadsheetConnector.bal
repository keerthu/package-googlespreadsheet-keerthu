package wso2.googlespreadsheet;

import ballerina.net.http;
import org.wso2.ballerina.connectors.oauth2;

public struct SheetProperties {
    float sheetId;
    string title;
    int index;
    string sheetType;
    GridProperties gridProperties;
    boolean hidden;
    Color tabColor;
    boolean rightToLeft;
}

public struct Color {
    int red;
    int green;
    int blue;
    float alpha;
}

public struct GridProperties {
    int rowCount;
    int columnCount;
    int frozenRowCount;
    int frozenColumnCount;
    boolean hideGridlines;
}

public struct Error {
    json errorMessage;
}
@Description{ value : "Google Spreadsheet client connector"}
@Param{ value : "accessToken: The accessToken of the Google Spreadsheet account to access the Google Spreadsheet REST API"}
@Param{ value : "refreshToken: The refreshToken of the Google Spreadsheet App to access the Google Spreadsheet REST API"}
@Param{ value : "clientId: The clientId of the App to access the Google Spreadsheet REST API"}
@Param{ value : "clientSecret: The clientSecret of the App to access the Google Spreadsheet REST API"}
public connector ClientConnector (string accessToken, string refreshToken, string clientId,
                           string clientSecret) {
    endpoint<oauth2:ClientConnector> googlespreadsheetEP {
        create oauth2:ClientConnector("https://sheets.googleapis.com", accessToken, clientId, clientSecret, refreshToken,
        "https://www.googleapis.com", "/oauth2/v3/token");
    }

    http:HttpConnectorError e;
    Error errorResponse = {};

    @Description{ value : "Copies a single sheet from a spreadsheet to another spreadsheet"}
    @Param{ value : "spreadsheetId: Unique value of the spreadsheet"}
    @Param{ value : "sheetId: The ID of the sheet to copy"}
    @Param{ value : "destinationSpreadsheetId: The ID of the spreadsheet to copy the sheet to"}
    @Param{ value : "fields: Specifying which fields to include in a partial response"}
    @Return{ value : "response object"}
    action copyTo(string spreadsheetId, string sheetId,
                  string destinationSpreadsheetId, string fields) (SheetProperties, Error) {
        http:OutRequest request = {};
        http:InResponse response = {};
        SheetProperties copyToResponse = {};
        json googlespreadsheetJSONResponse;
        string copyToPath = "/v4/spreadsheets/" + spreadsheetId + "/sheets/" + sheetId + ":copyTo";

        if(fields != "null") {
            copyToPath = copyToPath + "?" + "fields=" + fields;
        }
        request.setJsonPayload({"destinationSpreadsheetId":destinationSpreadsheetId});
        response, e = googlespreadsheetEP.post(copyToPath, request);
        int statusCode = response.statusCode;
        println("Status code: " + statusCode);
        googlespreadsheetJSONResponse = response.getJsonPayload();
        if(statusCode == 200) {
            println(googlespreadsheetJSONResponse.toString());
            copyToResponse, _ = <SheetProperties>googlespreadsheetJSONResponse;
        } else {
            errorResponse.errorMessage = googlespreadsheetJSONResponse.error;
        }
        return copyToResponse, errorResponse;
    }
}