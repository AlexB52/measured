# frozen_string_literal: true

Magic = Measured.build do
  unit :magic_missile, aliases: [:magic_missiles, "magic missile"]
  unit :fireball, value: "2/3 magic_missile", aliases: [:fire, :fireballs]
  unit :ice, value: "2 magic_missile"
  unit :arcane, value: "10 magic_missile"
  unit :ultima, value: "10 arcane"
end

DynamicMagic = Measured.build do
  unit :magic_missile, aliases: [:magic_missiles, "magic missile"]
  unit :fireball, value: "2/3 magic_missile", aliases: [:fire, :fireballs]

  unit :ice, value: [
    {
      conversion: ->(x) { Rational(2, 1) * x },
      inverse_conversion: ->(x) {  x * Rational(1, 2) },
      description: '2 magic missile'
    },
    "magic_missile"
  ]

  unit :arcane, value: [
    {
      conversion: ->(arc) { Rational(10, 1) * arc },
      inverse_conversion: ->(mm) {  mm * Rational(1, 10) },
      description: '10 magic missile'
    },
    "magic_missile"
  ]

  unit :ultima, value: [
    {
      conversion: ->(ult) { Rational(10, 1) * ult + 10},
      inverse_conversion: ->(arc) {  (arc-10) * Rational(1, 10) },
      description: '10 arcane + 10'
    },
    "arcane"
  ]
end

DynamicLength = Measured.build do
  unit :mm
  unit :cm, value: [
    {
      conversion: ->(cm) { Rational(10,1) * cm },
      inverse_conversion: ->(mm) { mm * Rational(1,10) },
      description: '10 mm',
    },
    "mm"
  ]

  unit :dm, value: '10 cm'
  unit :m, value: '10 dm'
end

OtherFakeSystem = Measured.build do
  unit :other_fake_base
  unit :other_fake1, value: "2 other_fake_base"
end
