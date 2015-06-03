
Bestiary v1.2 by Enelvon
=============================================================================

Summary
-----------------------------------------------------------------------------
  This script is intended to provide an extremely customizable bestiary for
use in a variety of situations. Every aspect of the layout can be altered by
the developer, including the number of pages and types of information
displayed. Future updates are likely to contain new fields and bugfixes
rather than large overhauls of the system, unless the general public finds
the customization to be unreasonably difficult (something that I find
unlikely, as none of my non-scripter beta testers had difficulty with it). I
included almost all of the major features that I could think of in this first
release, so I would appreciate it if users would suggest ideas for
improvements and new features!

Compatibility Information
-----------------------------------------------------------------------------
**Required Scripts:**
  SES Core v2.2 or higher and Window_Book v3.0 or higher.

**Known Incompatibilities:**
  None, and as this is a new class (and thus contains no direct redefinitions
of the base scripts), it should never have any. It does contain a few new
methods for existing classes, but nothing that is likely to cause problems.
It does have a few aliases, but none that should cause any problems - or so I
think, though I could be absolutely wrong.

Aliased Methods
-----------------------------------------------------------------------------
* `class Game_Enemy`
    - `make_drop_items`
* `class Game_Party`
    - `initialize`

New Methods
-----------------------------------------------------------------------------
* `class RPG::Enemy`
    - `bestiary_show?`
    - `bestiary_parameter`

* `class Game_Enemy`
    - `defeated_count`
    - `use_item`
    - `item_apply`
    - `item_effect_add_state_attack`
    - `item_effect_add_state_normal`
    - `bestiary_parameter`

* `class Game_Party`
    - `reveal_bestiary_enemy`
    - `add_bestiary_enemy`
    - `add_bestiary_data`
    - `knows_bestiary_enemy?`
    - `knows_bestiary_data?`

* `class Game_Troop`
    - `on_battle_end`

Installation
-----------------------------------------------------------------------------
  Place this script below Materials and Window_Book, but above Main. Exact
placement shouldn't matter all that much beyond that.

Usage
-----------------------------------------------------------------------------
  This script has a large number of configuration options, all of which are
detailed in the `SES::Bestiary` module. They will not be described in this
section, as I despise redundancy. What this section *will* cover is the
series of note tags that this script adds to Enemies. It will also discuss
the series of script calls that can be used to add data to the bestiary (only
relevant if you set things to require discovery in the configuration). I will
begin by explaining the two ways to open the bestiary, though.

### Opening the Bestiary:
  There are two ways to open the bestiary: the first allows you to open it to
a specific page and allow the user to scroll through it from there, while the
second allows you to open a list of enemies and allow the user to select
enemies from there.

#### Option One: Opening the Bestiary as a Book
  This can be accomplished with a simple `show_book` call:

    show_book(Bestiary.new(ID, Turnable))

  Simply replace `ID` with the ID of the enemy whose page you would like to
begin on. `Turnable` should be `true` or `false`, depending on whether or not
you would like the pages to be turnable.

#### Option Two: Opening the Bestiary as a Scene
  This is accomplished in the same way that you would access any other scene:

    SceneManager.call(Scene_Bestiary)

### Enemy Note Tags:
This script now has a Demiurge plugin! You can find the link to it in the
thread, or in the GitHub archive. I highly recommend using that instead of
manually configuring Note tags.

`<Bestiary X Offset: !X!>`

  Place this in a Notes box to alter the draw X of the enemy's image in the
bestiary.

**Replacements:**

`!X!` with the number of pixels by which to move the enemy's image. Positive
values will move it towards the right while negative values will move it
towards the left.

`<Bestiary Y Offset: !Y!>`

  Place this in a Notes box to alter the draw Y of the enemy's image in the
bestiary.

**Replacements:**

`!Y!` with the number of pixels by which to move the enemy's image. Positive
values will move it towards the bottom while negative values will move it
towards the top.

`<Bestiary Hide !Type!>`

Place this in a Notes box to prevent part of an enemy's data from being
displayed. This is useful for bosses.

**Replacements:**

`!Type!` with the type of data you would like to hide. This can be Skills,
Elements, States, or Enemy. The first three hide their respective areas, while
the last prevents the enemy from appearing in the bestiary at all and serves
as an alternative to the HiddenEnemies array.

`<Bestiary Hide Skill: !ID!>`

Place this in a Notes box to prevent a given skill from appearing in the list
of an enemy's skills.

**Replacements:**

`!ID!` with the ID of the skill you would like to hide. This tag can hold
more than one ID, formatted like this: `<Bestiary Hide Skill: 1, 2>`

It can contain an unlimited number of IDs - just don't press Enter until
you've closed the tag. The automatic wrapping in the Notes box doesn't
actually introduce a new line.

`<Bestiary Parameter !Name!: !Value!>`

  Place this in a Notes box to change the value of a given method or variable
for the purposes of display in the bestiary (and only the purposes of display
in the bestiary - this affects nothing else). This can also be used to create
'fake' variables that are only used in custom bestiary fields - they can be
accessed via the name you give them within bestiary configuration.

**Replacements:**

`!Name!` with the name of the variable or method whose content you are
altering or creating.

`!Value!` with the value it should hold. This can be anything, as it will be
treated as a String (display only and all that).

`<Bestiary Hide All (Stats|Parameters|Params)>`

  Place this in a Notes box to have all of an enemy's basic stats (HP, MP,
ATK, and so on) drawn as ???. A convenience method for bosses and other
special enemies.

**Replacements:**

None - just choose one of the three names in the parentheses of the tag. Only
use one - multiple possibilities are included due to variance in the
preferences of developers.

```
<Bestiary Description>
  ...TEXT...
  ...TEXT...
</Bestiary Description>
```

  Place this in a Notes box to determine what will be drawn for an enemy's
description. Everything between the opening and closing tags will be
considered part of the description. Text will be automatically wrapped to
fit, and any line breaks manually inserted with Enter will drop to a new line
regardless of position when the description is drawn.

**Replacements:**

None - just make sure to include a description. If this tag is absent from an
enemy, an empty description will be drawn.

Script Calls
-----------------------------------------------------------------------------
  These can be used in events or within your own scripts, as they are all
calls to `$game_party`.

    $game_party.reveal_bestiary_enemy(ID)

  Replace `ID` with the ID of the enemy that you would like to reveal. This
call causes **all** of the enemy's data to be marked as known.

    $game_party.add_bestiary_enemy(ID, Defeated)

  Replace `ID` with the ID of the enemy that you would like to add and
`Defeated` with either `true` (the counter for the number of defeated enemies
should be incremented) or `false` (it should not). This will only make the
page visible -- it will not mark any individual pieces of data as known.

    $game_party.add_bestiary_data(ID, Type, Data)

  This is the most complicated of the calls. Replace `ID` with the ID of the
enemy whose data you are updating. `Type` should be `:dro` for Drops, `:ele`
for Elements, `:sta` for States, or `:ski` for Skills. Data varies depending
on the Type. For `:ele`, `:sta`, and `:ski`, it should be the ID of an
Element, State, or Skill. For `:dro`, it should be a string in the format
`"Kind-ID"`. Kind should be 1 (for Items), 2 (for Weapons), or 3 (for
Armors). ID is the Database ID of the item in question.

License
-----------------------------------------------------------------------------
  This script is made available under the terms of the MIT Expat license.
View [this page](http://sesvxace.wordpress.com/license/) for more detailed
information.
