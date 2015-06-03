# Name: SES - Bestiary
# Author: Enelvon
# URL: https://raw.githubusercontent.com/sesvxace/bestiary/master/lib/bestiary.rb
#
# A highly configurable bestiary.

Register.notify('Enelvon', 'SES - Bestiary')

Register.add do |enemy, enelvon_bestiary_x_offset, x|
  self.name = 'Bestiary X Offset'
  self.description = "Adjusts the X value of the enemy's battler in the bestiary."
  self.type = :Bestiary
  self.params[0] = [:Integer,
                    'Offset',
                    'The distance in pixels by which to adjust the battler\'s position.']
  
  [proc { |x| "<Bestiary X Offset: #{x}>" },
   /^<Bestiary X Offset:\s*([\-\d]+)>/i]
end

Register.add do |enemy, enelvon_bestiary_hide, info|
  self.name = 'Hide Bestiary Information'
  self.description = 'Hides particular kinds of information in the bestiary.'
  self.type = :Bestiary
  self.repeatable = true
  en_sese = ['Skills', 'Elements', 'States', 'Enemy']
  self.params[0] = [:String,
                    'Information',
                    'The kind of information to hide.',
                    proc { en_sese }]
  
  [proc { |info| "<Bestiary Hide #{info}>" },
   /^<Bestiary Hide (Skills|Elements|States|Enemy)>/i]
end

Register.add do |enemy, enelvon_bestiary_param, param, value|
  self.name = 'Bestiary Param'
  self.description = 'Allows enemy parameters to be falsified in the bestiary.'
  self.type = :Bestiary
  self.repeatable = true
  self.params[0] = [:String,
                    'Param Name',
                    'The name of the parameter that you want to falsify.']
  self.params[1] = [:String,
                    'Param Value',
                    'The falsified value of the parameter.']
  
  [proc { |param, value| "<Bestiary Parameter #{param}: #{value}>" },
   /^<(?:Bestiary Parameter|Bestiary Param) (\w+):\s*(.+)>/i]
end

Register.add do |enemy, enelvon_bestiary_hide_skills, *skills|
  self.name = 'Hide Bestiary Skills'
  self.description = 'Hides particular skills in the bestiary.'
  self.type = :Bestiary
  self.repeatable = true
  self.params[0] = [:Integer,
                    'Skill',
                    'The skill to hide.',
                    proc { Data_Skills.collect { |s| s.name if s } },
                    proc { |s| Data_Skills.find_index { |sk| sk.name == s } }]
  
  [proc do |*skills|
    s = '<Bestiary Hide Skill: '
    last = skills.last
    skills.each do |sk|
      s << "#{sk}"
      s << ', ' unless sk == last
    end
    s << '>'
  end,
  /^<Bestiary Hide Skill:\s*((?:\d+[,\s]*)+)>/i]
end

Register.add do |enemy, enelvon_bestiary_description, desc|
  self.name = 'Bestiary Description'
  self.description = 'A description of the enemy that will be displayed in the bestiary.'
  self.type = :Bestiary
  self.params[0] = [:Paragraph,
                    'Description',
                    'The enemy\'s description text.']
  
  [proc { |desc| "<Bestiary Description>#{desc}</Bestiary Description>" },
   /^<Bestiary Description>(.+)<\/Bestiary Description>/im]
end
