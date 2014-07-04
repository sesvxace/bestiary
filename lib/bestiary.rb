#--
# Bestiary v1.0 by Enelvon
# =============================================================================
# 
# Summary
# -----------------------------------------------------------------------------
#   This script is intended to provide an extremely customizable bestiary for
# use in a variety of situations. Every aspect of the layout can be altered by
# the developer, including the number of pages and types of information
# displayed. Future updates are likely to contain new fields and bugfixes
# rather than large overhauls of the system, unless the general public finds
# the customization to be unreasonably difficult (something that I find
# unlikely, as none of my non-scripter beta testers had difficulty with it). I
# included almost all of the major features that I could think of in this first
# release, so I would appreciate it if users would suggest ideas for
# improvements and new features!
# 
# Compatibility Information
# -----------------------------------------------------------------------------
# **Required Scripts:**
#   SES Core v2.2 or higher and SES Window Book v3.0 or higher.
# 
# **Known Incompatibilities:**
#   None, and as this is a new class (and thus contains no direct redefinitions
# of the base scripts), it should never have any. It does contain a few new
# methods for existing classes, but nothing that is likely to cause problems.
# It does have a few aliases, but none that should cause any problems - or so I
# think, though I could be absolutely wrong.
# 
# Usage
# -----------------------------------------------------------------------------
#   This script has a large number of configuration options, all of which are
# detailed in the `SES::Bestiary` module. They will not be described in this
# section, as I despise redundancy. What this section *will* cover is the
# series of note tags that this script adds to Enemies. It will also discuss
# the series of script calls that can be used to add data to the bestiary (only
# relevant if you set things to require discovery in the configuration). I will
# begin by explaining the two ways to open the bestiary, though.
# 
# ### Opening the Bestiary:
#   There are two ways to open the bestiary: the first allows you to open it to
# a specific page and allow the user to scroll through it from there, while the
# second allows you to open a list of enemies and allow the user to select
# enemies from there.
# 
# #### Option One: Opening the Bestiary as a Book
#   This can be accomplished with a simple `show_book` call:
# 
#     show_book(Bestiary.new(ID, Turnable))
# 
#   Simply replace `ID` with the ID of the enemy whose page you would like to
# begin on. `Turnable` should be `true` or `false`, depending on whether or not
# you would like the pages to be turnable.
# 
# #### Option Two: Opening the Bestiary as a Scene
#   This is accomplished in the same way that you would access any other scene:
# 
#     SceneManager.call(Scene_Bestiary)
# 
# ### Enemy Note Tags:
# 
# `<Bestiary X Offset: !X!>`
# 
#   Place this in a Notes box to alter the draw X of the enemy's image in the
# bestiary.
# 
# **Replacements:**
# 
# `!X!` with the number of pixels by which to move the enemy's image. Positive
# values will move it towards the right while negative values will move it
# towards the left.
# 
# `<Bestiary Y Offset: !Y!>`
# 
#   Place this in a Notes box to alter the draw Y of the enemy's image in the
# bestiary.
# 
# **Replacements:**
# 
# `!Y!` with the number of pixels by which to move the enemy's image. Positive
# values will move it towards the bottom while negative values will move it
# towards the top.
# 
# `<Bestiary Hide !Type!>`
# 
# Place this in a Notes box to prevent part of an enemy's data from being
# displayed. This is useful for bosses.
# 
# **Replacements:**
# 
# `!Type!` with the type of data you would like to hide. This can be Skills,
# Elements, or States.
# 
# `<Bestiary Hide Skill: !ID!>`
# 
# Place this in a Notes box to prevent a given skill from appearing in the list
# of an enemy's skills.
# 
# **Replacements:**
# 
# `!ID!` with the ID of the skill you would like to hide. This tag can hold
# more than one ID, formatted like this: `<Bestiary Hide Skill: 1, 2>`
# 
# It can contain an unlimited number of IDs - just don't press Enter until
# you've closed the tag. The automatic wrapping in the Notes box doesn't
# actually introduce a new line.
# 
# `<Bestiary Parameter !Name!: !Value!>`
# 
#   Place this in a Notes box to change the value of a given method or variable
# for the purposes of display in the bestiary (and only the purposes of display
# in the bestiary - this affects nothing else). This can also be used to create
# 'fake' variables that are only used in custom bestiary fields - they can be
# accessed via the name you give them within bestiary configuration.
# 
# **Replacements:**
# 
# `!Name!` with the name of the variable or method whose content you are
# altering or creating.
# 
# `!Value!` with the value it should hold. This can be anything, as it will be
# treated as a String (display only and all that).
# 
# `<Bestiary Hide All (Stats|Parameters|Params)>`
# 
#   Place this in a Notes box to have all of an enemy's basic stats (HP, MP,
# ATK, and so on) drawn as ???. A convenience method for bosses and other
# special enemies.
# 
# **Replacements:**
# 
# None - just choose one of the three names in the parentheses of the tag. Only
# use one - multiple possibilities are included due to variance in the
# preferences of developers.
# 
# ```
# <Bestiary Description>
#   ...TEXT...
#   ...TEXT...
# </Bestiary Description>
# ```
# 
#   Place this in a Notes box to determine what will be drawn for an enemy's
# description. Everything between the opening and closing tags will be
# considered part of the description. Text will be automatically wrapped to
# fit, and any line breaks manually inserted with Enter will drop to a new line
# regardless of position when the description is drawn.
# 
# **Replacements:**
# 
# None - just make sure to include a description. If this tag is absent from an
# enemy, an empty description will be drawn.
# 
# Script Calls
# -----------------------------------------------------------------------------
#   These can be used in events or within your own scripts, as they are all
# calls to `$game_party`.
# 
#     $game_party.reveal_bestiary_enemy(ID)
# 
#   Replace `ID` with the ID of the enemy that you would like to reveal. This
# call causes **all** of the enemy's data to be marked as known.
# 
#     $game_party.add_bestiary_enemy(ID, Defeated)
# 
#   Replace `ID` with the ID of the enemy that you would like to add and
# `Defeated` with either `true` (the counter for the number of defeated enemies
# should be incremented) or `false` (it should not). This will only make the
# page visible -- it will not mark any individual pieces of data as known.
# 
#     $game_party.add_bestiary_data(ID, Type, Data)
# 
#   This is the most complicated of the calls. Replace `ID` with the ID of the
# enemy whose data you are updating. `Type` should be `:dro` for Drops, `:ele`
# for Elements, `:sta` for States, or `:ski` for Skills. Data varies depending
# on the Type. For `:ele`, `:sta`, and `:ski`, it should be the ID of an
# Element, State, or Skill. For `:dro`, it should be a string in the format
# `"Kind-ID"`. Kind should be 1 (for Items), 2 (for Weapons), or 3 (for
# Armors). ID is the Database ID of the item in question.
# 
# Aliased Methods
# -----------------------------------------------------------------------------
# * `class Game_Enemy`
#     - `make_drop_items`
# * `class Game_Party`
#     - `initialize`
# 
# New Methods
# -----------------------------------------------------------------------------
# * `class RPG::Enemy`
#     - `bestiary_show?`
#     - `bestiary_parameter`
# 
# * `class Game_Enemy`
#     - `defeated_count`
#     - `use_item`
#     - `item_apply`
#     - `item_effect_add_state_attack`
#     - `item_effect_add_state_normal`
#     - `bestiary_parameter`
# 
# * `class Game_Party`
#     - `reveal_bestiary_enemy`
#     - `add_bestiary_enemy`
#     - `add_bestiary_data`
#     - `knows_bestiary_enemy?`
#     - `knows_bestiary_data?`
# 
# * `class Game_Troop`
#     - `on_battle_end`
# 
# License
# -----------------------------------------------------------------------------
#   This script is made available under the terms of the MIT Expat license.
# View [this page](http://sesvxace.wordpress.com/license/) for more detailed
# information.
# 
# Installation
# -----------------------------------------------------------------------------
#   This script requires the SES Core (v2.2 or higher) and SES Window Book
# (v3.0 or higher) in order to function. Both of these scripts may be found in
# the SES source repository at the following locations:
# 
# * [Core](https://raw.github.com/sesvxace/core/master/lib/core.rb)
# * [Window Book](https://raw.github.com/sesvxace/book/master/lib/book.rb)
# 
# Place this script below Materials, but above Main. Place this script below
# the SES Core and SES Window Book.
# 
#++
module SES
  module Bestiary
    # =========================================================================
    # BEGIN CONFIGURATION
    # =========================================================================
    # A hash of pages. Each page is represented by an array that consists of
    # subarrays defining lines. Each line array contains a set of arrays
    # defining what will be drawn on a given line. 'Line' may be a misnomer,
    # however, as in the case of a number of the possible entries more than a
    # single line of space may be taken up, such as for the display of elemental
    # resistances.
    Pages = {
      # Page 1
      1 => [
        # Line 1
        [
          # Draw Name
          #   This is the most basic form of value definition, consisting of a
          #   leading string and a method or variable found in Game_Enemy. When
          #   the bestiary encounters an array in this format, it will print out
          #   the leading string (in this case empty) followed by the result of
          #   the method when called on the current enemy, which in this case
          #   will print the enemy's name.
          ['\c[14]', :name],
          # Draw Enemy Battler
          #   Unlike the previous example, this does not define a value. It will
          #   instead call the passed method on the bestiary window itself, in
          #   this case drawing the enemy's battler.
          [:draw_enemy]
        ],
        # Line 2
        #   Line 2 will display the number of times that the current enemy has
        #   been defeated by the party.
        [
          ['\c[16]Defeated Count:\c[0] ', :defeated_count]
        ],
        # Line 3
        #   Line 4 is an empty array, which means it will produce an empty line.
        [],
        # Line 4
        [
          # Draw HP
          #   This is a slightly more complicated version of the array from the
          #   first line that is used to draw the enemy's name. Lines are
          #   printed with draw_text_ex, so you can use any of the control
          #   characters that are available when displaying a message from an
          #   event. Here we display the text "HP:" in color 16 of the
          #   windowskin - the 'system color.'
          #   The value call is also slightly more complicated than it was for
          #   the name. An array of values can be given, which are passed to the
          #   method when it is called on the enemy. In this case we tell it
          #   that we want to pass :mhp to the enemy's bestiary_parameter
          #   method. bestiary_parameter will check if the enemy has a value for
          #   the given parameter defined in its Notes box and use that if it is
          #   present (useful for giving bosses ??? for stats, for example). If
          #   it is not, it will use the normal value of the passed argument.
          #   Most of the lines from here on will use this format.
          ['\c[16]HP: \c[0] ', :bestiary_parameter, [:mhp]],
          # Draw MP
          ['\c[16]MP: \c[0] ', :bestiary_parameter, [:mmp]]
        ],
        # Line 5
        [
          # Draw ATK
          ['\c[16]ATK:\c[0] ', :bestiary_parameter, [:atk]],
          # Draw DEF
          ['\c[16]DEF:\c[0] ', :bestiary_parameter, [:def]]
        ],
        # Line 6
        [
          # Draw MAT
          ['\c[16]MAT:\c[0] ', :bestiary_parameter, [:mat]],
          # Draw MDF
          ['\c[16]MDF:\c[0] ', :bestiary_parameter, [:mdf]]
        ],
        # Line 7
        [
          # Draw AGI
          ['\c[16]AGI:\c[0] ', :bestiary_parameter, [:agi]],
          # Draw LUK
          ['\c[16]LUK:\c[0] ', :bestiary_parameter, [:luk]]
        ],
        [
          # Draw EXP
          ['\c[16]EXP:\c[0] ', :bestiary_parameter, [:exp]],
          # Draw Gold
          ['\c[16]GLD:\c[0] ', :bestiary_parameter, [:gold]]
        ],
        # Line 9
        [
          # Draw Column Description
          #   The draw_column_description method is used to draw the description
          #   text for an enemy along one side of the screen. It takes a
          #   parameter that should be either 0 (for the left side) or 1 (for
          #   the right side). The :draw_description method is also available.
          #   It will draw the text across the entire horizontal length of a
          #   page, making it useful if you decide to add a page dedicated to
          #   the description rather than having it present on all pages like in
          #   the default setup.
          [:draw_column_description, [1]],
          # Draw Elements
          #   Here we call the draw_elements_as_icons method to create a basic
          #   representation of elemental resistances. draw_elements_as_icons
          #   will draw the icons for every element with a letter displayed over
          #   their lower-right corner - W for weakness, R for resist, N for
          #   immunity, and D for drain. A dash will be displayed if neutral
          #   damage is taken from the element. If you use RequireElementKnown
          #   with draw_elements_as_icons, a ? will be displayed in place of a
          #   letter for all undiscovered elements.
          [:draw_elements_as_icons],
        ],
        [
          # Draw States
          #   Here we call the draw_states_as_icons method to create a basic
          #   representation of state resistances. draw_states_as_icons will
          #   draw the icons for every state not present in the Hidden States
          #   array with a letter displayed over their lower-right corner - W
          #   for weakness, R for resist, and N for immunity. A dash will be
          #   displayed if the enemy has neutral resistance towards the state.
          #   If you use RequireStateKnown with draw_states_as_icons, a ? will
          #   be displayed in place of a letter for all undiscovered elements.
          [:draw_states_as_icons, [0.5]]
        ],
        [
          # Draw Drops
          #   Here we draw the enemy's drops. This method will draw the icon,
          #   name, and drop rate of each item in the enemy's drop_items array.
          #   You can set up behavior for unfound drops in the RequireDropKnown
          #   hash. This method takes two parameters - a number of columns and
          #   a multiplier for the maximum width of the drawing section. Since
          #   we only want it to be drawn along the left side of the screen in
          #   the default setup, columns are set to 1 and the multiplier is set
          #   to 0.5 (half of the row).
          [:draw_drops, [1, 0.5]]
        ]
      ],
      # Page 2
      2 => [
        # Line 1
        [
          # Draw Name
          ['\c[14]', :name],
          # Draw Enemy Battler
          [:draw_enemy],
          # Draw Column Description
          [:draw_column_description, [1, 8]]
        ],
        # Line 2
        [
          # Draw Skills
          #   Calls the draw_skills method on the bestiary window to display a
          #   list of the skills that an enemy is capable of using. If you have
          #   RequireSkillKnown set to true, only skills that the enemy has been
          #   observed using will be drawn.
          [:draw_skills]
        ],
        
      ],
#~       # Example Page 3 that would draw a full-page description.
#~       3 => [
#~         [
#~           # Draw Name
#~           ['\c[14]', :name],
#~           # Draw Enemy Battler
#~           [:draw_enemy]
#~         ],
#~         [
#~           ['\\c[16]Information']
#~         ],
#~         [
#~           [:draw_description]
#~         ]
#~       ]
    }
    
    # Defines the maximum height and width of the battler image when it is drawn
    # on a bestiary page.
    BattlerSize = [
      # Width
      #   When set to :default, this will be set to half of the page's width.
      #   If given an integer, it will instead use that as a static maximum
      #   width.
      :default,
      # Height
      #   When set to :default, this will be set to half of the page's height.
      #   If given an integer, it will instead use that as a static maximum
      #   height.
      :default
    ]
    
    # Determines whether or not enemies will be visible in the bestiary before
    # they have been encountered.
    RequireEnemyKnown = true
    
    # Advanced configuration for unknown drop items.
    RequireDropKnown = {
      # If this is set to true, the item's name will not be visible unless it
      # has been found as a drop from the enemy in question. It will instead be
      # displayed as ???. This must be set to true for the other options to have
      # any effect.
      'Item' => true,
      # If this is set to true, the icons of unfound drops will not be drawn.
      'Icon' => false,
      # If this is set to true, the drop rates of unfound drops will not be
      # drawn.
      'Rate' => false,
    }
    
    # This option allows you to configure the type of drop rate that you are
    # using in your game. :default is the basic RPG Maker VX system. Only use
    # :percentage if you are using a script that changes drop rates to be fully
    # percentage based.
    #   :default - 1 in n chance
    #   :percentage - n% chance
    DropRateType = :default
    
    # Determines whether or not elemental resistances will be visible before you
    # have hit an enemy with an element.
    RequireElementKnown = true
    
    # Defines the columns to be displayed when the draw_elements_as_columns
    # method is called. Possible values are 'Weak', 'Resist', 'Null', and
    # 'Absorb'. The order in which they exist in this array determines the order
    # in which they will be drawn, and removing a value from this array will
    # prevent the column from being shown. If you are not using a script that
    # allows you to define elements for an enemy to absorb, you should remove
    # the 'Absorb' column as it will always be drawn empty.
    # NOTE: THIS METHOD IS NOT YET FULLY FUNCTIONAL. DO NOT USE.
    Elements = ['Weak', 'Resist', 'Null', 'Absorb']
    
    # Defines icons corresponding to each element. The first element of this
    # array is unused, as there is no element ID zero. The second value in the
    # array corresponds to the first database element, the third value
    # represents the second database element, and so on.
    # In the case of the default database, this sets the Physical element to use
    # icon 11, the Absorb element to use icon 9, the Fire element to use icon
    # 96, and so on.
    ElementIcons = [nil, 11, 9, 96, 97, 98, 99, 100, 101, 102, 103]
    
    # Determines the colors in which the letters corresponding to elemental
    # resistance will be drawn. Each number here should be an index from your
    # windowskin, just like the \c[#] control character in a message window.
    ElementRateColor = {
      # Color for W - Weak
      'Weak' => 18,
      # Color for R - Resist
      'Resist' => 17,
      # Color for N - Null
      'Null' => 7,
      # Color for D - Drain
      'Drain' => 11,
    }
    
    # Determines whether or not state resistances will be visible before you
    # have tried to hit an enemy with a state.
    RequireStateKnown = true
    
    # Same as the configuration array for draw_elements_as_columns, but for
    # states.
    # NOTE: THIS METHOD IS NOT YET FULLY FUNCTIONAL. DO NOT USE.
    States = ['Weak', 'Resist', 'Null']
    
    # Determines the colors in which the letters corresponding to state
    # resistance will be drawn. Each number here should be an index from your
    # windowskin, just like the \c[#] control character in a message window.
    StateRateColor = {
      # Color for W - Weak
      'Weak' => 18,
      # Color for R - Resist
      'Resist' => 17,
      # Color for N - Null
      'Null' => 7,
    }
    
    # States present in this array will not be shown when a draw_states method
    # is called in the bestiary. Use this for beneficial states or states that
    # are normally 'hidden' from the player.
    HiddenStates = [9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23,
                    24, 25, 26]
    
    # Determines whether or not you need to see an enemy use a skill before it
    # is drawn in their list of skills.
    RequireSkillKnown = true
    
    # This array contains a list of skill IDs that should never be displayed
    # when draw_skills is called. The default setting is [1, 2], which prevents
    # the Attack and Guard skills from being shown.
    HiddenSkills = [1, 2]
    # =========================================================================
    # END CONFIGURATION
    # =========================================================================
  end
