# AtlasTextureCreator
AtlasTextureCreator:used for auto-generate Godot AtlasTexture from Aseprite exported png( with json file ).

HOW TO USE:

1.addon appears on dock when enable.
2.select the png file and json file
3.select the directory you want to store the created AtlasTextures
4.press begin

ATTENTION:

1.your aseprite file should use different layer to draw bodypart (such as "head","body","left_hand"……)

2.when export from aseprite, item filename should be "{layer}" (export sprite sheet -> output tab -> JSON DATA ->item filename )

3.should use only 1 frame.  animation part is in Godot engine,it intended to dealing with static resource here
