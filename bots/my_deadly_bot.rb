class MyDeadlyBot < RTanque::Bot::Brain
  NAME = 'my_deadly_bot'
  include RTanque::Bot::BrainHelper

  def tick!
    self.make_circles
    self.command.fire(0.25)
  end

  def make_circles
    command.speed = 5
    command.heading = sensors.heading + 0.01
  end
end