end
                    ($imported ||= {})['SES - Bestiary'] = 1.0
# Basic Enemy class for RPG Maker VX Ace.
class RPG::Enemy < RPG::BaseItem
  
  alias_method :en_be_e_ssn, :scan_ses_notes
  # Scans the Notes box of an enemy.
  #
  # @param tags [Hash] hash of tags that should be parsed
  def scan_ses_notes(tags = {})
    @bestiary_image_offset = 0
    @bestiary_show = Hash.new(true)
    @bestiary_parameters = {}
    @bestiary_description = []
    @hidden_skills = SES::Bestiary::HiddenSkills.clone
    tags[/^<Bestiary X Offset:\s*([\-\d]+)>/i] =
      proc do |offset|
        @bestiary_image_offset = offset.to_i
      end
    tags[/^<Bestiary Hide (Skills|Elements|States)>/i] =
      proc do |type|
        @bestiary_show[type[0..2].downcase.to_sym] = false
      end
    tags[/^<Bestiary Hide Skill:\s*((\d+[,\s]*)+)>/i] =
      proc do |skills|
        skills.gsub!(/(\d+)/) do
          @hidden_skills << $1.to_i; ''
        end
      end
    tags[/^<(?:Bestiary Parameter|Bestiary Param) (\w+):\s*(.+)>/i] =
      proc do |param, value|
        @bestiary_parameters[param.downcase.to_sym] = value
      end
    tags[/^<Bestiary Hide All (?:Stats|Parameters|Params)>/i] =
      proc do
        [:mhp, :mmp, :atk, :def, :mat, :mdf, :agi, :luk].each do |param|
          @bestiary_parameters[param] = '???'
        end
      end
    tags[/^<Bestiary Description>/i] = proc do
      note[/<Bestiary Description>(.+)<\/Bestiary Description>/im]
      @bestiary_description = $1 ? $1.split(/[\r\n]/) : []
    end
    en_be_e_ssn(tags)
  end
  
  # Checks whether or not a given type of data should be displayed in the
  #  bestiary.
  #
  # @param type [Symbol] the type of data to check
  def bestiary_show?(type)
    scan_ses_notes unless @bestiary_show
    return @bestiary_show[type]
  end
  
  # Gets altered display data for a parameter.
  #
  # @param param [Symbol, String] the parameter whose data is being requested
  def bestiary_parameter(param)
    scan_ses_notes unless @bestiary_parameters
    return @bestiary_parameters[param]
  end
  
  # Defines getter methods for the various variables grabbed from Notes boxes.
  [:bestiary_image_offset, :bestiary_description, :hidden_skills].each do |var|
    define_method(var) do
      scan_ses_notes unless instance_variable_get("@#{var}")
      return instance_variable_get("@#{var}")
    end
  end
