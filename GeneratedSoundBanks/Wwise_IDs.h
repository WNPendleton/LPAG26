/////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Audiokinetic Wwise generated include file. Do not edit.
//
/////////////////////////////////////////////////////////////////////////////////////////////////////

#ifndef __WWISE_IDS_H__
#define __WWISE_IDS_H__

#include <AK/SoundEngine/Common/AkTypes.h>

namespace AK
{
    namespace EVENTS
    {
        static const AkUniqueID PLAY_AMBIENCE = 278617630U;
        static const AkUniqueID PLAY_CONTRAPTION_LOOP = 245867814U;
        static const AkUniqueID PLAY_MOB_FOOTFALL = 1603081396U;
        static const AkUniqueID PLAY_MOB_IMPACT_HURT = 132558531U;
        static const AkUniqueID PLAY_MOB_IMPACT_LAND = 2698782831U;
        static const AkUniqueID PLAY_MOB_VOCAL_ATTACK = 786648969U;
        static const AkUniqueID PLAY_MOB_VOCAL_HURT = 2786240606U;
        static const AkUniqueID PLAY_MOB_VOCAL_IDLE = 1024902515U;
        static const AkUniqueID PLAY_MOB_VOCAL_JUMP = 2981602165U;
        static const AkUniqueID PLAY_MOB_VOCAL_KILL = 1709172129U;
        static const AkUniqueID PLAY_MOB_VOCAL_LAND = 1010697978U;
        static const AkUniqueID PLAY_OBJECT_BREAK = 1726731735U;
        static const AkUniqueID PLAY_OBJECT_IMPACT = 2959945292U;
        static const AkUniqueID PLAY_OBJECT_PICKUP = 2818358958U;
        static const AkUniqueID PLAY_PLAYER_DASH = 2175711460U;
        static const AkUniqueID PLAY_PLAYER_DOUBLE_JUMP = 2440480106U;
        static const AkUniqueID PLAY_PLAYER_FOOTFALL = 1561578791U;
        static const AkUniqueID PLAY_PLAYER_IMPACT_HURT = 3871964538U;
        static const AkUniqueID PLAY_PLAYER_IMPACT_LAND = 500414542U;
        static const AkUniqueID PLAY_PLAYER_ITEM_COLLECT = 2814351110U;
        static const AkUniqueID PLAY_PLAYER_JUMP = 562256996U;
        static const AkUniqueID PLAY_PLAYER_LAND = 4249207015U;
        static const AkUniqueID PLAY_PLAYER_OBJECT_PICKUP = 2926254236U;
        static const AkUniqueID PLAY_PLAYER_OBJECT_THROW = 2707209376U;
        static const AkUniqueID PLAY_PLAYER_SMASH_MOB = 2242430491U;
        static const AkUniqueID PLAY_PLAYER_VOCAL_HURT = 3205593845U;
        static const AkUniqueID PLAY_PLAYER_VOCAL_JUMP = 3539357910U;
        static const AkUniqueID PLAY_PLAYER_VOCAL_LAND = 1607231777U;
        static const AkUniqueID PLAY_TESTSOUND = 2752533807U;
        static const AkUniqueID PLAY_TEXT_SCROLL = 1513931445U;
        static const AkUniqueID PLAY_WIN_CONDITION_ACHIEVE = 1295372146U;
        static const AkUniqueID STOP_CONTRAPTION_LOOP = 2728690880U;
        static const AkUniqueID STOP_TEXT_SCROLL = 962785531U;
    } // namespace EVENTS

    namespace STATES
    {
        namespace AMBIENCE
        {
            static const AkUniqueID GROUP = 85412153U;

            namespace STATE
            {
                static const AkUniqueID CAVE = 4122393694U;
                static const AkUniqueID CAVERN = 3631438710U;
                static const AkUniqueID DUNGEON = 608898761U;
                static const AkUniqueID INSIDE = 3553349781U;
                static const AkUniqueID NONE = 748895195U;
                static const AkUniqueID OUTDOOR_NIGHT = 3735097304U;
                static const AkUniqueID OUTDOOR_SUNNY = 4207937715U;
                static const AkUniqueID UNDER_WATER = 447521081U;
            } // namespace STATE
        } // namespace AMBIENCE

        namespace UNDER_WATER_OR_NOT_UNDERWATER
        {
            static const AkUniqueID GROUP = 90601107U;

            namespace STATE
            {
                static const AkUniqueID NONE = 748895195U;
                static const AkUniqueID NOT_UNDER_WATER = 4191120611U;
                static const AkUniqueID UNDER_WATER = 447521081U;
            } // namespace STATE
        } // namespace UNDER_WATER_OR_NOT_UNDERWATER

    } // namespace STATES

