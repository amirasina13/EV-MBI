/* ---------------------------------------------------------- APP FONT FAMILY */

const appName = 'EV@MBI';
const String fontFamilyMain = 'Segoe';
const double marginHorizontal = 15;
const double scaleFactor = 1.0;
const double sidePadding = 10;

const String appDateFormat = 'dd MMM yyyy';
const String appTimeFormat = 'hh:mm';
// minimum age
const int minAgeDOB = 18;

const String apiUrl = 'https://prod.evchargersystem.com';
const String apiVersionDefault = '/api/v1';
const String apiUsername = 'eaba46692c32657b4e8acd1c995b86c317781965';
const String apiPassword = 'f3af3db6e92aafd94eb9ec0e4409894af8c57099';

/* Location Dialog */
const String androidLocText =
    r'EV@MBI! requires location access to '
    r' suggest the nearest EV charging stations based on '
    r'user current location. ';
const String iosLocText =
    r'EV@MBI! requires location access to '
    r' suggest the nearest EV charging stations based on '
    r'user current location. You can change this option later in the Settings app.';

const mapBoxToken =
    "pk.eyJ1IjoidnNkYXV0b21hdGlvbiIsImEiOiJjbW1vbmp2MjkwYWN4MnJvZ3N5MXV2d29mIn0.DjKByqKCr88VN7m-wcmw3Q";

const imageSelected1 = 'assets/icon/home.svg';
const imageSelected2 = 'assets/icon/map_bottom.svg';
const imageSelected3 = '';
const imageSelected4 = 'assets/icon/history.svg';
const imageSelected5 = 'assets/icon/profile.svg';

const imageUnselected1 = 'assets/icon/home.svg';
const imageUnselected2 = 'assets/icon/map_bottom.svg';
const imageUnselected3 = '';
const imageUnselected4 = 'assets/icon/history.svg';
const imageUnselected5 = 'assets/icon/profile.svg';

// NAME
const title1 = 'home-nav';
const title2 = 'map-nav';
const title3 = '';
const title4 = 'session-nav';
const title5 = 'profile-nav';

// ------------------------------------------------------------------ SOCIAL URL

final urlTerm = '$apiUrl/terms_of_use';
final urlPolicy = '$apiUrl/privacy_policy';
final urlWalkthrough = '$apiUrl/walkthrough';
final urlChargingGuide = '$apiUrl/charging_guide';