end

# Singleton class of the SceneManager module.
class << SceneManager
  attr_reader :stack
end

# Battle class for Enemies in RPG Maker VX Ace.
class Game_Enemy < Game_Battler
  
  # Gets the number of defeated enemies of this type.
  #
  # @return [Integer] the number of defeated enemies of this type
  def defeated_count
    $game_party.knows_bestiary_enemy?(@enemy_id) || 0
  end
  
  # Triggers the use of a skill by the enemy.
  #
  # @param [RPG::Skill] the skill to be used
  def use_item(item)
    super
    $game_party.add_bestiary_data(@enemy_id, :ski, item.id)
  end
  
  # Applies the effects of a skill or item to the enemy.
  #
  # @param user [Game_Actor, Game_Enemy] the user of the skill or item
  # @param item [RPG::Item, RPG::Skill] the skill or item to be applied
  def item_apply(user, item)
    super
    if item.damage.element_id < 0
      user.atk_elements.each do |e|
        $game_party.add_bestiary_data(@enemy_id, :ele, e)
      end
    else
      $game_party.add_bestiary_data(@enemy_id, :ele, item.damage.element_id)
    end
  end
  
  # Adds a state to the enemy based on the attacker's normal attack states.
  #
  # @param user [Game_Actor, Game_Enemy] the user of the skill or item
  # @param item [RPG::Item, RPG::Skill] the skill or item being used
  # @param effect [RPG::UsableItem::Effect] the effect being applied
  def item_effect_add_state_attack(user, item, effect)
    super(user, item, effect)
    user.atk_states.each do |state_id|
      $game_party.add_bestiary_data(@enemy_id, :sta, state_id)
    end
  end
  
  # Adds a state to the enemy.
  #
  # @param user [Game_Actor, Game_Enemy] the user of the skill or item
  # @param item [RPG::Item, RPG::Skill] the skill or item being used
  # @param effect [RPG::UsableItem::Effect] the effect being applied
  def item_effect_add_state_normal(user, item, effect)
    super(user, item, effect)
    $game_party.add_bestiary_data(@enemy_id, :sta, effect.data_id)
  end
  
  alias_method :en_be_ge_mdi, :make_drop_items
  # Determines what items an enemy will drop after a given battle.
  #
  # @return [Array] an array of items that the enemy will drop when defeated
  def make_drop_items
    items = en_be_ge_mdi
    items.each do |item|
      enemy.drop_items.each_with_index do |d,i|
        if item == item_object(d.kind, d.data_id)
          $game_party.add_bestiary_data(@enemy_id, :dro,
                                        "#{d.kind}-#{d.data_id}")
        end
      end
    end
    return items
  end
  
  # Gets altered display data for a parameter.
  #
  # @param param [Symbol, String] the parameter whose data is being requested
  def bestiary_parameter(param)
    enemy.send(:bestiary_parameter, param) || send(param)
  end
