#--
# Bestiary Addon: BGM v1.0 by Enelvon
# =============================================================================
# 
# Summary
# -----------------------------------------------------------------------------
#   This addon does two things: allows the bestiary to play music and allows
# enemies to have different battle themes. Battle themes are ranked by priority,
# so if multiple enemies with unique battle themes are in a troop together the
# music associated with the enemy with the highest priority will be played.
# 
# Compatibility Information
# -----------------------------------------------------------------------------
# **Required Scripts:**
#   SES Core v2.2 or higher.
#   SES Bestiary v1.0 or higher.
# 
# **Known Incompatibilities:**
#   None.
# 
# Usage
# -----------------------------------------------------------------------------
#   This script uses a single Notes tag to accomplish its task.
# 
# ### Enemy Note Tags:
# 
# `<BGM !Priority!: !Name!, !Volume!, !Pitch!)>`
# 
#   Place this in a Notes box to give an enemy a unique battle BGM.
# 
# **Replacements:**
# 
# `!Priority!` with the priority of the BGM. This only comes into play when more
# than one enemy with a unique BGM is present in a troop - the BGM with the
# highest priority will be played.
#
# `!Name!` with the name of a BGM present in the Audio/BGM folder. It should not
# include the extension.
#
# `Volume` with the volume at which the BGM should be played - this can be any
# integer in the range 0 to 100.
#
# `Pitch` with the pitch at which the BGM should be played - this can be any
# integer in the range 50 to 150.
#
# Overwritten Methods
# -----------------------------------------------------------------------------
# * `module BattleManager`
#     - `play_battle_bgm`
# 
# Aliased Methods
# -----------------------------------------------------------------------------
# * `class Bestiary`
#     - `initialize`
#     - `turn_page`
# 
# License
# -----------------------------------------------------------------------------
#   This script is made available under the terms of the MIT Expat license.
# View [this page](http://sesvxace.wordpress.com/license/) for more detailed
# information.
# 
# Installation
# -----------------------------------------------------------------------------
#   This script requires the SES Core (v2.2 or higher) and the SES Bestiary
# (v1.0 or higher) in order to function.
# These scripst can be found in the SES source repositories at the following
# locations:
# 
# * [Core](https://github.com/sesvxace/core/blob/master/lib/core.rb)
# * [Bestiary](https://github.com/sesvxace/bestiary/blob/master/lib/bestiary.rb)
# 
# Place this script below Materials, but above Main. Place this script below
# the SES Core.
# 
#++
module SES module BestiaryAddons
  
  # Always reset the play position of BGM when turning pages in the bestiary
  ResetBGM = false
  
end end
# Module that handles battle processing.
module BattleManager
  
  # Plays the battle BGM.
  def self.play_battle_bgm
    $game_troop.battle_bgm.play
    RPG::BGS.stop
  end
end
# Basic Enemy class for RPG Maker VX Ace.
class RPG::Enemy < RPG::BaseItem
  
  alias_method :en_bam_e_ssn, :scan_ses_notes
  # Scans the Notes box of an enemy.
  #
  # @param tags [Hash] hash of tags that should be parsed
  def scan_ses_notes(tags = {})
    bgm = $data_system.battle_bgm
    @battle_bgm = [0, [bgm.name, bgm.volume, bgm.pitch]]
    tags[/<BGM (\d+):\s*(.+)+?,\s*(\d+),\s*(\d+)>/i] =
      proc do |priority, name, volume, pitch|
        @battle_bgm = [priority.to_i, [name, volume.to_i, pitch.to_i]]
      end
    en_bam_e_ssn(tags)
  end
  
  # The BGM associated with the enemy.
  #
  # @return [Array] an Array that contains a priority and details for a BGM
  def battle_bgm
    scan_ses_notes if @battle_bgm.nil?
    return @battle_bgm
  end
end
# Battle class for Enemies in RPG Maker VX Ace.
class Game_Enemy < Game_Battler
  
  # The BGM associated with the enemy.
  #
  # @return [Array] an Array that contains a priority and details for a BGM
  def battle_bgm
    enemy.battle_bgm
  end
end
# The Enemy Troop class for RPG Maker VX Ace.
class Game_Troop < Game_Unit
  
  # The BGM associated with the troop.
  #
  # @return [RPG::BGM] the BGM associated with the troop
  def battle_bgm
    music = members.collect { |e| e.battle_bgm }.compact.sort_by { |i| i[0] }
    RPG::BGM.new(*music.reverse[0][1])
  end
end
# Bestiary window - a subclass of Window_Book.
class Bestiary < Window_Book
  
  alias_method :en_bam_b_i, :initialize
  # Creates a new instance of the Bestiary window.
  #
  # @param enemy [Integer] the ID of the enemy to display
  # @param allow_change [TrueClass, FalseClass] whether or not the pages should
  #  be turnable
  # @return [Bestiary] a new instance of the Bestiary class
  def initialize(enemy, allow_change = true)
    en_bam_b_i(enemy, allow_change)
    play_bgm
  end
  
  alias_method :en_bam_b_tp, :turn_page
  # Turns the page.
  def turn_page(num)
    en_bam_b_tp(num)
    play_bgm
  end
  
  # Plays the BGM associated with the enemy currently being displayed.
  def play_bgm
    if @bgm != @enemy.battle_bgm[1][0] || SES::BestiaryAddons::ResetBGM
      RPG::BGM.new(*@enemy.battle_bgm[1]).play
      @bgm = @enemy.battle_bgm[1][0]
    end
  end
end
