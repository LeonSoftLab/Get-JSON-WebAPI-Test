unit UnitMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.Generics.Collections, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, dxSkinsCore, dxSkinBasic, dxSkinBlue, dxSkinCaramel, dxSkinOffice2010Silver,
  dxSkinOffice2013White, cxLabel, cxTextEdit, Data.Bind.Components, Data.Bind.ObjectScope,
  REST.Client, REST.Authenticator.OAuth, IPPeerClient, Vcl.Menus, Vcl.StdCtrls, cxButtons,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, cxMemo,
  System.IOUtils, System.Net.HttpClient, System.JSON, IdIOHandler, System.DateUtils,
  IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, REST.Types,
  cxGroupBox, cxClasses, dxNavBarBase, dxNavBarCollns, dxNavBar, cxSplitter,
  cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxNavigator,
  dxDateRanges, dxScrollbarAnnotations, Data.DB, cxDBData, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxButtonEdit;

type
  TMyBaseRESTObject = class
    private
      FOwner: TComponent;
      FAuthenticator: TOAuth2Authenticator;
      FRESTClient: TRESTClient;
      FRESTRequest: TRESTRequest;
      FRESTResponse: TRESTResponse;

      FAPIObject: string;
      FJSONArray: TJSONArray;
      procedure LoadJSONFromAPI(AAPIObject: string); virtual;
    public
      constructor Create(AOwner: TComponent; AAuthenticator: TOAuth2Authenticator; ABaseAPIURL: string); virtual;
      destructor Destroy; override;
  end;

  TMyReportItemObject = class
    private
      Fid: Integer;
      Fname: string;
      Fdescription: string;
      Fcode_name: string;
      Ffile_name: string;
    public
      constructor Create(const Aid: Integer; Aname, Adescription, Acode_name, Afile_name: string);
      property id: Integer read Fid write Fid;
      property name: string read Fname write Fname;
      property description: string read Fdescription write Fdescription;
      property code_name: string read Fcode_name write Fcode_name;
      property file_name: string read Ffile_name write Ffile_name;
  end;

  TMyReportArrayObject = class(TMyBaseRESTObject)
    private
      FReportList: TObjectList<TMyReportItemObject>;
      
      function GetItem(AIndex: Integer): TMyReportItemObject;
      function GetCount: Integer;
      procedure AddElement(const Aid: Integer; Aname, Adescription, Acode_name, Afile_name: string);
      procedure DeleteElement(const AIndex: Integer);
      procedure SetItem(Index: Integer; const Value: TMyReportItemObject);
      procedure Clear;
      procedure DeserializeJSON;
    public
      constructor Create(AOwner: TComponent; AAuthenticator: TOAuth2Authenticator; ABaseAPIURL: string); override;
      destructor Destroy; override;
      procedure GET(AAPIObject: string);
      procedure Show(AGrid: TcxGridTableView);
      
      property Items[Index: Integer]: TMyReportItemObject read GetItem;
      property Count: Integer read GetCount;
  end;

  TForm_Main = class(TForm)
    cxMemo_log: TcxMemo;
    cxGroupBox_Auth: TcxGroupBox;
    cxButton_OAuth2Connect: TcxButton;
    cxTextEdit_Login: TcxTextEdit;
    cxTextEdit_Password: TcxTextEdit;
    cxLabel_Login: TcxLabel;
    cxLabel_Password: TcxLabel;
    OAuth2Authenticator1: TOAuth2Authenticator;
    cxGroupBox_Data: TcxGroupBox;
    cxButton_getTestData: TcxButton;
    cxTextEdit_serverURL: TcxTextEdit;
    cxLabel_serverURL: TcxLabel;
    dxNavBar: TdxNavBar;
    dxNavBarGroup_References: TdxNavBarGroup;
    dxNavBar_refReports: TdxNavBarItem;
    cxLookAndFeelController1: TcxLookAndFeelController;
    cxSplitter1: TcxSplitter;
    cxButton_getReports: TcxButton;
    cxGridLevel: TcxGridLevel;
    cxGrid: TcxGrid;
    cxGridTableView: TcxGridTableView;
    cxGridTableViewColumn_id: TcxGridColumn;
    cxGridTableViewColumn_name: TcxGridColumn;
    cxGridTableViewColumn_description: TcxGridColumn;
    cxGridTableViewColumn_code_name: TcxGridColumn;
    cxGridTableViewColumn_file_name: TcxGridColumn;
    procedure cxButton_getTestDataClick(Sender: TObject);
    procedure cxButton_OAuth2ConnectClick(Sender: TObject);
    procedure cxButton_getReportsClick(Sender: TObject);
    procedure dxNavBar_refReportsClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_Main: TForm_Main;