end

# The Party class for RPG Maker VX Ace.
class Game_Party < Game_Unit
  attr_reader :bestiary_known_data
  
  alias_method :en_be_gp_i, :initialize
  # Creates a new instance of Game_Party.
  #
  # @return [Game_Party] a new instance of Game_Party
  def initialize
    en_be_gp_i
    @bestiary_known_data = {}
    @bestiary_known_data[:ene] = {}
    @bestiary_known_data[:dro] = {}
    @bestiary_known_data[:ele] = {}
    @bestiary_known_data[:sta] = {}
    @bestiary_known_data[:ski] = {}
  end
  
  # Reveals all information about a given enemy.
  #
  # @param enemy [Integer] the ID of the enemy whose data should be revealed
  def reveal_bestiary_enemy(enemy)
    add_bestiary_enemy(enemy)
    de = $data_enemies[enemy]
    de.drop_items.each do |d|
      add_bestiary_data(enemy, :dro, "#{d.kind}-#{d.data_id}")
    end
    $data_system.elements.each_index { |i| add_bestiary_data(enemy, :ele, i) }
    $data_states.compact.size.times { |i| add_bestiary_data(enemy, :sta, i+1) }
    de.actions.each { |a| add_bestiary_data(enemy, :ski, a.skill_id) }
  end
  
  # Adds an enemy to the list of known enemies.
  #
  # @param enemy [Integer] the ID of the enemy who should be added
  # @param defeated [TrueClass, FalseClass] whether or not the defeat counter
  #  should be updated
  def add_bestiary_enemy(enemy, defeated = false)
    @bestiary_known_data[:ene][enemy] ||= 0
    @bestiary_known_data[:ene][enemy] += 1 if defeated
  end
  
  # Adds a given piece of information to the known facts about an enemy.
  #
  # @param enemy [Integer] the ID of the enemy whose data should be added
  # @param type [Symbol] the type of data being added
  # @param data [Integer, String] the data to be added
  def add_bestiary_data(enemy, type, data)
    store = (@bestiary_known_data[type][data] ||= [])
    store << enemy unless store.include?(enemy)
  end
  
  # Checks if an enemy has been encountered.
  #
  # @param enemy [Integer] the ID of the enemy whose encounter status is being
  #  checked
  # @return [TrueClass, FalseClass] the encounter status of the enemy
  def knows_bestiary_enemy?(enemy)
    if SES::Bestiary::RequireEnemyKnown then @bestiary_known_data[:ene][enemy]
    else @bestiary_known_data[:ene][enemy] || 0 end
  end
  
  # Checks if a given piece of information is known about an enemy.
  #
  # @param type [Symbol] the type of data being checked
  # @param data [Integer, String] the data being checked
  # @param enemy [Integer] the ID of the enemy whose known data is being checked
  # @return [TrueClass, FalseClass] the known status of the data
  def knows_bestiary_data?(type, data, enemy)
    return false unless @bestiary_known_data[type][data]
    return @bestiary_known_data[type][data].include?(enemy)
  end
