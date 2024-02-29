object Form_Main: TForm_Main
  Left = 0
  Top = 0
  Caption = 'Form_Main'
  ClientHeight = 564
  ClientWidth = 662
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object cxMemo_log: TcxMemo
    Left = 0
    Top = 418
    Align = alBottom
    Properties.ReadOnly = True
    Properties.ScrollBars = ssVertical
    TabOrder = 0
    Height = 146
    Width = 662
  end
  object cxGroupBox_Auth: TcxGroupBox
    Left = 0
    Top = 0
    Align = alTop
    Caption = 'Connection settings '
    TabOrder = 1
    Height = 81
    Width = 662
    object cxButton_OAuth2Connect: TcxButton
      Left = 372
      Top = 40
      Width = 104
      Height = 27
      Caption = 'Authorization'
      TabOrder = 0
      OnClick = cxButton_OAuth2ConnectClick
    end
    object cxTextEdit_Login: TcxTextEdit
      Left = 45
      Top = 44
      TabOrder = 1
      Text = 'leon'
      Width = 121
    end
    object cxTextEdit_Password: TcxTextEdit
      Left = 239
      Top = 44
      TabOrder = 2
      Text = '12345'
      Width = 121
    end
    object cxLabel_Login: TcxLabel
      Left = 3
      Top = 45
      Caption = 'Login'
    end
    object cxLabel_Password: TcxLabel
      Left = 183
      Top = 44
      Caption = 'Password'
    end
    object cxButton_getTestData: TcxButton
      Left = 285
      Top = 13
      Width = 75
      Height = 25
      Caption = 'Get TestData'
      TabOrder = 5
      OnClick = cxButton_getTestDataClick
    end
    object cxTextEdit_serverURL: TcxTextEdit
      Left = 45
      Top = 17
      TabOrder = 6
      Text = 'http://192.168.56.1:8000/'
      Width = 229
    end
    object cxLabel_serverURL: TcxLabel
      Left = 3
      Top = 18
      Caption = 'Server'
    end
    object cxButton_getReports: TcxButton
      Left = 372
      Top = 13
      Width = 104
      Height = 25
      Caption = 'getReports'
      TabOrder = 8
      OnClick = cxButton_getReportsClick
    end
  end
  object cxGroupBox_Data: TcxGroupBox
    Left = 0
    Top = 81
    Align = alClient
    Caption = 'Data'
    TabOrder = 2
    Height = 337
    Width = 662
    object dxNavBar: TdxNavBar
      Left = 3
      Top = 15
      Width = 150
      Height = 315
      Align = alLeft
      ActiveGroupIndex = 0
      TabOrder = 0
      ViewReal = 15
      ExplicitLeft = 0
      ExplicitTop = 14
      ExplicitHeight = 317
      object dxNavBarGroup_References: TdxNavBarGroup
        Caption = 'References'
        SelectedLinkIndex = -1
        TopVisibleLinkIndex = 0
        Links = <
          item
            Item = dxNavBar_refReports
          end>
      end
      object dxNavBar_refReports: TdxNavBarItem
        Caption = 'Reports'
        OnClick = dxNavBar_refReportsClick
      end
    end
    object cxSplitter1: TcxSplitter
      Left = 153
      Top = 15
      Width = 8
      Height = 315
      ExplicitLeft = 240
      ExplicitTop = 140
      ExplicitHeight = 100
    end
    object cxGrid: TcxGrid
      Left = 161
      Top = 15
      Width = 498
      Height = 315
      Align = alClient
      TabOrder = 2
      ExplicitLeft = 305
      ExplicitTop = 70
      ExplicitWidth = 250
      ExplicitHeight = 200
      object cxGridTableView: TcxGridTableView
        Navigator.Buttons.CustomButtons = <>
        ScrollbarAnnotations.CustomAnnotations = <>
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsCustomize.ColumnGrouping = False
        OptionsData.Deleting = False
        OptionsData.Editing = False
        OptionsData.Inserting = False
        OptionsView.GroupByBox = False
        object cxGridTableViewColumn_id: TcxGridColumn
          Caption = 'ID'
          DataBinding.ValueType = 'Integer'
        end
        object cxGridTableViewColumn_name: TcxGridColumn
          Caption = 'Name'
          Width = 135
        end
        object cxGridTableViewColumn_description: TcxGridColumn
          Caption = 'Description'
          Width = 195
        end
        object cxGridTableViewColumn_code_name: TcxGridColumn
          Caption = 'CodeName'
          Width = 118
        end
        object cxGridTableViewColumn_file_name: TcxGridColumn
          Caption = 'FileName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Width = 111
        end
      end
      object cxGridLevel: TcxGridLevel
        GridView = cxGridTableView
      end
    end
  end
  object OAuth2Authenticator1: TOAuth2Authenticator
    ResponseType = rtTOKEN
    TokenType = ttBEARER
    Left = 620
    Top = 25
  end
  object cxLookAndFeelController1: TcxLookAndFeelController
    NativeStyle = False
    SkinName = 'Office2010Silver'
    Left = 620
    Top = 101
  end
end
