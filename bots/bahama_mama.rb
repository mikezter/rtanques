class BahamaMama < RTanque::Bot::Brain
  NAME = 'Bahama Mama'
  include RTanque::Bot::BrainHelper
  FULL_ANGLE   =      Math::PI * 2.0
  HALF_ANGLE   =      Math::PI
  EIGHTH_ANGLE =      Math::PI / 4.0
  ONE_DEGREE   =      FULL_ANGLE / 360.0
  FULL_RANGE   =      (0..FULL_ANGLE)

  NORTH = N =         0.0
  NORTH_EAST = NE =   1.0 * EIGHTH_ANGLE
  EAST = E =          2.0 * EIGHTH_ANGLE
  SOUTH_EAST = SE =   3.0 * EIGHTH_ANGLE
  SOUTH = S =         4.0 * EIGHTH_ANGLE
  SOUTH_WEST = SW =   5.0 * EIGHTH_ANGLE
  WEST = W =          6.0 * EIGHTH_ANGLE
  NORTH_WEST = NW =   7.0 * EIGHTH_ANGLE

  attr_accessor :clockwise, :go_west

  def energie!
    command.speed = MAX_BOT_SPEED
  end

  def phaser
    switch_turret_direction
    command.turret_heading = sensors.turret_heading + ONE_DEGREE if clockwise
    command.turret_heading = sensors.turret_heading - ONE_DEGREE unless clockwise
  end

  def switch_turret_direction
    if sensors.turret_heading >= WEST
      @clockwise = false
    elsif sensors.turret_heading <= EAST
      @clockwise = true
    end
  end

  def switch_direction
    if sensors.position.on_left_wall?
      @go_west = false
    elsif sensors.position.on_right_wall?
      @go_west = true
    end
  end

  def kurs_339
    switch_direction
    if !sensors.position.on_top_wall?
      command.heading = NORTH
    elsif go_west
      command.heading = WEST
    elsif !go_west
      command.heading = EAST
    end
  end

  def feuer
    command.fire 1
  end

  def tick!
    kurs_339
    phaser
    feuer
    energie!
  end
end