    namespace SWITCHES
    {
        namespace MATERIAL_ENVIRONMENT
        {
            static const AkUniqueID GROUP = 2851469388U;

            namespace SWITCH
            {
                static const AkUniqueID GLASS = 2449969375U;
                static const AkUniqueID METAL = 2473969246U;
                static const AkUniqueID SOFT = 670602561U;
                static const AkUniqueID STONE = 1216965916U;
                static const AkUniqueID WET = 1181096339U;
                static const AkUniqueID WOOD = 2058049674U;
            } // namespace SWITCH
        } // namespace MATERIAL_ENVIRONMENT

        namespace MATERIAL_FLOOR
        {
            static const AkUniqueID GROUP = 2007472349U;

            namespace SWITCH
            {
                static const AkUniqueID GLASS = 2449969375U;
                static const AkUniqueID GRASS = 4248645337U;
                static const AkUniqueID METAL = 2473969246U;
                static const AkUniqueID SOFT = 670602561U;
                static const AkUniqueID STONE = 1216965916U;
                static const AkUniqueID WATER_SHALLOW_FAST = 2898033376U;
                static const AkUniqueID WATER_SHALLOW_SLOW = 2062765865U;
                static const AkUniqueID WOOD = 2058049674U;
            } // namespace SWITCH
        } // namespace MATERIAL_FLOOR

        namespace MATERIAL_OBJECT
        {
            static const AkUniqueID GROUP = 2110646320U;

            namespace SWITCH
            {
                static const AkUniqueID GLASS = 2449969375U;
                static const AkUniqueID METAL = 2473969246U;
                static const AkUniqueID SOFT = 670602561U;
                static const AkUniqueID STONE = 1216965916U;
                static const AkUniqueID WET = 1181096339U;
                static const AkUniqueID WOOD = 2058049674U;
            } // namespace SWITCH
        } // namespace MATERIAL_OBJECT

        namespace MATERIAL_OBJECT_BREAK
        {
            static const AkUniqueID GROUP = 1260988400U;

            namespace SWITCH
            {
                static const AkUniqueID GLASS = 2449969375U;
                static const AkUniqueID METAL = 2473969246U;
                static const AkUniqueID SOFT = 670602561U;
                static const AkUniqueID STONE = 1216965916U;
                static const AkUniqueID WET = 1181096339U;
                static const AkUniqueID WOOD = 2058049674U;
            } // namespace SWITCH
        } // namespace MATERIAL_OBJECT_BREAK

    } // namespace SWITCHES

    namespace GAME_PARAMETERS
    {
        static const AkUniqueID DIALOGUE_SPEED = 4238820691U;
        static const AkUniqueID MOB_VELOCITY = 127967901U;
        static const AkUniqueID OBJECT_MASS = 292743055U;
        static const AkUniqueID OBJECT_VELOCITY = 790395066U;
        static const AkUniqueID PLAYER_HORIZONTAL_VELOCITY = 1095763933U;
        static const AkUniqueID PLAYER_VERTICAL_VELOCITY = 1686300671U;
        static const AkUniqueID SS_AIR_FEAR = 1351367891U;
        static const AkUniqueID SS_AIR_FREEFALL = 3002758120U;
        static const AkUniqueID SS_AIR_FURY = 1029930033U;
        static const AkUniqueID SS_AIR_MONTH = 2648548617U;
        static const AkUniqueID SS_AIR_PRESENCE = 3847924954U;
        static const AkUniqueID SS_AIR_RPM = 822163944U;
        static const AkUniqueID SS_AIR_SIZE = 3074696722U;
        static const AkUniqueID SS_AIR_STORM = 3715662592U;
        static const AkUniqueID SS_AIR_TIMEOFDAY = 3203397129U;
        static const AkUniqueID SS_AIR_TURBULENCE = 4160247818U;
    } // namespace GAME_PARAMETERS

    namespace BUSSES
    {
        static const AkUniqueID DIALOGUE = 3930136735U;
        static const AkUniqueID MAIN_AUDIO_BUS = 2246998526U;
        static const AkUniqueID MUSIC = 3991942870U;
        static const AkUniqueID SFX = 393239870U;
    } // namespace BUSSES

    namespace AUX_BUSSES
    {
        static const AkUniqueID REVERB_CAVE = 323187407U;
        static const AkUniqueID REVERB_CHAMBER = 4120357254U;
        static const AkUniqueID REVERB_OPEN_AIR = 2286153165U;
        static const AkUniqueID REVERB_ROOM = 3258416929U;
    } // namespace AUX_BUSSES

    namespace AUDIO_DEVICES
    {
        static const AkUniqueID NO_OUTPUT = 2317455096U;
        static const AkUniqueID SYSTEM = 3859886410U;
    } // namespace AUDIO_DEVICES

}// namespace AK

#endif // __WWISE_IDS_H__