implementation

{$R *.dfm}

procedure TForm_Main.cxButton_getReportsClick(Sender: TObject);
var
  RESTClient: TRESTClient;
  RESTRequest: TRESTRequest;
  RESTResponse: TRESTResponse;
  JsonObject: TJSONObject;
  JsonArray: TJSONArray;
  JsonPair: TJSONPair;
  i: Integer;
begin
  cxMemo_log.Clear;
  cxMemo_log.Lines.Add('--------------------------'+(Sender as TcxButton).Name);
  RESTClient := TRESTClient.Create(Self);
  RESTRequest := TRESTRequest.Create(Self);
  RESTResponse := TRESTResponse.Create(Self);
  RESTClient.BaseURL := cxTextEdit_serverURL.Text;
  RESTClient.Authenticator := OAuth2Authenticator1;
  RESTRequest.Client := RESTClient;
  RESTRequest.Response := RESTResponse;
  RESTRequest.Resource := 'reports';
  RESTRequest.Method := rmGET;
  RESTRequest.Execute;

  if RESTResponse.StatusCode = 200 then
  begin
    cxMemo_log.Lines.Add('ContentLength: ' + IntToStr(RESTResponse.ContentLength)+
      '   ContentType: ' + RESTResponse.ContentType);
    cxMemo_log.Lines.Add(RESTResponse.Content);
    cxMemo_log.Lines.Add('---=='+TJSONObject.ParseJSONValue(RESTResponse.Content).ClassName+'=---');
    try
      JsonArray := TJSONObject.ParseJSONValue(RESTResponse.Content) as TJSONArray;
      if Assigned(JsonArray) then
      begin
        // Перебор элементов JSON-массива
        for i := 0 to JsonArray.Count - 1 do
        begin
          JsonObject := JsonArray.Items[i] as TJSONObject;
          // Получение значений по ключам
          //logMemo.Lines.Add('ID: ' + JsonObject.GetValue('id').Value);
          for JsonPair in JsonObject do
          begin
            cxMemo_log.Lines.Add(JsonPair.JsonString.Value + ': ' + JsonPair.JsonValue.Value);
          end;
          cxMemo_log.Lines.Add('--------------------------');
        end;
      end
      else
      begin
        cxMemo_log.Lines.Add('Failed to parse JSON response.');
      end;
    finally
      jsonArray.Free;
    end;
  end
  else
  begin
    cxMemo_log.Lines.Add('ERROR! StatusCode: ' + IntToStr(RESTResponse.StatusCode) + ' StatusText: ' + RESTResponse.StatusText);
    JsonObject := TJSONObject.ParseJSONValue(RESTResponse.Content) as TJSONObject;
    for JsonPair in JsonObject do
      begin
        cxMemo_log.Lines.Add(JsonPair.JsonString.Value + ': ' + JsonPair.JsonValue.Value);
      end;
  end;
end;

procedure TForm_Main.cxButton_getTestDataClick(Sender: TObject);
var
  RESTClient: TRESTClient;
  RESTRequest: TRESTRequest;
  RESTResponse: TRESTResponse;
  JsonObject: TJSONObject;
  JsonArray: TJSONArray;
  JsonPair: TJSONPair;
  i: Integer;
