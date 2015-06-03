Bestiary Addon: BGM v1.0 by Enelvon
=============================================================================

Summary
-----------------------------------------------------------------------------
  This addon does two things: allows the bestiary to play music and allows
enemies to have different battle themes. Battle themes are ranked by priority,
so if multiple enemies with unique battle themes are in a troop together the
music associated with the enemy with the highest priority will be played.

Compatibility Information
-----------------------------------------------------------------------------
**Required Scripts:**
  SES Core v2.2 or higher.
  SES Bestiary v1.0 or higher.

**Known Incompatibilities:**
  None.

Usage
-----------------------------------------------------------------------------
  This script uses a single Notes tag to accomplish its task.

### Enemy Note Tags:

`<BGM !Priority!: !Name!, !Volume!, !Pitch!)>`

  Place this in a Notes box to give an enemy a unique battle BGM.

**Replacements:**

`!Priority!` with the priority of the BGM. This only comes into play when more
than one enemy with a unique BGM is present in a troop - the BGM with the
highest priority will be played.

`!Name!` with the name of a BGM present in the Audio/BGM folder. It should not
include the extension.

`Volume` with the volume at which the BGM should be played - this can be any
integer in the range 0 to 100.

`Pitch` with the pitch at which the BGM should be played - this can be any
integer in the range 50 to 150.

Overwritten Methods
-----------------------------------------------------------------------------
* `module BattleManager`
    - `play_battle_bgm`

Aliased Methods
-----------------------------------------------------------------------------
* `class Bestiary`
    - `initialize`
    - `turn_page`

License
-----------------------------------------------------------------------------
  This script is made available under the terms of the MIT Expat license.
View [this page](http://sesvxace.wordpress.com/license/) for more detailed
information.

Installation
-----------------------------------------------------------------------------
  This script requires the SES Core (v2.2 or higher) and the SES Bestiary
(v1.0 or higher) in order to function.
These scripst can be found in the SES source repositories at the following
locations:

* [Core](https://github.com/sesvxace/core/blob/master/lib/core.rb)
* [Bestiary](https://github.com/sesvxace/bestiary/blob/master/lib/bestiary.rb)

Place this script below Materials, but above Main. Place this script below
the SES Core.
