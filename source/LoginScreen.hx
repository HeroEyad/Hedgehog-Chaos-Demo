package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.addons.ui.FlxInputText;
import flixel.ui.FlxButton;
import flixel.addons.api.FlxGameJolt;

class LoginScreen extends MusicBeatState {
    private var usernameInput:FlxInputText;
    private var tokenInput:FlxInputText;
    private var statusText:FlxText;
    private var logoutButton:FlxButton;

    override public function create():Void {
        
        FlxG.mouse.visible = true;

        var usernameLabel = new FlxText(10, 100, 0, "Username:");
        usernameLabel.screenCenter(X);
        add(usernameLabel);
        
        usernameInput = new FlxInputText(10, 130, 200, "");
        add(usernameInput);

        var tokenLabel = new FlxText(10, 200, 0, "Token:");
        add(tokenLabel);

        tokenInput = new FlxInputText(10, 250, 200, "");
        add(tokenInput);
        
        var loginButton = new FlxButton(10, 300, "Login", onLoginClicked);
        add(loginButton);

        logoutButton = new FlxButton(10, 350, "Logout", onLogoutClicked);
        logoutButton.visible = false;
        add(logoutButton);

        statusText = new FlxText(10, 170, 0, "");
        add(statusText);

        FlxGameJolt.init(913463, 'be19cd1cd9c5c164b9b2aa8f973f0701');

        super.create();
    }

    private function onLoginClicked():Void {
        var username = usernameInput.text;
        var token = tokenInput.text;
        
        FlxGameJolt.authUser(username, token, function(success:Bool) {
            if (success) {
                statusText.text = "Login successful!";
                logoutButton.visible = true;
            } else {
                statusText.text = "Login failed!";
                return;
            }
        });
    }

    private function onLogoutClicked():Void {
        statusText.text = "Logged out!";
        logoutButton.visible = false;
    }
}