begin
  cxMemo_log.Clear;
  cxMemo_log.Lines.Add('--------------------------'+(Sender as TcxButton).Name);
  RESTClient := TRESTClient.Create(Self);
  RESTRequest := TRESTRequest.Create(Self);
  RESTResponse := TRESTResponse.Create(Self);
  RESTClient.BaseURL := cxTextEdit_serverURL.Text;
  RESTRequest.Client := RESTClient;
  RESTRequest.Response := RESTResponse;
  RESTRequest.Resource := 'testdata';
  RESTRequest.Method := rmGET;
  RESTRequest.Execute;

  if RESTResponse.StatusCode = 200 then
  begin
    cxMemo_log.Lines.Add('ContentLength: ' + IntToStr(RESTResponse.ContentLength)+
      '   ContentType: ' + RESTResponse.ContentType);
    cxMemo_log.Lines.Add(RESTResponse.Content);
    cxMemo_log.Lines.Add('---=='+TJSONObject.ParseJSONValue(RESTResponse.Content).ClassName+'=---');
    try
      JsonArray := TJSONObject.ParseJSONValue(RESTResponse.Content) as TJSONArray;
      if Assigned(JsonArray) then
      begin
        // Перебор элементов JSON-массива
        for i := 0 to JsonArray.Count - 1 do
        begin
          JsonObject := JsonArray.Items[i] as TJSONObject;
          // Получение значений по ключам
          //logMemo.Lines.Add('ID: ' + JsonObject.GetValue('id').Value);
          for JsonPair in JsonObject do
          begin
            cxMemo_log.Lines.Add(JsonPair.JsonString.Value + ': ' + JsonPair.JsonValue.Value);
          end;
          cxMemo_log.Lines.Add('--------------------------');
        end;
      end
      else
      begin
        cxMemo_log.Lines.Add('Failed to parse JSON response.');
      end;
    finally
      jsonArray.Free;
    end;
  end
  else
  begin
    // Если произошла ошибка, выводим сообщение об ошибке
    ShowMessage('Error: ' + IntToStr(RESTResponse.StatusCode) + ' - ' + RESTResponse.StatusText);
  end;
end;

procedure TForm_Main.cxButton_OAuth2ConnectClick(Sender: TObject);
var
  RESTClient: TRESTClient;
  RESTRequest: TRESTRequest;
  RESTResponse: TRESTResponse;
  TokenObject: TJSONObject;
  JsonObject: TJSONObject;
  JsonPair: TJSONPair;
begin
  cxMemo_log.Clear;
  cxMemo_log.Lines.Add('--------------------------'+(Sender as TcxButton).Name);
  RESTClient := TRESTClient.Create(Self);
  RESTRequest := TRESTRequest.Create(Self);
  RESTResponse := TRESTResponse.Create(Self);
  RESTClient.BaseURL := cxTextEdit_serverURL.Text;
  RESTRequest.Client := RESTClient;
  RESTRequest.Response := RESTResponse;
  RESTRequest.Accept := 'application/json';

  try
    RESTClient.BaseURL := cxTextEdit_serverURL.Text;
    RESTClient.Authenticator := OAuth2Authenticator1;
    with RESTRequest do
    begin
      Resource := 'login';
      Method := rmPOST;
      Params.Clear;
      AddParameter('grant_type', '');
      AddParameter('username', cxTextEdit_Login.Text);
      AddParameter('password', cxTextEdit_Password.Text);
      AddParameter('scope', '');
      AddParameter('client_id', '');
      AddParameter('client_secret', '');
    end;
    RESTRequest.Execute;
    cxMemo_log.Lines.Add('ContentLength: ' + IntToStr(RESTResponse.ContentLength)+
      '   ContentType: ' + RESTResponse.ContentType);
    cxMemo_log.Lines.Add(RESTResponse.Content);
    cxMemo_log.Lines.Add('---=='+TJSONObject.ParseJSONValue(RESTResponse.Content).ClassName+'=---');
    if RESTResponse.StatusCode = 200 then
    begin
      TokenObject := TJSONObject.ParseJSONValue(RESTResponse.Content) as TJSONObject;
      cxMemo_log.Lines.Add('sub: ' + TokenObject.GetValue('sub').Value);
      cxMemo_log.Lines.Add('exp: ' + TokenObject.GetValue('exp').Value);
      cxMemo_log.Lines.Add('access_token: ' + TokenObject.GetValue('access_token').Value);
      cxMemo_log.Lines.Add('token_type: ' + TokenObject.GetValue('token_type').Value);
      with OAuth2Authenticator1 do
      begin
        AccessTokenEndpoint := cxTextEdit_serverURL.Text + 'login';
        ClientID := '';
        ClientSecret := '';
        ResponseType := TOAuth2ResponseType.rtTOKEN;
        AccessTokenParamName := 'access_token';
        TokenType := TOAuth2TokenType.ttBEARER;
        AccessToken := TokenObject.GetValue('access_token').Value;
        AccessTokenExpiry := ISO8601ToDate(TokenObject.GetValue('exp').Value);
      end;
    end
    else
    begin
      cxMemo_log.Lines.Add('ERROR! StatusCode: ' + IntToStr(RESTResponse.StatusCode) + ' StatusText: ' + RESTResponse.StatusText);
      JsonObject := TJSONObject.ParseJSONValue(RESTResponse.Content) as TJSONObject;
      for JsonPair in JsonObject do
        begin
          cxMemo_log.Lines.Add(JsonPair.JsonString.Value + ': ' + JsonPair.JsonValue.Value);
        end;
    end;
  finally
    RESTClient.Free;
    RESTRequest.Free;
    RESTResponse.Free;
  end;
