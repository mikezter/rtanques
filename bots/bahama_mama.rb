class BahamaMama < RTanque::Bot::Brain
  NAME = 'Bahama Mama'
  include RTanque::Bot::BrainHelper
  FULL_ANGLE   =      Math::PI * 2.0
  HALF_ANGLE   =      Math::PI
  EIGHTH_ANGLE =      Math::PI / 4.0
  QUARTER_ANGLE =      Math::PI / 2.0
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

  MARGIN = 200
  FIRE_ANGLE = 3 * EIGHTH_ANGLE
  attr_accessor :clockwise

  def energie!
    command.speed = MAX_BOT_SPEED
  end

  def phaser
    command.turret_heading = RTanque::Heading.new(heading + QUARTER_ANGLE + turret_rotation)
  end

  def turret_rotation
    if @offset > FIRE_ANGLE / 2
      @clockwise = false
    elsif @offset < -(FIRE_ANGLE / 2)
      @clockwise = true
    end

    if @clockwise
      @offset += ONE_DEGREE
    else
      @offset -= ONE_DEGREE
    end
  end

  def heading
    return NORTH if initializing?
    if near_top_wall? && near_right_wall?
      SOUTH
    elsif near_right_wall? && near_bottom_wall?
      WEST
    elsif near_bottom_wall? && near_left_wall?
      NORTH
    elsif near_left_wall? && near_top_wall?
      EAST
    elsif near_right_wall?
      SOUTH
    elsif near_bottom_wall?
      WEST
    elsif near_left_wall?
      NORTH
    elsif near_top_wall?
      EAST
    end
  end

  def kurs_339
    command.heading = heading
  end

  def feuer
    command.fire 1
  end

  def near_left_wall?
    sensors.position.x < MARGIN
  end

  def near_bottom_wall?
    sensors.position.y < MARGIN
  end

  def near_right_wall?
    sensors.position.x > arena.width - MARGIN
  end

  def near_top_wall?
    sensors.position.y > arena.height - MARGIN
  end

  def initializing?
    @initializing = true unless defined?(@initializing)
    @clockwise = false unless defined?(@clockwise)
    @offset ||= 0
    @initializing = false if near_top_wall?
    @initializing
  end

  def tick!
    kurs_339
    phaser
    feuer
    energie!
  end
end
