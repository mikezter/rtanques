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

  attr_accessor :clockwise

  def energie!
    command.speed = MAX_BOT_SPEED
  end

  def phaser
    switch_turret_direction
    command.turret_heading = sensors.turret_heading + ONE_DEGREE if clockwise
    command.turret_heading = sensors.turret_heading - ONE_DEGREE unless clockwise
  end

  def switch_turret_direction
    if sensors.position.on_top_wall?

      if sensors.turret_heading >= WEST
        @clockwise = false
      elsif sensors.turret_heading <= EAST
        @clockwise = true
      end

    elsif sensors.position.on_right_wall?

      if sensors.turret_heading <= SOUTH
        @clockwise = true
      elsif sensors.turret_heading <= EAST
        @clockwise = false
      end

    elsif sensors.position.on_bottom_wall?

      if sensors.turret_heading <= EAST
        @clockwise = false
      elsif sensors.turret_heading <= WEST
        @clockwise = true
      end

    elsif sensors.position.on_left_wall?

      if sensors.turret_heading >= WEST
        @clockwise = true
      elsif sensors.turret_heading >= SOUTH
        @clockwise = false
      end

    end
  end

  def heading
    return NORTH unless sensors.position.on_wall?
    if sensors.position.on_top_wall?
      if sensors.position.on_right_wall?
        SOUTH
      else
        EAST
      end
    elsif sensors.position.on_bottom_wall?
      if sensors.position.on_left_wall?
        NORTH
      else
        WEST
      end
    elsif sensors.position.on_right_wall?
      SOUTH
    elsif sensors.position.on_left_wall?
      NORTH
    end
  end

  def kurs_339
    command.heading = heading
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