end;

procedure TForm_Main.dxNavBar_refReportsClick(Sender: TObject);
var
  testObj: TMyReportArrayObject;
  i:integer;
begin
try
  testObj := TMyReportArrayObject.Create(Self,OAuth2Authenticator1,cxTextEdit_serverURL.Text);
  testObj.GET('reports');
  cxMemo_log.Lines.Add('object TMyReportArrayObject - loaded');
  testObj.Show(cxGridTableView);
except
 on E:Exception do
   begin
     cxMemo_log.Lines.Add('ERROR! on getReports - ' + E.ClassName);
     cxMemo_log.Lines.Add(E.Message);
   end;
end;
end;

{ TMyBaseRESTObject }

constructor TMyBaseRESTObject.Create(AOwner: TComponent; AAuthenticator: TOAuth2Authenticator; ABaseAPIURL: string);
begin
  FOwner := AOwner;
  FAuthenticator := AAuthenticator;
  FRESTClient := TRESTClient.Create(FOwner);
  FRESTRequest := TRESTRequest.Create(FOwner);
  FRESTResponse := TRESTResponse.Create(FOwner);
  FRESTClient.BaseURL := ABaseAPIURL;
  FRESTClient.Authenticator := FAuthenticator;
  FRESTRequest.Client := FRESTClient;
  FRESTRequest.Response := FRESTResponse;
end;

destructor TMyBaseRESTObject.Destroy;
begin
  if Assigned(FRESTResponse) then
   FreeAndNil(FRESTResponse);
  if Assigned(FRESTRequest) then
   FreeAndNil(FRESTRequest);
  if Assigned(FRESTClient) then
   FreeAndNil(FRESTClient);
  inherited;
end;

procedure TMyBaseRESTObject.LoadJSONFromAPI(AAPIObject: string);
var
  JsonObject: TJSONObject;
begin
  FAPIObject := AAPIObject;
  FRESTRequest.Resource := FAPIObject;
  FRESTRequest.Method := rmGET;
  FRESTRequest.Execute;
  if FRESTResponse.StatusCode = 200 then
  begin    
    if Assigned(FJSONArray) then
      FJSONArray.Free;  
    FJSONArray := TJSONObject.ParseJSONValue(FRESTResponse.Content) as TJSONArray;
    if not Assigned(FJSONArray) then
    begin
      raise Exception.Create('Failed to parse JSON response. Content is not TJSONArray, but ' + 
                             TJSONObject.ParseJSONValue(FRESTResponse.Content).ClassName);
    end;
  end
  else
  begin
    JsonObject := TJSONObject.ParseJSONValue(FRESTResponse.Content) as TJSONObject;
    if Assigned(FJSONArray) then
      FJSONArray.Free;
    FJSONArray := TJSONArray.Create;
    FJSONArray.AddElement(JsonObject);

    raise Exception.Create('Failed to load JSON from API. APIObject:' + FAPIObject + ' StatusCode: ' + IntToStr(FRESTResponse.StatusCode) +
                           ' StatusText: ' + FRESTResponse.StatusText);
  end;
end;

{ TMyReportItemObject }

