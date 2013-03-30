class BahamaMama < RTanque::Bot::Brain
  NAME = 'bahama_mama'
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

  def kurs_339
    command.heading = 0
  end

  def photonentorpedos
    command.turret_heading =
      case sensors.turret_heading
      when WEST..FULL_ANGLE then clockwise? ? FULL_ANGLE : WEST
      when NORTH..EAST then clockwise? ? EAST : NORTH
      when EAST..SOUTH then EAST
      when SOUTH..WEST then WEST
      else raise "Beam ein Aussenteam runter"
      end
  end

  def phaser
    command.turret_heading =
      case sensors.turret_heading
      when (EAST..SOUTH - 0.1) then clockwise? ? SOUTH : EAST
      when SOUTH..WEST then clockwise? ? WEST : SOUTH
      when WEST..FULL_ANGLE then WEST
      when NORTH..EAST then EAST
      else raise "Beam ein Aussenteam runter"
      end
  end

  def clockwise?
    @clockwise = true unless defined? @clockwise
    case sensors.turret_heading
    when EAST then @clockwise = !@clockwise
    when WEST then @clockwise = !@clockwise
    else @clockwise
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
