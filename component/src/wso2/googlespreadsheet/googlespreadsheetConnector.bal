package wso2.googlespreadsheet;

import ballerina.net.http;
import org.wso2.ballerina.connectors.oauth2;

public struct Spreadsheet {
    string spreadsheetId;
    SpreadsheetProperties properties;
    Sheet[] sheets;
    NamedRange[] namedRanges;
    string spreadsheetUrl;
    DeveloperMetadata developerMetadata;
}

public struct SpreadsheetProperties {
    string title;
    string locale;
    string autoRecalc;
    string timeZone;
    CellFormat defaultFormat;
    IterativeCalculationSettings iterativeCalculationSettings;
}

public struct CellFormat {
    NumberFormat numberFormat;
    Color backgroundColor;
    Borders borders;
    Padding padding;
    string horizontalAlignment;
    string verticalAlignment;
    string wrapStrategy;
    string textDirection;
    TextFormat textFormat;
    string hyperlinkDisplayType;
    TextRotation textRotation;
}

public struct NumberFormat {
    string numberFormatType;
    string pattern;
}

public struct Borders {
    Border top;
    Border bottom;
    Border left;
    Border right;
}

public struct Border {
    string style;
    float width;
    Color color;
}

public struct Padding {
    int top;
    int bottom;
    int left;
    int right;
}

public struct TextFormat {
    Color foregroundColor;
    string fontFamily;
    int fontSize;
    boolean bold;
    boolean italic;
    boolean strikethrough;
    boolean underline;
}

public struct TextRotation {
    float angle;
    boolean vertical;
}

public struct IterativeCalculationSettings {
    int maxIterations;
    int convergenceThreshold;
}

public struct NamedRange {
    string namedRangeId;
    string name;
    GridRange range;
}

public struct GridRange {
    float sheetId;
    int startRowIndex;
    int endRowIndex;
    int startColumnIndex;
    int endColumnIndex;
}

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

public struct DeveloperMetadata {
    float metadataId;
    string metadataKey;
    string metadataValue;
    DeveloperMetadataLocation location;
    string visibility;
}

public struct DeveloperMetadataLocation {
    string locationType;
    boolean spreadsheet;
    float sheetId;
    DimensionRange dimensionRange;
}

public struct DimensionRange {
    float sheetId;
    string dimension;
    int startIndex;
    int endIndex;
}

public struct Sheet {
    SheetProperties properties;
    //GridData data;
    GridRange[] merges;
    //ConditionalFormatRule[] conditionalFormats;
    //FilterView[] filterViews;
    //ProtectedRange[] protectedRanges;
    //BasicFilter basicFilter;
    //EmbeddedChart[] charts;
    //BandedRanges bandedRanges;
    DeveloperMetadata developerMetadata;
}

public struct GridData {
    int startRow;
    int startColumn;
    RowData[] rowData;
    //DimensionProperties[] rowMetadata;
    //DimensionProperties[] columnMetadata;
}

public struct RowData {
    CellData[] values;
}

public struct CellData {
    //ExtendedValue userEnteredValue;
    //ExtendedValue effectiveValue;
    string formattedValue;
    CellFormat userEnteredFormat;
    CellFormat effectiveFormat;
    string hyperlink;
    string note;
    //TextFormatRun[] textFormatRuns;
    //DataValidationRule dataValidation;
    //PivotTable pivotTable;
}

public struct ValueRange {
    string range;
    string majorDimension;
    json values;
}

public struct Error {
    json errorMessage;
}

