class MyDeadlyBot < RTanque::Bot::Brain
  NAME = 'sebastian_deadly_bot'
  include RTanque::Bot::BrainHelper

  def tick!
    self.seek_enemy
    self.atack_enemy if @reflection
  end

  def seek_enemy
    @reflection = sensors.radar.first
    unless @reflection
      command.radar_heading = sensors.radar_heading + MAX_RADAR_ROTATION
    end
  end

  def atack_enemy
    command.heading = @reflection.heading
    command.turret_heading = @reflection.heading
    command.speed = @reflection.distance > 200 ? 1 : 0 
    command.fire
  end
end
