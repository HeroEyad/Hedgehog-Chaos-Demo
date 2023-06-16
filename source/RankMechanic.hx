package;
import flixel.FlxSprite;

class RankMechanic extends FlxSprite 
{
    private var rankNameString:String;
    private var rankArray:Array<Array<String>> = [
        ['S'   ,'S rank Bop'               ],
        ['A'   ,'A Rank'                   ],
        ['B'   ,'B Rank'                   ],
        ['F'   ,'SHITHEAD Rank'            ],
        ['Null','what fucking rank is this']
    ];

    public function new(x:Float,y:Float,?scl:Float = 0,?rankName:String = 'Null'){
        super(x,y);

        frames = Paths.getSparrowAtlas("resultsmenu/Cock_And_Ball_torture");
        for (i in 0...rankArray.length) animation.addByPrefix(rankArray[i][0], rankArray[i][1], 24);
        rankNameString = validRankName(rankName);
        changeRank(rankNameString);
        updateHitbox();

        setGraphicSize(Std.int(width * (0.3 - scl)));
        updateHitbox();

        // animation.addByPrefix('B',)
    }

    private function validRankName(rankName:String):String {
        for (i in 0...rankArray.length){

            

            if (rankName == rankArray[i][0] && rankArray[i][0] != 'Null') break;
            else 
                continue;

            rankName = 'Null';
        }

        

        rankNameString = rankName;
        return rankName;
    }

    public function changeRank(rankName:String) {
        var rankNamesFuck:String = validRankName(rankName);
        animation.play(rankNamesFuck);

        var positionOff:Array<Float> = [338,455-70];
        // switch(rankNamesFuck){
        //     case "S":
        //         positionOff[1] -= 60;
        //     case "A":
        //         positionOff[1] -= 70;
        // //     case "B":
        // //         positionOff = [0,0];
        //     case "Null":
        //         positionOff[1] -= 70;
        // }

        trace("offsetX: " + offset.x);
        trace("offsetY: " + offset.y);

        offset.set(positionOff[0],positionOff[1]);


        // updateHitbox();
    }

    public function getRankName():String {
        return rankNameString;
    }
}