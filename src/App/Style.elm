module App.Style exposing (..)

import Html.Attributes exposing (style)

notSelected =
    False

cardStyle selected index marginTop =
    let
        position =
            (240 * index) + 40

        shadowColor =
            if selected == False then
                "0 4px 8px 0 rgba(0,0,0,0.2)"
            else
                "0 4px 8px 0 rgba(0,127,0,0.9)"
    in
        [ ( "background-color", "white" )
        , ( "position", "absolute" )
        , ( "margin-top", marginTop )
        , ( "margin-left", (toString position) ++ "px" )
        , ( "box-shadow", shadowColor )
        , ( "transition", "0.3s" )
        , ( "width", "190px" )
        , ( "height", "280px" )
        , ( "border-radius", "5px" )
        , ( "padding-left", "15px" )
        , ( "padding-right", "5px" )
        , ( "padding-top", "2px" )
        , ( "font-family", "Helvetica , Times, serif" )
        ]


blackCardStyle index marginTop =
    let
        basicCardStyle =
            (cardStyle notSelected index marginTop)
    in
        basicCardStyle ++ [ ( "background-color", "black" ), ( "color", "white" ) ]


pointsStyle =
    style
        [ ( "padding-left", "520px" )
        , ( "padding-top", "20px" )
        , ( "font-size", "20px" )
        ]


errorStyle =
    style
        [ ( "padding-left", "40px" )
        , ( "padding-top", "600px" )
        , ( "font-size", "20px" )
        , ( "color", "red" )
        ]


containerStyle =
    style [ ( "padding", "2px 16px" ) ]


pageStyle =
    style [ ( "background-color", "#F5F5DC" )
          , ( "background-size", "cover") ]



