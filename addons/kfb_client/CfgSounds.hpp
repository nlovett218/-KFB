class CfgSounds
{
    sounds[] = {"LoadingScreenMusic", "SM_incomingMissile_warning"};

    /*#include "sound\sound_farty\sound.hpp"
    #include "sound\sound_screamer\sound.hpp"
    #include "sound\sound_sparky\sound.hpp"
    #include "sound\sound_strigoi\sound.hpp"
    #include "sound\sound_flamer\sound.hpp"*/

    class LoadingScreenMusic
    {
        name = "LoadingScreenMusic";
        sound[] = {"\kfb_assets\sound\aggressor.ogg", db-8, 1.0};
        titles[] = {};
    };

    class SM_incomingMissile_warning
    {
        name = "SM_incomingMissile_warning";
        sound[] = {"\kfb_assets\sound\IncomingMissile\warning.ogg", 1, 1};
        titles[] = {};
    };
};