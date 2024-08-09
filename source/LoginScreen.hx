package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.addons.ui.FlxInputText;
import flixel.ui.FlxButton;
import flixel.addons.api.FlxGameJolt;
import flixel.FlxSprite;

class LoginScreen extends MusicBeatState {
    private var usernameInput:FlxInputText;
    private var tokenInput:FlxInputText;
    private var statusText:FlxText;
    private var logoutButton:FlxButton;
    private var loginButton:FlxButton;
    private var tokenButton:FlxButton;
    private var usernameLabel:FlxText;
    private var tokenLabel:FlxText;
    private var welcomeText:FlxText;

    
    public static var currentUsername:String;
    public static var currentToken:String;
    public static var loggedIn:Bool = false;

    override public function create():Void {
        FlxG.mouse.visible = true;

        var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
        bg.setGraphicSize(Std.int(bg.width * 1.175));
        bg.updateHitbox();
        bg.screenCenter();
        bg.antialiasing = ClientPrefs.globalAntialiasing;
        add(bg);

        welcomeText = new FlxText(0, 50, FlxG.width, "Welcome!");
        welcomeText.setFormat(Paths.font('sonic2.ttf'), 24, FlxColor.WHITE, "center");
        add(welcomeText);

        usernameLabel = new FlxText(0, 200, FlxG.width, "Username:");
        usernameLabel.setFormat(Paths.font('sonic2.ttf'), 16, FlxColor.WHITE, "center");
        add(usernameLabel);

        usernameInput = new FlxInputText(0, 230, 400, "");
        usernameInput.screenCenter(X);
        usernameInput.setFormat(Paths.font('sonic2.ttf'), 16, FlxColor.BLACK, "center");
        add(usernameInput);

        tokenLabel = new FlxText(0, 300, FlxG.width, "Game Token:");
        tokenLabel.setFormat(Paths.font('sonic2.ttf'), 16, FlxColor.WHITE, "center");
        add(tokenLabel);

        tokenInput = new FlxInputText(0, 330, 400, "");
        tokenInput.screenCenter(X);
        tokenInput.setFormat(Paths.font('sonic2.ttf'), 16, FlxColor.BLACK, "center");
        add(tokenInput);

        loginButton = new FlxButton(0, 400, "Login", onLoginClicked);
        loginButton.screenCenter(X);
        loginButton.scale.set(1.5, 1.5);
        add(loginButton);

        tokenButton = new FlxButton(0, 400, "How to Get Token", onToken);
        tokenButton.screenCenter(X);
        tokenButton.x += 100;
        tokenButton.scale.set(1.5, 1.5);
        add(tokenButton);

        logoutButton = new FlxButton(0, 470, "Logout", onLogoutClicked);
        logoutButton.screenCenter(X);
        logoutButton.scale.set(1.5, 1.5);
        logoutButton.visible = false;
        add(logoutButton);

        statusText = new FlxText(0, 530, FlxG.width, "");
        statusText.setFormat(Paths.font('sonic2.ttf'), 16, FlxColor.WHITE, "center");
        add(statusText);

        FlxGameJolt.init(913463, 'be19cd1cd9c5c164b9b2aa8f973f0701');

        super.create();
    }

    private function onToken():Void {
        CoolUtil.browserLoad('https://www.youtube.com/watch?v=T5-x7kAGGnE');
    }

    private function onLoginClicked():Void {
        var username = usernameInput.text;
        var token = tokenInput.text;

        FlxGameJolt.authUser(username, token, function(success:Bool) {
            if (success) {
                currentUsername = username;
                currentToken = token;
                usernameInput.visible = false;
                tokenInput.visible = false;
                statusText.text = "Login successful!";
                logoutButton.visible = true;
                loginButton.visible = false;
                tokenButton.visible = false;
                loggedIn = true;

            } else {
                statusText.text = "Login failed! (Check your token or your Internet Connection)";
                return;
            }
        });
    }

    private function onLogoutClicked():Void {
        statusText.text = "Logged out!";
        logoutButton.visible = false;
        loginButton.visible = true;
        tokenButton.visible = true;
        usernameInput.visible = true;
        tokenInput.visible = true;
        currentUsername = null;
        currentToken = null;
        loggedIn = false;
    }

    override function update(elapsed:Float):Void {
        if (FlxG.keys.justPressed.ESCAPE) {
            MusicBeatState.switchState(new MainMenuState());
        }
        super.update(elapsed);
    }
}
