mix = app.helpers.util.mix

theme = 
  textColor: '#000000'
  barColor: '#66320e'
  backgroundColor: '#EAEAB2'
  darkBlue: '#93caed'
  fontFamily: 'Helvetica Neue'

properties = 
  platformWidth: Ti.Platform.displayCaps.platformWidth
  platformHeight: Ti.Platform.displayCaps.platformHeight  
  
  Window: 
    barColor: theme.barColor
    backgroundColor: theme.backgroundColor
    tabBarHidden: true
    orientationModes: [
      Ti.UI.PORTRAIT
      Ti.UI.LANDSCAPE_LEFT
      Ti.UI.LANDSCAPE_RIGHT      
    ]
  
  Button: 
    height: 50
    width: 250
    color: '#000'
    font: 
      fontSize: 18
      fontWeight: 'bold'    
  
  Label: 
    color: theme.textColor
    font: 
      fontFamily: theme.fontFamily
      fontSize: 18  
    height: 'auto'
  
  TableView: 
    backgroundColor: theme.backgroundColor
    editable: true
  
#    なぜか色が反映されない。
  SearchBar: 
    barColor: theme.barColor
    backgroundColor: theme.barColor
    
  TableViewRow: 
    selectedBackgroundColor: theme.darkBlue
    backgroundSelectedColor: theme.darkBlue
    hasChild: true
    className: 'tvRow'
  
  GroupedTableView: 
    style: Ti.UI.iPhone.TableViewStyle.GROUPED
    rowHeight:40
  
  GroupedTableViewRow: 
    selectionStyle: Ti.UI.iPhone.TableViewCellSelectionStyle.NONE
  
  ScrollView: 
    height: 431
    width: 320
    contentHeight: 'auto'
    contentWidth: 320
  
  TextField: 
    height: 55
    borderStyle: Ti.UI.INPUT_BORDERSTYLE_ROUNDED
    color: '#000000'
  
  TextArea: 
    top: 0
    # height:387
    # width:320
    font:{fontSize:16}
    textAlign:'left'
    backgroundColor: theme.backgroundColor
    appearance:Ti.UI.KEYBOARD_APPEARANCE_DEFAULT       
    keyboardType:Ti.UI.KEYBOARD_DEFAULT
    returnKeyType:Ti.UI.RETURNKEY_DEFAULT
    suppressReturn: false

views =
  root: 
    window: 
      properties.Window
    tableView: 
      properties.TableView
    searchBar: 
      properties.SearchBar
    tableViewRow: 
      properties.TableViewRow
    addBtn: 
      systemButton: Ti.UI.iPhone.SystemButton.ADD
    titleLabel: mix(properties.Label,
      left: 5
      top: 12
      width: 200
      color: '#8b4513'
      height: 20)
    dateLabel: mix( properties.Label,
      right: 20
      top: 15
      width: 60
      height: 20
      textAlign: 'right'
      font: 
        fontFamily: theme.fontFamily
        fontSize: 14  
      color: '#669'
      )
      

  edit: 
    window: mix(properties.Window,
      backButtonTitle: 'Memo'
      )
    fs:
      systemButton: Titanium.UI.iPhone.SystemButton.FLEXIBLE_SPACE
    addBtn: 
      systemButton: Ti.UI.iPhone.SystemButton.ADD
    doneBtn: 
      systemButton: Ti.UI.iPhone.SystemButton.DONE
    trashBtn: 
      systemButton: Ti.UI.iPhone.SystemButton.TRASH
    prevBtn: 
      title: String.fromCharCode(0x25c0)
    nextBtn: 
      title: String.fromCharCode(0x25b6)
    mailBtn: 
      image:'image/light_mail.png'
    textArea: 
      properties.TextArea
    optionDialog: 
      title: 'Delete this memo?'
      options: ['OK', 'Cancel']
      destructive: 0
      cancel: 1
      
exports = 
  views: views