constructor TMyReportItemObject.Create(const Aid: Integer; Aname, Adescription, Acode_name, Afile_name: string);
begin
  Fid := Aid;
  Fname := Aname;
  Fdescription := Adescription;
  Fcode_name := Acode_name;
  Ffile_name := Afile_name;
end;

{ TMyReportArrayObject }

procedure TMyReportArrayObject.AddElement(const Aid: Integer; Aname,
  Adescription, Acode_name, Afile_name: string);
var
  NewReport: TMyReportItemObject;
begin
  NewReport := TMyReportItemObject.Create(Aid, Aname, Adescription, Acode_name, Afile_name);
  FReportList.Add(NewReport);
end;

procedure TMyReportArrayObject.Clear;
begin
  FReportList.Clear;
end;

constructor TMyReportArrayObject.Create(AOwner: TComponent;
  AAuthenticator: TOAuth2Authenticator; ABaseAPIURL: string);
begin
  inherited;
  FReportList := TObjectList<TMyReportItemObject>.Create;
end;

procedure TMyReportArrayObject.DeleteElement(const AIndex: Integer);
begin
  FReportList.Delete(AIndex);
end;

procedure TMyReportArrayObject.DeserializeJSON;
var
  i:Integer;
  JsonObject: TJSONObject;
begin
  if Assigned(FJSONArray) then
  begin
    if FJSONArray.Count > 0 then    
    for i := 0 to FJSONArray.Count - 1 do
    begin
      JsonObject := FJSONArray.Items[i] as TJSONObject;
      AddElement(StrToInt(JsonObject.GetValue('id').Value),
                 JsonObject.GetValue('name').Value,
                 JsonObject.GetValue('description').Value,
                 JsonObject.GetValue('code_name').Value,
                 JsonObject.GetValue('file_name').Value);
      if Assigned(JsonObject) then
        JsonObject.Free;
    end
    else
      raise Exception.Create('no data to serialize ');
  end
  else
    raise Exception.Create('no data to serialize ');
end;

destructor TMyReportArrayObject.Destroy;
begin
  if Assigned(FReportList) then
    FreeAndNil(FReportList);
  inherited;
end;

procedure TMyReportArrayObject.GET(AAPIObject: string);
begin
  LoadJSONFromAPI(AAPIObject);
  DeserializeJSON;
end;

function TMyReportArrayObject.GetCount: Integer;
begin
  Result := FReportList.Count;
end;

function TMyReportArrayObject.GetItem(AIndex: Integer): TMyReportItemObject;
begin
  Result := FReportList[AIndex]
end;

procedure TMyReportArrayObject.SetItem(Index: Integer;
  const Value: TMyReportItemObject);
begin
  if Assigned(FReportList[Index]) then
    FReportList[Index].Free;

  FReportList[Index] := Value;
end;

procedure TMyReportArrayObject.Show(AGrid: TcxGridTableView);
  var
  I: Integer;
  ColumnIndexes: TList<Integer>;
begin
  AGrid.BeginUpdate;
  try
  ColumnIndexes := TList<Integer>.Create;
  ColumnIndexes.Add(AGrid.FindItemByName('cxGridTableViewColumn_id').Index);
  ColumnIndexes.Add(AGrid.FindItemByName('cxGridTableViewColumn_name').Index);
  ColumnIndexes.Add(AGrid.FindItemByName('cxGridTableViewColumn_description').Index);
  ColumnIndexes.Add(AGrid.FindItemByName('cxGridTableViewColumn_code_name').Index);
  ColumnIndexes.Add(AGrid.FindItemByName('cxGridTableViewColumn_file_name').Index);
  AGrid.DataController.RecordCount := Count;
  for I := 0 to Count-1 do
    begin
      AGrid.DataController.SetValue(I,ColumnIndexes[0],FReportList[I].id);
      AGrid.DataController.SetValue(I,ColumnIndexes[1],FReportList[I].name);
      AGrid.DataController.SetValue(I,ColumnIndexes[2],FReportList[I].description);
      AGrid.DataController.SetValue(I,ColumnIndexes[3],FReportList[I].code_name);
      AGrid.DataController.SetValue(I,ColumnIndexes[4],FReportList[I].file_name);
    end;
  finally
    AGrid.EndUpdate;
  end;
end;

end.