@Description{ value : "Google Spreadsheet client connector"}
@Param{ value : "accessToken: The accessToken of the Google Spreadsheet account to access the Google Spreadsheet REST API"}
@Param{ value : "refreshToken: The refreshToken of the Google Spreadsheet App to access the Google Spreadsheet REST API"}
@Param{ value : "clientId: The clientId of the App to access the Google Spreadsheet REST API"}
@Param{ value : "clientSecret: The clientSecret of the App to access the Google Spreadsheet REST API"}
public connector GoogleSpreadsheetClientConnector (string accessToken, string refreshToken, string clientId,
                           string clientSecret) {
    endpoint<oauth2:ClientConnector> googlespreadsheetEP {
        create oauth2:ClientConnector("https://sheets.googleapis.com", accessToken, clientId, clientSecret,
                                      refreshToken, "https://www.googleapis.com", "/oauth2/v3/token");
    }

    http:HttpConnectorError e;
    TypeConversionError conversionError;
    Error errorResponse = {};

    @Description{ value : "Copies a single sheet from a spreadsheet to another spreadsheet"}
    @Param{ value : "spreadsheetId: Unique value of the spreadsheet"}
    @Param{ value : "sheetId: The ID of the sheet to copy"}
    @Param{ value : "destinationSpreadsheetId: The ID of the spreadsheet to copy the sheet to"}
    @Param{ value : "fields: Specifying which fields to include in a partial response"}
    @Return{ value : "response object"}
    action copyTo (string spreadsheetId, string sheetId,
                  string destinationSpreadsheetId, string fields) (SheetProperties, Error) {
        http:OutRequest request = {};
        http:InResponse response = {};
        SheetProperties copyToResponse = {};
        string copyToPath = "/v4/spreadsheets/" + spreadsheetId + "/sheets/" + sheetId + ":copyTo";

        if(fields != "null") {
            copyToPath = copyToPath + "?" + "fields=" + fields;
        }
        request.setJsonPayload({"destinationSpreadsheetId":destinationSpreadsheetId});
        response, e = googlespreadsheetEP.post(copyToPath, request);
        int statusCode = response.statusCode;
        json googlespreadsheetJSONResponse = response.getJsonPayload();
        if(statusCode == 200) {
            copyToResponse, conversionError = <SheetProperties>googlespreadsheetJSONResponse;
        } else {
            errorResponse.errorMessage = googlespreadsheetJSONResponse.error;
        }
        return copyToResponse, errorResponse;
    }

    @Description{ value : "Create a new spreadsheet"}
    @Param{ value : "payload: The payload containing the information of the post that should be send"}
    @Param{ value : "fields: Specifying which fields to include in a partial response"}
    @Return{ value : "response object"}
    action createSpreadsheet(Spreadsheet spreadsheetRequest, string fields) (Spreadsheet, Error) {
        http:OutRequest request = {};
        http:InResponse response = {};
        json spreadsheetJSONRequest;
        Spreadsheet spreadsheetResponse = {};
        string createSpreadsheetPath = "/v4/spreadsheets";
        spreadsheetJSONRequest, conversionError = <json> spreadsheetRequest;

        if(fields != "null") {
            createSpreadsheetPath = createSpreadsheetPath + "?" + "fields=" + fields;
        }

        request.setJsonPayload(spreadsheetJSONRequest);
        response, e = googlespreadsheetEP.post(createSpreadsheetPath, request);
        int statusCode = response.statusCode;
        json spreadsheetJSONResponse = response.getJsonPayload();
        if(statusCode == 200) {
            spreadsheetResponse, conversionError = <Spreadsheet>spreadsheetJSONResponse;
        } else {
            errorResponse.errorMessage = spreadsheetJSONResponse.error;
        }
        return spreadsheetResponse, errorResponse;
    }
    
    @Description{ value : "Retrieve any set of cell data from a sheet"}
    @Param{ value : "spreadsheetId: Unique value of the spreadsheet"}
    @Param{ value : "range: The A1 notation of the values to retrieve"}
    @Param{ value : "dateTimeRenderOption: How dates, times, and durations should be represented in the output"}
    @Param{ value : "valueRenderOption: How values should be represented in the output"}
    @Param{ value : "fields: Specifying which fields to include in a partial response"}
    @Param{ value : "majorDimension: The major dimension that results should use"}
    @Return{ value : "response object"}
    action getSpreadSheetValues(string spreadsheetId, string range, string dateTimeRenderOption,
                                string valueRenderOption, string fields, string majorDimension) (ValueRange, Error) {
        http:OutRequest request = {};
        http:InResponse response = {};
        ValueRange sheetValues = {};
        string uriParams = "";
        json googlespreadsheetJSONResponse;

        string getSpreadSheetValuesPath = "/v4/spreadsheets/" + spreadsheetId + "/values/" + range;

        if(dateTimeRenderOption != "null") {
            uriParams = uriParams + "&dateTimeRenderOption=" + dateTimeRenderOption;
        }
        if(valueRenderOption != "null") {
            uriParams = uriParams + "&valueRenderOption=" + valueRenderOption;
        }
        if(majorDimension != "null") {
            uriParams = uriParams + "&majorDimension=" + majorDimension;
        }
        if(fields != "null") {
            uriParams = uriParams + "&fields=" + fields;
        }
        println("uriParams: " + uriParams);
        if(uriParams != "") {
            getSpreadSheetValuesPath = getSpreadSheetValuesPath + "?" + uriParams.subString(1, uriParams.length());
        }
        println("getSpreadSheetValuesPath: " + getSpreadSheetValuesPath);

        response, e = googlespreadsheetEP.get(getSpreadSheetValuesPath, request);
        int statusCode = response.statusCode;
        googlespreadsheetJSONResponse = response.getJsonPayload();
        if(statusCode == 200) {
            println(googlespreadsheetJSONResponse.toString());
            sheetValues, conversionError = <ValueRange>googlespreadsheetJSONResponse;
        } else {
            errorResponse.errorMessage = googlespreadsheetJSONResponse.error;
        }
        return sheetValues, errorResponse;
    }

}