end

# The Enemy Troop class for RPG Maker VX Ace.
class Game_Troop < Game_Unit
  
  # Method run when a battle concludes.
  def on_battle_end
    members.each do |member|
      if member.alive? then $game_party.add_bestiary_enemy(member.enemy_id)
      else $game_party.add_bestiary_enemy(member.enemy_id, true) end
    end
    super
  end
end

# Bestiary window - a subclass of Window_Book.
class Bestiary < Window_Book
  include SES::Bestiary
  
  # Creates a new instance of the Bestiary window.
  #
  # @param enemy [Integer] the ID of the enemy to display
  # @param allow_change [TrueClass, FalseClass] whether or not the pages should
  #  be turnable
  # @return [Bestiary] a new instance of the Bestiary class
  def initialize(enemy, allow_change = true)
    @contents_heights = Hash.new(0)
    @enemy = enemy.is_a?(Integer) ? Game_Enemy.new(1, enemy) : enemy
    @draw_y = 0
    @id = @enemy.enemy_id
    @allow_change_enemy = allow_change
    @battler_size = []
    gwidth = Graphics.width - standard_padding * 2
    gheight = Graphics.height - standard_padding * 2
    if BattlerSize[0] == :default then @battler_size << gwidth / 2
    else @battler_size << BattlerSize[0] end
    if BattlerSize[1] == :default then @battler_size << gheight / 2
    else @battler_size << BattlerSize[1] end
    super()
  end
  
  # Checks the maximum number of pages for an enemy in the Bestiary.
  #
  # @return [Integer] the maximum number of pages
  def max_pages() Pages.keys.size end
  
  # Checks the maximum with of a page at the given line.
  #
  # @param y [Integer] the line number to check
  # @return [Integer] the width of the line
  def max_width(y = @draw_y)
    if @page != nil
      y *= 24
      if Pages[@page].flatten.include?(:draw_enemy)
        return contents_width - @battler_size[0] if y <= @battler_size[1]
      end
    end
    return contents_width
  end
  
  # Writes text to the page.
  #
  # @param text [Array] array of lines to write to the page
  # @param i [Integer] vertical line offset for the first line
  # @param newline_boundary [String] text prepended to wrapped lines
  # @param mode [Symbol] the mode of drawing
  # @param text_width [Symbol] method to be used when determining line width
  # @param l_x [Integer] horizontal line offset for all lines
  def write_page_text(text = @pagetext[@page], i = 0, newline_boundary = '',
                      mode = :bestiary, text_width = :contents_width, l_x = 0)
    if @enemy && mode == :bestiary then draw_parameters
    else super(text, i, newline_boundary, mode, text_width, l_x) end
  end
  
  # Draws a given bestiary page.
  def draw_parameters
    @draw_y = 0
    unless $game_party.knows_bestiary_enemy?(@enemy.enemy_id)
      draw_text_ex(0, 0, '???')
      @contents_heights[@page] = contents_height
      return
    end
    Pages[@page].each_with_index do |l,li|
      @draw_y += 1 and next if l.empty?
      wid = max_width(@draw_y) / l.size
      l.each_with_index do |p,i|
        @draw_y += 1 and next unless p[0]
        if p[0].is_a?(String)
          if p[1]
            value = p[2] ? @enemy.send(p[1], *p[2]) : @enemy.send(p[1])
            draw_text_ex(i * wid, @draw_y * line_height, "#{p[0]}#{value}")
          else draw_text_ex(i * wid, @draw_y * line_height, "#{p[0]}") end
        else (p[1] && p[1].empty?) ? send(p[0]) : send(p[0], *p[1]) end
      end
      @draw_y += 1
    end
    if @contents_heights[@page] == 0 && @draw_y > 0
      @draw_y = [@draw_y, @max_y + 1].max if @max_y
      @contents_heights[@page] = [@draw_y * line_height, contents_height].max
      refresh
    end
  end
  
  # Draws the current enemy's battler.
  def draw_enemy
    src_bitmap = Cache.battler(@enemy.battler_name, @enemy.battler_hue)
    src_rect = Rect.new(0, @draw_y, src_bitmap.width, src_bitmap.height)
    width = [src_bitmap.width, @battler_size[0]].min
    height = [src_bitmap.height, @battler_size[1]].min
    xpos, ypos = (@battler_size[0] - width) / 2, (@battler_size[1] - height) / 2
    xpos += @enemy.enemy.bestiary_image_offset
    dest_rect = Rect.new(max_width + xpos, @draw_y + ypos, width, height)
    contents.stretch_blt(dest_rect, src_bitmap, src_rect)
  end
  
  # Draws the list of an enemy's elemental resistances.
  #
  # @param w [Integer] multiplier that adjusts the number of icons per row
  # @param xadj [Integer] horizontal offset for the list
  def draw_elements_as_icons(w = 1, xadj = 0)
    icons_per_row = (max_width / 29 + 1) * w
    x = (max_width * w - text_size('Elemental Affinities').width) / 2 + xadj
    draw_text_ex(x, @draw_y * line_height, '\c[16]Elemental Affinities')
    @draw_y += 1 and yadj = 0
    $data_system.elements.each_index do |e|
      next if e == 0 || !ElementIcons[e]
      @draw_y += 1 and yadj = 4 if (e - 1) % icons_per_row == 0 && e - 1 != 0
      row_x, row_y = (e - 1) % icons_per_row * 29, @draw_y * line_height + yadj
      draw_text_ex(row_x, row_y, "\\I[#{ElementIcons[e]}]")
      if @enemy.enemy.bestiary_show?(:ele)
        value = @enemy.element_rate(e)
        if !RequireElementKnown ||
           $game_party.knows_bestiary_data?(:ele, e, @id)
          if value < 0 then rate = "\\c[#{ElementRateColor['Drain']}]D"
          elsif value == 0 then rate = "\\c[#{ElementRateColor['Null']}]N"
          elsif value < 1.0 then rate = "\\c[#{ElementRateColor['Resist']}]R"
          elsif value > 1.0 then rate = "\\c[#{ElementRateColor['Weak']}]W"
          else rate = '-' end
        else rate = '?' end
      else rate = '?' end
      draw_text_ex(row_x + 12, row_y + 4, rate)
      @draw_y = [row_y / line_height, @draw_y].max
    end
  end
  
  # Draws the list of an enemy's state resistances.
  #
  # @param w [Integer] multiplier that adjusts the number of icons per row
  # @param xadj [Integer] horizontal offset for the list
  def draw_states_as_icons(w = 1, xadj = 0)
    xadj *= (max_width * w)
    icons_per_row = (max_width / 29 + 1) * w
    x = (max_width * w - text_size('State Affinities').width) / 2 + xadj
    draw_text_ex(x, @draw_y * line_height, '\c[16]State Affinities')
    @draw_y += 1 and yadj = 0
    states = $data_states.select do |s|
      s && s.icon_index > 0 && !HiddenStates.include?(s.id)
    end
    states.each_with_index do |s,i|
      @draw_y += 1 and yadj = 4 if i % icons_per_row == 0 && i != 0
      row_x = (i % icons_per_row) * 29 + xadj
      row_y = @draw_y * line_height + yadj
      draw_text_ex(row_x, row_y, "\\I[#{s.icon_index}]")
      value = @enemy.state_rate(s.id)
      value = 0 if @enemy.state_resist_set.include?(s.id)
      if @enemy.enemy.bestiary_show?(:sta)
        if !RequireStateKnown ||
           $game_party.knows_bestiary_data?(:sta, s.id, @id)
          if value == 0 then rate = "\\c[#{StateRateColor['Null']}]N"
          elsif value < 1.0 then rate = "\\c[#{StateRateColor['Resist']}]R"
          elsif value > 1.0 then rate = "\\c[#{StateRateColor['Weak']}]W"
          else rate = '-' end
        else rate = '?' end
      else rate = '?' end
      draw_text_ex(row_x + 12, row_y + 4, rate)
      @draw_y = [row_y / line_height, @draw_y].max
    end
  end
  
  # Draws the skills that an enemy can use.
  #
  # @param cols [Integer] the number of columns in which skills should be drawn
  def draw_skills(cols = 1)
    draw_text_ex(0, @draw_y * line_height, '\c[16]Skills')
    @draw_y += 1
    if @enemy.enemy.bestiary_show?(:ski)
      i, cwid = 0, max_width(@draw_y) / cols
      if RequireSkillKnown
        skills = $game_party.bestiary_known_data[:ski].select do |k,v|
          v.include?(@id)
        end.keys
      else skills = @enemy.enemy.actions.collect {|a| a.skill_id } end
      skills.each do |id|
        next if @enemy.enemy.hidden_skills.include?(id)
        if RequireSkillKnown
          next unless $game_party.knows_bestiary_data?(:ski, id, @id)
        end
        text = "\\I[#{$data_skills[id].icon_index}] #{$data_skills[id].name}"
        draw_text_ex(i * cwid, @draw_y * line_height, text)
        i += 1 and (i = 0 and @draw_y += 1 if i >= cols)
      end
    else draw_text_ex(0, @draw_y * line_height, '???') end
  end
  
  # Draws an enemy's description as full-page text.
  def draw_description
    @draw_y = write_page_text(@enemy.enemy.bestiary_description, @draw_y, '',
                              :ex, :max_width)
  end
  
  # Draws an enemy's description as a column.
  #
  # @param side [Integer] the side on which the column should be drawn
  # @param y [Integer] the y value at which the column should be drawn
  def draw_column_description(side = 0, y = @draw_y)
    @max_y = write_page_text(@enemy.enemy.bestiary_description, y, '',
                             :ex, :max_width, side * max_width)
  end
    
  # Draws an enemy's droppable items.
  #
  # @param cols [Integer] the number of columns that should be drawn
  # @param w [Integer] modifier for the placement of columns
  def draw_drops(cols = 1, w = 1)
    x = (max_width * w - text_size('Drops').width) / 2
    draw_text_ex(x, @draw_y * line_height, '\c[16]Drops')
    @draw_y += 1
    if @enemy.enemy.bestiary_show?(:dro)
      cwid = max_width * w / cols
      @enemy.enemy.drop_items.each_with_index do |d,i|
        next if d.kind == 0
        key = "#{d.kind}-#{d.data_id}"
        if RequireDropKnown['Item'] &&
           !$game_party.knows_bestiary_data?(:dro, key, @id)
          unknown = true
          next unless RequireDropKnown.values.include?(false)
        end 
        @draw_y += 1 if i > 0 && i % cols == 0
        row_x, row_y = (i % cols) * cwid, @draw_y * line_height
        if DropRateType == :default
          rate = "#{(1.0 / d.denominator) * 100}%"
        else rate = "#{d.denominator}%" end
        case d.kind
        when 1; di = $data_items[d.data_id]
        when 2; di = $data_weapons[d.data_id]
        when 3; di = $data_armors[d.data_id]
        end
        icon, item = di.icon_index, di.name
        if unknown
          if RequireDropKnown['Icon'] == false
            draw_icon(icon, row_x, row_y, false)
          end
          change_color(normal_color, false)
          wid = text_size('???').width
          draw_text(row_x + 32, row_y, wid + 4, line_height, '???')
          if RequireDropKnown['Rate'] == false
            draw_text(row_x + 28, row_y, cwid - 36, line_height, rate, 2)
          end
        else
          reset_font_settings
          draw_icon(icon, row_x, row_y)
          wid = cwid - 32 - text_size('50%').width
          draw_text(row_x + 32, row_y, wid, line_height, item)
          draw_text(row_x + 28, row_y, cwid - 36, line_height, rate, 2)
        end
      end
      @draw_y += 1
    end
  end
  
  # Draws the scroll arrows for the window.
  def draw_scroll
    y = @draw_y and @draw_y = contents_height / line_height
    super
    @draw_y = y
  end
  
  # Determines how tall the window's contents Bitmap should be.
  #
  # @param padding [Integer] the number of pixels of padding the height should
  #  have
  # @return [Integer] the height of the contents Bitmap in pixels
  def contents_height(padding = 2)
    if @contents_heights[@page] > 0 then return @contents_heights[@page]
    elsif @page && Pages[@page].flatten.include?(:draw_description)
      return super(2, :max_width, @enemy.enemy.bestiary_description)
    else return super end
  end
  
  # Turns the page back to the previous enemy.
  def previous_enemy
    @id -= 1 and (@id = $data_enemies.size - 1 if @id <= 0)
    if RequireEnemyKnown && !$game_party.knows_bestiary_enemy?(@id)
      last_id = @id and @id -= 1
      until $game_party.knows_bestiary_enemy?(@id) || @id == last_id
        @id -= 1 and (@id = $data_enemies.size - 1 if @id <= 0)
      end
    end
    @contents_heights.clear
    @enemy = Game_Enemy.new(0, @id) and @changed = true and refresh
  end
  
  # Turns the page forward to the next enemy.
  def next_enemy
    @id += 1 and (@id = 1 if @id >= $data_enemies.size)
    if RequireEnemyKnown && !$game_party.knows_bestiary_enemy?(@id)
      last_id = @id and @id += 1
      until $game_party.knows_bestiary_enemy?(@id) || @id == last_id
        @id += 1 and (@id = 1 if @id >= $data_enemies.size)
      end
    end
    @contents_heights.clear
    @enemy = Game_Enemy.new(0, @id) and @changed = true and refresh
  end
  
  # Updates the index of the Bestiary scene, if it exists.
  def update_scene_index
    if (scene = SceneManager.stack.find {|scene| scene.is_a?(Scene_Bestiary) })
      scene.set_index(@id - 1)
    end
  end
  
  # Processes scrolling between enemies and pages in the Bestiary.
  def process_cursor_move
    return unless super && @allow_change_enemy
    if Input.trigger?(:L)
      previous_enemy
      update_scene_index
    elsif Input.trigger?(:R)
      next_enemy
      update_scene_index
    end
    return true
  end
