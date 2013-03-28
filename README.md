# RTanque Bots

## Quick Start

After cloning install the gems, create a bot and watch it fight:

    $ bundle
    $ bundle exec rtanque new_bot my_lovely_bot
    $ bundle exec rtanque start bots/my_lovely_bot bots/my_deadly_bot 

*Drive the Keyboard bot with asdf. Aim/fire with the arrow keys*

## [RTanque Documentation](http://rubydoc.info/github/awilliams/RTanque/master/frames/file/README.md)

  * [RTanque](http://rubydoc.info/github/awilliams/RTanque/master/frames/RTanque)
  * [RTanque::Bot::Brain](http://rubydoc.info/github/awilliams/RTanque/master/frames/RTanque/Bot/Brain)
  * [RTanque::Heading](http://rubydoc.info/github/awilliams/RTanque/master/frames/RTanque/Heading)
  * [RTanque::Point](http://rubydoc.info/github/awilliams/RTanque/master/frames/RTanque/Point)

## Sharing
At some point you'll want to compete against other bots, or maybe you'll even organize a small tournament. Sharing bots is easy.

Ask your friends to upload their bot(s) in a [gist](https://gist.github.com/), which you can then download with the following command:

    bundle exec rtanque get_gist <gist_id> ...

If you'd like to publicly share your bot, post its gist id on the wiki https://github.com/awilliams/RTanque/wiki/bot-gists

## Bot API

The tank api consists of reading input from Brain#sensors and giving output to Brain#command

**[Brain#sensors](http://rubydoc.info/github/awilliams/RTanque/master/frames/RTanque/Bot/Sensors)**

```ruby
class Bot < RTanque::Bot::Brain
  # RTanque::Bot::Sensors =
  #  Struct.new(:ticks, :health, :speed, :position, :heading, :radar, :turret)
  def tick!
    sensors.ticks # Integer
    sensors.health # Float
    sensors.position # RTanque::Point
    sensors.heading # RTanque::Heading
    sensors.speed # Float
    sensors.radar_heading # RTanque::Heading
    sensors.turret_heading # RTanque::Heading
    sensors.radar.each do |scanned_bot|
      # scanned_bot: RTanque::Bot::Radar::Reflection
      # Reflection(:heading, :distance, :name)
    end
  end
end
```
**[Brain#command](http://rubydoc.info/github/awilliams/RTanque/master/frames/RTanque/Bot/Command)**

```ruby
class Bot < RTanque::Bot::Brain
  # RTanque::Bot::Command =
  #  Struct.new(:speed, :heading, :radar_heading, :turret_heading, :fire_power)
  def tick!
    command.speed = 1
    command.heading = Math::PI / 2.0
    command.radar_heading = Math::PI
    command.turret_heading = Math::PI
    command.fire(3)
  end
end
```

**RTanque::Heading**
This class handles angles. It is a wrapper around Float bound to `(0..Math::PI*2)`

```ruby
RTanque::Heading.new(Math::PI)
=> <RTanque::Heading: 3.141592653589793rad 180.0deg>

RTanque::Heading.new_from_degrees(180)
=> <RTanque::Heading: 3.141592653589793rad 180.0deg>

RTanque::Heading.new_from_degrees(180) + RTanque::Heading.new(Math::PI)
=> <RTanque::Heading: 0.0rad 0.0deg>

RTanque::Heading.new(Math::PI) + (Math::PI / 2.0)
=> <RTanque::Heading: 4.71238898038469rad 270.0deg>

RTanque::Heading.new == 0
=> true
```
