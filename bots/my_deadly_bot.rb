class MyDeadlyBot < RTanque::Bot::Brain
  NAME = 'sebastian_deadly_bot'
  include RTanque::Bot::BrainHelper

  TURRET_FIRE_RANGE = RTanque::Heading::ONE_DEGREE * 5.0

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

    change_direction if ticks_passed? 300

    @desired_heading = @reflection.heading + (Math::PI / 2.0)
    @desired_heading += RTanque::Heading::HALF_ANGLE if @direction

    command.heading = @desired_heading
    command.turret_heading = @reflection.heading
    command.speed = @reflection.distance > 200 ? MAX_BOT_SPEED : MAX_BOT_SPEED / 2.0
    if (@reflection.heading.delta(sensors.turret_heading)).abs < TURRET_FIRE_RANGE
      command.fire(@reflection.distance > 200 ? MAX_FIRE_POWER : MIN_FIRE_POWER)
    end
  end

  def ticks_passed?(ticks=200)
    (sensors.ticks % ticks) == 0
  end

  def change_direction
    @direction = @direction ? false : true
  end
end
