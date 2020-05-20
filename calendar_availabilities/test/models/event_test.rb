require 'test_helper'

class EventTest < ActiveSupport::TestCase
  test "availabilities type check" do
    assert_raises(TypeError) { Event.availabilities('2014-08-10') }
    assert_raises(TypeError) { Event.availabilities(1) }
    assert_raises(ArgumentError) { Event.availabilities }
  end

  test "provided base test" do
    Event.create(
      kind: 'opening',
      starts_at: DateTime.parse("2014-08-04 09:30"),
      ends_at: DateTime.parse("2014-08-04 13:30"),
      weekly_recurring: true
    )
    Event.create(
      kind: 'appointment',
      starts_at: DateTime.parse("2014-08-11 10:30"),
      ends_at: DateTime.parse("2014-08-11 11:30")
    )

    availabilities = Event.availabilities DateTime.parse("2014-08-10")
    assert_equal '2014/08/10', availabilities[0][:date]
    assert_equal [], availabilities[0][:slots]
    assert_equal '2014/08/11', availabilities[1][:date]
    assert_equal ["9:30", "10:00", "11:30", "12:00", "12:30", "13:00"],
      availabilities[1][:slots]
    assert_equal [], availabilities[2][:slots]
    assert_equal '2014/08/16', availabilities[6][:date]
    assert_equal 7, availabilities.length
  end

  test "multiple openings" do
    Event.create(
      kind: 'opening',
      starts_at: DateTime.parse("2014-08-04 09:30"),
      ends_at: DateTime.parse("2014-08-04 13:30"),
      weekly_recurring: true
    )
    Event.create(
      kind: 'opening',
      starts_at: DateTime.parse("2014-08-05 14:00"),
      ends_at: DateTime.parse("2014-08-05 17:00"),
      weekly_recurring: true
    )
    Event.create(
      kind: 'opening',
      starts_at: DateTime.parse("2014-08-14 13:00"),
      ends_at: DateTime.parse("2014-08-14 16:00"),
      weekly_recurring: false
    )
    Event.create(
      kind: 'appointment',
      starts_at: DateTime.parse("2014-08-11 12:00"),
      ends_at: DateTime.parse("2014-08-11 12:30")
    )

    availabilities = Event.availabilities DateTime.parse("2014-08-10")
    assert_equal '2014/08/10', availabilities[0][:date]
    assert_equal [], availabilities[0][:slots]
    assert_equal '2014/08/11', availabilities[1][:date]
    assert_equal ["9:30", "10:00", "10:30", "11:00", "11:30", "12:30", "13:00"], availabilities[1][:slots]
    assert_equal '2014/08/12', availabilities[2][:date]
    assert_equal ["14:00", "14:30", "15:00", "15:30", "16:00", "16:30"], availabilities[2][:slots]
    assert_equal '2014/08/14', availabilities[4][:date]
    assert_equal ["13:00", "13:30", "14:00", "14:30", "15:00", "15:30"], availabilities[4][:slots]
    assert_equal '2014/08/16', availabilities[6][:date]
    assert_equal 7, availabilities.length
  end

  test "multiple appointments" do
    Event.create(
      kind: 'opening',
      starts_at: DateTime.parse("2014-08-04 09:30"),
      ends_at: DateTime.parse("2014-08-04 13:30"),
      weekly_recurring: true
    )
    Event.create(
      kind: 'opening',
      starts_at: DateTime.parse("2014-08-05 09:30"),
      ends_at: DateTime.parse("2014-08-05 13:30"),
      weekly_recurring: true
    )

    Event.create(
      kind: 'appointment',
      starts_at: DateTime.parse("2014-08-11 10:30"),
      ends_at: DateTime.parse("2014-08-11 11:30")
    )
    Event.create(
      kind: 'appointment',
      starts_at: DateTime.parse("2014-08-12 9:30"),
      ends_at: DateTime.parse("2014-08-12 10:00")
    )
    Event.create(
      kind: 'appointment',
      starts_at: DateTime.parse("2014-08-12 13:00"),
      ends_at: DateTime.parse("2014-08-12 13:30")
    )

    availabilities = Event.availabilities DateTime.parse("2014-08-10")
    assert_equal '2014/08/10', availabilities[0][:date]
    assert_equal [], availabilities[0][:slots]
    assert_equal '2014/08/11', availabilities[1][:date]
    assert_equal ["9:30", "10:00", "11:30", "12:00", "12:30", "13:00"], availabilities[1][:slots]
    assert_equal '2014/08/12', availabilities[2][:date]
    assert_equal ["10:00", "10:30", "11:00", "11:30", "12:00", "12:30"], availabilities[2][:slots]
    assert_equal '2014/08/16', availabilities[6][:date]
    assert_equal 7, availabilities.length
  end

  test "event opening recurring date is from weeks ago" do
    Event.create(
      kind: 'opening',
      starts_at: DateTime.parse("2014-07-28 09:30"),
      ends_at: DateTime.parse("2014-07-28 13:30"),
      weekly_recurring: true
    )
    Event.create(
      kind: 'opening',
      starts_at: DateTime.parse("2014-07-16 08:00"),
      ends_at: DateTime.parse("2014-07-16 12:00"),
      weekly_recurring: true
    )
    Event.create(
      kind: 'appointment',
      starts_at: DateTime.parse("2014-08-13 11:30"),
      ends_at: DateTime.parse("2014-08-13 12:00")
    )

    availabilities = Event.availabilities DateTime.parse("2014-08-10")
    assert_equal '2014/08/10', availabilities[0][:date]
    assert_equal [], availabilities[0][:slots]
    assert_equal '2014/08/11', availabilities[1][:date]
    assert_equal ["9:30", "10:00", "10:30", "11:00", "11:30", "12:00", "12:30", "13:00"], availabilities[1][:slots]
    assert_equal [], availabilities[2][:slots]
    assert_equal '2014/08/13', availabilities[3][:date]
    assert_equal ["8:00", "8:30", "9:00", "9:30", "10:00", "10:30", "11:00"], availabilities[3][:slots]
    assert_equal '2014/08/16', availabilities[6][:date]
    assert_equal 7, availabilities.length
  end

  test "event opening date is from weeks ago and no recurring" do
    Event.create(
      kind: 'opening',
      starts_at: DateTime.parse("2014-07-28 09:30"),
      ends_at: DateTime.parse("2014-07-28 13:30"),
      weekly_recurring: false
    )

    availabilities = Event.availabilities DateTime.parse("2014-08-10")
    assert_equal '2014/08/10', availabilities[0][:date]
    assert_equal [], availabilities.map { |a| a[:slots].uniq }.flatten!
    assert_equal '2014/08/16', availabilities[6][:date]
    assert_equal 7, availabilities.length
  end

  test "input date as end of month should overlap" do
    Event.create(
      kind: 'opening',
      starts_at: DateTime.parse("2014-08-04 09:30"),
      ends_at: DateTime.parse("2014-08-04 11:30"),
      weekly_recurring: true
    )

    availabilities = Event.availabilities DateTime.parse("2014-08-28")
    assert_equal '2014/08/28', availabilities[0][:date]
    assert_equal '2014/09/01', availabilities[4][:date]
    assert_equal ["9:30", "10:00", "10:30", "11:00"], availabilities[4][:slots]
    assert_equal '2014/09/03', availabilities[6][:date]
    assert_equal 7, availabilities.length
  end

  test "overlapping openings" do
    Event.create(
      kind: 'opening',
      starts_at: DateTime.parse("2014-08-04 09:30"),
      ends_at: DateTime.parse("2014-08-04 11:30"),
      weekly_recurring: true
    )
    Event.create(
      kind: 'opening',
      starts_at: DateTime.parse("2014-08-04 09:00"),
      ends_at: DateTime.parse("2014-08-04 12:30"),
      weekly_recurring: true
    )

    availabilities = Event.availabilities DateTime.parse("2014-08-28")
    assert_equal '2014/08/28', availabilities[0][:date]
    assert_equal '2014/09/01', availabilities[4][:date]
    assert_equal ["9:00", "9:30", "10:00", "10:30", "11:00", "11:30", "12:00"], availabilities[4][:slots]
    assert_equal '2014/09/03', availabilities[6][:date]
    assert_equal 7, availabilities.length
  end

  test "duplicated appointments" do
    Event.create(
      kind: 'opening',
      starts_at: DateTime.parse("2014-08-04 09:30"),
      ends_at: DateTime.parse("2014-08-04 11:30"),
      weekly_recurring: true
    )
    Event.create(
      kind: 'appointment',
      starts_at: DateTime.parse("2014-08-04 09:30"),
      ends_at: DateTime.parse("2014-08-04 10:00")
    )
    Event.create(
      kind: 'appointment',
      starts_at: DateTime.parse("2014-08-04 09:30"),
      ends_at: DateTime.parse("2014-08-04 10:00")
    )

    availabilities = Event.availabilities DateTime.parse("2014-08-04")
    assert_equal '2014/08/04', availabilities[0][:date]
    assert_equal ["10:00", "10:30", "11:00"], availabilities[0][:slots]
    assert_equal '2014/08/10', availabilities[6][:date]
    assert_equal 7, availabilities.length
  end

  test "shifting recurring openings" do
    Event.create(
      kind: 'opening',
      starts_at: DateTime.parse("2014-08-04 09:30"),
      ends_at: DateTime.parse("2014-08-04 11:30"),
      weekly_recurring: true
    )
    Event.create(
      kind: 'opening',
      starts_at: DateTime.parse("2014-07-04 09:30"),
      ends_at: DateTime.parse("2014-07-04 10:00"),
      weekly_recurring: true
    )

    availabilities = Event.availabilities DateTime.parse("2014-08-10")
    assert_equal 1, Event.where(
      kind: 'opening',
      weekly_recurring: true,
      starts_at: DateTime.parse("2014-08-11 09:30"),
      ends_at: DateTime.parse("2014-08-11 11:30")
    ).count

    assert_equal 1, Event.where(
      kind: 'opening',
      weekly_recurring: true,
      starts_at: DateTime.parse("2014-08-15 09:30"),
      ends_at: DateTime.parse("2014-08-15 10:00")
    ).count

    assert_equal 4, Event.count
  end
end