end

# A window that contains a list of enemies for the Bestiary scene.
class Window_BestiaryEnemyList < Window_Selectable
  
  # Creates a new instance of Window_BestiaryEnemyList.
  #
  # @param y [Integer] the y value at which to draw the window
  # @param height [Integer] the height of the window
  # @return [Window_BestiaryEnemyList] a new instance of the window
  def initialize(y, height)
    super(0, y, Graphics.width, height)
    @index ||= 0
    @data = []
  end
  
  # Gets the maximum number of columns to draw.
  #
  # @return [Integer] the number of columns to draw
  def col_max() 2 end
  
  # Gets the number of items in the window.
  #
  # @return [Integer] the number of items in the window
  def item_max() $data_enemies.size end
  
  # Gets the currently selected enemy.
  #
  # @return [RPG::Enemy] the enemy whose index is currently selected
  def item() $data_enemies[@index+1] end
  
  # Checks if the currently selected item is enabled.
  #
  # @return [TrueClass, FalseClass] the enabled status of the current item
  def current_item_enabled?
    enable?(@index)
  end
  
  # Checks if the item at the given index is enabled.
  #
  # @return [TrueClass, FalseClass] the enabled status of the item
  def enable?(index)
    return true unless SES::Bestiary::RequireEnemyKnown
    return true if $game_party.bestiary_known_data[:ene][index+1]
    return false
  end
  
  # Creates the data list for the window.
  def make_item_list
    if SES::Bestiary::RequireEnemyKnown
      @data = ['???'] * $data_enemies.size
      $game_party.bestiary_known_data[:ene].each_key do |enemy|
        enemy = $data_enemies[enemy]
        @data[enemy.id-1] = "#{enemy.id}: #{enemy.name}"
      end
    else
      @data = $data_enemies.collect { |enemy| enemy.bestiary_parameter(:name) }
    end
  end
  
  # Draws an item in the window.
  #
  # @param index [Integer] the index of the item to draw
  def draw_item(index)
    item = @data[index]
    if item
      rect = item_rect(index)
      change_color(normal_color, enable?(index))
      draw_text(rect.x, rect.y, contents_width / col_max, line_height, item)
    end
  end
  
  # Updates the help window with the number of encountered enemies.
  def update_help
    enc = $game_party.bestiary_known_data[:ene].keys.size
    @help_window.set_text("Encountered: #{enc}/#{$data_enemies.size}")
  end
  
  # Refreshes the window.
  def refresh
    make_item_list
    create_contents
    draw_all_items
  end
end

# A scene that allows the Bestiary to be browsed by enemy name.
class Scene_Bestiary < Scene_Base
  
  # Creates the viewport and windows of the scene.
  def start
    super
    create_help_window
    create_item_window
  end
  
  # Creates the scene's help window.
  def create_help_window
    @help_window = Window_Help.new(1)
    @help_window.viewport = @viewport
  end
  
  # Creates the scene's enemy list.
  def create_item_window
    @index ||= 0
    wy = @help_window.y + @help_window.height
    wh = Graphics.height - wy
    @item_window = Window_BestiaryEnemyList.new(wy, wh)
    @item_window.viewport = @viewport
    @item_window.help_window = @help_window
    @item_window.set_handler(:ok,     method(:on_item_ok))
    @item_window.set_handler(:cancel, method(:return_scene))
    @item_window.refresh
    @item_window.index = @index
    @item_window.activate
  end
  
  # Opens the Bestiary when an enemy is selected.
  def on_item_ok
    SceneManager.call(Scene_Book)
    SceneManager.scene.set_book(Bestiary.new(@item_window.index+1))
  end
  
  # Sets the current enemy index.
  #
  # @param index [Integer] the index that should be selected
  def set_index(index)
    @index = index
  end
end